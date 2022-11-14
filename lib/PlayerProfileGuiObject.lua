function PlayerProfileGuiObject:init(ws)
	local panel = ws:panel():panel()
	self._panel = panel
	local skill_panel = panel:panel()
	local inventory_panel = panel:panel()
	self._skill_panel = skill_panel
	self._inventory_panel = inventory_panel
	self._panel:set_w(400)
	self._panel:set_h(250)
	self._choose_self_profile = false
	self._current_page = NepgearsyMM and NepgearsyMM.Data["current_profile_page_selected"] or "skills"
	self:refresh_data(self._current_page)

	self:_init_supposed_skill_points()

	local next_level_data = managers.experience:next_level_data() or {}
	local s_current_xp = next_level_data.current_points or 1
	local next_level_xp = next_level_data.points or 1
	local max_left_len = 0
	local max_right_len = 0
	local font = tweak_data.menu.pd2_large_font
	local font_size = tweak_data.menu.pd2_small_font_size
	self._font = font
	self._font_size = font_size
	BoxGuiObject:new(panel, {sides = {
		1,
		1,
		1,
		1
	}})
	local bg_rect = panel:rect({
		name = "background",
		color = Color.black,
		alpha = 0.4,
		layer = -1,
		halign = "scale",
		valign = "scale"
	})
	local blur = panel:bitmap({
		texture = "guis/textures/test_blur_df",
		w = panel:w(),
		h = panel:h(),
		render_template = "VertexColorTexturedBlur3D",
		layer = -1,
		halign = "scale",
		valign = "scale"
	})

	local button_skills = panel:panel({
		name = "button_skills",
		w = 24,
		h = 24
	})
	self._button_skill = button_skills

	local bg_rect_button_skill = button_skills:rect({
		name = "background_btn_skill",
		color = Color.white,
		alpha = 0.1,
		layer = 1,
		halign = "scale",
		valign = "scale"
	})

	BoxGuiObject:new(button_skills, {sides = {
		1,
		1,
		1,
		1
	}, color = Color("202020")})

	button_skills:set_right(panel:right() - 10)
	button_skills:set_top(panel:top() + 10)

	local text_btn_skill = button_skills:text({
		text = "S",
		color = Color.white,
		font = font,
		font_size = font_size - 4,
		valign = "center",
		align = "center",
		vertical = "center",
		layer = 5
	})

	local button_inventory = panel:panel({
		name = "button_inventory",
		w = 24,
		h = 24
	})
	self._button_inventory = button_inventory

	local bg_rect_button_inventory = button_inventory:rect({
		name = "background_btn_inventory",
		color = Color.white,
		alpha = 0.1,
		layer = 1,
		halign = "scale",
		valign = "scale"
	})

	BoxGuiObject:new(button_inventory, {sides = {
		1,
		1,
		1,
		1
	}, color = Color("202020")})

	button_inventory:set_right(panel:right() - 10)
	button_inventory:set_top(button_skills:bottom() + 5)

	local text_btn_inventory = button_inventory:text({
		text = "I",
		color = Color.white,
		font = font,
		font_size = font_size - 4,
		valign = "center",
		align = "center",
		vertical = "center",
		layer = 5
	})

	local myavatar = panel:bitmap({
		name = "myavatar",
		texture = "guis/textures/pd2/none_icon",
		visible = true,
		h = 60,
		w = 60,
		x = 10,
		y = 10
	})

	self._my_avatar = myavatar

	Steam:friend_avatar(2, Steam:userid(), function (texture)
		local avatar = texture or "guis/textures/pd2/none_icon"
		local avatar_panel = self._panel:child("myavatar")
		avatar_panel:set_image(avatar)
	end)

	local player_level = managers.experience:current_level()
	local player_rank = managers.experience:current_rank()
	local player_name = managers.network.account:username() or managers.blackmarket:get_preferred_character_real_name()
	local is_infamous = player_rank > 0
	local level_string = (is_infamous and managers.experience:rank_string(player_rank) .. "-" or "") .. tostring(player_level)

	local player_text = panel:text({
		font = font,
		font_size = font_size,
		text = player_name,
		color = tweak_data.screen_colors.text
	})

	local level_text = panel:text({
		font = font,
		font_size = font_size,
		text = level_string,
		color = Color(0.5, 0.5, 0.5)
	})

	local nl_text = ""
	local next_xp_in = next_level_xp - s_current_xp

	if next_xp_in == 0 then
		nl_text = managers.localization:text("nepmenu_exp_max_level_reached")
	else
		local s_next_xp_in = tostring(next_xp_in)
		nl_text = managers.localization:text("nepmenu_exp_needed_text", {exp = managers.money:add_decimal_marks_to_string(s_next_xp_in), nextlevel = (managers.experience:current_level() + 1)})
	end


	local current_xp = panel:text({
		font = font,
		font_size = 15,
		text = nl_text,
		color = Color(0.5, 0.5, 0.5)
	})

	local player_pool = managers.experience:get_current_prestige_xp()
	local pool_max = "30000000"
	local pool_text = ""

	if player_pool == pool_max then
		pool_text = managers.localization:text("nepmenu_pool_max_reached")
	else
		pool_text = managers.localization:text("nepmenu_pool_needed_text", {exp = managers.money:add_decimal_marks_to_string(tostring(player_pool)), max = managers.money:add_decimal_marks_to_string(pool_max)})
	end

	local xp_pool = panel:text({
		font = font,
		font_size = 15,
		text = pool_text,
		color = Color(0.5, 0.5, 0.5)
	})

	self:_make_fine_text(player_text)
	self:_make_fine_text(level_text)
	self:_make_fine_text(current_xp)
	self:_make_fine_text(xp_pool)

	level_text:set_left(myavatar:right() + 10)
	level_text:set_top(myavatar:top())

	player_text:set_left(level_text:right() + 10)
	player_text:set_top(level_text:top())

	current_xp:set_left(myavatar:right() + 10)
	current_xp:set_top(player_text:bottom() + 4)

	xp_pool:set_left(myavatar:right() + 10)
	xp_pool:set_top(current_xp:bottom() + 4)

	local current_specialization = managers.skilltree:get_specialization_value("current_specialization")
	local texture_rect_x = 0
	local texture_rect_y = 0
	local specialization_data = tweak_data.skilltree.specializations[current_specialization]
	local specialization_text = ""

	local guis_catalog = "guis/"
	if specialization_data then
		local current_tier = managers.skilltree:get_specialization_value(current_specialization, "tiers", "current_tier")
		local max_tier = managers.skilltree:get_specialization_value(current_specialization, "tiers", "max_tier")
		local tier_data = specialization_data[max_tier]

		if tier_data then
			texture_rect_x = tier_data.icon_xy and tier_data.icon_xy[1] or 0
			texture_rect_y = tier_data.icon_xy and tier_data.icon_xy[2] or 0

			if tier_data.texture_bundle_folder then
				guis_catalog = guis_catalog .. "dlcs/" .. tostring(tier_data.texture_bundle_folder) .. "/"
			end

			specialization_text = tostring(current_tier) .. "/" .. tostring(max_tier)
		end
	end

	local icon_atlas_texture = guis_catalog .. "textures/pd2/specialization/icons_atlas"

	local equipped_perkdeck = skill_panel:bitmap({
		texture = icon_atlas_texture,
		texture_rect = {
			texture_rect_x * 64,
			texture_rect_y * 64,
			64,
			64
		},
		w = 48,
		h = 48
	})

	local mastermind_icon = skill_panel:bitmap({
		name = "mastermind_icon",
		texture = "assets/NepgearsyMM/mastermind_icon",
		visible = true,
		h = 35,
		w = 35,
		x = 25,
		y = 5
	})
	local mastermind_points = skill_panel:text({
		name = "mastermind_points",
		font = font,
		font_size = font_size,
		text = "000",
		valign = "center",
		align = "center",
		vertical = "center"
	})
	self:_make_fine_text(mastermind_points)
	mastermind_icon:set_top(myavatar:bottom() + 19)
	mastermind_points:set_top(mastermind_icon:bottom() + 5)
	mastermind_points:set_center_x(mastermind_icon:center_x() - 2)
	mastermind_points:set_text(managers.skilltree:get_tree_progress_2("mastermind"))

	local enforcer_icon = skill_panel:bitmap({
		name = "enforcer_icon",
		texture = "assets/NepgearsyMM/enforcer_icon",
		visible = true,
		h = 35,
		w = 35,
		x = 15,
		y = 5
	})
	local enforcer_points = skill_panel:text({
		name = "enforcer_points",
		font = font,
		font_size = font_size,
		text = "000",
		valign = "center",
		align = "center",
		vertical = "center"
	})
	self:_make_fine_text(enforcer_points)
	enforcer_icon:set_top(myavatar:bottom() + 20)
	enforcer_icon:set_left(mastermind_icon:right() + 25)
	enforcer_points:set_top(enforcer_icon:bottom() + 5)
	enforcer_points:set_center_x(enforcer_icon:center_x() - 2)
	enforcer_points:set_text(managers.skilltree:get_tree_progress_2("enforcer"))

	local technician_icon = skill_panel:bitmap({
		name = "technician_icon",
		texture = "assets/NepgearsyMM/technician_icon",
		visible = true,
		h = 35,
		w = 35,
		x = 15,
		y = 5
	})
	local technician_points = skill_panel:text({
		name = "technician_points",
		font = font,
		font_size = font_size,
		text = "000",
		valign = "center",
		align = "center",
		vertical = "center"
	})
	self:_make_fine_text(technician_points)
	technician_icon:set_top(myavatar:bottom() + 20)
	technician_icon:set_left(enforcer_icon:right() + 25)
	technician_points:set_top(technician_icon:bottom() + 5)
	technician_points:set_center_x(technician_icon:center_x() - 2)
	technician_points:set_text(managers.skilltree:get_tree_progress_2("technician"))

	local ghost_icon = skill_panel:bitmap({
		name = "ghost_icon",
		texture = "assets/NepgearsyMM/ghost_icon",
		visible = true,
		h = 35,
		w = 35,
		x = 15,
		y = 5
	})
	local ghost_points = skill_panel:text({
		name = "ghost_points",
		font = font,
		font_size = font_size,
		text = "000",
		valign = "center",
		align = "center",
		vertical = "center"
	})
	self:_make_fine_text(ghost_points)
	ghost_icon:set_top(myavatar:bottom() + 20)
	ghost_icon:set_left(technician_icon:right() + 25)
	ghost_points:set_top(ghost_icon:bottom() + 5)
	ghost_points:set_center_x(ghost_icon:center_x() - 1)
	ghost_points:set_text(managers.skilltree:get_tree_progress_2("ghost"))

	local fugitive_icon = skill_panel:bitmap({
		name = "fugitive_icon",
		texture = "assets/NepgearsyMM/fugitive_icon",
		visible = true,
		h = 35,
		w = 35,
		x = 15,
		y = 5
	})
	local fugitive_points = skill_panel:text({
		name = "fugitive_points",
		font = font,
		font_size = font_size,
		text = "000",
		valign = "center",
		align = "center",
		vertical = "center"
	})
	self:_make_fine_text(fugitive_points)
	fugitive_icon:set_top(myavatar:bottom() + 20)
	fugitive_icon:set_left(ghost_icon:right() + 25)
	fugitive_points:set_top(fugitive_icon:bottom() + 5)
	fugitive_points:set_center_x(fugitive_icon:center_x() - 2)
	fugitive_points:set_text(managers.skilltree:get_tree_progress_2("hoxton"))

	equipped_perkdeck:set_top(myavatar:bottom() + 20)
	equipped_perkdeck:set_left(fugitive_icon:right() + 25)
	equipped_perkdeck:set_center_y(fugitive_icon:center_y())

	local perkdeck_infos = skill_panel:text({
		name = "perkdeck_infos",
		font = font,
		font_size = font_size,
		text = specialization_text,
		valign = "center",
		align = "center",
		vertical = "center"
	})
	self:_make_fine_text(perkdeck_infos)

	perkdeck_infos:set_top(fugitive_points:top() + 1)
	perkdeck_infos:set_center_x(equipped_perkdeck:center_x())

	if not NepgearsyMM.CAN_ADD_FILES then

		local mastermind_xy = { 4, 9 }
		local enforcer_xy = { 8, 10 }
		local technician_xy = { 9, 6 }
		local ghost_xy = { 5, 9 }
		local fugitive_xy = { 1, 12 }

		mastermind_icon:set_image("guis/textures/pd2/skilltree_2/icons_atlas_2")
		mastermind_icon:set_texture_rect(
			mastermind_xy[1] * 80,
			mastermind_xy[2] * 80,
			80,
			80
		)

		enforcer_icon:set_image("guis/textures/pd2/skilltree_2/icons_atlas_2")
		enforcer_icon:set_texture_rect(
			enforcer_xy[1] * 80,
			enforcer_xy[2] * 80,
			80,
			80
		)

		technician_icon:set_image("guis/textures/pd2/skilltree_2/icons_atlas_2")
		technician_icon:set_texture_rect(
			technician_xy[1] * 80,
			technician_xy[2] * 80,
			80,
			80
		)

		ghost_icon:set_image("guis/textures/pd2/skilltree_2/icons_atlas_2")
		ghost_icon:set_texture_rect(
			ghost_xy[1] * 80,
			ghost_xy[2] * 80,
			80,
			80
		)

		fugitive_icon:set_image("guis/textures/pd2/skilltree_2/icons_atlas_2")
		fugitive_icon:set_texture_rect(
			fugitive_xy[1] * 80,
			fugitive_xy[2] * 80,
			80,
			80
		)
	end

	if managers.skilltree:get_tree_progress_2("mastermind") >= 30 then
		mastermind_icon:set_color(Color(1, 1, 0))
		mastermind_points:set_color(Color(1, 0.6, 0))
	end

	if managers.skilltree:get_tree_progress_2("enforcer") >= 30 then
		enforcer_icon:set_color(Color(1, 1, 0))
		enforcer_points:set_color(Color(1, 0.6, 0))
	end

	if managers.skilltree:get_tree_progress_2("technician") >= 30 then
		technician_icon:set_color(Color(1, 1, 0))
		technician_points:set_color(Color(1, 0.6, 0))
	end

	if managers.skilltree:get_tree_progress_2("ghost") >= 30 then
		ghost_icon:set_color(Color(1, 1, 0))
		ghost_points:set_color(Color(1, 0.6, 0))
	end

	if managers.skilltree:get_tree_progress_2("hoxton") >= 30 then
		fugitive_icon:set_color(Color(1, 1, 0))
		fugitive_points:set_color(Color(1, 0.6, 0))
	end

	local separator = panel:text({
		name = "separator",
		font = font,
		font_size = font_size,
		text = "______________________________________",
		color = Color(0.4, 0.4, 0.4),
		valign = "center",
		align = "center",
		vertical = "center",
		x = 10
	})
	self:_make_fine_text(separator)
	separator:set_top(mastermind_points:bottom())
	separator:set_center_x(panel:center_x())

	local spendable_money_string = panel:text({
		name = "spendable_money_string",
		font = font,
		font_size = font_size,
		text = managers.localization:text("nepmenu_spendable_cash_text"),
		color = Color(0.5, 0.5, 0.5),
		x = 10
	})
	self:_make_fine_text(spendable_money_string)
	spendable_money_string:set_top(separator:bottom() + 9)

	local offshore_money_string = panel:text({
		name = "offshore_money_string",
		font = font,
		font_size = font_size,
		text = managers.localization:text("nepmenu_offshore_cash_text"),
		color = Color(0.5, 0.5, 0.5),
		x = 10
	})
	self:_make_fine_text(offshore_money_string)
	offshore_money_string:set_top(spendable_money_string:bottom())

	local skill_points_used_string = panel:text({
		name = "skill_points_used_string",
		font = font,
		font_size = font_size,
		text = managers.localization:text("nepmenu_skill_points_used_text"),
		color = Color(0.5, 0.5, 0.5),
		x = 10
	})
	self:_make_fine_text(skill_points_used_string)
	skill_points_used_string:set_top(offshore_money_string:bottom())


	local spendable_money_amount = panel:text({
		name = "spendable_money_amount",
		font = font,
		font_size = font_size,
		text = "000000000000000000000000000",
		color = Color(0.38, 0.63, 0.30)
	})
	self:_make_fine_text(spendable_money_amount)
	spendable_money_amount:set_left(spendable_money_string:right() + 40)
	spendable_money_amount:set_top(separator:bottom() + 9)
	spendable_money_amount:set_text(managers.money:total_string())

	local offshore_money_amount = panel:text({
		name = "offshore_money_amount",
		font = font,
		font_size = font_size,
		text = "000000000000000000000000000",
		color = Color(0.58, 0.83, 0.50)
	})
	self:_make_fine_text(offshore_money_amount)
	offshore_money_amount:set_left(spendable_money_amount:left())
	offshore_money_amount:set_top(spendable_money_amount:bottom())
	offshore_money_amount:set_text(managers.experience:cash_string(managers.money:offshore()))

	local skill_points_used_amount = panel:text({
		name = "skill_points_used_amount",
		font = font,
		font_size = font_size,
		text = "00000000000000",
		color = Color(0.5, 0.67, 1)
	})
	self:_make_fine_text(skill_points_used_amount)
	local skillpoints = tostring(managers.skilltree:points())
	local n_skillpoints = tonumber(managers.skilltree:points())
	local total_used = managers.skilltree:get_tree_progress_2("mastermind") + managers.skilltree:get_tree_progress_2("enforcer") + managers.skilltree:get_tree_progress_2("technician") + managers.skilltree:get_tree_progress_2("ghost") + managers.skilltree:get_tree_progress_2("hoxton")
	skill_points_used_amount:set_left(spendable_money_amount:left())
	skill_points_used_amount:set_top(offshore_money_amount:bottom())

	if player_level > 100 then
		skill_points_used_amount:set_text(total_used .. " / 120")
	else
		skill_points_used_amount:set_text(total_used .. " / " .. self.supposed_skillpoint_level[player_level] or 120)
	end

	local skill_icon = panel:bitmap({
		w = 16,
		texture = "guis/textures/pd2/shared_skillpoint_symbol",
		h = 16,
		layer = 1,
		color = Color.white,
		visible = false
	})

	local skill_point_unused = panel:text({
		name = "skill_point_unused",
		font = font,
		font_size = font_size,
		text = skillpoints,
		color = Color.white,
		visible = false
	})

	skill_icon:set_left(skill_points_used_amount:right() + 60)
	skill_icon:set_top(offshore_money_amount:bottom())
	skill_point_unused:set_left(skill_icon:right() + 5)
	skill_point_unused:set_top(offshore_money_amount:bottom())

	if n_skillpoints > 0 then
		local function animate_new_skillpoints(o)
			while true do
				over(1, function (p)
					o:set_alpha(math.lerp(0.2, 1, math.sin(p * 180)))
				end)
			end
		end

		skill_point_unused:set_visible(true)
		skill_point_unused:animate(animate_new_skillpoints)
		skill_point_unused:set_color(Color(1, 0.75, 0))
		skill_icon:set_visible(true)
		skill_icon:animate(animate_new_skillpoints)
		skill_icon:set_color(Color(1, 0.75, 0))
	end

	self:_init_inventory()
	self:_rec_round_object(panel)

	DelayedCalls:Add( "Anticrash_Nepmenu", 0.05, function()
		managers.menu_component._blt_notifications._panel:set_top(self._panel:bottom() + 265)
    	managers.menu_component:create_friends_gui()
	end )
