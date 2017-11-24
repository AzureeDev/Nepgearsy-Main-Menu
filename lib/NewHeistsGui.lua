Hooks:PostHook( NewHeistsGui, "init", "nepmenu_post_init_newheists", function(self, ws, fullscreen_ws)
	local PANEL_PADDING = 10

	if managers.menu_component._blt_notifications then
		if self._content_panel then
			local header_h = tweak_data.menu.pd2_small_font_size + PANEL_PADDING
			local wx = self._content_panel:world_x() - 25
			local wy = managers.menu_component._blt_notifications._panel:world_y()
			wx, wy = managers.gui_data:convert_pos(ws, fullscreen_ws, wx, wy)

			self._content_panel:set_world_y(wy - header_h)
			self._content_panel:set_x(wx)
		end
	else
		if self._content_panel then
			self._content_panel:set_bottom(self._panel:height() - PANEL_PADDING * 2)
		end
	end
end)