/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*
 *		(Veggies)		*
 *						*
 * * * * * * * * * * * **/


/*	..................   Onions   ................... */
/obj/item/reagent_containers/food/snacks/grown/onion/rogue
	desc = "A wonderful vegetable with many layers and broad flavor profile."
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced
	tastes = list("onion" = 1)
	chopping_sound = TRUE
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced
	name = "sliced onion"
	icon_state = "onion_sliced"
	slices_num = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	cooked_smell = /datum/pollutant/food/fried_onion
	can_distill = TRUE
	distill_amt = 6

/*	..................   Cabbage   ................... */
/obj/item/reagent_containers/food/snacks/grown/cabbage/rogue
	desc = "A dense leafed vegetable, crunchy and ripe. A symbol of prosperity for elves"
	slices_num = 3
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced
	dropshrink = 0.7
	chopping_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced
	name = "shredded cabbage"
	icon_state = "cabbage_sliced"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried
	cooked_smell = /datum/pollutant/food/fried_cabbage

/*	..................   Potato   ................... */
/obj/item/reagent_containers/food/snacks/grown/potato/rogue
	desc = "A spud, dwarven icon of growth."
	eat_effect = null
	slices_num = 3
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	tastes = list("potato" = 1)
	chopping_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced
	name = "potato cuts"
	icon_state = "potato_sliced"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	cooked_smell = /datum/pollutant/food/baked_potato
	can_distill = TRUE
	distill_amt = 8

/obj/item/reagent_containers/food/snacks/grown/apple
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced
	slices_num = 3
	chopping_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced
	name = "apple slice"
	icon_state = "apple_sliced"
	desc = "A neatly sliced bit of apple. Nicer to eat. Refined, even."
	tastes = list("airy apple" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/*	..................   Carrot   ................... */
/obj/item/reagent_containers/food/snacks/grown/carrot
	desc = "A long vegetable said to help with eyesight."
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	tastes = list("carrot" = 1)
	dropshrink = 0.75

/*	..................   Cucumber   ................... */
/obj/item/reagent_containers/food/snacks/grown/cucumber
	slices_num = 1
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced
	tastes = list("cucumber" = 1)
	chopping_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced
	name = "cucumber slice"
	icon = 'modular_stonehedge/icons/roguetown/items/produce.dmi'
	icon_state = "cucumber_slices"
	desc = ""
	tastes = list("airy apple" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/*	..................   Eggplant   ................... */
/obj/item/reagent_containers/food/snacks/grown/eggplant
	slices_num = 1
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/eggplantcarved
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE
