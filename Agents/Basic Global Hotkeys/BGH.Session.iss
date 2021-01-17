objectdef bghSession
{
    variable filepath GlobalFolder="${LavishScript.HomeDirectory}"
    variable jsonvalue GlobalHotkeys="[]"
    variable jsonvalue GlobalShiftkeys="[]"
    variable bool HotkeyInstalled
    variable bool Enabled=1
    

    method Initialize()
    {
        LavishScript:RegisterEvent[On3DReset]
        LavishScript:RegisterEvent[OnMouseEnter]
        LavishScript:RegisterEvent[OnHotkeyFocused]
        LavishScript:RegisterEvent[OnShiftkeyFocused]
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
        GlobalShiftkeys:SetValue["${jo.Get["globalShiftkeys"].AsJSON~}"]
        if !${GlobalHotkeys.Type.Equal[array]}
            GlobalHotkeys:SetValue["[]"]
        if !${GlobalShiftkeys.Type.Equal[array]}
            GlobalShiftkeys:SetValue["[]"]
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
        globalbind "shift" "${GlobalShiftkeys.Get[${Slot}]~}" "BGHSession:OnGlobalShiftkey"
    }

    method UninstallHotkey()
    {
        if !${HotkeyInstalled}
            return
        HotkeyInstalled:Set[0]
        globalbind -delete "focus"
        globalbind -delete "shift"
    }

    method On3DReset()
    {
        This:InstallHotkey
    }

    method OnGlobalHotkey()
    {
        windowvisibility foreground
        ; FlushQueued
        Event[OnHotkeyFocused]:Execute
        This:ApplyFocusFollowMouse
    }

    method OnGlobalShiftkey()
    {
        windowvisibility foreground
        ; FlushQueued
        relay party VfxSession:VfxButton
        Event[OnHotkeyFocused]:Execute
        This:ApplyFocusFollowMouse
    }

    method ApplyFocusFollowMouse()
    {
        relay all "BWLSession:FocusSession[\"${Session~}\"]"
        Event[OnMouseEnter]:Execute
    }
}

variable(global) bghSession BGHSession

function main()
{
    while 1
        waitframe
}