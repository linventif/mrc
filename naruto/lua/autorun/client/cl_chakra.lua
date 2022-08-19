local function chakra_refuse()
    notification.AddLegacy("Vous n'avez pas acces à cette commande !", 1, 4)
    print("Vous n'avez pas acces à cette commande !")
end

local function chakra_bad_use()
    notification.AddLegacy("Vous n'avez pas bien executé la commande !", 1, 4)
    print("Vous n'avez pas bien executé la commande !")
end

concommand.Add("chakra_reset", function(ply, cmd, args, str)
    if ply:IsSuperAdmin() then
        if args[1] == nil then
            notification.AddLegacy("Vous n'avez pas bien executé la commande !", 1, 4)
            print("Vous n'avez pas bien executé la commande !")
        else
            net.Start("chakra_reset")
            net.WriteTable(args)
            net.SendToServer()
            for i, ply in ipairs(player.GetAll()) do
                if ply == player.GetBySteamID64(args[1]) then
                    notification.AddLegacy("Vous avez reset le chakra de " .. ply:Nick() .. " !", 0, 4)
                    print("Vous avez reset le chakra de " .. ply:Nick() .. " !")
                    
                end
            end
        end
    else
        chakra_refuse()
    end
end)

concommand.Add("chakra_add", function(ply, cmd, args, str)
    if ply:IsSuperAdmin() then
        if args[1] == nil or args[2] == nil then
            chakra_bad_use()
        else
            net.Start("chakra_add")
            net.WriteTable(args)
            net.SendToServer()
            for i, ply in ipairs(player.GetAll()) do
                if ply == player.GetBySteamID64(args[1]) then
                    notification.AddLegacy("Vous avez augementez le chakra de " .. ply:Nick() .. " de " .. args[2] .. " !", 0, 4)
                    print("Vous avez augementez le chakra de " .. ply:Nick() .. " de " .. args[2] .. " !")
                end
            end
        end
    else
        chakra_refuse()
    end
end)

concommand.Add("chakra_set", function(ply, cmd, args, str)
    if ply:IsSuperAdmin() then
        if args[1] == nil or args[2] == nil then
            chakra_bad_use()
        else
            net.Start("chakra_set")
            net.WriteTable(args)
            net.SendToServer()
            for i, ply in ipairs(player.GetAll()) do
                if ply == player.GetBySteamID64(args[1]) then
                    notification.AddLegacy("Vous avez définit le chakra de " .. ply:Nick() .. " a " .. args[2] .. " !", 0, 4)
                    print("Vous avez définit le chakra de " .. ply:Nick() .. " a " .. args[2] .. " !")
                end
            end
        end
    else
        chakra_refuse()
    end
end)

concommand.Add("chakra_config_auto_max", function(ply, cmd, args, str)
    if ply:IsSuperAdmin() then
        if args[1] == nil then
            chakra_bad_use()
        else
            net.Start("chakra_set_max")
            net.WriteString(args[1])
            net.SendToServer()
            notification.AddLegacy("Vous avez changer maximum de chakra automatiquement donné a " .. args[1] .. " !", 0, 4)
            print("Vous avez changer maximum de chakra automatiquement donné a " .. args[1] .. " !")
        end
    else
        chakra_refuse()
    end
end)

concommand.Add("chakra_config_auto_time", function(ply, cmd, args, str)
    if ply:IsSuperAdmin() then
        if args[1] == nil then
            chakra_bad_use()
        else
            net.Start("chakra_set_time")
            net.WriteString(args[1])
            net.SendToServer()
            notification.AddLegacy("Vous avez changer temps de chakra automatiquement donné a " .. args[1] .. " !", 0, 4)
            notification.AddLegacy("Redemarage serveur nécésaire pour apliquer le changement de timer !", 0, 8)
            print("Vous avez changer temps de chakra automatiquement donné a " .. args[1] .. " !")
            print("Redemarage serveur nécésaire pour apliquer le changement de timer !")
        end
    else
        chakra_refuse()
    end
end)

concommand.Add("chakra_config_auto_min", function(ply, cmd, args, str)
    if ply:IsSuperAdmin() then
        if args[1] == nil then
            chakra_bad_use()
        else
            net.Start("chakra_set_min")
            net.WriteString(args[1])
            net.SendToServer()
            notification.AddLegacy("Vous avez changer minimum de chakra automatiquement donné a " .. args[1] .. " !", 0, 4)
            print("Vous avez changer minimum de chakra automatiquement donné a " .. args[1] .. " !")
        end
    else
        chakra_refuse()
    end
end)

concommand.Add("chakra_config_info", function(ply, cmd, args, str)
    if ply:IsSuperAdmin() then
        net.Start("chakra_config_info")
        net.SendToServer()
    else
        chakra_refuse()
    end
end)

concommand.Add("chakra_info", function(ply, cmd, args, str)
    if ply:IsSuperAdmin() then
        if args[1] == nil then
            chakra_bad_use()
        else
            net.Start("chakra_set")
            net.WriteTable(args)
            net.SendToServer()
        end
    else
        chakra_refuse()
    end
end)

net.Receive("chakra_refuse", chakra_refuse)

net.Receive("chakra_error", function()
    local table = net.ReadTable()
    notification.AddLegacy("Aucun Joueur Trouvé ou SteamID 64 invalide !", 1, 4)
    print("Aucun Joueur Trouvé ou SteamID 64 invalide !")
end)

net.Receive("chakra_max", function()
    local table = net.ReadTable()
    notification.AddLegacy("Vous avez atteint le niveau max de chakra, vous ne pouviez pas en avoir plus !", 1, 4)
    print("Vous avez atteint le niveau max de chakra, vous ne pouviez pas en avoir plus !")
end)

net.Receive("chakra_auto_add", function()
    local chakra = net.ReadString()
    notification.AddLegacy("Votre chakra a augementer, il est maintenant de " .. chakra, 0, 4)
    print("Votre chakra a augementer, il est maintenant de " .. chakra)
end)

net.Receive("chakra_config_info", function()
    local config = net.ReadTable()
    notification.AddLegacy("Configuration reçu !", 0, 4)
    print("")
    print("")
    print("Configuration Chakra")
    print("")
    print("")
    PrintTable(config)
    print("")
    print("")
end)

net.Receive("chakra_info", function()
    local config = net.ReadTable()
    notification.AddLegacy("Configuration reçu !", 0, 4)
    print("")
    print("")
    print("Configuration Chakra")
    print("")
    print("")
    PrintTable(config)
    print("")
    print("")
end)