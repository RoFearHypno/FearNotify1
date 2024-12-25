-- HUGE THANKS TO 'Lucide' FOR SUPPLYING THE ICON LIB (And rayfield for making the huge list of icon ids)

local Icons = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/icons.lua'))()

local NotifGui = Instance.new("ScreenGui")
local Notifcations = Instance.new("Folder")

local CoreGui = game:GetService("CoreGui")

local Library = {}

if gethui then
	NotifGui.Parent = gethui()
elseif syn and syn.protect_gui then 
	syn.protect_gui(NotifGui)
	NotifGui.Parent = CoreGui
elseif CoreGui:FindFirstChild("RobloxGui") then
	NotifGui.Parent = CoreGui:FindFirstChild("RobloxGui")
else
	NotifGui.Parent = CoreGui
end

function GetIcon(name : string)
	name = string.match(string.lower(name), "^%s*(.*)%s*$") :: string
	local sizedicons = Icons['48px']

	local r = sizedicons[name]
	if not r then
		error("Lucide Icons: Failed to find icon by the name of \"" .. name .. "\".", 2)
	end

	local rirs = r[2]
	local riro = r[3]

	if type(r[1]) ~= "number" or type(rirs) ~= "table" or type(riro) ~= "table" then
		error("Lucide Icons: Internal error: Invalid auto-generated asset entry")
	end

	local irs = Vector2.new(rirs[1], rirs[2])
	local iro = Vector2.new(riro[1], riro[2])

	local asset = {
		id = r[1],
		imageRectSize = irs,
		imageRectOffset = iro,
	}

	return asset
end

function LimitNotifs()
	
end

function CreateNotifGui()
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.65,0,0,45)
	frame.Position = UDim2.new(0.5,0,0,0)
	frame.AnchorPoint = Vector2.new(0.5,0)
	frame.BackgroundTransparency = 1
	
	local icon1 = Instance.new("ImageLabel")
	icon1.Size = UDim2.new(0.05,0,1,0)
	icon1.BackgroundTransparency = 1
	icon1.LayoutOrder = 1
	icon1.Name = "icon1"
	local icon2 = Instance.new("ImageLabel")
	icon2.Size = UDim2.fromScale(0.05,0,1,0)
	icon2.BackgroundTransparency = 1
	icon2.LayoutOrder = 3
	icon2.Name = "icon2"
	
	local message = Instance.new("TextLabel")
	message.Size = UDim2.new(0,0,1,0)
	message.LayoutOrder = 2
	message.BackgroundTransparency = 0
	message.Name = "message"
	
	local uilistlayout = Instance.new("UIListLayout")
	uilistlayout.FillDirection = Enum.FillDirection.Horizontal
	uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uilistlayout.Padding = UDim.new(0,0)
	uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	uilistlayout.Parent = frame
	message.Parent = frame
	icon1.Parent = frame 
	icon2.Parent = frame 
	frame.Parent = NotifGui
	
	return frame
end

function GetMissingArg(data:{}, default:{})
	local cma = {}
	local str = ""
	for n, v in next, default do
		if not data[tostring(n)] then table.insert(cma,tostring(n)) end
	end
	for i, n in cma do
		if #cma>1 then if i ~= #cma then str = str..n..", " else str = str..n end elseif #cma==1 then str = n end
	end
	
	return (#cma>1) and "Missing Args: "..str or (#cma==1) and "Missing Arg: "..str or "Unknown"
end

function Library:Notify(data: {})
	local title: string = data["title"]
	local icon: string = data["icon"]
	local duration: number = data["duration"]
	
	if not title or not icon or not duration then 
		error("Invalid arguments. "..GetMissingArg(data, {title="",icon="",duration=0}.."!")) 
		return
	end
	
	warn("No invalid args")
	warn(title, icon, duration)
	
	icon = GetIcon(icon)
	if icon == nil then return end
	
	--warn(icon.id)
	
	local frame = CreateNotifGui()
	
	frame:FindFirstChild("message").Text = title
	
	local textBoundsSize = frame:FindFirstChild("message").TextBounds
	frame:FindFirstChild("message").Size = UDim2.new(0, textBoundsSize.X + 25, 1, 0)
	
	frame:FindFirstChild("icon1").ImageRectOffset = icon.imageRectOffset
	frame:FindFirstChild("icon1").ImageRectSize = icon.imageRectSize
	
	frame:FindFirstChild("icon2").ImageRectOffset = icon.imageRectOffset
	frame:FindFirstChild("icon2").ImageRectSize = icon.imageRectSize
	
	icon = "rbxassetid://"..tostring(icon.id)
	frame:FindFirstChild("icon1").Image = icon
	frame:FindFirstChild("icon2").Image = icon	
	
	task.delay(duration, function()
		frame:Destroy()
	end)
end

-- Library

return Library
