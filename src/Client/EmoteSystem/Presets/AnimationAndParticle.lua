local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Util = require(script.Parent.Parent:WaitForChild("Util"))
local Controllers = script.Parent.Parent:WaitForChild("Controllers")
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
local AnimationController = require(Controllers:WaitForChild("Animation"))
local ParticleController = require(Controllers:WaitForChild("Particle"))

local AnimationAndParticle = {}
AnimationAndParticle.__index = AnimationAndParticle

function AnimationAndParticle.new(character, animation, particles)
	local self = setmetatable({}, AnimationAndParticle)

	self._character = character
	self._stopped = false

	self._trove = Trove.new()
	self.Stopped = Signal.new()

	self._animationController = AnimationController.new(character, animation, self._trove)
	self._particleController = ParticleController.new(character, particles)

	self._animationController.Stopped:Connect(function()
		self:stop()
	end)

	self._trove:Add(self.Stopped)

	return self
end

function AnimationAndParticle:play()
	local humanoid = Util.getHumanoidAndAnimatorFromCharacter(self._character)
	local head: BasePart = self._character:FindFirstChild("Head")

	if not humanoid then
		return
	end

	if not head then
		warn("Tried to play animation on character without head")
		return
	end

	self._particleController:play()

	self._animationController:play()

	self._trove:Connect(humanoid.Running, function()
		self:stop()
	end)
end

function AnimationAndParticle:stop()
	if self._stopped then
		return
	end

	self._stopped = true

	self.Stopped:Fire()
	self._animationController:stop()
	self._particleController:stop()
	self._trove:Destroy()
end

return AnimationAndParticle
