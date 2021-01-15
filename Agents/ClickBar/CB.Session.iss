#include "CB.Common.iss"

objectdef cbSession
{
    variable filepath GlobalFolder="${LavishScript.HomeDirectory}"
    variable cbSettings Settings
    variable bool Enabled=0

    method Initialize()
    {
        LGUI2:LoadPackageFile[xCB.Session.lgui2package.json]        
        LGUI2:LoadPackageFile[xPF.Session.lgui2package.json]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[xCB.Session.lgui2package.json]
        LGUI2:UnloadPackageFile[xPF.Session.lgui2package.json]
    }

    method WindowSwap(uint slot)
    {
        ; if ${JMB.Slot}==${slot}
        ;     return

        uplink focus jmb${slot}
    }

    method CustomRRSwitch()
    {
        relay ${Session} BWLSession.CustomRRLayout:ApplyWindowLayout
    }

    method ShowPartyFrames()
    {
        variable uint NumAdded
        variable uint num=1
        
        for (NumAdded:Set[1] ; ${NumAdded}<=${JMB.Slots.Used:Dec} ; NumAdded:Inc)
        {
            relay jmb${num} LGUI2.Element[jmb${num}.partyframes]:SetVisibility[visible]
            num:Inc
        }
        relay party LGUI2.Element[actionbars]:SetVisibility[visible] 
    }
    
    ; always use partyframe buttons for window swapping - easier to just leave them on
    method HidePartyFrames()
    {
        ; relay all LGUI2.Element[jmb1.partyframes]:SetVisibility[hidden]
        relay all LGUI2.Element[actionbars]:SetVisibility[hidden]
    }
}

variable(global) cbSession CBSession

function main()
{
    while 1
        waitframe
}