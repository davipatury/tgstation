/mob/living/gib(no_brain, no_organs, no_bodyparts)
	var/prev_lying = lying
	if(stat != DEAD)
		death(1)

	if(!prev_lying)
		gib_animation()

	spill_organs(no_brain, no_organs, no_bodyparts)

	if(!no_bodyparts)
		spread_bodyparts(no_brain, no_organs)

	spawn_gibs(no_bodyparts)
	qdel(src)

/mob/living/proc/gib_animation()
	return

/mob/living/proc/spawn_gibs()
	new /obj/effect/gibspawner/generic(loc, viruses)

/mob/living/proc/spill_organs()
	return

/mob/living/proc/spread_bodyparts()
	return

/mob/living/dust()
	death(1)

	if(buckled)
		buckled.unbuckle_mob(src,force=1)

	dust_animation()
	spawn_dust()
	qdel(src)

/mob/living/proc/dust_animation()
	return

/mob/living/proc/spawn_dust()
	new /obj/effect/decal/cleanable/ash(loc)


/mob/living/death(gibbed)
	stat = DEAD
	unset_machine()
	timeofdeath = world.time
	tod = worldtime2text()
	var/turf/T = get_turf(src)
	if(mind && mind.name && mind.active && (!(T.flags & NO_DEATHRATTLE)))
		var/area/A = get_area(T)
		var/rendered = "<span class='deadsay'><b>[mind.name]</b> has died at <b>[A.name]</b>.</span>"
		deadchat_broadcast(rendered, follow_target = src, message_type=DEADCHAT_DEATHRATTLE)
	if(mind)
		mind.store_memory("Time of death: [tod]", 0)
	living_mob_list -= src
	if(!gibbed)
		dead_mob_list += src
	paralysis = 0
	stunned = 0
	weakened = 0
	set_drugginess(0)
	SetSleeping(0, 0)
	blind_eyes(1)
	reset_perspective(null)
	hide_fullscreens()
	update_action_buttons_icon()
	update_damage_hud()
	update_health_hud()
	update_canmove()
	med_hud_set_health()
	med_hud_set_status()

	for(var/s in ownedSoullinks)
		var/datum/soullink/S = s
		S.ownerDies(gibbed)
	for(var/s in sharedSoullinks)
		var/datum/soullink/S = s
		S.sharerDies(gibbed)

	return TRUE
