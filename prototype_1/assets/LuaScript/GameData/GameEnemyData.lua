--***********************************************************************
-- @file GameEnemyData.lua
--***********************************************************************

--==================================
-- Template Fields
--==================================
ENEMY_TEMPLATE_TYPE = 1;
ENEMY_TEMPLATE_LOOK = 2;
ENEMY_TEMPLATE_LIFE = 3;
ENEMY_TEMPLATE_SPEED = 4;
ENEMY_TEMPLATE_RANGE = 5;
ENEMY_TEMPLATE_ATTACK = 6;
ENEMY_TEMPLATE_SPRATE = 7;
ENEMY_TEMPLATE_ABILITY = 8;
ENEMY_TEMPLATE_ATACKTYPE = 9;
ENEMY_TEMPLATE_SCOPE = 10;
ENEMY_TEMPLATE_SKILL = 11;
ENEMY_TEMPLATE_SFX = 12;
ENEMY_TEMPLATE_LAYER = 13;
ENEMY_TEMPLATE_SCALE = 14;

--==================================
-- TEMPLATE_TYPE
--==================================
ET_NONE = 0;
ET_OBJECT = 1;
ET_INNOCENT = 2;
ET_MONKEY = 3;
ET_NINJA = 4;
ET_HUMAN = 5;
ET_GHOST = 6;
ET_MONSTER = 7;
ET_BOSSMINION = 8;
ET_BOSS = 9;

--==================================
-- TEMPLATE_ABILITY
--==================================
EA_NONE = 1;
EA_DEFEND = 2;
EA_NONSTOP = 3;
EA_STATIC = 4;
EA_INVINCIBLE = 5;
EA_MONKEY = 6;
EA_INNOCENT = 7;
EA_INNOCENT_SP = 8;

--==================================
-- TEMPLATE_SCOPE
--==================================
ER_MELEE = 1;
ER_BULLET = 2;

--==================================
-- TEMPLATE_SKILL
--==================================
ES_BIRTH = 1;
ES_MOVE = 2;
ES_PREATTACK = 3;
ES_ATTACK = 4;
ES_WOUNDED = 5;
ES_REVENGE = 6;
ES_DEAD = 7;
ES_INVINCIBLE = 8;

--==================================
-- TEMPLATE_ATTACK
--==================================
EK_NORMAL = 1;
EK_BOMB = 2;
EK_RANGED = 3;
EK_GHOST = 4;

--==================================
-- TEMPLATE_LAYER
--==================================
--EL_DEFAULT = 0;
EL_POSTRENDER = 1;
EL_PRERENDER = 2;

--==================================
-- Animations
--==================================
ENEMY_ANIM_MOVE = "_move";
ENEMY_ANIM_ATTACK = "_attack";
ENEMY_ANIM_RANGEATTACK = "_rangeattack";
ENEMY_ANIM_WOUNDED = "_wounded";
ENEMY_ANIM_HIT = "_hit";
ENEMY_ANIM_STUN = "_stun";
ENEMY_ANIM_DEAD = "_dead";
ENEMY_ANIM_IDLE = "_idle";

ENEMY_ANIM_SKILL_ENTER = "_skill_enter";
ENEMY_ANIM_SKILL_EXIT = "_skill_exit";
--ENEMY_ANIM_PARRY = "_parry";
ENEMY_ANIM_SKILL_ASSAULT = "_assault";
ENEMY_ANIM_SKILL_HEAL = "_heal";
ENEMY_ANIM_SKILL_RUN = "_run";

ENEMY_ANIM_SKILL_SUMMON_ENTER = "_summon_enter";
ENEMY_ANIM_SKILL_SUMMON_ON = "_summon_on";
ENEMY_ANIM_SKILL_SUMMON_EXIT = "_summon_exit";

ENEMY_ANIM_WOUNDED_SINGLE = "_wounded_front_01";

--==================================
-- Globals
--==================================
ENEMY_DURATION_WOUNDED = 300;
ENEMY_DURATION_ATTACK = 1000; --750;
ENEMY_DURATION_ATTACK_SP = 500;
ENEMY_DURATION_SKILL_SUBSTITUTE_MIN = 1500;
ENEMY_DURATION_SKILL_SUBSTITUTE_MAX = 3500;
ENEMY_DURATION_SKILL_EXPLODE = 400;
ENEMY_SCALE_EXPLODE = 1.4;

ENEMY_SKILL_SUBSTITUTE_RANGE = 100;
ENEMY_SKILL_SUMMON_DURATION = 1500;

ENEMY_PUSHBACK_VELOCITY = 500;
ENEMY_STUNBACK_VELOCITY = 150;

ENEMY_SHADOW_OFFSET = 130;

ENERGY_BALL_VALUE_MIN = 3;
ENERGY_BALL_VALUE_MAX = 12;

--==============================================================================
-- Effect
--==============================================================================
EFFECT_BOMB = 1;
EFFECT_WATER = 2;

ENEMY_EFFECT =
{
	-- animation, offsetX, offsetY, block, state
	[EFFECT_BOMB] = { "effect_explosion01", -42, -15 },
	[EFFECT_WATER] = { "effect_water", -42, -15 },
};

