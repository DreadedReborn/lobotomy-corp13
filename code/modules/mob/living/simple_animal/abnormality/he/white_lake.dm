#define STATUS_EFFECT_CHAMPION /datum/status_effect/champion
//White Lake from wonderlabs, by Kirie saito
//It's very buggy, and I can't test it alone
/mob/living/simple_animal/hostile/abnormality/whitelake
	name = "White Lake"
	desc = "A ballet dancer, absorbed in her work."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "white_lake"
	icon_living = "white_lake"
	maxHealth = 600
	health = 600
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 10,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 30
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE
	/// Grab her champion
	var/champion
	//Has the weapon been given out?
	var/sword = FALSE
	start_qliphoth = 3

	ego_list = list(
		/datum/ego_datum/weapon/wings,
		/datum/ego_datum/armor/wings
		)
	gift_type = /datum/ego_gifts/waltz
	gift_chance = 0


/mob/living/simple_animal/hostile/abnormality/whitelake/work_chance(mob/living/carbon/human/user, chance)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 60)
		var/newchance = chance-30 //You suck, die. I hate you
		return newchance
	return chance

/mob/living/simple_animal/hostile/abnormality/whitelake/success_effect(mob/living/carbon/human/user, work_type, pe)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 60)		//Doesn't like these people
		champion = user

/mob/living/simple_animal/hostile/abnormality/whitelake/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/whitelake/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 60)
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/whitelake/zero_qliphoth(mob/living/carbon/human/user)
	datum_reference.qliphoth_change(3)
	if(!champion)
		return
	var/mob/living/carbon/human/H = champion
	H.Apply_Gift(new gift_type)	//It's a gift now! Free shit! Oh wait you- oh god you just stabbed that man.
	H.apply_status_effect(STATUS_EFFECT_CHAMPION)
	if(!sword)
		waltz(H)
	//Replaces AI with murder one
	if (!H.sanity_lost)
		H.adjustSanityLoss(-500)
	QDEL_NULL(H.ai_controller)
	H.ai_controller = /datum/ai_controller/insane/murder/whitelake
	H.InitializeAIController()
	champion = null
	return

/mob/living/simple_animal/hostile/abnormality/whitelake/proc/waltz(mob/living/carbon/human/H)
	var/obj/item/held = H.get_active_held_item()
	var/obj/item/wep = new /obj/item/ego_weapon/flower_waltz(H)
	H.dropItemToGround(held) //Drop weapon
	RegisterSignal(H, COMSIG_LIVING_DEATH, .proc/Champion_Death_Sword)
	ADD_TRAIT(wep, TRAIT_NODROP, wep)
	H.put_in_hands(wep) 		//Time for pale
	sword = TRUE

// If Champ dies, sword is droppable
/mob/living/simple_animal/hostile/abnormality/whitelake/proc/Champion_Death_Sword(mob/living/gibbed)
	var/obj/item/ego_weapon/flower_waltz/sword
	if (istype(gibbed.get_active_held_item(), /obj/item/ego_weapon/flower_waltz))
		sword = gibbed.get_active_held_item()
		REMOVE_TRAIT(sword, TRAIT_NODROP, src)
	if (istype(gibbed.get_inactive_held_item(), /obj/item/ego_weapon/flower_waltz))
		sword = gibbed.get_inactive_held_item()
		REMOVE_TRAIT(sword, TRAIT_NODROP, src)
	UnregisterSignal(gibbed, COMSIG_LIVING_DEATH)

//Outfit and Attacker's sword.
/datum/outfit/whitelake
	head = /obj/item/clothing/head/ego_gift/whitelake

/obj/item/clothing/head/ego_gift/whitelake
	name = "waltz of the flowers"
	icon_state = "whitelake"
	icon = 'icons/obj/clothing/ego_gear/head.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/head.dmi'

//WAW Class, you have to sacrifice someone for it
/obj/item/ego_weapon/flower_waltz
	name = "waltz of the flowers"
	desc = "It's awfully fun to write a march for tin soldiers, a waltz of the flowers."
	special = "Cannot be dropped until moved from your hands. Twice as effective against monsters."
	icon_state = "flower_waltz"
	force = 22
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	attack_verb_continuous = list("slices", "cuts")
	attack_verb_simple = list("slices", "cuts")
	hitsound = 'sound/weapons/bladeslice.ogg'
	//No requirements because who knows who will use it.

// Sets the weapon to not be droppable until it's moved from the main hand. No more leg sweeping.
/obj/item/ego_weapon/flower_waltz/equipped(mob/user, slot, initial = FALSE)
	.=..()
	if (slot != ITEM_SLOT_HANDS)
		REMOVE_TRAIT(src, TRAIT_NODROP, src)

/obj/item/ego_weapon/flower_waltz/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if (!ishuman(A) && istype(A, /mob/living))
		force = 44
	return

/obj/item/ego_weapon/flower_waltz/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	force = 22
	return

//Slightly different AI lines
/datum/ai_controller/insane/murder/whitelake
	lines_type = /datum/ai_behavior/say_line/insanity_whitelake

/datum/ai_behavior/say_line/insanity_whitelake
	lines = list(
				"I will protect her!!",
				"You're in the way!",
				"I will dance with her forever!"
				)
//CHAMPION
//Sets the defenses of the champion
/datum/status_effect/champion
	id = "champion"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 6000		//Lasts 10 minutes, guaranteed.
	alert_type = /atom/movable/screen/alert/status_effect/champion

/atom/movable/screen/alert/status_effect/champion
	name = "The Champion"
	desc = "You are White Lake's champion, and she has empowered you temporarily."

/datum/status_effect/champion/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod *= 0.3
		L.physiology.white_mod *= 0.1
		L.physiology.black_mod *= 0.1
		L.physiology.pale_mod *= 0.2

/datum/status_effect/champion/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod /= 0.3
		L.physiology.white_mod /= 0.1
		L.physiology.black_mod /= 0.1
		L.physiology.pale_mod /= 0.2

#undef STATUS_EFFECT_CHAMPION
