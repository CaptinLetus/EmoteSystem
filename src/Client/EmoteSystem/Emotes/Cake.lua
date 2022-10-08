local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Controllers = script.Parent.Parent:WaitForChild("Controllers")
local AudioController = require(Controllers:WaitForChild("Audio"))
local AnimationController = require(Controllers:WaitForChild("Animation"))
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)

local EmoteSystemAssets = ReplicatedStorage:WaitForChild("EmoteSystemAssets")
local Assets = EmoteSystemAssets:WaitForChild("Cake")
local Animation = Assets:WaitForChild("HoldCake")
local Song = Assets:WaitForChild("Shout")
local CakeModel = Assets:WaitForChild("Cake")

local Cake = {}
Cake.__index = Cake

function Cake.new(character)
	local self = setmetatable({}, Cake)

	self._trove = Trove.new()
	self._stopped = false
	self._character = character
	self._audioController = AudioController.new(character, Song)
	self._animationController = AnimationController.new(character, Animation, self._trove)

	self.Stopped = Signal.new()

	self._trove:Add(self.Stopped)

	return self
end

function Cake:play()
	self._audioController:play()
	self._animationController:play()

	local cake = self:weldCake()

	self._trove:Add(cake)
end

function Cake:weldCake()
	local newCake: Model = CakeModel:Clone()

	newCake.Parent = self._character

	for _, v: BasePart in pairs(newCake:GetDescendants()) do
		if not v:IsA("BasePart") then
			continue
		end

		local wc = Instance.new("WeldConstraint")
		wc.Part0 = newCake.PrimaryPart
		wc.Part1 = v
		wc.Parent = v

		v.Anchored = false
	end

	local rc = Instance.new("RigidConstraint")
	rc.Attachment0 = self._character.RightHand.RightGripAttachment
	rc.Attachment1 = newCake.PrimaryPart.Attachment
	rc.Parent = newCake.PrimaryPart

	newCake.PrimaryPart.Anchored = false

	return newCake
end

function Cake:stop()
	if self._stopped then
		return
	end

	self._stopped = true

	self._animationController:stop()
	self._trove:Destroy()

	self.Stopped:Fire()
end

return Cake
