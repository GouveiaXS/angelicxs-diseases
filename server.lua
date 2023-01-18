ESX = nil
QBcore = nil

if Config.UseESX then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    TriggerEvent('qs-core:getSharedObject', function(obj) QS = obj end)
elseif Config.UseQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterNetEvent('angelicxs-MedicalDiseases:CommandHeal', function(source, player)
    if player then
        TriggerEvent('angelicxs-MedicalDiseases:CureDisease', player, 'all')
    end
end)

RegisterNetEvent('angelicxs-MedicalDiseases:CureDisease', function(source, type)
    TriggerClientEvent('angelicxs-MedicalDiseases:CureIllness', source, 'allowed', type)
end)

if Config.UseESX then
	ESX.RegisterUsableItem(Config.CoughDrug, function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.removeInventoryItem(Config.CoughDrug, 1) then
            TriggerEvent('angelicxs-MedicalDiseases:CureDisease',source, 'coughing')
        end
	end)
    ESX.RegisterUsableItem(Config.VomitDrug, function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.removeInventoryItem(Config.VomitDrug, 1) then
            TriggerEvent('angelicxs-MedicalDiseases:CureDisease',source, 'vomiting')
        end
	end)
    ESX.RegisterUsableItem(Config.DizzyDrug, function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.removeInventoryItem(Config.DizzyDrug, 1) then
            TriggerEvent('angelicxs-MedicalDiseases:CureDisease',source, 'dizzy')
        end
	end)
elseif Config.UseQBCore then
    QBCore.Functions.CreateUseableItem(Config.CoughDrug, function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.RemoveItem(Config.CoughDrug, 1,item.slot) then
            TriggerEvent('angelicxs-MedicalDiseases:CureDisease',source, 'coughing')
        end
    end)
    QBCore.Functions.CreateUseableItem(Config.VomitDrug, function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.RemoveItem(Config.VomitDrug, 1,item.slot) then
            TriggerEvent('angelicxs-MedicalDiseases:CureDisease',source, 'coughing')
        end
    end)
    QBCore.Functions.CreateUseableItem(Config.DizzyDrug, function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.RemoveItem(Config.DizzyDrug, 1,item.slot) then
            TriggerEvent('angelicxs-MedicalDiseases:CureDisease',source, 'coughing')
        end
    end) 
end