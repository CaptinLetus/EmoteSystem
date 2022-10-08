local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Presets = script.Parent.Parent:WaitForChild("Presets")
local AnimationParticleAudio = require(Presets:WaitForChild("AnimationParticleAudio"))

local EmoteSystemAssets = ReplicatedStorage:WaitForChild("EmoteSystemAssets")
local Assets = EmoteSystemAssets:WaitForChild("Dance")
local Animation = Assets:WaitForChild("Animation")
local Particles = Assets:WaitForChild("Beats")
local Song = Assets:WaitForChild("Song")

local Dance = {}

function Dance.new(character)
	return AnimationParticleAudio.new(character, Animation, Particles, Song)
end

return Dance
