if not hookmetamethod then 
    return print('Incompatible Exploit','Your exploit does not support this command (missing hookmetamethod)')
end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local oldhmmi
local oldhmmnc
oldhmmi = hookmetamethod(game, "__index", function(self, method)
    if self == LocalPlayer and method:lower() == "kick" then
    print(self)
        return error("Expected ':' not '.' calling member function Kick", 2)
    end
    return oldhmmi(self, method)
end)
oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
    if self == LocalPlayer and getnamecallmethod():lower() == "kick" then
    print(self)
        return
    end
    print(self)
    return oldhmmnc(self, ...)
end)
print('Client Antikick','Client anti kick is now active (only effective on localscript kick)')

local Fluent = loadstring(game:HttpGet("https://xtimeteam.netlify.app/Lib/Fluent/Addons/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://xtimeteam.netlify.app/Lib/Fluent/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://xtimeteam.netlify.app/Lib/Fluent/Addons/InterfaceManager.lua"))()

local HumanModCons = {}
local Tool
local oldCFrame = nil
local odb = nil
local git = false

local Window = Fluent:CreateWindow({
Title = "[😼] Kitkat Hub | Whispering Pines",
SubTitle = "by Kokie",
TabWidth = 160,
Size = UDim2.fromOffset(580, 350),
Acrylic = true,
Theme = "Aqua",
MinimizeKey = Enum.KeyCode.Period
})

