FriendLoadoutGui = FriendLoadoutGui or class(MenuGuiComponentGeneric)

local padding = 10
local massive_font = tweak_data.menu.pd2_massive_font
local large_font = tweak_data.menu.pd2_large_font
local medium_font = tweak_data.menu.pd2_medium_font
local small_font = tweak_data.menu.pd2_small_font
local tiny_font = tweak_data.menu.tiny_font
local massive_font_size = tweak_data.menu.pd2_massive_font_size
local large_font_size = tweak_data.menu.pd2_large_font_size
local medium_font_size = tweak_data.menu.pd2_medium_font_size
local small_font_size = tweak_data.menu.pd2_small_font_size
local tiny_font_size = tweak_data.menu.pd2_tiny_font_size

local function make_fine_text(text)
	local x, y, w, h = text:text_rect()

	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))
end

local function to_upper(t)
    return utf8.to_upper(t)
end

function FriendLoadoutGui:init(ws, full_ws, steam_id)
    managers.menu_component:play_transition()
    self._panel = ws:panel():panel({})
    self._fullscreen_panel = full_ws:panel():panel({})
    self._steam_data = managers.menu_component._friends_gui._steam_data_user or {}

    self._player = {}
    self._has_nepgearsy_menu = false
    self._is_myself = false

    if not managers.menu_component._player_profile_gui._choose_self_profile then
        self._player.id = self._steam_data.steam_id
        self._player.name = self._steam_data.name
        self._player.main_state = self._steam_data.main_state
        self._player.sub_state = self._steam_data.sub_state
        self._player.full_sub_state = self._steam_data.f_sub_state
        self._player.level = self._steam_data.level
        self._player.infamy = self._steam_data.infamy
        self._player.loadout = self._steam_data.loadout
        self._player.lobby = self._steam_data.current_lobby
        self._player.skill_points_invested = self._steam_data.skill_points_invested
        self._player.personal_description = self._steam_data.personal_description

        if self._player.loadout.primary.info_text ~= "" then
            self._has_nepgearsy_menu = true
        end

    else
        self._player.id = Steam:userid()
        self._player.name = managers.network.account:username() or managers.blackmarket:get_preferred_character_real_name()
        self._player.main_state = "ingame"
        self._player.sub_state = to_upper("Main menu, online")
        self._player.full_sub_state = to_upper("Main menu, online")
        self._player.level = managers.experience:current_level()
        self._player.infamy = managers.experience:current_rank()
        self._player.loadout = managers.blackmarket:player_loadout_data()
        self._player.lobby = nil
        self._player.skill_points_invested = {
            mastermind = managers.skilltree:get_tree_progress_2("mastermind"),
            enforcer = managers.skilltree:get_tree_progress_2("enforcer"),
            technician = managers.skilltree:get_tree_progress_2("technician"),
            ghost = managers.skilltree:get_tree_progress_2("ghost"),
            fugitive = managers.skilltree:get_tree_progress_2("hoxton")
        }
        self._has_nepgearsy_menu = true
        self._is_myself = true
    end

    self._is_ingame = self._player.main_state == "ingame"
    self._is_online = self._player.main_state == "online"
    self._is_offline = self._player.main_state == "offline"

    self._ingame_color = Color("90ba3c")
	self._online_color = Color("57cbde")
	self._offline_color = Color("898989")
    self._avert_color = Color("ff5555")
    self._color_by_status = self._offline_color

    if self._player.main_state then
        if self._player.main_state == "ingame" then
            self._color_by_status = self._ingame_color
        elseif self._player.main_state == "online" then
            self._color_by_status = self._online_color
        end
    end

    self:_setup_basics()
    self:_setup_profile()
    self:_setup_loadout()
    self:_setup_description()
    self:_setup_profile_buttons()
end

function FriendLoadoutGui:_setup_basics()
    local title = self._panel:text({
        font = large_font,
        font_size = large_font_size,
        text = managers.localization:to_upper_text("NepgearsyMM_PlayerProfile_Header")
    })
    make_fine_text(title)

    local main_panel = self._panel:panel({
        h = self._panel:h() - 50
    })
    main_panel:set_top(title:bottom() + 5)
    self._main_panel = main_panel

    BoxGuiObject:new(main_panel, {sides = {
		1,
		1,
		1,
		1
	}})

    local main_panel_rect = main_panel:rect({
        name = "background",
		color = Color.black,
		alpha = 0.4,
		layer = -1,
		halign = "scale",
		valign = "scale"
    })
    local blur = main_panel:bitmap({
		texture = "guis/textures/test_blur_df",
		w = main_panel:w(),
		h = main_panel:h(),
		render_template = "VertexColorTexturedBlur3D",
		layer = -1,
		halign = "scale",
		valign = "scale"
	})
    MenuGuiComponentGeneric._add_back_button(self)
