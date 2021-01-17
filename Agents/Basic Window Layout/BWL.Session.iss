#include "BWL.Common.iss"

objectdef bwlSession
{
    variable taskmanager TaskManager=${LMAC.NewTaskManager["bwlSession"]}
    variable bwlSettings Settings

    variable bwlHorizontalLayout HorizontalLayout
    variable bwlVerticalLayout VerticalLayout
    variable bwlCustomWindowLayout CustomLayout
    variable bwlCustomRRWindowLayout CustomRRLayout
    variable bwlVfx3WindowLayout Vfx3Layout
    variable bwlVfx4WindowLayout Vfx4Layout
    variable bwlVfx5WindowLayout Vfx5Layout
    variable weakref CurrentLayout

    variable bool Applied

    method Initialize()
    {
        This:UpdateCurrentLayout

        LavishScript:RegisterEvent[On Activate]
        LavishScript:RegisterEvent[OnWindowStateChanging]
		LavishScript:RegisterEvent[OnMouseEnter]
		LavishScript:RegisterEvent[OnMouseExit]
        LavishScript:RegisterEvent[OnHotkeyFocused]
        This:EnableHotkeys
        ; FocusClick eat
    }

    method Shutdown()
    {
        This:DisableHotkeys
        TaskManager:Destroy
    }

    method UpdateCurrentLayout()
    {
        switch ${Settings.UseLayout}
        {
            default
            case Horizontal
                CurrentLayout:SetReference["HorizontalLayout"]
                break
            case Vertical
                CurrentLayout:SetReference["VerticalLayout"]
                break
            case Custom
                CurrentLayout:SetReference["CustomLayout"]
                break
            case CustomRR
                CurrentLayout:SetReference["CustomRRLayout"]
                break
            case Vfx3
                CurrentLayout:SetReference["Vfx3Layout"]
                break
            case Vfx4
                CurrentLayout:SetReference["Vfx4Layout"]
                break
            case Vfx5
                CurrentLayout:SetReference["Vfx5Layout"]
                break
        }
    }

    method SelectLayout(string newValue)
    {
        Settings.UseLayout:Set["${newValue~}"]
        This:UpdateCurrentLayout
    }

    method ApplyWindowLayout(bool setOtherSlots=TRUE)
    {
        CurrentLayout:ApplyWindowLayout[${setOtherSlots}]
        relay party LGUI2.Element["vfx3.window"]:Destroy
    }

    method OnActivate()
    {
        if ${Settings.SwapOnActivate} && !${Settings.FocusFollowsMouse}
            This:ApplyWindowLayout
        else
        {
            if !${Applied}
                This:ApplyWindowLayout[FALSE]
        }
    }

    method OnHotkeyFocused()
    {
        ; if it would have been handled by SwapOnActivate, don't do it again here
        if (!${Settings.SwapOnActivate} || ${Settings.FocusFollowsMouse}) && ${Settings.SwapOnHotkeyFocused}
        {
            This:ApplyWindowLayout
        }
        else
        {
            if !${Applied}
                This:ApplyWindowLayout[FALSE]
        }
    }

    method OnWindowStateChanging(string change)
    {
      ;  echo OnWindowStateChanging ${change~}
    }

    method ToggleFocusFollowsMouse()
    {
        echo ToggleFocusFollowsMouse
        uplink "BWLUplink:ToggleFocusFollowsMouse"
    }

    method ToggleSwapOnActivate()
    {
        echo ToggleSwapOnActivate
        uplink "BWLUplink:ToggleSwapOnActivate"
    }
    method ToggleLeaveHole()
    {
        uplink "BWLUplink:ToggleLeaveHole"
    }
    method ToggleAvoidTaskbar()
    {
        uplink "BWLUplink:ToggleAvoidTaskbar"
    }

    method Fullscreen()
    {
        echo Fullscreen
        variable uint monitorWidth=${Display.Monitor.Width}
        variable uint monitorHeight=${Display.Monitor.Height}
        variable int monitorX=${Display.Monitor.Left}
        variable int monitorY=${Display.Monitor.Top}
        
        WindowCharacteristics -pos -viewable ${monitorX},${monitorY} -size -viewable ${monitorWidth}x${monitorHeight} -frame none        
    }

    method EnableHotkeys()
    {
        variable jsonvalue joBinding
        if ${Settings.hotkeyFullscreen.Type.Equal[object]} && ${Settings.hotkeyFullscreen.Has[controls]}
        {
            joBinding:SetValue["${Settings.hotkeyFullscreen.AsJSON~}"]
            joBinding:Set[name,"\"bwl.fullscreen\""]
            joBinding:Set[eventHandler,"$$>
            {
                "type":"task",
                "taskManager":"bwlSession",
                "task":{
                    "type":"ls1.code",
                    "start":"BWLSession:Fullscreen"
                }
            }
            <$$"]

            LGUI2:AddBinding["${joBinding.AsJSON~}"]
        }

        if ${Settings.hotkeyApplyWindowLayout.Type.Equal[object]} && ${Settings.hotkeyApplyWindowLayout.Has[controls]}
        {
            joBinding:SetValue["${Settings.hotkeyApplyWindowLayout.AsJSON~}"]
            joBinding:Set[name,"\"bwl.applyWindowLayout\""]
            joBinding:Set[eventHandler,"$$>
            {
                "type":"task",
                "taskManager":"bwlSession",
                "task":{
                    "type":"ls1.code",
                    "start":"BWLSession:ApplyWindowLayout"
                }
            }
            <$$"]

            LGUI2:AddBinding["${joBinding.AsJSON~}"]
        }

        if ${Settings.hotkeyToggleFocusFollowsMouse.Type.Equal[object]} && ${Settings.hotkeyToggleFocusFollowsMouse.Has[controls]}
        {
            joBinding:SetValue["${Settings.hotkeyToggleFocusFollowsMouse.AsJSON~}"]
            joBinding:Set[name,"\"bwl.toggleFocusFollowsMouse\""]
            joBinding:Set[eventHandler,"$$>
            {
                "type":"task",
                "taskManager":"bwlSession",
                "task":{
                    "type":"ls1.code",
                    "start":"BWLSession:ToggleFocusFollowsMouse"
                }
            }
            <$$"]

            LGUI2:AddBinding["${joBinding.AsJSON~}"]
        }

        if ${Settings.hotkeyToggleSwapOnActivate.Type.Equal[object]} && ${Settings.hotkeyToggleSwapOnActivate.Has[controls]}
        {
            joBinding:SetValue["${Settings.hotkeyToggleSwapOnActivate.AsJSON~}"]
            joBinding:Set[name,"\"bwl.toggleSwapOnActivate\""]
            joBinding:Set[eventHandler,"$$>
             {
                "type":"task",
                "taskManager":"bwlSession",
                "task":{
                    "type":"ls1.code",
                    "start":"BWLSession:ToggleSwapOnActivate"
                }
            }
            <$$"]

            LGUI2:AddBinding["${joBinding.AsJSON~}"]
        }
    }

    method DisableHotkeys()
    {
        LGUI2:RemoveBinding["bwl.fullscreen"]
        LGUI2:RemoveBinding["bwl.applyWindowLayout"]
        LGUI2:RemoveBinding["bwl.toggleFocusFollowsMouse"]
        LGUI2:RemoveBinding["bwl.toggleSwapOnActivate"]
    }

    method ApplyFocusFollowMouse()
    {
        if !${Settings.FocusFollowsMouse}
            return

        if ${Display.Window.IsForeground}
            return
        relay all "BWLSession:FocusSession[\"${Session~}\"]"
    }
     
    method FocusSession(string name)
    {
        if !${Display.Window.IsForeground}
            return
        uplink focus "${name~}"
    }

    method OnMouseEnter()
    {
        This:ApplyFocusFollowMouse
        Event[OnMouseEnter]:Execute
    }

    method OnMouseExit()
    {
    }
}

variable(global) bwlSession BWLSession

function main()
{
    while 1
    {
        waitframe
    }
}