local Tabs = {
Main = Window:AddTab({ Title = "Main", Icon = "home" }),
View = Window:AddTab({ Title = "View", Icon = "eye" }),
Teleports = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

Tabs.Main:AddSection("[🧨] Get Item Options")

-- Function to retrieve available items in ToolDrops
local function getItemList()
local items = {}
for _, v in ipairs(game.workspace.Debris.ToolDrops:GetChildren()) do
    local model = v:FindFirstChildOfClass("Model")
    if model and not table.find(items, model.Name) then
        table.insert(items, model.Name)
    end
end
return items
end

-- Function to update dropdown with current items
local function updateItemList(dropdown)
local items = getItemList()
table.insert(items, 1, "None")  -- Ensure "None" is always the first option
dropdown.Values = items
end

-- Button to check and notify about items
Tabs.Main:AddButton({
Title = "[🎒] Check Item",
Description = "Check Item",
Callback = function()
    local items = getItemList()
    local itemText = #items > 0 and table.concat(items, ", ") or "None"

    Fluent:Notify({
        Title = "Notification",
        Content = "Items found: " .. itemText,
        Duration = 5
    })
end
})


local Toolitem = Tabs.Main:AddDropdown("Item", {
Title = "[🎒] Item To Get",
Values = {
    "None",
    "FireAxe", "Bat", "Crowbar",
    "Radio", "Flashlight", "FirstAidKit",
    "Credit", "AntiqueHelmet", "Adrenaline",
    "TaurusJudge", "FlareGun", "EMFReader",
    "Polaroid", "Hatchet" , "SledgeHammer",
    "MetalPipe", "ButchersKnife"
},
Multi = false,
Default = 1,
})
--_ToolDrop
Tabs.Main:AddButton({
Title = "[🧲] Get Item",
Description = "Get Item",
Callback = function()
Tool = Toolitem.Value

local itemParent = nil
for i, v in ipairs(game.workspace.Debris.ToolDrops:GetChildren()) do
if v.Name:lower():find(Tool:lower()) then  -- Match Tool name regardless of case
    itemParent = v
    break
end
end


if itemParent then
    local item = itemParent:FindFirstChild("DropPivot")

    if item then
        local LocalPlayer = game.Players.LocalPlayer
        local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRoot = Char:WaitForChild("HumanoidRootPart")
        
        if not oldCFrame then
            oldCFrame = HumanoidRoot.CFrame
        end

        local prompt = item:FindFirstChild("ItemDropPrompt")
        if prompt then

            HumanoidRoot.CFrame = item.CFrame
            HumanoidRoot.Anchored = true
               task.wait(0.05)
             HumanoidRoot.CFrame = item.CFrame + Vector3.new(0, 1.5, 0)
            item.CFrame = HumanoidRoot.CFrame

            prompt.HoldDuration = 0
            HumanoidRoot.Anchored = false


            while item.Parent do

            if git == true then
            git = false
            HumanoidRoot.Anchored = false
            HumanoidRoot.CFrame = oldCFrame
            oldCFrame = nil
            break
            end
                HumanoidRoot.CFrame = item.CFrame + Vector3.new(0, 1.5, 0)
                item.CFrame = HumanoidRoot.CFrame
                fireproximityprompt(prompt)
                task.wait(0.005)
            end
            HumanoidRoot.CFrame = oldCFrame
            oldCFrame = nil
        end
    else
        Fluent:Notify({
            Title = "Notification",
            Content = "No DropPivot found in item.",
            Duration = 3
        })
    end
else
    if Value ~= "None" then
        Fluent:Notify({
            Title = "Notification",
            Content = "Item category not found.",
            Duration = 3
        })
    end
end
end
})

Tabs.Main:AddButton({
Title = "[🧰] Stop Get Item",
Description = "Stop Get Item",
Callback = function()
    git = true
end
})

Tabs.Main:AddSection("[🧨] Full Power Options")

Tabs.Main:AddButton({
Title = "[☀] Full Brightness",
Description = "Makes the map brighter",
Callback = function()
    game.Lighting.Brightness = 1
    game.Lighting.ClockTime = 14
    game.Lighting.FogEnd = 100000
    game.Lighting.GlobalShadows = false
    game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end
})

local NoFall = Tabs.Main:AddToggle("NoFallDmg", {Title = "[🛡] No Fall Dmg and Ragdoll", Default = true })

NoFall:OnChanged(function()
local Enabled = Options.NoFallDmg.Value

task.spawn(function()
    while Enabled do
        local Char = game.Players.LocalPlayer.Character
        if Char then
            local FallDamage = Char:FindFirstChild("FallDamage")
            if FallDamage then
                local Client = FallDamage:FindFirstChild("Client")
                local Client2 = FallDamage:FindFirstChild("Client2")
                
                if Client then Client.Disabled = true end
                if Client2 then Client2.Disabled = true end
            end
            
            Char:SetAttribute("Ragdolled", false)
            Char:SetAttribute("RagdollToggle", false)
            
            local RagdollTime = Char:FindFirstChild("RagdollTime")
            if RagdollTime then
                RagdollTime.Value = false
            end
        end
        task.wait(0.1)
    end
end)
end)


local Unlock = Tabs.Main:AddToggle("Unlock", {Title = "[🔓] Unlock Stamina and Regen", Default = true })
Unlock:OnChanged(function()
_G.Unlock = Options.Unlock.Value
task.spawn(function()
    while _G.Unlock do
        game:GetService("Players").LocalPlayer.PlayerGui.UI.Main.Regen.Value = 0
        game:GetService("Players").LocalPlayer.PlayerGui.UI.Main.RegenTime.Value = 0
        game:GetService("Players").LocalPlayer.PlayerGui.UI.Main.Stamina.Value = 500
        game:GetService("Players").LocalPlayer.PlayerGui.UI.Main.BleedDamage.Value = 0
        game:GetService("Players").LocalPlayer.PlayerGui.UI.Main.Drainage.Value = 0
        task.wait(0.1)
    end
end)
end)

local Hold = Tabs.Main:AddToggle("Hold", {Title = "[🔓] Unlock Hold", Default = true })
Hold:OnChanged(function()
_G.Hold = Options.Hold.Value
task.spawn(function()
    while _G.Hold do
        for i, Item in ipairs(workspace.Debris.ToolDrops:GetDescendants()) do
            if Item:IsA("ProximityPrompt") and Item.HoldDuration ~= 0 then
                Item.HoldDuration = 0
            end
        end
        task.wait(0.15)
    end
end)
end)

Tabs.Main:AddButton({
Title = "[⚡] Unlock Speed And JumpPower",
Description = "Unlock Speed And JumpPower",
Callback = function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid then return end

    if HumanModCons.wsLoop then
        HumanModCons.wsLoop:Disconnect()
        HumanModCons.wsLoop = nil
    end
    if HumanModCons.jpLoop then
        HumanModCons.jpLoop:Disconnect()
        HumanModCons.jpLoop = nil
    end

    if humanoid.WalkSpeed == 25 and humanoid.JumpPower == 35 then
        humanoid.WalkSpeed = 10
        humanoid.JumpPower = 35
    else
        humanoid.WalkSpeed = 25
        humanoid.JumpPower = 35

        HumanModCons.wsLoop = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if humanoid.WalkSpeed ~= 25 then
                humanoid.WalkSpeed = 25
            end
        end)

        HumanModCons.jpLoop = humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
            if humanoid.JumpPower ~= 35 then
                humanoid.JumpPower = 35
            end
        end)
    end
end
})

