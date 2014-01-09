
GameObjectTemplate
{
	class = "Castle",
	reloadable = true,
	preLayer = true,

	components =
	{
		{
			class = "Transform",
		},

        {
            class = "PuzzleAnimation",
			anim = "avatar_ninjagirl_move",
        },

		{
			class = "CircleBound",
            autoSize = true,
--[[			
			debug = true,
--]]			
		},

		{
			class = "StateMachine",
			states = CastleStates,
		},

        {
            class = "Timer",
            duration = 1000,
        },

        {
            class = "LinearMotion",
            velocity = 200,
        },
		
		{
			class = "Attribute",
		},
	},
};

GameObjectTemplate
{
	class = "StaticBackdrop",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},

		{
			class = "PuzzleSprite",
			image = "scene_city_daytime_background",
			--blendMode = GraphicsEngine.BLEND_FADEOUT,
		},
	},
};

GameObjectTemplate
{
	class = "DynamicBackdrop",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},
		
		{
			class = "PuzzleCompositeSprite",
			images =
			{
				{ "scene_city_daytime_layer2", true },
				{ "scene_city_daytime_layer2", true, SCENE_LAYER_SIZE, 0 },
			},
			--blendMode = GraphicsEngine.BLEND_FADEOUT,
		},
		
		{
			class = "TimeBasedInterpolator",
		},
		
		{
			class = "Attribute",
		},
	},
};

GameObjectTemplate
{
	class = "SceneDecorator",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},

        {
            class = "PuzzleAnimation",
            anim = "scene_city_daytime_leaf",
        },
        
        {
            class = "LinearMotion",
            velocity = 150,
        },

        {
            class = "StateMachine",
            states = SceneDecoratorStates,
        },
        
        {
            class = "TimeBasedInterpolator",
        },
    },
};

GameObjectTemplate
{
	class = "SceneDecoratorLauncher",

	components =
	{
        {
            class = "StateMachine",
            states = SceneDecoratorLauncherStates,
        },
		
		{
			class = "Timer",
			duration = 1000,
		},
	},
};

GameObjectTemplate
{
	class = "RealShaker",

	components =
	{
		{
			class = "Transform",
		},

		{
			class = "Shaker",
			minValue = 5,
			maxValue = 10,
			count = 4,
			velocity = 300,
		},
	},
};

GameObjectTemplate
{
	class = "BackdropField",

	components =
	{
		{
			class = "Transform",
		},

		{
			class = "RectangleShape",
			width = 100,
			height = 100,
			color = { 0, 0.4, 0, ALPHA_QUARTER },
		},
	},
};

GameObjectTemplate
{
	class = "Blade",
	reloadable = true,
	indie = true,

	components =
	{
		{
			class = "Transform",
		},

		{
            class = "PuzzleAnimation",
			anim = "we_katana_blue",
		},

		{
			class = "CircleBound",
            radius = BLADE_RADIUS,
			indie = true,
--[[
			debug = true,
--]]
		},

		{
			class = "StateMachine",
			states = BladeStates,
			initial = "paused",
		},
		
		{
			class = "Timer",
			duration = BLADE_COOLDOWN_DURATION,
		},

		{
			class = "Attribute",
		},
	},
};

GameObjectTemplate
{
	class = "CriticalEffect",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},

		{
            class = "PuzzleAnimation",
			anim = "effect_critical",
		},
	},
};

GameObjectTemplate
{
	class = "Clock",

	components =
	{
        {
            class = "Timer",
            duration = 1000,
        },
	},
};

GameObjectTemplate
{
	class = "EnemyLauncher",

	components =
	{
        {
            class = "StateMachine",
            states = EnemyLauncherStates,
            initial = "inactive",
        },

        {
            class = "Timer",
            duration = 1000,
        },
		
		{
			class = "Attribute",
		},
	},
};

