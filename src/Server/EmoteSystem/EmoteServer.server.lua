--[[
	Emote Server

	

]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Comm = require(ReplicatedStorage.Packages.Comm)

local EmoteComm = Comm.ServerComm.new(workspace, "EmoteComm")

local playSignal = EmoteComm:CreateSignal("PlayAnimation")
local stopSignal = EmoteComm:CreateSignal("StopAnimation")

playSignal:Connect(function(player: Player, animationName: string)
	playSignal:FireAll(player.Character, animationName, workspace:GetServerTimeNow())
end)

stopSignal:Connect(function(player: Player)
	stopSignal:FireAll(player.Character)
end)