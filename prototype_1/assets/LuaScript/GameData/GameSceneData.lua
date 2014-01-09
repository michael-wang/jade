--***********************************************************************
-- @file GameSceneData.lua
--***********************************************************************
DECO_LAUNCHER_DURATION_MIN = 700;
DECO_LAUNCHER_DURATION_MAX = 1700;
DECO_VELOCITY_TEMPLATE_MIN = 50;
DECO_VELOCITY_TEMPLATE_MAX = 90;
DECO_VELOCITY_MIN = 50;
DECO_VELOCITY_MAX = 90;
DECO_RANGE_MIN = 30;
DECO_RANGE_MAX = 80;
DECO_ROTATE_DURATION_MIN = 4000;
DECO_ROTATE_DURATION_MAX = 5000;

DSCENE_LAYERS_SPEED =
{
	{ 1200, 2900, 9600, }, -- { 1000, 2400, 8000, },
	{ 1000, 2400, 8000, },
	{ 1000, 2400, 8000, },
	{ 1000, 2400, 8000, },
	{ 1000, 2400, 8000, },
};



--==============================================================================
-- Game Events
--==============================================================================
-------------------------------------------------------------------------
ENEMY_EVENTS_1 =
{
	[1] =    { 0.90, 0, 0, { 100, 100, 100, 100 } },   -- No innocents for first 500m
	[500] =  { 1.00, 5 },
	[1000] = { 1.05, 10, 7 },
	[1500] = { 1.10, 15, 7, { 95, 100, 100, 100 } },
	[2000] = { 1.15, 20, 13 },
	[2500] = { 1.20, 20 },
	[3000] = { 1.25, 25, 20, { 90, 95, 100, 100 } },
	[3500] = { 1.25, 25 },
	[4000] = { 1.30, 30, 26 },
	[4500] = { 1.30, 30 },
	[5000] = { 1.40, 40, 33 },
	[6000] = { 1.40, 40 },
    [9000] = { 1.50, 50, 50 },
    [10000] = { 2.0, 60, 80 },
};

ENEMY_EVENTS_2 =
{
	[1] =    { 0.90, 10, 0, { 95, 100, 100, 100 } },
	[500] =  { 1.00, 10 },
	[1000] = { 1.05, 15, 7 },
	[1500] = { 1.10, 15, 7, { 90, 95, 100, 100 } },
	[2000] = { 1.15, 20, 13 },
	[2500] = { 1.20, 20 },
	[3000] = { 1.25, 25, 20, { 85, 95, 100, 100 } },
	[3500] = { 1.25, 25 },
	[4000] = { 1.30, 30, 26 },
	[4500] = { 1.30, 30 },
	[5000] = { 1.40, 40, 33 },
	[6000] = { 1.40, 40 },
    [9000] = { 1.50, 50, 50 },
    [10000] = { 2.0, 60, 80 },
};

ENEMY_EVENTS_3 =
{
	[1] =    { 0.90, 10, 0, { 90, 95, 100, 100 } },
	[500] =  { 1.00, 10 },
	[1000] = { 1.05, 15, 7 },
	[1500] = { 1.10, 15, 7, { 85, 95, 100, 100 } },
	[2000] = { 1.15, 20, 13 },
	[2500] = { 1.20, 20 },
	[3000] = { 1.25, 25, 20, { 80, 90, 100, 100 } },
	[3500] = { 1.25, 25 },
	[4000] = { 1.30, 30, 26 },
	[4500] = { 1.30, 30 },
	[5000] = { 1.40, 40, 33 },
	[6000] = { 1.40, 40 },
    [9000] = { 1.50, 50, 50 },
    [10000] = { 2.0, 60, 80 },
};

ENEMY_EVENTS_4 =
{
	[1] =    { 0.90, 10, 0, { 85, 95, 100, 100 } },
	[500] =  { 1.00, 10 },
	[1000] = { 1.05, 15, 7 },
	[1500] = { 1.10, 15, 7, { 80, 90, 100, 100 } },
	[2000] = { 1.15, 20, 13 },
	[2500] = { 1.20, 20 },
	[3000] = { 1.25, 25, 20, { 75, 90, 95, 100 } },
	[3500] = { 1.25, 25 },
	[4000] = { 1.30, 30, 26 },
	[4500] = { 1.30, 30 },
	[5000] = { 1.40, 40, 33 },
	[6000] = { 1.40, 40 },
    [9000] = { 1.50, 50, 50 },
    [10000] = { 2.0, 60, 80 },
};