--==============================================================================
-- Bullet
--==============================================================================

ENEMY_BULLET =
{
	["enemy_flyninja"] = { "bullet_shuriken", 300 },
	["enemy_purpleninja"] = { "bullet_kunai", 400 },
	["enemy_redninja"] = { "bullet_shuriken", 300 },
	["enemy_gunsoldier"] = { "bullet_gun", 450 },
	["enemy_digman"] = { "bullet_knife", 300 },
	["enemy_crowtengu"] = { "bullet_tengufan", 400 },
	["enemy_raccoon"] = { "bullet_chestnut", 450 },
	["enemy_umbrella"] = { "bullet_fireball", 520 },
	["enemy_kamaitachi"] = { "bullet_sickle", 350 },
	["bossminion_shadowninja_ranged"] = { "boss_bullet_shuriken", 500 },
	["boss_akudaikan"] = { "bullet_gun", 600 },
	["boss_ghostking"] = { "bullet_bladewave", 500 },
	["boss_giantspider"] = { "bullet_venom", 550 },
};

--==============================================================================
-- 
--==============================================================================

ENEMY_CAN_SWIPED =
{
	[ET_MONKEY] = true,
	[ET_INNOCENT] = true,
	[ET_OBJECT] = true,
};

--==============================================================================
-- Attribute Value
--==============================================================================

ENEMY_SPEED =
{
	30,
	50,
	80,
	110,
	140,
	170,
	200,
	300,
};

ENEMY_RANGE =
{
	20,
	30,
	50,
	75,
	150,
	200,
	250,
	300,
};

ENEMY_ATTACK =
{
	10,
	15,
	20,
	30,
	40,
};

ENEMY_SCORE =
{
	100,
	150,
	200,
	250,
	300,
	400,
	500,
};

INNOCENT_SPEED =
{
	250,
	190,
	140,
};

-------------------------------------------------------------------------
ACH_ENEMY_TYPE_FUNC =
{
    [ET_NINJA] = function()
        BatchUpdateAchievement(ACH_ENEMY_NINJA_LV1);
        BatchUpdateAchievement(ACH_ENEMY_NINJA_LV2);
        BatchUpdateAchievement(ACH_ENEMY_NINJA_LV3);
    end,

    [ET_HUMAN] = function()
        BatchUpdateAchievement(ACH_ENEMY_HUMAN_LV1);
        BatchUpdateAchievement(ACH_ENEMY_HUMAN_LV2);
        BatchUpdateAchievement(ACH_ENEMY_HUMAN_LV3);
    end,

    [ET_GHOST] = function()
        BatchUpdateAchievement(ACH_ENEMY_GHOST_LV1);
        BatchUpdateAchievement(ACH_ENEMY_GHOST_LV2);
        BatchUpdateAchievement(ACH_ENEMY_GHOST_LV3);
    end,
};



--==============================================================================
-- Innocent
--==============================================================================

Monkey_Ninja =
{
	ET_MONKEY,
	"monkey_ninja",
	1,
	300,
	0,
	0,
	0,
	EA_MONKEY,
	EK_NORMAL,
	{},
	{
		[ES_BIRTH] = "innocent_warning",
		[ES_DEAD] = "monkey_die",
	},
	{
		[ES_MOVE] = SFX_CHAR_ANIMAL_WOUNDED_2,
	},
};

--==============================================================================
-- Innocent
--==============================================================================

Innocent_None =
{
	ET_NONE,
	"innocent_*",
};

Innocent_Man =
{
	ET_INNOCENT,
	"innocent_male",
	1,
	INNOCENT_SPEED[1],
	0,
	9999,
	0,
	EA_INNOCENT,
	EK_NORMAL,
	{},
	{
		[ES_BIRTH] = "innocent_warning",
		[ES_DEAD] = "innocent_die",
	},
	{
		[ES_MOVE] = SFX_CHAR_INNOCENT_MAN,
	},
};

Innocent_Woman =
{
	ET_INNOCENT,
	"innocent_female",
	1,
	INNOCENT_SPEED[2],
	0,
	9999,
	0,
	EA_INNOCENT,
	EK_NORMAL,
	{},
	{
		[ES_BIRTH] = "innocent_warning",
		[ES_DEAD] = "innocent_die",
	},
	{
		[ES_MOVE] = SFX_CHAR_INNOCENT_WOMAN,
	},
};

Innocent_Elder =
{
	ET_INNOCENT,
	"innocent_oldfemale",
	1,
	INNOCENT_SPEED[3],
	0,
	9999,
	0,
	EA_INNOCENT,
	EK_NORMAL,
	{},
	{
		[ES_BIRTH] = "innocent_warning",
		[ES_DEAD] = "innocent_die",
	},
	{
		[ES_MOVE] = SFX_CHAR_INNOCENT_ELDER,
	},
};

Innocent_ElderSP =
{
	ET_INNOCENT,
	"innocent_oldfemale",
	1,
	INNOCENT_SPEED[3],
	0,
	9999,
	0,
	EA_INNOCENT_SP,
	EK_NORMAL,
	{},
	{
		[ES_BIRTH] = "innocent_warning",
		[ES_DEAD] = "innocent_die",
	},
	{
		[ES_MOVE] = SFX_CHAR_INNOCENT_ELDER,
	},
};

