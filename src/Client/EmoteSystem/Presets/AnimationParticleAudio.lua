local Util = require(script.Parent.Parent:WaitForChild("Util"))
local AnimationAndParticle = require(script.Parent:WaitForChild("AnimationAndParticle"))
local Controllers = script.Parent.Parent:WaitForChild("Controllers")
local AudioController = require(Controllers:WaitForChild("Audio"))

local AnimationParticleAudio = {}
AnimationParticleAudio.__index = AnimationParticleAudio

function AnimationParticleAudio.new(character, animation, particle, audio)
	local self = setmetatable({}, AnimationParticleAudio)

	self._character = character
	self._audioController = AudioController.new(character, audio)
	self._animAndParticle = AnimationAndParticle.new(character, animation, particle)

	self._animAndParticle.Stopped:Connect(function()
		self:stop()
	end)

	self.Stopped = self._animAndParticle.Stopped

	return self
end

function AnimationParticleAudio:play()
	self._audioController:play()
	self._animAndParticle:play()
end

function AnimationParticleAudio:stop()
	self._audioController:stop()
	self._animAndParticle:stop()
end

return AnimationParticleAudio