end

function FriendLoadoutGui:_setup_profile()
    local profile_panel = self._main_panel:panel({
        h = 210,
        w = 665,
        x = 10,
        y = padding
    })
    self._profile_panel = profile_panel

    local profile_panel_rect = profile_panel:rect({
        name = "background",
		color = Color.black,
		alpha = 0.4,
		layer = -1,
		halign = "scale",
		valign = "scale"
    })

    BoxGuiObject:new(profile_panel, {sides = {
		1,
		1,
		1,
		1
	}})

    local avatar_square = profile_panel:panel({
        name = "avatar_square",
        h = 188,
        w = 188,
        x = padding,
        y = padding
    })

    local avatar_rect = avatar_square:rect({
        name = "avatar_background_status",
        color = self._color_by_status,
        layer = -1,
		halign = "scale",
		valign = "scale"
    })

    local avatar = avatar_square:bitmap({
        name = "avatar",
        texture = "guis/textures/pd2/none_icon",
        h = 184,
        w = 184,
        x = 2,
        y = 2
    })

    Steam:friend_avatar(2, self._player.id, function (texture)
		local avatar = texture or "guis/textures/pd2/none_icon"
        local avatar_square = self._profile_panel:child("avatar_square")
        local avatar_panel = avatar_square:child("avatar")
		avatar_panel:set_image(avatar)
	end)

    local is_infamous = tonumber(self._player.infamy) > 0
    local level = self._player.level or ""
    local built_level = (is_infamous and managers.experience:rank_string(self._player.infamy) .. "-" or "") .. tostring(level)
    local reputation = profile_panel:text({
        name = "reputation",
        font = large_font,
        font_size = large_font_size - 10,
        text = built_level,
        color = Color(0.5, 0.5, 0.5)
    })
    make_fine_text(reputation)
    reputation:set_left(avatar_square:right() + padding)
    reputation:set_top(avatar_square:top())

    local name = profile_panel:text({
        name = "player_name",
        font = large_font,
        font_size = large_font_size - 10,
        text = to_upper(self._player.name),
        color = Color.white
    })
    make_fine_text(name)

    if level ~= "" then
        name:set_left(reputation:right() + 20)
    else
        name:set_left(avatar_square:right() + padding)
    end

    name:set_top(reputation:top())

    local main_state = profile_panel:text({
        name = "player_main_state",
        font = large_font,
        font_size = small_font_size,
        text = to_upper(self._player.main_state),
        color = self._color_by_status
    })
    make_fine_text(main_state)
    main_state:set_left(avatar_square:right() + padding)
    main_state:set_top(name:bottom())

    local sub_state = profile_panel:text({
        name = "player_sub_state",
        font = large_font,
        font_size = small_font_size,
        text = self._player.full_sub_state,
        color = self._color_by_status
    })
    make_fine_text(sub_state)
    sub_state:set_left(avatar_square:right() + padding)
    sub_state:set_top(main_state:bottom() + 15)
end

