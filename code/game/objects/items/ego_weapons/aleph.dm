/obj/item/ego_weapon/paradise
	name = "paradise lost"
	desc = "\"Behold: you stood at the door and knocked, and it was opened to you. \
	I come from the end, and I am here to stay for but a moment.\""
	special = "This weapon has a ranged attack."
	icon_state = "paradise"
	force = 40
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	attack_verb_continuous = list("purges", "purifies")
	attack_verb_simple = list("purge", "purify")
	hitsound = 'sound/weapons/ego/paradise.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
	var/ranged_cooldown
	var/ranged_cooldown_time = 0.8 SECONDS
	var/ranged_damage = 40

/obj/item/ego_weapon/paradise/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		return
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if(get_dist(user, target_turf) < 2)
		return
	..()
	var/mob/living/carbon/human/H = user
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(target_turf, 'sound/weapons/ego/paradise_ranged.ogg', 50, TRUE)
	var/damage_dealt = 0
	for(var/turf/open/T in range(target_turf, 1))
		new /obj/effect/temp_visual/paradise_attack(T)
		for(var/mob/living/L in T.contents)
			L.apply_damage(ranged_damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			if((L.stat < DEAD) && !(L.status_flags & GODMODE))
				damage_dealt += ranged_damage
	if(damage_dealt > 0)
		H.adjustStaminaLoss(-damage_dealt*0.2)
		H.adjustBruteLoss(-damage_dealt*0.1)
		H.adjustFireLoss(-damage_dealt*0.1)
		H.adjustSanityLoss(damage_dealt*0.1)

/obj/item/ego_weapon/paradise/EgoAttackInfo(mob/user)
	return "<span class='notice'>It deals [force] [damtype] damage in melee.\n\
	Use it on a distant target to perform special attack that can heal you.</span>"

/obj/item/ego_weapon/justitia
	name = "justitia"
	desc = "A sharp sword covered in bandages. It may be able to not only cut flesh but trace of sins as well."
	special = "This weapon has a combo system."
	icon_state = "justitia"
	force = 35
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	hitsound = 'sound/weapons/ego/justitia1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

	var/combo = 0
	/// Maximum world.time after which combo is reset
	var/combo_time
	/// Wait time between attacks for combo to reset
	var/combo_wait = 10

/obj/item/ego_weapon/justitia/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	switch(combo)
		if(5)
			hitsound = 'sound/weapons/ego/justitia2.ogg'
			force *= 1.5
			user.changeNext_move(CLICK_CD_MELEE * 0.5)
		if(1,4)
			hitsound = 'sound/weapons/ego/justitia3.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.3)
		if(6)
			hitsound = 'sound/weapons/ego/justitia4.ogg'
			combo = -1
			user.changeNext_move(CLICK_CD_MELEE * 1.2)
			var/turf/T = get_turf(M)
			new /obj/effect/temp_visual/justitia_effect(T)
			for(var/mob/living/L in T.contents)
				if(L == user)
					continue
				if(L.stat >= DEAD)
					continue
				L.apply_damage(50, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
		else
			hitsound = 'sound/weapons/ego/justitia1.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/da_capo
	name = "da capo"
	desc = "A scythe that swings silently and with discipline like a conductor's gestures and baton. \
	If there were a score for this song, it would be one that sings of the apocalypse."
	special = "This weapon has a combo system."
	icon_state = "da_capo"
	force = 40 // It attacks very fast
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/weapons/ego/da_capo1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

	var/combo = 0 // I am copy-pasting justitia "combo" system and nobody can stop me
	var/combo_time
	var/combo_wait = 14

/obj/item/ego_weapon/da_capo/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	switch(combo)
		if(1)
			hitsound = 'sound/weapons/ego/da_capo2.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.4)
		if(2)
			hitsound = 'sound/weapons/ego/da_capo3.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.7)
			force *= 1.5
			combo = -1
		else
			hitsound = 'sound/weapons/ego/da_capo1.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.5)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/mimicry
	name = "mimicry"
	desc = "The yearning to imitate the human form is sloppily reflected on the E.G.O, \
	as if it were a reminder that it should remain a mere desire."
	special = "This weapon heals you on hit."
	icon_state = "mimicry"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 80
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/abnormalities/nothingthere/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/mimicry/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = force*0.15
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff[damtype] > 0)
				heal_amt *= S.damage_coeff[damtype]
			else
				heal_amt = 0
		user.adjustBruteLoss(-heal_amt)
	..()

/obj/item/ego_weapon/twilight
	name = "twilight"
	desc = "Just like how the ever-watching eyes, the scale that could measure any and all sin, \
	and the beak that could swallow everything protected the peace of the Black Forest... \
	The wielder of this armament may also bring peace as they did."
	icon_state = "twilight"
	force = 25
	damtype = RED_DAMAGE // It's all damage types, actually
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/weapons/ego/twilight.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)

/obj/item/ego_weapon/twilight/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	..()
	for(var/damage_type in list(WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE))
		damtype = damage_type
		armortype = damage_type
		M.attacked_by(src, user)
	damtype = initial(damtype)
	armortype = initial(armortype)

/obj/item/ego_weapon/twilight/EgoAttackInfo(mob/user)
	return "<span class='notice'>It deals [force * 4] red, white, black and pale damage combined.</span>"

/obj/item/ego_weapon/gold_rush
	name = "gold rush"
	desc = "The weapon of someone who can swing their weight around like a truck"
	special = "This weapon deals it's damage after a short windup."
	icon_state = "gold_rush"
	force = 130
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/goldrush_damage = 130
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE

