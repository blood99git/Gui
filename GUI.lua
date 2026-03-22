-- JesterUI v1
-- Minimal, modern, smooth UI library
-- Satu file, siap dipakai ulang
-- Fitur nanti tinggal diisi di callback button/toggle

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local JesterUI = {}
JesterUI.__index = JesterUI

JesterUI.Theme = {
	Accent = Color3.fromRGB(0, 235, 255),
	Background = Color3.fromRGB(12, 12, 14),
	Panel = Color3.fromRGB(18, 18, 22),
	Panel2 = Color3.fromRGB(24, 24, 30),
	Stroke = Color3.fromRGB(42, 42, 50),
	Text = Color3.fromRGB(245, 245, 245),
	Muted = Color3.fromRGB(170, 170, 180),
	Shadow = Color3.fromRGB(0, 0, 0),
}

local function tween(obj, info, props)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = radius or UDim.new(0, 10)
	c.Parent = parent
	return c
end

local function stroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or JesterUI.Theme.Stroke
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0
	s.Parent = parent
	return s
end

local function padding(parent, l, r, t, b)
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, l or 0)
	p.PaddingRight = UDim.new(0, r or 0)
	p.PaddingTop = UDim.new(0, t or 0)
	p.PaddingBottom = UDim.new(0, b or 0)
	p.Parent = parent
	return p
end

local function getParentGui()
	local ok, gui = pcall(function()
		return CoreGui
	end)
	if ok and gui then
		return gui
	end

	local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if playerGui then
		return playerGui
	end

	return game:GetService("StarterGui")
end

function JesterUI:SetTheme(themeTable)
	for k, v in pairs(themeTable) do
		self.Theme[k] = v
	end
end

