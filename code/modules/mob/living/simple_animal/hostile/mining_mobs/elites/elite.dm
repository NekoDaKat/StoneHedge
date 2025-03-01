#define TUMOR_INACTIVE 0
#define TUMOR_ACTIVE 1
#define TUMOR_PASSIVE 2

//Elite mining mobs
/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite
	name = "elite"
	desc = ""
	icon = 'icons/mob/lavaland/lavaland_elites.dmi'
	faction = list("boss")
	robust_searching = TRUE
	ranged_ignores_vision = TRUE
	ranged = TRUE
	obj_damage = 5
	vision_range = 6
	aggro_vision_range = 18
	environment_smash = ENVIRONMENT_SMASH_NONE  //This is to prevent elites smashing up the mining station, we'll make sure they can smash minerals fine below.
	harm_intent_damage = 0 //Punching elites gets you nowhere
	stat_attack = UNCONSCIOUS
	layer = LARGE_MOB_LAYER
	sentience_type = SENTIENCE_BOSS
	hud_type = /datum/hud/lavaland_elite
	var/chosen_attack = 1
	var/list/attack_action_types = list()
	var/can_talk = FALSE
	var/obj/loot_drop = null


//Gives player-controlled variants the ability to swap attacks
/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/Initialize(mapload)
	. = ..()
	for(var/action_type in attack_action_types)
		var/datum/action/innate/elite_attack/attack_action = new action_type()
		attack_action.Grant(src)

