--[[
	Emote Client

	

]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Comm = require(ReplicatedStorage.Packages.Comm)

local Emotes = script.Parent:WaitForChild("Emotes")
local EmoteComm = Comm.ClientComm.new(workspace, true, "EmoteComm")

local playSignal = EmoteComm:GetSignal("PlayAnimation")
local stopSignal = EmoteComm:GetSignal("StopAnimation")

local playingEmote = {}

local function getEmoteFromName(name)
	local emote

	for _, child in pairs(Emotes:GetChildren()) do
		if child.Name == name then
			emote = require(child)
			break
		end
	end

	return emote
end

local function stopEmote(character)
	local emote = playingEmote[character]

	if emote then
		emote:stop()
		playingEmote[character] = nil
	end
end

playSignal:Connect(function(character: Player, animationName: string)
	local emoteClass = getEmoteFromName(animationName)

	if not emoteClass then
		warn("Tried to play emote that doesn't exist: " .. animationName)
		return
	end

	local emote = emoteClass.new(character)

	stopEmote(character)	
	emote:play()

	if character == Players.LocalPlayer.Character then
		emote.Stopped:Connect(function()
			stopSignal:Fire()
		end)
	end

	playingEmote[character] = emote
end)

stopSignal:Connect(stopEmote)

Players.LocalPlayer.Chatted:Connect(function(message)
	if message == "cute" then
		playSignal:Fire("Cute")
	elseif message == "dance" then
		playSignal:Fire("Dance")
	elseif message == "cake" then
		playSignal:Fire("Cake")
	end
end)
