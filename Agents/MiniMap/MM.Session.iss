objectdef mmSession
{
    variable uint RefreshedSlots

    method Initialize()
    {
        LavishScript:RegisterEvent[OnSessionRenamed]
        Event[OnSessionRenamed]:AttachAtom[This:OnMM]

        LGUI2:LoadPackageFile[xMM.Session.lgui2package.json]
        This:SetSourceEnabled[1]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[xMM.Session.lgui2package.json]
        
        ; explicitly destroy dynamically loaded elements
        This:SetSourceEnabled[0]
    }

    method OnMM()
    {
        if ${JMB.Slots.Used}!=${RefreshedSlots}
            This:RefreshSlots
    }

     method RefreshSlots()
     {
         variable uint numSlots=2
         variable uint Slot

         RefreshedSlots:Set[${numSlots}]

         LGUI2.Element[mm.viewerpanel]:ClearChildren
         
         for ( Slot:Set[1] ; ${Slot}<=${numSlots} ; Slot:Inc )
         {
            This:AddSlot[${Slot}]
         }
     }

    method AddSlot(uint Slot)
    {
        if ${Slot}==${JMB.Slot}
            return

        variable jsonvalue jo

        variable string focusCommand="MMSession:Focus[${Slot}]"
        jo:SetValue["$$>
        {
            "type":"button",
            "borderThickness":0,
            "content":{
                "jsonTemplate": "mm.viewer",
                "feedName": "mm${Slot}"
                "acceptsKeyboardFocus":false,
                "acceptsMouseFocus":false,
                "keyboardFocus": false,
                "mouseFocus": false
            },
            "eventHandlers":{
                "onMouse2Press":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
            }
        }
        <$$"]

        LGUI2.Element[mm.viewerpanel]:AddChild["${jo.AsJSON~}"]
    }

    method Focus(uint Slot)
    {
        uplink focus "jmb${Slot}"
        relay "jmb${Slot}" "Event[OnHotkeyFocused]:Execute"
        relay party "Event[OnMM]:Execute"
    }

    method SetSourceEnabled(bool newValue)
    {
        if ${newValue}
        {
            LGUI2.Element[mm.source]:Destroy

            variable jsonvalue jo
            jo:SetValue["${LGUI2.Template[mm.source].AsJSON~}"]

            jo:Set["feedName","\"mm${JMB.Slot}\""]

            LGUI2:LoadJSON["${jo.AsJSON~}"]
        }
        else
        {
            LGUI2.Element[mm.source]:Destroy
        }
    }
}

variable(global) mmSession MMSession

function main()
{
    while 1
        waitframe
}
