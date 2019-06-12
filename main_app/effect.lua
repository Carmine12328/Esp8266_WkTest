local display = require "tm1640"

local efx = {}
local dataset = {}

dataset["full"] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff}
dataset["void"] = {0, 0, 0, 0, 0, 0, 0, 0}
dataset["onda"] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff}


function efx.wave_effect()
    tmr.create():alarm(7000, tmr.ALARM_AUTO, function()
        tmr.create():alarm(50, tmr.ALARM_SINGLE, function()
          display.brightness(7)
          display.write(dataset["full"])
        end)
        tmr.create():alarm(1500, tmr.ALARM_SINGLE, function()
          local lum = 7
          for cont = 1,8 do 
            for x = 1,7 do 
              tmr.delay(20000)
              dataset["onda"][cont] = 0
              display.write(dataset["onda"])
            end
            display.brightness(lum)
            lum = lum-1
          end
        end)
        tmr.create():alarm(1500, tmr.ALARM_SINGLE, function()
          display.brightness(7)
          display.write(dataset["full"])
        end)
        tmr.create():alarm(5000, tmr.ALARM_SINGLE, function()
          for cont = 1,8 do
            for x = 1,7 do 
              tmr.delay(20000)
              dataset["onda"][cont] = 0xff
              display.write(dataset["onda"])
            end
            display.brightness(cont)
          end
        end)
      end)
end

function efx.on_off_effect()
    tmr.create():alarm(3000, tmr.ALARM_SINGLE, function()
        tmr.create():alarm(50, tmr.ALARM_SINGLE, function()
        display.write(dataset["full"])
        end)
        tmr.create():alarm(1500, tmr.ALARM_SINGLE, function()
        display.write(dataset["void"])
        end)
    end)
end

return efx