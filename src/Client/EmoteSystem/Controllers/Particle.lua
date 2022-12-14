local Util = require(script.Parent.Parent:WaitForChild("Util"))

local Particle = {}
Particle.__index = Particle

function Particle.new(character, particles)
	local self = setmetatable({}, Particle)

	self._character = character
	self._particleTemplate = particles

	return self
end

function Particle:play()
	local head: BasePart = self._character:FindFirstChild("Head")

	if not head then
		warn("Tried to play particles on character without head")
		return
	end

	local particles = self._particleTemplate:Clone()

	particles.Parent = head

	self._particles = particles
end

function Particle:stop()
	Util.stopParticles(self._particles)
end

return Particle
