--***********************************************************************
-- @file GameAvatarData.lua
--***********************************************************************

AVATAR_ID = 1;
AVATAR_NAME = 2;
AVATAR_ICON = 3;
AVATAR_STAT = 4;
AVATAR_LVNAME = 5;
AVATAR_SFX = 6;
AVATAR_LIFE = 7;
AVATAR_ENERGY = 8;
AVATAR_SPEED = 9;
AVATAR_DODGE = 10
AVATAR_COIN = 11;
AVATAR_CRIT = 12;

LIFE_BASE_FACTOR =   { 1, 1.18, 1.39, 1.64, 1.94, 2.29, 2.70, 3.19, 3.76, 4.44, 5.23, 6.18, 7.29, 8.60, 10.15 };
ENERGY_BASE_FACTOR = { 1, 1.08, 1.16, 1.24, 1.34, 1.44, 1.54, 1.66, 1.78, 1.92, 2.06, 2.22, 2.38, 2.56, 2.75  };
AVATAR_SPEED_LV =    { 150, 115, 110, 100, 95, 90, 85, 80, 75, 70 };
DEFAULT_EXP_DATA =   { 0, 2200, 3300, 5500, 8800, 14000, 22000, 34000, 54000, 90000, 165000, 330000, 700000, 1540000, 3460000 };

--[[ @DEBUG
	--ENERGY_BASE_FACTOR = { 1, 1.06, 1.12, 1.19, 1.26, 1.34, 1.42, 1.50, 1.59, 1.69, 1.79, 1.90, 2.01, 2.13, 2.26  };
	--AVATAR_SPEED_LV =    { 200, 140, 120, 100, 95, 90, 85, 80, 75, 70 };
	DEFAULT_EXP_DATA = { 0, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10 };
--]]

AVATAR_MAX_LV = #DEFAULT_EXP_DATA;

AVATAR_LV_UNLOCK_JADE =
{
    [2] = 1,
    [4] = 2,
    [6] = 3,
    [8] = 4,
    [10] = 5,
};

AVATAR_LV_UNLOCK_SCROLL =
{
    [3] = 2,
    [5] = 3,
    [7] = 4,
    [9] = 5,
};

AVATAR_NINJA = 1;
AVATAR_SAMURAI = 2;
AVATAR_WITCH = 3;
AVATAR_ASSASSIN = 4;
AVATAR_THIEF = 5;
AVATAR_WARLORD = 6;

