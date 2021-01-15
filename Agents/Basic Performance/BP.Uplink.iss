objectdef bpUplink
{
    method Initialize()
    {
        maxfps -fg -calculate 60
        maxfps -bg -calculate 60
        Proc -all

        LGUI2:LoadPackageFile[xBP.Uplink.lgui2Package.json]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[xBP.Uplink.lgui2Package.json]
    }

    method HideUI()
    {
        LGUI2.Element[bp.window]:SetVisibility[hidden]
    }
}

variable(global) bpUplink BPUplink

function main()
{
    while 1
        waitframe
}