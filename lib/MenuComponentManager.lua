function MenuComponentManager:create_friends_gui()
	self:close_friends_gui()

	self._friends_book = BookBoxGui:new(self._ws, nil, {
		no_close_legend = true,
		no_scroll_legend = true
	})

	self._friends_gui = FriendsBoxGui:new(self._ws, "Friends", "")
	--self._friends2_gui = FriendsBoxGui:new(self._ws, "Test", "", nil, nil, "recent")
	--self._friends3_gui = FriendsBoxGui:new(self._ws, "Test", "")

	self._friends_book:add_page("Friends", self._friends_gui, true)
	--self._friends_book:add_page("Recent Players", self._friends2_gui)
	--self._friends_book:add_page("Clan", self._friends3_gui)
	self._friends_book:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)

	
end

--Annoyingly overkill returns on mouse released making scroll release not work without this :c
Hooks:PreHook(MenuComponentManager, "mouse_released", "NepgearsyCreateFriendsGUI", function(self, o, button, x, y)
	if self._friends_gui then
		self._friends_gui:mouse_released(o, button, x, y)
	end
end)