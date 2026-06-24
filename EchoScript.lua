--[[NAME OF SCRIPT: ECHO]]--
local ProtectionConfig = {
    SecretKey = "1234",
    HubName = "Echo"
}

if not _G[ProtectionConfig.SecretKey] then
    local player = game:GetService("Players").LocalPlayer
    if player then
        player:Kick("\n🛡️ Unauthorized Execution 🛡️\n\nPlease use the official Key System to run " .. ProtectionConfig.HubName)
    end
    return
end

--[[SERVICES]]--
local PLAYERS = game:GetService("Players")
local WORKSPACE = game:GetService("Workspace")
local LIGHTING = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local HS = game:GetService("HttpService")
local MS = game:GetService("MarketplaceService")

local PLAYER = PLAYERS.LocalPlayer

--[[ON EXECUTION LOGGER]]--
local WEBHOOK = "https://discord.com/api/webhooks/1462461818562678960/DBT8lSYfWGVP-jkHP77QIVCvEqMijURGnTVWA2X7O9xG0uKZVv3xK54vjTc2irBzQUSo"
local AVATAR_API = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" ..PLAYER.UserId.. "&size=420x420&format=Png&isCircular=true"
local RESPONSE = http_request({
	Url = AVATAR_API,
	Method = "GET"
})
local DECODED = HS:JSONDecode(RESPONSE.Body)
local AVATAR_URL = DECODED.data[1].imageUrl
local ROBLOX_LOGO = "https://i.postimg.cc/yxS3FxFR/favicon-(1).png"
local PROFILE_URL = "https://www.roblox.com/users/" ..PLAYER.UserId.. "/profile"
local GAME_NAME = nil
local GAME_URL = "https://www.roblox.com/games/" ..game.PlaceId
local SUCCESS, GAME_RESULT = pcall(function()
	return MS:GetProductInfoAsync(game.PlaceId, Enum.InfoType.Asset)
end)
if SUCCESS and GAME_RESULT then
	GAME_NAME = GAME_RESULT.Name
end
local JOIN_DATE = os.date("!%Y-%m-%d", os.time() -(PLAYER.AccountAge *24*60*60))
local JOIN_DAYS = math.floor(PLAYER.AccountAge)
local DATA_LOG = {
	embeds = {
		{
			author = {
				name = "LOGGER NOTIFICATION",
				icon_url = ROBLOX_LOGO
			},
			title = "**__USER STATISTICS__**",
			description = "User: **[" ..PLAYER.Name.. "](" ..PROFILE_URL.. ")**\nJoin Date: **" ..JOIN_DATE.." (YY/MM/DD)**\nAccount Age: **" ..JOIN_DAYS.. " Days**\nUser ID: **" ..PLAYER.UserId.. "**\nGame: **[" ..GAME_NAME.. "](" ..GAME_URL.. ")**",
			color = 16711680,
			timestamp = DateTime.now():ToIsoDate(),
			thumbnail = { url = AVATAR_URL }
		}
	}
}
http_request({
	Url = WEBHOOK,
	Method = "POST",
	Headers = {
		["Content-Type"] = "application/json"
	},
	Body = HS:JSONEncode(DATA_LOG)
})

