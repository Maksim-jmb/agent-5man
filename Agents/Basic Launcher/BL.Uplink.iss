#include "BL.Common.iss"

objectdef blUplink
{
    variable filepath GlobalFolder="${LavishScript.HomeDirectory}"
    
    variable blSettings Settings
    variable string Layout
    variable jsonvalue Games="[]"
    variable jsonvalue Agents="[]"
    variable jsonvalue Layouts="[]"
    variable jsonvalue Teams="[]"
    variable bool ReplaceSlots=TRUE
    
    method Initialize()
    {
        LavishScript:RegisterEvent[GamesChanged]
        LavishScript:RegisterEvent[SettingsChanged]
        LavishScript:RegisterEvent[LayoutChanged]
        Event[GamesChanged]:AttachAtom[This:RefreshGames]
        Event[SettingsChanged]:AttachAtom[This:RefreshSettings]
        Event[LayoutChanged]:AttachAtom[This:RefreshSettings]

        Settings:Store
        This:RefreshGames
        This:RefreshSettings

        LGUI2:LoadPackageFile[xBL.Uplink.lgui2package.json]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[xBL.Uplink.lgui2package.json]
    }

    method InstallCharacter(uint Slot)
    {
        variable string UseGameProfile="${Settings.UseGame~} Default Profile"

        variable jsonvalue jo
        jo:SetValue["$$>
        {
            "id":${Slot},
            "display_name":"Generic Character",
            "game":${Settings.UseGame.AsJSON~},
            "gameProfile":${UseGameProfile.AsJSON~}
            "virtualFiles":[
                {
                    "pattern":"*/Config.WTF",
                    "replacement":"{1}/Config.Generic.JMB${Slot}.WTF"
                },
                {
                    "pattern":"Software/Blizzard Entertainment/World of Warcraft/Client/\*",
                    "replacement":"Software/Blizzard Entertainment/World of Warcraft/Client-JMB${Slot}/{1}"
                }
            ]
        }
        <$$"]
        JMB:AddCharacter["${jo.AsJSON~}"]
    }

    method InstalldxNothing(uint Slot)
    {
        variable string UsedxNProfile="${Settings.UsedxNothing~} Default Profile"
        variable jsonvalue jo
		jo:SetValue["$$>
		{
			"id":${Slot},
			"display_name":"Generic Character",
			"game":${Settings.UsedxNothing.AsJSON~},
			"gameProfile":${UsedxNProfile.AsJSON~}
			"virtualFiles":[
				{
				}
			]
		}
		<$$"]
		JMB:AddCharacter["${jo.AsJSON~}"]
    }

    method LaunchWowClient()
    {
        LGUI2.Element[bl.launchSlots]:PushTextBinding

        if ${ReplaceSlots}
        {
            JMB.Slots:ForEach["kill jmb\${ForEach.Value.Get[id]}"]
            JMB:ClearSlots
        }
        variable uint Slot
        variable uint NumAdded
        for (NumAdded:Set[1] ; ${NumAdded}<=${Settings.UseLaunchSlots} ; NumAdded:Inc)
        {
            Slot:Set["${JMB.AddSlot.ID}"]
            This:InstallCharacter[${Slot}]
            JMB.Slot[${Slot}]:SetCharacter[${Slot}]
            JMB.Slot[${Slot}]:Launch
        }
    }

    method LaunchdxNothing()
    {
        variable uint Slot
        Slot:Set["${JMB.AddSlot.ID}"]
        This:InstalldxNothing[${Slot}]
        JMB.Slot[${Slot}]:SetCharacter[${Slot}]
        JMB.Slot[${Slot}]:Launch
    }

    method Relaunch(uint numSlot)
    {
        if !${JMB.Slot[${numSlot}].ProcessID}
            JMB.Slot[${numSlot}]:Launch
            VfxSession:ClearVfxViews
    }
    
    method RelaunchMissingSlots()
    {
        JMB.Slots:ForEach["This:Relaunch[\${ForEach.Value.Get[id]}]"]
        TimedCommand 40 BLUplink:JoinRelayGroups
        TimedCommand 50 BWLSession:ApplyWindowLayout
        TimedCommand 70 MMSession:Initialize
    }

    variable int setlayout
    variable uint vfx1=1
    variable uint vfx3=3
    variable uint vfx4=4
    variable uint vfx5=5

    method SetupLaunch()
    {
        switch ${BWLUplink.Settings.UseLayout}
        {    
            case Horizontal
                setlayout:Set[1]
                break
            case Vertical
                setlayout:Set[1]
                break
            case Custom
                setlayout:Set[1]
                break
            case Vfx3
                setlayout:Set[3]
                break
            case Vfx4
                setlayout:Set[4]
                break
            case Vfx5
                setlayout:Set[5]
                break
        }
        This:Launch
    }

    method Launch()
    {
        if (${Settings.UseLaunchSlots}<=6) && ${setlayout}!=${vfx3} && ${setlayout}!=${vfx4} && ${setlayout}!=${vfx5}
        {
            BLUplink:LaunchWowClient
            TimedCommand 60 BLUplink:JoinRelayGroups
            TimedCommand 90 BWLUplink:ApplyWindowLayout
        }
        if (${Settings.UseLaunchSlots}<=6) && (${setlayout}==${vfx3} || ${setlayout}==${vfx4} || ${setlayout}==${vfx5})
        {
            BLUplink:LaunchWowClient
            TimedCommand 20 BLUplink:LaunchdxNothing
            TimedCommand 60 BLUplink:JoinRelayGroups
            TimedCommand 90 BWLUplink:ApplyWindowLayout
        }
        if (${Settings.UseLaunchSlots}>=7) && ${setlayout}!=${vfx3} && ${setlayout}!=${vfx4} && ${setlayout}!=${vfx5}
        {   
            BLUplink:LaunchWowClient
            TimedCommand 100 BLUplink:JoinRelayGroups
            TimedCommand 120 BWLUplink:ApplyWindowLayout
        }
        if (${Settings.UseLaunchSlots}>=7) && (${setlayout}==${vfx3} || ${setlayout}==${vfx4} || ${setlayout}==${vfx5})
        {
            BLUplink:LaunchWowClient
            BLUplink:LaunchdxNothing
            TimedCommand 100 BLUplink:JoinRelayGroups
            TimedCommand 120 BWLUplink:ApplyWindowLayout
        }
    }

    method JoinRelayGroups()
    {
        variable uint NumAdded
        for (NumAdded:Set[0] ; ${NumAdded}<=${Settings.UseLaunchSlots} ; NumAdded:Inc)
        {
            TimedCommand 20 relay jmb${NumAdded} RGSession:JoinRelayGroup${NumAdded}
            TimedCommand 30 relay jmb${NumAdded} "WindowText JMB${NumAdded}"
        }
        if ( ${setlayout}==${vfx3} || ${setlayout}==${vfx4} || ${setlayout}==${vfx5} )
        {
            variable uint Num
            Num:Set[${Settings.UseLaunchSlots}]
            Num:Inc
            relay jmb${Num} WindowText VFX${Num}
            relay jmb${Num} LGUI2.Element["toggles"]:Destroy 
            relay jmb${Num} LGUI2.Element["actionbars"]:Destroy
            relay jmb${Num} LGUI2.Element["jmb1.partyframes"]:Destroy
        }
        relay all CBSession:HidePartyFrames
    }

    method KilldxNothing()
    {
        JMB:RemoveSlot[${JMB.Slots.Used}]
    }

    method SetGame(string newValue)
    {
        if ${newValue.Equal["${Settings.UseGame~}"]}
            return
        Settings.UseGame:Set["${newValue~}"]
        Settings:Store
    }

    method SetLaunchSlots(uint newValue)
    {
        if ${newValue.Equal["${Settings.UseLaunchSlots}"]}
            return
        Settings.UseLaunchSlots:Set[${newValue}]
        Settings:Store
    }

     method SetUseLayout(string newValue~)
    {
         if ${newValue.Equal["${BWLSettings.UseLayout~}"]}
            return
        Settings.UseLayout:Set["${newValue~}"]
        Settings:Store
        BWLSettings:Initialize
        BWLSession:UpdateCurrentLayout
    }

    method GenerateItemView_Game()
	{
		; build an itemview lgui2element json
		variable jsonvalue joListBoxItem
		joListBoxItem:SetValue["${LGUI2.Template["BLUplink.gameView"].AsJSON~}"]
        		
		Context:SetView["${joListBoxItem.AsJSON~}"]
	}

    method GenerateItemView_Agents()
	{
		; build an itemview lgui2element json
		variable jsonvalue jaListBoxItem
		jaListBoxItem:SetValue["${LGUI2.Template["BLUplink.agentsView"].AsJSON~}"]
        		
		Context:SetView["${jaListBoxItem.AsJSON~}"]
	}

    method GenerateItemView_Layouts()
	{
		; build an itemview lgui2element json
		variable jsonvalue joListBoxItem
		joListBoxItem:SetValue["${LGUI2.Template["BLUplink.layoutsView"].AsJSON~}"]
        		
		Context:SetView["${joListBoxItem.AsJSON~}"]
	}

     method GenerateItemView_Teams()
	{
		; build an itemview lgui2element json
		variable jsonvalue joListBoxItem
		joListBoxItem:SetValue["${LGUI2.Template["BLUplink.teamsView"].AsJSON~}"]
        		
		Context:SetView["${joListBoxItem.AsJSON~}"]
	}

    method RefreshGames()
    {
        variable jsonvalue jo="${JMB.GameConfiguration.AsJSON~}"
        jo:Erase["_set_guid"]

        variable jsonvalue jaKeys
        jaKeys:SetValue["${jo.Keys.AsJSON~}"]
        jo:SetValue["[]"]

        variable uint i
        for (i:Set[1] ; ${i}<=${jaKeys.Used} ; i:Inc)
        {
            jo:Add["$$>
            {
                "display_name":${jaKeys[${i}].AsJSON~}
            }
            <$$"]
        }
    
        Games:SetValue["${jo.AsJSON~}"]
        Games:Erase[1]
        LGUI2.Element[BLUplink.events]:FireEventHandler[onGamesUpdated]
    }

    method RefreshSettings()
    {
        Layout:Set["${Settings.UseLayout~}"]
        Agents:SetValue["${Settings.UseAgents~}"]
        Layouts:SetValue["${Settings.UseLayouts~}"]
        Clickbars:SetValue["${Settings.UseClickbars~}"]
        Teams:SetValue["${Settings.UseTeams~}"]
        BWLSession.Settings.UseLayout:SetValue["${Settings.UseLayout~}"]

        LGUI2.Element[BLUplink.events]:FireEventHandler[onSettingsUpdated]
        Settings:Store
    }

    method ApplyWindowLayout()
    {
        if ${setlayout}==${vfx1}
            relay jmb1 BWLSession:ApplyWindowLayout
        if ${setlayout}==${vfx3} || ${setlayout}==${vfx4} || ${setlayout}==${vfx5}
            relay all BWLSession:ApplyWindowLayout
    }
}

variable(global) blUplink BLUplink

function main()
{
    while 1
        waitframe
}
