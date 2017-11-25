NepgearsyMM = NepgearsyMM or class()

NepgearsyMM.SavePath = SavePath .. "NepgearsyMM_Preferences.txt"
NepgearsyMM.AssetsDirectory = ModPath .. "assets/NepgearsyMM/"
NepgearsyMM.SoftAssetsDirectory = "assets/NepgearsyMM/"
NepgearsyMM.MenusDirectory = ModPath .. "menu/"
NepgearsyMM.OS = os.getenv('OS')
NepgearsyMM.LINUX = false
NepgearsyMM.Data = {}
NepgearsyMM.Localization = {}
NepgearsyMM.Localization[1] = ModPath .. "localization/english.txt"
NepgearsyMM.Localization[2] = ModPath .. "localization/german.txt"
NepgearsyMM.Localization[3] = ModPath .. "localization/russian.txt"
NepgearsyMM.Localization[4] = ModPath .. "localization/turkish.txt"
NepgearsyMM.Localization[5] = ModPath .. "localization/spanish.txt"

function NepgearsyMM:init()
	self:_check_is_linux()
	self:Load()
	self:_init_icons()
	self:_init_menus()

	self._initialized = true
	self:log("init() finished!")
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

function NepgearsyMM:_check_is_linux()
	if self.OS and self.OS ~= nil then
		return false
	end

	self.LINUX = true
	return true
end

function NepgearsyMM:create_texture_entry(texture_path_ingame, texture_path_inmod)
	if self.LINUX and NepgearsyMM.Data["NepgearsyMM_Misc_LinuxSupport_Value"] then
		return
	end

	DB:create_entry(Idstring("texture"), Idstring(texture_path_ingame), texture_path_inmod)
	self:log("Loaded custom asset: " .. tostring(texture_path_inmod))
end

function NepgearsyMM:_init_icons()
	if self.LINUX and NepgearsyMM.Data["NepgearsyMM_Misc_LinuxSupport_Value"] then
		return
	end

	for i, v in ipairs(SystemFS:list(self.AssetsDirectory)) do
		local wo_extension = string.gsub(v, ".texture", "")
		self:create_texture_entry(self.SoftAssetsDirectory .. wo_extension, self.AssetsDirectory .. v)
	end
	self:log("Loaded all the custom assets!")
end

function NepgearsyMM:_init_menus()
	if self.LINUX then -- This time not checking if he has the option since we want them to access the menu no matter what
		-- Loading the menu "old way" since SystemFS doesn't exist for Linux.

		MenuHelper:LoadFromJsonFile(self.MenusDirectory .. "0_main.json", NepgearsyMM, NepgearsyMM.Data)
		MenuHelper:LoadFromJsonFile(self.MenusDirectory .. "friendlist_options.json", NepgearsyMM, NepgearsyMM.Data)
		MenuHelper:LoadFromJsonFile(self.MenusDirectory .. "scene_options.json", NepgearsyMM, NepgearsyMM.Data)
		MenuHelper:LoadFromJsonFile(self.MenusDirectory .. "z_misc_options.json", NepgearsyMM, NepgearsyMM.Data)
		return
	end

	for i, v in ipairs(SystemFS:list(self.MenusDirectory)) do
		MenuHelper:LoadFromJsonFile(self.MenusDirectory .. v, NepgearsyMM, NepgearsyMM.Data)
	end
end
