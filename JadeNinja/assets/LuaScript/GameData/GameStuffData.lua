--***********************************************************************
-- @file GameStuffData.lua
--***********************************************************************

--======================================
-- @Stuff
--======================================
STUFF_TYPE = 1;
STUFF_ICON = 2;
STUFF_INFO = 3;
STUFF_DESC = 4;
STUFF_SHOPLOOK = 5;
STUFF_PRICE = 6;
STUFF_ATTR = 7;

ST_MAX = 0;
ST_WEAPON = 1;
ST_JADE = 2;
ST_AVATAR = 3;
ST_COIN = 4;
ST_TREASURE = 5;

-- Attr for Weapon
ST_WEAPON_TYPE = 1;
ST_WEAPON_FX = 2;
ST_WEAPON_POWER = 3;
ST_WEAPON_ENERGY = 4;
ST_WEAPON_CRITICAL = 5;
ST_WEAPON_SKILL = 6;

WEAPON_TYPE_KATANA = 1;
WEAPON_TYPE_BLADE = 2;
WEAPON_TYPE_SPEAR = 3;
WEAPON_MAX = WEAPON_TYPE_SPEAR;

WS_TYPE = 1;
WS_VALUE = 2;

WEAPON_SKILL_KNOCKBACK = 1;
WEAPON_SKILL_STAB = 2;
WEAPON_SKILL_PROTECT = 3;

-- Attr for Item
ST_ITEM_EFFECT = 1;
ST_ITEM_VALUE = 2;

-- Attr for Jade
ST_JADE_CHANCE = 1;

-- Item effects (Use only once & use immediately)
ITEM_EFFECT_KOBAN_GAIN = 1;
ITEM_EFFECT_COIN_GAIN = 2;
ITEM_EFFECT_LIFE_MAX = 3;
ITEM_EFFECT_ENERGY_MAX = 4;

--==============================================================================
-- @Weapon
--==============================================================================
WEAPON_PRICE =
{
--[[
	[WEAPON_TYPE_KATANA] = { 1, 600,  900, 1500, 3000, 5500, 11000, 18000, 30000, 45000, 57000, 74000, },
	[WEAPON_TYPE_BLADE]  = { 1, 750, 1100, 1900, 3800, 6800, 13000, 23000, 38000, 57000, 71000, 93000, },
	[WEAPON_TYPE_SPEAR]  = { 1, 650, 1000, 1700, 3300, 5900, 11500, 19500, 32500, 49000, 62000, 81000, },
--]]	
---[[ @FinalWeapon
	[WEAPON_TYPE_KATANA] = { 1, 600,  900, 1500, 3000, 5500, 11000, 18000, 30000, 45000, 63000, 87000,  150000 },
	[WEAPON_TYPE_BLADE]  = { 1, 750, 1100, 1900, 3800, 6800, 13000, 23000, 38000, 57000, 78000, 110000, 190000 },
	[WEAPON_TYPE_SPEAR]  = { 1, 650, 1000, 1700, 3300, 5900, 11500, 19500, 32500, 49000, 68000, 94000,  160000 },
--]]	
};

WEAPON_STR =
{
	[WEAPON_TYPE_KATANA] = "katana",
	[WEAPON_TYPE_BLADE] = "blade",
	[WEAPON_TYPE_SPEAR] = "spear",
};

WEAPON_MAX_LV = #WEAPON_PRICE[1];

--==============================================================================
-- @Jade
--==============================================================================
JADE_EFFECT_ENEMY_FREEZE = 1;
JADE_EFFECT_COIN_DROP = 2;
JADE_EFFECT_EXP_GAIN = 3;
JADE_EFFECT_ENEMY_STUN = 4;
JADE_EFFECT_ENEMY_CRIT = 5;
JADE_EFFECT_INNO_PROTECT = 6;

JE_ID = 1;
JE_ICON = 2;
JE_TEXT = 3;
JE_SHOPICON = 4;
JE_SCROLLICON = 5;

JADE_DATA_POOL =
{
	[JADE_EFFECT_ENEMY_FREEZE] =
	{
		"enemy_freeze",
		"effect_jadeicon_01",
		"effect_jadebuff_01",
		"ui_shopicon_upgrade_jade1",
		"ui_scroll_jadebar_01",
	},

	[JADE_EFFECT_COIN_DROP] =
	{
		"coin_drop",
		"effect_jadeicon_02",
		"effect_jadebuff_02",
		"ui_shopicon_upgrade_jade2",
		"ui_scroll_jadebar_02",
	},

	[JADE_EFFECT_EXP_GAIN] =
	{
		"exp_gain",
		"effect_jadeicon_03",
		"effect_jadebuff_03",
		"ui_shopicon_upgrade_jade3",
		"ui_scroll_jadebar_03",
	},

	[JADE_EFFECT_ENEMY_STUN] =
	{
		"enemy_stun",
		"effect_jadeicon_04",
		"effect_jadebuff_04",
		"ui_shopicon_upgrade_jade4",
		"ui_scroll_jadebar_04",
	},

	[JADE_EFFECT_ENEMY_CRIT] =
	{
		"enemy_crit",
		"effect_jadeicon_05",
		"effect_jadebuff_05",
		"ui_shopicon_upgrade_jade5",
		"ui_scroll_jadebar_05",
	},

	[JADE_EFFECT_INNO_PROTECT] =
	{
		"inno_protect",
		"effect_jadeicon_06",
		"effect_jadebuff_06",
		"ui_shopicon_upgrade_jade6",
		"ui_scroll_jadebar_06",
	},
};

JADE_STR =
{
	[JADE_EFFECT_ENEMY_FREEZE] = "snowfall",
	[JADE_EFFECT_COIN_DROP] = "fortune",
	[JADE_EFFECT_EXP_GAIN] = "soul",
	[JADE_EFFECT_ENEMY_STUN] = "starlight",
	[JADE_EFFECT_ENEMY_CRIT] = "rage",
	[JADE_EFFECT_INNO_PROTECT] = "protection",
};

JADE_NORMAL_MAX = JADE_EFFECT_ENEMY_CRIT;
JADE_MAX = #JADE_DATA_POOL;

JADE_EFFECT_DATA =
{
	[JADE_EFFECT_ENEMY_FREEZE] = { 10, 12, 15, 18, 21, 25, 30, 35, 40, 45, 50, 60, 70 },
	[JADE_EFFECT_COIN_DROP] =	{ 30, 32, 34, 36, 38, 40, 42, 45, 50, 55, 60, 65, 70 },
	[JADE_EFFECT_EXP_GAIN] =		{ 20, 24, 28, 32, 36, 40, 45, 50, 60, 70, 80, 90, 99 },
	[JADE_EFFECT_ENEMY_STUN] =	{  9, 10, 11, 13, 15, 17, 19, 21, 23, 25, 27, 30, 40 },
	[JADE_EFFECT_ENEMY_CRIT] =	{ 1.30, 1.33, 1.36, 1.40, 1.45, 1.50, 1.55, 1.60, 1.65, 1.70, 1.80, 1.9, 1.99 },
	[JADE_EFFECT_INNO_PROTECT] = { 0, },
};

JADE_PRICE =
{
	[JADE_EFFECT_ENEMY_FREEZE] = { 1, 120,  400,  720, 1100, 2200, 3700,  4800,  6100,  7500,  9100, 22000, 45000 },
	[JADE_EFFECT_COIN_DROP] 	  = { 1, 100,  300,  400,  700, 1000, 3300,  4700,  6400,  9000, 12000, 16000, 37000 },
	[JADE_EFFECT_EXP_GAIN]	  = { 1, 150,  320,  570,  900, 1300, 3400,  4500,  5700,  7000,  8500, 10000, 12000 },
	[JADE_EFFECT_ENEMY_STUN]	  = { 1, 500, 1100, 2000, 3000, 4400, 5900,  7700,  9800, 12000, 15000, 20000, 40000 },
	[JADE_EFFECT_ENEMY_CRIT]	  = { 1, 300,  500, 1200, 2300, 3300, 4500,  5800,  8600, 11000, 26000, 31000, 46000 },
};

JADE_MAX_LV = #JADE_PRICE[1];

JADE_EFFECT_FUNC =
{
	[JADE_EFFECT_ENEMY_FREEZE] =
	{
		Enter = function(chance)
			EnemyManager:SetBladeEnchant("freeze", chance);
		end,
		
		Exit = function()
			EnemyManager:ClearBladeEnchant();
		end,
	},

	[JADE_EFFECT_COIN_DROP] =
	{
		Enter = function(chance)
			EnemyManager:SetBladeEnchant("coin_drop");
			EnemyManager:SetDropRate(chance);
		end,
		
		Exit = function()
			EnemyManager:ClearBladeEnchant();
			EnemyManager:SetDropRate(DEFAULT_DROP_RATE);
		end,
	},

	[JADE_EFFECT_ENEMY_STUN] =
	{
		Enter = function(chance)
			EnemyManager:SetBladeEnchant("stun", chance);
		end,
		
		Exit = function()
			EnemyManager:ClearBladeEnchant();
		end,
	},

	[JADE_EFFECT_EXP_GAIN] =
	{
		Enter = function(chance)
			EnemyManager:SetBladeEnchant("energy_gain");
			EnemyManager:SetEnergyBallRate(chance);
		end,
		
		Exit = function()
			EnemyManager:ClearBladeEnchant();
			EnemyManager:SetEnergyBallRate(0);
		end,
	},

	[JADE_EFFECT_ENEMY_CRIT] =
	{
		Enter = function(chance)
			EnemyManager:SetBladeEnchant("enemy_crit");
			BladeManager:SetCriticalHitFactor(chance);
		end,
		
		Exit = function()
			EnemyManager:ClearBladeEnchant();
			BladeManager:SetCriticalHitFactor(DEFAULT_CRITICAL_HIT_FACTOR);
		end,
	},

	[JADE_EFFECT_INNO_PROTECT] =
	{
		Enter = function()
			EnemyManager:EnableInnocentProtect(true);
			LevelManager:EnableInnocentProtect(true);
		end,
		
		Exit = function()
			EnemyManager:EnableInnocentProtect(false);
			LevelManager:EnableInnocentProtect(false);
		end,
	},
};

