if not NepgearsyMM._initialized then
	NepgearsyMM:init()
end

Hooks:Add("LocalizationManagerPostInit", "NepMenu_Localization", function(loc)
	local language_picked = NepgearsyMM.Data["NepgearsyMM_LanguageSelection_Value"] or 1
	loc:load_localization_file(NepgearsyMM.Localization[language_picked])
end)

function MenuCallbackHandler:NepgearsyMM_Value_Callback(item)
	local name = item._parameters.name
	local NHO = NepgearsyMM.Data
	NHO[name.."_Value"] = item:value()
	managers.menu_scene._character_unit:set_position(Vector3(NHO.NepgearsyMM_Scene_Character_Position_X_Value or 5, NHO.NepgearsyMM_Scene_Character_Position_Y_Value or -45, NHO.NepgearsyMM_Scene_Character_Position_Z_Value or -140))	
	managers.menu_scene._character_unit:set_rotation(Rotation(NHO.NepgearsyMM_Scene_Character_Rotation_Value or -170))	
	NepgearsyMM:Save()	
end

function MenuCallbackHandler:NepgearsyMM_Value_Bool_Callback(item)
	NepgearsyMM.Data.NepgearsyMM_FriendList_EnableRepLevel_Value = item:value() == "on"
	NepgearsyMM:Save()
end