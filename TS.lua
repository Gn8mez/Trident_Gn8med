local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/2Riddle2/AlteryoBases/main/AlteryoLinoria"))()
		local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainstreamed/Linoria-Rewrite/main/Save%20Manager.lua"))()
		local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/2Riddle2/AlteryoBases/main/AlteryoTheme'))()

		getgenv()._Aimbot = {
			Enabled = false,
			AimSmooth = 5,
			X_Offset = 0,
			Y_Offset = 0
		}

		getgenv()._SilentAim = {
			Enabled = false,
			Silent_Target = nil,
			X_Offset = 0,
			Y_Offset = 0
		}

		getgenv().ASSettings = {
			AimType = "To Cursor",
			AimDis = 200,
			AimSleepers = false,
			VisibleCheck = false,
			Prediction = false,
		}

		getgenv()._Toggles = {
			ESP = false,
			Noclip = false,
			OreESP = false
		}

		getgenv().Settings = {
			CameraZoom = 0,
			OreMaxDis = 300
		}

		local anticam
		anticam = hookmetamethod(game, "__index", newcclosure(function(...)
			local self, k = ...
			if not checkcaller() and k == "CFrame" and self.Name == "Camera" and self == Camera then
				return _Camera.GetCFrame()
			end

			return anticam(...)
		end))

		local antihitbox
		antihitbox = hookmetamethod(game, "__index", newcclosure(function(...)
			local self, k = ...

			if not checkcaller() and k == "Size" and self.Name == "Head" then
				return Vector3.new(1.9362000226974487, 0.9681000113487244, 0.9681000113487244)
			end

			return antihitbox(...)
		end))


		-- Game Globals
		local _Network = getrenv()._G.modules.Network;
		local _Player = getrenv()._G.modules.Player;
		local _Character = getrenv()._G.modules.Character;
		local _Camera = getrenv()._G.modules.Camera;

		-- Locals
		local Players = game:GetService("Players");
		local LocalPlayer = Players.LocalPlayer;
		local Camera = game:GetService("Workspace").Camera;
		local Mouse = LocalPlayer:GetMouse();


		local Light = game:GetService("Lighting")
		-- // Functions \\ --
		-- Sleeping Check
		local function IsSleeping(head)
			return (head.Rotation == Vector3.new(0, 0, -75) or head.Rotation == Vector3.new(0, 0, 45)) -- Jank
		end

		-- Check if Visible
		function isPartVisible(part)
			local ignore = workspace.Ignore:GetDescendants();
			local castPoints = {part.Position}
			return Camera:GetPartsObscuringTarget(castPoints, ignore)
		end

		-- Get Closest to mouse
		function getClosestPlayerToCursor()
			local closestPlayer = nil;
			local shortestDistance = ASSettings["AimDis"];

			for i, v in pairs(workspace:GetChildren()) do
				if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= "Player" then
					if v.PrimaryPart ~= nil and v:FindFirstChild("Head") then
						if (not isPartVisible(v.PrimaryPart) and not ASSettings["VisibleCheck"]) or (IsSleeping(v.Head) and not ASSettings["AimSleepers"]) then
							return nil;
						end

						local pos = Camera.WorldToViewportPoint(Camera, v.PrimaryPart.Position)
						local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude

						if magnitude < shortestDistance then
							closestPlayer = v
							shortestDistance = magnitude
						end
					end
				end
			end

			return closestPlayer
		end

		-- Get Closest to LocalPlayer
		function getClosestPlayerToPlayer()
			local closestPlayer = nil;
			local shortestDistance = ASSettings["AimDis"];

			for i, v in pairs(workspace:GetChildren()) do
				if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= "Player" then
					if v.PrimaryPart ~= nil and v:FindFirstChild("Head") then
						if (not isPartVisible(v.PrimaryPart) and not ASSettings["VisibleCheck"]) or (IsSleeping(v.Head) and not ASSettings["AimSleepers"]) then
							return nil;
						end

						local magnitude = (_Character.character.Middle.Position - v.PrimaryPart.Position).magnitude
						if magnitude < shortestDistance then
							closestPlayer = v
							shortestDistance = magnitude
						end
					end
				end
			end

			return closestPlayer
		end

		function dofullbright()
			Light.Ambient = Color3.new(1, 1, 1)
			Light.ColorShift_Bottom = Color3.new(1, 1, 1)
			Light.ColorShift_Top = Color3.new(1, 1, 1)
		end


		loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/FreeCam.lua", true))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/SimpleESP.lua", true))()

		Library:SetWatermark('Gn8med 🤓 Scripts')
		setscriptable(workspace.Terrain, "Decoration", true)
		local Window = Library:CreateWindow({
			Title = 'Gn8med 🤓',
			Center = true,
			AutoShow = true,
		})

		local Tabs = {
			AimBots = Window:AddTab('AimBots'), 
			Misc = Window:AddTab("Misc"),
			Visual = Window:AddTab("Visual"),
			Settings = Window:AddTab('Settings'),
		}

		local aimtabs = Tabs.AimBots:AddTabbox({Side = 1})
		local aimsettabs = Tabs.AimBots:AddTabbox({Side = 2})
		local worldset = Tabs.Misc:AddLeftGroupbox("World Settings")
		local esp = Tabs.Visual:AddLeftGroupbox("ESP")

		local SilentAimTab = aimtabs:AddTab("SilentAim")
		local AimTab = aimtabs:AddTab("AimTab")

		local AimsetTab = aimsettabs:AddTab("AimBot 🛠")

		SilentAimTab:AddToggle('SilentAim_Enabled', {
			Text = 'Enable SilentAim',
			Default = false,
			Tooltip = 'Turns on/off silent aim.',
		})

		Toggles.SilentAim_Enabled:OnChanged(function()
			if Toggles.SilentAim_Enabled.Value then
				_Aimbot["Enabled"] = false;
				Toggles.Aim_Enabled.Value = false;
			end

			_SilentAim["Enabled"] = Toggles.SilentAim_Enabled.Value;
		end)
		SilentAimTab:AddLabel('SilentAim Keybind'):AddKeyPicker('SilentAimbot_Bind', {
			Default = 'MB2',
			Text = 'SilentAim Keybind',
			Tooltip = 'Keybind to silent aimbot.',
			NoUI = false,
			Mode = 'Hold',
		})
		-- Replace Camera function
		local OrginalGetCFrame = _Camera.GetCFrame;
		_Camera.GetCFrame = function()
			if _SilentAim["Enabled"] and _SilentAim["Silent_Target"] then
				return CFrame.new(OrginalGetCFrame().p, _SilentAim["Silent_Target"].Position + Vector3.new((_SilentAim["X_Offset"]), (_SilentAim["Y_Offset"]), 0.001));
			else
				return OrginalGetCFrame();
			end
		end

		wait(0.1)
		task.spawn(function()
			while task.wait() do
				if Options.SilentAimbot_Bind:GetState() and _SilentAim["Enabled"] then
					local Target;
					if ASSettings["AimType"] == "To Cursor" then
						Target = getClosestPlayerToCursor();
					else
						Target = getClosestPlayerToPlayer();
					end
					if Target then
						local Head = Target:FindFirstChild("Head");
						if Head then
							local oldx = Head.Position.X;
							local oldy = Head.Position.Y;
							wait(0.01)
							if ASSettings["Prediction"] == true then
								_SilentAim["X_Offset"] = (Head.Position.X - oldx)*2;
								_SilentAim["Y_Offset"] = (Head.Position.Y - oldy);
							else
								_SilentAim["X_Offset"] = 0
								_SilentAim["Y_Offset"] = 0
							end
							_SilentAim["Silent_Target"] = Head;
						end
					end
				else
					_SilentAim["Silent_Target"] = nil;
				end

				if Library.Unloaded then break end
			end
		end)

		-- // Aimbot \\ --

		-- Aimbot Toggle
		AimTab:AddToggle('Aim_Enabled', {
			Text = 'Enable Aimbot',
			Default = false,
			Tooltip = 'Turns on/off the aimbot.',
		})

		Toggles.Aim_Enabled:OnChanged(function()
			if Toggles.Aim_Enabled.Value then
				_SilentAim["Enabled"] = false;
				Toggles.SilentAim_Enabled.Value = false;
			end

			_Aimbot["Enabled"] = Toggles.Aim_Enabled.Value;
		end)

		-- Aimbot Keybind
		AimTab:AddLabel('Aimbot Keybind'):AddKeyPicker('Aimbot_Bind', {
			Default = 'MB2',
			Text = 'Aimbot Keybind',
			Tooltip = 'Keybind to aimbot.',
			NoUI = false,
			Mode = 'Hold',
		})

		wait(0.1)
		task.spawn(function()
			while task.wait() do
				if Options.Aimbot_Bind:GetState() and _Aimbot["Enabled"] then
					local Target;
					if ASSettings["AimType"] == "To Cursor" then
						Target = getClosestPlayerToCursor();
					else
						Target = getClosestPlayerToPlayer();
					end
					if Target then
						local Head = Target:FindFirstChild("Head");
						if Head then
							local pos, _ = Camera:WorldToScreenPoint(Head.Position)
							local oldx = Head.Position.X;
							local oldy = Head.Position.Y;
							wait(0.01)
							if ASSettings["Prediction"] == true then
								_Aimbot["X_Offset"] = (Head.Position.X - oldx)*2;
								_Aimbot["Y_Offset"] = (Head.Position.Y - oldy);
							else
								_Aimbot["X_Offset"] = 0
								_Aimbot["Y_Offset"] = 0
							end
							mousemoverel((pos.X - (Mouse.X + _Aimbot["X_Offset"]))/_Aimbot["AimSmooth"], (pos.Y - (Mouse.Y + _Aimbot["Y_Offset"]))/_Aimbot["AimSmooth"])
						end
					end
				end

				if Library.Unloaded then break end
			end
		end)

		AimsetTab:AddDropdown('AimTypeDrop', {
			Values = {"To Cursor", "To Player"},
			Default = 1,
			Multi = false,

			Text = 'Target Closest',
			Tooltip = 'Changes how the aimbot/silent aim selects a target.',
		})

		Options.AimTypeDrop:OnChanged(function()
			AimsetTab["AimType"] = Options.AimTypeDrop.Value;
		end)

		-- Aim Distance
		AimsetTab:AddSlider('Aim_Distance', {
			Text = 'Max Distance',
			Default = 200,
			Min = 0,
			Max = 1000,
			Rounding = 0,
			Compact = false,
		})

		Options.Aim_Distance:OnChanged(function()
			ASSettings["AimDis"] = Options.Aim_Distance.Value;
		end)

		-- Visible Check
		AimsetTab:AddToggle('Aim_Visible', {
			Text = 'Visible Check',
			Default = false,
			Tooltip = 'Toggles aiming only if player is visible.',
		})

		Toggles.Aim_Visible:OnChanged(function()
			ASSettings["VisibleCheck"] = Toggles.Aim_Visible.Value;
		end)

		-- Sleeping Aim
		AimsetTab:AddToggle('Aim_Sleepers', {
			Text = 'Aim at Sleepers',
			Default = false,
			Tooltip = 'Toggles aiming at sleeping players.',
		})

		Toggles.Aim_Sleepers:OnChanged(function()
			ASSettings["AimSleepers"] = Toggles.Aim_Sleepers.Value;
		end)

		AimsetTab:AddToggle('Predictions', {
			Text = 'Prediction',
			Default = false,
			Tooltip = 'Toggles predictions.',
		})

		Toggles.Predictions:OnChanged(function()
			ASSettings["Prediction"] = Toggles.Predictions.Value;
		end)


		local uisett = Tabs.Settings:AddLeftGroupbox('Ui Settings')
		local uitheme = Tabs.Settings:AddRightGroupbox('Ui Theme')
		local UnloadButton = uisett:AddButton('Unload', function()
			Library:Unload()
		end)
		uisett:AddToggle('KBTT', {
			Text = 'Gn8med 🤓 Key Binds',
			Default = false,
			Tooltip = 'Off/On Keybind',
		})
		Toggles.KBTT:OnChanged(function(KBTTTT)
			Library.KeybindFrame.Visible = KBTTTT
		end)
		uisett:AddToggle('WMT', {
			Text = 'Watermark',
			Default = false,
			Tooltip = 'Off/On Watermark',
		})
		Toggles.WMT:OnChanged(function(WT)
			Library:SetWatermarkVisibility(WT)
		end)

		uisett:AddInput('WaterMarkText', {
			Default = 'Gn8med 🤓',
			Numeric = false,
			Finished = false,

			Text = 'Gn8med 🤓',
			Tooltip = 'Set Water Mark',

			Placeholder = ' ',
		})


		Options.WaterMarkText:OnChanged(function()
			Library:SetWatermark(Options.WaterMarkText.Value)
		end)

		uisett:AddLabel('Menu bind'):AddKeyPicker('Menubind', {

			Default = 'End',
			SyncToggleState = false, 

			Mode = 'Toggle',

			Text = 'Menu bind',
			NoUI = true,
		})

		Library.ToggleKeybind = Options.Menubind

		worldset:AddToggle('TGT', {
			Text = 'Grass changer',
			Default = false,
			Tooltip = 'Off/On grass',
		})
		Toggles.TGT:OnChanged(function(f)
			workspace.Terrain.Decoration = f
		end)
		worldset:AddToggle('FBT', {
			Text = 'Full Bright',
			Default = false,
			Tooltip = 'Off/On Full Bright',
		})
		Toggles.FBT:OnChanged(function(f)
			if f == true then
				dofullbright()
			else
				Light.Ambient = Color3.new(0.364706, 0.364706, 0.364706)
				Light.ColorShift_Bottom = Color3.new(0, 0, 0)
				Light.ColorShift_Top = Color3.new(0, 0, 0)
			end
		end)
		worldset:AddToggle('BHB', {
			Text = 'Big Heads',
			Default = false,
			Tooltip = 'Off/On Esp',
		})
		Toggles.BHB:OnChanged(function(f)
			if f == true then
				for v,i in pairs(workspace:GetChildren()) do
					if i:FindFirstChild("Humanoid") then
						local FakeHead = Instance.new("Part",i)
						FakeHead.CFrame = i.Head.CFrame * CFrame.new(0,-1.5,0)
						FakeHead.Name = "Head"
						FakeHead.Size = Vector3.new(4,5,2.5)
						FakeHead.Anchored = true
						FakeHead.CanCollide = false
						FakeHead.Transparency = 0.9
					end
				end
				local FakeHead = Instance.new("Part",game.ReplicatedStorage.Player)
				FakeHead.CFrame = game.ReplicatedStorage.Player.Head.CFrame * CFrame.new(0,-1.5,0)
				FakeHead.Name = "Head"
				FakeHead.Size = Vector3.new(4,5,2.5)
				FakeHead.Anchored = true
				FakeHead.CanCollide = false
				FakeHead.Transparency = 0.9
			else
				for v,i in pairs(workspace:GetChildren()) do
					if i:FindFirstChild("Humanoid") then
						for v,i in pairs(i:GetChildren()) do
							if i.Name == "Head" and i.Size == Vector3.new(4,5,2.5) then
								i:Remove()
							end
						end
					end
				end

				for v,i in pairs(game.ReplicatedStorage.Player:GetChildren()) do
					if i.Name == "Head" and i.Size == Vector3.new(4,5,2.5) then
						i:Remove()
					end
				end
			end
		end)

		worldset:AddLabel('Noclip'):AddKeyPicker('Noclip_Toggle', {
			Default = 'V',
			Text = 'Toggle Noclip',
			Tooltip = 'Noclip!',
			NoUI = false,
		})

		Options.Noclip_Toggle:OnClick(function()
			if not _Toggles["Noclip"] then
				_Toggles["Noclip"] = true;
				_Character.SetNoclipping(true);
			else
				_Toggles["Noclip"] = false;
				_Character.SetNoclipping(false);
			end
		end)

		worldset:AddLabel('Free Cam'):AddKeyPicker('Free_Cam', {
			Default = 'B',
			Text = 'Free Cam',
			Tooltip = 'Allows you to go into a free cam mode.',
			NoUI = false,
		})

		Options.Free_Cam:OnClick(function()
			ToggleFreecam();
		end)

		esp:AddToggle('ESPT', {
			Text = 'Esp Toggle',
			Default = false,
			Tooltip = 'Off/On Esp',
		})
		Toggles.ESPT:OnChanged(function(f)
			_Player.SetEsp(f);
		end)


		ThemeManager.Library = Library
		ThemeManager:CreateThemeManager(uitheme)
		