#include "BL.Common.iss"

objectdef rgSession
{
    variable blSettings rgSettings

    method Initialize()
    {    

    }

    method JoinRelayGroup1()
    {
        uplink relaygroup -join party
        uplink relaygroup -join tank
        uplink relaygroup -join melee
        uplink relaygroup -join monk
    }
    method JoinRelayGroup2()
    {
        uplink relaygroup -join party
        uplink relaygroup -join heal
        uplink relaygroup -join ranged
        uplink relaygroup -join priest
    }
    method JoinRelayGroup3()
    {
        uplink relaygroup -join party
        uplink relaygroup -join dps
        uplink relaygroup -join ranged
        uplink relaygroup -join mage
    }
    method JoinRelayGroup4()
    {
        uplink relaygroup -join party
        uplink relaygroup -join dps
        uplink relaygroup -join ranged
        uplink relaygroup -join warlock
    }
    method JoinRelayGroup5()
    {
        uplink relaygroup -join party
        uplink relaygroup -join dps
        uplink relaygroup -join melee
        uplink relaygroup -join warrior
    }

}

variable(global) rgSession RGSession

function main()
{
    
    while 1
        waitframe
}
    