--======================================
-- @Avatar
--======================================
AVATAR_PRE_ID = 3100;
AVATAR_POST_ID = 100;

AVATAR_PRICE =
{
	1,	    -- Ninja
	-50,	-- Samurai
	-120,	-- Witch
	-200,	-- Assassin
	0,  	-- Thief
	0,      -- Berserker
};

AVATAR_STR =
{
	[3101] = "ninja",
	[3102] = "samurai",
	[3103] = "witch",
	[3104] = "assassin",
	[3105] = "thief",
	[3106] = "warlord",
};

--======================================
-- @Coinbag & @Treasure
--======================================

COINBAG_PRICE =
{
	-1,
	-10,
	-100,
	-1000,
};

COINBAG_COUNT =
{
	100,
	1200,
	15000,
	200000,
};

TREASURE_COUNT =
{
	150,
	500,
	1500,
	6000,
	80,  	-- Starter Kit
};

IAP_STARTERKIT_COIN = 25000;

COINBAG_MAX = #COINBAG_COUNT;
TREASURE_MAX = #TREASURE_COUNT;

--======================================
-- @Drop
--======================================
COIN_CHANCE = 1;
COIN_LOOK = 2;
COIN_VALUE = 3;
COIN_SCALE = 4;

DROP_COIN_DATA =
{
	{ 100, "coin",    1, 0.85 },
	{ 100, "coinlv2", 2, 1.0 },
	{ 100, "coinlv2", 3, 1.1 },
	{ 100, "coinlv3", 5, 1.2 },
	{ 100, "coinlv3", 6, 1.3 },
};

DROP_DATA_NUM = #DROP_COIN_DATA;

DROP_TYPE_COIN = 1;
DROP_TYPE_JADE = 2;

--======================================
-- @Energy
--======================================
ENERGY_COST_KATANA = 2;
ENERGY_COST_BLADE = 5;
ENERGY_COST_SPEAR = 3;

ENERGY_LOW_THRESHOLD = 13;
ENERGY_ZERO_THRESHOLD = 5;

--======================================
-- @Shop
--======================================

ITEM_ID_MAX = 9999;
AVATAR_ID_PREFIX = 3100;

SHOP_ITEM_POOL =
{
	["Weapon"] =
	{
--[[	
		[WEAPON_TYPE_KATANA] = { 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, },
		[WEAPON_TYPE_BLADE] =  { 1201, 1202, 1203, 1204, 1205, 1206, 1207, 1208, 1209, 1210, 1211, 1212, },
		[WEAPON_TYPE_SPEAR] =  { 1301, 1302, 1303, 1304, 1305, 1306, 1307, 1308, 1309, 1310, 1311, 1312, },
--]]		
---[[ @FinalWeapon	
		[WEAPON_TYPE_KATANA] = { 1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113 },
		[WEAPON_TYPE_BLADE] =  { 1201, 1202, 1203, 1204, 1205, 1206, 1207, 1208, 1209, 1210, 1211, 1212, 1213 },
		[WEAPON_TYPE_SPEAR] =  { 1301, 1302, 1303, 1304, 1305, 1306, 1307, 1308, 1309, 1310, 1311, 1312, 1313 },
--]]		
	},
	
	["Jade"] =
	{
		[1] = { 4001, },
		[2] = { 4101, 4102, 4103, 4104, 4105, 4106, 4107, 4108, 4109, 4110, 4111, 4112, 4113 },
		[3] = { 4201, 4202, 4203, 4204, 4205, 4206, 4207, 4208, 4209, 4210, 4211, 4212, 4213 },
		[4] = { 4301, 4302, 4303, 4304, 4305, 4306, 4307, 4308, 4309, 4310, 4311, 4312, 4313 },
		[5] = { 4401, 4402, 4403, 4404, 4405, 4406, 4407, 4408, 4409, 4410, 4411, 4412, 4413 },
		[6] = { 4501, 4502, 4503, 4504, 4505, 4506, 4507, 4508, 4509, 4510, 4511, 4512, 4513 },
	},

	["Avatar"] =
	{
		[1] = { 3106 },
		[2] = { 3105 },
		[3] = { 3101 },
		[4] = { 3102 },
		[5] = { 3103 },
		[6] = { 3104 },
	},
	
	["Coinbag"] =
	{
		8101, 8102, 8103, 8104,
	},
	
	["Treasure"] =
	{
		9201, 9101, 9102, 9103, 9104,
	},
};