//Replaces the normal attack with the gigafuck punch
/obj/item/ego_weapon/gold_rush/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(do_after(user, 4, target))

		target.visible_message("<span class='danger'>[user] rears up and slams into [target]!</span>", \
						"<span class='userdanger'>[user] punches you with everything you got!!</span>", COMBAT_MESSAGE_RANGE, user)
		to_chat(user, "<span class='danger'>You throw your entire body into this punch!</span>")
		goldrush_damage = force
		//I gotta regrab  justice here
		var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		goldrush_damage *= justicemod

		if(ishuman(target))
			goldrush_damage = 50

		target.apply_damage(goldrush_damage, RED_DAMAGE, null, target.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)		//MASSIVE fuckoff punch

		playsound(src, 'sound/weapons/resonator_blast.ogg', 50, TRUE)
		var/atom/throw_target = get_edge_target_turf(target, user.dir)
		if(!target.anchored)
			target.throw_at(throw_target, 2, 4, user)		//Bigass knockback. You are punching someone with a glove of GOLD
		goldrush_damage = initial(goldrush_damage)
	else
		to_chat(user, "<span class='spider'><b>Your attack was interrupted!</b></span>")
		return

/obj/item/ego_weapon/smile
	name = "smile"
	desc = "The monstrous mouth opens wide to devour the target, its hunger insatiable."
	special = "This weapon has a slightly slower attack speed.\
			This weapon instantly kills targets below 10% health"	//To make it more unique, if it's too strong
	icon_state = "smile"
	force = 100 //Slightly less damage, has an ability
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/smile/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 1.5) // Slow

/obj/item/ego_weapon/smile/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	..()
	if((target.health<=target.maxHealth *0.1	|| target.stat == DEAD) && !(GODMODE in target.status_flags))	//Makes up for the lack of damage by automatically killing things under 10% HP
		target.gib()
		user.adjustBruteLoss(-user.maxHealth*0.1)	//Heal 10% HP. Moved here from the armor, because that's a nightmare to code

/obj/item/ego_weapon/blooming
	name = "blooming"
	desc = "A rose is a rose, by any other name."
	special = "Use this weapon to change it's damage type between red, white and pale."	//like a different rabbit knife. No black though
	icon_state = "rosered"
	force = 70 //Less damage, can swap damage type
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cuts", "slices")
	hitsound = 'sound/weapons/ego/rapier2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/ego_weapon/blooming/attack_self(mob/living/user)
	switch(damtype)
		if(RED_DAMAGE)
			damtype = WHITE_DAMAGE
			force = 60 //Prefers red, you can swap to white if needed
			icon_state = "rosewhite"
		if(WHITE_DAMAGE)
			damtype = PALE_DAMAGE
			force = 40	//I'm not making this more than 40.
			icon_state = "rosepale"
		if(PALE_DAMAGE)
			damtype = RED_DAMAGE
			force = 70
			icon_state = "rosered"
	armortype = damtype
	to_chat(user, "<span class='notice'>\[src] will now deal [force] [damtype] damage.</span>")
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)

/obj/item/ego_weapon/censored
	name = "CENSORED"
	desc = "(CENSORED) has the ability to (CENSORED), but this is a horrendous sight for those watching. \
			Looking at the E.G.O for more than 3 seconds will make you sick."
	special = "This weapon increases its user resistance to all damage sources by 40% while equipped. \
			Using it in hand will activate its special ability. To perform this attack - click on a distant target."
	icon_state = "censored"
	force = 75
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("attacks")
	attack_verb_simple = list("attack")
	hitsound = 'sound/weapons/ego/censored1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

	var/special_attack = FALSE
	var/special_damage = 300
	var/special_cooldown
	var/special_cooldown_time = 10 SECONDS
	var/special_checks_faction = TRUE

/obj/item/ego_weapon/censored/attack_self(mob/living/user)
	if(!CanUseEgo(user))
		return
	if(special_cooldown > world.time)
		return
	special_attack = !special_attack
	if(special_attack)
		to_chat(user, "<span class='notice'>You prepare special attack.</span>")
	else
		to_chat(user, "<span class='notice'>You decide to not use special attack.</span>")

/obj/item/ego_weapon/censored/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(special_cooldown > world.time)
		return
	if(!special_attack)
		return
	special_attack = FALSE
	var/turf/target_turf = get_ranged_target_turf_direct(user, A, 4)
	var/list/turfs_to_hit = getline(user, target_turf)
	for(var/turf/T in turfs_to_hit)
		if(T.density)
			break
		new /obj/effect/temp_visual/cult/sparks(T)
	playsound(user, 'sound/weapons/ego/censored2.ogg', 75)
	special_cooldown = world.time + special_cooldown_time
	if(!do_after(user, 7))
		return
	playsound(user, 'sound/weapons/ego/censored3.ogg', 75)
	var/turf/MT = get_turf(user)
	MT.Beam(target_turf, "censored", time=5)
	for(var/turf/T in turfs_to_hit)
		if(T.density)
			break
		for(var/mob/living/L in T)
			if(special_checks_faction && user.faction_check_mob(L))
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(!H.sanity_lost)
						continue
				else
					continue
			L.apply_damage(special_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))

/obj/item/ego_weapon/censored/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(!ishuman(user))
		return
	if(slot != ITEM_SLOT_HANDS)
		return
	var/mob/living/carbon/human/H = user
	H.physiology.damage_resistance += 40

/obj/item/ego_weapon/censored/dropped(mob/user, silent = FALSE)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	H.physiology.damage_resistance -= 40

/obj/item/ego_weapon/censored/get_clamped_volume()
	return 50
