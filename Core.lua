NepgearsyMM = NepgearsyMM or class()

NepgearsyMM.SavePath = SavePath .. "NepgearsyMM_Preferences.txt"
NepgearsyMM.AssetsDirectory = ModPath .. "assets/NepgearsyMM/"
NepgearsyMM.SoftAssetsDirectory = "assets/NepgearsyMM/"
NepgearsyMM.Data = {}
NepgearsyMM.Localization = {}
NepgearsyMM.Localization[1] = ModPath .. "localization/english.txt"
NepgearsyMM.Localization[2] = ModPath .. "localization/german.txt"

function NepgearsyMM:init()
	self:init_icons()
	self:log("init() finished!")
	self._initialized = true
end

function NepgearsyMM:log(t)
	local tostring_log = tostring(t)
	log("[NepgearsyMM] - " .. tostring_log)
end

function NepgearsyMM:Load()		
	local file = io.open( self.SavePath , "r")
	if file then
		for k, v in pairs(json.decode(file:read("*all")) or {}) do
			if k then
				NepgearsyMM.Data[k] = v
			end
		end
		file:close()
	end
end

function NepgearsyMM:Save()
	if file.DirectoryExists( SavePath ) then	
		local file = io.open( self.SavePath , "w+")
		if file then
			file:write(json.encode(NepgearsyMM.Data))
			file:close()
		end
	end
end

function NepgearsyMM:create_texture_entry(texture_path_ingame, texture_path_inmod)
	DB:create_entry(Idstring("texture"), Idstring(texture_path_ingame), texture_path_inmod)
	self:log("Loaded custom asset: " .. tostring(texture_path_inmod))
end

function NepgearsyMM:init_icons()
	for i, v in ipairs(SystemFS:list(self.AssetsDirectory)) do
		local wo_extension = string.gsub(v, ".texture", "")
		self:create_texture_entry(self.SoftAssetsDirectory .. wo_extension, self.AssetsDirectory .. v)
	end
	self:log("Loaded all the custom assets!")
end

MenuCallbackHandler.NepgearsyMM_LanguageSelection_Callback = function(self, item)
	NepgearsyMM.Data.NepgearsyMM_LanguageSelection_Value = item:value()
	NepgearsyMM:Save()
end

NepgearsyMM:Load()

Hooks:Add("LocalizationManagerPostInit", "NepMenu_Localization", function(loc)
	local language_picked = NepgearsyMM.Data["NepgearsyMM_LanguageSelection_Value"] or 1
	loc:load_localization_file( NepgearsyMM.Localization[language_picked] )
end)

MenuHelper:LoadFromJsonFile(ModPath .. "/menu/main.json", NepgearsyMM, NepgearsyMM.Data)

if not NepgearsyMM._initialized then
	NepgearsyMM:init()
end