Tutorial_InnocentWoman =
{
	ET_INNOCENT,
	"innocent_female",
	1,
	INNOCENT_SPEED[1],
	0,
	9999,
	0,
	EA_INNOCENT,
	EK_NORMAL,
	{},
	{
		[ES_BIRTH] = "innocent_warning",
		[ES_DEAD] = "innocent_die",
	},
	{
		[ES_MOVE] = SFX_CHAR_INNOCENT_WOMAN,
	},
};

INNOCENT_POOL =
{
	Monkey_Ninja,
	Innocent_Woman, Innocent_Woman,
	Innocent_Man, Innocent_Man, Innocent_Man,
	Innocent_Elder, Innocent_Elder, Innocent_Elder,
	Innocent_ElderSP,
};
--[[ @DEBUG
INNOCENT_POOL = { Monkey_Ninja, Monkey_Ninja, Monkey_Ninja, Innocent_Man };
--]]
BOSS_INNOCENT_POOL = { Innocent_Man, Innocent_Man, Innocent_Woman, Innocent_Woman, Innocent_Elder };



--==============================================================================
-- Enemy @ Tutorial
--==============================================================================

Tutorial_Enemy1 =
{
	ET_NINJA,				-- type
	"enemy_blackninja",		-- look
	1,						-- life
	ENEMY_SPEED[8],			-- speed
	ENEMY_RANGE[5],			-- range
	4,						-- attack
	ENEMY_SCORE[1],			-- score
	EA_NONE,				-- ability
	EK_NORMAL,				-- attack type
	{ ER_MELEE, 1 },			-- scope
	{						-- skill set
		[ES_BIRTH] = "tutorial_birth",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Tutorial_Enemy2 =
{
	ET_NINJA,				-- type
	"enemy_swordman",		-- look
	1,						-- life
	ENEMY_SPEED[8],			-- speed
	ENEMY_RANGE[5],			-- range
	4,						-- attack
	ENEMY_SCORE[1],			-- score
	EA_DEFEND,
	EK_NORMAL,
	{ ER_MELEE, 1 },			-- scope
	{						-- skill set
		[ES_BIRTH] = "tutorial_birth",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Tutorial_Enemy3 =
{
	ET_NINJA,				-- type
	"enemy_blackninja",		-- look
	1,						-- life
	ENEMY_SPEED[8],			-- speed
	ENEMY_RANGE[5],			-- range
	4,						-- attack
	ENEMY_SCORE[1],			-- score
	EA_NONE,				-- ability
	EK_NORMAL,
	{ ER_MELEE, 1 },			-- scope
	{						-- skill set
		[ES_BIRTH] = "tutorial_idle",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Tutorial_Enemy4 =
{
	ET_NINJA,
	"enemy_greenninja",
	4,
	ENEMY_SPEED[8],
	ENEMY_RANGE[1],
	18,
	ENEMY_SCORE[4],
	EA_NONE,
	EK_NORMAL,
	{ ER_MELEE, 1 },	
	{
		[ES_BIRTH] = "tutorial_idle",
		[ES_PREATTACK] = "skill_explode",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
	},
};

Tutorial_Enemy5 =
{
	ET_NINJA,
	"enemy_blueninja",
	4,
	ENEMY_SPEED[8],
	ENEMY_RANGE[1],
	18,
	ENEMY_SCORE[4],
	EA_NONE,
	EK_NORMAL,
	{ ER_MELEE, 1 },	
	{
		[ES_BIRTH] = "tutorial_assault",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
	},
};

--==============================================================================
-- ET_NINJA
--==============================================================================

Enemy_BasicNinja =
{
	ET_NINJA,				-- type
	"enemy_blackninja",		-- look
	3,						-- life
	ENEMY_SPEED[3],			-- speed
	ENEMY_RANGE[3],			-- range
	4,						-- attack
	ENEMY_SCORE[1],			-- score
	EA_NONE,				-- ability
	EK_NORMAL,				-- attack type
	{ ER_MELEE, 1 },			-- scope
	{						-- skill set
		[ES_BIRTH] = nil,
		[ES_MOVE] = nil,
		[ES_PREATTACK] = nil,
		[ES_ATTACK] = nil,
		[ES_WOUNDED] = nil,
		[ES_REVENGE] = nil,
		[ES_DEAD] = nil,
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_WallNinja =
{
	ET_NINJA,
	"enemy_blueninja",
	5,
	ENEMY_SPEED[4],
	ENEMY_RANGE[3],
	6,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_NORMAL,
	{ ER_MELEE, 1 },	
	{
		[ES_BIRTH] = "skill_wall",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_MOVE] = SFX_CHAR_NINJA_SKILL,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_AssaultNinja =
{
	ET_NINJA,
	"enemy_blueninja",
	5,
	ENEMY_SPEED[4],
	ENEMY_RANGE[3],
	6,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_NORMAL,
	{ ER_MELEE, 1 },	
	{
		[ES_BIRTH] = "skill_assault",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_MOVE] = SFX_CHAR_NINJA_SKILL,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_ExplodeNinja =
{
	ET_NINJA,
	"enemy_greenninja",
	4,
	ENEMY_SPEED[5],
	ENEMY_RANGE[1],
	18,
	ENEMY_SCORE[4],
	EA_NONE,
	EK_BOMB,
	{ ER_MELEE, 1 },	
	{
		[ES_BIRTH] = "skill_explode_enter",
		[ES_PREATTACK] = "skill_explode",
	},
	{
		[ES_BIRTH] = SFX_OBJECT_BOMB_LOOP,
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_FlyNinja =
{
	ET_NINJA,
	"enemy_flyninja",
	8,
	ENEMY_SPEED[2],
	ENEMY_RANGE[5],
	ENEMY_ATTACK[2],
	9,
	EA_NONE,
	EK_RANGED,
	{ ER_BULLET, 2 },
	{
		[ES_BIRTH] = "skill_fly",
		[ES_MOVE] = "skill_fly",
		[ES_ATTACK] = "skill_bullet",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_MOVE] = SFX_CHAR_NINJA_SKILL,
		[ES_PREATTACK] = SFX_ENEMY_ATTACK_BULLET_LIGHT,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
	EL_POSTRENDER,
};

Enemy_BulletNinja =
{
	ET_NINJA,
	"enemy_purpleninja",
	7,
	ENEMY_SPEED[3],
	ENEMY_RANGE[6],
	10,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_RANGED,
	{ ER_BULLET, 1 },
	{
		[ES_ATTACK] = "skill_bullet",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_MOVE] = SFX_CHAR_NINJA_SKILL,
		[ES_PREATTACK] = SFX_ENEMY_ATTACK_BULLET_LIGHT,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_GhostNinja =
{
	ET_NINJA,
	"enemy_redninja",
	15,
	ENEMY_SPEED[3],
	ENEMY_RANGE[5],
	10,
	ENEMY_SCORE[5],
	EA_NONE,
	EK_NORMAL,
	{ ER_BULLET, 1 },
	{
		[ES_ATTACK] = "skill_bullet",
		[ES_WOUNDED] = "skill_substitute",
		[ES_REVENGE] = "skill_bullet_revenge",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_MOVE] = SFX_CHAR_NINJA_SKILL,
		[ES_PREATTACK] = SFX_ENEMY_ATTACK_BULLET_HEAVY,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_HEAVY,
	},
	false,
	1.3,
};

--==============================================================================
-- ET_HUMAN
--==============================================================================

Enemy_HumanSwordMan =
{
	ET_HUMAN,
	"enemy_swordman",
	18,
	ENEMY_SPEED[2],
	ENEMY_RANGE[3],
	12,
	75, --ENEMY_SCORE[5],
	EA_DEFEND,
	EK_NORMAL,
	{ ER_MELEE, 1 },	
	{},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_HumanRobber =
{
	ET_HUMAN,
	"enemy_robber",
	5,
	ENEMY_SPEED[3],
	ENEMY_RANGE[3],
	3,
	ENEMY_SCORE[2],
	EA_NONE,
	EK_NORMAL,
	{ ER_MELEE, 1 },	
	{},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_HumanGunSoldier =
{
	ET_HUMAN,
	"enemy_gunsoldier",
	7,
	ENEMY_SPEED[3],
	ENEMY_RANGE[7],
	8,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_RANGED,
	{ ER_BULLET, 1 },
	{
		[ES_ATTACK] = "skill_bullet",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_MOVE] = SFX_CHAR_NINJA_SKILL,
		[ES_PREATTACK] = SFX_ENEMY_ATTACK_BULLET_GUN,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_BULLET_HEAVY,
	},
};

Enemy_HumanDigMan =
{
	ET_HUMAN,
	"enemy_digman",
	9,
	ENEMY_SPEED[2],
	ENEMY_RANGE[3],--ENEMY_RANGE[5],
	8,
	80, --ENEMY_SCORE[4],
	EA_DEFEND,
	EK_NORMAL,
	{ ER_MELEE, 1 },	--{ ER_BULLET, 2 },
	{
		[ES_BIRTH] = "skill_digout",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_MOVE] = SFX_CHAR_NINJA_SKILL,
		[ES_PREATTACK] = SFX_ENEMY_ATTACK_BULLET_LIGHT,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_HumanKabuki =
{
	ET_HUMAN,
	"enemy_kabuki",
	14,
	ENEMY_SPEED[2],
	ENEMY_RANGE[3],
	12,
	ENEMY_SCORE[4],
	EA_NONE,
	EK_NORMAL,
	{ ER_MELEE, 1 },	
	{
		[ES_WOUNDED] = "skill_trap",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_HumanMonk =
{
	ET_HUMAN,
	"enemy_monk",
	17,
	ENEMY_SPEED[2],
	ENEMY_RANGE[6],
	1,
	ENEMY_SCORE[5],
	EA_NONE,
	EK_NORMAL,
	{ ER_BULLET, 2 },
	{
		[ES_ATTACK] = "skill_heal",
		[ES_WOUNDED] = "skill_substitute",
		[ES_REVENGE] = "skill_heal",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_NINJA_WOUNDED,
	},
};

--==============================================================================
-- ET_GHOST
--==============================================================================

Enemy_UndeadSoldier =
{
	ET_GHOST,
	"enemy_deadsoldier",
	8,
	ENEMY_SPEED[2],
	ENEMY_RANGE[3],
	8,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_GHOST,
	{ ER_MELEE, 3 },	
	{
		[ES_BIRTH] = "skill_assault",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_UNDEAD_WOUNDED,
		[ES_MOVE] = SFX_CHAR_UNDEAD_SKILL,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_UndeadGhost =
{
	ET_GHOST,
	"enemy_ghost",
	10,
	ENEMY_SPEED[2],
	ENEMY_RANGE[3],
	8,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_GHOST,
	{ ER_MELEE, 2 },	
	{
		[ES_WOUNDED] = "skill_spawn_lv1",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_UNDEAD_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
	false,
	1.3,
};

Enemy_UndeadGhostSummoneeLv1 =
{
	ET_GHOST,
	"enemy_ghost",
	8,
	ENEMY_SPEED[2],
	ENEMY_RANGE[3],
	4,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_GHOST,
	{ ER_MELEE, 2 },	
	{
		[ES_BIRTH] = "move",
		[ES_WOUNDED] = "skill_spawn_lv2",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_UNDEAD_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
	false,
	1.0,
};

Enemy_UndeadGhostSummoneeLv2 =
{
	ET_GHOST,
	"enemy_ghost",
	4,
	ENEMY_SPEED[2],
	ENEMY_RANGE[2],
	2,
	ENEMY_SCORE[2],
	EA_NONE,
	EK_GHOST,
	{ ER_MELEE, 2 },	
	{
		[ES_BIRTH] = "move",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_UNDEAD_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
	false,
	0.7,
};

Enemy_UndeadShogun =
{
	ET_GHOST,
	"enemy_deadshogun",
	22,
	ENEMY_SPEED[2],
	ENEMY_RANGE[4],
	20,
	ENEMY_SCORE[5],
	EA_NONE,
	EK_GHOST,
	{ ER_MELEE, 3 },	
	{
		[ES_BIRTH] = "skill_summon_move",
		[ES_WOUNDED] = "skill_summon_wounded",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_UNDEAD_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_HEAVY,
	},
	false,
	1.3,
};

Enemy_UndeadShogunSummonee =
{
	ET_GHOST,
	"enemy_deadsoldier",
	8,
	ENEMY_SPEED[2],
	ENEMY_RANGE[3],
	8,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_GHOST,
	{ ER_MELEE, 3 },	
	{
		[ES_BIRTH] = "skill_summonee",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_UNDEAD_WOUNDED,
		[ES_MOVE] = SFX_CHAR_UNDEAD_SKILL,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_UndeadRedOni =
{
	ET_GHOST,
	"enemy_redoni",
	28,
	ENEMY_SPEED[1],
	ENEMY_RANGE[4],
	18,
	95, --ENEMY_SCORE[5],
	EA_DEFEND,
	EK_GHOST,
	{ ER_MELEE, 4 },	
	{},
	{
		[ES_WOUNDED] = SFX_CHAR_GIANT_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_HEAVY,
	},
	false,
	1.4,
};

Enemy_BlueOni =
{
	ET_GHOST,
	"enemy_blueoni",
	39,
	ENEMY_SPEED[2],
	ENEMY_RANGE[4],
	24,
	95, --ENEMY_SCORE[5],
	EA_DEFEND,
	EK_GHOST,
	{ ER_MELEE, 4 },	
	{},
	{
		[ES_WOUNDED] = SFX_CHAR_GIANT_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_HEAVY,
	},
	false,
	1.5,
};

Enemy_SmallOni =
{
	ET_GHOST,
	"enemy_smalloni",
	19,
	ENEMY_SPEED[3],
	ENEMY_RANGE[3],
	18,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_NORMAL,
	{ ER_MELEE, 3 },	
	{
		[ES_BIRTH] = "skill_wall",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_GIANT_WOUNDED,
		[ES_MOVE] = SFX_CHAR_NINJA_SKILL,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_FireSkull =
{
	ET_GHOST,
	"enemy_fireskull",
	20,
	ENEMY_SPEED[3],
	ENEMY_RANGE[1],
	24,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_BOMB,
	{ ER_MELEE, 1 },	
	{
		[ES_WOUNDED] = "skill_firespawn_lv1",
		[ES_PREATTACK] = "object_explode",
	},
	{
	},
	false,
	1.1,
};

Enemy_FireSkullSummoneeLv1 =
{
	ET_GHOST,
	"enemy_fireskull",
	10,
	ENEMY_SPEED[3],
	ENEMY_RANGE[1],
	12,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_BOMB,
	{ ER_MELEE, 1 },	
	{
		[ES_BIRTH] = "move",
		[ES_WOUNDED] = "skill_firespawn_lv2",
		[ES_PREATTACK] = "object_explode",
	},
	{
	},
	false,
	0.9,
};

Enemy_FireSkullSummoneeLv2 =
{
	ET_GHOST,
	"enemy_fireskull",
	5,
	ENEMY_SPEED[3],
	ENEMY_RANGE[1],
	6,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_BOMB,
	{ ER_MELEE, 1 },	
	{
		[ES_BIRTH] = "move",
		[ES_PREATTACK] = "object_explode",
	},
	{
	},
	false,
	0.7,
};

Enemy_SpeedFireSkull =
{
	ET_GHOST,
	"enemy_fireskull",
	10,
	ENEMY_SPEED[5],
	ENEMY_RANGE[1],
	12,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_BOMB,
	{ ER_MELEE, 1 },	
	{
		[ES_BIRTH] = "move",
		[ES_PREATTACK] = "object_explode",
	},
	{
	},
	false,
	0.7,
};

--==============================================================================
-- ET_MONSTER
--==============================================================================

Enemy_UndeadCrowTengu =
{
	ET_MONSTER,
	"enemy_crowtengu",
	7,
	ENEMY_SPEED[4],
	ENEMY_RANGE[6],
	12,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_RANGED,
	{ ER_BULLET, 2 },
	{
		[ES_BIRTH] = "skill_fly",
		[ES_MOVE] = "skill_fly",
		[ES_ATTACK] = "skill_bullet",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_ANIMAL_WOUNDED,
		[ES_PREATTACK] = SFX_ENEMY_ATTACK_BULLET_HEAVY,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_HEAVY,
	},
	EL_POSTRENDER,
};

Enemy_Kappa =
{
	ET_MONSTER,
	"enemy_kappa",
	15,
	ENEMY_SPEED[3],
	ENEMY_RANGE[3],
	10,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_NORMAL,
	{ ER_MELEE, 3 },	
	{
		[ES_BIRTH] = "skill_wall",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_ANIMAL_WOUNDED,
		[ES_MOVE] = SFX_CHAR_NINJA_SKILL,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_Racoon =
{
	ET_MONSTER,
	"enemy_raccoon",
	13,
	ENEMY_SPEED[4],
	ENEMY_RANGE[7],
	10,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_RANGED,
	{ ER_BULLET, 4 },
	{
		[ES_ATTACK] = "skill_bullet",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_ANIMAL_WOUNDED,
		[ES_PREATTACK] = SFX_ENEMY_ATTACK_BULLET_LIGHT,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_Umbrella =
{
	ET_MONSTER,
	"enemy_umbrella",
	14,
	ENEMY_SPEED[3],
	ENEMY_RANGE[7],
	12,
	ENEMY_SCORE[3],
	EA_NONE,
	EK_RANGED,
	{ ER_BULLET, 3 },
	{
		[ES_ATTACK] = "skill_bullet",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_UNDEAD_WOUNDED,
		[ES_PREATTACK] = SFX_ENEMY_ATTACK_BULLET_LIGHT,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Enemy_Kamaitachi =
{
	ET_MONSTER,
	"enemy_kamaitachi",
	17,
	ENEMY_SPEED[3],
	ENEMY_RANGE[5],
	12,
	ENEMY_SCORE[3],
	EA_INVINCIBLE,
	EK_RANGED,
	{ ER_BULLET, 1 },
	{
		[ES_BIRTH] = "skill_invincible_fly",
		[ES_MOVE] = "skill_invincible_fly",
		[ES_PREATTACK] = "skill_invincible_preattack",
		[ES_WOUNDED] = "skill_invincible_enter",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_ANIMAL_WOUNDED,
		[ES_PREATTACK] = SFX_ENEMY_ATTACK_BULLET_HEAVY,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_HEAVY,
	},
	EL_POSTRENDER,
};

Enemy_YinYang =
{
	ET_MONSTER,
	"enemy_yinyang",
	26,
	ENEMY_SPEED[3],
	ENEMY_RANGE[7],
	0,
	ENEMY_SCORE[5],
	EA_NONE,
	EK_NORMAL,
	{ ER_MELEE, -1 },
	{
		[ES_MOVE] = "skill_yinyang_move",
		[ES_ATTACK] = "skill_yinyang_summon",
		[ES_WOUNDED] = "skill_substitute",
		[ES_REVENGE] = "skill_yinyang_summon",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_ANIMAL_WOUNDED,
	},
};

Enemy_YinYangSummonee =
{
	ET_OBJECT,
	"enemy_paperman",
	1,
	ENEMY_SPEED[2],
	ENEMY_RANGE[1],
	20,
	ENEMY_SCORE[3],
	EA_NONSTOP,
	EK_BOMB,
	{ ER_MELEE, 1 },	
	{
		[ES_BIRTH] = "skill_summonee",
		[ES_PREATTACK] = "object_explode",
	},
	{
	},
};

Enemy_Daruma =
{
	ET_MONSTER,
	"enemy_daruma",
	66,
	ENEMY_SPEED[2],
	ENEMY_RANGE[4],
	20,
	100, --ENEMY_SCORE[5],
	EA_NONE,
	EK_NORMAL,
	{ ER_MELEE, 4 },	
	{
		[ES_BIRTH] = "skill_daruma_enter",
		[ES_WOUNDED] = "skill_enlarge",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_GIANT_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_HEAVY,
	},
	false,
	0.7,
};

--==============================================================================
-- Object
--==============================================================================

Enemy_EvilWheel =
{
	ET_OBJECT,
	"enemy_evilwheel",
	11,
	ENEMY_SPEED[5],
	ENEMY_RANGE[3], --ENEMY_RANGE[1],
	24,
	ENEMY_SCORE[4],
	EA_NONSTOP,
	EK_BOMB,
	{ ER_MELEE, 1 },
	{
		[ES_PREATTACK] = "object_explode",
		[ES_WOUNDED] = "object_wounded",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_OBJECT_WOUNDED,
	},
};

Enemy_ObjectBombcask =
{
	ET_OBJECT,
	"enemy_bombcask",
	6,
	ENEMY_SPEED[5],
	ENEMY_RANGE[1],
	20,
	ENEMY_SCORE[4],
	EA_NONSTOP,
	EK_BOMB,
	{ ER_MELEE, 1 },
	{
		[ES_PREATTACK] = "object_explode",
		[ES_WOUNDED] = "object_wounded",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_OBJECT_WOUNDED,
	},
};

Enemy_ObjectTrap =
{
	ET_OBJECT,
	"enemy_trap",
	1,
	ENEMY_SPEED[4],
	ENEMY_RANGE[1],
	15,
	ENEMY_SCORE[1],
	EA_STATIC,
	EK_NORMAL,
	{ ER_MELEE, 1 },
	{
		[ES_BIRTH] = "skill_trap_move",
		[ES_DEAD] = "skill_trap_hurt",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_OBJECT_WOUNDED,
	},
	EL_PRERENDER,
};

Enemy_ObjectPaperman =
{
	ET_OBJECT,
	"enemy_paperman",
	1,
	ENEMY_SPEED[2],
	ENEMY_RANGE[1],
	20,
	ENEMY_SCORE[3],
	EA_NONSTOP,
	EK_BOMB,
	{ ER_MELEE, 1 },	
	{
		[ES_BIRTH] = "skill_shadow_summoner",
		[ES_PREATTACK] = "object_explode",
	},
	{
	},
};

Enemy_ObjectPapermanSumonee =
{
	ET_OBJECT,
	"enemy_paperman",
	1,
	ENEMY_SPEED[2],
	ENEMY_RANGE[1],
	20,
	ENEMY_SCORE[3],
	EA_NONSTOP,
	EK_BOMB,
	{ ER_MELEE, 1 },	
	{
		[ES_BIRTH] = "skill_shadow_summonee",
		[ES_PREATTACK] = "object_explode",
	},
	{
	},
};

--==============================================================================
-- Boss
--==============================================================================

Boss_ShadowNinja =
{
	ET_BOSS,				-- type
	"boss_shadowninja",		-- look
	120,					-- life
	ENEMY_SPEED[4],			-- speed
	90, --ENEMY_RANGE[4],	-- range
	16,						-- attack
	100,					-- parry rate
	EA_DEFEND,				-- ability
	EK_NORMAL,				-- attack type
	{ ER_MELEE, 2 },			-- scope
	{						-- skill set
		[ES_BIRTH] = "boss_shadowninja_assault",
		[ES_WOUNDED] = "boss_shadowninja_mirror",
	},
	{
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_HEAVY,
	},
};

BossMinion_MirrorNinja_Melee =
{
	ET_BOSSMINION,
	"boss_shadowninja",
	21,
	ENEMY_SPEED[4],
	90, --ENEMY_RANGE[4],
	12,
	80,
	EA_NONE,
	EK_NORMAL,
	{ ER_MELEE, 2 },
	{
		[ES_BIRTH] = "boss_shadowninja_mirror_exit",
	},
	{
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_HEAVY,
	},
};

BossMinion_MirrorNinja_Ranged =
{
	ET_BOSSMINION,
	"bossminion_shadowninja_ranged",
	15,
	ENEMY_SPEED[4],
	ENEMY_RANGE[8],
	10,
	80,
	EA_NONE,
	EK_RANGED,
	{ ER_BULLET, 2 },
	{
		[ES_BIRTH] = "boss_shadowninja_mirror_exit",
		[ES_ATTACK] = "skill_bullet",
	},
	{
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_LIGHT,
	},
};

Boss_Akudaikan =
{
	ET_BOSS,
	"boss_akudaikan",
	260,
	ENEMY_SPEED[2],
	ENEMY_RANGE[6],
	20,
	100,
	EA_DEFEND,
	EK_RANGED,
	{ ER_BULLET, 4 },
	{
		[ES_ATTACK] = "skill_bullet",
		[ES_WOUNDED] = "boss_akudaikan_summon",
	},
	{
		[ES_PREATTACK] = SFX_ENEMY_ATTACK_BULLET_GUN,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_BULLET_HEAVY,
	},
};

Boss_GhostKing =
{
	ET_BOSS,
	"boss_ghostking",
	500,
	ENEMY_SPEED[2],
	ENEMY_RANGE[8],
	24,
	100,
	EA_NONE,
	EK_RANGED,
	{ ER_BULLET, 3 },
	{
		[ES_BIRTH] = "boss_ghostking_enter",
		[ES_ATTACK] = "skill_bullet",
		[ES_WOUNDED] = "boss_ghostking_summon",
	},
	{
		[ES_PREATTACK] = SFX_ENEMY_ATTACK_BULLET_LIGHT,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_BULLET_HEAVY,
	},
};

Boss_GiantSpider =
{
	ET_BOSS,
	"boss_giantspider",
	330,
	ENEMY_SPEED[3],
	ENEMY_RANGE[7],
	40,
	100,
	EA_NONE,
	EK_RANGED,
	{ ER_BULLET, 4 },
	{
		[ES_BIRTH] = "boss_giantspider_enter",
		[ES_ATTACK] = "skill_bullet",
		[ES_WOUNDED] = "boss_giantspider_jump_out",
	},
	{
		[ES_PREATTACK] = SFX_ENEMY_ATTACK_BULLET_LIGHT,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_HEAVY,
	},
};

BossMinion_MiniSpider =
{
	ET_BOSSMINION,
	"boss_giantspider",
	13,
	ENEMY_SPEED[5],
	ENEMY_RANGE[4],
	20,
	ENEMY_SCORE[1],
	EA_NONE,
	EK_NORMAL,
	{ ER_MELEE, 1 },
	{
		[ES_BIRTH] = "move",
	},
	{
	},
	false,
	0.35,
};

BossMinion_ObjectSpiderEgg =
{
	ET_OBJECT,
	"boss_giantspideregg",
	1,
	ENEMY_SPEED[4],
	ENEMY_RANGE[1],
	1,
	ENEMY_SCORE[1],
	EA_STATIC,
	EK_NORMAL,
	{ ER_MELEE, 1 },
	{
		[ES_BIRTH] = "boss_giantspider_trap_drop",
		[ES_DEAD] = "boss_giantspider_trap_hit",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_OBJECT_WOUNDED,
	},
};

Boss_DevilSamurai =
{
	ET_BOSS,
	"boss_devilsamurai",
	600,
	ENEMY_SPEED[2],
	180, --ENEMY_RANGE[5],
	54,
	0,
	EA_INVINCIBLE,
	EK_NORMAL,
	{ ER_MELEE, 4 },	
	{
		[ES_BIRTH] = "boss_devilsamurai_skill_enter",
		[ES_MOVE] = "boss_devilsamurai_action",
		[ES_WOUNDED] = "boss_devilsamurai_jump_out",
		[ES_ATTACK] = "boss_devilsamurai_attack",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_GIANT_WOUNDED,
		[ES_ATTACK] = SFX_ENEMY_ATTACK_MELEE_HEAVY,
	},
	false,
	1.8,
};

BossMinion_ObjectTrap =
{
	ET_OBJECT,
	"boss_trap",
	1,
	ENEMY_SPEED[4],
	ENEMY_RANGE[1],
	20,
	ENEMY_SCORE[1],
	EA_STATIC,
	EK_NORMAL,
	{ ER_MELEE, 1 },
	{
		[ES_BIRTH] = "boss_devilsamurai_trap_drop",
		[ES_DEAD] = "skill_trap_hurt",
	},
	{
		[ES_WOUNDED] = SFX_CHAR_OBJECT_WOUNDED,
	},
	EL_PRERENDER,
};


--==============================================================================
-- Enemy Rand Pool
--==============================================================================
ENEMY_RAND_POOL_1 =
{
	{ Enemy_BasicNinja, 30 },
	{ Enemy_WallNinja, 19 },
	{ Enemy_AssaultNinja, 16 },
	{ Enemy_FlyNinja, 9 },
	{ Enemy_ExplodeNinja, 18 },
	{ Enemy_BulletNinja, 5 },
	{ Enemy_HumanSwordMan, 3 },
};

ENEMY_RAND_POOL_2 =
{
	{ Enemy_HumanRobber, 27 },
	{ Enemy_HumanKabuki, 11 },
	{ Enemy_ObjectBombcask, 12 },
	{ Enemy_HumanDigMan, 9 },
	{ Enemy_HumanGunSoldier, 7 },
	{ Enemy_HumanMonk, 4 },
	{ Enemy_WallNinja, 13 },
	{ Enemy_FlyNinja, 17 },
};

ENEMY_RAND_POOL_3 =
{
	{ Enemy_UndeadSoldier, 25 },
	{ Enemy_UndeadGhost, 18 },
	{ Enemy_UndeadCrowTengu, 22 },
	{ Enemy_UndeadShogun, 11 },
	{ Enemy_UndeadRedOni, 5 },
	{ Enemy_GhostNinja, 9 },
	{ Enemy_ObjectBombcask, 10 },
};

ENEMY_RAND_POOL_4 =
{
	{ Enemy_Kappa, 17 },
	{ Enemy_EvilWheel, 12 },
	{ Enemy_Kamaitachi, 9 },
	{ Enemy_Racoon, 19 },
	{ Enemy_YinYang, 8 },
	{ Enemy_UndeadCrowTengu, 29 },
	{ Enemy_UndeadRedOni, 6 },
};

ENEMY_RAND_POOL_5 =
{
	{ Enemy_Umbrella, 23 },
	{ Enemy_SmallOni, 21 },
	{ Enemy_Daruma, 7 },
	{ Enemy_EvilWheel, 14 },
	{ Enemy_YinYang, 8 },
	{ Enemy_Kamaitachi, 5 },
	{ Enemy_BlueOni, 5 },
	{ Enemy_FireSkull, 17 },
};
