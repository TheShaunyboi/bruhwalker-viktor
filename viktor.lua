if game.local_player.champ_name ~= "Viktor" then
	return
end

pred:use_prediction()
viktor_category = menu:add_category("viktor or afk")
viktor_enabled = menu:add_checkbox("enabled", viktor_category, 1)
viktor_combokey = menu:add_keybinder("combo key", viktor_category, 32)

viktor_combo = menu:add_subcategory("combo", viktor_category)
viktor_use_q = menu:add_checkbox("use q", viktor_combo, 1)
viktor_use_w = menu:add_checkbox("use w", viktor_combo, 1)
viktor_use_e = menu:add_checkbox("use e", viktor_combo, 1)
viktor_use_r2 = menu:add_checkbox("use r if hp <=", viktor_combo, 1)
viktor_use_r2_hp = menu:add_slider("r minimum hp percentage", viktor_combo, 0, 100, 30)
viktor_use_r = menu:add_checkbox("use r auto follow", viktor_combo, 1)

viktor_harass = menu:add_subcategory("harass", viktor_category)
viktor_harass_use_q = menu:add_checkbox("use q", viktor_harass, 1)
viktor_harass_use_w = menu:add_checkbox("use w", viktor_harass, 1)
viktor_harass_use_e = menu:add_checkbox("use e", viktor_harass, 1)

viktor_lasthit = menu:add_subcategory("last hit", viktor_category)
viktor_lasthit_use_q = menu:add_checkbox("use q", viktor_lasthit, 0)

viktor_range = menu:add_subcategory("range", viktor_category)
viktor_draw_q = menu:add_checkbox("draw q", viktor_range)
viktor_draw_w = menu:add_checkbox("draw w", viktor_range)
viktor_draw_e = menu:add_checkbox("draw e", viktor_range)
viktor_draw_r = menu:add_checkbox("draw r", viktor_range)

local function do_combo()
	if menu:get_value(viktor_use_r2) == 1 and spellbook:can_cast(SLOT_R) then
		target = selector:find_target(850, health)
		is_r_active = false
		
		pets = game.pets

		for _, v in ipairs(pets) do
			champ_name = v.champ_name
			
			if champ_name == "ViktorSingularity" then 
				owner = v.owner

				if owner.object_id == local_player.object_id and v.is_alive then
					is_r_active = true
				end 
			end
		end
		
		if target.object_id ~= 0 and target:health_percentage() <= menu:get_value(viktor_use_r2_hp) then
			if not is_r_active and not game.local_player:has_buff("viktorchaosstormtimer") then
				origin = target.origin
				my_origin = game.local_player.origin
				distance = vector_math:distance(origin.x, origin.y, origin.z, my_origin.x, my_origin.y, my_origin.z)

				if distance > 700 then
					calc = vector_math:add_to_direction(my_origin.x, my_origin.y, my_origin.z, origin.x, origin.y, origin.z, 700)
					origin.x = calc.x
					origin.y = calc.y
					origin.z = calc.z
				end

				spellbook:cast_spell(SLOT_R, 0.35, origin.x, origin.y, origin.z)
			end
		end
	end

	if menu:get_value(viktor_use_q) == 1 then
		target = selector:find_target(650, health)
	
		if target.object_id ~= 0 then
			if spellbook:can_cast(SLOT_Q) then
				origin = target.origin
				x, y, z = origin.x, origin.y, origin.z
				spellbook:cast_spell(SLOT_Q, 0.35, x, y, z)
			end
		end
	end

	if menu:get_value(viktor_use_w) == 1 then
		target = selector:find_target(800, health)
	
		if target.object_id ~= 0 then
			if spellbook:can_cast(SLOT_W) then
				origin = target.origin
				x, y, z = origin.x, origin.y, origin.z

				if pred_output.can_cast then
					cast_pos = pred_output.cast_pos
					
					spellbook:cast_spell(SLOT_W, 0.35, cast_pos.x, cast_pos.y, cast_pos.z)
				end
			end
		end
	end

	if menu:get_value(viktor_use_e) == 1 then
		target = selector:find_target(525, health)
	
		if target.object_id ~= 0 then
			if spellbook:can_cast(SLOT_E) then
				origin = target.origin
				x, y, z = origin.x, origin.y, origin.z
				my_origin = game.local_player.origin
				pred_output = pred:predict(1050, 0, 525, 80, target, true)

				if pred_output.can_cast then
					cast_pos = pred_output.cast_pos
					spellbook:cast_spell(SLOT_E, 0.35, cast_pos.x, cast_pos.y, cast_pos.z)
				end
			end
		end
		
		target = selector:find_target(1150, health)
	
		if target.object_id ~= 0 then
			if spellbook:can_cast(SLOT_E) then
				origin = target.origin
				my_origin = game.local_player.origin
				x, y, z = origin.x, origin.y, origin.z
				x1, y1, z1 = my_origin.x, my_origin.y, my_origin.z
				
				calc = vector_math:add_to_direction(x1, y, z1, x, y, z, 450)
				pred_output = pred:predict(1050, 0, 680, 80, target, true, false, calc)

				if pred_output.can_cast then
					cast_pos = pred_output.cast_pos
					spellbook:cast_spell(SLOT_E, 0.35, cast_pos.x, cast_pos.y, cast_pos.z, calc.x, calc.y, calc.z)
				end
			end
		end
	end

	if menu:get_value(viktor_use_r) == 1 then
		target = selector:find_target(2000, health)
		is_r_active = false
		
		pets = game.pets

		for _, v in ipairs(pets) do
			champ_name = v.champ_name
			
			if champ_name == "ViktorSingularity" then 
				owner = v.owner

				if owner.object_id == local_player.object_id and v.is_alive then
					is_r_active = true
				end 
			end
		end
		
		if target.object_id ~= 0 then
			if is_r_active and not target:has_buff("ViktorChaosStormGuide") and game.local_player:has_buff("viktorchaosstormtimer") then
				origin = target.origin
				spellbook:cast_spell(SLOT_R, 0.35, origin.x, origin.y, origin.z)
			end
		end
	end
