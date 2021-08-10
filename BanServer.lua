--variables
local BanRec = game:GetService("DataStoreService"):GetDataStore("Bans")
local Cool = game:GetService("DataStoreService"):GetDataStore("Data")
local Rep = game:GetService("ReplicatedStorage")
local GS = Rep:WaitForChild("GameStats")
local fol = Rep:WaitForChild("Events")
local http = game:GetService("HttpService")
local webhook = "" -- YOUR WEBHOOK HERE
local groupid = 0 -- YOUR GROUP ID HERE
local rank = 0 -- YOUR ADMINS RANKS

--Ban

fol:WaitForChild("Ban").OnServerEvent:Connect(function(player, user, reason, date) -- ARGUEMENTS YOU WILL BE SENDING FROM CLIENT (Name of the player, reason, time in days)
    if player:GetRankInGroup(groupid) <= rank then
        if game.Players:GetUserIdFromNameAsync(user) then
            local found = game.Players:FindFirstChild(user)
            local offlineKey = "BanKey-".. game.Players:GetUserIdFromNameAsync(user)
            local record = BanRec:GetAsync(offlineKey)
            local bansave = {date * 86400 + os.time(), reason, record[3] + 1}
            BanRec:SetAsync(offlineKey, bansave)
            if found then
                player:Kick("\nYou have been banned.\nWith the reason of: ".. reason .. ".\nYou'll be unbanned in: ".. date * 86400 .." day(s).")
            end
        end
	end
	local data = {
		['embeds'] = {{

			['title'] = "Ban",
			['description'] = player.Name .." has banned: " .. user .. ". With the reason of: " .. reason .. ". They will be unbanned in: " .. date .. " day(s).",
			['color'] = 0
		}}
	}

	local finalData = http:JSONEncode(data)
	http:PostAsync(webhook, finalData)
end)

--Unban

fol:WaitForChild("Unban").OnServerEvent:Connect(function(player, user) --ARGUEMENTS()
    if player:GetRankInGroup(groupid) <= rank then
        if game.Players:GetUserIdFromNameAsync(user) then
            local Key = "BanKey-".. game.Players:GetUserIdFromNameAsync(user)
            local record = BanRec:GetAsync(Key)
            local bansave = {0, "Not Banned", record[3]}
            BanRec:SetAsync(Key, bansave)
        end
	end
    local data = {
        ['embeds'] = {{

            ['title'] = "UnBan",
            ['description'] = player.Name .." has unbanned: " .. user,
            ['color'] = 0
        }}
    }
    local finalData = http:JSONEncode(data)
    http:PostAsync(webhook, finalData)
end)

--PERM BAN

fol:WaitForChild("Ban2").OnServerEvent:Connect(function(player, user, reason)
    if player:GetRankInGroup(groupid) <= rank then
        if game.Players:GetUserIdFromNameAsync(user) then
            local Key = "BanKey-".. game.Players:GetUserIdFromNameAsync(user)
            local record = BanRec:GetAsync(Key)
            local bansave = {123, reason, record[3]}
            BanRec:SetAsync(Key, bansave)
        end
    end
    local data = {
        ['embeds'] = {{

            ['title'] = "UnBan",
            ['description'] = player.Name .." has permanently banned: " .. user .. ". With the reason of: " .. reason,
            ['color'] = 0
        }}
    }
    local finalData = http:JSONEncode(data)
    http:PostAsync(webhook, finalData)
end)

fol:WaitForChild("FetchRecords").OnServerEvent:Connect(function(player, target)
    if player:GetRankInGroup(groupid) <= rank then
        local Key = "BanKey-".. game.Players:GetUserIdFromNameAsync(user)
		local record = BanRec:GetAsync(Key)
        if game.Players:GetUserIdFromNameAsync(user) then
            if record then
                return record[3]
            else
                return "No Ban Record for player was found"
            end
        end
    end
end)

--Kick

fol:WaitForChild("Kick").OnServerEvent:Connect(function(plr, user, reason)
	local found = game.Players:FindFirstChild(user)
    if player:GetRankInGroup(groupid) <= rank then
        local data = {
			['embeds'] = {{

				['title'] = "UnBan",
				['description'] = player.Name .." has kicked: " .. user,
				['color'] = 0
			}}
		}
		local finalData = http:JSONEncode(data)
		http:PostAsync(webhook, finalData)
		found:Kick("\nWith the reason of: ".. reason)
	end
end)

-- kicking banned ones

game.Players.PlayerAdded:Connect(function(player)
	local key = "BanKey-"..player.UserId
	local previousData = BanRec:GetAsync(key)
	local record = BanRec:GetAsync(key)
	if previousData ~= nil then
		if record[1] > os.time() then
            local data = {
                ['embeds'] = {{
    
                    ['title'] = "UnBan",
                    ['description'] = player.Name .." has tried to join. Their ban will expire in: " .. math.floor((record[1] - os.time()) / 86400 + 0.5) .. " day(s).",
                    ['color'] = 0
                }}
            }
            local finalData = http:JSONEncode(data)
            http:PostAsync(webhook, finalData)
			player:Kick("\nYou're banned.\nWith the reason of: ".. record[2] .. ".\nYou'll be unbanned in: ".. math.floor((record[1] - os.time()) / 86400 + 0.5).." day(s).")
        elseif record[1] == 123 then
            local data = {
                ['embeds'] = {{
    
                    ['title'] = "UnBan",
                    ['description'] = player.Name .." has tried to join. They were permanently banned.",
                    ['color'] = 0
                }}
            }
            local finalData = http:JSONEncode(data)
            http:PostAsync(webhook, finalData)
			player:Kick("\nYou're permanently from this game.\nWith the reason of: " .. record[2])
		end
	else
		local bansave = {1, "Not Banned", 0}
		BanRec:SetAsync(key,bansave)
	end
end)