end

function PlayerProfileGuiObject:_init_inventory()
	local panel = self._inventory_panel
	local font = self._font
	local font_size = self._font_size
	local player_loadout_data = managers.blackmarket:player_loadout_data()
	local icon_w = 256 / 3.1
	local icon_h = 128 / 3.1
	local is_primary_skin = true
	local is_secondary_skin = true
	local padding_bottom = 30

	if player_loadout_data.primary.item_bg_texture == nil then
		is_primary_skin = false
	end

	if player_loadout_data.secondary.item_bg_texture == nil then
		is_secondary_skin = false
	end

	local primary_icon = panel:bitmap({
		texture = player_loadout_data.primary.item_texture,
		w = icon_w,
		h = icon_h,
		x = 10,
		layer = 2
	})

	local primary_rarity_icon = panel:bitmap({
		texture = player_loadout_data.primary.item_bg_texture,
		w = icon_w,
		h = icon_h,
		x = 10,
		layer = 1,
		visible = is_primary_skin
	})

	primary_icon:set_top(self._my_avatar:bottom() + padding_bottom)
	primary_rarity_icon:set_top(self._my_avatar:bottom() + padding_bottom)

	local secondary_icon = panel:bitmap({
		texture = player_loadout_data.secondary.item_texture,
		w = icon_w,
		h = icon_h,
		layer = 2
	})

	local secondary_rarity_icon = panel:bitmap({
		texture = player_loadout_data.secondary.item_bg_texture,
		w = icon_w,
		h = icon_h,
		layer = 1,
		visible = is_secondary_skin
	})

	secondary_icon:set_top(self._my_avatar:bottom() + padding_bottom)
	secondary_icon:set_left(primary_icon:right())
	secondary_rarity_icon:set_top(self._my_avatar:bottom() + padding_bottom)
	secondary_rarity_icon:set_left(primary_icon:right())

	melee_icon = panel:bitmap({
		texture = player_loadout_data.melee_weapon.item_texture,
		w = icon_w,
		h = icon_h,
		layer = 2
	})
	melee_icon:set_top(self._my_avatar:bottom() + padding_bottom)
	melee_icon:set_left(secondary_icon:right())

	grenade_icon = panel:bitmap({
		texture = player_loadout_data.grenade.item_texture,
		w = icon_w,
		h = icon_h,
		layer = 2
	})
	grenade_icon:set_top(self._my_avatar:bottom() + padding_bottom)
	grenade_icon:set_left(melee_icon:right())

	deployable_icon = panel:bitmap({
		texture = player_loadout_data.deployable.item_texture,
		w = 128 / 3.1,
		h = 128 / 3.1,
		layer = 2
	})
	deployable_icon:set_top(self._my_avatar:bottom() + padding_bottom)
	deployable_icon:set_left(grenade_icon:right())
