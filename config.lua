
----------------------------------------------------------------------
-- Thanks for supporting AngelicXS Scripts!							--
-- Support can be found at: https://discord.gg/tQYmqm4xNb			--
-- More paid scripts at: https://angelicxs.tebex.io/ 				--
-- More FREE scripts at: https://github.com/GouveiaXS/ 				--
----------------------------------------------------------------------

Config = {}

Config.UseESX = true						-- Use ESX Framework
Config.UseQBCore = false					-- Use QBCore Framework (Ignored if Config.UseESX = true)

Config.UseCustomNotify = false				-- Use a custom notification script, must complete event below.

-- Only complete this event if Config.UseCustomNotify is true; mythic_notification provided as an example
RegisterNetEvent('angelicxs-MedicalDiseases:CustomNotify')
AddEventHandler('angelicxs-MedicalDiseases:CustomNotify', function(message, type)
    --exports.mythic_notify:SendAlert(type, message, 4000)
end)


Config.RegisterCommand = true               -- Allows a /command to cure all diseases instead of items
Config.CommandName = 'CureDisease'          -- If Config.RegisterCommand, name of /command
Config.CommandDistance = 5		            -- If Config.RegisterCommand, max distance player can be away to use command.
Config.CommandJob = {                       -- If Config.RegisterCommand what jobs can use the /command to cure all diseases
    'ambulance', 
    'doctor'
}

Config.IllnessCheck = 10                    -- In minutes, how long to do a illness check

Config.CoughDrug = 'coughmedicine'          -- Name of item used to cure coughing
Config.VomitDrug = 'nauesamedicine'          -- Name of item used to cure vomiting
Config.DizzyDrug = 'gingermedicine'         -- Name of item used to cure dizziness

Config.LangType = {
	['error'] = 'error',
	['success'] = 'success',
	['info'] = 'primary'
}

Config.Lang = {
	['wrong_job'] = 'You do not have the right job to do this!',
	['no_id'] = 'Enter the ID of the player you are trying to cure!',
	['wrong_medicine'] = 'You took the wrong kind of medicine for your illness!',
	['cured'] = 'You took the medicine and feel much better!',
	['feel_sick'] = 'You feel sick...',
	['not_sick'] = 'You took mediciation but you are not sick!',
	['too_far'] = 'They are too far away to provide treatment!',
}