//Prevents elites from attacking members of their faction (can't hurt themselves either) and lets them mine rock with an attack despite not being able to smash walls.
/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/AttackingTarget()
	if(istype(target, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/M = target
		if(faction_check_mob(M))
			return FALSE
	if(istype(target, /obj/structure/elite_tumor))
		var/obj/structure/elite_tumor/T = target
		if(T.mychild == src && T.activity == TUMOR_PASSIVE)
			var/elite_remove = alert("Re-enter the tumor?", "Despawn yourself?", "Yes", "No")
			if(elite_remove == "No" || !src || QDELETED(src))
				return
			T.mychild = null
			T.activity = TUMOR_INACTIVE
			T.icon_state = "advanced_tumor"
			qdel(src)
			return FALSE
	. = ..()
	if(ismineralturf(target))
		var/turf/closed/mineral/M = target
		M.gets_drilled()

//Elites can't talk (normally)!
/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(can_talk)
		. = ..()
		return TRUE
	return FALSE

/*Basic setup for elite attacks, based on Whoneedspace's megafauna attack setup.
While using this makes the system rely on OnFire, it still gives options for timers not tied to OnFire, and it makes using attacks consistent accross the board for player-controlled elites.*/

/datum/action/innate/elite_attack
	name = "Elite Attack"
	icon_icon = 'icons/mob/actions/actions_elites.dmi'
	button_icon_state = ""
	background_icon_state = "bg_default"
	var/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/M
	var/chosen_message
	var/chosen_attack_num = 0

/datum/action/innate/elite_attack/Grant(mob/living/L)
	if(istype(L, /mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite))
		M = L
		return ..()
	return FALSE

/datum/action/innate/elite_attack/Activate()
	M.chosen_attack = chosen_attack_num
	to_chat(M, chosen_message)

/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/updatehealth()
	. = ..()
	update_health_hud()

/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/update_health_hud()
	if(hud_used)
		var/severity = 0
		var/healthpercent = (health/maxHealth) * 100
		switch(healthpercent)
			if(100 to INFINITY)
				hud_used.healths.icon_state = "elite_health0"
			if(80 to 100)
				severity = 1
			if(60 to 80)
				severity = 2
			if(40 to 60)
				severity = 3
			if(20 to 40)
				severity = 4
			if(10 to 20)
				severity = 5
			if(1 to 20)
				severity = 6
			else
				severity = 7
		hud_used.healths.icon_state = "elite_health[severity]"
		if(severity > 0)
			overlay_fullscreen("brute", /atom/movable/screen/fullscreen/brute, severity)
		else
			clear_fullscreen("brute")

//The Pulsing Tumor, the actual "spawn-point" of elites, handles the spawning, arena, and procs for dealing with basic scenarios.

/obj/structure/elite_tumor
	name = "pulsing tumor"
	desc = ""
	armor = list("blunt" = 100, "slash" = 100, "stab" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE
	var/activity = TUMOR_INACTIVE
	var/boosted = FALSE
	var/times_won = 0
	var/mob/living/carbon/human/activator = null
	var/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/mychild = null
	var/potentialspawns = list(/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/broodmother,
								/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/pandora,
								/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/legionnaire,
								/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/herald)
	icon = 'icons/obj/lavaland/tumor.dmi'
	icon_state = "tumor"
	pixel_x = -16
	light_color = LIGHT_COLOR_RED
	light_range = 3
	anchored = TRUE
	density = FALSE

/obj/structure/elite_tumor/attack_hand(mob/user)
	. = ..()
	if(ishuman(user))
		switch(activity)
			if(TUMOR_PASSIVE)
				activity = TUMOR_ACTIVE
				visible_message(span_boldwarning("[src] convulses as my arm enters its radius.  Your instincts tell you to step back."))
				activator = user
				if(boosted)
					mychild.playsound_local(get_turf(mychild), 'sound/blank.ogg', 40, 0)
					to_chat(mychild, "<b>Someone has activated my tumor.  You will be returned to fight shortly, get ready!</b>")
				addtimer(CALLBACK(src, PROC_REF(return_elite)), 30)
				INVOKE_ASYNC(src, PROC_REF(arena_checks))
			if(TUMOR_INACTIVE)
				activity = TUMOR_ACTIVE
				var/mob/dead/observer/elitemind = null
				visible_message(span_boldwarning("[src] begins to convulse.  Your instincts tell you to step back."))
				activator = user
				if(!boosted)
					addtimer(CALLBACK(src, PROC_REF(spawn_elite)), 30)
					return
				visible_message(span_boldwarning("Something within [src] stirs..."))
				var/list/candidates = pollCandidatesForMob("Do you want to play as a lavaland elite?", ROLE_SENTIENCE, null, ROLE_SENTIENCE, 50, src, POLL_IGNORE_SENTIENCE_POTION)
				if(candidates.len)
					audible_message(span_boldwarning("The stirring sounds increase in volume!"))
					elitemind = pick(candidates)
					elitemind.playsound_local(get_turf(elitemind), 'sound/blank.ogg', 40, 0)
					to_chat(elitemind, "<b>I have been chosen to play as a Lavaland Elite.\nIn a few seconds, you will be summoned on Lavaland as a monster to fight my activator, in a fight to the death.\nYour attacks can be switched using the buttons on the top left of the HUD, and used by clicking on targets or tiles similar to a gun.\nWhile the opponent might have an upper hand with  powerful mining equipment and tools, you have great power normally limited by AI mobs.\nIf you want to win, you'll have to use my powers in creative ways to ensure the kill.  It's suggested you try using them all as soon as possible.\nShould you win, you'll receive extra information regarding what to do after.  Good luck!</b>")
					addtimer(CALLBACK(src, PROC_REF(spawn_elite), elitemind), 100)
				else
					visible_message(span_boldwarning("The stirring stops, and nothing emerges.  Perhaps try again later."))
					activity = TUMOR_INACTIVE
					activator = null


/obj/structure/elite_tumor/proc/spawn_elite(mob/dead/observer/elitemind)
	var/selectedspawn = pick(potentialspawns)
	mychild = new selectedspawn(loc)
	visible_message(span_boldwarning("[mychild] emerges from [src]!"))
	playsound(loc,'sound/blank.ogg', 200, 0, 50, TRUE, TRUE)
	if(boosted)
		mychild.key = elitemind.key
		mychild.sentience_act()
	icon_state = "tumor_popped"
	INVOKE_ASYNC(src, PROC_REF(arena_checks))

/obj/structure/elite_tumor/proc/return_elite()
	mychild.forceMove(loc)
	visible_message(span_boldwarning("[mychild] emerges from [src]!"))
	playsound(loc,'sound/blank.ogg', 200, 0, 50, TRUE, TRUE)
	mychild.revive(full_heal = TRUE, admin_revive = TRUE)
	if(boosted)
		mychild.maxHealth = mychild.maxHealth * 2
		mychild.health = mychild.maxHealth

/obj/structure/elite_tumor/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/gps, "Menacing Signal")
	START_PROCESSING(SSobj, src)

/obj/structure/elite_tumor/Destroy()
	STOP_PROCESSING(SSobj, src)
	mychild = null
	activator = null
	return ..()

/obj/structure/elite_tumor/process()
	if(isturf(loc))
		for(var/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/elitehere in loc)
			if(elitehere == mychild && activity == TUMOR_PASSIVE)
				mychild.adjustHealth(-mychild.maxHealth*0.05)
				var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal(get_turf(mychild))
				H.color = "#FF0000"

/obj/structure/elite_tumor/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/organ/regenerative_core) && activity == TUMOR_INACTIVE && !boosted)
		var/obj/item/organ/regenerative_core/core = I
		if(!core.preserved)
			return
		visible_message(span_boldwarning("As [user] drops the core into [src], [src] appears to swell."))
		icon_state = "advanced_tumor"
		boosted = TRUE
		light_range = 6
		desc = ""
		qdel(core)
		return TRUE