ENEMY_EVENTS_5 =
{
	[1] =    { 0.90, 10, 0, { 80, 90, 100, 100 } },
	[500] =  { 1.00, 10 },
	[1000] = { 1.05, 15, 7 },
	[1500] = { 1.10, 15, 7, { 75, 90, 95, 100 } },
	[2000] = { 1.15, 20, 13 },
	[2500] = { 1.20, 20 },
	[3000] = { 1.25, 25, 20, { 70, 85, 95, 100 } },
	[3500] = { 1.25, 25 },
	[4000] = { 1.30, 30, 26 },
	[4500] = { 1.30, 30 },
	[5000] = { 1.40, 40, 33 },
	[6000] = { 1.40, 40 },
    [9000] = { 1.50, 50, 50 },
    [10000] = { 2.0, 60, 80 },
};

-------------------------------------------------------------------------
SHADOW_ENEMY_EVENTS_1 =
{
	[1] =    { 1.00, 10, 20, { 75, 90, 95, 100 } },
	[500] =  { 1.00, 10 },
	[1000] = { 1.05, 15 },
	[1500] = { 1.10, 15, 20, { 70, 85, 95, 100 } },
	[2000] = { 1.15, 20, 26 },
	[2500] = { 1.20, 20 },
	[3000] = { 1.25, 25, 33, { 65, 80, 95, 100 } },
	[3500] = { 1.25, 25 },
	[4000] = { 1.30, 30, 40 },
	[4500] = { 1.30, 30 },
	[5000] = { 1.40, 40, 46 },
	[6000] = { 1.40, 40 },
    [9000] = { 1.50, 50, 50 },
    [10000] = { 2.0, 60, 80 },
};

SHADOW_ENEMY_EVENTS_2 =
{
	[1] =    { 1.00, 10, 20, { 70, 85, 95, 100 } },
	[500] =  { 1.00, 10 },
	[1000] = { 1.05, 15 },
	[1500] = { 1.10, 15, 20, { 65, 80, 95, 100 } },
	[2000] = { 1.15, 20, 26 },
	[2500] = { 1.20, 20 },
	[3000] = { 1.25, 25, 33, { 60, 75, 90, 100 } },
	[3500] = { 1.25, 25 },
	[4000] = { 1.30, 30, 40 },
	[4500] = { 1.30, 30 },
	[5000] = { 1.40, 40, 46 },
	[6000] = { 1.40, 40 },
    [9000] = { 1.50, 50, 50 },
    [10000] = { 2.0, 60, 80 },
};

SHADOW_ENEMY_EVENTS_3 =
{
	[1] =    { 1.00, 10, 20, { 65, 80, 95, 100 } },
	[500] =  { 1.00, 10 },
	[1000] = { 1.05, 15 },
	[1500] = { 1.10, 15, 20, { 60, 75, 90, 100 } },
	[2000] = { 1.15, 20, 26 },
	[2500] = { 1.20, 20 },
	[3000] = { 1.25, 25, 33, { 55, 75, 90, 100 } },
	[3500] = { 1.25, 25 },
	[4000] = { 1.30, 30, 40 },
	[4500] = { 1.30, 30 },
	[5000] = { 1.40, 40, 46 },
	[6000] = { 1.40, 40 },
    [9000] = { 1.50, 50, 50 },
    [10000] = { 2.0, 60, 80 },
};

SHADOW_ENEMY_EVENTS_4 =
{
	[1] =    { 1.00, 10, 20, { 60, 75, 90, 100 } },
	[500] =  { 1.00, 10 },
	[1000] = { 1.05, 15 },
	[1500] = { 1.10, 15, 20, { 55, 75, 90, 100 } },
	[2000] = { 1.15, 20, 26 },
	[2500] = { 1.20, 20 },
	[3000] = { 1.25, 25, 33, { 50, 70, 90, 100 } },
	[3500] = { 1.25, 25 },
	[4000] = { 1.30, 30, 40 },
	[4500] = { 1.30, 30 },
	[5000] = { 1.40, 40, 46 },
	[6000] = { 1.40, 40 },
    [9000] = { 1.50, 50, 50 },
    [10000] = { 2.0, 60, 80 },
};