end

function PlayerProfileGuiObject:_init_supposed_skill_points()
	self.supposed_skillpoint_level = {}
	self.supposed_skillpoint_level[0] = 0
	self.supposed_skillpoint_level[1] = 1
	self.supposed_skillpoint_level[2] = 2
	self.supposed_skillpoint_level[3] = 3
	self.supposed_skillpoint_level[4] = 4
	self.supposed_skillpoint_level[5] = 5
	self.supposed_skillpoint_level[6] = 6
	self.supposed_skillpoint_level[7] = 7
	self.supposed_skillpoint_level[8] = 8
	self.supposed_skillpoint_level[9] = 9
	self.supposed_skillpoint_level[10] = 12
	self.supposed_skillpoint_level[11] = 13
	self.supposed_skillpoint_level[12] = 14
	self.supposed_skillpoint_level[13] = 15
	self.supposed_skillpoint_level[14] = 16
	self.supposed_skillpoint_level[15] = 17
	self.supposed_skillpoint_level[16] = 18
	self.supposed_skillpoint_level[17] = 19
	self.supposed_skillpoint_level[18] = 20
	self.supposed_skillpoint_level[19] = 21
	self.supposed_skillpoint_level[20] = 24
	self.supposed_skillpoint_level[21] = 25
	self.supposed_skillpoint_level[22] = 26
	self.supposed_skillpoint_level[23] = 27
	self.supposed_skillpoint_level[24] = 28
	self.supposed_skillpoint_level[25] = 29
	self.supposed_skillpoint_level[26] = 30
	self.supposed_skillpoint_level[27] = 31
	self.supposed_skillpoint_level[28] = 32
	self.supposed_skillpoint_level[29] = 33
	self.supposed_skillpoint_level[30] = 36
	self.supposed_skillpoint_level[31] = 37
	self.supposed_skillpoint_level[32] = 38
	self.supposed_skillpoint_level[33] = 39
	self.supposed_skillpoint_level[34] = 40
	self.supposed_skillpoint_level[35] = 41
	self.supposed_skillpoint_level[36] = 42
	self.supposed_skillpoint_level[37] = 43
	self.supposed_skillpoint_level[38] = 44
	self.supposed_skillpoint_level[39] = 45
	self.supposed_skillpoint_level[40] = 48
	self.supposed_skillpoint_level[41] = 49
	self.supposed_skillpoint_level[42] = 50
	self.supposed_skillpoint_level[43] = 51
	self.supposed_skillpoint_level[44] = 52
	self.supposed_skillpoint_level[45] = 53
	self.supposed_skillpoint_level[46] = 54
	self.supposed_skillpoint_level[47] = 55
	self.supposed_skillpoint_level[48] = 56
	self.supposed_skillpoint_level[49] = 57
	self.supposed_skillpoint_level[50] = 60
	self.supposed_skillpoint_level[51] = 61
	self.supposed_skillpoint_level[52] = 62
	self.supposed_skillpoint_level[53] = 63
	self.supposed_skillpoint_level[54] = 64
	self.supposed_skillpoint_level[55] = 65
	self.supposed_skillpoint_level[56] = 66
	self.supposed_skillpoint_level[57] = 67
	self.supposed_skillpoint_level[58] = 68
	self.supposed_skillpoint_level[59] = 69
	self.supposed_skillpoint_level[60] = 72
	self.supposed_skillpoint_level[61] = 73
	self.supposed_skillpoint_level[62] = 74
	self.supposed_skillpoint_level[63] = 75
	self.supposed_skillpoint_level[64] = 76
	self.supposed_skillpoint_level[65] = 77
	self.supposed_skillpoint_level[66] = 78
	self.supposed_skillpoint_level[67] = 79
	self.supposed_skillpoint_level[68] = 80
	self.supposed_skillpoint_level[69] = 81
	self.supposed_skillpoint_level[70] = 84
	self.supposed_skillpoint_level[71] = 85
	self.supposed_skillpoint_level[72] = 86
	self.supposed_skillpoint_level[73] = 87
	self.supposed_skillpoint_level[74] = 88
	self.supposed_skillpoint_level[75] = 89
	self.supposed_skillpoint_level[76] = 90
	self.supposed_skillpoint_level[77] = 91
	self.supposed_skillpoint_level[78] = 92
	self.supposed_skillpoint_level[79] = 93
	self.supposed_skillpoint_level[80] = 96
	self.supposed_skillpoint_level[81] = 97
	self.supposed_skillpoint_level[82] = 98
	self.supposed_skillpoint_level[83] = 99
	self.supposed_skillpoint_level[84] = 100
	self.supposed_skillpoint_level[85] = 101
	self.supposed_skillpoint_level[86] = 102
	self.supposed_skillpoint_level[87] = 103
	self.supposed_skillpoint_level[88] = 104
	self.supposed_skillpoint_level[89] = 105
	self.supposed_skillpoint_level[90] = 108
	self.supposed_skillpoint_level[91] = 109
	self.supposed_skillpoint_level[92] = 110
	self.supposed_skillpoint_level[93] = 111
	self.supposed_skillpoint_level[94] = 112
	self.supposed_skillpoint_level[95] = 113
	self.supposed_skillpoint_level[96] = 114
	self.supposed_skillpoint_level[97] = 115
	self.supposed_skillpoint_level[98] = 116
	self.supposed_skillpoint_level[99] = 117
	self.supposed_skillpoint_level[100] = 120