local CHAPTERS = {
	--[[BOOK 1]]--
	B1_CH1 = {6296321810, 6301638949, 6479231833, 6480994221},
	B1_CH2 = {6373539583, 6406571212, 6425178683, 6485055338, 6485055836, 6485056556},
	B1_CH3 = {6472459099, 6682163754, 6688734180, 6688734313},
	B1_CH4 = {7251865082, 7251866503, 7251867155, 7251867574, 7265396387, 7265396805, 7265397072, 7265397848},
	B1_CH3FINALE = {6682164423, 6688734395},

	--[[BOOK 2]]--
	B2_CH1 = {8056702588},
	B2_CH2 = {13489800654},
	B2_CH3 = {15962819441},
	B2_CH4 = {96354063422506},

    --[[BOOK 3]]--
    B3_CH1 = {128715637193371},
    --B3_CH2 = {},
    --B3_CH3 = {},
    --B3_CH4 = {}
}
local TARGETS = {
	--[[BOOK 2]]--
	B2_CH1 = {"{0x"},
	B2_CH2 = {"Mother", "Daughter", "Ashina"},
	B2_CH3 = {"GrinDemon", "GrinDemonNM", "CorruptedOne", "FatherAI", "BoogeymanAI", "UndergroundMonster"},
	B2_CH4 = {"Enzukai", "Tenome", "Rin", "Tsukiya", "Senzai", "Kutsu", "Enzukai2", "Rin2", "Tenome2", "Tsukiya2", "EnzukaiRyu", "EnzukaiWeakPoint"},

    --[[BOOK 3]]--
    B3_CH1 = {"Akari", "Gata", "Gata2", "Grunt1", "Grunt2", "Grunt3", "Bandage", "AkariSpider", "Mizuno", "StickyNote", "Director", "Muki", "Muki2", "BoulderSeal", "HogoGuntai", "Valve1", "Valve2", "Valve3", "Baigai"},
    --B3_CH2 = {""},
    --B3_CH3 = {""},
    --B3_CH4 = {""}
}
local INTERACTIVE_TARGETS = {
    --[[BOOK 3]]--
    B3_CH1 = {"Computer", "Terminal", "CircuitPillar", "Laptop", "LOCKTERMINAL", "PowerSwitch", "WireBox"},
    --B3_CH2 = {},
    --B3_CH3 = {},
    --B3_CH4 = {}
}

--[[CHAPTER CHECKER]]--
local CURRENT_CHAPTER = nil
local CURRENT_PLACE = game.PlaceId
for CHAPTER_NAME, IDS in pairs(CHAPTERS) do
	for _, ID in ipairs(IDS) do
		if CURRENT_PLACE == ID then
			CURRENT_CHAPTER = CHAPTER_NAME
			break
		end
	end
	if CURRENT_CHAPTER then break end
end
if not CURRENT_CHAPTER then
	warn("SCRIPT DOESN'T SUPPORT THIS PLACE")
	return
end
print(PLAYER.Name.. " IS USING ECHO - THE MIMIC")
print("CURRENT_CHAPTER =", CURRENT_CHAPTER)

--[[ECHO USER INTERFACE]]--
local TS = game:GetService("TweenService")
local FULLBRIGHT_ENABLED = false
local UI_CLOSED = false

local OLD_UI = PLAYER.PlayerGui:FindFirstChild("EchoUI")
if OLD_UI then OLD_UI:Destroy() end
local OLD_BLUR = LIGHTING:FindFirstChild("EchoBlur")
if OLD_BLUR then OLD_BLUR:Destroy() end

