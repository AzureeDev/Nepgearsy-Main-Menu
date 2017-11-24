function BookBoxGui:init(ws, title, config)
	config = config or {}
	config.h = config.h or 305
	config.w = config.w or 400
	local x, y = ws:size()
	config.x = config.x or 1
	config.y = config.y or 260
	self._header_type = config.header_type or "event"

	BookBoxGui.super.init(self, ws, title, nil, nil, config)
	self._panel:set_visible(false)
	self._pages = {}
	self._page_panels = {}

	self._font = tweak_data.menu.pd2_large_font
	self._font_size = tweak_data.menu.pd2_small_font_size
end

function BookBoxGui:add_page(name, box_gui, visible)
	local panel = self._panel:panel({
		h = 0,
		w = 40,
		x = 0,
		layer = 10,
		name = name,
		visible = false
	})

	panel:rect({
		name = "bg_rect",
		layer = 0,
		color = Color(0.1, 1, 1, 1),
		visible = false
	})
	panel:text({
		y = 0,
		name = "name_text",
		vertical = "center",
		hvertical = "center",
		align = "center",
		halign = "center",
		x = 0,
		layer = 1,
		text = name,
		font = self._font,
		font_size = self._font_size
	})
	box_gui:set_visible(self._visible and (visible or false))
	box_gui:set_position(self:position())
	box_gui:set_size(self:size())
	box_gui:set_title(nil)
	box_gui._panel:child("bottom_line"):set_visible(false)
	box_gui._panel:child("top_line"):set_visible(false)
	table.insert(self._page_panels, panel)
	self:_layout_page_panels()

	self._pages[name] = {
		box_gui = box_gui,
		panel = panel
	}

	if visible then
		self:set_page(name)
	end
end

function BookBoxGui:set_page(name)
	if self._active_page_name == name then
		return
	end

	if self._active_page_name and self._active_page_name ~= name then
		self._pages[self._active_page_name].box_gui:close_page()
	end
	self._active_page_name = name
	self._pages[self._active_page_name].box_gui:open_page()
end

function BookBoxGui:_layout_page_panels()
	local total_w = 0

	for _, p in ipairs(self._page_panels) do
		local name_text = p:child("name_text")
		local _, _, wt, ht = name_text:text_rect()
		total_w = total_w + wt + 1
	end

	local w = 0

	for _, p in ipairs(self._page_panels) do
		local name_text = p:child("name_text")
		local _, _, wt, ht = name_text:text_rect()
		local ws = math.ceil(wt / total_w * self._panel:w())

		if self._header_type == "fit" then
			ws = wt + 10
		end

		p:set_size(ws, ht)
		name_text:set_size(ws, ht)
		name_text:set_center(p:w() / 2, p:h() / 2)
		p:child("bg_rect"):set_size(ws, ht)
		p:set_x(math.ceil(w))

		w = w + math.ceil(p:w()) + 2
	end
end