local wifi_connect = false
local dev_ID = "TEST" -- HOSTNAME


print("===== Main =====")
print("- devId: "..dev_ID)

local M = {
    hostname = "",
    ip = ""
}

dofile("credentials.lua")

wifi_got_ip_event = function(T)
    print("Wifi connection is ready! IP address is "..T.IP)
end

wifi_connect_event = function(T)
    if disconnect_ct ~= nil then disconnect_ct = nul end
end

wifi_disconnect_event = function(T)
    if T.reason == wifi.eventmon.reason.ASSOC_LEAVE then 
        return
    end

    local total_tries = 75
    print("\nWiFi connection to AP("..T.SSID..") has failed!")
    for key,val in pairs(wifi.eventmon.reason) do
        if val == T.reason then
            print("Disconnect reason "..val.."("..key..")")
            break
        end
    end
    if disconnect_ct == nil then
        disconnect_ct = 1
    else
        disconnect_ct = disconnect_ct +1 
    end
    if disconnect_ct < total_tries then
        print("Retrying connection....(attempt"..(disconnect_ct+1).."of"..total_tries..")")
    else
        wifi.sta.disconnect()
        print("Aborting connection to AP!")
        disconnect_ct = nil
    end
end
