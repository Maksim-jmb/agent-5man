objectdef bghSession
{
    variable filepath GlobalFolder="${LavishScript.HomeDirectory}"
    variable jsonvalue GlobalHotkeys="[]"
    variable jsonvalue GlobalHealkeys="[]"
    ; variable string HealsKey="Shift+F2"
    variable bool HotkeyInstalled
    variable bool Enabled=1
    

    method Initialize()
    {
        LavishScript:RegisterEvent[On3DReset]
        LavishScript:RegisterEvent[OnHotkeyFocused]
        ; LavishScript:RegisterEvent[HealsWindow]
        Event[On3DReset]:AttachAtom[This:On3DReset]

        This:LoadSettings
    }

    method Shutdown()
    {
        This:Disable
    }

    method LoadSettings()
    {
        variable jsonvalue jo

        if !${jo:ParseFile["${GlobalFolder~}/Configuration/Settings/bgh.Settings.json"](exists)} || !${jo.Type.Equal[object]}
        {
            return
        }

        GlobalHotkeys:SetValue["${jo.Get["globalHotkeys"].AsJSON~}"]
        GlobalHealkeys:SetValue["${jo.Get["globalHealkeys"].AsJSON~}"]
        ; if ${jo.Has[healsHotkey]}
        ;     HealsKey:Set["${jo.Get["healsHotkey"]~}"]

        if !${GlobalHotkeys.Type.Equal[array]}
            GlobalHotkeys:SetValue["[]"]
        if !${GlobalHealkeys.Type.Equal[array]}
            GlobalHealkeys:SetValue["[]"]
    }

    method Enable()
    {
        if ${Enabled}
            return

        Enabled:Set[1]
        This:InstallHotkey
    }

    method Disable()
    {
        if !${Enabled}
            return
        Enabled:Set[0]
        This:UninstallHotkey
    }

    method InstallHotkey()
    {
        variable string useTarget="foreground"
        variable uint Slot=${JMB.Slot}
        if !${Slot} || ${Slot}>${GlobalHotkeys.Used}
            return

        if ${HotkeyInstalled}
            return
        
        HotkeyInstalled:Set[1]
        
        globalbind "focus" "${GlobalHotkeys.Get[${Slot}]~}" "BGHSession:OnGlobalHotkey"
        globalbind "heal" "${GlobalHealkeys.Get[${Slot}]~}" "BGHSession:OnGlobalHealkey"

        ; if ${Slot}==1
        ; {
        ;     if ${HealsKey.NotNULLOrEmpty}
        ;         globalbind "heals" "${HealsKey~}" "relay ${useTarget~} BGHSession:HealsWindow"
        ; }
    }

    method UninstallHotkey()
    {
        if !${HotkeyInstalled}
            return
        HotkeyInstalled:Set[0]
        globalbind -delete "focus"
        globalbind -delete "heal"
        ; if ${Slot}==1
        ; {
        ;     if ${HealsKey.NotNULLOrEmpty}
        ;         globalbind -delete "heals"
        ; }
    }

    method On3DReset()
    {
        This:InstallHotkey
    }

    method OnGlobalHotkey()
    {
        windowvisibility foreground
        Event[OnHotkeyFocused]:Execute
    }

    method OnGlobalHealkey()
    {
        windowvisibility foreground
        relay party VfxSession:VfxButton
        Event[OnHotkeyFocused]:Execute
    }

}

variable(global) bghSession BGHSession

function main()
{
    while 1
        waitframe
}