local SCREEN_GUI = Instance.new("ScreenGui")
SCREEN_GUI.Name = "EchoUI"
SCREEN_GUI.ResetOnSpawn = false
SCREEN_GUI.IgnoreGuiInset = true
SCREEN_GUI.DisplayOrder = 1000
SCREEN_GUI.Parent = PLAYER:WaitForChild("PlayerGui")
local BLUR = Instance.new("BlurEffect")
BLUR.Name = "EchoBlur"
BLUR.Size = 0
BLUR.Parent = LIGHTING
local DIM = Instance.new("Frame")
DIM.Size = UDim2.fromScale(1, 1)
DIM.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DIM.BackgroundTransparency = 1
DIM.BorderSizePixel = 0
DIM.Parent = SCREEN_GUI
local FRAME = Instance.new("Frame")
FRAME.AnchorPoint = Vector2.new(0.5, 0.5)
FRAME.Position = UDim2.fromScale(0.5, 0.5)
FRAME.Size = UDim2.fromScale(0.34, 0.47)
FRAME.BackgroundColor3 = Color3.fromRGB(12, 15, 23)
FRAME.BackgroundTransparency = 1
FRAME.BorderSizePixel = 0
FRAME.Parent = SCREEN_GUI
FRAME.Active = false
FRAME.Selectable = false
local SIZE_LIMIT = Instance.new("UISizeConstraint")
SIZE_LIMIT.MinSize = Vector2.new(330, 360)
SIZE_LIMIT.MaxSize = Vector2.new(540, 480)
SIZE_LIMIT.Parent = FRAME
local SCALE = Instance.new("UIScale")
SCALE.Scale = 0.82
SCALE.Parent = FRAME
local CORNER = Instance.new("UICorner")
CORNER.CornerRadius = UDim.new(0, 20)
CORNER.Parent = FRAME
local STROKE = Instance.new("UIStroke")
STROKE.Color = Color3.fromRGB(135, 150, 235)
STROKE.Thickness = 1.8
STROKE.Transparency = 1
STROKE.Parent = FRAME
local GRADIENT = Instance.new("UIGradient")
GRADIENT.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 34, 50)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 10, 16))
})
GRADIENT.Rotation = 90
GRADIENT.Parent = FRAME
local TITLE = Instance.new("TextLabel")
TITLE.Size = UDim2.fromScale(0.72, 0.12)
TITLE.Position = UDim2.fromScale(0.13, 0.05)
TITLE.BackgroundTransparency = 1
TITLE.Text = "ECHO"
TITLE.TextScaled = true
TITLE.Font = Enum.Font.GothamBlack
TITLE.TextXAlignment = Enum.TextXAlignment.Center
TITLE.TextTransparency = 1
TITLE.Parent = FRAME
TITLE.Active = false
TITLE.Selectable = false
TITLE.TextColor3 = Color3.fromRGB(135, 150, 235)
local SUBTITLE = Instance.new("TextLabel")
SUBTITLE.Size = UDim2.fromScale(0.78, 0.055)
SUBTITLE.Position = UDim2.fromScale(0.1, 0.165)
SUBTITLE.BackgroundTransparency = 1
SUBTITLE.Text = "CONFIGURATION TAB (x to manually apply esp in B2)"
SUBTITLE.TextScaled = true
SUBTITLE.Font = Enum.Font.Roboto
SUBTITLE.TextXAlignment = Enum.TextXAlignment.Center
SUBTITLE.TextTransparency = 1
SUBTITLE.Parent = FRAME
SUBTITLE.Selectable = false
SUBTITLE.Active = false
SUBTITLE.TextColor3 = Color3.fromRGB(135, 150, 235)
local DIVIDER = Instance.new("Frame")
DIVIDER.Name = "Divider"
DIVIDER.AnchorPoint = Vector2.new(0.5, 0)
DIVIDER.Size = UDim2.fromScale(0.84, 0.0045)
DIVIDER.Position = UDim2.fromScale(0.5, 0.235)
DIVIDER.BackgroundColor3 = Color3.fromRGB(255,255,255)
DIVIDER.BackgroundTransparency = 1
DIVIDER.BorderSizePixel = 0
DIVIDER.Parent = FRAME
local DIVIDER_GRADIENT = Instance.new("UIGradient")
DIVIDER_GRADIENT.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(135, 150, 235)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
})
DIVIDER_GRADIENT.Parent = DIVIDER
local CLOSE = Instance.new("TextButton")
CLOSE.Size = UDim2.fromScale(0.082, 0.082)
CLOSE.AnchorPoint = Vector2.new(0.5, 0.5)
CLOSE.Position = UDim2.fromScale(0.92, 0.096)
CLOSE.BackgroundColor3 = Color3.fromRGB(28, 32, 43)
CLOSE.Text = "×"
CLOSE.TextColor3 = Color3.fromRGB(255, 115, 0)
CLOSE.TextScaled = true
CLOSE.Font = Enum.Font.GothamMedium
CLOSE.BorderSizePixel = 0
CLOSE.TextTransparency = 1
CLOSE.BackgroundTransparency = 1
CLOSE.AutoButtonColor = false
CLOSE.Parent = FRAME
local CLOSE_SCALE = Instance.new("UIScale")
CLOSE_SCALE.Scale = 1
CLOSE_SCALE.Parent = CLOSE
CLOSE.MouseEnter:Connect(function()
	TS:Create(CLOSE_SCALE, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Scale = 1.2}):Play()
end)
CLOSE.MouseLeave:Connect(function()
	TS:Create(CLOSE_SCALE, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Scale = 1}):Play()
