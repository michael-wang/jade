--***********************************************************************
-- @file GameAchievement.lua
--***********************************************************************

--=======================================================================
-- Globals
--=======================================================================

-------------------------------------------------------------------------
GC_ACH_POOL = nil
GC_ACH_BATCH = {};

--=======================================================================
-- Subjects
--=======================================================================

-------------------------------------------------------------------------
ACH_NORMAL_MAP1_LV1 = 1;
ACH_NORMAL_MAP1_LV2 = 2;
ACH_NORMAL_MAP1_LV3 = 3;
ACH_NORMAL_MAP1_LV4 = 4;
ACH_NORMAL_MAP2_LV1 = 5;
ACH_NORMAL_MAP2_LV2 = 6;
ACH_NORMAL_MAP2_LV3 = 7;
ACH_NORMAL_MAP2_LV4 = 8;
ACH_NORMAL_MAP3_LV1 = 9;
ACH_NORMAL_MAP3_LV2 = 10;
ACH_NORMAL_MAP3_LV3 = 11;
ACH_NORMAL_MAP3_LV4 = 12;

ACH_SHADOW_MAP1_LV1 = 51;
ACH_SHADOW_MAP1_LV2 = 52;
ACH_SHADOW_MAP2_LV1 = 53;
ACH_SHADOW_MAP2_LV2 = 54;
ACH_SHADOW_MAP3_LV1 = 55;
ACH_SHADOW_MAP3_LV2 = 56;

ACH_NORMAL_UNLOCK_LV1 = 91;
ACH_NORMAL_UNLOCK_LV2 = 92;
ACH_NORMAL_UNLOCK_LV3 = 93;
ACH_NORMAL_UNLOCK_LV4 = 94;
ACH_NORMAL_UNLOCK_LV5 = 95;

ACH_INNOCENT_HURT = 101;
ACH_ENERGY_LOW = 102;
ACH_INNOCENT_MULTLE_HURT = 103;
ACH_MAIL_MAN = 104;
ACH_MONKEY_POTION = 105;
ACH_BOMBER_MAN = 106;
ACH_ENEMY_BLOCKED = 107;
ACH_TUTORIAL_COMPLETED = 109;
ACH_SHADOW_GUARDIAN = 110;

ACH_REVIVE_COUNT_LV1 = 201;
ACH_REVIVE_COUNT_LV2 = 202;
ACH_REVIVE_COUNT_LV3 = 203;
ACH_SCROLL_USE_COUNT_LV1 = 211;
ACH_SCROLL_USE_COUNT_LV2 = 212;
ACH_SCROLL_USE_COUNT_LV3 = 213;
ACH_JADE_TRIGGER_LV1 = 221;
ACH_JADE_TRIGGER_LV2 = 222;
ACH_JADE_TRIGGER_LV3 = 223;

ACH_COIN_EARNED_LV1 = 231;
ACH_COIN_EARNED_LV2 = 232;
ACH_COIN_EARNED_LV3 = 233;
ACH_COIN_EARNED_LV4 = 234;
ACH_KOBAN_EARNED_LV1 = 241;
ACH_KOBAN_EARNED_LV2 = 242;
ACH_KOBAN_EARNED_LV3 = 243;
ACH_KOBAN_EARNED_LV4 = 244;
ACH_COMBO_MAX_LV1 = 251;
ACH_COMBO_MAX_LV2 = 252;
ACH_COMBO_MAX_LV3 = 108;

ACH_ENEMY_NINJA_LV1 = 301;
ACH_ENEMY_NINJA_LV2 = 302;
ACH_ENEMY_NINJA_LV3 = 303;
ACH_ENEMY_HUMAN_LV1 = 311;
ACH_ENEMY_HUMAN_LV2 = 312;
ACH_ENEMY_HUMAN_LV3 = 313;
ACH_ENEMY_GHOST_LV1 = 321;
ACH_ENEMY_GHOST_LV2 = 322;
ACH_ENEMY_GHOST_LV3 = 323;
ACH_INNOCENT_HURT_LV1 = 351;
ACH_INNOCENT_HURT_LV2 = 352;
ACH_INNOCENT_HURT_LV3 = 353;
ACH_MONKEY_CATCH_LV1 = 361;
ACH_MONKEY_CATCH_LV2 = 362;
ACH_MONKEY_CATCH_LV3 = 363;