AVATAR_DATA_POOL =
{
    -- Ninja
    [AVATAR_NINJA] =
    {
		[AVATAR_ID] = "ninja",
		[AVATAR_NAME] = "avatar_ninjagirl",
		[AVATAR_ICON] = "ui_scroll_avatarbar_01",
		[AVATAR_STAT] = "ui_shopicon_avatar_charater01",
		[AVATAR_LVNAME] = "ui_lvup_01",
		[AVATAR_SFX] = SFX_CHAR_AVATAR_FEMALE_WOUNDED,
        [AVATAR_LIFE] = 35, --AVATAR_LIFE_LV[4],
        [AVATAR_ENERGY] = 55, --AVATAR_ENERGY_LV[4],
        [AVATAR_SPEED] = AVATAR_SPEED_LV[4],
		[AVATAR_DODGE] =
		{
			10,		-- EK_NORMAL
			10,		-- EK_BOMB
			10,		-- EK_RANGED
			10,		-- EK_GHOST
		},
		--[AVATAR_COIN] = nil,
    },
    -- Samurai
    [AVATAR_SAMURAI] =
    {
		[AVATAR_ID] = "samurai",
		[AVATAR_NAME] = "avatar_samurai",
		[AVATAR_ICON] = "ui_scroll_avatarbar_02",
		[AVATAR_STAT] = "ui_shopicon_avatar_charater02",
		[AVATAR_LVNAME] = "ui_lvup_02",
		[AVATAR_SFX] = SFX_CHAR_AVATAR_FEMALE_WOUNDED,
        [AVATAR_LIFE] = 50, --AVATAR_LIFE_LV[6],
        [AVATAR_ENERGY] = 60, --AVATAR_ENERGY_LV[6],
        [AVATAR_SPEED] = AVATAR_SPEED_LV[2],
		[AVATAR_DODGE] =
		{
			10,		-- EK_NORMAL
			40,		-- EK_BOMB
			15,		-- EK_RANGED
			15,		-- EK_GHOST
		},
		--[AVATAR_COIN] = nil,
    },
    -- Witch
    [AVATAR_WITCH] =
    {
		[AVATAR_ID] = "witch",
		[AVATAR_NAME] = "avatar_witch",
		[AVATAR_ICON] = "ui_scroll_avatarbar_03",
		[AVATAR_STAT] = "ui_shopicon_avatar_charater03",
		[AVATAR_LVNAME] = "ui_lvup_03",
		[AVATAR_SFX] = SFX_CHAR_AVATAR_FEMALE_WOUNDED,
        [AVATAR_LIFE] = 30, --AVATAR_LIFE_LV[3],
        [AVATAR_ENERGY] = 70, --AVATAR_ENERGY_LV[6],
        [AVATAR_SPEED] = AVATAR_SPEED_LV[5],
		[AVATAR_DODGE] =
		{
			10,		-- EK_NORMAL
			15,		-- EK_BOMB
			15,		-- EK_RANGED
			40,		-- EK_GHOST
		},
		--[AVATAR_COIN] = nil,
    },
    -- Assassin
    [AVATAR_ASSASSIN] =
    {
		[AVATAR_ID] = "assassin",
		[AVATAR_NAME] = "avatar_assassin",
		[AVATAR_ICON] = "ui_scroll_avatarbar_04",
		[AVATAR_STAT] = "ui_shopicon_avatar_charater04",
		[AVATAR_LVNAME] = "ui_lvup_04",
		[AVATAR_SFX] = SFX_CHAR_AVATAR_MALE_WOUNDED,
        [AVATAR_LIFE] = 45, --AVATAR_LIFE_LV[4],
        [AVATAR_ENERGY] = 50, --AVATAR_ENERGY_LV[4],
        [AVATAR_SPEED] = AVATAR_SPEED_LV[6],
		[AVATAR_DODGE] =
		{
			10,		-- EK_NORMAL
			15,		-- EK_BOMB
			40,		-- EK_RANGED
			15,		-- EK_GHOST
		},
		--[AVATAR_COIN] = nil,
    },
    -- Thief
    [AVATAR_THIEF] =
    {
		[AVATAR_ID] = "thief",
		[AVATAR_NAME] = "avatar_thief",
		[AVATAR_ICON] = "ui_scroll_avatarbar_05",
		[AVATAR_STAT] = "ui_shopicon_avatar_charater05",
		[AVATAR_LVNAME] = "ui_lvup_05",
		[AVATAR_SFX] = SFX_CHAR_AVATAR_MALE_WOUNDED,
        [AVATAR_LIFE] = 50, --AVATAR_LIFE_LV[6],
        [AVATAR_ENERGY] = 55, --AVATAR_ENERGY_LV[3],
        [AVATAR_SPEED] = AVATAR_SPEED_LV[5],
		[AVATAR_DODGE] =
		{
			20,		-- EK_NORMAL
			25,		-- EK_BOMB
			25,		-- EK_RANGED
			20,		-- EK_GHOST
		},
		[AVATAR_COIN] = true,
    },
---[[ @Warlord
    -- Warlord
    [AVATAR_WARLORD] =
    {
		[AVATAR_ID] = "warlord",
		[AVATAR_NAME] = "avatar_berserker1",
		[AVATAR_ICON] = "ui_scroll_avatarbar_06",
		[AVATAR_STAT] = "ui_shopicon_avatar_charater06",
		[AVATAR_LVNAME] = "ui_lvup_06",
		[AVATAR_SFX] = SFX_CHAR_AVATAR_MALE_WOUNDED,
        [AVATAR_LIFE] = 70,
        [AVATAR_ENERGY] = 60,
        [AVATAR_SPEED] = AVATAR_SPEED_LV[6],
		[AVATAR_DODGE] =
		{
			30,		-- EK_NORMAL
			30,		-- EK_BOMB
			30,		-- EK_RANGED
			30,		-- EK_GHOST
		},
		[AVATAR_COIN] = nil,
		[AVATAR_CRIT] = true,
    },
--]]	
};

AVATAR_MAX = #AVATAR_DATA_POOL;