SHADOW_ENEMY_EVENTS_5 =
{
	[1] =    { 1.00, 10, 20, { 55, 75, 90, 100 } },
	[500] =  { 1.00, 10 },
	[1000] = { 1.05, 15 },
	[1500] = { 1.10, 15, 20, { 50, 70, 90, 100 } },
	[2000] = { 1.15, 20, 26 },
	[2500] = { 1.20, 20 },
	[3000] = { 1.25, 25, 33, { 50, 65, 85, 100 } },
	[3500] = { 1.25, 25 },
	[4000] = { 1.30, 30, 40 },
	[4500] = { 1.30, 30 },
	[5000] = { 1.40, 40, 46 },
	[6000] = { 1.40, 40 },
    [9000] = { 1.50, 50, 50 },
    [10000] = { 2.0, 60, 80 },
};



--==============================================================================
-- Game Scenes
--==============================================================================

GAME_SCENE_POOL =
{	
	--==========================================================================
	-- Dojo
	--==========================================================================
	dojo =
	{
		backdrop = "scene_dojo_background",		
		layer_pre = { "scene_dojo_background", 0, 0, 3800 },
		layer_mid = { "scene_dojo_background", 0, 0, 3800 },
		layer_post = { "scene_dojo_layer1", 0, 241, 3200 },
		
		castle =
		{
			x = 370,
			y = 150,
			width = 75,
			height = 75,
			offsetX = 0,
			offsetY = 0,
		},

		field =
		{
			x = { 0, 360 },
			y = { 120, 185 }, --{ 120, 194 },
		},
		
		range_mid =
		{
			x = { 140, 270 },
			y = { 100, 220 },
		},
		
		range_long =
		{
			x = { 40, 140 },
			y = { 100, 220 },
		},

		wall =
		{
			x = { 80, 180 },
			y = 320,
			offset =
			{
				{ 75, -150 },
				{ 25, 25 },
			},
		},
		
		shield =
		{
			x = 300,
			y = 65,
		},
		
		speedline =
		{
			x = 0,
			y = 102,
		},
	};

	--==========================================================================
	-- D-Scene #1
	--==========================================================================

	-- D-Scene #1 @ Day
	city_day =
	{
		backdrop = "scene_city_daytime_background",
		layer_pre = { "scene_city_daytime_layer3", 0, 22,  DSCENE_LAYERS_SPEED[1][3] },		
		layer_mid = { "scene_city_daytime_layer2", 0, 110 , DSCENE_LAYERS_SPEED[1][2] },
		layer_post = { "scene_city_daytime_layer1", 0, 201, DSCENE_LAYERS_SPEED[1][1] },
--		layer_overlay = { "scene_city_daytime_sunlight", 175, 60, 2.0 },
--		layer_overlay = { "scene_city_daytime_sunlight", 142, 5, 1.0 },

		decorator =
		{
			DECO_TYPE_LEAF,
			{ "scene_city_daytime_leaf", },
		},
		
		castle =
		{
			x = 370,
			y = 150,
			width = 75,
			height = 75,
			offsetX = 0,
			offsetY = 0,
		},

		field =
		{
			x = { 0, 360 },
			y = { 130, 185 }, --{ 120, 185 },
		},
		
		range_mid =
		{
			x = { 140, 270 },
			y = { 100, 220 },
		},
		
		range_long =
		{
			x = { 40, 140 },
			y = { 100, 220 },
		},

		wall =
		{
			x = { 80, 180 },
			y = 320,
			offset =
			{
				{ 75, -150 },
				{ 25, 25 },
			},
		},
		
		shield =
		{
			x = 300,
			y = 65,
		},
		
		speedline =
		{
			x = 0,
			y = 102,
		},
	},
	
	-- D-Scene #1 @ Night
	city_night =
	{
		backdrop = "scene_city_night_background",
		layer_pre = { "scene_city_night_layer3", 0, 22,  DSCENE_LAYERS_SPEED[1][3] },
		layer_mid =	{ "scene_city_night_layer2", 0, 110, DSCENE_LAYERS_SPEED[1][2] },		
		layer_post = { "scene_city_night_layer1", 0, 201, DSCENE_LAYERS_SPEED[1][1] },
--		layer_overlay = { "scene_city_night_moonlight", 175, 60, 2.0 },
--		layer_overlay = { "scene_city_night_moonlight", 142, 5, 1.0 },

		decorator =
		{
			DECO_TYPE_LEAF,
			{ "scene_city_night_leaf", },
		},

		castle =
		{
			x = 370,
			y = 150,
			width = 75,
			height = 75,
			offsetX = 0,
			offsetY = 0,
		},

		field =
		{
			x = { 0, 360 },
			y = { 130, 185 }, --{ 120, 185 },
		},
		
		range_mid =
		{
			x = { 140, 270 },
			y = { 100, 220 },
		},
		
		range_long =
		{
			x = { 40, 140 },
			y = { 100, 220 },
		},

		wall =
		{
			x = { 80, 180 },
			y = 320,
			offset =
			{
				{ 75, -150 },
				{ 25, 25 },
			},
		},
		
		shield =
		{
			x = 300,
			y = 65,
		},

		speedline =
		{
			x = 0,
			y = 102,
		},
	},

	--==========================================================================
	-- D-Scene #2
	--==========================================================================

	-- D-Scene #2 @ Day
	battlefield_day =
	{
		backdrop = "scene_battlefield_daytime_background",		
		layer_pre = { "scene_battlefield_daytime_layer3", 0, 0,  DSCENE_LAYERS_SPEED[2][3] },
		layer_mid =	{ "scene_battlefield_daytime_layer2", 0, 74, DSCENE_LAYERS_SPEED[2][2] },		
		layer_post = { "scene_battlefield_daytime_layer1", 0, 274, DSCENE_LAYERS_SPEED[2][1] },

		decorator =
		{
			DECO_TYPE_LIGHTNING,
			{ "scene_battlefield_daytime_lightning1", "scene_battlefield_daytime_lightning2", "scene_battlefield_daytime_lightning3" },
			{ 2000, 5000, 100, 100 },
		},

		castle =
		{
			x = 370,
			y = 150,
			width = 75,
			height = 75,
			offsetX = 0,
			offsetY = 0,
		},

		field =
		{
			x = { 0, 360 },
			y = { 130, 200 }, --{ 140, 230 },
		},
		
		range_mid =
		{
			x = { 140, 270 },
			y = { 100, 220 },
		},
		
		range_long =
		{
			x = { 40, 140 },
			y = { 100, 220 },
		},

		wall =
		{
			x = { 80, 180 },
			y = 320,
			offset =
			{
				{ 75, -150 },
				{ 25, 25 },
			},
		},

		shield =
		{
			x = 300,
			y = 65,
		},

		speedline =
		{
			x = 0,
			y = 102,
		},
	},

	-- D-Scene #2 @ Night
	battlefield_night =
	{
		backdrop = "scene_battlefield_night_background",		
		layer_pre = { "scene_battlefield_night_layer3", 0, 0,  DSCENE_LAYERS_SPEED[2][3] },
		layer_mid =	{ "scene_battlefield_night_layer2", 0, 74, DSCENE_LAYERS_SPEED[2][2] },
		layer_post = { "scene_battlefield_night_layer1", 0, 274, DSCENE_LAYERS_SPEED[2][1] },

		decorator =
		{
			DECO_TYPE_LIGHTNING,
			{ "scene_battlefield_night_lightning1", "scene_battlefield_night_lightning2", "scene_battlefield_night_lightning3" },
			{ 2000, 5000, 100, 100 },
		},

		castle =
		{
			x = 370,
			y = 150,
			width = 75,
			height = 75,
			offsetX = 0,
			offsetY = 0,
		},

		field =
		{
			x = { 0, 360 },
			y = { 130, 200 }, --{ 140, 230 },
		},
		
		range_mid =
		{
			x = { 140, 270 },
			y = { 100, 220 },
		},
		
		range_long =
		{
			x = { 40, 140 },
			y = { 100, 220 },
		},

		wall =
		{
			x = { 80, 180 },
			y = 320,
			offset =
			{
				{ 75, -150 },
				{ 25, 25 },
			},
		},

		shield =
		{
			x = 300,
			y = 65,
		},

		speedline =
		{
			x = 0,
			y = 102,
		},
	},

	--==========================================================================
	-- D-Scene #3
	--==========================================================================

	-- D-Scene #3 @ Day
	bamboo_day =
	{
		backdrop = "scene_bamboo_daytime_background",		
		layer_pre = { "scene_bamboo_daytime_layer3", 0, 0,  DSCENE_LAYERS_SPEED[3][3] },
		layer_mid =	{ "scene_bamboo_daytime_layer2", 0, 45, DSCENE_LAYERS_SPEED[3][2] },
		layer_post = { "scene_bamboo_daytime_layer1", 0, 245, DSCENE_LAYERS_SPEED[3][1] },

		decorator =
		{
			DECO_TYPE_FOG,
			{ "scene_bamboo_daytime_fog", },
			{ 3000, 6000, 180, 220 },  -- launch min, launch max, velocity min, velocity max
		},

		castle =
		{
			x = 370,
			y = 150,
			width = 75,
			height = 75,
			offsetX = 0,
			offsetY = 0,
		},

		field =
		{
			x = { 0, 360 },
			y = { 130, 210 }, --{ 140, 240 }
		},
		
		range_mid =
		{
			x = { 140, 270 },
			y = { 100, 220 },
		},
		
		range_long =
		{
			x = { 40, 140 },
			y = { 100, 220 },
		},

		wall =
		{
			x = { 80, 180 },
			y = 320,
			offset =
			{
				{ 75, -150 },
				{ 25, 25 },
			},
		},

		shield =
		{
			x = 300,
			y = 65,
		},

		speedline =
		{
			x = 0,
			y = 102,
		},
	},

	-- D-Scene #3 @ Night
	bamboo_night =
	{
		backdrop = "scene_bamboo_night_background",	
		layer_pre = { "scene_bamboo_night_layer3", 0, 0,  DSCENE_LAYERS_SPEED[3][3] },
		layer_mid =	{ "scene_bamboo_night_layer2", 0, 45, DSCENE_LAYERS_SPEED[3][2] },
		layer_post = { "scene_bamboo_night_layer1", 0, 245, DSCENE_LAYERS_SPEED[3][1] },

		decorator =
		{
			DECO_TYPE_FOG,
			{ "scene_bamboo_night_fog", },
			{ 3000, 6000, 180, 220 },  -- launch min, launch max, velocity min, velocity max
		},

		castle =
		{
			x = 370,
			y = 150,
			width = 75,
			height = 75,
			offsetX = 0,
			offsetY = 0,
		},

		field =
		{
			x = { 0, 360 },
			y = { 130, 210 }, --{ 140, 240 }
		},
		
		range_mid =
		{
			x = { 140, 270 },
			y = { 100, 220 },
		},
		
		range_long =
		{
			x = { 40, 140 },
			y = { 100, 220 },
		},

		wall =
		{
			x = { 80, 180 },
			y = 320,
			offset =
			{
				{ 75, -150 },
				{ 25, 25 },
			},
		},

		shield =
		{
			x = 300,
			y = 65,
		},

		speedline =
		{
			x = 0,
			y = 102,
		},
	},
	
	--==========================================================================
	-- D-Scene #4
	--==========================================================================

	-- D-Scene #4 @ Day
	forest_day =
	{
		backdrop = "scene_forest_daytime_background",
		layer_pre = { "scene_forest_daytime_layer3", 0, 0,  DSCENE_LAYERS_SPEED[4][3] },		
		layer_mid = { "scene_forest_daytime_layer2", 0, 0, DSCENE_LAYERS_SPEED[4][2] },
		layer_post = { "scene_forest_daytime_layer1", 0, 246, DSCENE_LAYERS_SPEED[4][1] },
		layer_overlay = { "scene_forest_daytime_sunlight", 173, -1 },

		decorator =
		{
			DECO_TYPE_LEAF,
			{ "scene_forest_daytime_leaf", },
		},

		castle =
		{
			x = 370,
			y = 150,
			width = 75,
			height = 75,
			offsetX = 0,
			offsetY = 0,
		},

		field =
		{
			x = { 0, 360 },
			y = { 130, 210 }, --{ 120, 175 },
		},
		
		range_mid =
		{
			x = { 140, 270 },
			y = { 100, 220 },
		},
		
		range_long =
		{
			x = { 40, 140 },
			y = { 100, 220 },
		},

		wall =
		{
			x = { 80, 180 },
			y = 320,
			offset =
			{
				{ 75, -150 },
				{ 25, 25 },
			},
		},
		
		shield =
		{
			x = 300,
			y = 65,
		},
		
		speedline =
		{
			x = 0,
			y = 102,
		},
	},	

	-- D-Scene #4 @ Night
	forest_night =
	{
		backdrop = "scene_forest_night_background",
		layer_pre = { "scene_forest_night_layer3", 0, 0,  DSCENE_LAYERS_SPEED[4][3] },		
		layer_mid = { "scene_forest_night_layer2", 0, 0, DSCENE_LAYERS_SPEED[4][2] },
		layer_post = { "scene_forest_night_layer1", 0, 246, DSCENE_LAYERS_SPEED[4][1] },
		layer_overlay = { "scene_forest_night_sunlight", 173, -1 },

		decorator =
		{
			DECO_TYPE_LEAF,
			{ "scene_forest_night_leaf", },
		},
		
		castle =
		{
			x = 370,
			y = 150,
			width = 75,
			height = 75,
			offsetX = 0,
			offsetY = 0,
		},

		field =
		{
			x = { 0, 360 },
			y = { 130, 210 }, --{ 120, 175 },
		},
		
		range_mid =
		{
			x = { 140, 270 },
			y = { 100, 220 },
		},
		
		range_long =
		{
			x = { 40, 140 },
			y = { 100, 220 },
		},

		wall =
		{
			x = { 80, 180 },
			y = 320,
			offset =
			{
				{ 75, -150 },
				{ 25, 25 },
			},
		},
		
		shield =
		{
			x = 300,
			y = 65,
		},
		
		speedline =
		{
			x = 0,
			y = 102,
		},
	},
	
	--==========================================================================
	-- D-Scene #5
	--==========================================================================

	-- D-Scene #5 @ Day
	lava_day =
	{
		backdrop = "scene_lava_daytime_background",
		layer_pre = { "scene_lava_daytime_layer3", 0, 44,  DSCENE_LAYERS_SPEED[5][3] },		
		layer_mid = { "scene_lava_daytime_layer2", 0, 62, DSCENE_LAYERS_SPEED[5][2] },
		layer_post = { "scene_lava_daytime_layer1", 0, 220, DSCENE_LAYERS_SPEED[5][1] },

		decorator =
		{
			DECO_TYPE_FIREPILLAR,
			{ "scene_lava_explosion_day" },
			{ 2500, 6000, 1, 1 },
		},
		
		castle =
		{
			x = 370,
			y = 150,
			width = 75,
			height = 75,
			offsetX = 0,
			offsetY = 0,
		},

		field =
		{
			x = { 0, 360 },
			y = { 130, 210 }, --{ 120, 175 },
		},
		
		range_mid =
		{
			x = { 140, 270 },
			y = { 100, 220 },
		},
		
		range_long =
		{
			x = { 40, 140 },
			y = { 100, 220 },
		},

		wall =
		{
			x = { 80, 180 },
			y = 320,
			offset =
			{
				{ 75, -150 },
				{ 25, 25 },
			},
		},
		
		shield =
		{
			x = 300,
			y = 65,
		},
		
		speedline =
		{
			x = 0,
			y = 102,
		},
	},	

	-- D-Scene #5 @ Night
	lava_night =
	{
		backdrop = "scene_lava_night_background",
		layer_pre = { "scene_lava_night_layer3", 0, 44,  DSCENE_LAYERS_SPEED[5][3] },		
		layer_mid = { "scene_lava_night_layer2", 0, 62, DSCENE_LAYERS_SPEED[5][2] },
		layer_post = { "scene_lava_night_layer1", 0, 220, DSCENE_LAYERS_SPEED[5][1] },

		decorator =
		{
			DECO_TYPE_FIREPILLAR,
			{ "scene_lava_explosion_night" },
			{ 2500, 6000, 1, 1 },
		},
		
		castle =
		{
			x = 370,
			y = 150,
			width = 75,
			height = 75,
			offsetX = 0,
			offsetY = 0,
		},

		field =
		{
			x = { 0, 360 },
			y = { 130, 210 }, --{ 120, 175 },
		},
		
		range_mid =
		{
			x = { 140, 270 },
			y = { 100, 220 },
		},
		
		range_long =
		{
			x = { 40, 140 },
			y = { 100, 220 },
		},

		wall =
		{
			x = { 80, 180 },
			y = 320,
			offset =
			{
				{ 75, -150 },
				{ 25, 25 },
			},
		},
		
		shield =
		{
			x = 300,
			y = 65,
		},
		
		speedline =
		{
			x = 0,
			y = 102,
		},
	},	
};



