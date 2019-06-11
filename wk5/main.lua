local mqtt_status = false
local mqtt_callback = {}
local dev_ID = "TEST"
 
print("====== Main =====")

mqtt_callback["/radiolog/cmd"] = cmdfunc
mqtt_callback["/radiolog/show"] = showfunc

function dispatch(client,topic,data)
    if data ~= nil and mqtt_callback[topic] then
        mqtt_callback[topic](client, data)
    end
end
function send_mqtt_message()    
    m = mqtt.Client("radiolog",60)
    m:on("message",dispatch)

    m:on("connect",function(client)
        mqtt_status = true
        print("connected")
    end)

    m:on("offline",function(client)
        print("offline")
    end)

    m:connect('mqtt.asterix.cloud',1883,0,function(client)
    print("connected")
    client:publish("/radiolog/"..dev_ID.."/status","hello",0,0)
    client:subscribe("/radiolog/show",0,function(client)
        print("subscribe success")
    end)
    end)
end 