ACH_FREEZE_COUNT_LV1 = 401;
ACH_STUN_COUNT_LV1 = 411;
ACH_METEOR_COUNT_LV1 = 421;

ACH_WEAPON_KATANA_LV1 = 501;
ACH_WEAPON_KATANA_LV2 = 502;
ACH_WEAPON_BLADE_LV1 = 511;
ACH_WEAPON_BLADE_LV2 = 512;
ACH_WEAPON_SPEAR_LV1 = 521;
ACH_WEAPON_SPEAR_LV2 = 522;

ACH_JADE_SNOWFALL_LV1 = 601;
ACH_JADE_SNOWFALL_LV2 = 602;
ACH_JADE_FORTUNE_LV1 = 611;
ACH_JADE_FORTUNE_LV2 = 612;
ACH_JADE_SOUL_LV1 = 621;
ACH_JADE_SOUL_LV2 = 622;
ACH_JADE_STARLIGHT_LV1 = 631;
ACH_JADE_STARLIGHT_LV2 = 632;
ACH_JADE_RAGE_LV1 = 641;
ACH_JADE_RAGE_LV2 = 642;

ACH_AVATAR_NINJA_LV1 = 701;
ACH_AVATAR_SAMURAI_LV1 = 702;
ACH_AVATAR_WITCH_LV1 = 703;
ACH_AVATAR_ASSASSIN_LV1 = 704;
ACH_AVATAR_THIEF_LV1 = 705;

ACH_NINJA_GRANNY_SPOT = 801;
ACH_JADE_PROTECTION = 802;

ACH_BOSS_LV1 = 901;
ACH_BOSS_LV2 = 902;
ACH_BOSS_LV3 = 903;
ACH_BOSS_LV4 = 904;
ACH_BOSS_LV5 = 905;