--==============================================================================
-- Game Levels
--==============================================================================
LEVEL_SCENE_NAME = 1;
LEVEL_ENEMY_LAUNCHER = 2;
LEVEL_ENEMY_EVENTS = 3;
LEVEL_ENEMY_RANDSET = 4;
LEVEL_PRELOAD_TEXTURES = 5;
LEVEL_BOSS_DATA = 6;

BOSS_TEMPLATE = 1;
BOSS_TEXTURE = 2;

NINJA_ENDLESS_GAME_LEVEL = {};

NINJA_ENDLESS_GAME_LEVEL[101] =
{
	{
		[LEVEL_SCENE_NAME] = "dojo",
		[LEVEL_ENEMY_LAUNCHER] = ENEMY_LEVELSET_1,
		[LEVEL_ENEMY_EVENTS] = ENEMY_EVENTS_1,
		[LEVEL_ENEMY_RANDSET] = ENEMY_RAND_POOL_1,
		[LEVEL_PRELOAD_TEXTURES] =
		{
			"innocent.png",
			"enemy_set1.png",
		},
	},

	{
		[LEVEL_SCENE_NAME] = "dojo",
		[LEVEL_ENEMY_LAUNCHER] = ENEMY_LEVELSET_1,
		[LEVEL_ENEMY_EVENTS] = ENEMY_EVENTS_1,
		[LEVEL_ENEMY_RANDSET] = ENEMY_RAND_POOL_1,
		[LEVEL_PRELOAD_TEXTURES] =
		{
			"innocent.png",
			"enemy_set1.png",
		},
	},
};

