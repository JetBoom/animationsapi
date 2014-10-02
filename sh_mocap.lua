--Mocap

include("mocap_controller.lua")

local Animations = {}

function GetMocapAnimations()
	return Animations
end

function RegisterMocapAnimation(sName, tInfo)
	local numframes = 0

	for bonename, bonedata in pairs(tInfo.FrameData) do
		numframes = math.max(numframes, #bonedata)
	end

	tInfo.NumFrames = numframes
	Animations[sName] = tInfo
end

RegisterMocapAnimation("mocaptest", {
	FrameData = {
		["ValveBiped.Bip01_Spine"] = {
			{
				Vector(0, 0, 30),
				Angle(0, 0, 0)
			},
			{
				Vector(0, 0, 40),
				Angle(0, 0, 0)
			},
			{
				Vector(0, 0, 50),
				Angle(0, 0, 0)
			}
		}
	}
})
