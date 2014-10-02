if CLIENT or GetLuaAnimations ~= nil then return end

include("sh_boneanimlib.lua")
AddCSLuaFile("cl_boneanimlib.lua")
AddCSLuaFile("sh_boneanimlib.lua")
AddCSLuaFile("cl_animeditor.lua")

hook.Add("Initialize", "BAL_Initialize", function()
	util.AddNetworkString("bal_reset")
	util.AddNetworkString("bal_set")
	util.AddNetworkString("bal_stop")
	util.AddNetworkString("bal_stopgroup")
	util.AddNetworkString("bal_stopall")
end)

-- These are unreliable. All Lua animations should be set on both the client and server (predicted).
local meta = FindMetaTable("Entity")
if not meta then return end

local function ResetMoCap(pl, sAnimation)
	local anim = GetLuaAnimations()[sAnimation]
	if anim and anim.Type == TYPE_MOCAP then
		pl:CreateRagdoll()
	end
end

function meta:ResetLuaAnimation(sAnimation, fTime, fPower, fTimeScale)
	net.Start("bal_reset")
		net.WriteEntity(self)
		net.WriteString(sAnimation)
		net.WriteFloat(fTime or -1)
		net.WriteFloat(fPower or -1)
		net.WriteFloat(fTimeScale or -1)
	net.Broadcast()

	ResetMoCap(self, sAnimation)
end

function meta:SetLuaAnimation(sAnimation, fTime, fPower, fTimeScale)
	net.Start("bal_set")
		net.WriteEntity(self)
		net.WriteString(sAnimation)
		net.WriteFloat(fTime or -1)
		net.WriteFloat(fPower or -1)
		net.WriteFloat(fTimeScale or -1)
	net.Broadcast()

	ResetMoCap(self, sAnimation)
end

function meta:StopLuaAnimation(sAnimation, fTime)
	net.Start("bal_stop")
		net.WriteEntity(self)
		net.WriteString(sAnimation)
		net.WriteFloat(fTime or 0)
	net.Broadcast()
end

function meta:StopLuaAnimationGroup(sAnimation, fTime)
	net.Start("bal_stopgroup")
		net.WriteEntity(self)
		net.WriteString(sAnimation)
		net.WriteFloat(fTime or 0)
	net.Broadcast()
end

function meta:StopAllLuaAnimations(fTime)
	net.Start("bal_stopall")
		net.WriteEntity(self)
		net.WriteFloat(fTime or 0)
	net.Broadcast()
end