function JesterUI:CreateWindow(config)
	config = config or {}

	local title = config.Title or "JesterUI"
	local subtitle = config.Subtitle or "minimal theme"
	local size = config.Size or UDim2.new(0, 620, 0, 390)
	local position = config.Position or UDim2.new(0.5, 0, 0.5, 0)

	local gui = Instance.new("ScreenGui")
	gui.Name = "JesterUI_" .. title
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = getParentGui()

	local shadow = Instance.new("Frame")
	shadow.Name = "Shadow"
	shadow.Parent = gui
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = position
	shadow.Size = size
	shadow.BackgroundColor3 = self.Theme.Shadow
	shadow.BackgroundTransparency = 0.55
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 1
	corner(shadow, UDim.new(0, 16))

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Parent = gui
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.Position = position
	main.Size = size
	main.BackgroundColor3 = self.Theme.Background
	main.BorderSizePixel = 0
	main.ZIndex = 2
	corner(main, UDim.new(0, 16))
	stroke(main, self.Theme.Stroke, 1, 0.15)

	local accentTop = Instance.new("Frame")
	accentTop.Name = "AccentTop"
	accentTop.Parent = main
	accentTop.Size = UDim2.new(1, 0, 0, 2)
	accentTop.BackgroundColor3 = self.Theme.Accent
	accentTop.BorderSizePixel = 0
	accentTop.ZIndex = 3

	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Parent = main
	topBar.Size = UDim2.new(1, 0, 0, 48)
	topBar.BackgroundColor3 = self.Theme.Panel
	topBar.BorderSizePixel = 0
	topBar.ZIndex = 3
	corner(topBar, UDim.new(0, 16))

	local topBarCut = Instance.new("Frame")
	topBarCut.Name = "TopBarCut"
	topBarCut.Parent = topBar
	topBarCut.AnchorPoint = Vector2.new(0, 1)
	topBarCut.Position = UDim2.new(0, 0, 1, 0)
	topBarCut.Size = UDim2.new(1, 0, 0, 16)
	topBarCut.BackgroundColor3 = self.Theme.Panel
	topBarCut.BorderSizePixel = 0
	topBarCut.ZIndex = 3

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Parent = topBar
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 16, 0, 5)
	titleLabel.Size = UDim2.new(0.7, 0, 0, 20)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = title
	titleLabel.TextColor3 = self.Theme.Text
	titleLabel.TextSize = 17
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 4

	local subLabel = Instance.new("TextLabel")
	subLabel.Parent = topBar
	subLabel.BackgroundTransparency = 1
	subLabel.Position = UDim2.new(0, 16, 0, 24)
	subLabel.Size = UDim2.new(0.7, 0, 0, 16)
	subLabel.Font = Enum.Font.Gotham
	subLabel.Text = subtitle
	subLabel.TextColor3 = self.Theme.Muted
	subLabel.TextSize = 12
	subLabel.TextXAlignment = Enum.TextXAlignment.Left
	subLabel.ZIndex = 4

	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Name = "Minimize"
	minimizeBtn.Parent = topBar
	minimizeBtn.BackgroundTransparency = 1
	minimizeBtn.Size = UDim2.new(0, 34, 0, 34)
	minimizeBtn.Position = UDim2.new(1, -76, 0, 7)
	minimizeBtn.Font = Enum.Font.GothamBold
	minimizeBtn.Text = "–"
	minimizeBtn.TextColor3 = self.Theme.Accent
	minimizeBtn.TextSize = 24
	minimizeBtn.AutoButtonColor = false
	minimizeBtn.ZIndex = 4

	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "Close"
	closeBtn.Parent = topBar
	closeBtn.BackgroundTransparency = 1
	closeBtn.Size = UDim2.new(0, 34, 0, 34)
	closeBtn.Position = UDim2.new(1, -40, 0, 7)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Text = "X"
	closeBtn.TextColor3 = self.Theme.Accent
	closeBtn.TextSize = 20
	closeBtn.AutoButtonColor = false
	closeBtn.ZIndex = 4

	local body = Instance.new("Frame")
	body.Name = "Body"
	body.Parent = main
	body.BackgroundTransparency = 1
	body.Position = UDim2.new(0, 0, 0, 48)
	body.Size = UDim2.new(1, 0, 1, -48)
	body.ZIndex = 2

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Parent = body
	sidebar.Size = UDim2.new(0, 150, 1, 0)
	sidebar.BackgroundColor3 = self.Theme.Panel
	sidebar.BorderSizePixel = 0
	sidebar.ZIndex = 3
	corner(sidebar, UDim.new(0, 14))

	local sidebarCut = Instance.new("Frame")
	sidebarCut.Parent = sidebar
	sidebarCut.AnchorPoint = Vector2.new(0, 1)
	sidebarCut.Position = UDim2.new(0, 0, 1, 0)
	sidebarCut.Size = UDim2.new(1, 0, 0, 16)
	sidebarCut.BackgroundColor3 = self.Theme.Panel
	sidebarCut.BorderSizePixel = 0
	sidebarCut.ZIndex = 3

	padding(sidebar, 10, 10, 10, 10)

	local tabList = Instance.new("Frame")
	tabList.Name = "TabList"
	tabList.Parent = sidebar
	tabList.BackgroundTransparency = 1
	tabList.Size = UDim2.new(1, 0, 1, 0)
	tabList.ZIndex = 4

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Parent = tabList
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Padding = UDim.new(0, 8)

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Parent = body
	content.Position = UDim2.new(0, 160, 0, 0)
	content.Size = UDim2.new(1, -160, 1, 0)
	content.BackgroundTransparency = 1
	content.ZIndex = 2

	local contentPadding = Instance.new("UIPadding")
	contentPadding.Parent = content
	contentPadding.PaddingTop = UDim.new(0, 6)
	contentPadding.PaddingLeft = UDim.new(0, 0)
	contentPadding.PaddingRight = UDim.new(0, 12)
	contentPadding.PaddingBottom = UDim.new(0, 12)

	local window = {}
	window.Gui = gui
	window.Main = main
	window.Body = body
	window.Sidebar = sidebar
	window.Content = content
	window._tabs = {}
	window._currentTab = nil
	window._minimized = false

	local function selectTab(tabName)
		for name, tab in pairs(window._tabs) do
			if tab.Page then
				if name == tabName then
					tab.Page.Visible = true
					tab.Page.GroupTransparency = 1
					tab.Page.Position = UDim2.new(0, 0, 0, 6)
					tween(tab.Page, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						GroupTransparency = 0,
						Position = UDim2.new(0, 0, 0, 0)
					})
					if tab.Button then
						tween(tab.Button, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							BackgroundColor3 = self.Theme.Panel2
						})
					end
				else
					tab.Page.Visible = false
					if tab.Button then
						tween(tab.Button, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							BackgroundColor3 = self.Theme.Panel
						})
					end
				end
			end
		end
		window._currentTab = tabName
	end

	function window:CreateTab(tabName)
		local tabBtn = Instance.new("TextButton")
		tabBtn.Name = tabName .. "_Tab"
		tabBtn.Parent = tabList
		tabBtn.Size = UDim2.new(1, 0, 0, 36)
		tabBtn.BackgroundColor3 = self.Theme.Panel
		tabBtn.BorderSizePixel = 0
		tabBtn.AutoButtonColor = false
		tabBtn.Text = ""
		tabBtn.ZIndex = 5
		corner(tabBtn, UDim.new(0, 10))
		stroke(tabBtn, self.Theme.Stroke, 1, 0.2)

		local tabText = Instance.new("TextLabel")
		tabText.Parent = tabBtn
		tabText.BackgroundTransparency = 1
		tabText.Size = UDim2.new(1, -14, 1, 0)
		tabText.Position = UDim2.new(0, 14, 0, 0)
		tabText.Font = Enum.Font.GothamSemibold
		tabText.Text = tabName
		tabText.TextColor3 = self.Theme.Text
		tabText.TextSize = 13
		tabText.TextXAlignment = Enum.TextXAlignment.Left
		tabText.ZIndex = 6

		local indicator = Instance.new("Frame")
		indicator.Parent = tabBtn
		indicator.Size = UDim2.new(0, 3, 0, 18)
		indicator.Position = UDim2.new(0, 6, 0.5, -9)
		indicator.BackgroundColor3 = self.Theme.Accent
		indicator.BorderSizePixel = 0
		indicator.ZIndex = 6
		corner(indicator, UDim.new(1, 0))

		local page = Instance.new("CanvasGroup")
		page.Name = tabName .. "_Page"
		page.Parent = content
		page.Visible = false
		page.GroupTransparency = 1
		page.BackgroundTransparency = 1
		page.Size = UDim2.new(1, 0, 1, 0)
		page.ZIndex = 2

		local pageLayout = Instance.new("UIListLayout")
		pageLayout.Parent = page
		pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		pageLayout.Padding = UDim.new(0, 10)

		local pagePad = Instance.new("UIPadding")
		pagePad.Parent = page
		pagePad.PaddingTop = UDim.new(0, 4)
		pagePad.PaddingLeft = UDim.new(0, 4)
		pagePad.PaddingRight = UDim.new(0, 4)
		pagePad.PaddingBottom = UDim.new(0, 4)

		local tab = {}
		tab.Button = tabBtn
		tab.Page = page
		tab.Name = tabName

		function tab:AddSection(text)
			local section = Instance.new("Frame")
			section.Parent = page
			section.BackgroundColor3 = JesterUI.Theme.Panel
			section.BorderSizePixel = 0
			section.Size = UDim2.new(1, 0, 0, 34)
			section.ZIndex = 3
			corner(section, UDim.new(0, 10))
			stroke(section, JesterUI.Theme.Stroke, 1, 0.3)

			local label = Instance.new("TextLabel")
			label.Parent = section
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(1, -16, 1, 0)
			label.Position = UDim2.new(0, 12, 0, 0)
			label.Font = Enum.Font.GothamSemibold
			label.Text = text
			label.TextColor3 = JesterUI.Theme.Muted
			label.TextSize = 12
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.ZIndex = 4

			return section
		end

		function tab:AddLabel(text, height)
			local row = Instance.new("Frame")
			row.Parent = page
			row.BackgroundColor3 = JesterUI.Theme.Panel
			row.BorderSizePixel = 0
			row.Size = UDim2.new(1, 0, 0, height or 42)
			row.ZIndex = 3
			corner(row, UDim.new(0, 10))
			stroke(row, JesterUI.Theme.Stroke, 1, 0.35)

			local label = Instance.new("TextLabel")
			label.Parent = row
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(1, -16, 1, 0)
			label.Position = UDim2.new(0, 12, 0, 0)
			label.Font = Enum.Font.Gotham
			label.Text = text
			label.TextColor3 = JesterUI.Theme.Text
			label.TextSize = 13
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.ZIndex = 4

			return row
		end

		function tab:AddButton(text, callback)
			callback = callback or function() end

			local btn = Instance.new("TextButton")
			btn.Parent = page
			btn.Size = UDim2.new(1, 0, 0, 42)
			btn.BackgroundColor3 = JesterUI.Theme.Panel2
			btn.BorderSizePixel = 0
			btn.AutoButtonColor = false
			btn.Text = ""
			btn.ZIndex = 3
			corner(btn, UDim.new(0, 10))
			stroke(btn, JesterUI.Theme.Stroke, 1, 0.25)

			local label = Instance.new("TextLabel")
			label.Parent = btn
			label.BackgroundTransparency = 1
			label.Position = UDim2.new(0, 14, 0, 0)
			label.Size = UDim2.new(1, -30, 1, 0)
			label.Font = Enum.Font.GothamSemibold
			label.Text = text
			label.TextColor3 = JesterUI.Theme.Text
			label.TextSize = 13
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.ZIndex = 4

			local accent = Instance.new("Frame")
			accent.Parent = btn
			accent.Size = UDim2.new(0, 3, 0, 18)
			accent.Position = UDim2.new(1, -14, 0.5, -9)
			accent.BackgroundColor3 = JesterUI.Theme.Accent
			accent.BorderSizePixel = 0
			accent.ZIndex = 4
			corner(accent, UDim.new(1, 0))

			btn.MouseEnter:Connect(function()
				tween(btn, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = JesterUI.Theme.Background
				})
			end)

			btn.MouseLeave:Connect(function()
				tween(btn, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = JesterUI.Theme.Panel2
				})
			end)

			btn.MouseButton1Click:Connect(function()
				tween(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(1, 0, 0, 40)
				})
				task.delay(0.08, function()
					if btn and btn.Parent then
						tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(1, 0, 0, 42)
						})
					end
				end)
				callback()
			end)

			return btn
		end

		function tab:AddToggle(text, default, callback)
			local state = default and true or false
			callback = callback or function() end

			local row = Instance.new("Frame")
			row.Parent = page
			row.Size = UDim2.new(1, 0, 0, 42)
			row.BackgroundColor3 = JesterUI.Theme.Panel2
			row.BorderSizePixel = 0
			row.ZIndex = 3
			corner(row, UDim.new(0, 10))
			stroke(row, JesterUI.Theme.Stroke, 1, 0.25)

			local label = Instance.new("TextLabel")
			label.Parent = row
			label.BackgroundTransparency = 1
			label.Position = UDim2.new(0, 14, 0, 0)
			label.Size = UDim2.new(1, -100, 1, 0)
			label.Font = Enum.Font.GothamSemibold
			label.Text = text
			label.TextColor3 = JesterUI.Theme.Text
			label.TextSize = 13
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.ZIndex = 4

			local toggle = Instance.new("TextButton")
			toggle.Parent = row
			toggle.Size = UDim2.new(0, 50, 0, 24)
			toggle.Position = UDim2.new(1, -64, 0.5, -12)
			toggle.BackgroundColor3 = state and JesterUI.Theme.Accent or JesterUI.Theme.Background
			toggle.BorderSizePixel = 0
			toggle.AutoButtonColor = false
			toggle.Text = ""
			toggle.ZIndex = 4
			corner(toggle, UDim.new(1, 0))
			stroke(toggle, JesterUI.Theme.Stroke, 1, 0.25)

			local knob = Instance.new("Frame")
			knob.Parent = toggle
			knob.Size = UDim2.new(0, 18, 0, 18)
			knob.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
			knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
			knob.BorderSizePixel = 0
			knob.ZIndex = 5
			corner(knob, UDim.new(1, 0))

			local function render()
				tween(toggle, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = state and JesterUI.Theme.Accent or JesterUI.Theme.Background
				})
				tween(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
				})
			end

			toggle.MouseButton1Click:Connect(function()
				state = not state
				render()
				callback(state)
			end)

			render()
			return {
				Set = function(_, value)
					state = value and true or false
					render()
					callback(state)
				end,
				Get = function()
					return state
				end
			}
		end

		function tab:AddSpacer(height)
			local spacer = Instance.new("Frame")
			spacer.Parent = page
			spacer.BackgroundTransparency = 1
			spacer.Size = UDim2.new(1, 0, 0, height or 6)
			spacer.ZIndex = 2
			return spacer
		end

		tabBtn.MouseButton1Click:Connect(function()
			selectTab(tabName)
		end)

		window._tabs[tabName] = tab

		if not window._currentTab then
			selectTab(tabName)
		end

		return tab
	end

	function window:SetTitle(newTitle)
		titleLabel.Text = newTitle or title
	end

	function window:Minimize()
		if self._minimized then
			return
		end
		self._minimized = true
		tween(main, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 48)
		})
		body.Visible = false
	end

	function window:Restore()
		if not self._minimized then
			return
		end
		self._minimized = false
		body.Visible = true
		tween(main, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = size
		})
	end

	function window:ToggleMinimize()
		if self._minimized then
			self:Restore()
		else
			self:Minimize()
		end
	end

	function window:Destroy()
		gui:Destroy()
	end

	minimizeBtn.MouseButton1Click:Connect(function()
		window:ToggleMinimize()
	end)

	closeBtn.MouseButton1Click:Connect(function()
		local fade1 = tween(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1
		})
		tween(shadow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1
		})
		task.delay(0.22, function()
			if gui then
				gui:Destroy()
			end
		end)
	end)

	do
		local dragging = false
		local dragStart
		local startPos

		topBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = main.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				main.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
				shadow.Position = main.Position
			end
		end)
	end

	-- animasi masuk
	main.Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 0)
	main.BackgroundTransparency = 1
	shadow.BackgroundTransparency = 1
	tween(main, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = size,
		BackgroundTransparency = 0
	})
	tween(shadow, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.55
	})

	return window
end

_G.JesterUI = JesterUI

-- =========================
-- CONTOH PEMAKAIAN
-- =========================
-- local Window = JesterUI:CreateWindow({
--     Title = "Jester Theme",
--     Subtitle = "minimal modern smooth",
-- })
--
-- local Main = Window:CreateTab("Main")
-- Main:AddSection("Core")
-- Main:AddButton("Test Button", function()
--     print("Button diklik")
-- end)
-- Main:AddToggle("Test Toggle", false, function(state)
--     print("Toggle:", state)
-- end)