ITEM_POS_AVATAR_IAP =
{
---[[ @Thief	
	[1] = true,		-- Berserker
	[2] = true,		-- Thief
	[3] = false,
	[4] = false,
	[5] = false,
	[6] = false,
--]]	
--[[
	[1] = false,
	[3] = false,
	[4] = false,
	[5] = false,
--]]
};

ITEM_POS_AVATAR_ID =
{
	[1] = AVATAR_WARLORD,
	[2] = AVATAR_THIEF,
	[3] = AVATAR_NINJA,
	[4] = AVATAR_SAMURAI,
	[5] = AVATAR_WITCH,
	[6] = AVATAR_ASSASSIN,
};

ITEM_POS_JADE_IAP =
{
	[1] = true,		-- Inno Protect
};

ITEM_POS_JADE_ID =
{
	[1] = JADE_EFFECT_INNO_PROTECT,
	[2] = JADE_EFFECT_ENEMY_FREEZE,
	[3] = JADE_EFFECT_COIN_DROP,
	[4] = JADE_EFFECT_EXP_GAIN,
	[5] = JADE_EFFECT_ENEMY_STUN,
	[6] = JADE_EFFECT_ENEMY_CRIT,
};

JADE_SHOW_LV =
{
	[JADE_EFFECT_ENEMY_FREEZE] = true,
	[JADE_EFFECT_COIN_DROP] = true,
	[JADE_EFFECT_EXP_GAIN] = true,
	[JADE_EFFECT_ENEMY_STUN] = true,
	[JADE_EFFECT_ENEMY_CRIT] = true,	
};

--======================================
-- Effect
--======================================
ENEMY_EFFECT_HEAL = 101;
ENEMY_EFFECT_CASK = 102;
ENEMY_EFFECT_EVILWHEEL = 103;

EFFECT_ANIM =
{
	[JADE_EFFECT_ENEMY_FREEZE] = "effect_freeze",
	[JADE_EFFECT_ENEMY_STUN] = "effect_stun",
	[ENEMY_EFFECT_HEAL] = "effect_heal",
	[ENEMY_EFFECT_CASK] = "effect_bombcask",
	[ENEMY_EFFECT_EVILWHEEL] = "effect_evilwheel",
};

EFFECT_OBJECTS =
{
	["enemy_bombcask"] = ENEMY_EFFECT_CASK,
	["enemy_evilwheel"] = ENEMY_EFFECT_EVILWHEEL,
};

EFFECT_STATE =
{
	[JADE_EFFECT_ENEMY_FREEZE] = "freeze",
	[JADE_EFFECT_ENEMY_STUN] = "stun",
};

EFFECT_OFFSET =
{
	[JADE_EFFECT_ENEMY_FREEZE] = 
	{
		["Default"] = { -19, -19 },
		[Enemy_FlyNinja] = { -19, -12 },
		[Enemy_HumanGunSoldier] = { -17, -19 },
		[Enemy_HumanKabuki] = { -22, -12 },
		[Enemy_HumanMonk] = { -4, -18 },
		[Enemy_UndeadSoldier] = { -8, -23 },
		[Enemy_UndeadShogunSummonee] = { -8, -23 },
		[Enemy_UndeadShogun] = { 8, 4 },
		[Enemy_UndeadRedOni] = { -4, 0 },
		[Enemy_BlueOni] = { -4, 0 },
		[Enemy_Daruma] = { 0, 5 },
		--[Enemy_UndeadYinYang] = { -8, -6 },	
	},

	[JADE_EFFECT_ENEMY_STUN] =
	{
		["Default"] = { 7, -5 },
		[Enemy_FlyNinja] = { 7, 2 },
		[Enemy_HumanGunSoldier] = { 12, -5 },
		[Enemy_HumanKabuki] = { 4, -4 },
		[Enemy_HumanMonk] = { 22, -4 },
		[Enemy_UndeadSoldier] = { 18, -9 },
		[Enemy_UndeadShogunSummonee] = { 18, -9 },
		[Enemy_UndeadShogun] = { 34, 9 },
		[Enemy_UndeadRedOni] = { 30, -7 },
		[Enemy_BlueOni] = { 30, -7 },
		[Enemy_Daruma] = { 34, -2 },
		--[Enemy_UndeadYinYang] = { 19, 1 },
	},
	
	[ENEMY_EFFECT_HEAL] =
	{
		["Default"] = { 0, -16 },
		[Enemy_FlyNinja] = { 0, -2 },
		[Enemy_HumanGunSoldier] = { 2, -14 },
		[Enemy_HumanKabuki] = { -4, -6 },
		[Enemy_HumanDigMan] = { 0, -13 },
		[Enemy_HumanMonk] = { 17, -10 },
		[Enemy_UndeadSoldier] = { 10, -16 },
		[Enemy_UndeadShogunSummonee] = { 10, -16 },
		[Enemy_UndeadShogun] = { 23, 10 },
		[Enemy_UndeadRedOni] = { 14, 2 },
		[Enemy_BlueOni] = { 14, 2 },
		[Enemy_Daruma] = { 18, 7 },
		--[Enemy_UndeadYinYang] = { 8, 2 },
		--[Boss_DevilSamurai] = { 40, 50 },
	},
	
	[ENEMY_EFFECT_CASK] =
	{
		["Default"] = { 0, 0 },	
	},

	[ENEMY_EFFECT_EVILWHEEL] =
	{
		["Default"] = { 0, 0 },	
	},
};