end

function PlayerProfileGuiObject:refresh_data(page)
	if not page then
		return
	end

	if page == "skills" then
		self._skill_panel:set_visible(true)
		self._inventory_panel:set_visible(false)
	elseif page == "inventory" then
		self._inventory_panel:set_visible(true)
		self._skill_panel:set_visible(false)
	else
		self._skill_panel:set_visible(true)
		self._inventory_panel:set_visible(false)
	end

	NepgearsyMM.Data["current_profile_page_selected"] = page or "skills"
	NepgearsyMM:Save()
end

function PlayerProfileGuiObject:mouse_pressed(button, x, y)
	if button ~= Idstring("0") or not self._panel and self._panel:inside(x, y) then
		return
	end

	if button == Idstring("0") then

		if self._panel:inside(x, y) and not self._button_skill:inside(x, y) and not self._button_inventory:inside(x, y) then
			managers.menu_component:post_event("menu_enter")
			managers.menu:open_node("friend_loadout")
			return true
		end

		if self._button_skill and self._button_skill:visible() and self._button_skill:inside(x, y) then
			managers.menu_component:post_event("menu_enter")
			self._current_page = "skills"
			self:refresh_data(self._current_page)
			return true
		end

		if self._button_inventory and self._button_inventory:visible() and self._button_inventory:inside(x, y) then
			managers.menu_component:post_event("menu_enter")
			self._current_page = "inventory"
			self:refresh_data(self._current_page)
			return true
		end
	end