Tabs.Teleports:AddSection("[🔮] Teleports Options")

local function TeleportPlayer(targetPosition)
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRoot = Char:WaitForChild("HumanoidRootPart")

if not odb then
    odb = HumanoidRoot.CFrame
end

HumanoidRoot.CFrame = CFrame.new(targetPosition)
end

local function ReturnToOriginalPosition()
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRoot = Char:WaitForChild("HumanoidRootPart")

if odb then
    HumanoidRoot.CFrame = odb
    odb = nil
    HumanoidRoot.Anchored = false
end
end

Tabs.Teleports:AddButton({
Title = "Get CFrame",
Callback = function()
    local LocalPlayer = Players.LocalPlayer
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HR = char:FindFirstChild("HumanoidRootPart")
    if HR then
        local currentCFrame = HR.CFrame.Position
        setclipboard(string.format(
            "Vector3.new(%f, %f, %f)",
            currentCFrame.X, currentCFrame.Y, currentCFrame.Z
        ))
        Fluent:Notify({
            Title = "CFrame Copied",
            Content = "CFrame position copied to clipboard.",
            Duration = 3
        })
    else
        Fluent:Notify({
            Title = "Error",
            Content = "HumanoidRootPart not found.",
            Duration = 3
        })
    end
end
})

Tabs.Teleports:AddButton({
Title = "[👛] AFK Money",
Description = "Bug",
Callback = function()
    TeleportPlayer(Vector3.new(-491.159, 250, 229.857),true)
end
})

Tabs.Teleports:AddButton({
Title = "[🗼] Shop Tower",
Description = "Teleport to Shop Tower",
Callback = function()
    TeleportPlayer(Vector3.new(-248.657, 40.375, -341.895),false)
end
})

Tabs.Teleports:AddButton({
Title = "[🗼] Radio Tower",
Description = "Teleport to Shop Tower",
Callback = function()
    TeleportPlayer(Vector3.new(216.813309, 40.590576, 214.205231),false)
end
})

Tabs.Teleports:AddButton({
Title = "[🏠] House",
Description = "Teleport to House",
Callback = function()
    TeleportPlayer(Vector3.new(22.460442, 4.233502, -116.518257),false)
end
})

Tabs.Teleports:AddButton({
Title = "[⛏] Cave",
Description = "Teleport to Cave",
Callback = function()
    TeleportPlayer(Vector3.new(-389.844360, 4.606637, 208.673141),false)
end
})

Tabs.Teleports:AddButton({
Title = "[🔄] Return to Previous Position",
Description = "Go back to your original position",
Callback = function()
    ReturnToOriginalPosition()
end
})

Tabs.View:AddSection("[👓] View Options")