NINJA_ENDLESS_GAME_LEVEL[1] =
{
	{
		[LEVEL_SCENE_NAME] = "city_day",
		[LEVEL_ENEMY_LAUNCHER] = ENEMY_LEVELSET_1,		
		[LEVEL_ENEMY_EVENTS] = ENEMY_EVENTS_1,
		[LEVEL_ENEMY_RANDSET] = ENEMY_RAND_POOL_1,
		[LEVEL_PRELOAD_TEXTURES] =
		{
			"innocent.png",
			"enemy_set1.png",
			"enemy_sp1.png",
		},
	},

	{
		[LEVEL_SCENE_NAME] = "city_night",
		[LEVEL_ENEMY_LAUNCHER] = ENEMY_LEVELSET_1,
		[LEVEL_ENEMY_EVENTS] = SHADOW_ENEMY_EVENTS_1,
		[LEVEL_ENEMY_RANDSET] = ENEMY_RAND_POOL_1,
		[LEVEL_PRELOAD_TEXTURES] =
		{
			"innocent.png",
			"enemy_shadow.png",
			"enemy_set1.png",
			"enemy_sp1.png",
		},
		[LEVEL_BOSS_DATA] = { Boss_ShadowNinja, "boss_shadowninja.png" },
	},
};

NINJA_ENDLESS_GAME_LEVEL[2] =
{
	{
		[LEVEL_SCENE_NAME] = "battlefield_day",
		[LEVEL_ENEMY_LAUNCHER] = ENEMY_LEVELSET_2,
		[LEVEL_ENEMY_EVENTS] = ENEMY_EVENTS_2,
		[LEVEL_ENEMY_RANDSET] = ENEMY_RAND_POOL_2,
		[LEVEL_PRELOAD_TEXTURES] =
		{
			"innocent.png",
			"enemy_set2.png",
			"enemy_sp1.png",
			"enemy_sp2.png",
		},
	},

	{
		[LEVEL_SCENE_NAME] = "battlefield_night",
		[LEVEL_ENEMY_LAUNCHER] = ENEMY_LEVELSET_2,
		[LEVEL_ENEMY_EVENTS] = SHADOW_ENEMY_EVENTS_2,
		[LEVEL_ENEMY_RANDSET] = ENEMY_RAND_POOL_2,
		[LEVEL_PRELOAD_TEXTURES] =
		{
			"innocent.png",
			"enemy_shadow.png",
			"enemy_set2.png",
			"enemy_sp1.png",
			"enemy_sp2.png",
		},
		[LEVEL_BOSS_DATA] = { Boss_Akudaikan, "boss_akudaikan.png" },
	},
};