GameObjectTemplate
{
	class = "EnemyLifebar",

	components =
	{
		{
			class = "Transform",
		},
		
		{
			class = "CompositeShape",
			indie = true,
			shapes =
			{
				{
					COMPOSITESHAPE_RECT, ENEMY_BAR_SIZE[1] + ENEMY_BAR_FRAME * 2, ENEMY_BAR_SIZE[2] + ENEMY_BAR_FRAME * 2,
					0, 0, 0, ALPHA_MAX,
					ENEMY_BAR_OFFSET[1] - ENEMY_BAR_FRAME, ENEMY_BAR_OFFSET[2] - ENEMY_BAR_FRAME, --true
				},

				{
					COMPOSITESHAPE_RECT, ENEMY_BAR_SIZE[1], ENEMY_BAR_SIZE[2],
					0.39, 0, 0, ALPHA_MAX,
					ENEMY_BAR_OFFSET[1], ENEMY_BAR_OFFSET[2], --true
				},

				{
					COMPOSITESHAPE_RECT, ENEMY_BAR_SIZE[1], ENEMY_BAR_SIZE[2],
					1, 0, 0, ALPHA_MAX,
					ENEMY_BAR_OFFSET[1], ENEMY_BAR_OFFSET[2], --true
				},
			},
		},

        {
            class = "StateMachine",
            states = EnemyLifebarStates,
        },

        {
            class = "Timer",
            duration = 500,
        },
	},
};

GameObjectTemplate
{
	class = "Enemy",
	postLayer = true,

	components =
	{
		{
			class = "Transform",
		},

        {
            class = "PuzzleSpriteGroup",
            sprites =
            {
                { name="PuzzleSprite", image="enemy_blackninja_wounded_front_01", enable=false },
                { name="PuzzleSprite", image="enemy_blackninja_wounded_front_01", enable=false },
                { name="PuzzleAnimation", anim="enemy_blackninja_move", sync=true },
            },
        },

		{
			class = "CircleBound",
            autoSize = true,
--[[
			debug = true,
--]]
		},
        
        {
            class = "LinearMotion",
            velocity = 100,
        },

        {
            class = "StateMachine",
            states = EnemyStates,
            initial = "inactive",
        },

        {
            class = "TimeBasedInterpolator",
        },

        {
            class = "Timer",
            duration = 3000,
        },

		{
			class = "Attribute",
		},
	},
};

GameObjectTemplate
{
	class = "EnemyShadow",
	reloadable = true,
	
	components =
	{
		{
			class = "Transform",
		},

        {
            class = "PuzzleSprite",
			image = "effect_shadow_01",
        },
	},
};

GameObjectTemplate
{
	class = "EnemyDrop",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},
        
        {
            class = "PuzzleAnimation",
			anim = "coin",
        },

        {
			class = "CircleBound",
            autoSize = true,
			--debug = SHOW_DEBUG_BOUND,
		},
        
        {
            class = "StateMachine",
            states = CoinStates,
        },

        {
            class = "TimeBasedInterpolator",
        },

        {
            class = "LinearMotion",
            velocity = COIN_BOUNCE_VELOCITY,
        },

        {
            class = "Attribute",
        },
    },
};

GameObjectTemplate
{
	class = "EnemyBullet",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
        },

        {
            class = "PuzzleAnimation",
            anim = "bullet_shuriken",
			animating = true,
        },
        
        {
            class = "LinearMotion",
            velocity = 300,
        },

		{
			class = "CircleBound",
            autoSize = true,
--[[
			debug = true,
--]]			
		},

        {
            class = "StateMachine",
            states = BulletStates,
        },
        
        {
            class = "Attribute",
        },
    },
};

GameObjectTemplate
{
	class = "EnemyEffect",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},

        {
            class = "PuzzleAnimation",
			anim = "effect_explosion01",
        },

        {
            class = "StateMachine",
            states = EnemyEffectStates,
        },
		
		{
			class = "Attribute",
		},
	},
};

GameObjectTemplate
{
	class = "EnemyEnchant",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},

        {
            class = "PuzzleAnimation",
			anim = "effect_stun",
        },
		
		{
			class = "StateMachine",
			states = EnemyEnchantStates,
			initial = "inactive",
		},

		{
			class = "Timer",
			duration = 1000,
		},

        {
            class = "Attribute",
        },
	},
};

GameObjectTemplate
{
	class = "BackdropShade",

	components =
	{
		{
			class = "Transform",
		},

		{
			class = "RectangleShape",
			width = APP_WIDTH,
			height = APP_HEIGHT,
			color = { 0.1, 0.1, 0.1, ALPHA_THREEQUARTER },
		},				
	},
};

GameObjectTemplate
{
	class = "ScrollEffectObject",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},

		{
            class = "PuzzleAnimation",
			anim = "scrolleffect_fireball",
		},
		
		{
			class = "LinearMotion",
			velocity = 400,
		},

		{
			class = "TimeBasedInterpolator",
		},
	},
};

