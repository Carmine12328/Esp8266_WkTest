local button = { }

local btn1 = 0
local btn2 = 6

print("==== Main ====")

gpio.mode(btn1,gpio.INPUT)
gpio.mode(btn2,gpio.INPUT)

local btn_val = 1
local btn_val2 = 1

function get_buttonstate()
    tmr.create():alarm(300, tmr.ALARM_AUTO, function()
        if gpio.read(btn1) == 0 then 
            tmr.create():alarm(50, tmr.ALARM_SINGLE, function()
                if(gpio.read(btn1) == 0) then 
                    btn_val = 0
                end
            end)
        else
            btn_val = 1
        end

        if gpio.read(btn2) == 0 then 
            tmr.create():alarm(50, tmr.ALARM_SINGLE, function()
                if(gpio.read(btn2) == 0) then 
                    btn_val2 = 0
                end
            end)
        else
            btn_val2 = 1
        end

        print(btn_val)
        print(btn_val2)
        
    end)
end