-- GroundSpeedLimit script from Asta, if any question, find me here: https://discord.gg/ZUZdMzQ
local bluePlanes = mist.makeUnitTable({'[blue][plane]'})
local zone_names = {'zone1','zone2','zone3','zone4'} -- List of the zone are you need to check the groundspeed of players
local units = nil
local unit = nil
local speedVec = nil
local speed = nil

local function speedLimitCheck()
	timer.scheduleFunction(speedLimitCheck, {}, timer.getTime() + 5) -- Checking every 5 seconds
	units = mist.getUnitsInZones(bluePlanes, zone_names, 'cylinder')
	for i = 1, #units do 
		if (Unit.getPlayerName(units[i]) ~= nil and units[i]:getLife() > 0 ) then -- Checking if player and if alive
			unit = units[i]
			if (unit:inAir() == false) then
				speedVec = unit:getVelocity() -- Getting 3vec in m/s
				speed =  math.floor((math.sqrt(speedVec.x^2 + speedVec.y^2 + speedVec.z^2))*1.94384) -- Precise speed in kt
				if (speed > 40) then -- Over 40kt, player is spectorised!
					trigger.action.outTextForUnit(unit:getID() , "" .. unit:getPlayerName() ..", you were not allowed to takeoff from taxiways/parkings!\nYou have been ejected to spectator!", 10)
					unit:destroy()
					net.send_chat(""..unit:getPlayerName().." has been spectorized!", true)
					net.send_chat("Remember, no takeoff/landing from taxiways/parkings!", true)
				elseif (speed > 25) then -- Over 25kt, player is warned by a message visible by him only
					trigger.action.outTextForUnit(unit:getID() , "" .. unit:getPlayerName() ..", you are too fast ("..speed.."kt) you are not allowed to takeoff/landing from taxiways/parkings, accelerate and you will be punished!", 5)
				end
			end
		end
	end
end
speedLimitCheck()