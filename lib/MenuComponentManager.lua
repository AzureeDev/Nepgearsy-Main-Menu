dofile(ModPath .. "lib/FriendLoadoutGui.lua")

Hooks:Add("MenuComponentManagerInitialize", "NepgearsyCreateNewMenu", function(menu)
	menu._active_components["friend_loadout"] = { create = callback(menu, menu, "_create_friend_loadout_gui"), close = callback(menu, menu, "close_friend_loadout_gui") }
end)

Hooks:Add("CoreMenuData.LoadDataMenu", "NepgearsyAddNewNode", function( menu_id, menu )
	if menu_id == "start_menu" then
		local new_node = {
		_meta = "node",
		name = "friend_loadout",
		menu_components = "friend_loadout",
		scene_state = "crew_management",
		[1] = {
			["_meta"] = "default_item",
			["name"] = "back"
		}
	}

	table.insert( menu, new_node )
	end
end)

function MenuComponentManager:create_friends_gui()
	self:close_friends_gui()
	self._friends_book = BookBoxGui:new(self._ws, nil, {
		no_close_legend = true,
		no_scroll_legend = true
	})
	self._friends_gui = FriendsBoxGui:new(self._ws)
	self._friends_book:add_page("Friends", self._friends_gui, true)
	self._friends_book:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

function MenuComponentManager:close_friend_loadout_gui()
	if self._friend_loadout_gui then
		self._friend_loadout_gui:close()

		self._friend_loadout_gui = nil
		self:unregister_component("friend_loadout_gui")
	end
end

function MenuComponentManager:_create_friend_loadout_gui()
	self:create_friend_loadout_gui()
end

function MenuComponentManager:create_friend_loadout_gui(steam_id)
	self._friend_loadout_gui = FriendLoadoutGui:new(self._ws, self._fullscreen_ws, steam_id)
	self:register_component("friend_loadout_gui", self._friend_loadout_gui)
end

Hooks:PostHook(MenuComponentManager, "mouse_pressed", "NepgearsyMousePressed", function(self, o, button, x, y)
	if self._player_profile_gui and self._player_profile_gui:mouse_pressed(button, x, y) then
		return true
	end

	if self._friend_loadout_gui and self._friend_loadout_gui:mouse_pressed(button, x, y) then
		return true
	end
end)

Hooks:PostHook(MenuComponentManager, "mouse_moved", "NepgearsyMouseMoved", function(self, o, x, y)
	if self._player_profile_gui then
		local used, pointer = self._player_profile_gui:mouse_moved(o, x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end

	if self._friend_loadout_gui then
		local used, pointer = self._friend_loadout_gui:mouse_moved(o, x, y)
		wanted_pointer = pointer or wanted_pointer

		if used then
			return true, wanted_pointer
		end
	end
end)

--Annoyingly overkill returns on mouse released making scroll release not work without this :c
Hooks:PreHook(MenuComponentManager, "mouse_released", "NepgearsyCreateFriendsGUI", function(self, o, button, x, y)
	if self._friends_gui then
		self._friends_gui:mouse_released(o, button, x, y)
	end
end)
