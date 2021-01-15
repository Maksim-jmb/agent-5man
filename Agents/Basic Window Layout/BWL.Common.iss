objectdef bwlSettings
{
    variable filepath GlobalFolder="${LavishScript.HomeDirectory}"
    
    variable jsonvalue hotkeyToggleSwapOnActivate="$$>
    {
        "controls":"A",
        "modifiers":"shift+ctrl+alt"
    }
    <$$"
    variable jsonvalue hotkeyToggleFocusFollowsMouse="$$>
    {
        "controls":"M",
        "modifiers":"shift+ctrl+alt"
    }
    <$$"
    variable jsonvalue hotkeyFullscreen="$$>
    {
        "controls":"F",
        "modifiers":"shift+ctrl+alt"
    }
    <$$"
    variable jsonvalue hotkeyApplyWindowLayout="$$>
    {
        "controls":"W",
        "modifiers":"shift+ctrl+alt"
    }
    <$$"

    method Initialize()
    {
        This:Load
    }

    method Load()
    {
        variable jsonvalue jo
        if !${GlobalFolder.FileExists[\\Configuration\\Settings\\bwl.Settings.json]}
            return

        if !${jo:ParseFile["${GlobalFolder~}/Configuration/Settings/bwl.Settings.json"](exists)} || !${jo.Type.Equal[object]}
        {
            return
        }

        if ${jo.Has[swapOnHotkeyFocused]}
            SwapOnHotkeyFocused:Set["${jo.Get[swapOnHotkeyFocused]~}"]

        if ${jo.Has[swapOnActivate]}
            SwapOnActivate:Set["${jo.Get[swapOnActivate]~}"]

        if ${jo.Has[leaveHole]}
            LeaveHole:Set["${jo.Get[leaveHole]~}"]

        if ${jo.Has[focusFollowsMouse]}
            FocusFollowsMouse:Set["${jo.Get[focusFollowsMouse]~}"]

        if ${jo.Has[avoidTaskbar]}
            AvoidTaskbar:Set["${jo.Get[avoidTaskbar]~}"]

        if ${jo.Has[useLayout]}
            UseLayout:Set["${jo.Get[useLayout]~}"]

        if ${jo.Has[customLayout]}
            CustomLayout:SetValue["${jo.Get[customLayout].AsJSON~}"]

        if ${jo.Has[vfx3Layout]}
            Vfx3Layout:SetValue["${jo.Get[vfx3Layout].AsJSON~}"]

        if ${jo.Has[vfx4Layout]}
            Vfx4Layout:SetValue["${jo.Get[vfx4Layout].AsJSON~}"]

        if ${jo.Has[vfx5Layout]}
            Vfx5Layout:SetValue["${jo.Get[vfx5Layout].AsJSON~}"]

        variable jsonvalue joHotkeys
        joHotkeys:SetValue["${jo.Get[hotkeys].AsJSON~}"]

        if ${joHotkeys.Type.Equal[object]}
        {
            if ${joHotkeys.Has[toggleSwapOnActivate]}
                hotkeyToggleSwapOnActivate:SetValue["${joHotkeys.Get[toggleSwapOnActivate].AsJSON~}"]
            if ${joHotkeys.Has[toggleFocusFollowsMouse]}
                hotkeyToggleFocusFollowsMouse:SetValue["${joHotkeys.Get[toggleFocusFollowsMouse].AsJSON~}"]
            if ${joHotkeys.Has[fullscreen]}
                hotkeyFullscreen:SetValue["${joHotkeys.Get[fullscreen].AsJSON~}"]
            if ${joHotkeys.Has[applyWindowLayout]}
                hotkeyApplyWindowLayout:SetValue["${joHotkeys.Get[applyWindowLayout].AsJSON~}"]
        }
    }


    method Store()
    {
        variable jsonvalue jo
        jo:SetValue["${This.AsJSON~}"]
        jo:WriteFile["${GlobalFolder~}/Configuration/Settings/bwl.Settings.json",multiline]
    }

    member AsJSON()
    {
        variable jsonvalue jo
        jo:SetValue["$$>
        {
            "swapOnActivate":${SwapOnActivate.AsJSON~},
            "swapOnHotkeyFocused":${SwapOnHotkeyFocused.AsJSON~},
            "leaveHole":${LeaveHole.AsJSON~},
            "focusFollowsMouse":${FocusFollowsMouse.AsJSON~},
            "avoidTaskbar":${AvoidTaskbar.AsJSON~},
            "hotkeys":{
                "toggleSwapOnActivate":${hotkeyToggleSwapOnActivate.AsJSON~},
                "toggleFocusFollowsMouse":${hotkeyToggleFocusFollowsMouse.AsJSON~},
                "fullscreen":${hotkeyFullscreen.AsJSON~},
                "applyWindowLayout":${hotkeyApplyWindowLayout.AsJSON~},
            },
            "useLayout":${UseLayout.AsJSON~},
            "customLayout":${CustomLayout.AsJSON~}
            "vfx3Layout":${Vfx3Layout.AsJSON~}
            "vfx4Layout":${Vfx4Layout.AsJSON~}
            "vfx5Layout":${Vfx5Layout.AsJSON~}
        }
        <$$"]
        return "${jo.AsJSON~}"
    }

    variable bool SwapOnActivate=TRUE
    variable bool SwapOnHotkeyFocused=TRUE
    variable bool LeaveHole=TRUE
    variable bool FocusFollowsMouse=FALSE    
    variable bool AvoidTaskbar=FALSE
    variable string UseLayout="Horizontal"

    variable jsonvalue CustomLayout="$$>
    {
        "mainRegion":{
            "x":0,
            "y":0,
            "width":2560,
            "height":1080
        },
        "regions":[
            {
                "x":2560,
                "y":0,
                "width":640,
                "height":270
            },
            {
                "x":2560,
                "y":270,
                "width":640,
                "height":270
            },
            {
                "x":2560,
                "y":540,
                "width":640,
                "height":270
            },
            {
                "x":2560,
                "y":810,
                "width":640,
                "height":270
            },
            {
                "x":3200,
                "y":0,
                "width":640,
                "height":270
            },
            {
                "x":3200,
                "y":270,
                "width":640,
                "height":270
            },
            {
                "x":3200,
                "y":540,
                "width":640,
                "height":270
            },
            {
                "x":3200,
                "y":810,
                "width":640,
                "height":270
            },
            {
                "x":3840,
                "y":0,
                "width":640,
                "height":270
            },
            {
                "x":3840,
                "y":270,
                "width":640,
                "height":270
            },
            {
                "x":3840,
                "y":540,
                "width":640,
                "height":270
            },
            {
                "x":3840,
                "y":810,
                "width":640,
                "height":270
            }
        ]
    }
    <$$"
    
    variable jsonvalue Vfx3Layout="$$>
    {
        "mainRegion":{
            "x":0,
            "y":0,
            "width":2560,
            "height":1080
        },
        "regions":[
            {
                "x":0,
                "y":0,
                "width":640,
                "height":360
            },
            {
                "x":0,
                "y":360,
                "width":640,
                "height":360
            },
            {
                "x":0,
                "y":720,
                "width":640,
                "height":360
            }
        ]
    }
    <$$"

    variable jsonvalue Vfx4Layout="$$>
    {
        "mainRegion":{
            "x":0,
            "y":0,
            "width":2560,
            "height":1080
        },
        "regions":[
            {
                "x":0,
                "y":0,
                "width":640,
                "height":270
            },
            {
                "x":0,
                "y":270,
                "width":640,
                "height":270
            },
            {
                "x":0,
                "y":540,
                "width":640,
                "height":270
            },
            {
                "x":0,
                "y":810,
                "width":640,
                "height":270
            }
        ]
    }
    <$$"

    variable jsonvalue Vfx5Layout="$$>
    {
        "mainRegion":{
            "x":0,
            "y":0,
            "width":2560,
            "height":1080
        },
        "regions":[
            {
                "x":0,
                "y":0,
                "width":384,
                "height":270
            },
            {
                "x":384,
                "y":0,
                "width":384,
                "height":270
            },
            {
                "x":768,
                "y":0,
                "width":384,
                "height":270
            },
            {
                "x":1152,
                "y":0,
                "width":384,
                "height":270
            },
            {
                "x":1536,
                "y":0,
                "width":384,
                "height":270
            }
        ]
    }
    <$$"
}

; base class for window layouts
objectdef bwlLayout
{    
    method ApplyWindowLayout(bool setOtherSlots=TRUE)
    {
    }

    member ToText()
    {
        return "Unknown"   
    }
}

objectdef bwlHorizontalLayout
{
    member ToText()
    {
        return "Horizontal"   
    }

    method ApplyWindowLayout(bool setOtherSlots=TRUE)
    {
        variable jsonvalueref Slots="JMB.Slots"

        variable uint monitorWidth=${Display.Monitor.Width}
        variable uint monitorHeight=${Display.Monitor.Height}
        variable int monitorX=${Display.Monitor.Left}
        variable int monitorY=${Display.Monitor.Top}

        variable uint mainHeight
        variable uint numSmallRegions=${Slots.Used}
        variable uint mainWidth
        variable uint smallHeight
        variable uint smallWidth

        if ${BWLSession.Settings.AvoidTaskbar}
        {
            monitorX:Set["${Display.Monitor.MaximizeLeft}"]
            monitorY:Set["${Display.Monitor.MaximizeTop}"]
            monitorWidth:Set["${Display.Monitor.MaximizeWidth}"]
            monitorHeight:Set["${Display.Monitor.MaximizeHeight}"]
        }

        ; if there's only 1 window, just go full screen windowed
        if ${numSmallRegions}==1
        {
            WindowCharacteristics -pos -viewable ${monitorX},${monitorY} -size -viewable ${monitorWidth}x${monitorHeight} -frame none
            BWLSession.Applied:Set[1]
            return
        }

        if !${BWLSession.Settings.LeaveHole}
            numSmallRegions:Dec

        ; 2 windows is actually a 50/50 split screen and should probably handle differently..., pretend there's 3
        if ${numSmallRegions}==2
            numSmallRegions:Set[3]

        mainWidth:Set["${monitorWidth}"]
        mainHeight:Set["${monitorHeight}*${numSmallRegions}/(${numSmallRegions}+1)"]

        smallHeight:Set["${monitorHeight}-${mainHeight}"]
        smallWidth:Set["${monitorWidth}/${numSmallRegions}"]

        WindowCharacteristics -pos -viewable ${monitorX},${monitorY} -size -viewable ${mainWidth}x${mainHeight} -frame none
        BWLSession.Applied:Set[1]

        if !${setOtherSlots}
            return

        variable int useX
        variable uint numSlot

        variable uint slotID

        for (numSlot:Set[1] ; ${numSlot}<=${Slots.Used} ; numSlot:Inc)
        {
            slotID:Set["${Slots[${numSlot}].Get[id]~}"]
            if ${slotID}!=${JMB.Slot}
            {
                relay jmb${slotID} "WindowCharacteristics -stealth -pos -viewable ${useX},${mainHeight} -size -viewable ${smallWidth}x${smallHeight} -frame none"
                useX:Inc["${smallWidth}"]
            }
            else
            {
                if ${BWLSession.Settings.LeaveHole}
                    useX:Inc["${smallWidth}"]
            }
        }
    }
}

objectdef bwlVerticalLayout
{   
    member ToText()
    {
        return "Vertical"   
    }

    method ApplyWindowLayout(bool setOtherSlots=TRUE)
    {
        variable jsonvalueref Slots="JMB.Slots"

        variable uint monitorWidth=${Display.Monitor.Width}
        variable uint monitorHeight=${Display.Monitor.Height}
        variable int monitorX=${Display.Monitor.Left}
        variable int monitorY=${Display.Monitor.Top}

        variable uint mainHeight
        variable uint numSmallRegions=${Slots.Used}
        variable uint mainWidth
        variable uint smallHeight
        variable uint smallWidth

        if ${BWLSession.Settings.AvoidTaskbar}
        {
            monitorX:Set["${Display.Monitor.MaximizeLeft}"]
            monitorY:Set["${Display.Monitor.MaximizeTop}"]
            monitorWidth:Set["${Display.Monitor.MaximizeWidth}"]
            monitorHeight:Set["${Display.Monitor.MaximizeHeight}"]
        }

        ; if there's only 1 window, just go full screen windowed
        if ${numSmallRegions}==1
        {
            relay jmb1 WindowCharacteristics -pos -viewable ${monitorX},${monitorY} -size -viewable ${monitorWidth}x${monitorHeight} -frame none
            BWLSession.Applied:Set[1]
            return
        }

        if !${BWLSession.Settings.LeaveHole}
            numSmallRegions:Dec

        ; 2 windows is actually a 50/50 split screen and should probably handle differently..., pretend there's 3
        if ${numSmallRegions}==2
            numSmallRegions:Set[3]

        mainHeight:Set["${monitorHeight}"]
        mainWidth:Set["${monitorWidth}*${numSmallRegions}/(${numSmallRegions}+1)"]

        smallWidth:Set["${monitorWidth}-${mainWidth}"]
        smallHeight:Set["${monitorHeight}/${numSmallRegions}"]

        WindowCharacteristics -pos -viewable ${monitorX},${monitorY} -size -viewable ${mainWidth}x${mainHeight} -frame none
        BWLSession.Applied:Set[1]

        if !${setOtherSlots}
            return

        variable int useY
        variable uint numSlot

        variable uint slotID

        for (numSlot:Set[1] ; ${numSlot}<=${Slots.Used} ; numSlot:Inc)
        {
            slotID:Set["${Slots[${numSlot}].Get[id]~}"]
            if ${slotID}!=${JMB.Slot}
            {
                relay jmb${slotID} "WindowCharacteristics -stealth -pos -viewable ${mainWidth},${useY} -size -viewable ${smallWidth}x${smallHeight} -frame none"
                useY:Inc["${smallHeight}"]
            }
            else
            {
                if ${BWLSession.Settings.LeaveHole}
                    useY:Inc["${smallHeight}"]
            }
        }

    }
}

objectdef bwlCustomWindowLayout
{
    member ToText()
    {
        return "Custom"   
    }

    method ApplyWindowLayout(bool setOtherSlots=TRUE)
    {
         variable jsonvalueref Slots="JMB.Slots"

        variable uint numSmallRegions=${Slots.Used}

        variable bool SwapOnActivate=TRUE
        variable bool SwapOnHotkeyFocused=TRUE
        variable bool LeaveHole=TRUE
        variable bool FocusFollowsMouse=FALSE

        variable uint mainHeight=${BWLSession.Settings.CustomLayout.Get[mainRegion,height]}
        variable uint mainWidth=${BWLSession.Settings.CustomLayout.Get[mainRegion,width]}
        variable int mainX=${BWLSession.Settings.CustomLayout.Get[mainRegion,x]}
        variable int mainY=${BWLSession.Settings.CustomLayout.Get[mainRegion,y]}


        WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none
        BWLSession.Applied:Set[1]

        if !${BWLSession.Settings.LeaveHole}
            numSmallRegions:Dec

        if !${setOtherSlots} || !${numSmallRegions}
            return

        variable uint numSlot
        variable uint numSmallRegion=1

        variable uint slotID

        variable int smallX
        variable int smallY
        variable uint smallWidth
        variable uint smallHeight

        for (numSlot:Set[1] ; ${numSlot}<=${Slots.Used} ; numSlot:Inc)
        {
            slotID:Set["${Slots[${numSlot}].Get[id]~}"]
            if ${slotID}!=${JMB.Slot}
            {
                smallX:Set["${BWLSession.Settings.CustomLayout.Get[regions,${numSmallRegion},x]~}"]
                smallY:Set["${BWLSession.Settings.CustomLayout.Get[regions,${numSmallRegion},y]~}"]
                smallWidth:Set["${BWLSession.Settings.CustomLayout.Get[regions,${numSmallRegion},width]~}"]
                smallHeight:Set["${BWLSession.Settings.CustomLayout.Get[regions,${numSmallRegion},height]~}"]

                if ${smallWidth} && ${smallHeight}
                {
                    if ${smallWidth}==${mainWidth} && ${smallHeight}==${mainHeight}
                        relay jmb${slotID} "WindowCharacteristics -pos -viewable ${smallX},${smallY} -size -viewable ${smallWidth}x${smallHeight} -frame none "
                    else
                        relay jmb${slotID} "WindowCharacteristics -stealth -pos -viewable ${smallX},${smallY} -size -viewable ${smallWidth}x${smallHeight} -frame none "
                }

                numSmallRegion:Inc
            }
            else
            {
                if ${BWLSession.Settings.LeaveHole}
                   numSmallRegion:Inc
            }
        }
    }
}

objectdef bwlCustomRRWindowLayout
{
    member ToText()
    {
        return "CustomRR"   
    }

    method ApplyWindowLayout(bool setOtherSlots=TRUE)
    {
        variable jsonvalueref Slots="JMB.Slots"

        variable bool SwapOnActivate=FALSE
        variable bool SwapOnHotkeyFocused=FALSE
        variable bool LeaveHole=FALSE
        variable bool FocusFollowsMouse=TRUE 

        variable uint monitorWidth=${Display.Monitor.Width}
        variable uint monitorHeight=${Display.Monitor.Height}
        variable int monitorX=${Display.Monitor.Left}
        variable int monitorY=${Display.Monitor.Top}

        variable uint mainHeight
        variable uint numSmallRegions=${Slots.Used}
        variable uint mainWidth
        variable uint smallHeight
        variable uint smallWidth
        variable uint vfxWidth

        if ${BWLSession.Settings.AvoidTaskbar}
        {
            monitorX:Set["${Display.Monitor.MaximizeLeft}"]
            monitorY:Set["${Display.Monitor.MaximizeTop}"]
            monitorWidth:Set["${Display.Monitor.MaximizeWidth}"]
            monitorHeight:Set["${Display.Monitor.MaximizeHeight}"]
        }


        ; if there's only 1 window, just go full screen windowed
        if ${numSmallRegions}==1
        {
            WindowCharacteristics -stealth -pos -viewable ${monitorX},${monitorY} -size -viewable ${monitorWidth}x${monitorHeight} -frame none
            BWLSession.Applied:Set[1]
            return
        }

        if !${BWLSession.Settings.LeaveHole}
            numSmallRegions:Dec

        ; 2 windows is actually a 50/50 split screen and should probably handle differently..., pretend there's 3
        if ${numSmallRegions}==2
            numSmallRegions:Set[3]

        mainHeight:Set["${monitorHeight}"]
        mainWidth:Set["${monitorWidth}"]

        smallWidth:Set["${mainWidth}/(${numSmallRegions}-1)"]
        smallHeight:Set["${monitorHeight}/(${numSmallRegions}-1)"]

        vfxWidth:Set["${mainWidth}+${smallWidth}"]

        if !${setOtherSlots}
            return

        variable int useY
        variable uint numSlot
        variable uint num=(${Slots.Used}-1)
        variable uint slotID

        for (numSlot:Set[1] ; ${numSlot}<=${num} ; numSlot:Inc)
        {
            slotID:Set["${Slots[${numSlot}].Get[id]~}"]
            if ${slotID}!=${JMB.Slot}
            {
                relay jmb${slotID} "WindowCharacteristics -stealth -pos -viewable ${mainWidth},${useY} -size -viewable ${smallWidth}x${smallHeight} -frame none"
                useY:Inc["${smallHeight}"]
            }
            else
            {
                if ${BWLSession.Settings.LeaveHole}
                    useY:Inc["${smallHeight}"]
            }
        }
        relay jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable ${vfxWidth},0 -size -viewable ${smallWidth}x${mainHeight} -frame none"
    }
}


objectdef bwlVfx3WindowLayout
{
    member ToText()
    {
        return "Vfx3"   
    }

    method ApplyWindowLayout(bool setOtherSlots=TRUE)
    {
        variable jsonvalueref Slots="JMB.Slots"

        variable bool SwapOnActivate=FALSE
        variable bool SwapOnHotkeyFocused=FALSE
        variable bool LeaveHole=FALSE
        variable bool FocusFollowsMouse=FALSE 

        variable uint numSmallRegions=${Slots.Used}

        variable uint mainWidth=${BWLSession.Settings.Vfx3Layout.Get[mainRegion,width]}
        variable uint mainHeight=${BWLSession.Settings.Vfx3Layout.Get[mainRegion,height]}
        variable int mainX=${BWLSession.Settings.Vfx3Layout.Get[mainRegion,x]}
        variable int mainY=${BWLSession.Settings.Vfx3Layout.Get[mainRegion,y]}
        variable uint numSlot

        for (numSlot:Set[1] ; ${numSlot}<=${Slots.Used} ; numSlot:Inc)
        {
            slotID:Set["${Slots[${numSlot}].Get[id]~}"]
            if ${slotID}!=${JMB.Slot}
            {
                WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none 
            }
        }

        variable uint num
        num:Set[${JMB.Slots.Used}]
        num:Dec
        
        if ${num}<=3
            relay jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable 2560,0 -size -viewable 640x1080 -frame none "
            relay ~jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none "
        if ${num}>=4 && ${num}<=6
            relay jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable 2560,0 -size -viewable 1280x1080 -frame none "
            relay ~jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none "
        if ${num}>=7
            relay jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable 2560,0 -size -viewable 1920x1080 -frame none "
            relay ~jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none "
        
        BWLSession.Applied:Set[1]
    }
}

objectdef bwlVfx4WindowLayout
{
    member ToText()
    {
        return "Vfx4"   
    }

    method ApplyWindowLayout(bool setOtherSlots=TRUE)
    {
        variable jsonvalueref Slots="JMB.Slots"

        variable bool SwapOnActivate=FALSE
        variable bool SwapOnHotkeyFocused=FALSE
        variable bool LeaveHole=FALSE
        variable bool FocusFollowsMouse=FALSE 

        variable uint numSmallRegions=${Slots.Used}

        variable uint mainWidth=${BWLSession.Settings.Vfx4Layout.Get[mainRegion,width]}
        variable uint mainHeight=${BWLSession.Settings.Vfx4Layout.Get[mainRegion,height]}
        variable int mainX=${BWLSession.Settings.Vfx4Layout.Get[mainRegion,x]}
        variable int mainY=${BWLSession.Settings.Vfx4Layout.Get[mainRegion,y]}
        variable uint numSlot

        for (numSlot:Set[1] ; ${numSlot}<=${Slots.Used} ; numSlot:Inc)
        {
            slotID:Set["${Slots[${numSlot}].Get[id]~}"]
            if ${slotID}!=${JMB.Slot}
            {
                WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none 
            }
        }
        
        variable uint num
        num:Set[${JMB.Slots.Used}]
        num:Dec
        
        if ${num}<=4
            relay jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable 2560,0 -size -viewable 640x1080 -frame none "
            relay ~jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none"
        if ${num}>=5 && ${num}<=8
            relay jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable 2560,0 -size -viewable 1280x1080 -frame none "
            relay ~jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none"
        if ${num}>=9
            relay jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable 2560,0 -size -viewable 1920x1080 -frame none "
            relay ~jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none"

        BWLSession.Applied:Set[1]
    }
}

objectdef bwlVfx5WindowLayout
{
    member ToText()
    {
        return "Vfx5"   
    }

    method ApplyWindowLayout(bool setOtherSlots=TRUE)
    {
        variable jsonvalueref Slots="JMB.Slots"

        variable bool SwapOnActivate=FALSE
        variable bool SwapOnHotkeyFocused=FALSE
        variable bool LeaveHole=FALSE
        variable bool FocusFollowsMouse=FALSE 

        variable uint numSmallRegions=${Slots.Used}

        variable uint mainWidth=${BWLSession.Settings.Vfx5Layout.Get[mainRegion,width]}
        variable uint mainHeight=${BWLSession.Settings.Vfx5Layout.Get[mainRegion,height]}
        variable int mainX=${BWLSession.Settings.Vfx5Layout.Get[mainRegion,x]}
        variable int mainY=${BWLSession.Settings.Vfx5Layout.Get[mainRegion,y]}
        variable uint numSlot

        for (numSlot:Set[1] ; ${numSlot}<=${Slots.Used} ; numSlot:Inc)
        {
            slotID:Set["${Slots[${numSlot}].Get[id]~}"]
            if ${slotID}!=${JMB.Slot}
            {
                WindowCharacteristics "WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none"
            }
        }
        
        variable uint num
        num:Set[${JMB.Slots.Used}]
        num:Dec
        
        if ${num}<=5
            relay jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable 2560,0 -size -viewable 1920x270 -frame none "
            relay ~jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none "
        if ${num}>=6 && ${num}<=10
            relay jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable 2560,0 -size -viewable 1920x540 -frame none "
            relay ~jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none "
        if ${num}>=11 && ${num}<=15
            relay jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable 2560,0 -size -viewable 1920x810 -frame none "
            relay ~jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none "
        if ${num}>=16
            relay jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable 2560,0 -size -viewable 1920x1080 -frame none "
            relay ~jmb${JMB.Slots.Used} "WindowCharacteristics -pos -viewable ${mainX},${mainY} -size -viewable ${mainWidth}x${mainHeight} -frame none "

        BWLSession.Applied:Set[1]
    }   
}

variable(global) bwlSettings BWLSettings