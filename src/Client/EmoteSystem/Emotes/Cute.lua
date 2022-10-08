local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Presets = script.Parent.Parent:WaitForChild("Presets")
local AnimationParticleAudio = require(Presets:WaitForChild("AnimationParticleAudio"))

local EmoteSystemAssets = ReplicatedStorage:WaitForChild("EmoteSystemAssets")
local Assets = EmoteSystemAssets:WaitForChild("Cute")
local Animation = Assets:WaitForChild("Curtsy")
local Particles = Assets:WaitForChild("Hearts")
local Song = Assets:WaitForChild("Harp")

local Cute = {}

function Cute.new(character)
	return AnimationParticleAudio.new(character, Animation, Particles, Song)
end

return Cute