end

local function do_harass()
	if menu:get_value(viktor_harass_use_q) == 1 then
		target = selector:find_target(650, health)
	
		if target.object_id ~= 0 then
			if spellbook:can_cast(SLOT_Q) then
				origin = target.origin
				x, y, z = origin.x, origin.y, origin.z
				spellbook:cast_spell(SLOT_Q, 0.35, x, y, z)
			end
		end
	end

	if menu:get_value(viktor_harass_use_w) == 1 then
		target = selector:find_target(800, health)
	
		if target.object_id ~= 0 then
			if spellbook:can_cast(SLOT_W) then
				origin = target.origin
				x, y, z = origin.x, origin.y, origin.z
				pred_output = pred:predict(0, 1.0, 800, 300, target, true)

				if pred_output.can_cast then
					cast_pos = pred_output.cast_pos
					spellbook:cast_spell(SLOT_W, 0.35, cast_pos.x, cast_pos.y, cast_pos.z)
				end
			end
		end
	end

	if menu:get_value(viktor_harass_use_e) == 1 then
		target = selector:find_target(525, health)
	
		if target.object_id ~= 0 then
			if spellbook:can_cast(SLOT_E) then
				origin = target.origin
				x, y, z = origin.x, origin.y, origin.z
				my_origin = game.local_player.origin
				pred_output = pred:predict(1050, 0, 525, 80, target, true)

				if pred_output.can_cast then
					cast_pos = pred_output.cast_pos
					spellbook:cast_spell(SLOT_E, 0.35, cast_pos.x, cast_pos.y, cast_pos.z)
				end
			end
		end
		
		target = selector:find_target(1150, health)
	
		if target.object_id ~= 0 then
			if spellbook:can_cast(SLOT_E) then
				origin = target.origin
				my_origin = game.local_player.origin
				x, y, z = origin.x, origin.y, origin.z
				x1, y1, z1 = my_origin.x, my_origin.y, my_origin.z
				
				calc = vector_math:add_to_direction(x1, y, z1, x, y, z, 450)
				pred_output = pred:predict(1050, 0, 680, 80, target, true, false, calc)

				if pred_output.can_cast then
					cast_pos = pred_output.cast_pos
					spellbook:cast_spell(SLOT_E, 0.35, cast_pos.x, cast_pos.y, cast_pos.z, calc.x, calc.y, calc.z)
				end
			end
		end
	end
end

local function do_last_hit()
	if menu:get_value(viktor_lasthit_use_q) == 1 then
		if spellbook:can_cast(SLOT_Q) then
			spell_slot = spellbook:get_spell_slot(0)
			q_level = spell_slot.level

			if q_level > 0 then
				dmg = {60, 75, 90, 105, 120}
				
				q_damage = dmg[q_level] + game.local_player:get_ability_power() * 0.4
				
				target = selector:find_target_minion(650)

				if target.object_id ~= 0 then
					missile_speed = 2000
					cast_delay = 0.25
					q_damage = target:calculate_magic_damage(q_damage)
					time_to_attack = target:get_time_to_attack(missile_speed, cast_delay, false)

					if target:can_last_hit(q_damage, time_to_attack, true) then
						origin = target.origin
						x, y, z = origin.x, origin.y, origin.z
						spellbook:cast_spell(SLOT_Q, 0.35, x, y, z)
					end
				end
			end
		end
	end
end

local function on_tick()
	if game:is_key_down(menu:get_value(viktor_combokey)) and menu:get_value(viktor_enabled) == 1 then
		do_combo()
	end

	if combo:get_mode() == MODE_HARASS then
		do_harass()
	end

	if combo:get_mode() == MODE_LASTHIT then
		do_last_hit()
	end
end

local function on_draw()
	local_player = game.local_player

	if local_player.object_id ~= 0 then
		origin = local_player.origin
		x, y, z = origin.x, origin.y, origin.z

		if menu:get_value(viktor_draw_e) == 1 then
			renderer:draw_circle(x, y, z, 525, 150, 150, 150, 150)
			renderer:draw_circle(x, y, z, 1200, 150, 150, 150, 150)
		end

		if menu:get_value(viktor_draw_w) == 1 then
			renderer:draw_circle(x, y, z, 800, 150, 150, 150, 150)
		end

		if menu:get_value(viktor_draw_q) == 1 then
			renderer:draw_circle(x, y, z, 650, 150, 150, 150, 150)
		end

		if menu:get_value(viktor_draw_r) == 1 then
			renderer:draw_circle(x, y, z, 700, 150, 150, 150, 150)
		end
		
		pets = game.pets

		for _, v in ipairs(pets) do
			champ_name = v.champ_name
			
			if champ_name == "ViktorSingularity" then 
				owner = v.owner

				if owner.object_id == local_player.object_id and v.is_alive then
					origin = v.origin
					x, y, z = origin.x, origin.y, origin.z

					renderer:draw_circle(x, y, z, 300, 150, 150, 150, 150)
				end 
			end
		end
	end
end

local function on_level(level)
	if level < 19 then
		spell_order = {0, 2, 2, 1, 2, 3, 2, 0, 2, 0, 3, 0, 0, 1, 1, 3, 1, 1}
		--spellbook:level_spell_slot(spell_order[level])
	end
end

client:set_event_callback("on_level", on_level)
client:set_event_callback("on_tick", on_tick)
client:set_event_callback("on_draw", on_draw)