function FriendLoadoutGui:_setup_loadout()

    local loadout_panel = self._main_panel:panel({
        h = self._main_panel:h() - (large_font_size * 2) + 10,
        w = 500,
        x = -10,
        y = padding
    })
    loadout_panel:set_right(self._main_panel:right() - padding)

    local loadout_panel_rect = loadout_panel:rect({
        name = "background",
		color = Color.black,
		alpha = 0.4,
		layer = -1,
		halign = "scale",
		valign = "scale"
    })

    BoxGuiObject:new(loadout_panel, {sides = {
		1,
		1,
		1,
		1
	}})

    local title = loadout_panel:text({
        text = managers.localization:to_upper_text("NepgearsyMM_Loadout_Header"),
        color = Color.white,
        font = large_font,
        font_size = medium_font_size,
        x = padding,
        y = padding
    })
    make_fine_text(title)

    if not self._is_ingame or not self._has_nepgearsy_menu then
        local loadout_alert = loadout_panel:text({
            text = managers.localization:text("NepgearsyMM_Loadout_Error", {name = self._player.name}),
            color = self._avert_color,
            font = large_font,
            font_size = small_font_size,
            x = padding
        })
        make_fine_text(loadout_alert)

        loadout_alert:set_top(title:bottom() + 20)
        return
    end

    local is_primary_skin = true
	local is_secondary_skin = true

    if self._player.loadout.primary.item_bg_texture == "" or self._player.loadout.primary.item_bg_texture == nil then
		is_primary_skin = false
    else
        is_primary_skin = true
	end

	if self._player.loadout.secondary.item_bg_texture == "" or self._player.loadout.secondary.item_bg_texture == nil then
		is_secondary_skin = false
    else
        is_secondary_skin = true
	end

    if not DB:has(Idstring("texture"), self._player.loadout.primary.item_texture) then
        self._player.loadout.primary.item_texture = "guis/textures/pd2/none_icon"
    end

    if not DB:has(Idstring("texture"), self._player.loadout.secondary.item_texture) then
        self._player.loadout.secondary.item_texture = "guis/textures/pd2/none_icon"
    end

    local primary_icon = loadout_panel:bitmap({
        texture = self._player.loadout.primary.item_texture,
        w = 256,
        h = 128,
        x = loadout_panel:x() / 6,
        layer = 2
    })
    primary_icon:set_top(title:bottom() - 5)

    local primary_rarity = loadout_panel:bitmap({
        texture = self._player.loadout.primary.item_bg_texture,
        w = 256,
        h = 128,
        x = loadout_panel:x() / 6,
        layer = 1,
        visible = is_primary_skin
    })
    primary_rarity:set_top(title:bottom() - 5)

    local primary_text = loadout_panel:text({
        text = self._player.loadout.primary.info_text,
        font = large_font,
        font_size = small_font_size,
        color = self._player.loadout.primary.info_text_color or Color.white,
        align = "center",
        halign = "center",
        vertical = "center",
        hvertical = "center"
    })
    make_fine_text(primary_text)

    primary_text:set_top(primary_icon:bottom())
    primary_text:set_center_x(primary_icon:center_x())

    local secondary_icon = loadout_panel:bitmap({
        texture = self._player.loadout.secondary.item_texture,
        w = 256,
        h = 128,
        x = loadout_panel:x() / 6,
        layer = 2
    })
    secondary_icon:set_top(primary_text:bottom())

    local secondary_rarity = loadout_panel:bitmap({
        texture = self._player.loadout.secondary.item_bg_texture,
        w = 256,
        h = 128,
        x = loadout_panel:x() / 6,
        layer = 1,
        visible = is_secondary_skin
    })
    secondary_rarity:set_top(primary_text:bottom())

    local secondary_text = loadout_panel:text({
        text = self._player.loadout.secondary.info_text,
        font = large_font,
        font_size = small_font_size,
        color = self._player.loadout.secondary.info_text_color or Color.white,
        align = "center",
        halign = "center",
        vertical = "center",
        hvertical = "center"
    })
    make_fine_text(secondary_text)

    secondary_text:set_top(secondary_icon:bottom())
    secondary_text:set_center_x(secondary_icon:center_x())

    local melee_texture = loadout_panel:bitmap({
        texture = self._player.loadout.melee_weapon.item_texture or "guis/textures/pd2/none_icon",
        w = 256 / 2,
        h = 128 / 2,
        x = 64
    })
    melee_texture:set_top(secondary_text:bottom() + 20)
    local throwable = loadout_panel:bitmap({
        texture = self._player.loadout.grenade.item_texture or "guis/textures/pd2/none_icon",
        w = 256 / 2,
        h = 128 / 2
    })
    throwable:set_top(melee_texture:top())
    throwable:set_left(melee_texture:right())
    local deployable = loadout_panel:bitmap({
        texture = self._player.loadout.deployable.item_texture or "guis/textures/pd2/none_icon",
        w = 128 / 2,
        h = 128 / 2
    })
    deployable:set_top(melee_texture:top())
    deployable:set_left(throwable:right())

    local loadout_skills_title = loadout_panel:text({
        text = managers.localization:to_upper_text("NepgearsyMM_Skills_Header"),
        color = Color.white,
        font = large_font,
        font_size = medium_font_size,
        x = padding
    })
    make_fine_text(loadout_skills_title)
    loadout_skills_title:set_top(melee_texture:bottom() + 20)

    local mastermind_points = self._player.skill_points_invested.mastermind
    local enforcer_points = self._player.skill_points_invested.enforcer
    local technician_points = self._player.skill_points_invested.technician
    local ghost_points = self._player.skill_points_invested.ghost
    local fugitive_points = self._player.skill_points_invested.fugitive

    local mastermind_icon = loadout_panel:bitmap({
        texture = "assets/NepgearsyMM/mastermind_icon",
        w = 64,
        h = 64,
        x = padding + 20
    })
    mastermind_icon:set_top(loadout_skills_title:bottom())

    local enforcer_icon = loadout_panel:bitmap({
        texture = "assets/NepgearsyMM/enforcer_icon",
        w = 64,
        h = 64
    })
    enforcer_icon:set_top(mastermind_icon:top())
    enforcer_icon:set_left(mastermind_icon:right() + 32)

    local technician_icon = loadout_panel:bitmap({
        texture = "assets/NepgearsyMM/technician_icon",
        w = 54,
        h = 54
    })
    technician_icon:set_top(mastermind_icon:top() + 5)
    technician_icon:set_left(enforcer_icon:right() + 38)

    local ghost_icon = loadout_panel:bitmap({
        texture = "assets/NepgearsyMM/ghost_icon",
        w = 54,
        h = 54
    })
    ghost_icon:set_top(mastermind_icon:top() + 5)
    ghost_icon:set_left(technician_icon:right() + 38)

    local fugitive_icon = loadout_panel:bitmap({
        texture = "assets/NepgearsyMM/fugitive_icon",
        w = 54,
        h = 54
    })
    fugitive_icon:set_top(mastermind_icon:top() + 5)
    fugitive_icon:set_left(ghost_icon:right() + 38)

    local mastermind_text = loadout_panel:text({
        font = large_font,
        font_size = small_font_size,
        color = Color.white,
        text = tostring(mastermind_points),
        valign = "center",
		align = "center",
		vertical = "center"
    })
    make_fine_text(mastermind_text)
    mastermind_text:set_center_x(mastermind_icon:center_x())
    mastermind_text:set_top(mastermind_icon:bottom() + 5)

    local enforcer_text = loadout_panel:text({
        font = large_font,
        font_size = small_font_size,
        color = Color.white,
        text = tostring(enforcer_points),
        valign = "center",
		align = "center",
		vertical = "center"
    })
    make_fine_text(enforcer_text)
    enforcer_text:set_center_x(enforcer_icon:center_x())
    enforcer_text:set_top(enforcer_icon:bottom() + 5)

    local technician_text = loadout_panel:text({
        font = large_font,
        font_size = small_font_size,
        color = Color.white,
        text = tostring(technician_points),
        valign = "center",
		align = "center",
		vertical = "center"
    })
    make_fine_text(technician_text)
    technician_text:set_center_x(technician_icon:center_x())
    technician_text:set_top(enforcer_text:top())

    local ghost_text = loadout_panel:text({
        font = large_font,
        font_size = small_font_size,
        color = Color.white,
        text = tostring(ghost_points),
        valign = "center",
		align = "center",
		vertical = "center"
    })
    make_fine_text(ghost_text)
    ghost_text:set_center_x(ghost_icon:center_x())
    ghost_text:set_top(enforcer_text:top())

    local fugitive_text = loadout_panel:text({
        font = large_font,
        font_size = small_font_size,
        color = Color.white,
        text = tostring(fugitive_points),
        valign = "center",
		align = "center",
		vertical = "center"
    })
    make_fine_text(fugitive_text)
    fugitive_text:set_center_x(fugitive_icon:center_x())
    fugitive_text:set_top(enforcer_text:top())

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

    if tonumber(mastermind_points) >= 30 then
		mastermind_icon:set_color(Color(1, 1, 0))
		mastermind_text:set_color(Color(1, 0.6, 0))
	end

	if tonumber(enforcer_points) >= 30 then
		enforcer_icon:set_color(Color(1, 1, 0))
		enforcer_text:set_color(Color(1, 0.6, 0))
	end

	if tonumber(technician_points) >= 30 then
		technician_icon:set_color(Color(1, 1, 0))
		technician_text:set_color(Color(1, 0.6, 0))
	end

	if tonumber(ghost_points) >= 30 then
		ghost_icon:set_color(Color(1, 1, 0))
		ghost_text:set_color(Color(1, 0.6, 0))
	end

	if tonumber(fugitive_points) >= 30 then
		fugitive_icon:set_color(Color(1, 1, 0))
		fugitive_text:set_color(Color(1, 0.6, 0))
	end
