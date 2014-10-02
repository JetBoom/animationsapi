local ENT = {}

ENT.Type = "anim"

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)

	if SERVER then
		self:SetStartTime(CurTime())
	end
end

function ENT:OnRemove()
	if SERVER then
		local parent = self:GetParent()
		if parent:IsValid() and parent:Alive() then
			local rag = parent:GetRagdollEntity()
			if IsValid(rag) then rag:Remove() end
		end
	end
end

function ENT:Think()
	if SERVER then return end

	local animdata = self:GetAnimationData()
	if not animdata then return end
	local parent = self:GetParent()
	if not parent:IsValid() then return end
	local rag = parent:GetRagdollEntity()
	if not IsValid(rag) then return end


	local delta = CurTime() - self:GetStartTime()
	local frame = math.Clamp(delta, 1, animdata.NumFrames)

	for iBoneID, tBoneInfo in pairs(animdata.FrameData) do
		local tFrameData = tBoneInfo[frame]
		if not tFrameData then continue end

		if type(iBoneID) ~= "number" then
			iBoneID = rag:LookupBone(iBoneID)
		end
		if not iBoneID then continue end

		local iPhysID = rag:TranslateBoneToPhysBone(iBoneID)
		if not iPhysID then continue end

		local phys = rag:GetPhysicsObjectNum(iPhysID)
		if IsValid(phys) then
			phys:SetPos(parent:LocalToWorld(tFrameData[1]))
			phys:SetAngles(parent:LocalToWorldAngles(tFrameData[2]))
		end
	end


	self:NextThink(CurTime())
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:SetStartTime(m)
	self:SetDTFloat(0, m)
end

function ENT:GetStartTime()
	return self:GetDTFloat(0)
end

function ENT:SetAnimationName(m)
	self:SetDTString(0, m)
end

function ENT:GetAnimationName()
	return self:GetDTString(0)
end

function ENT:GetAnimationData()
	return GetMocapAnimations()[self:GetAnimationName()]
end

if CLIENT then
function ENT:Draw()
end
end

scripted_ents.Register(ENT, "mocap_controller")