--==============================================================================
-- All Game Stuff
--==============================================================================
GAME_STUFF =
{
	--==========================================================================
	-- Final Guard
	--==========================================================================
	[9999] =
	{
		ST_MAX,
		nil,
		nil,
		nil,
		nil,
		0,
		nil,
	},

	--==========================================================================
	-- @Weapon
	--==========================================================================

	--============
	-- Katana
	--============
	[1101] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana01",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana01",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][1],
		{
			[ST_WEAPON_TYPE] = WEAPON_TYPE_KATANA,
			[ST_WEAPON_FX] = "we_katana_blue",
			[ST_WEAPON_POWER] = 3,
			[ST_WEAPON_ENERGY] = 2,
			[ST_WEAPON_CRITICAL] = 4,
			[ST_WEAPON_SKILL] = nil,
		},
	},
	
	[1102] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana02",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana02",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][2],
		{
			WEAPON_TYPE_KATANA,
			"we_katana_blue",
			4,
			2,
			5,
			nil,
		},
	},
	
	[1103] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana03",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana03",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][3],
		{
			WEAPON_TYPE_KATANA,
			"we_katana_blue",
			5,
			2,
			6,
			nil,
		},
	},
	
	[1104] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana04",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana04",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][4],
		{
			WEAPON_TYPE_KATANA,
			"we_katana_blue",
			7,
			2,
			7,
			nil,
		},
	},
	
	[1105] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana05",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana05",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][5],
		{
			WEAPON_TYPE_KATANA,
			"we_katana_blue",
			9,
			2,
			8,
			nil,
		},
	},
	
	[1106] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana06",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana06",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][6],
		{
			WEAPON_TYPE_KATANA,
			"we_katana_blue",
			12,
			3,
			9,
			nil,
		},
	},

	[1107] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana07",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana07",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][7],
		{
			WEAPON_TYPE_KATANA,
			"we_katana_blue",
			15,
			3,
			10,
			nil,
		},
	},

	[1108] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana08",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana08",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][8],
		{
			WEAPON_TYPE_KATANA,
			"we_katana_blue",
			19,
			3,
			11,
			nil,
		},
	},

	[1109] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana09",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana09",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][9],
		{
			WEAPON_TYPE_KATANA,
			"we_katana_blue",
			24,
			3,
			12,
			nil,
		},
	},

	[1110] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana10",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana10",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][10],
		{
			WEAPON_TYPE_KATANA,
			"we_katana_blue",
			30,
			3,
			13,
			nil,
		},
	},

	[1111] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana11",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana11",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][11],
		{
			WEAPON_TYPE_KATANA,
			"we_katana_blue",
			36,
			4,
			15,
			nil,
		},
	},

	[1112] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana12",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana12",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][12],
		{
			WEAPON_TYPE_KATANA,
			"we_katana_blue",
			42,
			4,
			17,
			nil,
		},
	},
