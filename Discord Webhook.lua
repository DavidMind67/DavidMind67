local Players = game:GetService("Players")
local http = game:GetService("HttpService")
local webhook = "" -- YOUR WEBHOOK HERE
Players.PlayerAdded:Connect(function(plr)
	print(plr.Name .. " connected.")
	local data = 
		{
			["contents"] = "",
			["embeds"] = {{
				["title"]= plr.name,
				["description"] = "player joined",
				["type"]= "rich",
				["color"]= tonumber(0x36393e),
				["fields"]={
					{
						["name"]="New Visitor",
						["value"]="User: **"..plr.Name.."** with ID: **"..plr.UserId.."** has joined [Profile](https://www.roblox.com/users/"..plr.UserId.."/profile)",
						["inline"]=true}}}}
		}
	http:PostAsync(webhook,http:JSONEncode(data))
end)

Players.PlayerRemoving:Connect(function(plr)
	print(plr.Name .. " disconnected.")
	local leavedata = 
		{
			["contents"] = "",
			["embeds"] = {{
				["title"]= plr.name,
				["description"] = "player left",
				["type"]= "rich",
				["color"]= tonumber(0x36393e),
				["fields"]={
					{
						["name"]="Player left the game",
						["value"]="User: **"..plr.Name.."** with ID: **"..plr.UserId.."** left [Profile](https://www.roblox.com/users/"..plr.UserId.."/profile)",
						["inline"]=true}}}}
		}
	http:PostAsync(webhook,http:JSONEncode(leavedata))
end)
