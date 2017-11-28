Hooks:PostHook( NetworkAccountSTEAM, "_set_presences", "nepmenu_setup_new_presences", function(self)
	local pld = managers.blackmarket:player_loadout_data()
	local current_specialization = managers.skilltree:get_specialization_value("current_specialization")
	local specialization_data = tweak_data.skilltree.specializations[current_specialization]
	local specialization_text = specialization_data and managers.localization:text(specialization_data.name_id) or " "

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
		end
	end
	local icon_atlas_texture = guis_catalog .. "textures/pd2/specialization/icons_atlas"

	local loadout = {
		character = {
			name = pld.character.info_text,
			texture = pld.character.item_texture
		},
		mask = {
			name = pld.mask.info_text,
			texture = pld.mask.item_texture
		},
		primary = {
			name = pld.primary.info_text,
			texture = pld.primary.item_texture,
			rarity = pld.primary.item_bg_texture,
			rarity_text_color = pld.primary.info_text_color
		},
		secondary = {
			name = pld.secondary.info_text,
			texture = pld.secondary.item_texture,
			rarity = pld.secondary.item_bg_texture,
			rarity_text_color = pld.secondary.info_text_color
		},
		melee_weapon = {
			name = pld.melee_weapon.info_text,
			texture = pld.melee_weapon.item_texture
		},
		grenade = {
			name = pld.grenade.info_text,
			texture = pld.grenade.item_texture
		},
		armor = {
			name = pld.armor.info_text,
			texture = pld.armor.item_texture
		},
		deployable = {
			name = pld.deployable.info_text,
			texture = pld.deployable.item_texture
		},
		perk_deck = {
			name = specialization_text,
			texture = icon_atlas_texture,
			x = texture_rect_x,
			y = texture_rect_y,
			current_tier = current_tier,
			max_tier = max_tier
		}
	}

	local personal_desc = tostring(NepgearsyMM.DescInfo)

	Steam:set_rich_presence("infamy", managers.experience:current_rank())
	--Steam:set_rich_presence("has_nepgearsy_menu", "1")
	Steam:set_rich_presence("amount_skillpoints_mastermind", managers.skilltree:get_tree_progress_2("mastermind"))
	Steam:set_rich_presence("amount_skillpoints_enforcer", managers.skilltree:get_tree_progress_2("enforcer"))
	Steam:set_rich_presence("amount_skillpoints_technician", managers.skilltree:get_tree_progress_2("technician"))
	Steam:set_rich_presence("amount_skillpoints_ghost", managers.skilltree:get_tree_progress_2("ghost"))
	Steam:set_rich_presence("amount_skillpoints_fugitive", managers.skilltree:get_tree_progress_2("hoxton"))
	--Steam:set_rich_presence("loadout_character_texture", loadout.character.texture)
	--Steam:set_rich_presence("loadout_character_mask", loadout.mask.texture)
	Steam:set_rich_presence("loadout_primary_name", loadout.primary.name)
	Steam:set_rich_presence("loadout_primary_texture", loadout.primary.texture)
	Steam:set_rich_presence("loadout_primary_rarity", loadout.primary.rarity)
	Steam:set_rich_presence("loadout_secondary_name", loadout.secondary.name)
	Steam:set_rich_presence("loadout_secondary_texture", loadout.secondary.texture)
	Steam:set_rich_presence("loadout_secondary_rarity", loadout.secondary.rarity)
	Steam:set_rich_presence("loadout_melee_texture", loadout.melee_weapon.texture)
	Steam:set_rich_presence("loadout_throwable_texture", loadout.grenade.texture)
	Steam:set_rich_presence("loadout_deployable_texture", loadout.deployable.texture)
	Steam:set_rich_presence("personal_description", personal_desc)
end)