---[[ @FinalWeapon
	[1113] =	-- Light Saber
	{
		ST_WEAPON,
		"ui_itemicon_weapon_katana101",
		"ui_iteminfo_katana",
		nil,
		"ui_shopicon_weapon_katana101",
		WEAPON_PRICE[WEAPON_TYPE_KATANA][13],
		{
			WEAPON_TYPE_KATANA,
			"we_katana_blue",
			50,
			4,
			20,
			nil,
		},
	},
--]]
	--============
	-- Blade
	--============
	[1201] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade01",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade01",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][1],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			6,
			5,
			10,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},

	[1202] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade02",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade02",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][2],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			8,
			5,
			12,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},

	[1203] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade03",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade03",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][3],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			10,
			5,
			14,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},

	[1204] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade04",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade04",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][4],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			14,
			5,
			16,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},

	[1205] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade05",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade05",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][5],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			18,
			5,
			18,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},

	[1206] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade06",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade06",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][6],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			24,
			6,
			20,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},

	[1207] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade07",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade07",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][7],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			30,
			6,
			22,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},

	[1208] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade08",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade08",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][8],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			39,
			6,
			24,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},

	[1209] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade09",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade09",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][9],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			48,
			6,
			27,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},

	[1210] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade10",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade10",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][10],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			59,
			8,
			30,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},

	[1211] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade11",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade11",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][11],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			73,
			8,
			33,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},

	[1212] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade12",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade12",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][12],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			89,
			8,
			35,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},
---[[ @FinalWeapon	
	[1213] =	-- Chainsaw
	{
		ST_WEAPON,
		"ui_itemicon_weapon_blade101",
		"ui_iteminfo_blade",
		"ui_iteminfo_redword_blade1",
		"ui_shopicon_weapon_blade101",
		WEAPON_PRICE[WEAPON_TYPE_BLADE][13],
		{
			WEAPON_TYPE_BLADE,
			"we_blade_red",
			108,
			8,
			40,
			{ WEAPON_SKILL_KNOCKBACK, 1 },
		},
	},
--]]
	--============
	-- Spear
	--============
	[1301] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari01",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear2",
		"ui_shopicon_weapon_yari01",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][1],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			2,
			3,
			9,
			{ WEAPON_SKILL_STAB, 3 },
		},
	},
	
	[1302] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari02",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear2",
		"ui_shopicon_weapon_yari02",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][2],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			3,
			3,
			10,
			{ WEAPON_SKILL_STAB, 3 },
		},
	},
	
	[1303] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari03",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear2",
		"ui_shopicon_weapon_yari03",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][3],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			4,
			3,
			11,
			{ WEAPON_SKILL_STAB, 3 },
		},
	},
	
	[1304] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari04",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear2",
		"ui_shopicon_weapon_yari04",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][4],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			5,
			3,
			12,
			{ WEAPON_SKILL_STAB, 3 },
		},
	},
	
	[1305] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari05",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear3",
		"ui_shopicon_weapon_yari05",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][5],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			7,
			4,
			13,
			{ WEAPON_SKILL_STAB, 4 },
		},
	},

	[1306] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari06",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear3",
		"ui_shopicon_weapon_yari06",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][6],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			9,
			4,
			14,
			{ WEAPON_SKILL_STAB, 4 },
		},
	},
	
	[1307] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari07",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear3",
		"ui_shopicon_weapon_yari07",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][7],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			11,
			4,
			15,
			{ WEAPON_SKILL_STAB, 4 },
		},
	},
	
	[1308] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari08",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear3",
		"ui_shopicon_weapon_yari08",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][8],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			14,
			4,
			16,
			{ WEAPON_SKILL_STAB, 4 },
		},
	},
	
	[1309] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari09",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear4",
		"ui_shopicon_weapon_yari09",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][9],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			17,
			5,
			17,
			{ WEAPON_SKILL_STAB, 5 },
		},
	},

	[1310] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari10",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear4",
		"ui_shopicon_weapon_yari10",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][10],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			21,
			5,
			18,
			{ WEAPON_SKILL_STAB, 5 },
		},
	},

	[1311] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari11",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear4",
		"ui_shopicon_weapon_yari11",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][11],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			25,
			5,
			20,
			{ WEAPON_SKILL_STAB, 5 },
		},
	},

	[1312] =
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari12",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear4",
		"ui_shopicon_weapon_yari12",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][12],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			29,
			5,
			22,
			{ WEAPON_SKILL_STAB, 5 },
		},
	},
