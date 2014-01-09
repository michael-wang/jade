--***********************************************************************
-- @file GameGlobal.lua
--***********************************************************************

-------------------------------------------------------------------------
GAME_DIFF_NORMAL = 1;
GAME_DIFF_SHADOW = 2;

GAME_DIFFICULTY =
{
    [1] = "Normal",
    [2] = "Shadow",
};

ENEMY_MAX = 30;
ENEMY_DROP_MAX = ENEMY_MAX * 4;

ENEMY_MAIN_SPRITE = 3;

ENEMY_BAR_SIZE = { 45 * APP_SCALE_FACTOR, 4 * APP_SCALE_FACTOR };
ENEMY_BAR_OFFSET = { 10 * APP_SCALE_FACTOR, -5 * APP_SCALE_FACTOR };
ENEMY_BAR_FRAME = 2 * APP_SCALE_FACTOR;

ENEMY_SHADOW_LIFE = 4.2;
ENEMY_SHADOW_POWER = 1.5;
ENEMY_SHADOW_SPEED = 1.1;

EFFECT_MAX = 10;

if (IS_DEVICE_IPAD) then
    SCENE_LAYER_SIZE = 1024;
else
    SCENE_LAYER_SIZE = 568;
end

AVATAR_DODGE_DIST = 18;

COIN_LIVE_DURATION = 7000;
COIN_BLINK_DURATION = 3000;
COIN_MOVE_VELOCITY = 160;
COIN_BOUNCE_VELOCITY = 350;
COIN_BOUNCE_OFFSET = 15;

TREASURE_LIVE_DURATION = 7000;
TREASURE_BLINK_DURATION = 3000;
TREASURE_BOUNCE_VELOCITY = 250;
TREASURE_SHAKE_VELOCITY = 750;
TREASURE_SHAKE_OFFSET = 4;

HEAL_INTER_RATE = 125;
COMBO_LIVE_DURATION = 2000; --3500;
TEXTEFFECT_LIVE_DURATION = 700;

TEXT_EFFECT_SCALE =
{
    ["CriticalText"] = 1.5,
};

TEXT_FINAL_WAVE_DURATION = 2000;

MAGIC_CIRCLE_DURATION = 700;
MAGIC_CIRCLE_SCALE = 1.75;

ENEMY_SCROLL_RAND_THESHOLD = 5;
ENEMY_SCROLL_HIT_CHANCE = 50;
CASTLE_SCROLL_SHIELD_DURATION = 10000;

DEFAULT_DROP_RATE = 25;
DEFAULT_EXPBALL_RATE = 0;

DOOR_HALF_SIZE = 250;

ENCHANT_POISON_COUNT = 5;
ENCHANT_POISON_DURATION = 1000;
ENCHANT_FREEZE_DURATION = 7500;
ENCHANT_STUN_DURATION = 1000;  --1500;

FEEDBACK_DISTANCE_INITIAL = 10000;
FEEDBACK_DISTANCE_MAX = 40000;  --320000;
FEEDBACK_GAMECOUNT_INITIAL = 20;
FEEDBACK_GAMECOUNT_MAX = 200;

GAME_SCORE_FACTOR =
{
    [GAME_DIFF_NORMAL] =
    {
        [1] = { 10, 20 },
        [2] = { 20, 40 },
        [3] = { 30, 60 },
        [4] = { 40, 80 },
        [5] = { 50, 100 },
    },
    
    [GAME_DIFF_SHADOW] =
    {
        [1] = { 50,  120 },
        [2] = { 100, 240 },
        [3] = { 150, 360 },
        [4] = { 200, 480 },
        [5] = { 250, 600 },
    },
};

GAME_BOSS_FACTOR = 1.5;

TREASURE_ANIM_IDLE = 1;
TREASURE_ANIM_OPEN = 2;
TREASURE_ANIM_CLOSE = 3;

TREASURE_ANIM =
{
    [1] = { "ui_stat_box1_idle", "ui_stat_box1_open", "ui_stat_box1" },
    [2] = { "ui_stat_box2_idle", "ui_stat_box2_open", "ui_stat_box2" },
    [3] = { "ui_stat_box3_idle", "ui_stat_box3_open", "ui_stat_box3" },
}

TREASURE_TYPE_COIN = 1;
TREASURE_TYPE_KOBAN = 2;
TREASURE_TYPE_BOOST = 3;

TREAUSRE_KOBAN_FINAL_CHANCE = 10;
TREAUSRE_KOBAN_FACTOR = 5;

