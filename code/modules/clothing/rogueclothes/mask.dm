/obj/item/clothing/mask/rogue
	name = ""
	icon = 'icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/masks.dmi'
	body_parts_covered = FACE
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/rogue/spectacles
	name = "spectacles"
	desc = "A finely made set of spectacles for those with trouble seeing."
	icon_state = "glasses"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 20
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	anvilrepair = /datum/skill/craft/blacksmithing
//	block2add = FOV_BEHIND

/obj/item/clothing/mask/rogue/spectacles/golden
	name = "golden spectacles"
	desc = "A finely made set of spectacles, these ones seem to have been commissioned by a noble."
	icon_state = "goggles"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 35
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	anvilrepair = /datum/skill/craft/blacksmithing

/obj/item/clothing/mask/rogue/spectacles/Initialize()
	. = ..()
	AddComponent(/datum/component/spill, null, 'sound/blank.ogg')

/obj/item/clothing/mask/rogue/spectacles/Crossed(mob/crosser)
	if(isliving(crosser) && !obj_broken)
		take_damage(11, BRUTE, "blunt", 1)
	..()

/obj/item/clothing/mask/rogue/equipped(mob/user, slot)
	. = ..()
	user.update_fov_angles()

/obj/item/clothing/mask/rogue/dropped(mob/user)
	. = ..()
	user.update_fov_angles()

/obj/item/clothing/mask/rogue/eyepatch
	name = "eyepatch"
	desc = "An eyepatch, fitted for the right eye."
	icon_state = "eyepatch"
	max_integrity = 20
	integrity_failure = 0.5
	block2add = FOV_RIGHT
	body_parts_covered = EYES
	sewrepair = TRUE
	salvage_amount = 1

/obj/item/clothing/mask/rogue/eyepatch/left
	desc = "An eyepatch, fitted for the left eye."
	icon_state = "eyepatch_l"
	block2add = FOV_LEFT

/obj/item/clothing/mask/rogue/lordmask
	name = "golden halfmask"
	desc = "Half of your face turned gold."
	icon_state = "lmask"
	sellprice = 50
	anvilrepair = /datum/skill/craft/blacksmithing

/obj/item/clothing/mask/rogue/lordmask/l
	icon_state = "lmask_l"

/obj/item/clothing/mask/rogue/lepermask
    name = "leper mask"
    desc = "A mask worn by those suffering with leprocy."
    icon_state = "lepermask"