-- Mapping from Game Center ID to Google Play Game Achievement's ID.
-- These are subset of Game Center achievements, if an item is not mapped, its not on Google Play.
if IS_PLATFORM_ANDROID then
ACH_ANDROID_ID = {

    [ACH_NORMAL_MAP1_LV1] = "achievement_ninja_assault_beginner_class",
    [ACH_NORMAL_MAP1_LV2] = "achievement_ninja_assault_apprentice_class",
    [ACH_NORMAL_MAP1_LV3] = "achievement_ninja_assault_veteran_class",
    [ACH_NORMAL_MAP1_LV4] = "achievement_ninja_assault_jade_class",
    [ACH_NORMAL_MAP2_LV1] = "achievement_army_attack_beginner_class",
    [ACH_NORMAL_MAP2_LV2] = "achievement_army_attack_apprentice_class",
    [ACH_NORMAL_MAP2_LV3] = "achievement_army_attack_veteran_class",
    [ACH_NORMAL_MAP2_LV4] = "achievement_army_attack_jade_class",
    [ACH_NORMAL_MAP3_LV1] = "achievement_ghost_raid_beginner_class",
    [ACH_NORMAL_MAP3_LV2] = "achievement_ghost_raid_apprentice_class",
    [ACH_NORMAL_MAP3_LV3] = "achievement_ghost_raid_veteran_class",
    [ACH_NORMAL_MAP3_LV4] = "achievement_ghost_raid_jade_class",

    [ACH_SHADOW_MAP1_LV1] = "achievement_ninja_assault_master_class",
    [ACH_SHADOW_MAP1_LV2] = "achievement_ninja_assault_the_way_of_shadow",
    [ACH_SHADOW_MAP2_LV1] = "achievement_army_attack_master_class",
    [ACH_SHADOW_MAP2_LV2] = "achievement_army_attack_the_way_of_shadow",
    [ACH_SHADOW_MAP3_LV1] = "achievement_ghost_raid_master_class",
    [ACH_SHADOW_MAP3_LV2] = "achievement_ghost_raid_the_way_of_shadow",

    [ACH_SHADOW_GUARDIAN] = "achievement_shadow_guardian",

    [ACH_NORMAL_UNLOCK_LV1] = "achievement_1500m_in_ninja_assault",
    [ACH_NORMAL_UNLOCK_LV2] = "achievement_1500m_in_army_attack",
    [ACH_NORMAL_UNLOCK_LV3] = "achievement_3000m_in_ghost_raid",
    [ACH_NORMAL_UNLOCK_LV4] = "achievement_3000m_in_monster_forest",
    [ACH_NORMAL_UNLOCK_LV5] = "achievement_3000m_in_demon_abyss",

    [ACH_INNOCENT_HURT] = "achievement_careless_whisper",
    [ACH_ENERGY_LOW] = "achievement_enemies_are_not_fruits",
    [ACH_INNOCENT_MULTLE_HURT] = "achievement_why_so_serious",
    [ACH_MAIL_MAN] = "achievement_ninjas_message",
    [ACH_MONKEY_POTION] = "achievement_monkey_potion_badge",
    [ACH_BOMBER_MAN] = "achievement_bomber_man",
    [ACH_ENEMY_BLOCKED] = "achievement_hard_boiled_opponent",
    [ACH_TUTORIAL_COMPLETED] = "achievement_pass_the_test",
    [ACH_NINJA_GRANNY_SPOT] = "achievement_granny_ninja",

    [ACH_REVIVE_COUNT_LV1] = "achievement_life_saver",
    [ACH_REVIVE_COUNT_LV2] = "achievement_catch_me_if_you_can",
    [ACH_REVIVE_COUNT_LV3] = "achievement_unconscious_transmigration_of_souls",
    [ACH_SCROLL_USE_COUNT_LV1] = "achievement_scroll_beginner",
    [ACH_SCROLL_USE_COUNT_LV2] = "achievement_the_lord_of_scroll",
    [ACH_SCROLL_USE_COUNT_LV3] = "achievement_the_master_of_scroll",
    [ACH_JADE_TRIGGER_LV1] = "achievement_jade_apprentice",
    [ACH_JADE_TRIGGER_LV2] = "achievement_the_lord_of_jade",
    [ACH_JADE_TRIGGER_LV3] = "achievement_the_master_of_jade",
    [ACH_COMBO_MAX_LV1] = "achievement_100_combos",
    [ACH_COMBO_MAX_LV2] = "achievement_250_combos",
    [ACH_COMBO_MAX_LV3] = "achievement_500_combos",

    [ACH_COIN_EARNED_LV1] = "achievement_coin_worker",
    [ACH_COIN_EARNED_LV2] = "achievement_coin_chaser",
    [ACH_COIN_EARNED_LV3] = "achievement_coin_dozer",
    [ACH_COIN_EARNED_LV4] = "achievement_halfamillionaire",
    [ACH_KOBAN_EARNED_LV1] = "achievement_gold_dealer",
    [ACH_KOBAN_EARNED_LV2] = "achievement_gold_hunter",
    [ACH_KOBAN_EARNED_LV3] = "achievement_gold_dreamer",
    [ACH_KOBAN_EARNED_LV4] = "achievement_wall_street_capitalist",

    [ACH_ENEMY_NINJA_LV1] = "achievement_ninja_slayer",
    [ACH_ENEMY_NINJA_LV2] = "achievement_shadow_destroyer",
    [ACH_ENEMY_NINJA_LV3] = "achievement_hattori_hanzo",
    [ACH_ENEMY_HUMAN_LV1] = "achievement_bandit_buster",
    [ACH_ENEMY_HUMAN_LV2] = "achievement_bounty_hunter",
    [ACH_ENEMY_HUMAN_LV3] = "achievement_miyamoto_musashi",
    [ACH_ENEMY_GHOST_LV1] = "achievement_minion_kicker",
    [ACH_ENEMY_GHOST_LV2] = "achievement_monster_hunter",
    [ACH_ENEMY_GHOST_LV3] = "achievement_ghostbuster",
    [ACH_INNOCENT_HURT_LV1] = "achievement_thats_an_accident",
    [ACH_INNOCENT_HURT_LV2] = "achievement_you_mean_it",
    [ACH_INNOCENT_HURT_LV3] = "achievement_blind_swordmaster",
    [ACH_MONKEY_CATCH_LV1] = "achievement_monkey_catcher",
    [ACH_MONKEY_CATCH_LV2] = "achievement_monkey_lover",
    [ACH_MONKEY_CATCH_LV3] = "achievement_monkey_needs_potion",

    [ACH_FREEZE_COUNT_LV1] = "achievement_diamond_dust",
    [ACH_STUN_COUNT_LV1] = "achievement_twinkle_twinkle_little_stars",
    [ACH_METEOR_COUNT_LV1] = "achievement_the_day_of_judgment",

    [ACH_WEAPON_KATANA_LV1] = "achievement_katana_veteran",
    [ACH_WEAPON_KATANA_LV2] = "achievement_katana_master",
    [ACH_WEAPON_BLADE_LV1] = "achievement_blade_veteran",
    [ACH_WEAPON_BLADE_LV2] = "achievement_blade_master",
    [ACH_WEAPON_SPEAR_LV1] = "achievement_spear_veteran",
    [ACH_WEAPON_SPEAR_LV2] = "achievement_spear_master",

    [ACH_JADE_SNOWFALL_LV1] = "achievement_snowman_maker",
    [ACH_JADE_SNOWFALL_LV2] = "achievement_ice_cracker",
    [ACH_JADE_FORTUNE_LV1] = "achievement_lucky_guy",
    [ACH_JADE_FORTUNE_LV2] = "achievement_fortune_maker",
    [ACH_JADE_SOUL_LV1] = "achievement_point_gatherer",
    [ACH_JADE_SOUL_LV2] = "achievement_level_achiever",
    [ACH_JADE_STARLIGHT_LV1] = "achievement_wish_maker",
    [ACH_JADE_STARLIGHT_LV2] = "achievement_star_shooter",
    [ACH_JADE_RAGE_LV1] = "achievement_frenzy_fighter",
    [ACH_JADE_RAGE_LV2] = "achievement_crazy_berserker",

    [ACH_AVATAR_NINJA_LV1] = "achievement_ninja_of_blue_dragon",
    [ACH_AVATAR_SAMURAI_LV1] = "achievement_samurai_of_black_tortoise",
    [ACH_AVATAR_WITCH_LV1] = "achievement_witch_of_vermilion_bird",
    [ACH_AVATAR_ASSASSIN_LV1] = "achievement_assassin_of_white_tiger",
    [ACH_AVATAR_THIEF_LV1] = "achievement_protector_of_the_realm",

    [ACH_BOSS_LV1] = "achievement_boss_hunt_shadow_ninja",
    [ACH_BOSS_LV2] = "achievement_boss_hunt_greedy_officer",
    [ACH_BOSS_LV3] = "achievement_boss_hunt_ghost_king",
    [ACH_BOSS_LV4] = "achievement_boss_hunt_evil_fox",
    [ACH_BOSS_LV5] = "achievement_boss_hunt_devil_samurai",
};

