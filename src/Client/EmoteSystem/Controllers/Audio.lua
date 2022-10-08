local Util = require(script.Parent.Parent:WaitForChild("Util"))

local Audio = {}
Audio.__index = Audio

function Audio.new(character, audio)
	local self = setmetatable({}, Audio)

	self._character = character
	self._audio = audio

	return self
end

function Audio:play()
	local head: BasePart = self._character:FindFirstChild("Head")

	if not head then
		warn("Tried to play animation on character without head")
		return
	end

	local newSong: Sound = self._audio:Clone()

	newSong.Parent = head
	newSong:Play()

	self._song = newSong
end

function Audio:stop()
	Util.stopAudio(self._song)
end

return Audio
