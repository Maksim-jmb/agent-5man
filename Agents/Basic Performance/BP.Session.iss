objectdef bpSession
{
    method Initialize()
    {
        maxfps -fg -calculate 60
        maxfps -bg -calculate 60
        ProcLock on
        Proc -all

        LGUI2:LoadPackageFile[xBP.Session.lgui2Package.json]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[xBP.Session.lgui2Package.json]
    }
}

variable(global) bpSession BPSession

function main()
{
    while 1
        waitframe
}