/obj/structure/elite_tumor/proc/arena_checks()
	if(activity != TUMOR_ACTIVE || QDELETED(src))
		return
	INVOKE_ASYNC(src, PROC_REF(fighters_check))  //Checks to see if our fighters died.
	INVOKE_ASYNC(src, PROC_REF(arena_trap))  //Gets another arena trap queued up for when this one runs out.
	INVOKE_ASYNC(src, PROC_REF(border_check))  //Checks to see if our fighters got out of the arena somehow.
	addtimer(CALLBACK(src, PROC_REF(arena_checks)), 50)

/obj/structure/elite_tumor/proc/fighters_check()
	if(activator != null && activator.stat == DEAD || activity == TUMOR_ACTIVE && QDELETED(activator))
		onEliteWon()
	if(mychild != null && mychild.stat == DEAD || activity == TUMOR_ACTIVE && QDELETED(mychild))
		onEliteLoss()

/obj/structure/elite_tumor/proc/arena_trap()
	var/turf/T = get_turf(src)
	if(loc == null)
		return
	for(var/t in RANGE_TURFS(12, T))
		if(get_dist(t, T) == 12)
			var/obj/effect/temp_visual/elite_tumor_wall/newwall
			newwall = new /obj/effect/temp_visual/elite_tumor_wall(t, src)
			newwall.activator = src.activator
			newwall.ourelite = src.mychild

/obj/structure/elite_tumor/proc/border_check()
	if(activator != null && get_dist(src, activator) >= 12)
		activator.forceMove(loc)
		visible_message(span_boldwarning("[activator] suddenly reappears above [src]!"))
		playsound(loc,'sound/blank.ogg', 200, 0, 50, TRUE, TRUE)
	if(mychild != null && get_dist(src, mychild) >= 12)
		mychild.forceMove(loc)
		visible_message(span_boldwarning("[mychild] suddenly reappears above [src]!"))
		playsound(loc,'sound/blank.ogg', 200, 0, 50, TRUE, TRUE)

/obj/structure/elite_tumor/proc/onEliteLoss()
	playsound(loc,'sound/blank.ogg', 200, 0, 50, TRUE, TRUE)
	visible_message(span_boldwarning("[src] begins to convulse violently before beginning to dissipate."))
	visible_message(span_boldwarning("As [src] closes, something is forced up from down below."))
	var/obj/structure/closet/crate/necropolis/tendril/lootbox = new /obj/structure/closet/crate/necropolis/tendril(loc)
	if(!boosted)
		mychild = null
		activator = null
		qdel(src)
		return
	var/lootpick = rand(1, 2)
	if(lootpick == 1 && mychild.loot_drop != null)
		new mychild.loot_drop(lootbox)
	else
		new /obj/item/tumor_shard(lootbox)
	mychild = null
	activator = null
	qdel(src)

