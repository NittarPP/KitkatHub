--[[
Look My LICENSE
https://raw.githubusercontent.com/NittarPP/KitkatHub/refs/heads/main/LICENSE
]]

local response = request({
    Url = "https://httpbin.org/user-agent",
    Method = "GET",
})
assert(type(response) == "table", "Response must be a table")
assert(response.StatusCode == 200, "Did not return a 200 status code")
local data = game:GetService("HttpService"):JSONDecode(response.Body)
assert(type(data) == "table" and type(data["user-agent"]) == "string", "Did not return a table with a user-agent key")

if not (data["user-agent"]:lower():match("flexer") or data["user-agent"]:lower():match("xeno")) then
    game.Players.LocalPlayer:Kick("KitKat Hub Not Support: " .. data["user-agent"])
end



local pd = game.placeId

if pd == 9621271261 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/NittarPP/KitkatHub/refs/heads/main/Script/Whitreper.lua"))()
else
    game.Players.LocalPlayer:Kick("KitKat Hub Not Support This game")
end
