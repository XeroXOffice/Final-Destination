/obj/machinery/computer/ship/ship_weapon/beam_cannon/particle_lance/handle_beam_damage(var/turf/s, var/d, var/killing_floor = FALSE)
	set waitfor = FALSE
	for(var/turf/T in getline(s,get_target_turf(s, d)))
		var/deflected = FALSE
		for(var/obj/effect/shield/S in T)
			S.take_damage(3000,SHIELD_DAMTYPE_EM)
			if((S.gen.mitigation_em > 0 || S.gen.check_flag(MODEFLAG_EM)) && !S.disabled_for)
				S.take_damage(3000,SHIELD_DAMTYPE_EM)
				deflected = TRUE
		if(deflected)
			var/def_angle = pick(90,-90,0)
			handle_beam_damage(get_step(T, turn(d, 180)), turn(d,180 + def_angle), TRUE)
			handle_beam_on_enemy(get_step(T, turn(d, 180)), turn(d,180 + def_angle))
			log_and_message_admins("��� [gun_name] ������ ����������� �� ����.")
			break
		if(T.density && !killing_floor)
			sleep(beam_speed)
			explosion(T, 4, EX_ACT_DEVASTATING,adminlog = 0, turf_breaker = TRUE)
			if(T)
				T.ex_act(1,TRUE)
		else if(killing_floor && !istype(T, /turf/space))
			sleep(beam_speed)
			explosion(T, 4, EX_ACT_DEVASTATING,adminlog = 0, turf_breaker = TRUE)
			if(T && T.density)
				T.ex_act(1,TRUE)
			var/list/relevant_z = GetConnectedZlevels(s.z)
			for(var/mob/M in GLOB.player_list)
				var/turf/J = get_turf(M)
				if(!J || !(J.z in relevant_z))
					continue
				shake_camera(M, 4)
			if(!T.density && !istype(T, /turf/space))
				empulse(T, heavy_ion_effect_range, light_ion_effect_range)
		else
			sleep(beam_speed)
		for(var/mob/living/U in T)
			U.gib()
		for(var/atom/A in T)
			if(A.density)
				explosion(T, 4, EX_ACT_DEVASTATING,adminlog = 0, turf_breaker = TRUE)
				if(A && A.density)
					A.ex_act(1,TRUE)