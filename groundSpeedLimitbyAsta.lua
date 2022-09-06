-- GroundSpeedLimit script from Asta, if any question, find me here: https://discord.gg/ZUZdMzQ
local bluePlanes = mist.makeUnitTable({'[blue][plane]'})
local zone_names = {'zone1','zone2'} -- List of the zones you need to check the groundspeed of players
local units = nil
local unit = nil
local speedVec = nil
local speed = nil
local onlinePlayers = nil

local function speedLimitCheck()
	timer.scheduleFunction(speedLimitCheck, {}, timer.getTime() + 5) -- Checking every 5 seconds
	units = mist.getUnitsInZones(bluePlanes, zone_names)
	for i = 1, #units do 
		if (Unit.getPlayerName(units[i]) ~= nil and units[i]:getLife() > 0 ) then -- Checking if player and if alive
			unit = units[i]
			if (unit:inAir() == false) then
				speedVec = unit:getVelocity() -- Getting 3vec in m/s
				speed =  math.floor((math.sqrt(speedVec.x^2 + speedVec.y^2 + speedVec.z^2))*1.94384) -- Precise speed in kt
				if (speed > 40) then -- Over 40kt, player is spectorised!
					onlinePlayers = net.get_player_list()
					for j = 1, #onlinePlayers do						
						if(net.get_player_info(onlinePlayers[j], "name")==unit:getPlayerName()) then
							trigger.action.outTextForUnit(unit:getID() , "" .. unit:getPlayerName() ..", you were not allowed to takeoff from taxiways/parkings!\nYou have been ejected to spectator!", 10)
							net.force_player_slot(onlinePlayers[j], 0, '')
							--net.kick(onlinePlayers[j],"Dear "..unit:getPlayerName()..", you have been kicked because you takeoff/landing on parking/taxiway. Please use runways for that.")
							net.send_chat(""..unit:getPlayerName().." has been spectorized!(no takeoff/landing from taxi/parking!)", true)
						end
					end
				elseif (speed > 25) then -- Over 25kt, player is warned by a message visible by him only
					trigger.action.outTextForUnit(unit:getID() , "" .. unit:getPlayerName() ..", you are too fast ("..speed.."kt) you are not allowed to takeoff/landing from taxiways/parkings, accelerate and you will be punished!", 5)
				end
			end
		end
	end
end
speedLimitCheck()