-------------------------------------------------------------------------
TREASURE_COIN_RANGE =
{
    [GAME_DIFF_NORMAL] =
    {
        [1] =
        {
            { 20, 30 },
            { 60, 90 },
            { 120, 200 },
        },
        
        [2] =
        {
            { 30, 45 },
            { 90, 135 },
            { 180, 300 },
        },
        
        [3] =
        {
            { 40, 60 },
            { 120, 180 },
            { 240, 400 },
        },
        
        [4] =
        {
            { 50, 75 },
            { 150, 225 },
            { 300, 500 },
        },
        
        [5] =
        {
            { 60, 90 },
            { 180, 270 },
            { 360, 600 },
        },
    },
    
    [GAME_DIFF_SHADOW] =
    {
        [1] =
        {
            { 70, 105 },
            { 210, 315 },
            { 420, 700 },
        },
        
        [2] =
        {
            { 80, 120 },
            { 240, 360 },
            { 480, 800 },
        },
        
        [3] =
        {
            { 90, 135 },
            { 270, 405 },
            { 540, 900 },
        },
        
        [4] =
        {
            { 100, 150 },
            { 300, 450 },
            { 600, 1000 },
        },
        
        [5] =
        {
            { 110, 165 },
            { 330, 495 },
            { 660, 1100 },
        },
    },
};

-------------------------------------------------------------------------
TREASURE_KOBAN_RANGE =
{
    [GAME_DIFF_NORMAL] =
    {
        [1] =
        {
            { 1, 1 },
            { 1, 2 },
            { 2, 2 },
        },
        
        [2] =
        {
            { 1, 1 },
            { 1, 2 },
            { 2, 3 },
        },
        
        [3] =
        {
            { 1, 1 },
            { 1, 2 },
            { 2, 4 },
        },
        
        [4] =
        {
            { 1, 1 },
            { 1, 2 },
            { 2, 5 },
        },
        
        [5] =
        {
            { 1, 2 },
            { 2, 3 },
            { 3, 5 },
        },
    },
    
    [GAME_DIFF_SHADOW] =
    {
        [1] =
        {
            { 1, 2 },
            { 2, 3 },
            { 3, 4 },
        },
        
        [2] =
        {
            { 1, 2 },
            { 2, 3 },
            { 3, 5 },
        },
        
        [3] =
        {
            { 1, 2 },
            { 2, 3 },
            { 3, 6 },
        },
        
        [4] =
        {
            { 1, 2 },
            { 2, 4 },
            { 4, 7 },
        },
        
        [5] =
        {
            { 1, 2 },
            { 2, 4 },
            { 4, 8 },
        },
    },
};

TREAUSRE_BOOST_DICE = 33;
TREAUSRE_BOOST_DISTANCE = { 500, 1200, 2500 };
TREAUSRE_BOOST_CHANCE =
{
    [GAME_DIFF_NORMAL] =
    {
        [1] = { 75, 97, 100 },  -- Medal #1
        [2] = { 70, 94, 100 },  -- Medal #2
        [3] = { 65, 91, 100 },  -- Medal #3
    },
    
    [GAME_DIFF_SHADOW] =
    {
        [1] = { 75, 98, 100 },  -- Medal #1
        [2] = { 70, 95, 100 },  -- Medal #2
        [3] = { 65, 92, 100 },  -- Medal #3
    },
};

MAP_UNLOCK_COST =
{
    [GAME_DIFF_NORMAL] =
    {
        [2] = 10,
        [3] = 20,
        [4] = 40,
        [5] = 80,
    },

    [GAME_DIFF_SHADOW] =
    {
        [2] = 100,
        [3] = 200,
        [4] = 400,
        [5] = 800,
    },
};

MAP_BOOST_COST =
{
--[[ @BoostByCoin
    [GAME_DIFF_NORMAL] =
    {
        111,
        222,
        333,
        444,
        555,
    },

    [GAME_DIFF_SHADOW] =
    {
        666,
        777,
        888,
        999,
        1111,
    },
--]]    
    [GAME_DIFF_NORMAL] = { 1, 1, 1, 1, 1 },
    [GAME_DIFF_SHADOW] = { 2, 2, 3, 3, 4 },
};

DEFAULT_MAP_UNLOCK_COST = 100;
DEFAULT_MAP_BOOST_COST = 10;

-------------------------------------------------------------------------
FA_SET_DATA =
{
    distance =
    {
        100, 500, 1000, 1500, 2000, 2500, 3000, 6000, 9000, 10000,
    },
    
    coin =
    {
        10, 50, 100, 200, 300, 500, 1000, 1500, 2000, 3000,
    },

    score =
    {
        1000, 5000, 10000, 20000, 40000, 80000, 160000, 320000, 640000, 1000000,
    },
};

FA_REVIVE_DIST = { 500, 1500, 3000, 6000, 9000 };