end

function PlayerProfileGuiObject:mouse_moved(o, x, y)
	local pointer = "arrow"
	local used = false
	local btn_skills_bg_rect = self._button_skill:child("background_btn_skill")
	local btn_inventory_bg_rect = self._button_inventory:child("background_btn_inventory")
	local rect_panel = self._panel:child("background")
	local profile_pointed = false

	if not self._panel:inside(x, y) then
		profile_pointed = false
		rect_panel:set_color(Color.black)
		rect_panel:set_alpha(0.4)
		self._choose_self_profile = false
	end

	if self._panel and self._panel:visible() and self._panel:inside(x, y) then
		if not self._button_skill:inside(x, y) and not self._button_inventory:inside(x, y) then
			used = true
			pointer = "link"

			if not profile_pointed then
				profile_pointed = true
				self._choose_self_profile = true
				rect_panel:set_color(Color.white)
				rect_panel:set_alpha(0.1)
				return used, pointer
			end
		end
	end

	if self._button_skill and self._button_skill:visible() and self._button_skill:inside(x, y) then
		used = true
		pointer = "link"

		if not self._button_skill_pointed then
			self._button_skill_pointed = true
			managers.menu_component:post_event("highlight")
			btn_skills_bg_rect:set_alpha(0.3)
			return used, pointer
		end
	end

	if not self._button_skill:inside(x, y) then
		self._button_skill_pointed = false
		btn_skills_bg_rect:set_alpha(0.1)
	end

	if self._button_inventory and self._button_inventory:visible() and self._button_inventory:inside(x, y) then
		used = true
		pointer = "link"

		if not self._button_inventory_pointed then
			self._button_inventory_pointed = true
			managers.menu_component:post_event("highlight")
			btn_inventory_bg_rect:set_alpha(0.3)
			return used, pointer
		end
	end

	if not self._button_inventory:inside(x, y) then
		self._button_inventory_pointed = false
		btn_inventory_bg_rect:set_alpha(0.1)
	end
end