local ViewOptions = {"None", "Rake"}
for i, pls in ipairs(game.Players:GetChildren()) do
if pls ~= LocalPlayer then
    table.insert(ViewOptions, pls.Name)
end
end

local ViewDropdown = Tabs.View:AddDropdown("ViewSelection", {
Title = "[👁] Select Target",
Values = ViewOptions,
Multi = false,
Default = 1,
})

Tabs.View:AddButton({
Title = "[🔍] View Selected",
Description = "Switch camera to selected entity",
Callback = function()
    local Selected = ViewDropdown.Value
    if Selected == "None" then
        workspace.CurrentCamera.CameraSubject = LocalPlayer.Character
    elseif Selected == "Rake" and workspace:FindFirstChild("Rake") then
        workspace.CurrentCamera.CameraSubject = workspace.Rake
    else
        local TargetPlayer = game.Players:FindFirstChild(Selected)
        if TargetPlayer and TargetPlayer.Character then
            workspace.CurrentCamera.CameraSubject = TargetPlayer.Character
        end
    end
    ViewDropdown:SetValue("None")
end
})

Tabs.View:AddButton({
Title = "[🔄] Reset View Selection",
Description = "Reset view dropdown ",
Callback = function()
    local ViewOptions = {"None", "Raka"}
        for i, pls in ipairs(Players:GetChildren()) do
            if pls ~= LocalPlayer then
                table.insert(ViewOptions, pls.Name)
        end
    end
end
})

Tabs.View:AddSection("[👁] Esp Options")

local RakeEsp = Tabs.View:AddToggle("RakeEsp", {Title = "[🛰] Rake Esp", Default = false })
RakeEsp:OnChanged(function()
_G.RakeEsp = Options.RakeEsp.Value
task.spawn(function()
    while _G.RakeEsp do
        local Rake = workspace:FindFirstChild("Rake")
        if Rake then
            local highlight = Rake:FindFirstChild("HumanoidRootPart"):FindFirstChild("Rake_Highlight")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "Rake_Highlight"
                highlight.Parent = Rake.HumanoidRootPart
                highlight.FillTransparency = 0.7
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineTransparency = 1
            end
        end
        task.wait(0.5)
    end
end)
end)

local ItemEsp = Tabs.View:AddToggle("ItemEsp", {Title = "[🛰] Item Esp", Default = false })
ItemEsp:OnChanged(function()
_G.ItemEsp = Options.ItemEsp.Value
task.spawn(function()
    while _G.ItemEsp do
        
for i, v in ipairs(workspace.Debris.ToolDrops:GetChildren()) do
    local esp = v:FindFirstChild("Item_ToolEsp")
    if not esp then
    local a = Instance.new("Highlight")
    a.Name = "Item_ToolEsp"
    a.Parent = v
    a.FillTransparency = 0.7
    a.FillColor = Color3.fromRGB(0, 255, 0)
    a.OutlineTransparency = 1
end

        task.wait(0.5)
    end
end
end)
end)

local PlayerEsp = Tabs.View:AddToggle("PlayerEsp", {Title = "[🛰] Player Esp", Default = false })

PlayerEsp:OnChanged(function()
_G.PlayerEsp = Options.PlayerEsp.Value

if _G.PlayerEsp then
    task.spawn(function()
        while _G.PlayerEsp do
            for i, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Character then
                    local v = plr.Character
                    local esp = v:FindFirstChild("Player_Esp")
                    if not esp then
                        local a = Instance.new("Highlight")
                        a.Name = "Player_Esp"
                        a.Parent = v
                        a.FillTransparency = 0.7
                        a.FillColor = Color3.fromRGB(0, 255, 255)
                        a.OutlineTransparency = 1
                    end
                end
            end
            task.wait(0.5)
        end

    end)
else
end
end)



Window:SelectTab(1)


Window:SelectTab(1)
InterfaceManager:SetFolder("KitKatHub")
SaveManager:SetFolder("KitKatHub/Whispering-Pines")
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