end

function FriendLoadoutGui:_setup_description()
    local description_panel = self._main_panel:panel({
        w = self._profile_panel:w(),
        h = self._profile_panel:h(),
        x = padding
    })
    description_panel:set_top(self._profile_panel:bottom() + padding)

    self._description_panel = description_panel

    BoxGuiObject:new(description_panel, {sides = {
		1,
		1,
		1,
		1
	}})

    local description_panel_rect = description_panel:rect({
        name = "background",
		color = Color.black,
		alpha = 0.4,
		layer = -1,
		halign = "scale",
		valign = "scale"
    })

    local description_title = description_panel:text({
        text = managers.localization:to_upper_text("NepgearsyMM_Description_Header"),
        font = large_font,
        font_size = medium_font_size,
        color = Color.white,
        x = padding,
        y = padding
    })
    make_fine_text(description_title)

    if NepgearsyMM.DescInfo and NepgearsyMM.DescInfo == "" and self._is_myself then
        local avert_desc = description_panel:text({
            text = managers.localization:text("NepgearsyMM_Description_Setup"),
            font = large_font,
            font_size = small_font_size,
            color = self._avert_color,
            x = padding
        })
        make_fine_text(avert_desc)

        avert_desc:set_top(description_title:bottom() + 20)
        return
    end

    if self._is_myself then
        local desc = description_panel:text({
            text = tostring(NepgearsyMM.DescInfo),
            color = Color.white,
            font = large_font,
            font_size = small_font_size,
            x = padding,
            word_wrap = true,
            wrap = true,
            w = description_panel:w() - padding,
            h = description_panel:h() - padding - description_title:h()
        })
        make_fine_text(desc)

        desc:set_top(description_title:bottom() + 20)
        return
    end

    if self._player.personal_description and self._player.personal_description ~= "" then
        local desc = description_panel:text({
            text = tostring(self._player.personal_description),
            color = Color.white,
            font = large_font,
            font_size = small_font_size,
            x = padding,
            word_wrap = true,
            wrap = true,
            w = description_panel:w() - padding,
            h = description_panel:h() - padding - description_title:h()
        })
        make_fine_text(desc)

        desc:set_top(description_title:bottom() + 20)

    else
        local avert_desc = description_panel:text({
            text = managers.localization:text("NepgearsyMM_Description_Error", {name = self._player.name}),
            font = large_font,
            font_size = small_font_size,
            color = self._avert_color,
            x = padding
        })
        make_fine_text(avert_desc)

        avert_desc:set_top(description_title:bottom() + 20)
        return
    end
