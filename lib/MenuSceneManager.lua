Hooks:PostHook( MenuSceneManager, "_set_up_templates", "nepmenu_setup_templates", function(self)

	local NHO = NepgearsyMM.Data
	if not NepgearsyMM.POSER then
		self._scene_templates.standard.character_pos = Vector3(NHO.NepgearsyMM_Scene_Character_Position_X_Value or 5, NHO.NepgearsyMM_Scene_Character_Position_Y_Value or -45, NHO.NepgearsyMM_Scene_Character_Position_Z_Value or -140)
		self._scene_templates.standard.character_rot = NHO.NepgearsyMM_Scene_Character_Rotation_Value or -170
	end
	self._scene_templates.standard.hide_menu_logo = true

	self._scene_templates.standard.use_character_grab = false
	self._scene_templates.options.use_character_grab = false
	self._scene_templates.character_customization.use_character_grab = false

	local chosen_light_1
	local chosen_light_2
	local chosen_light_3

	local classic_light_1 = Vector3(0.86, 0.37, 0.21) * 4
	local classic_light_2 = Vector3(0.3, 0.5, 0.8) * 6
	local classic_light_3 = Vector3(1, 1, 1) * 0.35

	local nmml_light_1 = Vector3(1, 0.4, 0.2) * 5
	local nmml_light_2 = Vector3(0.6, 0.6, 1) * 2
	local nmml_light_3 = Vector3(0.6, 0.6, 1) * 0.1

	local no_light = Vector3(1, 1, 1)

	math.randomseed( os.time() )
	local random_1 = math.random()
	math.randomseed( os.time() + 50 )
	local random_2 = math.random()
	math.randomseed( os.time() + 100 )
	local random_3 = math.random()

	math.randomseed( os.time() + 150)
	local random_4 = math.random()
	math.randomseed( os.time() + 200 )
	local random_5 = math.random()
	math.randomseed( os.time() + 250 )
	local random_6 = math.random()

	math.randomseed( os.time() + 300 )
	local random_7 = math.random()
	math.randomseed( os.time() + 350 )
	local random_8 = math.random()
	math.randomseed( os.time() + 400 )
	local random_9 = math.random()

	local rand_light_1 = Vector3(random_1, random_2, random_3) * 3
	local rand_light_2 = Vector3(random_4, random_5, random_6) * 3
	local rand_light_3 = Vector3(random_7, random_8, random_9) * 3

	local o_light_data = NHO and NHO.NepgearsyMM_Scene_Light_Selection_Value

	if o_light_data then
		if o_light_data == 1 then -- nmm
			chosen_light_1 = nmml_light_1
			chosen_light_2 = nmml_light_2
			chosen_light_3 = nmml_light_3
		elseif o_light_data == 2 then -- default
			chosen_light_1 = classic_light_1
			chosen_light_2 = classic_light_2
			chosen_light_3 = classic_light_3
		elseif o_light_data == 3 then -- rand
			chosen_light_1 = rand_light_1
			chosen_light_2 = rand_light_2
			chosen_light_3 = rand_light_3
		elseif o_light_data == 4 then -- white
			chosen_light_1 = no_light
			chosen_light_2 = no_light
			chosen_light_3 = no_light
		end
	else
		chosen_light_1 = nmml_light_1
		chosen_light_2 = nmml_light_2
		chosen_light_3 = nmml_light_3
	end

	self._scene_templates.standard.lights = {
		self:_create_light({
			far_range = 750,
			color = chosen_light_1,
			position = Vector3(180, -100, 0)
		}),
		self:_create_light({
			far_range = 750,
			specular_multiplier = 8,
			color = chosen_light_2,
			position = Vector3(-180, -100, 32)
		}),
		self:_create_light({
			far_range = 600,
			specular_multiplier = 0,
			color = chosen_light_3,
			position = Vector3(-180, -250, -40)
		})
	}
end)

Hooks:PostHook( MenuSceneManager, "set_scene_template", "nepmenu_set_scene_template", function(self, template, data, custom_name, skip_transition)
	local template_data = nil

	if not skip_transition then
		template_data = data or self._scene_templates[template]
		local NHO = NepgearsyMM.Data

		-- This below would fix the pos save when going to inventory > back to menu without restart, but breaks the other positions.

		--if template_data.character_pos then
		--	self._character_unit:set_position(Vector3(NHO.NepgearsyMM_Scene_Character_Position_X_Value or 5, NHO.NepgearsyMM_Scene_Character_Position_Y_Value or -45, NHO.NepgearsyMM_Scene_Character_Position_Z_Value or -140))
		--end

		if template_data.character_rot and not NepgearsyMM.POSER then
			self._character_unit:set_rotation(Rotation(NHO.NepgearsyMM_Scene_Character_Rotation_Value or -170, self._character_pitch))
            self._character_yaw = template_data.character_rot
		end
	end
end)

Hooks:PostHook( MenuSceneManager, "_select_character_pose", "nepmenu_select_pose", function(self, unit)
	--unit = unit or self._character_unit
	--local pose = "husk_m95"
	--self:_set_character_unit_pose(pose, unit)

	-- note to myself: gonna make a lot of customization based on poses like poser did!
end)
