local display = require "tm1640"
local net = require "netmodule"

local mqtt_status = false
local wifi_connect = false
local dev_ID = "TEST" -- HOSTNAME
local dataset = {}
local mqtt_callbacks = {}

dataset["smile"] = { 0x3C, 0x42, 0xA5, 0x81, 0xA5, 0x99, 0x42, 0x3C}
dataset["cross"] = { 0x81, 0x42, 0x24, 0x18, 0x18, 0x24, 0x42, 0x81}

print("=== Main ===")
print("- devId: "..dev_ID)
display.init(7, 5)
display.brightness(5)
display.write(dataset["cross"])

function reverseBits(a)
    local b = 0x80
    local o = 0
    for i=0,7 do
        if (bit.band(a, bit.lshift(1, i)) ~= 0) then
            o = bit.bor(o, b)
        end
        b = bit.rshift(b, 1)
    end
    return o
end

function cmdfunc(client, data)
    print("Cmd: "..data)
end

function showfunc(client, data)
    local d = {}
    if (data) then
        for i=1,#data,2 do
            local v = tonumber(data:sub(i, i+1), 16)
            table.insert(d, reverseBits(v))
        end
        if (d) then
            display.write(d)
        end
    end
end

mqtt_callbacks["/radiolog/cmd"] = cmdfunc
mqtt_callbacks["/radiolog/show"] = showfunc

function dispatch(client, topic, data)
    print("rev: " .. topic .. " " .. data)
    if data~=nil and mqtt_callbacks[topic] then
        mqtt_callbacks[topic](client, data)
    end
end

function foo(T)
    print("Wifi connection is ready! "..T.IP)
    display.write(dataset["smile"])
    wifi_connect = true
    m = mqtt.Client("radiolog", 60)

    m:on("message", dispatch)
    m:on("connect", function(client)
        mqtt_status = true
        print ("connected")
    end)

    m:on("offline", function(client)
        print("offline")
    end)

    m:on("overflow", function(client, topic, data)
        print(topic .. " partial overflowed message: " .. data )
    end)

    m:connect('mqtt.asterix.cloud', 1883, 0, function(client)
    print("connected")
    dev_ID = "Node-"..string.sub(string.gsub(wifi.sta.getmac(), ":",""), 7)

    client:publish("/radiolog/"..dev_ID.."/status", "hello", 0, 0)
    client:subscribe("/radiolog/show", 0, function(client)
        print("subscribe success")
    end)

    tmr.alarm(0,10000, 1, function()
        m:publish("/radiolog/"..dev_ID.."/status", tmr.time(), 0, 0)
    end)

    end,
    function(client, reason)
        print("failed reason: " .. reason)
    end)
end

net.init(nil, foo, nil)


-- tmr.alarm(0,1000, 1, function()
--   print("Go to sleep..")
--   node.dsleep(60000000)
-- end)

-- local measures = {}

-- ds18b20.setup(OW_PIN)
-- i2c.setup(0, SDA, SCL, i2c.SLOW)
-- bmp085.setup()

-- tmr.alarm(0,2000, 1, function()
    -- ds18b20.read(
    --     function(ind, rom, res, temp, tdec, par)
    --         measures["temp"..ind] = temp
    --     end,{})

    -- local status, temp, humi, temp_dec, humi_dec = dht.read(DHT_PIN)
    -- if status == dht.OK then
    --    measures["humidity"]  = humi
    --    measures["humidityd"]  = humi_dec
    --    measures["temphumi"]  = temp
    --    measures["temphumid"]  = temp_dec
    -- else
    --     print(string.format("DHT error [%d] [%d]",  dht.ERROR_CHECKSUM, dht.ERROR_TIMEOUT))
    -- end

    -- -- measures["pressure"]  = bmp085.pressure()
    -- -- measures["temppress"]  = bmp085.temperature()

    -- for k,v in pairs(measures) do
    --     print(k,v)
    -- end
    -- print("------------")

-- end)


-- local m_dist = {}
-- function dispatch(m,t,pl)
--     if pl~=nil and m_dis[t] then
--         m_dis[t](m,pl)
--     end
-- end
--

--while true do
--    for k,v in pairs(measures) do
--        print(k,v)
--    end
--    print("------------")
--    tmr.delay(2000000)
--end


-- local m_dis = {}
-- local mqtt_status = false

--local cfg = require 'cfg'
-- local lib = require 'lib'