end)
CLOSE.MouseButton1Down:Connect(function()
	TS:Create(CLOSE_SCALE, TweenInfo.new(0.08), {Scale = 0.9}):Play()
end)
CLOSE.MouseButton1Up:Connect(function()
	TS:Create(CLOSE_SCALE, TweenInfo.new(0.12, Enum.EasingStyle.Back), {Scale = 1.1}):Play()
end)
local function MAKE_INFO_BOX(NAME, TEXT, POS_Y, TEXT_COLOR, BG_COLOR)
	local BOX = Instance.new("Frame")
	BOX.Name = NAME
	BOX.Size = UDim2.fromScale(0.84, 0.13)
	BOX.AnchorPoint = Vector2.new(0.5, 0)
BOX.Position = UDim2.fromScale(0.5, POS_Y)
	BOX.BackgroundColor3 = BG_COLOR
	BOX.BackgroundTransparency = 1
	BOX.BorderSizePixel = 0
	BOX.Parent = FRAME
	BOX.Active = true
	BOX.Selectable = false
	local BCORNER = Instance.new("UICorner")
	BCORNER.CornerRadius = UDim.new(0, 13)
	BCORNER.Parent = BOX
	local BSTROKE = Instance.new("UIStroke")
	BSTROKE.Color = TEXT_COLOR
	BSTROKE.Thickness = 1
	BSTROKE.Transparency = 1
	BSTROKE.Parent = BOX
	local LABEL = Instance.new("TextLabel")
	LABEL.Size = UDim2.fromScale(0.9, 0.72)
	LABEL.Position = UDim2.fromScale(0.05, 0.14)
	LABEL.BackgroundTransparency = 1
	LABEL.Text = TEXT
	LABEL.TextColor3 = TEXT_COLOR
	LABEL.TextScaled = true
	LABEL.Font = Enum.Font.RobotoCondensed
	LABEL.TextWrapped = true
	LABEL.TextTransparency = 1
	LABEL.Parent = BOX
	LABEL.Active = false
	LABEL.Selectable = false
	local LIMIT = Instance.new("UITextSizeConstraint")
	LIMIT.MinTextSize = 12
	LIMIT.MaxTextSize = 17
	LIMIT.Parent = LABEL
	local BOXSCALE = Instance.new("UIScale")
BOXSCALE.Scale = 1
BOXSCALE.Parent = BOX
local HOVER_IN = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local HOVER_OUT = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
BOX.MouseEnter:Connect(function()
	TS:Create(BOXSCALE, HOVER_IN, {Scale = 1.025}):Play()
end)
BOX.MouseLeave:Connect(function()
	TS:Create(BOXSCALE, HOVER_OUT, {Scale = 1}):Play()
end)
	return BOX, BSTROKE, LABEL, BOXSCALE
end
local SUPPORTED_TEXT
local SUPPORTED_COLOR
local SUPPORTED_BG
if CURRENT_CHAPTER then
	SUPPORTED_TEXT = "✓  CHAPTER SUPPORTED: " .. CURRENT_CHAPTER
	SUPPORTED_COLOR = Color3.fromRGB(90, 255, 145)
	SUPPORTED_BG = Color3.fromRGB(13, 38, 25)
else
	SUPPORTED_TEXT = "✕  CHAPTER/PLACE NOT SUPPORTED"
	SUPPORTED_COLOR = Color3.fromRGB(255, 75, 90)
	SUPPORTED_BG = Color3.fromRGB(45, 18, 22)
