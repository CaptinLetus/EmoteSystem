local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Util = {}

function Util.stopParticles(particles: ParticleEmitter)
	particles.Enabled = false

	task.delay(particles.Lifetime.Max, function()
		particles:Destroy()
	end)
end

function Util.stopAudio(audio: Sound)
	if audio:GetAttribute("DontCutOff") then
		return
	end

	TweenService:Create(audio, TweenInfo.new(0.5), {
		Volume = 0,
	}):Play()

	task.delay(0.5, function()
		audio:Destroy()
	end)
end

function Util.getHumanoidAndAnimatorFromCharacter(character: Model)
	local humanoid: Humanoid = character:FindFirstChild("Humanoid")

	if not humanoid then
		warn("Tried to play animation on character without humanoid")
		return
	end

	local animator: Animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator")
	animator.Parent = humanoid

	return humanoid, animator
end

function Util.playAnimation(character: Model, animation: Animation)
	-- don't play animations on other live characters
	-- they will animate themselves
	if character ~= Players.LocalPlayer.Character then
		for _, player in Players:GetPlayers() do
			if player.Character == character then
				return
			end
		end
	end

	local humanoid, animator = Util.getHumanoidAndAnimatorFromCharacter(character)

	if not humanoid or not animator then
		return
	end

	local animationTrack = animator:LoadAnimation(animation)

	animationTrack:Play()

	return animationTrack
end

return Util