/obj/structure/elite_tumor/proc/onEliteWon()
	activity = TUMOR_PASSIVE
	activator = null
	mychild.revive(full_heal = TRUE, admin_revive = TRUE)
	if(boosted)
		times_won++
		mychild.maxHealth = mychild.maxHealth * 0.5
		mychild.health = mychild.maxHealth
	if(times_won == 1)
		mychild.playsound_local(get_turf(mychild), 'sound/blank.ogg', 40, 0)
		to_chat(mychild, span_boldwarning("As the life in the activator's eyes fade, the forcefield around you dies out and you feel my power subside.\nDespite this inferno being my home, you feel as if you aren't welcome here anymore.\nWithout any guidance, my purpose is now for you to decide."))
		to_chat(mychild, "<b>My max health has been halved, but can now heal by standing on my tumor.  Note, it's my only way to heal.\nBear in mind, if anyone interacts with my tumor, you'll be resummoned here to carry out another fight.  In such a case, you will regain my full max health.\nAlso, be weary of my fellow inhabitants, they likely won't be happy to see you!</b>")
		to_chat(mychild, span_bigbold("Note that you are a lavaland monster, and thus not allied to the station.  You should not cooperate or act friendly with any station crew unless under extreme circumstances!"))

/obj/item/tumor_shard
	name = "tumor shard"
	desc = ""
	icon = 'icons/obj/lavaland/artefacts.dmi'
	icon_state = "crevice_shard"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	item_state = "screwdriver_head"
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 1
	throw_range = 5

/obj/item/tumor_shard/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(istype(target, /mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite) && proximity_flag)
		var/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/E = target
		if(E.stat != DEAD || E.sentience_type != SENTIENCE_BOSS || !E.key)
			user.visible_message(span_notice("It appears [E] is unable to be revived right now.  Perhaps try again later."))
			return
		E.faction = list("neutral")
		E.revive(full_heal = TRUE, admin_revive = TRUE)
		user.visible_message(span_notice("[user] stabs [E] with [src], reviving it."))
		E.playsound_local(get_turf(E), 'sound/blank.ogg', 40, 0)
		to_chat(E, "<span class='danger'>I have been revived by [user].  While you can't speak to them, you owe [user] a great debt.  Assist [user.p_them()] in achieving [user.p_their()] goals, regardless of risk.</span")
		to_chat(E, span_bigbold("Note that you now share the loyalties of [user].  You are expected not to intentionally sabotage their faction unless commanded to!"))
		E.maxHealth = E.maxHealth * 0.5
		E.health = E.maxHealth
		E.desc = ""
		E.sentience_type = SENTIENCE_ORGANIC
		qdel(src)
	else
		to_chat(user, span_info("[src] only works on the corpse of a sentient lavaland elite."))

/obj/effect/temp_visual/elite_tumor_wall
	name = "magic wall"
	icon = 'icons/turf/walls/hierophant_wall_temp.dmi'
	icon_state = "wall"
	duration = 50
	smooth = SMOOTH_TRUE
	layer = BELOW_MOB_LAYER
	var/mob/living/carbon/human/activator = null
	var/mob/living/simple_animal/hostile/retaliate/rogue/asteroid/elite/ourelite = null
	color = rgb(255,0,0)
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
	light_color = LIGHT_COLOR_RED

/obj/effect/temp_visual/elite_tumor_wall/Initialize(mapload, new_caster)
	. = ..()
	queue_smooth_neighbors(src)
	queue_smooth(src)

/obj/effect/temp_visual/elite_tumor_wall/Destroy()
	queue_smooth_neighbors(src)
	activator = null
	ourelite = null
	return ..()

/obj/effect/temp_visual/elite_tumor_wall/CanPass(atom/movable/mover, turf/target)
	if(mover == ourelite || mover == activator)
		return FALSE
	else
		return TRUE