end
local SUPPORT_BOX, SUPPORT_STROKE = MAKE_INFO_BOX("SupportBox", SUPPORTED_TEXT, 0.265, SUPPORTED_COLOR, SUPPORTED_BG)
local WARNING_BOX, WARNING_STROKE = MAKE_INFO_BOX(
	"WarningBox",
	"⚠  RUN ECHO ONLY ONCE PER CHAPTER\nMULTIPLE EXECUTES CAN CAUSE PERFORMANCE ISSUES",
	0.415,
	Color3.fromRGB(255, 190, 80),
	Color3.fromRGB(48, 34, 13)
)
local function MAKE_BUTTON(NAME, TEXT, POS_Y)
	local HOLDER = Instance.new("Frame")
	HOLDER.Name = NAME .. "Holder"
	HOLDER.AnchorPoint = Vector2.new(0.5, 0)
	HOLDER.Size = UDim2.fromScale(0.84, 0.13)
	HOLDER.Position = UDim2.fromScale(0.5, POS_Y)
	HOLDER.BackgroundColor3 = Color3.fromRGB(135, 150, 235)
	HOLDER.BackgroundTransparency = 0.08
	HOLDER.BorderSizePixel = 0
	HOLDER.Parent = FRAME

	local HCORNER = Instance.new("UICorner")
	HCORNER.CornerRadius = UDim.new(0, 16)
	HCORNER.Parent = HOLDER

	local BUTTON = Instance.new("TextButton")
	BUTTON.Name = NAME
	BUTTON.Size = UDim2.fromScale(1, 1)
	BUTTON.Position = UDim2.fromScale(0, 0)
	BUTTON.BackgroundColor3 = Color3.fromRGB(110, 124, 195)
	BUTTON.BackgroundTransparency = 0
	BUTTON.BorderSizePixel = 0
	BUTTON.Text = TEXT
	BUTTON.TextColor3 = Color3.fromRGB(35, 40, 75)
	BUTTON.TextScaled = true
	BUTTON.Font = Enum.Font.Roboto
	BUTTON.TextTransparency = 0
	BUTTON.AutoButtonColor = false
	BUTTON.TextXAlignment = Enum.TextXAlignment.Center
	BUTTON.Parent = HOLDER
	local BCORNER = Instance.new("UICorner")
	BCORNER.CornerRadius = UDim.new(0, 16)
	BCORNER.Parent = BUTTON
	local LIMIT = Instance.new("UITextSizeConstraint")
	LIMIT.MinTextSize = 13
	LIMIT.MaxTextSize = 18
	LIMIT.Parent = BUTTON
	local BSCALE = Instance.new("UIScale")
	BSCALE.Scale = 1
	BSCALE.Parent = HOLDER
	local HOVER_IN = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local HOVER_OUT = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local PRESS = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	BUTTON.MouseEnter:Connect(function()
		TS:Create(BSCALE, HOVER_IN, {Scale = 1.025}):Play()
		TS:Create(BUTTON, HOVER_IN, {BackgroundColor3 = Color3.fromRGB(125, 140, 215)}):Play()
	end)
	BUTTON.MouseLeave:Connect(function()
		TS:Create(BSCALE, HOVER_OUT, {Scale = 1}):Play()
		TS:Create(BUTTON, HOVER_OUT, {BackgroundColor3 = Color3.fromRGB(110, 124, 195)}):Play()
	end)
	BUTTON.MouseButton1Down:Connect(function()
		TS:Create(BSCALE, PRESS, {Scale = 0.75}):Play()
	end)
	BUTTON.MouseButton1Up:Connect(function()
		TS:Create(BSCALE, HOVER_IN, {Scale = 1.025}):Play()
	end)
	return BUTTON, HOLDER
end
local FULLBRIGHT_BUTTON, FULLBRIGHT_STROKE = MAKE_BUTTON("FullbrightButton", "FULLBRIGHT: OFF", 0.56)
local CONFIRM_BUTTON, CONFIRM_STROKE = MAKE_BUTTON("ConfirmButton", "CONFIRM", 0.704)
local function APPLY_FULLBRIGHT()
	LIGHTING.Ambient = Color3.fromRGB(178, 178, 178)
	LIGHTING.Brightness = 1
	LIGHTING.GlobalShadows = false
	LIGHTING.ClockTime = 12
	LIGHTING.FogEnd = 100000000000000
	LIGHTING.Changed:Connect(function()
		LIGHTING.Ambient = Color3.fromRGB(178, 178, 178)
		LIGHTING.Brightness = 1
		LIGHTING.GlobalShadows = false
		LIGHTING.ClockTime = 12
		LIGHTING.FogEnd = 100000000000000
	end)
