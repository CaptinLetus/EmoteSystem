--[[
	Emote Client

	

]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Emotes = script.Parent:WaitForChild("Emotes")
local Cute = require(Emotes:WaitForChild("Cute"))
local Dance = require(Emotes:WaitForChild("Dance"))

local Comm = require(ReplicatedStorage.Packages.Comm)

local EmoteComm = Comm.ClientComm.new(workspace, true, "EmoteComm")

local playSignal = EmoteComm:GetSignal("PlayAnimation")
local stopSignal = EmoteComm:GetSignal("StopAnimation")

local playingEmote = {}

playSignal:Connect(function(character: Player, animationName: string)
	local emote

	if animationName == "cute" then
		emote = Cute.new(character)
	elseif animationName == "dance" then
		emote = Dance.new(character)
	end

	emote:play()

	if character == Players.LocalPlayer.Character then
		emote.Stopped:Connect(function ()
			stopSignal:Fire()
		end)
	end

	playingEmote[character] = emote
end)

stopSignal:Connect(function(character: Player)
	local emote = playingEmote[character]

	if emote then
		emote:stop()
	end
end)

Players.LocalPlayer.Chatted:Connect(function(message)
	if message == "cute" then
		playSignal:Fire("cute")
	elseif message == "dance" then
		playSignal:Fire("dance")
	end
end)
