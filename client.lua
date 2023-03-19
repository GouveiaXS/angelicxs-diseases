ESX = nil
QBcore = nil

local isSick = false
local sickType = nil
local PlayerJob = nil

CreateThread(function()
    if Config.UseESX then
        ESX = exports["es_extended"]:getSharedObject()
	while not ESX.IsPlayerLoaded() do
            Wait(100)
        end
        local playerData = ESX.GetPlayerData()
        CreateThread(function()
            while true do
                if playerData ~= nil then
                    PlayerJob = playerData.job.name
                    SickThread()
                    break
                end
                Wait(100)
            end
        end)
        RegisterNetEvent('esx:setJob', function(job)
            PlayerJob = job.name
        end)
    elseif Config.UseQBCore then
        QBCore = exports['qb-core']:GetCoreObject()
        CreateThread(function ()
            while true do
                local playerData = QBCore.Functions.GetPlayerData()
                if playerData.citizenid ~= nil then
                    PlayerJob = playerData.job.name
                    SickThread()
                    break
                end
                Wait(100)
            end
        end)
        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
            PlayerJob = job.name
        end)
    end
end)

RegisterNetEvent('angelicxs-MedicalDiseases:Notify', function(message, type)
	if Config.UseCustomNotify then
        TriggerEvent('angelicxs-MedicalDiseases:CustomNotify',message, type)
	elseif Config.UseESX then
		ESX.ShowNotification(message)
	elseif Config.UseQBCore then
		QBCore.Functions.Notify(message, type)
	end
end)

RegisterNetEvent('angelicxs-MedicalDiseases:CureIllness', function(type, usage)
    if type == 'allowed' then
        if isSick then
            if usage == sickType or usage == 'all' then
                ResetSickness()
                TriggerEvent('angelicxs-MedicalDiseases:Notify', Config.Lang['cured'], Config.LangType['success'])
            else
                TriggerEvent('angelicxs-MedicalDiseases:Notify', Config.Lang['wrong_medicine'], Config.LangType['error'])
            end
        else
            TriggerEvent('angelicxs-MedicalDiseases:Notify', Config.Lang['not_sick'], Config.LangType['error'])
        end
    end
end)

function SickThread()
    Wait(60000*5)
    while true do
        local sleep = Config.IllnessCheck * 60000
        local diseaseSelector = math.random(1,3)
        local getSick = math.random(1,2)
        if getSick == 1 and not isSick then
            TriggerEvent('angelicxs-MedicalDiseases:Notify', Config.Lang['feel_sick'], Config.LangType['info'])
            isSick = true
            if diseaseSelector == 1 then
                CreateThread(function() Coughing() end)
            elseif diseaseSelector == 2 then
                CreateThread(function() Vomiting() end)
            elseif diseaseSelector == 3 then
                CreateThread(function() Dizzy() end)
            end
        elseif isSick then 
            sleep = sleep * 3 -- Increases check timer by 3 while sick, (makes it less annoying if you are unlucky).
        end
        Wait(sleep)
    end
end

if Config.RegisterCommand then
    RegisterCommand(Config.CommandName, function(source, arg) 
        if CommandUse() then
            if arg[1] then
                if #(GetEntityCoords(PlayerPedId())-GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(arg[1]))))) <= Config.CommandDistance then
                    TriggerServerEvent('angelicxs-MedicalDiseases:CommandHeal', tonumber(arg[1]))
                 else
                    TriggerEvent('angelicxs-MedicalDiseases:Notify', Config.Lang['too_far'], Config.LangType['error'])
                end
            else
                TriggerEvent('angelicxs-MedicalDiseases:Notify', Config.Lang['no_id'], Config.LangType['info'])
            end
        else
            TriggerEvent('angelicxs-MedicalDiseases:Notify', Config.Lang['wrong_job'], Config.LangType['error'])
        end
    end, false)

    function CommandUse()
        for i = 1, #Config.CommandJob do
            if Config.CommandJob[i] == PlayerJob then
                return true
            end
        end
        return false
    end
end

function Coughing()
    sickType = 'coughing'
    while isSick and sickType == 'coughing' do
        local sleep = math.random(5, 30)
        local ped = PlayerPedId()
        local dict = 'timetable@gardener@smoking_joint'
        local anim = 'idle_cough'
        AnimDictLoader(dict)
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        AnimpostfxPlay('SwitchHUDOut', 1000, false)
        Wait(3000)
        RemoveAnimDict(dict)
        ClearPedTasks(ped)
        Wait(sleep*1000)
    end
end

function Vomiting()
    sickType = 'vomiting'
    while isSick and sickType == 'vomiting' do
        local sleep = math.random(30, 90)
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local dict = 'oddjobs@taxi@tie'
        local anim = 'vomit_outside'
        AnimDictLoader(dict)
        AnimpostfxPlay('SwitchHUDIn', 3000, false)
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        if health > 120 then
            SetEntityHealth(ped, math.floor(health-10))
        end
        Wait(8000)
        AnimpostfxStop('SwitchHUDIn')
        RemoveAnimDict(dict)
        ClearPedTasks(ped)
        Wait(sleep*1000)
    end
end

function Dizzy()
    sickType = 'dizzy'
    while isSick and sickType == 'dizzy' do
        local sleep = math.random(60, 120)
        local ped = PlayerPedId()
        AnimpostfxPlay('MP_Celeb_Lose', 15000, true)
        SetPedMovementClipset(ped, 'MOVE_M@DRUNK@MODERATEDRUNK', 0.5)
        Wait(15000)
        ResetPedMovementClipset(ped, 2)
        AnimpostfxStop('MP_Celeb_Lose')
        ClearPedTasks(ped)
        Wait(sleep*1000)
    end
end

function ResetSickness()
    if isSick then 
        isSick = false
        sickType = nil
        local ped = PlayerPedId()
        local dict = 'mp_suicide'
        local anim = 'pill_fp'
        AnimDictLoader(dict)
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
        Wait(2700)
        RemoveAnimDict(dict)
        ResetPedMovementClipset(ped, 2)
        AnimpostfxStop('SwitchHUDIn')
        AnimpostfxStop('SwitchHUDOut')
        AnimpostfxStop('MP_Celeb_Lose')
        ClearPedTasks(ped)
    end
end

function AnimDictLoader(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
end

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        isSick = false
        sickType = nil
        local ped = PlayerPedId()
        ResetPedMovementClipset(ped, 2)
        AnimpostfxStop('SwitchHUDIn')
        AnimpostfxStop('SwitchHUDOut')
        AnimpostfxStop('MP_Celeb_Lose')
        ClearPedTasks(ped)
    end
end)
