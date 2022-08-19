util.AddNetworkString("chakra_refuse")
util.AddNetworkString("chakra_reset")
util.AddNetworkString("chakra_error")
util.AddNetworkString("chakra_add")
util.AddNetworkString("chakra_auto_add")
util.AddNetworkString("chakra_set")
util.AddNetworkString("chakra_max")
util.AddNetworkString("chakra_info")
util.AddNetworkString("chakra_config_auto_max")
util.AddNetworkString("chakra_config_auto_min")
util.AddNetworkString("chakra_config_auto_time")
util.AddNetworkString("chakra_config_info")

local config = {}

if !file.Exists("lddschakra", "data") then
    file.CreateDir("lddschakra")
end

if !file.Exists("lddschakra/config.json", "DATA") then
    local config = {
        min = 2,
        max = 6,
        time = 360
    }
    file.Write("lddschakra/config.json", util.TableToJSON(config))
else
    config = util.JSONToTable(file.Read("lddschakra/config.json", "DATA"))
end

hook.Add("PlayerInitialSpawn", "Player_Chakra_Init", function(ply)
    local table = {
        ["Awaken"] = false,
        ["Chakra"] = math.random(600, 1000)
    }

    if !file.Exists("lddschakra/" .. ply:SteamID64() .. ".txt", "data") then
        file.Write("lddschakra/" .. ply:SteamID64() .. ".txt", util.TableToJSON(table))
    elseif file.Size("lddschakra/" .. ply:SteamID64() .. ".txt", "DATA") == 0 then
        file.Write("lddschakra/" .. ply:SteamID64() .. ".txt", util.TableToJSON(table))
    end
end)

net.Receive("chakra_reset", function(len, ply)
    if ply:IsSuperAdmin() then
        local args = net.ReadTable()
        if args[1] == nil or !file.Exists("lddschakra/" .. args[1] .. ".txt", "data") then
            net.Start("chakra_error")
            net.Send(ply)
        else
            local table = util.JSONToTable(file.Read("lddschakra/" .. args[1] .. ".txt", "DATA"))
            table.Chakra = math.random(600, 1000)
            file.Write("lddschakra/" .. args[1] .. ".txt", util.TableToJSON(table))
        end
    else
        net.Start("chakra_refuse")
        net.Send(ply)
    end
end)

net.Receive("chakra_info", function(len, ply)
    if ply:IsSuperAdmin() then
        local args = net.ReadTable()
        if args[1] == nil or !file.Exists("lddschakra/" .. args[1] .. ".txt", "data") then
            net.Start("chakra_error")
            net.Send(ply)
        else
            local table = util.JSONToTable(file.Read("lddschakra/" .. args[1] .. ".txt", "DATA"))
            net.Start("chakra_info")
            net.WriteTable(table)
            net.Send(ply)
        end
    else
        net.Start("chakra_refuse")
        net.Send(ply)
    end
end)

net.Receive("chakra_add", function(len, ply)
    if ply:IsSuperAdmin() then
        local args = net.ReadTable()
        if file.Exists("lddschakra/" .. args[1] .. ".txt", "data") then
            local table = util.JSONToTable(file.Read("lddschakra/" .. args[1] .. ".txt", "DATA"))
            table.Chakra = table.Chakra + args[2]
            file.Write("lddschakra/" .. args[1] .. ".txt", util.TableToJSON(table))
        else
            net.Start("chakra_error")
            net.Send(ply)
        end
    else
        net.Start("chakra_refuse")
        net.Send(ply)
    end
end)

net.Receive("chakra_set", function(len, ply)
    if ply:IsSuperAdmin() then
        local args = net.ReadTable()
        if file.Exists("lddschakra/" .. args[1] .. ".txt", "data") then
            local table = util.JSONToTable(file.Read("lddschakra/" .. args[1] .. ".txt", "DATA"))
            table.Chakra = args[2]
            file.Write("lddschakra/" .. args[1] .. ".txt", util.TableToJSON(table))
        else
            net.Start("chakra_error")
            net.Send(ply)
        end
    else
        net.Start("chakra_refuse")
        net.Send(ply)
    end
end)

net.Receive("chakra_set_max", function(len, ply)
    if ply:IsSuperAdmin() then
        local new_config = net.ReadString()
        new_config = tonumber(new_config)
        if file.Exists("lddschakra/config.json", "data") then
            local data_config = util.JSONToTable(file.Read("lddschakra/config.json", "DATA"))
            data_config.max = new_config
            file.Write("lddschakra/config.json", util.TableToJSON(data_config))
        else
            net.Start("chakra_error")
            net.Send(ply)
        end
    else
        net.Start("chakra_refuse")
        net.Send(ply)
    end
end)

net.Receive("chakra_set_min", function(len, ply)
    if ply:IsSuperAdmin() then
        local new_config = net.ReadString()
        new_config = tonumber(new_config)
        if file.Exists("lddschakra/config.json", "data") then
            local data_config = util.JSONToTable(file.Read("lddschakra/config.json", "DATA"))
            data_config.min = new_config
            file.Write("lddschakra/config.json", util.TableToJSON(data_config))
        else
            net.Start("chakra_error")
            net.Send(ply)
        end
    else
        net.Start("chakra_refuse")
        net.Send(ply)
    end
end)

net.Receive("chakra_set_time", function(len, ply)
    if ply:IsSuperAdmin() then
        local new_config = net.ReadString()
        new_config = tonumber(new_config)
        if file.Exists("lddschakra/config.json", "data") then
            local data_config = util.JSONToTable(file.Read("lddschakra/config.json", "DATA"))
            data_config.time = new_config
            file.Write("lddschakra/config.json", util.TableToJSON(data_config))
        else
            net.Start("chakra_error")
            net.Send(ply)
        end
    else
        net.Start("chakra_refuse")
        net.Send(ply)
    end
end)

net.Receive("chakra_config_info", function(len, ply)
    if ply:IsSuperAdmin() then
        local config = util.JSONToTable(file.Read("lddschakra/config.json", "DATA"))
        PrintTable(config)
        net.Start("chakra_info")
        net.WriteTable(config)
        net.Send(ply)
    else
        net.Start("chakra_refuse")
        net.Send(ply)
    end
end)

timer.Create("Give_Chakra", config.time, 0, function()
    local config = util.JSONToTable(file.Read("lddschakra/config.json", "DATA"))
    for k, v in pairs(player.GetAll()) do
        if file.Exists("lddschakra/" .. v:SteamID64() .. ".txt", "DATA") then
            local table = util.JSONToTable(file.Read("lddschakra/" .. v:SteamID64() .. ".txt", "DATA"))
            table.Chakra = tonumber(table.Chakra)
            if table.Chakra < 15000 then
                table.Chakra = table.Chakra + math.random(config.min, config.max)
                if table.Chakra > 15000 then
                    table.Chakra = 15000
                end
                file.Write("lddschakra/" .. v:SteamID64() .. ".txt", util.TableToJSON(table))
                net.Start("chakra_auto_add")
                net.WriteString(table.Chakra)
                net.Send(v)
            else
                net.Start("chakra_max")
                net.Send(v)
            end
        else
            print(" - - - - - - - - - - - - - - - - - - -")
            print("DATA OF " .. v:Nick() .. " NOT FOUND")
            print(" - - - - - - - - - - - - - - - - - - -")
        end
    end
end)