NINJA_ENDLESS_GAME_LEVEL[3] =
{
	{
		[LEVEL_SCENE_NAME] = "bamboo_day",
		[LEVEL_ENEMY_LAUNCHER] = ENEMY_LEVELSET_3,
		[LEVEL_ENEMY_EVENTS] = ENEMY_EVENTS_3,
		[LEVEL_ENEMY_RANDSET] = ENEMY_RAND_POOL_3,
		[LEVEL_PRELOAD_TEXTURES] =
		{
			"innocent.png",
			"enemy_set3.png",
			"enemy_sp2.png",
			"enemy_sp3.png",
		},
	},

	{
		[LEVEL_SCENE_NAME] = "bamboo_night",
		[LEVEL_ENEMY_LAUNCHER] = ENEMY_LEVELSET_3,
		[LEVEL_ENEMY_EVENTS] = SHADOW_ENEMY_EVENTS_3,
		[LEVEL_ENEMY_RANDSET] = ENEMY_RAND_POOL_3,
		[LEVEL_PRELOAD_TEXTURES] =
		{
			"innocent.png",
			"enemy_shadow.png",
			"enemy_set3.png",
			"enemy_sp2.png",
			"enemy_sp3.png",
		},
		[LEVEL_BOSS_DATA] = { Boss_GhostKing, "boss_ghostking.png" },
	},
};