---[[ @FinalWeapon	
	[1313] =  -- Lance
	{
		ST_WEAPON,
		"ui_itemicon_weapon_yari101",
		"ui_iteminfo_spear",
		"ui_iteminfo_redword_spear4",
		"ui_shopicon_weapon_yari101",
		WEAPON_PRICE[WEAPON_TYPE_SPEAR][13],
		{
			WEAPON_TYPE_SPEAR,
			"we_yari_green",
			34,
			5,
			25,
			{ WEAPON_SKILL_STAB, 5 },
		},
	},
--]]
	--==========================================================================
	-- @Jade
	--==========================================================================

	------------------------------------
	-- Innocent Protect (IAP Jade)
	------------------------------------	
	[4001] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade06",
		"ui_iteminfo_redword_jade6",
		"ui_shopicon_upgrade_jade6",
		0,
		"ui_shop_iap4",	--"ui_shop_iap5",
	},

	------------------------------------
	-- Enemy Freeze
	------------------------------------	
	[4101] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][1],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][1],
	},

	[4102] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][2],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][2],
	},

	[4103] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][3],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][3],
	},

	[4104] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][4],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][4],
	},

	[4105] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][5],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][5],
	},

	[4106] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][6],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][6],
	},

	[4107] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][7],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][7],
	},

	[4108] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][8],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][8],
	},

	[4109] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][9],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][9],
	},

	[4110] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][10],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][10],
	},

	[4111] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][11],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][11],
	},

	[4112] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][12],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][12],
	},

	[4113] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade01",
		"ui_iteminfo_redword_jade1",
		"ui_shopicon_upgrade_jade1",
		JADE_PRICE[JADE_EFFECT_ENEMY_FREEZE][13],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_FREEZE][13],
	},

	------------------------------------
	-- Coin Drop
	------------------------------------	
	[4201] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][1],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][1],
	},

	[4202] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][2],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][2],
	},

	[4203] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][3],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][3],
	},

	[4204] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][4],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][4],
	},

	[4205] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][5],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][5],
	},

	[4206] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][6],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][6],
	},

	[4207] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][7],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][7],
	},

	[4208] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][8],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][8],
	},

	[4209] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][9],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][9],
	},

	[4210] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][10],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][10],
	},

	[4211] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][11],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][11],
	},

	[4212] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][12],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][12],
	},

	[4213] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade02",
		"ui_iteminfo_redword_jade2",
		"ui_shopicon_upgrade_jade2",
		JADE_PRICE[JADE_EFFECT_COIN_DROP][13],
		JADE_EFFECT_DATA[JADE_EFFECT_COIN_DROP][13],
	},

	------------------------------------
	-- Exp Gain
	------------------------------------	
	[4301] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][1],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][1],
	},

	[4302] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][2],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][2],
	},

	[4303] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][3],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][3],
	},

	[4304] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][4],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][4],
	},

	[4305] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][5],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][5],
	},

	[4306] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][6],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][6],
	},

	[4307] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][7],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][7],
	},

	[4308] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][8],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][8],
	},

	[4309] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][9],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][9],
	},

	[4310] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][10],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][10],
	},

	[4311] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][11],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][11],
	},

	[4312] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][12],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][12],
	},

	[4313] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade03",
		"ui_iteminfo_redword_jade3",
		"ui_shopicon_upgrade_jade3",
		JADE_PRICE[JADE_EFFECT_EXP_GAIN][13],
		JADE_EFFECT_DATA[JADE_EFFECT_EXP_GAIN][13],
	},

	------------------------------------
	-- Enemy Stun
	------------------------------------	
	[4401] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][1],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][1],
	},

	[4402] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][2],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][2],
	},

	[4403] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][3],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][3],
	},

	[4404] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][4],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][4],
	},

	[4405] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][5],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][5],
	},

	[4406] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][6],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][6],
	},

	[4407] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][7],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][7],
	},

	[4408] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][8],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][8],
	},

	[4409] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][9],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][9],
	},

	[4410] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][10],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][10],
	},

	[4411] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][11],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][11],
	},

	[4412] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][12],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][12],
	},

	[4413] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade04",
		"ui_iteminfo_redword_jade4",
		"ui_shopicon_upgrade_jade4",
		JADE_PRICE[JADE_EFFECT_ENEMY_STUN][13],
		JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_STUN][13],
	},

	------------------------------------
	-- Critical Hit
	------------------------------------	
	[4501] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][1],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][1] - 1) * 100,
	},

	[4502] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][2],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][2] - 1) * 100,
	},

	[4503] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][3],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][3] - 1) * 100,
	},

	[4504] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][4],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][4] - 1) * 100,
	},

	[4505] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][5],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][5] - 1) * 100,
	},

	[4506] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][6],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][6] - 1) * 100,
	},

	[4507] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][7],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][7] - 1) * 100,
	},

	[4508] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][8],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][8] - 1) * 100,
	},

	[4509] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][9],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][9] - 1) * 100,
	},

	[4510] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][10],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][10] - 1) * 100,
	},

	[4511] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][11],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][11] - 1) * 100,
	},

	[4512] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][12],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][12] - 1) * 100,
	},

	[4513] =
	{
		ST_JADE,
		nil,
		"ui_iteminfo_jade05",
		"ui_iteminfo_redword_jade5",
		"ui_shopicon_upgrade_jade5",
		JADE_PRICE[JADE_EFFECT_ENEMY_CRIT][13],
		(JADE_EFFECT_DATA[JADE_EFFECT_ENEMY_CRIT][13] - 1) * 100,
	},

	--==========================================================================
	-- Avatar
	--==========================================================================
