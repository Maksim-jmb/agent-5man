#include "CB.Common.iss"

objectdef cbUplink
{
    variable cbSettings Settings
    method Initialize()
    {
    }
    method Shutdown()
    {
    }
    
    method OnActivate()
    {
    }
}

variable(global) cbUplink CBUplink

function main()
{
    while 1
        waitframe
}