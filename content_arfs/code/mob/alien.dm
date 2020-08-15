// Roxy!
/mob/living/simple_mob/animal/roxy
	name = "Roxy"
	icon_state = "maid"
	icon_living = "maid"
	icon_dead = "maid_dead"
	icon_rest = "maid_sleep"
	desc = "A friendly xenomorph maid!"
	icon = 'content_arfs/icons/mob/mobs/alien.dmi'
	pixel_x = -16
	default_pixel_x = -16
	health = 100
	maxHealth = 100
	max_co2 = 10 //Lets them go outside without dying of co2
	response_help = "hugs"
	layer = MOB_LAYER
	vore_active = TRUE
	has_hands = TRUE
	movement_cooldown = 2
	meat_amount = 3
	makes_dirt = FALSE
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	melee_damage_lower = 10
	melee_damage_upper = 15
	universal_understand = TRUE