--[[
	ui_shop_iap1 $1.99
	ui_shop_iap2 $2.99
	ui_shop_iap3 $4.99
	ui_shop_iap4 $6.99
	ui_shop_iap5 $9.99
	ui_shop_iap6 $29.99
--]]
	[3101] =
	{
		ST_AVATAR,
		nil,
		"ui_iteminfo_ninja",
		nil,
		"ui_shopicon_avatar_charater01",
		AVATAR_PRICE[1],
	},

	[3102] =
	{
		ST_AVATAR,
		nil,
		"ui_iteminfo_samurai",
		nil,
		"ui_shopicon_avatar_charater02",
		AVATAR_PRICE[2],
	},

	[3103] =
	{
		ST_AVATAR,
		nil,
		"ui_iteminfo_witch",
		nil,
		"ui_shopicon_avatar_charater03",
		AVATAR_PRICE[3],
	},

	[3104] =
	{
		ST_AVATAR,
		nil,
		"ui_iteminfo_assassin",
		nil,
		"ui_shopicon_avatar_charater04",
		AVATAR_PRICE[4],
	},

	[3105] =
	{
		ST_AVATAR,
		nil,
		"ui_iteminfo_thief",
		nil,
		"ui_shopicon_avatar_charater05",
		AVATAR_PRICE[5],
		"ui_shop_iap2",
	},
	
	[3106] =
	{
		ST_AVATAR,
		nil,
		"ui_iteminfo_warlord",
		nil,
		"ui_shopicon_avatar_charater06",
		AVATAR_PRICE[6],
		"ui_shop_iap3", --"ui_shop_iap4",
	},

	--==========================================================================
	-- Coin
	--==========================================================================
	
	[8101] =
	{
		ST_COIN,
		nil,
		"ui_iteminfo_coin1",
		nil,
		"ui_shopicon_coinbag_coin1",
		COINBAG_PRICE[1],
		{
			ITEM_EFFECT_COIN_GAIN,
			COINBAG_COUNT[1],
		},
	},
	
	[8102] =
	{
		ST_COIN,
		nil,
		"ui_iteminfo_coin2",
		nil,
		"ui_shopicon_coinbag_coin2",
		COINBAG_PRICE[2],
		{
			ITEM_EFFECT_COIN_GAIN,
			COINBAG_COUNT[2],
		},
	},
	
	[8103] =
	{
		ST_COIN,
		nil,
		"ui_iteminfo_coin3",
		nil,
		"ui_shopicon_coinbag_coin3",
		COINBAG_PRICE[3],
		{
			ITEM_EFFECT_COIN_GAIN,
			COINBAG_COUNT[3],
		},
	},
	
	[8104] =
	{
		ST_COIN,
		nil,
		"ui_iteminfo_coin4",
		nil,
		"ui_shopicon_coinbag_coin4",
		COINBAG_PRICE[4],
		{
			ITEM_EFFECT_COIN_GAIN,
			COINBAG_COUNT[4],
		},
	},

	--==========================================================================
	-- Treasure
	--==========================================================================
	
	[9101] =
	{
		ST_TREASURE,
		nil,
		"ui_iteminfo_gold1",
		nil,
		"ui_shopicon_treasure_koban1",
		0,
		"ui_shop_iap1",
	},
	
	[9102] =
	{
		ST_TREASURE,
		"ui_shopicon_treasure_up1",  -- +N% tag
		"ui_iteminfo_gold2",
		nil,
		"ui_shopicon_treasure_koban2",
		0,
		"ui_shop_iap3",
	},
	
	[9103] =
	{
		ST_TREASURE,
		"ui_shopicon_treasure_up2",
		"ui_iteminfo_gold3",
		nil,
		"ui_shopicon_treasure_koban3",
		0,
		"ui_shop_iap5",
	},
	
	[9104] =
	{
		ST_TREASURE,
		"ui_shopicon_treasure_up3",
		"ui_iteminfo_gold4",
		nil,
		"ui_shopicon_treasure_koban4",
		0,
		"ui_shop_iap6",
	},

	-- Starter Kit
	[9201] =
	{
		ST_TREASURE,
		nil,
		"ui_iteminfo_starterkit",
		nil,
		"ui_shopicon_treasure_starterkit",
		0,
		"ui_shop_iap2", --"ui_shop_iap3",
	},
};