-------------------------------------------------------------------------
POCKET_SET_DATA =
{
    koban = { 0, 5,   10,   100,  500,   1000,  5000,  9999  },
    coin =  { 0, 100, 1000, 5000, 10000, 50000, 10000, 30000 },
};

-------------------------------------------------------------------------
INNOCENT_WARN_DELAY =
{
	[GAME_DIFF_NORMAL] = 1200,
	[GAME_DIFF_SHADOW] = 700,
};

-------------------------------------------------------------------------
REVIVE_DELAY_DURAION = 1000;
REVIVE_WAIT_DURAION = 3000;
REVIVE_UI_OFFSET = 130 * APP_UNIT_Y;

BOOST_WAIT_DURAION = 3000;
UI_BOOST_OFFSET = 160 * APP_UNIT_X;

WEAPON_TYPE = 1;
WEAPON_ID = 2;
--WEAPON_KNOCKBACK_DIST = 100;

EXP_GAIN_MIN = 10;

-------------------------------------------------------------------------
DURATION_DAY_1 = 60 * 60 * 24;
--[[ @DEBUG
DURATION_DAY_1 = 5;
--]]
--DAILY_CHALLENGE_DURATION = DURATION_DAY_1;
DAILY_CHALLENGE_DURATION = 60 * 60 * 23; -- 23 hours
DURATION_PARSE_UPDATE = 60 * 60 * 36;    -- 36 hours
DURATION_DAY_LAST = DURATION_DAY_1 * 28;

NOTIF_MSG_MAX_COUNT = 5;
NOTIF_MSG_PREFIX = "notif_msg";
NOTIF_MSG_NO_BOSS = "notif_sp1";
NOTIF_MSG_BOSS_P1 = "notif_sp2";
NOTIF_MSG_BOSS_P2 = "notif_sp3";
NOTIF_MSG_BYE = "notif_bye";
NOTIF_MSG_NORMAL =
{
    DURATION_DAY_1,
    DURATION_DAY_1 * 3,
    DURATION_DAY_1 * 5,
    DURATION_DAY_1 * 7,
    DURATION_DAY_1 * 10,
    DURATION_DAY_1 * 15,
};

NOTIF_MSG_CHALLENGE =
{
    DURATION_DAY_1 * 2,
    DURATION_DAY_1 * 4,
    DURATION_DAY_1 * 6,
    DURATION_DAY_1 * 9,
    DURATION_DAY_1 * 14,
};

-------------------------------------------------------------------------
GAME_STAT_PLAY_COUNT = "PlayCount";
GAME_STAT_DISTANCE = "TotalDistance";
GAME_STAT_COIN = "CoinEarned";
GAME_STAT_KOBAN = "KobanEarned";
GAME_STAT_ENEMY_KILL = "EnemyKill";
GAME_STAT_REVIVE = "ReviveCount";
GAME_STAT_JADE_TRIGGER = "JadeTrigger";
GAME_STAT_SCROLL_USE = "ScrollUse";
GAME_STAT_SLASH_KATANA = "SlashKatana";
GAME_STAT_SLASH_BLADE = "SlashBlade";
GAME_STAT_SLASH_SPEAR = "SlashSpear";
GAME_STAT_INNOCENT_SAFE = "InnocentSafe";
GAME_STAT_INNOCENT_HURT = "InnocentHurt";
GAME_STAT_MONKEY_CATCH = "MonkeyCatch";
GAME_STAT_BOSS_KILL = "BossKill";

GAME_STAT_SUBJECTS =
{
    GAME_STAT_PLAY_COUNT,
    GAME_STAT_DISTANCE,
    GAME_STAT_COIN,
    GAME_STAT_KOBAN,
    GAME_STAT_ENEMY_KILL,
    GAME_STAT_REVIVE,
    GAME_STAT_JADE_TRIGGER,
    GAME_STAT_SCROLL_USE,
    GAME_STAT_SLASH_KATANA,
    GAME_STAT_SLASH_BLADE,
    GAME_STAT_SLASH_SPEAR,
    GAME_STAT_INNOCENT_SAFE,
    GAME_STAT_INNOCENT_HURT,
    GAME_STAT_MONKEY_CATCH,
    --GAME_STAT_BOSS_KILL,
};

--===================================
-- Render Groups
--===================================
BACKDROP_GROUP = ROUTINE_GROUP_01;
CASTLE_GROUP = ROUTINE_GROUP_02;
ENEMY_GROUP = ROUTINE_GROUP_05;
BLADE_GROUP = ROUTINE_GROUP_09;
UI_GROUP = ROUTINE_GROUP_10;

GAME_OBJECT_GROUPS =
{
    BACKDROP_GROUP,
    CASTLE_GROUP,
    ENEMY_GROUP,
    BLADE_GROUP,
};
