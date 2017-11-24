Hooks:PostHook( NetworkAccountSTEAM, "_set_presences", "nepmenu_setup_new_presences", function(self)
	Steam:set_rich_presence("infamy", managers.experience:current_rank())
end)