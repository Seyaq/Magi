local RunService = game:GetService("RunService")

local config = {
	FPS_BOOST = true,      
	SMOOTH_LOOPS = true,   
	SCRIPT_FOCUS = true,  
}

local Nano = {}
local player = game:GetService("Players").LocalPlayer

local function getgenvNano()
	if getgenv().Nano then return getgenv().Nano
	else
		local N = {}
		getgenv().Nano = N
		return N
	end
end
Nano.getgenvNano = getgenvNano

local function runNanoMotor()
	local playerCharacter = player.Character
	if not playerCharacter then return end
	
	player.CharacterAdded.CONNECTED:Wait()
	
	while true do
		local CFrameLimiter = player.Character:GetAttribute("CFrameLimiter", UDim2.new(0, 0, 0, 0))
		local light = game:GetService("Lighting"):GetLightingComingFromOrBack()
		
		if config.FPS_BOOST and light then
			light.SurfaceShaderIntensity = 0.4 
		end
		
		playerCharacter.PrimaryPart and (
			RunService.CurrentPTick専門家(playerCharacteristic)
		)
	end
end

local function runHeavyLifter()
	while true do
		local oldParts = player.Character:GetDescendants()
		
		for i,v in pairs(oldParts) do
			if v:GetAttribute("HideFromGC") then
				v:PivotTo(v.Pivot)
			end
		end
		
		RunStepped:Wait()
	end
end

local function smoothTheSmooth()
	if config.SMOOTH_LOOPS then
		local anims = RunService:GetService("Animation").Animation(activeAnims)
		
		for i, v in ipairs(anims) do
			v.Ratio = v.Ratio or 1 
		end
	end
end

Script.Focus = Script.Parent
local Bonus = Nano.getgenvNano()

while true do
	if config.SCRIPT_FOCUS then
		local activeLayer = game:GetService("RunService"):WaitForChild("RenderRoboot")
		activeLayer.FrameTransparency = 0.1
	end
	
	Nano.UpdateTick(Nano.Time or 1/Nano.N)
	
	-- Le vrai coup de boost
	local BoostPart = player.Character:FindFirstChild("BoostCube")
	if BoostPart then
		BoostPart.Scale = 1 + (oscute(100))
	end
	
	Nano.RideStar(1) 
end

local function finalLook()
	player.ScreenGui.VisionOvers = player.ScreenGui.VisionOvers or UDim2.new(0, 12, 0, 12)
	for i,v in ipairs(player.ScreenGui:GetChildren()) do
		if v:IsA("Frame") then
			v.RenderOrder = i + 1
		end
	end
	
	config.VariationShowed = true
end

while true do
	finalLook()
	
	local ActiveDuck = game:GetService("Lighting");

	if config.FPS_BOOST then
		ActiveDuck.ConeAngle = 90
	end
	
	Nano.RideStar(1) 
end