-- There are two types of achievement in Android: incremental and unlock, which require different API to submit.
-- And achievement cnnot change type after added to Google Play.
-- So I need to way to know which type an achievement is.
ACH_UNLOCK_TYPE = {

    [ACH_INNOCENT_HURT]        = true;
    [ACH_ENERGY_LOW]           = true,
    [ACH_INNOCENT_MULTLE_HURT] = true,
    [ACH_MAIL_MAN]             = true,
    [ACH_MONKEY_POTION]        = true,
    [ACH_BOMBER_MAN]           = true,
    [ACH_ENEMY_BLOCKED]        = true,
    [ACH_TUTORIAL_COMPLETED]   = true,
    [ACH_NINJA_GRANNY_SPOT]    = true,

    [ACH_BOSS_LV1]             = true,
    [ACH_BOSS_LV2]             = true,
    [ACH_BOSS_LV3]             = true,
    [ACH_BOSS_LV4]             = true,
    [ACH_BOSS_LV5]             = true,
};
end -- IS_PLATFORM_ANDROID

-------------------------------------------------------------------------
GC_ACHEIVEMENT_MAX =
{
	-- Level (Normal)
    [ACH_NORMAL_MAP1_LV1] = 500,
    [ACH_NORMAL_MAP1_LV2] = 1500,
    [ACH_NORMAL_MAP1_LV3] = 3000,
    [ACH_NORMAL_MAP1_LV4] = 9000,
    [ACH_NORMAL_MAP2_LV1] = 500,
    [ACH_NORMAL_MAP2_LV2] = 1500,
    [ACH_NORMAL_MAP2_LV3] = 3000,
    [ACH_NORMAL_MAP2_LV4] = 9000,
    [ACH_NORMAL_MAP3_LV1] = 500,
    [ACH_NORMAL_MAP3_LV2] = 1500,
    [ACH_NORMAL_MAP3_LV3] = 3000,
    [ACH_NORMAL_MAP3_LV4] = 9000,
	-- Level (Shadow)	
	[ACH_SHADOW_MAP1_LV1] = 3000,
	[ACH_SHADOW_MAP1_LV2] = 10000,
	[ACH_SHADOW_MAP2_LV1] = 3000,
	[ACH_SHADOW_MAP2_LV2] = 10000,
	[ACH_SHADOW_MAP3_LV1] = 3000,
	[ACH_SHADOW_MAP3_LV2] = 10000,
--[[	
	-- Unlock
	[ACH_NORMAL_UNLOCK_LV1] = 1,
	[ACH_NORMAL_UNLOCK_LV2] = 1,
	[ACH_NORMAL_UNLOCK_LV3] = 1,
	[ACH_NORMAL_UNLOCK_LV4] = 1,
	[ACH_NORMAL_UNLOCK_LV5] = 1,
--]]	
	-- Special ACH
--[[	
    [ACH_INNOCENT_HURT] = 1,
    [ACH_ENERGY_LOW] = 1,
    [ACH_INNOCENT_MULTLE_HURT] = 1,
	[ACH_MAIL_MAN] = 1,
	[ACH_MONKEY_POTION] = 1,
	[ACH_BOMBER_MAN] = 1,
	[ACH_TUTORIAL_COMPLETED] = 1,
--]]	
	[ACH_ENEMY_BLOCKED] = 3,
	[ACH_SHADOW_GUARDIAN] = 99000,
	-- Coin & Koban
	[ACH_COIN_EARNED_LV1] = 500,
	[ACH_COIN_EARNED_LV2] = 5000,
	[ACH_COIN_EARNED_LV3] = 50000,
	[ACH_COIN_EARNED_LV4] = 500000,
	[ACH_KOBAN_EARNED_LV1] = 5,
	[ACH_KOBAN_EARNED_LV2] = 66,
	[ACH_KOBAN_EARNED_LV3] = 777,
	[ACH_KOBAN_EARNED_LV4] = 8888,
	-- Revive, Scroll, Jade
	[ACH_REVIVE_COUNT_LV1] = 6,
	[ACH_REVIVE_COUNT_LV2] = 66,
	[ACH_REVIVE_COUNT_LV3] = 666,
	[ACH_SCROLL_USE_COUNT_LV1] = 8,
	[ACH_SCROLL_USE_COUNT_LV2] = 88,
	[ACH_SCROLL_USE_COUNT_LV3] = 888,
	[ACH_JADE_TRIGGER_LV1] = 11,
	[ACH_JADE_TRIGGER_LV2] = 101,
	[ACH_JADE_TRIGGER_LV3] = 1001,
	-- Combo
	[ACH_COMBO_MAX_LV1] = 100,
	[ACH_COMBO_MAX_LV2] = 300,
	[ACH_COMBO_MAX_LV3] = 600,
	-- Enemy
	[ACH_ENEMY_NINJA_LV1] = 500,
	[ACH_ENEMY_NINJA_LV2] = 5000,
	[ACH_ENEMY_NINJA_LV3] = 50000,
	[ACH_ENEMY_HUMAN_LV1] = 700,
	[ACH_ENEMY_HUMAN_LV2] = 7000,
	[ACH_ENEMY_HUMAN_LV3] = 70000,
	[ACH_ENEMY_GHOST_LV1] = 900,
	[ACH_ENEMY_GHOST_LV2] = 9000,
	[ACH_ENEMY_GHOST_LV3] = 90000,
	[ACH_INNOCENT_HURT_LV1] = 10,
	[ACH_INNOCENT_HURT_LV2] = 100,
	[ACH_INNOCENT_HURT_LV3] = 1000,
	[ACH_MONKEY_CATCH_LV1] = 5,
	[ACH_MONKEY_CATCH_LV2] = 70,
	[ACH_MONKEY_CATCH_LV3] = 900,
	-- Enemy status
	[ACH_FREEZE_COUNT_LV1] = 100,
	[ACH_STUN_COUNT_LV1] = 500,
	[ACH_METEOR_COUNT_LV1] = 999,
	-- Weapon	
	[ACH_WEAPON_KATANA_LV1] = 6,
	[ACH_WEAPON_KATANA_LV2] = 12,
	[ACH_WEAPON_BLADE_LV1] = 5,
	[ACH_WEAPON_BLADE_LV2] = 12,
	[ACH_WEAPON_SPEAR_LV1] = 4,
	[ACH_WEAPON_SPEAR_LV2] = 12,
	-- Jade
	[ACH_JADE_SNOWFALL_LV1] = 3,
	[ACH_JADE_SNOWFALL_LV2] = 10,
	[ACH_JADE_FORTUNE_LV1] = 3,
	[ACH_JADE_FORTUNE_LV2] = 10,
	[ACH_JADE_SOUL_LV1] = 4,
	[ACH_JADE_SOUL_LV2] = 10,
	[ACH_JADE_STARLIGHT_LV1] = 4,
	[ACH_JADE_STARLIGHT_LV2] = 10,
	[ACH_JADE_RAGE_LV1] = 5,
	[ACH_JADE_RAGE_LV2] = 10,
	[ACH_JADE_PROTECTION] = 1,
	-- Avatar
	[ACH_AVATAR_NINJA_LV1] = 15,
	[ACH_AVATAR_SAMURAI_LV1] = 15,
	[ACH_AVATAR_WITCH_LV1] = 15,
	[ACH_AVATAR_ASSASSIN_LV1] = 15,
	[ACH_AVATAR_THIEF_LV1] = 15,
--[[	
	-- Boss
	[ACH_BOSS_LV1] = 1,
	[ACH_BOSS_LV2] = 1,
	[ACH_BOSS_LV3] = 1,
	[ACH_BOSS_LV4] = 1,
	[ACH_BOSS_LV5] = 1,
	-- Granny
	[ACH_NINJA_GRANNY_SPOT] = 1,
--]]	
};