GameObjectTemplate
{
	class = "CastleShield",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},

		{
            class = "PuzzleAnimation",
			anim = "scrolleffect_energyshield",
			animating = true,
			--blendMode = GraphicsEngine.BLEND_FADEOUT,
		},

		{
			class = "CircleBound",
            autoSize = true,
			--debug = SHOW_DEBUG_BOUND,
		},
		
		{
			class = "StateMachine",
			states = CastleShieldStates,
			initial = "inactive",
		},
		
		{
			class = "TimeBasedInterpolator"
		},
	},
};

GameObjectTemplate
{
	class = "CastleComboEffect",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},

		{
            class = "PuzzleAnimation",
			anim = "effect_combo_lv1",
			animating = true,
		},
		
		{
			class = "StateMachine",
			states = CastleComboEffectStates,
		},
		
		{
			class = "TimeBasedInterpolator"
		},
		
		{
			class = "Fade",
		},
	},
};

GameObjectTemplate
{
	class = "CastleComboText",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},

		{
            class = "PuzzleSprite",
			image = "ui_combotext_lv1",
			blendMode = GraphicsEngine.BLEND_FADEOUT,
		},
		
		{
			class = "StateMachine",
			states = CastleComboTextStates,
		},
		
		{
			class = "LinearMotion",
			velocity = 150,
		},
		
		{
			class = "Timer",
			duration = 2500,
		},
	},
};

GameObjectTemplate
{
	class = "CastleScrollClock",

	components =
	{
		{
            class = "Timer",
			duration = 100,
		},
		
		{
			class = "StateMachine",
			states = CastleScrollClock,
			initial = "inactive",
		},
	},
};


GameObjectTemplate
{
	class = "SpeedEffect",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},
		
		{
			class = "PuzzleSpriteGroup",
            sprites =
            {
                { name="PuzzleAnimation", anim="itemeffect_speed", animating=true, x=0, y=72*APP_UNIT_Y },
                { name="PuzzleAnimation", anim="itemeffect_speedline_up", animating=true, x=0, y=0 },
                { name="PuzzleAnimation", anim="itemeffect_speedline_down", animating=true, x=0, y=266*APP_UNIT_Y },
			},
		},
	},
};


GameObjectTemplate
{
	class = "ReviveEffect",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},
		
		{
			class = "PuzzleAnimation",
			anim = "effect_revive",
		},
	},
};


GameObjectTemplate
{
	class = "WarningEffect",
	reloadable = true,

	components =
	{
		{
			class = "Transform",
		},
		
		{
			class = "PuzzleAnimation",
			anim = "ui_ingame_warning",
		},

		{
			class = "TimeBasedInterpolator",
		},
	},
};


GameObjectTemplate
{
	class = "CastleHurtEffect",

	components =
	{
		{
			class = "Transform",
		},

		{
			class = "RectangleShape",
			width = APP_WIDTH,
			height = APP_HEIGHT,
			color = { 0.7, 0, 0, ALPHA_QUARTER },
		},
	},
};

--[[
GameObjectTemplate
{
	class = "WeaponSlot",

	components =
	{
		{
			class = "Transform",
		},
		
		{
			class = "PuzzleSprite",
			image = "ui_itemicon_weapon_katana01",
		},

        {
			class = "RectangleBound",
			width = 60,
			height = 60,
			--autoSize = true,
			--debug = true,
		},
		
		{
			class = "StateMachine",
			states = WeaponSlotStates,
		},
		
		{
			class = "TimeBasedInterpolator",
		},
	},
};
--]]

GameObjectTemplate
{
	class = "WeaponInv",

	components =
	{
		{
			class = "Transform",
			x = 0,
			y = 245,
		},

        {
			class = "RectangleBound",
			width = 140 * APP_SCALE_FACTOR,
			height = 90 * APP_SCALE_FACTOR,
		},
--[[ @Weapon Slot Range
        {
			class = "RectangleShape",
			width = 140 * APP_SCALE_FACTOR,
			height = 90 * APP_SCALE_FACTOR,
			color = { 1, 0, 0, 0.7 },
		},
--]]	
	},
};

GameObjectTemplate
{
	class = "BossController",

	components =
	{
		{
			class = "Transform",
		},
		
		{
			class = "StateMachine",
			states = BossControllerStates,
			initial = "inactive",
		},

		{
			class = "TimeBasedInterpolator",
		},
		
		{
			class = "Timer",
			duration = 750,
		},
	},
};
