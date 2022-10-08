local Util = require(script.Parent.Parent:WaitForChild("Util"))
local AnimationAndParticle = require(script.Parent:WaitForChild("AnimationAndParticle"))

local AnimationParticleAudio = {}
AnimationParticleAudio.__index = AnimationParticleAudio

function AnimationParticleAudio.new(character, animation, particle, audio)
	local self = setmetatable({}, AnimationParticleAudio)

	self._character = character
	self._audio = audio
	self._animAndParticle = AnimationAndParticle.new(character, animation, particle)

	self._animAndParticle.Stopped:Connect(function()
		self:stop()
	end)

	self.Stopped = self._animAndParticle.Stopped

	return self
end

function AnimationParticleAudio:play()
	local head: BasePart = self._character:FindFirstChild("Head")

	if not head then
		warn("Tried to play animation on character without head")
		return
	end

	local newSong: Sound = self._audio:Clone()

	newSong.Parent = head
	newSong:Play()

	self._song = newSong

	self._animAndParticle:play()
end

function AnimationParticleAudio:stop()
	Util.stopAudio(self._song)
	self._animAndParticle:stop()
end

return AnimationParticleAudio
