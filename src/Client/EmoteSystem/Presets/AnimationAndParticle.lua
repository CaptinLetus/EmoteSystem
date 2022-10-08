local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Util = require(script.Parent.Parent:WaitForChild("Util"))
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)

local AnimationAndParticle = {}
AnimationAndParticle.__index = AnimationAndParticle

function AnimationAndParticle.new(character, animation, particles)
	local self = setmetatable({}, AnimationAndParticle)

	self._character = character
	self._animation = animation
	self._particles = particles

	self._trove = Trove.new()
	self._stopped = false

	self.Stopped = Signal.new()

	self._trove:Add(self.Stopped)

	return self
end

function AnimationAndParticle:play()
	local humanoid, animator = Util.getHumanoidAndAnimatorFromCharacter(self._character)
	local head: BasePart = self._character:FindFirstChild("Head")

	if not humanoid or not animator then
		return
	end

	if not head then
		warn("Tried to play animation on character without head")
		return
	end

	local particles = self._particles:Clone()

	particles.Parent = head

	self._trove:Add(function()
		Util.stopParticles(particles)
	end)

	if self._character == Players.LocalPlayer.Character then
		self:playLocalPlayer()
	end

	self._trove:Connect(humanoid.Running, function()
		self:stop()
	end)
end

function AnimationAndParticle:playLocalPlayer()
	self._animationTrack = Util.playAnimation(self._character, self._animation)
	
	self._trove:Connect(self._animationTrack.Stopped, function()
		self:stop()
	end)
end

function AnimationAndParticle:stop()
	if self._stopped then
		return
	end

	self._stopped = true

	self.Stopped:Fire()

	self._trove:Destroy()

	if self._character == Players.LocalPlayer.Character then
		self:stopLocalPlayer()
	end
end

function AnimationAndParticle:stopLocalPlayer()
	self._animationTrack:Stop()
end

return AnimationAndParticle