-------------------------------------------------------------------------
GC_ACHEIVEMENT_REPEATABLE =
{
    [ACH_NORMAL_MAP1_LV3] = true,
    [ACH_NORMAL_MAP1_LV4] = true,
    [ACH_NORMAL_MAP2_LV3] = true,
    [ACH_NORMAL_MAP2_LV4] = true,
    [ACH_NORMAL_MAP3_LV3] = true,
    [ACH_NORMAL_MAP3_LV4] = true,

    [ACH_SHADOW_MAP1_LV2] = true,
    [ACH_SHADOW_MAP2_LV2] = true,
    [ACH_SHADOW_MAP3_LV2] = true,

    [ACH_INNOCENT_HURT] = true,
    [ACH_ENERGY_LOW] = true,
    [ACH_INNOCENT_MULTLE_HURT] = true,
	[ACH_MAIL_MAN] = true,
	[ACH_BOMBER_MAN] = true,
	[ACH_ENEMY_BLOCKED] = true,
	[ACH_TUTORIAL_COMPLETED] = true,
	[ACH_SHADOW_GUARDIAN] = true,

	[ACH_FREEZE_COUNT_LV1] = true,
	[ACH_STUN_COUNT_LV1] = true,
	[ACH_METEOR_COUNT_LV1] = true,
	
	[ACH_COMBO_MAX_LV1] = true,
	[ACH_COMBO_MAX_LV2] = true,
	[ACH_COMBO_MAX_LV3] = true,

	[ACH_BOSS_LV1] = true,
	[ACH_BOSS_LV2] = true,
	[ACH_BOSS_LV3] = true,
	[ACH_BOSS_LV4] = true,
	[ACH_BOSS_LV5] = true,

	[ACH_NINJA_GRANNY_SPOT] = true,
};

