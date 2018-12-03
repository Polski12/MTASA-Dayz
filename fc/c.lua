if not getResourceFromName("freecam") then return end

addCommandHandler("freecam", function()
	if exports.freecam:isFreecamEnabled() then
    x,y,z = getCameraMatrix ()
    setElementPosition(localPlayer,x,y,z)
		exports.freecam:setFreecamDisabled()
		setCameraTarget(localPlayer,localPlayer)
	else
		exports.freecam:setFreecamEnabled()
	end
end)