NINJA_ENDLESS_GAME_LEVEL[4] =
{
	{
		[LEVEL_SCENE_NAME] = "forest_day",
		[LEVEL_ENEMY_LAUNCHER] = ENEMY_LEVELSET_4,
		[LEVEL_ENEMY_EVENTS] = ENEMY_EVENTS_4,
		[LEVEL_ENEMY_RANDSET] = ENEMY_RAND_POOL_4,
		[LEVEL_PRELOAD_TEXTURES] =
		{
			"innocent.png",
			"enemy_set4.png",
			"enemy_sp3.png",
			"enemy_sp4.png",
		},
	},

	{
		[LEVEL_SCENE_NAME] = "forest_night",
		[LEVEL_ENEMY_LAUNCHER] = ENEMY_LEVELSET_4,
		[LEVEL_ENEMY_EVENTS] = SHADOW_ENEMY_EVENTS_4,
		[LEVEL_ENEMY_RANDSET] = ENEMY_RAND_POOL_4,
		[LEVEL_PRELOAD_TEXTURES] =
		{
			"innocent.png",
			"enemy_shadow.png",
			"enemy_set4.png",
			"enemy_sp3.png",
			"enemy_sp4.png",
		},
		[LEVEL_BOSS_DATA] = { Boss_GiantSpider, "boss_giantspider.png" },
	},
};

NINJA_ENDLESS_GAME_LEVEL[5] =
{
	{
		[LEVEL_SCENE_NAME] = "lava_day",
		[LEVEL_ENEMY_LAUNCHER] = ENEMY_LEVELSET_5,
		[LEVEL_ENEMY_EVENTS] = ENEMY_EVENTS_5,
		[LEVEL_ENEMY_RANDSET] = ENEMY_RAND_POOL_5,
		[LEVEL_PRELOAD_TEXTURES] =
		{
			"innocent.png",
			"enemy_set5.png",
			"enemy_sp4.png",
		},
	},

	{
		[LEVEL_SCENE_NAME] = "lava_night",
		[LEVEL_ENEMY_LAUNCHER] = ENEMY_LEVELSET_5,
		[LEVEL_ENEMY_EVENTS] = SHADOW_ENEMY_EVENTS_5,
		[LEVEL_ENEMY_RANDSET] = ENEMY_RAND_POOL_5,
		[LEVEL_PRELOAD_TEXTURES] =
		{
			"innocent.png",
			"enemy_shadow.png",
			"enemy_set5.png",
			"enemy_sp4.png",
		},
		[LEVEL_BOSS_DATA] = { Boss_DevilSamurai, "boss_devilsamurai.png" },
	},
};
