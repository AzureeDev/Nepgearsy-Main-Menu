Hooks:PostHook( MenuSceneManager, "_set_up_templates", "nepmenu_setup_templates", function(self)

	local NHO = NepgearsyMM.Data
	self._scene_templates.standard.character_pos = Vector3(NHO.NepgearsyMM_Scene_Character_Position_X_Value or 5, NHO.NepgearsyMM_Scene_Character_Position_Y_Value or -45, NHO.NepgearsyMM_Scene_Character_Position_Z_Value or -140)
	self._scene_templates.standard.character_rot = NHO.NepgearsyMM_Scene_Character_Rotation_Value or -170
	self._scene_templates.standard.hide_menu_logo = true

	self._scene_templates.standard.use_character_grab = false
	self._scene_templates.options.use_character_grab = false
	self._scene_templates.character_customization.use_character_grab = false

		local light_variation_rand = math.random(0, 100)

		local chosen_light_1 = Vector3(1, 1, 1) * 0.35
		local chosen_light_2 = Vector3(1, 1, 1) * 0.35
		local chosen_light_3 = Vector3(1, 1, 1) * 0.35

		local red_light = Vector3(1, 0.3, 0.3) * 5
		local blue_light = Vector3(0.3, 0.3, 1) * 5
		local green_light = Vector3(0.3, 1, 0.3) * 5
		local classic_light_1 = Vector3(0.86, 0.37, 0.21) * 4
		local classic_light_2 = Vector3(0.3, 0.5, 0.8) * 6
		local classic_light_3 = Vector3(1, 1, 1) * 0.35

		if light_variation_rand <= 20 then
			chosen_light_1 = red_light
			chosen_light_2 = classic_light_2
			chosen_light_3 = blue_light
		elseif light_variation_rand > 20 and light_variation_rand <= 40 then
			chosen_light_1 = blue_light
			chosen_light_2 = classic_light_1
			chosen_light_3 = red_light
		elseif light_variation_rand > 40 and light_variation_rand <= 60 then
			chosen_light_1 = green_light
			chosen_light_2 = classic_light_3
			chosen_light_3 = blue_light
		elseif light_variation_rand > 60 and light_variation_rand <= 80 then
			chosen_light_1 = classic_light_3
			chosen_light_2 = classic_light_2
			chosen_light_3 = green_light
		else
			chosen_light_1 = red_light
			chosen_light_2 = green_light
			chosen_light_3 = blue_light
		end

	self._scene_templates.standard.lights = {
		self:_create_light({
			far_range = 750,
			color = classic_light_1,
			position = Vector3(180, -100, 0)
		}),
		self:_create_light({
			far_range = 750,
			specular_multiplier = 8,
			color = classic_light_2,
			position = Vector3(-180, -100, 32)
		}),
		self:_create_light({
			far_range = 600,
			specular_multiplier = 0,
			color = classic_light_3,
			position = Vector3(-180, -250, -40)
		})
	}
end)

Hooks:PostHook( MenuSceneManager, "set_scene_template", "nepmenu_set_scene_template", function(self, template, data, custom_name, skip_transition)
	local template_data = nil

	if not skip_transition then
		template_data = data or self._scene_templates[template]
		local template_data_standard = self._scene_templates.standard
		local NHO = NepgearsyMM.Data

		--if template_data.character_pos then
		--	self._character_unit:set_position(Vector3(NHO.NepgearsyMM_Scene_Character_Position_X_Value or 5, NHO.NepgearsyMM_Scene_Character_Position_Y_Value or -45, NHO.NepgearsyMM_Scene_Character_Position_Z_Value or -140))
		--end

		if template_data.character_rot then
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