/obj/item/clothing/mask/rogue/facemask
	name = "iron mask"
	desc = "An iron mask which protects the eyes, nose and mouth while also obscuring the face it."
	icon_state = "imask"
	max_integrity = 100
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	resistance_flags = FIRE_PROOF
	armor = list("blunt" = 90, "slash" = 100, "stab" = 80, "bullet" = 20, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	flags_inv = HIDEFACE
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	experimental_onhip = TRUE
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/iron
	clothing_flags = CANT_SLEEP_IN

/obj/item/clothing/mask/rogue/facemask/prisoner/Initialize()
	. = ..()
	name = "cursed mask"
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	clothing_flags = null

/obj/item/clothing/mask/rogue/facemask/prisoner/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/mask/rogue/facemask/gold
	name = "gold mask"
	desc = "A golden mask commonly found in the Zybantine Empire, worn by nobles. Gold is softer than iron therefore it is easier to break than iron masks."
	icon_state = "goldmask"
	max_integrity = 75
	smeltresult = /obj/item/ingot/gold

/obj/item/clothing/mask/rogue/facemask/leper
	name = "steel leper mask"
	desc = "A gem-dust enchanted steel mask, Those are used to suppress the spasms of leprosy... But it'd make me pretty much blind when worn..."
	icon = 'modular_stonehedge/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_stonehedge/icons/roguetown/clothing/onmob/masks.dmi'
	icon_state = "steelmaskleper"
	block2add = FOV_BEHIND
	max_integrity = 200 //same as steel mask

//Cant see a fucking thing.
/obj/item/clothing/mask/rogue/facemask/leper/equipped(mob/living/carbon/human/user)
	. = ..()
	if(user.wear_mask)
		user.apply_status_effect(/datum/status_effect/debuff/lepermask)

/obj/item/clothing/mask/rogue/facemask/leper/attackby(obj/item/I, mob/living/carbon/human/user, params) //for removing into hand check
	. = ..()
	if(!user.wear_mask)
		user.remove_status_effect(/datum/status_effect/debuff/lepermask)

/obj/item/clothing/mask/rogue/facemask/leper/dropped(mob/living/carbon/human/user)
	..()
	if(!user.wear_mask)
		user.remove_status_effect(/datum/status_effect/debuff/lepermask)

/obj/item/clothing/mask/rogue/facemask/leper/gold
	name = "gold leper mask"
	desc = "A gem-dust enchanted gold mask, Those are used to suppress the spasms of leprosy... But it'd make me pretty much blind when worn..."
	icon_state = "goldmaskleper"
	max_integrity = 100
	smeltresult = /obj/item/ingot/gold

/obj/item/clothing/mask/rogue/facemask/steel
	name = "steel mask"
	desc = "A mask of steel which protects the eyes, nose and mouth while also obscuring the face."
	icon_state = "smask"
	max_integrity = 200
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/mask/rogue/facemask/steel/hound
	name = "hound mask"
	desc = "A steel mask, this one looks more comfortable for Lupians."
	icon_state = "smask_hound"

/obj/item/clothing/mask/rogue/shepherd
	name = "halfmask"
	icon_state = "shepherd"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	body_parts_covered = NECK|MOUTH
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	experimental_onhip = TRUE
	sewrepair = TRUE
	salvage_amount = 1

/obj/item/clothing/mask/rogue/shepherd/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			flags_inv = null
			body_parts_covered = NECK
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_wear_mask()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			flags_inv = HIDEFACE|HIDEFACIALHAIR
			body_parts_covered = NECK|MOUTH
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_wear_mask()

/obj/item/clothing/mask/rogue/physician
	name = "plague mask"
	desc = "What better laboratory than the blood-soaked battlefield?"
	icon_state = "physmask"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEEARS
	body_parts_covered = FACE|EARS|EYES|MOUTH|NECK
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = TRUE

/obj/item/clothing/mask/rogue/skullmask
	name = "skull mask"
	desc = "A mask in the shape of a skull, designed to terrify."
	icon_state = "skullmask"
	max_integrity = 100
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	resistance_flags = FIRE_PROOF
	armor = list("blunt" = 45, "slash" = 100, "stab" = 80, "bullet" = 20, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	body_parts_covered = FACE|EYES|MOUTH|HEAD|HAIR
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	experimental_onhip = TRUE
	smeltresult = /obj/item/natural/bone

/obj/item/clothing/mask/rogue/exoticsilkmask
	name = "Exotic Silk Mask"
	icon_state = "exoticsilkmask"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	body_parts_covered = NECK|MOUTH
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = TRUE

/obj/item/clothing/mask/rogue/ragmask
	name = "rag mask"
	icon_state = "ragmask"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	body_parts_covered = NECK|MOUTH
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	experimental_onhip = TRUE
	sewrepair = TRUE

/obj/item/clothing/mask/rogue/ragmask/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			flags_inv = null
			body_parts_covered = NECK
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_wear_mask()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			flags_inv = HIDEFACE|HIDEFACIALHAIR
			body_parts_covered = NECK|MOUTH
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_wear_mask()

/obj/item/clothing/mask/rogue/feldmask
	name = "plague mask"
	desc = "Do no harm."
	icon_state = "feldmask"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEEARS
	body_parts_covered = FACE|EARS|EYES|MOUTH|NECK
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = TRUE

/obj/item/clothing/mask/rogue/surgmask
	name = "pestra mask"
	desc = "Masks often worn by Pestran acolytes. It is similar in design to the mask worn by plague doctors, only modified in such a way to feature three bird's heads instead of one. One for the cure. One for the disease. And one for the compassion towards those who suffer with illness as Pestra does."
	icon_state = "pestramask"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	body_parts_covered = FACE|EARS|EYES|MOUTH|NECK
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = TRUE

/obj/item/clothing/mask/rogue/xylixmask
	name = "xylix mask"
	desc = "Life is a stage and we all play our part."
	icon_state = "xylixmask"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	body_parts_covered = FACE|EARS|EYES|MOUTH|NECK
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = TRUE

/obj/item/clothing/mask/rogue/jaw
	name = "jaw"
	desc = "The jaw of some fierce animal, repurposed into armor."
	icon_state = "jaw"
	body_parts_covered = MOUTH|NECK
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_NECK|ITEM_SLOT_HIP
	sewrepair = TRUE

/obj/item/clothing/mask/rogue/clothblindfold
	name = "cloth blindfold"
	desc = "A blindfold made of cloth."
	icon_state = "clothblindfold"
	max_integrity = 10
	integrity_failure = 0.5
	body_parts_covered = EYES
	sewrepair = TRUE
	tint = 2

/obj/item/clothing/mask/rogue/fakeclothblindfold
	name = "fake cloth blindfold"
	desc = "A blindfold made of cloth."
	icon_state = "clothblindfold"
	max_integrity = 10
	integrity_failure = 0.5
	body_parts_covered = EYES
	sewrepair = TRUE
