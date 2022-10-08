local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Util = require(script.Parent.Parent:WaitForChild("Util"))
local Signal = require(ReplicatedStorage.Packages.Signal)

local Animation = {}
Animation.__index = Animation

function Animation.new(character, animation, trove)
	local self = setmetatable({}, Animation)

	self._character = character
	self._animation = animation
	self._trove = trove

	self.Stopped = Signal.new()
	self._trove:Add(self.Stopped)

	return self
end

function Animation:play()
	self._animationTrack = Util.playAnimation(self._character, self._animation)

	if not self._animationTrack then
		return
	end

	self._trove:Connect(self._animationTrack.Stopped, function()
		self:stop()
	end)
end

function Animation:stop()
	if not self._animationTrack then
		return
	end

	self._animationTrack:Stop()

	self.Stopped:Fire()
end

return Animation