end

function FriendLoadoutGui:_setup_profile_buttons()
    local button_panel = self._main_panel:panel({
        w = self._profile_panel:w(),
        h = 106
    })
    button_panel:set_left(self._profile_panel:left())
    button_panel:set_top(self._description_panel:bottom() + padding)

    local button_panel_rect = button_panel:rect({
        name = "background",
		color = Color.black,
		alpha = 0.4,
		layer = -1,
		halign = "scale",
		valign = "scale"
    })

    BoxGuiObject:new(button_panel, {sides = {
		1,
		1,
		1,
		1
	}})

    local button_steam_profile = button_panel:panel({
        w = 300,
        h = button_panel:h() - (padding * 2),
        x = padding,
        y = padding
    })
    self._button_steam_profile = button_steam_profile

    local button_steam_profile_rect = button_steam_profile:rect({
        name = "background",
		color = Color("1b1c24"),
        alpha = 0.6,
		layer = -1,
		halign = "scale",
		valign = "scale"
    })

    BoxGuiObject:new(button_steam_profile, {sides = {
		1,
		1,
		1,
		1
	}})

    local button_steam_profile_text = button_steam_profile:text({
        text = managers.localization:to_upper_text("NepgearsyMM_Button_Steam_Profile"),
        color = Color("50556d"),
        font = large_font,
        font_size = large_font_size - 8,
        valign = "center",
		align = "center",
		vertical = "center"
    })
    make_fine_text(button_steam_profile_text)

    button_steam_profile_text:set_center_x(button_steam_profile:center_x() - padding)
    button_steam_profile_text:set_center_y(button_steam_profile:center_y() - padding)

    local button_steam_achievements = button_panel:panel({
        w = 335,
        h = button_panel:h() - (padding * 2),
        y = padding
    })
    button_steam_achievements:set_left(button_steam_profile:right() + padding)
    self._button_steam_achievements = button_steam_achievements

    local button_steam_achievements_rect = button_steam_achievements:rect({
        name = "background",
		color = Color("1b1c24"),
        alpha = 0.6,
		layer = -1,
		halign = "scale",
		valign = "scale"
    })

    BoxGuiObject:new(button_steam_achievements, {sides = {
		1,
		1,
		1,
		1
	}})

    local button_steam_achievements_text = button_steam_achievements:text({
        text = managers.localization:to_upper_text("NepgearsyMM_Button_Steam_Achievements"),
        color = Color("50556d"),
        font = large_font,
        font_size = large_font_size - 8,
        valign = "center",
		align = "center",
		vertical = "center"
    })
    make_fine_text(button_steam_achievements_text)

    button_steam_achievements_text:set_world_center_x(button_steam_achievements:world_center_x())
    button_steam_achievements_text:set_world_center_y(button_steam_achievements:world_center_y())
