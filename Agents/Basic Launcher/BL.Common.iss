objectdef blSettings
{
   variable filepath GlobalFolder="${LavishScript.HomeDirectory}"
    
    variable uint UseLaunchSlots=3
    variable uint UseLaunchdxNSlots=1
    variable string UseGame
    variable string UsedxNothing
    variable string UseLayout
    variable string UseAgents
    variable string UseLayouts
    variable string UseTeams

    method Initialize()
    {    
        This:Load
        This:LoadSettings
        
    }

     method Load()
    {
        variable jsonvalue jo

        if !${GlobalFolder.FileExists[\\Configuration\\Settings\\bl.Settings.json]}
            return

        if !${jo:ParseFile["${GlobalFolder~}/Configuration/Settings/bl.Settings.json"](exists)} || !${jo.Type.Equal[object]}
        {
            return
        }
        if ${jo.Has[launchSlots]}
            UseLaunchSlots:Set["${jo.Get[launchSlots]~}"]
        if ${jo.Has[launchdxNSlots]}
            UseLaunchdxNSlots:Set["${jo.Get[launchdxNSlots]~}"]
        if ${jo.Has[useGame]}
            UseGame:Set["${jo.Get[useGame]~}"]
        if ${jo.Has[usedxNothing]}
            UsedxNothing:Set["${jo.Get[usedxNothing]~}"]
        if ${jo.Has[uselayout]}
            UseLayout:Set["${jo.Get[uselayout]~}"]
        if ${jo.Has[agents]}
            UseAgents:Set["${jo.Get[agents]~}"]
        if ${jo.Has[layouts]}
            UseLayouts:Set["${jo.Get[layouts]~}"]
        if ${jo.Has[teams]}
            UseTeams:Set["${jo.Get[teams]~}"]
    }

    method LoadSettings()
    {
        variable jsonvalue jo

        if !${GlobalFolder.FileExists[\\Configuration\\Settings\\settings.json]}
        {
            jo:SetValue["$$>
            {
                "launchSlots":3,
                "LaunchdxNSlots":1,
                "useGame":"WoW Retail",
                "usedxNothing":"dxNothing",
                "uselayout":"Horizontal",
                "agents": [
                    {
                    "name":"Basic Global Hotkeys"
                    },
                    {
                    "name":"Basic Performance"
                    },
                    {
                    "name":"Basic Round-Robin"
                    },
                    {
                    "name":"Basic Window Layout"
                    },
                    {
                    "name":"Reload"
                    }
                ],
                "layouts": [
                    {
                    "layout":"Horizontal"
                    },
                    {
                    "layout":"Vertical"
                    },
                    {
                    "layout":"Custom"
                    },
                    {
                    "layout":"Vfx3"
                    },
                    {
                    "layout":"Vfx4"
                    },
                    {
                    "layout":"Vfx5"
                    }
                ],
                "teams": [
                    {
                    "team":"Team 1"
                    },
                    {
                    "team":"Team 2"
                    },
                    {
                    "team":"Team 3"
                    },
                    {
                    "team":"Team 4"
                    },
                    {
                    "team":"Team 5"
                    }
                ]
            }
            <$$"]
            jo:WriteFile["${GlobalFolder~}/Configuration/Settings/settings.json",multiline]
            This:ResetGlobalSettings
        }

    }

    method Store()
    {
        variable jsonvalue jo
        jo:SetValue["${This.AsJSON~}"]
        jo:WriteFile["${GlobalFolder~}/Configuration/Settings/bl.Settings.json",multiline]
    }

    member AsJSON()
    {
        variable jsonvalue jo
        jo:SetValue["$$>
        {
            "launchSlots":${UseLaunchSlots.AsJSON~},
            "launchdxNSlots":${UseLaunchdxNSlots.AsJSON~},
            "useGame":${UseGame.AsJSON~},
            "usedxNothing":${UsedxNothing.AsJSON~},
            "uselayout":${UseLayout.AsJSON~},
            "agents":${UseAgents},
            "layouts":${UseLayouts},
            "teams":${UseTeams}
        }
        <$$"]
        return "${jo.AsJSON~}"
    }

    method ResetGlobalSettings()
    {
        variable jsonvalue jo
        if ${GlobalFolder.FileExists[jmb.GlobalSettings.json]}
        {
            jo:SetValue["$$>
            {
                "$schema":"http://www.lavishsoft.com/schema/jmb/jmb.json#/globalSettings",
            }
            <$$"]
            jo:WriteFile["${GlobalFolder~}/jmb.GlobalSettings.json",multiline]
        }
    }

    method ViewAgents(string newValue)
    {
        switch ${newValue}
        {
            case Basic Global Hotkeys
                LGUI2.Element[bwl.window]:SetVisibility[hidden]
                LGUI2.Element[brr.window]:SetVisibility[hidden]
                LGUI2.Element[bp.window]:SetVisibility[hidden]
                LGUI2.Element[bgh.window]:SetVisibility[visible]
                break
            case Basic Performance
                LGUI2.Element[bwl.window]:SetVisibility[hidden]
                LGUI2.Element[brr.window]:SetVisibility[hidden]
                LGUI2.Element[bgh.window]:SetVisibility[hidden]
                LGUI2.Element[bp.window]:SetVisibility[visible]
                break
            case Basic Round-Robin
                LGUI2.Element[bwl.window]:SetVisibility[hidden]
                LGUI2.Element[bp.window]:SetVisibility[hidden]
                LGUI2.Element[bgh.window]:SetVisibility[hidden]
                LGUI2.Element[brr.window]:SetVisibility[visible]
                break
            case Basic Window Layout
                LGUI2.Element[brr.window]:SetVisibility[hidden]
                LGUI2.Element[bp.window]:SetVisibility[hidden]
                LGUI2.Element[bgh.window]:SetVisibility[hidden]
                LGUI2.Element[bwl.window]:SetVisibility[visible]
                break
            default
            case Reload
                BGHUplink:Initialize
                BPUplink:Initialize
                BRRUplink:Initialize
                BWLUplink:Initialize
                LGUI2.Element[bgh.window]:SetVisibility[hidden]
                LGUI2.Element[bp.window]:SetVisibility[hidden]
                LGUI2.Element[brr.window]:SetVisibility[hidden]
                LGUI2.Element[bwl.window]:SetVisibility[hidden]
                break
        }
    }

    method HideUI()
    {
        LGUI2.Element[brr.window]:SetVisibility[hidden]
    }

    method AllFullScreen()
    {
        relay all "WindowCharacteristics -pos -viewable ${Display.Monitor.Left},${Display.Monitor.Top} -size -viewable ${Display.Monitor.Width}x${Display.Monitor.Height} -frame none"
    }

    method ShowConsoles()
    {
        relay all "LGUI2.Element[consoleWindow]:SetVisibility[Visible]"
    }

    method HideConsoles()
    {
        relay all "LGUI2.Element[consoleWindow]:SetVisibility[Hidden]"
    }

    method HideAgent()
    {
        LGUI2.Element[bgh.window]:SetVisibility[hidden]
        LGUI2.Element[bp.window]:SetVisibility[hidden]
        LGUI2.Element[brr.window]:SetVisibility[hidden]
        LGUI2.Element[bwl.window]:SetVisibility[hidden]
    }

    method CloseAll()
    {
        relay all exit
    }


    method SetTeam(string newValue)
    {
        switch ${newValue}
        {
        }
    }
}