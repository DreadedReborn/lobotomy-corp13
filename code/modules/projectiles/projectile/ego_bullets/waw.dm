/obj/projectile/ego_bullet/ego_correctional
	name = "correctional"
	damage = 10
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_hornet
	name = "hornet"
	damage = 40
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_hatred
	name = "magic beam"
	icon_state = "qoh1"
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 50
	spread = 10

/obj/projectile/ego_bullet/ego_hatred/on_hit(atom/target, blocked = FALSE)
	if(ishuman(target) && isliving(firer))
		var/mob/living/carbon/human/H = target
		var/mob/living/user = firer
		if(firer==target)
			return BULLET_ACT_BLOCK
		if(user.faction_check_mob(H)) // Our faction
			switch(damage_type)
				if(WHITE_DAMAGE)
					H.adjustSanityLoss(damage*0.2)
				if(BLACK_DAMAGE)
					H.adjustBruteLoss(-damage*0.1)
					H.adjustSanityLoss(damage*0.1)
				else // Red or pale
					H.adjustBruteLoss(-damage*0.2)
			H.visible_message("<span class='warning'>[src] vanishes on contact with [H]!</span>")
			qdel(src)
			return BULLET_ACT_BLOCK
	..()

/obj/projectile/ego_bullet/ego_hatred/Initialize()
	. = ..()
	icon_state = "qoh[pick(1,2,3)]"
	damage_type = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	flag = damage_type

/obj/projectile/ego_bullet/ego_magicbullet
	name = "magic bullet"
	icon_state = "magic_bullet"
	damage = 80
	speed = 0.1
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	projectile_piercing = PASSMOB

/obj/projectile/ego_bullet/ego_solemnlament
	name = "solemn lament"
	icon_state = "whitefly"
	damage = 15
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_solemnvow
	name = "solemn vow"
	icon_state = "blackfly"
	damage = 15
	damage_type = BLACK_DAMAGE

//Smartgun
/obj/projectile/ego_bullet/ego_loyalty
	name = "loyalty"
	icon_state = "loyalty"
	damage = 8
	speed = 0.2
	nodamage = TRUE	//Damage is calculated later
	damage_type = RED_DAMAGE
	flag = RED_DAMAGE
	projectile_piercing = PASSMOB

/obj/projectile/ego_bullet/ego_loyalty/on_hit(atom/target, blocked = FALSE)
	if(!ishuman(target))
		nodamage = FALSE
	else
		return
	..()
	if(!ishuman(target))
		qdel(src)