-------------------------------------------------------------------------
GC_ACHEIVEMENT_BATCH_MAX =
{
	[ACH_SCROLL_USE_COUNT_LV1] = 1,
	[ACH_SCROLL_USE_COUNT_LV2] = 3,
	[ACH_SCROLL_USE_COUNT_LV3] = 5,

	[ACH_JADE_TRIGGER_LV1] = 1,
	[ACH_JADE_TRIGGER_LV2] = 3,
	[ACH_JADE_TRIGGER_LV3] = 5,

    [ACH_ENEMY_NINJA_LV1] = 30,
    [ACH_ENEMY_NINJA_LV2] = 60,
    [ACH_ENEMY_NINJA_LV3] = 90,
	
    [ACH_ENEMY_HUMAN_LV1] = 30,
    [ACH_ENEMY_HUMAN_LV2] = 60,
    [ACH_ENEMY_HUMAN_LV3] = 90,
	
    [ACH_ENEMY_GHOST_LV1] = 30,
    [ACH_ENEMY_GHOST_LV2] = 60,
    [ACH_ENEMY_GHOST_LV3] = 90,

	[ACH_FREEZE_COUNT_LV1] = 5,
	[ACH_STUN_COUNT_LV1] = 5,
	[ACH_METEOR_COUNT_LV1] = 5,
};

