function PlayerProfileGuiObject:init(ws)

	-- Hi Luffy

	-- I'm happy to see you here xdd

	local panel = ws:panel():panel()
	self._panel = panel
	self._panel:set_w(400)
	self._panel:set_h(250)

	DelayedCalls:Add( "AntiCrash_MovingBltNotif", 0.05, function()
    	managers.menu_component._blt_notifications._panel:set_top(self._panel:bottom() + 265)
	end )

	local infamy_title = {}
	
	for i = 0, 25 do
		infamy_title[i] = managers.localization:text("nepmenu_infamy_title_" .. i)
	end

	local supposed_skillpoint_level = {}
	supposed_skillpoint_level[0] = 0
	supposed_skillpoint_level[1] = 1
	supposed_skillpoint_level[2] = 2
	supposed_skillpoint_level[3] = 3
	supposed_skillpoint_level[4] = 4
	supposed_skillpoint_level[5] = 5
	supposed_skillpoint_level[6] = 6
	supposed_skillpoint_level[7] = 7
	supposed_skillpoint_level[8] = 8
	supposed_skillpoint_level[9] = 9
	supposed_skillpoint_level[10] = 12
	supposed_skillpoint_level[11] = 13
	supposed_skillpoint_level[12] = 14
	supposed_skillpoint_level[13] = 15
	supposed_skillpoint_level[14] = 16
	supposed_skillpoint_level[15] = 17
	supposed_skillpoint_level[16] = 18
	supposed_skillpoint_level[17] = 19
	supposed_skillpoint_level[18] = 20
	supposed_skillpoint_level[19] = 21
	supposed_skillpoint_level[20] = 24
	supposed_skillpoint_level[21] = 25
	supposed_skillpoint_level[22] = 26
	supposed_skillpoint_level[23] = 27
	supposed_skillpoint_level[24] = 28
	supposed_skillpoint_level[25] = 29
	supposed_skillpoint_level[26] = 30
	supposed_skillpoint_level[27] = 31
	supposed_skillpoint_level[28] = 32
	supposed_skillpoint_level[29] = 33
	supposed_skillpoint_level[30] = 36
	supposed_skillpoint_level[31] = 37
	supposed_skillpoint_level[32] = 38
	supposed_skillpoint_level[33] = 39
	supposed_skillpoint_level[34] = 40
	supposed_skillpoint_level[35] = 41
	supposed_skillpoint_level[36] = 42
	supposed_skillpoint_level[37] = 43
	supposed_skillpoint_level[38] = 44
	supposed_skillpoint_level[39] = 45
	supposed_skillpoint_level[40] = 48
	supposed_skillpoint_level[41] = 49
	supposed_skillpoint_level[42] = 50
	supposed_skillpoint_level[43] = 51
	supposed_skillpoint_level[44] = 52
	supposed_skillpoint_level[45] = 53
	supposed_skillpoint_level[46] = 54
	supposed_skillpoint_level[47] = 55
	supposed_skillpoint_level[48] = 56
	supposed_skillpoint_level[49] = 57
	supposed_skillpoint_level[50] = 60
	supposed_skillpoint_level[51] = 61
	supposed_skillpoint_level[52] = 62
	supposed_skillpoint_level[53] = 63
	supposed_skillpoint_level[54] = 64
	supposed_skillpoint_level[55] = 65
	supposed_skillpoint_level[56] = 66
	supposed_skillpoint_level[57] = 67
	supposed_skillpoint_level[58] = 68
	supposed_skillpoint_level[59] = 69
	supposed_skillpoint_level[60] = 72
	supposed_skillpoint_level[61] = 73
	supposed_skillpoint_level[62] = 74
	supposed_skillpoint_level[63] = 75
	supposed_skillpoint_level[64] = 76
	supposed_skillpoint_level[65] = 77
	supposed_skillpoint_level[66] = 78
	supposed_skillpoint_level[67] = 79
	supposed_skillpoint_level[68] = 80
	supposed_skillpoint_level[69] = 81
	supposed_skillpoint_level[70] = 84
	supposed_skillpoint_level[71] = 85
	supposed_skillpoint_level[72] = 86
	supposed_skillpoint_level[73] = 87
	supposed_skillpoint_level[74] = 88
	supposed_skillpoint_level[75] = 89
	supposed_skillpoint_level[76] = 90
	supposed_skillpoint_level[77] = 91
	supposed_skillpoint_level[78] = 92
	supposed_skillpoint_level[79] = 93
	supposed_skillpoint_level[80] = 96
	supposed_skillpoint_level[81] = 97
	supposed_skillpoint_level[82] = 98
	supposed_skillpoint_level[83] = 99
	supposed_skillpoint_level[84] = 100
	supposed_skillpoint_level[85] = 101
	supposed_skillpoint_level[86] = 102
	supposed_skillpoint_level[87] = 103
	supposed_skillpoint_level[88] = 104
	supposed_skillpoint_level[89] = 105
	supposed_skillpoint_level[90] = 108
	supposed_skillpoint_level[91] = 109
	supposed_skillpoint_level[92] = 110
	supposed_skillpoint_level[93] = 111
	supposed_skillpoint_level[94] = 112
	supposed_skillpoint_level[95] = 113
	supposed_skillpoint_level[96] = 114
	supposed_skillpoint_level[97] = 115
	supposed_skillpoint_level[98] = 116
	supposed_skillpoint_level[99] = 117
	supposed_skillpoint_level[100] = 120

	local next_level_data = managers.experience:next_level_data() or {}
	local s_current_xp = next_level_data.current_points or 1
	local next_level_xp = next_level_data.points or 1
	local max_left_len = 0
	local max_right_len = 0
	local font = tweak_data.menu.pd2_large_font
	local font_size = tweak_data.menu.pd2_small_font_size
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

	local myavatar = panel:bitmap({
		name = "myavatar",
		texture = "guis/textures/pd2/none_icon",
		visible = true,
		h = 60,
		w = 60,
		x = 10,
		y = 10
	})

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
	local current_specialization = managers.skilltree:get_specialization_value("current_specialization")

	local texture_rect_x = 0
	local texture_rect_y = 0
	local specialization_data = tweak_data.skilltree.specializations[current_specialization]
	local guis_catalog = "guis/"
	if specialization_data then
		local max_tier = managers.skilltree:get_specialization_value(current_specialization, "tiers", "max_tier")
		local tier_data = specialization_data[max_tier]

		if tier_data then
			texture_rect_x = tier_data.icon_xy and tier_data.icon_xy[1] or 0
			texture_rect_y = tier_data.icon_xy and tier_data.icon_xy[2] or 0

			if tier_data.texture_bundle_folder then
				guis_catalog = guis_catalog .. "dlcs/" .. tostring(tier_data.texture_bundle_folder) .. "/"
			end
		end
	end

	local icon_atlas_texture = guis_catalog .. "textures/pd2/specialization/icons_atlas"

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

	local anticrash_infamy_title

	if player_rank > 25 then
		anticrash_infamy_title = managers.localization:text("nepmenu_infamy_title_hax")
	else
		anticrash_infamy_title = "\"" .. infamy_title[player_rank] .. "\""
	end

	local infamous_title = panel:text({
		font = font,
		font_size = font_size,
		text = anticrash_infamy_title
	})

	self:_make_fine_text(player_text)
	self:_make_fine_text(level_text)
	self:_make_fine_text(current_xp)
	self:_make_fine_text(infamous_title)

	local equipped_perkdeck = panel:bitmap({
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

	equipped_perkdeck:set_top(current_xp:bottom())
	equipped_perkdeck:set_left(panel:right() - 64)
	
	level_text:set_left(myavatar:right() + 10)
	level_text:set_top(myavatar:top())

	player_text:set_left(level_text:right() + 10)
	player_text:set_top(level_text:top())

	current_xp:set_left(myavatar:right() + 10)
	current_xp:set_top(player_text:bottom() + 4)

	infamous_title:set_left(myavatar:right() + 10)
	infamous_title:set_top(current_xp:bottom() + 4)

	local mastermind_icon = panel:bitmap({
		name = "mastermind_icon",
		texture = "assets/NepgearsyMM/mastermind_icon",
		visible = true,
		h = 35,
		w = 35,
		x = 35,
		y = 10
	}) 
	local mastermind_points = panel:text({
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

	local enforcer_icon = panel:bitmap({
		name = "enforcer_icon",
		texture = "assets/NepgearsyMM/enforcer_icon",
		visible = true,
		h = 35,
		w = 35,
		x = 40,
		y = 10
	})
	local enforcer_points = panel:text({
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
	enforcer_icon:set_left(mastermind_icon:right() + 40)
	enforcer_points:set_top(enforcer_icon:bottom() + 5)
	enforcer_points:set_center_x(enforcer_icon:center_x() - 2)
	enforcer_points:set_text(managers.skilltree:get_tree_progress_2("enforcer"))

	local technician_icon = panel:bitmap({
		name = "technician_icon",
		texture = "assets/NepgearsyMM/technician_icon",
		visible = true,
		h = 35,
		w = 35,
		x = 40,
		y = 10
	})
	local technician_points = panel:text({
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
	technician_icon:set_left(enforcer_icon:right() + 40)
	technician_points:set_top(technician_icon:bottom() + 5)
	technician_points:set_center_x(technician_icon:center_x() - 2)
	technician_points:set_text(managers.skilltree:get_tree_progress_2("technician"))

	local ghost_icon = panel:bitmap({
		name = "ghost_icon",
		texture = "assets/NepgearsyMM/ghost_icon",
		visible = true,
		h = 35,
		w = 35,
		x = 40,
		y = 10
	})
	local ghost_points = panel:text({
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
	ghost_icon:set_left(technician_icon:right() + 40)
	ghost_points:set_top(ghost_icon:bottom() + 5)
	ghost_points:set_center_x(ghost_icon:center_x() - 1)
	ghost_points:set_text(managers.skilltree:get_tree_progress_2("ghost"))

	local fugitive_icon = panel:bitmap({
		name = "fugitive_icon",
		texture = "assets/NepgearsyMM/fugitive_icon",
		visible = true,
		h = 35,
		w = 35,
		x = 40,
		y = 10
	})
	local fugitive_points = panel:text({
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
	fugitive_icon:set_left(ghost_icon:right() + 40)
	fugitive_points:set_top(fugitive_icon:bottom() + 5)
	fugitive_points:set_center_x(fugitive_icon:center_x() - 2)
	fugitive_points:set_text(managers.skilltree:get_tree_progress_2("hoxton"))

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
		skill_points_used_amount:set_text(total_used .. " / " .. supposed_skillpoint_level[player_level] or 120)
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
					o:set_alpha(math.lerp(0.4, 0.85, math.sin(p * 180)))
				end)
			end
		end

		skill_point_unused:set_visible(true)
		skill_point_unused:animate(animate_new_skillpoints)
		skill_point_unused:set_color(Color(1, 0.55, 0.1))
		skill_icon:set_visible(true)
		skill_icon:animate(animate_new_skillpoints)
		skill_icon:set_color(Color(1, 0.55, 0.1))
	end

	self:_rec_round_object(panel)

	DelayedCalls:Add( "AntiCrash_CreateFriendList", 0.05, function()
    	managers.menu_component:create_friends_gui()
	end )
end