end

function FriendLoadoutGui:close()
    if self._panel and self._fullscreen_panel then
		self._panel:parent():remove(self._panel)
        self._fullscreen_panel:parent():remove(self._fullscreen_panel)
    end -- Couldnt find a way to make it work with super.. :c

    managers.blackmarket:verfify_crew_loadout()
end

function FriendLoadoutGui:mouse_pressed(button, x, y)

    FriendLoadoutGui.super.mouse_pressed(self, button, x, y)

    if button ~= Idstring("0") or not self._panel and self._panel:inside(x, y) then
		return
	end

    if button == Idstring("0") then
		if self._button_steam_profile and self._button_steam_profile:visible() and self._button_steam_profile:inside(x, y) then
			managers.menu_component:post_event("menu_enter")
            Steam:overlay_activate("url", "http://steamcommunity.com/profiles/" .. self._player.id .. "/")
			return true
		end

        if self._button_steam_achievements and self._button_steam_achievements:visible() and self._button_steam_achievements:inside(x, y) then
			managers.menu_component:post_event("menu_enter")
            Steam:overlay_activate("url", "http://steamcommunity.com/profiles/" .. self._player.id .. "/stats/PAYDAY2")
			return true
		end
    end
end

function FriendLoadoutGui:mouse_moved(o, x, y)

    FriendLoadoutGui.super.mouse_moved(self, o, x, y)

    local sp_rect = self._button_steam_profile:child("background")
    local sa_rect = self._button_steam_achievements:child("background")

    if self._button_steam_profile and self._button_steam_profile:visible() and self._button_steam_profile:inside(x, y) then
		used = true

		if not self._button_steam_profile_pointed then
			self._button_steam_profile_pointed = true
			managers.menu_component:post_event("highlight")
			sp_rect:set_alpha(1)
            pointer = "link"
			return used, pointer
		end
	end

    if self._button_steam_achievements and self._button_steam_achievements:visible() and self._button_steam_achievements:inside(x, y) then
		used = true

		if not self._button_steam_achievements_pointed then
			self._button_steam_achievements_pointed = true
			managers.menu_component:post_event("highlight")
			sa_rect:set_alpha(1)
            pointer = "link"
			return used, pointer
		end
	end

    if not self._button_steam_achievements:inside(x, y) then
        sa_rect:set_alpha(0.6)
        self._button_steam_achievements_pointed = false
    end

    if not self._button_steam_profile:inside(x, y) then
        sp_rect:set_alpha(0.6)
        self._button_steam_profile_pointed = false
    end
end

function FriendLoadoutGui:make_fine_text(text)
	local x, y, w, h = text:text_rect()

	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))
end