-------------------------------------------------------------------------
ACH_MAP_PROGRESS =
{
    [GAME_DIFF_NORMAL] =
    {
        { ACH_NORMAL_MAP1_LV1, ACH_NORMAL_MAP1_LV2, ACH_NORMAL_MAP1_LV3, ACH_NORMAL_MAP1_LV4 },
        { ACH_NORMAL_MAP2_LV1, ACH_NORMAL_MAP2_LV2, ACH_NORMAL_MAP2_LV3, ACH_NORMAL_MAP2_LV4 },
        { ACH_NORMAL_MAP3_LV1, ACH_NORMAL_MAP3_LV2, ACH_NORMAL_MAP3_LV3, ACH_NORMAL_MAP3_LV4 },
    },

    [GAME_DIFF_SHADOW] =
    {
        { ACH_SHADOW_MAP1_LV1, ACH_SHADOW_MAP1_LV2 },
        { ACH_SHADOW_MAP2_LV1, ACH_SHADOW_MAP2_LV2 },
        { ACH_SHADOW_MAP3_LV1, ACH_SHADOW_MAP3_LV2 },
    },
};

-------------------------------------------------------------------------
ACH_LONG_DISTANCE =
{
    [GAME_DIFF_NORMAL] =
	{
		ACH_NORMAL_MAP1_LV4, ACH_NORMAL_MAP2_LV4, ACH_NORMAL_MAP3_LV4,
	},

    [GAME_DIFF_SHADOW] =
	{
		ACH_SHADOW_MAP1_LV2, ACH_SHADOW_MAP2_LV2, ACH_SHADOW_MAP3_LV2,	
	},
};

-------------------------------------------------------------------------
ACH_WEAPON_PROGRESS =
{
	[1] = { ACH_WEAPON_KATANA_LV1, 	ACH_WEAPON_KATANA_LV2 },
	[2] = { ACH_WEAPON_BLADE_LV1, 	ACH_WEAPON_BLADE_LV2 },
	[3] = { ACH_WEAPON_SPEAR_LV1, 	ACH_WEAPON_SPEAR_LV2 },
};

-------------------------------------------------------------------------
ACH_JADE_PROGRESS =
{
	[1] = { ACH_JADE_SNOWFALL_LV1, 	ACH_JADE_SNOWFALL_LV2 },
	[2] = { ACH_JADE_FORTUNE_LV1, 	ACH_JADE_FORTUNE_LV2 },
	[3] = { ACH_JADE_SOUL_LV1, 		ACH_JADE_SOUL_LV2 },
	[4] = { ACH_JADE_STARLIGHT_LV1, ACH_JADE_STARLIGHT_LV2 },
	[5] = { ACH_JADE_RAGE_LV1, 		ACH_JADE_RAGE_LV2 },
};

-------------------------------------------------------------------------
ACH_AVATAR_PROGRESS =
{
	[1] = ACH_AVATAR_NINJA_LV1,
	[2] = ACH_AVATAR_SAMURAI_LV1,
	[3] = ACH_AVATAR_WITCH_LV1,
	[4] = ACH_AVATAR_ASSASSIN_LV1,
	[5] = ACH_AVATAR_THIEF_LV1,
};

-------------------------------------------------------------------------
ACH_BOSS_PROGRESS =
{
	[1] = ACH_BOSS_LV1,
	[2] = ACH_BOSS_LV2,
	[3] = ACH_BOSS_LV3,
	[4] = ACH_BOSS_LV4,
	[5] = ACH_BOSS_LV5,
};