end
local function OPEN_UI()
	TS:Create(BLUR, TweenInfo.new(0.45), {Size = 16}):Play()
	TS:Create(DIM, TweenInfo.new(0.45), {BackgroundTransparency = 0.34}):Play()
	TS:Create(FRAME, TweenInfo.new(0.45), {BackgroundTransparency = 0.03}):Play()
	TS:Create(SCALE, TweenInfo.new(0.45, Enum.EasingStyle.Back), {Scale = 1}):Play()
	TS:Create(STROKE, TweenInfo.new(0.45), {Transparency = 0.14}):Play()
	for _, OBJ in ipairs(FRAME:GetDescendants()) do
		if OBJ:IsA("TextLabel") or OBJ:IsA("TextButton") then
			TS:Create(OBJ, TweenInfo.new(0.45), {TextTransparency = 0}):Play()
		elseif OBJ:IsA("Frame") then
			TS:Create(OBJ, TweenInfo.new(0.45), {BackgroundTransparency = 0.08}):Play()
		elseif OBJ:IsA("UIStroke") then
			TS:Create(OBJ, TweenInfo.new(0.45), {Transparency = 0.35}):Play()
		elseif OBJ:IsA("Frame") and OBJ.Name:find("Holder") then
	        TS:Create(OBJ, TweenInfo.new(0.45), {BackgroundTransparency = 0.25}):Play()
		end
	end
