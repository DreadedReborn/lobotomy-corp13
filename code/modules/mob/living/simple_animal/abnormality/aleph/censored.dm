/mob/living/simple_animal/hostile/abnormality/censored
	name = "CENSORED"
	desc = "What is this... It's too disgusting to even look at..."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "censored"
	icon_living = "censored"
	pixel_x = -16
	base_pixel_x = -16
	faction = list("censored")
	speak_emote = list("screeches")
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/censored/attack.ogg'
	/* Stats */
	threat_level = ALEPH_LEVEL
	fear_level = ALEPH_LEVEL + 3
	health = 4000
	maxHealth = 4000
	obj_damage = 600
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 60
	melee_damage_upper = 75
	speed = 4
	move_to_delay = 5
	/* Works */
	start_qliphoth = 2
	can_breach = TRUE
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(80, 70, 60, 55, 50),
						ABNORMALITY_WORK_INSIGHT = list(90, 80, 70, 65, 60),
						ABNORMALITY_WORK_ATTACHMENT = list(70, 60, 50, 45, 40),
						ABNORMALITY_WORK_REPRESSION = 0,
						"Sacrifice" = 999,
						)
	work_damage_amount = 14
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/censored
		)

	gift_type =  /datum/ego_gifts/censored

	var/can_act = TRUE

/* Combat */
/mob/living/simple_animal/hostile/abnormality/censored/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/censored/Moved()
	. = ..()
	if(!(status_flags & GODMODE))
		for(var/mob/living/carbon/human/H in view(1, src))
			if(H.stat >= SOFT_CRIT || H.health < 0)
				Convert(H)
				break

/mob/living/simple_animal/hostile/abnormality/censored/CanAttack(atom/the_target)
	if(isliving(target) && !ishuman(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/censored/AttackingTarget()
	. = ..()
	if(!can_act)
		return
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.stat >= SOFT_CRIT || H.health < 0)
		Convert(H)

/mob/living/simple_animal/hostile/abnormality/censored/proc/Convert(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(!can_act)
		return
	can_act = FALSE
	forceMove(get_turf(H))
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	playsound(src, 'sound/abnormalities/censored/convert.ogg', 45, FALSE, 5)
	SLEEP_CHECK_DEATH(3)
	new /obj/effect/temp_visual/censored(get_turf(src))
	for(var/i = 1 to 3)
		new /obj/effect/gibspawner/generic/silent(get_turf(src))
		SLEEP_CHECK_DEATH(5.5)
	var/mob/living/simple_animal/hostile/mini_censored/C = new(get_turf(src))
	if(!QDELETED(H))
		C.desc = "What the hell is this? It shouldn't exist... On the second thought, it reminds you of [H.real_name]..."
		H.gib()
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1)
	adjustBruteLoss(-(maxHealth*0.1))
	can_act = TRUE

/* Work */
/mob/living/simple_animal/hostile/abnormality/censored/attempt_work(mob/living/carbon/human/user, work_type)
	if(work_type == "Sacrifice")
		to_chat(user, "<span class='warning'>You hesitate for a moment...</span>")
		if(!do_after(user, 3 SECONDS, target = user))
			to_chat(user, "<span class='warning'>You decide it's not worth it.</span>")
			return null
		user.Stun(30 SECONDS)
		step_towards(user, src)
		sleep(0.3 SECONDS)
		step_towards(user, src)
		new /obj/effect/temp_visual/censored(get_turf(src))
		sleep(0.3 SECONDS)
		playsound(src, 'sound/abnormalities/censored/sacrifice.ogg', 45, FALSE, 10)
		user.death()
		for(var/i = 1 to 3)
			new /obj/effect/gibspawner/generic/silent(get_turf(src))
			sleep(5.4)
		datum_reference.qliphoth_change(1)
		QDEL_NULL(user)
		return null
	return TRUE

/mob/living/simple_animal/hostile/abnormality/censored/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/censored/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/censored/breach_effect(mob/living/carbon/human/user)
	..()
	icon_living = "censored_breach"
	icon_state = icon_living
	return

/* The mini censoreds */
/mob/living/simple_animal/hostile/mini_censored
	name = "???"
	desc = "What the hell is this? It shouldn't exist... On the second thought, it reminds you of someone you knew..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "censored_mini"
	icon_living = "censored_mini"
	faction = list("censored")
	speak_emote = list("screeches")
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/censored/mini_attack.ogg'
	/* Stats */
	health = 600
	maxHealth = 600
	obj_damage = 300
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 14
	melee_damage_upper = 20
	speed = 3
	move_to_delay = 4
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	density = FALSE
	var/list/breach_affected = list()

/mob/living/simple_animal/hostile/mini_censored/Initialize()
	..()
	playsound(get_turf(src), 'sound/abnormalities/censored/mini_born.ogg', 50, 1, 4)
	base_pixel_x = rand(-6,6)
	pixel_x = base_pixel_x
	base_pixel_y = rand(-6,6)
	pixel_y = base_pixel_y

/mob/living/simple_animal/hostile/mini_censored/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(status_flags & GODMODE)
		return FALSE
	addtimer(CALLBACK(src, .proc/ShakePixels), rand(7, 14))
	ShakePixels()
	FearEffect()
	return

/mob/living/simple_animal/hostile/mini_censored/proc/ShakePixels()
	animate(src, pixel_x = base_pixel_x + rand(-3, 3), pixel_y = base_pixel_y + rand(-3, 3), time = 2)
	return

// Applies fear damage to everyone in range, copied from abnormalities
/mob/living/simple_animal/hostile/mini_censored/proc/FearEffect()
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H in breach_affected)
			continue
		if(HAS_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE))
			continue
		breach_affected += H
		H.adjustSanityLoss(-20)
		if(H.sanity_lost)
			continue
		to_chat(H, "<span class='warning'>Here it comes!")
	return