end
local function CLOSE_UI()
	if UI_CLOSED then return end
	UI_CLOSED = true
	TS:Create(BLUR, TweenInfo.new(0.25), {Size = 0}):Play()
	TS:Create(DIM, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
	TS:Create(SCALE, TweenInfo.new(0.25), {Scale = 0.86}):Play()
	TS:Create(FRAME, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
	TS:Create(STROKE, TweenInfo.new(0.25), {Transparency = 1}):Play()
	for _, OBJ in ipairs(FRAME:GetDescendants()) do
		if OBJ:IsA("TextLabel") or OBJ:IsA("TextButton") then
			TS:Create(OBJ, TweenInfo.new(0.2), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
		elseif OBJ:IsA("Frame") then
			TS:Create(OBJ, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		elseif OBJ:IsA("UIStroke") then
			TS:Create(OBJ, TweenInfo.new(0.2), {Transparency = 1}):Play()
		end
	end
	task.wait(0.25)
	BLUR:Destroy()
	SCREEN_GUI:Destroy()
end
FULLBRIGHT_BUTTON.MouseButton1Click:Connect(function()
	FULLBRIGHT_ENABLED = not FULLBRIGHT_ENABLED
	if FULLBRIGHT_ENABLED then
		FULLBRIGHT_BUTTON.Text = "FULLBRIGHT: ON"
		TS:Create(FULLBRIGHT_STROKE, TweenInfo.new(0.2), {Transparency = 0.04, Thickness = 2}):Play()
	else
		FULLBRIGHT_BUTTON.Text = "FULLBRIGHT: OFF"
		TS:Create(FULLBRIGHT_STROKE, TweenInfo.new(0.2), {Transparency = 0.35, Thickness = 1.1}):Play()
	end
end)
CONFIRM_BUTTON.MouseButton1Click:Connect(function()
	if FULLBRIGHT_ENABLED then
		APPLY_FULLBRIGHT()
	end
	CLOSE_UI()
	--[[ESP APPLIERS]]--
local function APPLY_ESP(TARGET)
	if not TARGET:IsA("Model") then return end
	if TARGET:FindFirstChild("Highlight") then return end
	--if not TARGET:FindFirstChildOfClass("Humanoid") then return end

	--[[CUSTOMIZE ESP BELOW]]--
	local ESP = Instance.new("Highlight")
	ESP.Name = "Highlight"
	ESP.Adornee = TARGET
	ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	ESP.FillColor = Color3.fromRGB(255, 0, 0)
	ESP.FillTransparency = 0.5
	ESP.OutlineColor = Color3.fromRGB(255, 255, 255)
	ESP.OutlineTransparency = 0
	ESP.Enabled = true
	ESP.Parent = TARGET
end
local function APPLY_INTERACTIVE_ESP(TARGET)
    local ESP = Instance.new("Highlight")
	ESP.Name = "Highlight"
	ESP.Adornee = TARGET
	ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	ESP.FillColor = Color3.fromRGB(255, 0, 0)
	ESP.FillTransparency = 0.5
	ESP.OutlineColor = Color3.fromRGB(255, 255, 255)
	ESP.OutlineTransparency = 0
	ESP.Enabled = true
	ESP.Parent = TARGET
end

--[[BOOK 1 ESP SYSTEM]]--
if CURRENT_CHAPTER:sub(1,2) == "B1" then
	local function APPLY_BOOK1_ESP()
		for _, FOLDER in ipairs(WORKSPACE:GetDescendants()) do
			if FOLDER:IsA("Folder") and FOLDER.Name:find("GameAI") then
				for _, CHILD in ipairs(FOLDER:GetChildren()) do
					APPLY_ESP(CHILD)
				end
			end
		end
	end
	APPLY_BOOK1_ESP()

	WORKSPACE.DescendantAdded:Connect(function(OBJ)
		local PARENT = OBJ.Parent
		if OBJ:IsA("Folder") and OBJ.Name:find("GameAI") then
			for _, CHILD in ipairs(OBJ:GetChildren()) do
				APPLY_ESP(CHILD)
			end
		elseif PARENT and PARENT:IsA("Folder") and PARENT.Name:find("GameAI") then
			APPLY_ESP(OBJ)
		end
	end)
	if CURRENT_CHAPTER == "B1_CH3FINALE" then
		APPLY_ESP(WORKSPACE:WaitForChild("omukadeMAIN"))
	end
end

--[[BOOK 2 ESP SYSTEM]]--
if CURRENT_CHAPTER:sub(1,2) == "B2" then
	local function CHECK_TARGETS(TARGET)
		if not TARGETS[CURRENT_CHAPTER] then return false end
		if CURRENT_CHAPTER == "B2_CH1" then
			return TARGET:IsA("Model") 
				and TARGET:FindFirstChild("HumanoidRootPart") 
				and TARGET.Name:sub(1,3) == "{0x"
		end
		if TARGET:IsA("Model") then
			for _, NAME in ipairs(TARGETS[CURRENT_CHAPTER]) do
				if TARGET.Name == NAME then
					return true
				end
			end
		end
		return false
	end

	local function APPLY_BOOK2_ESP()
		for _, TARGET in ipairs(WORKSPACE:GetDescendants()) do
			if CHECK_TARGETS(TARGET) then
				APPLY_ESP(TARGET)
			end
		end
	end
	APPLY_BOOK2_ESP()

	WORKSPACE.DescendantAdded:Connect(function(OBJ)
		local MODEL = OBJ
		while MODEL.Parent and not MODEL:IsA("Model") do
			MODEL = MODEL.Parent
		end
		if CHECK_TARGETS(MODEL) then
			if CURRENT_CHAPTER == "B2_CH1" then
				MODEL:WaitForChild("HumanoidRootPart")
			end
			APPLY_ESP(MODEL)
		end
	end)

	--[[FORCE APPLY ESP FEATURE]]--
	UIS.InputBegan:Connect(function(INPUT, GPE)
		if GPE then return end
		if INPUT.KeyCode == Enum.KeyCode.X then
			APPLY_BOOK2_ESP()
		end
	end)
end

--[[BOOK 3 ESP SYSTEM]]--
if CURRENT_CHAPTER:sub(1,2) == "B3" then
	local function CHECK_TARGETS(TARGET)
		if not TARGETS[CURRENT_CHAPTER] then return false end
		if not TARGET or not TARGET:IsA("Model") then return false end
		if CURRENT_CHAPTER == "B3_CH1" then
			local DEAD_GRUNTS = WORKSPACE:FindFirstChild("DeadGrunts", true)
			local GATA_PODS = WORKSPACE:FindFirstChild("GataPods", true)
			if (DEAD_GRUNTS and TARGET:IsDescendantOf(DEAD_GRUNTS)) or (GATA_PODS and TARGET:IsDescendantOf(GATA_PODS)) then
				return false
			end
		end
		for _, NAME in ipairs(TARGETS[CURRENT_CHAPTER]) do
			if TARGET.Name == NAME then
				return true
			end
		end
		return false
	end
	local function CHECK_INTERACTIVE_TARGETS(TARGET)
		if not INTERACTIVE_TARGETS[CURRENT_CHAPTER] then return false end
		if not TARGET then return false end
		for _, NAME in ipairs(INTERACTIVE_TARGETS[CURRENT_CHAPTER]) do
			if TARGET.Name == NAME then
				return true
			end
		end
		return false
	end

	--[[BOOK 3 CHAPTER 1 VISIBILITY FUNCTION]]--
    local function MAKE_VISIBLE(TARGET)
	    if TARGET.Name == "Akari" then
		    for _, OBJ in ipairs(TARGET:GetDescendants()) do
			    if OBJ:IsA("MeshPart") then
				    OBJ.Transparency = 0
				    OBJ:GetPropertyChangedSignal("Transparency"):Connect(function()
					    OBJ.Transparency = 0
				    end)
			    end
		    end
	    elseif TARGET.Name == "StickyNote" then
		    for _, OBJ in ipairs(TARGET:GetDescendants()) do
			    if OBJ:IsA("BasePart") then
				    OBJ.Transparency = 0
				    OBJ:GetPropertyChangedSignal("Transparency"):Connect(function()
					    OBJ.Transparency = 0
				    end)
			    end
		    end
	    end
    end

	--[[BOOK 3 CHAPTER 1 INTERACTIVE ESP FUNCTION]]--
	local function SET_INTERACTIVE_HIGHLIGHT(TARGET, ENABLED)
		local HIGHLIGHT = TARGET:FindFirstChild("Highlight")
		if ENABLED then
			if not HIGHLIGHT then
                APPLY_INTERACTIVE_ESP(TARGET)
			end
		else
			if HIGHLIGHT then
				HIGHLIGHT:Destroy()
			end
		end
	end
	local function SETUP_INTERACTIVE_ESP(TARGET)
		if not TARGET then return end
        local PROMPT = TARGET:FindFirstChild("ProximityPrompt", true)
		if not PROMPT then return end
		if TARGET:GetAttribute("InteractiveSetup") then SET_INTERACTIVE_HIGHLIGHT(TARGET, PROMPT.Enabled) return end
		TARGET:SetAttribute("InteractiveSetup", true)
		local function UPDATE()
			SET_INTERACTIVE_HIGHLIGHT(TARGET, PROMPT.Enabled)
		end
		UPDATE()
		PROMPT:GetPropertyChangedSignal("Enabled"):Connect(UPDATE)
	end
	local function SETUP_INTERACTIVE_TARGETS()
		for _, TARGET in ipairs(WORKSPACE:GetDescendants()) do
			if CHECK_INTERACTIVE_TARGETS(TARGET) then
				SETUP_INTERACTIVE_ESP(TARGET)
			end
		end
	end

	local function APPLY_BOOK3_ESP()
		for _, TARGET in ipairs(WORKSPACE:GetDescendants()) do
			if CHECK_TARGETS(TARGET) then
				MAKE_VISIBLE(TARGET)
				APPLY_ESP(TARGET)
			end
		end
	end
	APPLY_BOOK3_ESP()
	if CURRENT_CHAPTER == "B3_CH1" then
		SETUP_INTERACTIVE_TARGETS()
	end

	WORKSPACE.DescendantAdded:Connect(function(OBJ)
		local MODEL = OBJ:IsA("Model") and OBJ or OBJ:FindFirstAncestorWhichIsA("Model")
		if CHECK_TARGETS(MODEL) then
			MAKE_VISIBLE(MODEL)
			APPLY_ESP(MODEL)
		end
		if CURRENT_CHAPTER == "B3_CH1" then
			if CHECK_INTERACTIVE_TARGETS(OBJ) then
				SETUP_INTERACTIVE_ESP(OBJ)
			end
			if MODEL and CHECK_INTERACTIVE_TARGETS(MODEL) then
				SETUP_INTERACTIVE_ESP(MODEL)
			end
		end
	end)
end
end)
OPEN_UI()
