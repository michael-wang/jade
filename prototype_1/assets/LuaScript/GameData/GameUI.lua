--***********************************************************************
-- @file GameUI.lua
--***********************************************************************

-------------------------------------------------------------------------
-- UI Widgets
-------------------------------------------------------------------------
if (IS_DEVICE_IPAD or IS_PLATFORM_ANDROID) then
	UI_FULLSCREEN_HEIGHT = 600;
else
	UI_FULLSCREEN_HEIGHT = 270;
end

UI_MOTION_VELOCITY = 800;--800;
UI_KOBAN_POS = { 5, 5 };	--UI_KOBAN_POS = { 25, 5 };
UI_COIN_POS = { 115, 5 };	--UI_COIN_POS = { 115, 5 };

UI_BUTTON_POS = { 420, 360, 300, 230 };

UI_INGAME_COIN_ORIGIN = { 310, 5 };
UI_INGAME_COIN_POS = { 300, 5 };
UI_INGAME_JADE_POS = { 17, 55 };
UI_INGAME_ENERGYBAR_POS = { 5 * APP_SCALE_FACTOR, 25 * APP_SCALE_FACTOR };
--UI_INGAME_ENERGYBAR_TARGET = { 10 * APP_SCALE_FACTOR, 30 * APP_SCALE_FACTOR };
UI_INGAME_ENERGYBAR_TARGET = { 10 * APP_SCALE_FACTOR / APP_UNIT_X, 30 * APP_SCALE_FACTOR / APP_UNIT_Y };

UI_INGAME_MEDAL_POS =
{
	{ 200, 0 },
	{ 225, 0 },
	{ 250, 0 },
};

UI_KOBAN_PREFIX = "koban";
UI_COIN_PREFIX = "coin";

UI_WEAPON_VELOCITY = 180;
UI_WEAPON_VELOCITY_MOD = 270;

UI_WEAPON_POS =
{
	{ 35, 270 },
	{ 10, 255 },
	{ 65, 255 },
};

UI_SCROLL_POS =
{
	{ 420, 270 },
	{ 350, 270 },
};

UI_BAR_NUM_OFFSET = { 35, 9 };


UW_WEAPON_1 =
{
	class = "PuzzlePicture",
	name = "Weapon1",
	x = UI_WEAPON_POS[1][1],
	y = UI_WEAPON_POS[1][2],
	doUpdate = true,
	
	components =
	{
		{
			class = "PuzzleCompositeSprite",
			images = 
			{ 
				{ "ui_itemicon_weapon_katana01", true, },
				{ "ui_cooldown", false, },
			},
		},

		{
			class = "LinearMotion",
			velocity = UI_WEAPON_VELOCITY,
		},
	},
};

UW_WEAPON_2 =
{
	class = "PuzzlePicture",
	name = "Weapon2",
	x = UI_WEAPON_POS[2][1],
	y = UI_WEAPON_POS[2][2],
	doUpdate = true,
	
	components =
	{
		{
			class = "PuzzleCompositeSprite",
			images = 
			{ 
				{ "ui_itemicon_weapon_blade01", true, },
				{ "ui_cooldown", false, },
			},
		},

		{
			class = "LinearMotion",
			velocity = UI_WEAPON_VELOCITY,
		},
	},
};

UW_WEAPON_3 =
{
	class = "PuzzlePicture",
	name = "Weapon3",
	x = UI_WEAPON_POS[3][1],
	y = UI_WEAPON_POS[3][2],
	doUpdate = true,
	
	components =
	{
		{
			class = "PuzzleCompositeSprite",
			images = 
			{ 
				{ "ui_itemicon_weapon_yari01", true, },
				{ "ui_cooldown", false, },
			},
		},

		{
			class = "LinearMotion",
			velocity = UI_WEAPON_VELOCITY,
		},
	},
};

UW_KOBAN_NUM =
{
	class = "PuzzleNumber",
	name = "KobanNum",
	x = UI_KOBAN_POS[1],
	y = UI_KOBAN_POS[2],
	numberOffset = -1,
	prefix = UI_KOBAN_PREFIX,
	doUpdate = true,
	
	components = 
	{
		{
			class = "PuzzleSprite",
			image = "ui_money_0",
		},

		{
			class = "TimeBasedInterpolator",
		},
		
		{
			class = "LinearMotion",
			velocity = 250,
		},
	},
};

UW_COIN_NUM =
{
	class = "PuzzleNumber",
	name = "CoinNum",
	x = UI_COIN_POS[1],
	y = UI_COIN_POS[2],
	numberOffset = -1,
	prefix = UI_COIN_PREFIX,
	doUpdate = true,
	
	components = 
	{
		{
			class = "PuzzleSprite",
			image = "ui_money_0",
		},

		{
			class = "TimeBasedInterpolator",
		},
		
		{
			class = "LinearMotion",
			velocity = 250,
		},
	},
};

UW_LIFEBAR =
{
	class = "PuzzleProgressbar",
	name = "LifeBar",
	x = 5 * APP_SCALE_FACTOR,
	y = 2 * APP_SCALE_FACTOR,
	maxValue = 100,
	value = 100,
	doUpdate = true,
	indie = true,

	components =
	{
		{
			class = "PuzzleCompositeSprite",
			primary = 2,
			images = 
			{ 
				{ "ui_lifebar_base", true },
				{ "ui_lifebar_life", true, 20 * APP_SCALE_FACTOR, 9 * APP_SCALE_FACTOR },
			},
		},

		{
			class = "SpeedBasedInterpolator",
		},
	},
};

UW_LIFEBAR_NUM =
{
	class = "PuzzleNumber",
	name = "LifeBarNumber",
	x = 40 * APP_SCALE_FACTOR,
	y = 11 * APP_SCALE_FACTOR,
	value = 100,
	maxValue = 100,
	signSlash = true,
	indie = true,
	
	components = 
	{
		{
			class = "PuzzleSprite",
			image = "ui_lifebar_0",
		},
	},
};
	
UW_ENERGYBAR =	
{
	class = "PuzzleProgressbar",
	name = "EnergyBar",
	x = UI_INGAME_ENERGYBAR_POS[1],
	y = UI_INGAME_ENERGYBAR_POS[2],
	maxValue = 100,
	value = 100,
	doUpdate = true,
	indie = true,

	components =
	{
		{
			class = "PuzzleCompositeSprite",
			primary = 2,
			images = 
			{ 
				{ "ui_energybar_base", true },
				{ "ui_energybar_energy", true, 20 * APP_SCALE_FACTOR, 9 * APP_SCALE_FACTOR },
			},
		},

		{
			class = "SpeedBasedInterpolator",
		},
   },
};

UW_ENERGYBAR_NUM =
{
	class = "PuzzleNumber",
	name = "EnergyBarNumber",
	x = 40 * APP_SCALE_FACTOR,
	y = 34 * APP_SCALE_FACTOR,
	value = 100,
	maxValue = 100,
	signSlash = true,
	indie = true,
	
	components = 
	{
		{
			class = "PuzzleSprite",
			image = "ui_lifebar_0",
		},
	},
};

UW_SHOP_BUT =
{
	class = "PuzzleButton",
	name = "SHOP",
	x = UI_BUTTON_POS[2],
	y = 0,
	--doUpdate = true,
	
	onMouseUp = function(x, y)
		StageManager:ChangeStage("EndlessMapCloseDoor", "ShopOpenDoor");
		AudioManager:PlaySfx(SFX_UI_BUTTON_1);
	end,
	
	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_button_shop",
		},
		
		{
			class = "TimeBasedInterpolator",
		},
	},	
};

UW_DAILY_BUT =
{
	class = "PuzzleButton",
	name = "Challenge",
	x = UI_BUTTON_POS[3],
	y = 0,
	doUpdate = true,
	
	onMouseUp = function(x, y)
		LevelManager:EnterChallengeMap();
	end,

	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_button_daily",
		},

		{
			class = "TimeBasedInterpolator",
		},
	},
};



-------------------------------------------------------------------------
-- UI Frames
-------------------------------------------------------------------------

GameUITemplate
{
	name = "MainEntry",
	reloadable = true,
	textures = { "ui_mainlogo.png", "ui_mainwidget.png",
				 "ui_mainmenu.png", "ui_mainchar.png", "ui_mainmenu_night.png", "ui_mainchar_night.png" },
	
    components =
    {
        {
            class = "PuzzleSprite",
			image = "ui_logo_background",
        },
		
		{
			class = "LinearMotion",
			velocity = UI_MOTION_VELOCITY,
		}
    },

	widgets =
	{
        {
			class = "PuzzlePicture",
			name = "Char1",
			x = 0,
			y = 0,
			doUpdate = true,
			
			components =
			{
				{
					class = "PuzzleAnimation",
					anim = "ui_logo_char1_enter",
				},
			},
		},

        {
			class = "PuzzlePicture",
			name = "Char2",
			x = 44,
			y = 254,
			doUpdate = true,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_logo_char2",
				},
				
				{
					class = "LinearMotion",
					velocity = 800,
				},
			},
		},

        {
			class = "PuzzlePicture",
			name = "Roof",
			x = 0,
			y = 254,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_logo_roof",
				},
			},
		},

        {
			class = "PuzzlePicture",
			name = "Char3",
			x = 480,
			y = 114,
			doUpdate = true,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_logo_char3",
				},
				
				{
					class = "LinearMotion",
					velocity = 1200,
				},
			},
		},

        {
			class = "PuzzlePicture",
			name = "Logo",
			x = 260,
			y = 6,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_logo_logo",
				},
			},
		},

        {
			class = "PuzzleButton",
			name = "PlayFullscreen",
			x = 0,
			y = 0,
			width = SCREEN_UNIT_X,
			height = UI_FULLSCREEN_HEIGHT,
			transparent = true,
			
            onMouseUp = function()
				EnterEndlessMap();
			end,
		},

        {
			class = "PuzzleButton",
			name = "Play",
			--x = 184,
			y = 206,
			doUpdate = true,
			--indie = true,
			axis = AXIS_X_CENTER,
			
            onMouseUp = function()
				EnterEndlessMap();
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_mainmenu_play",
				},
				
				{
					class = "StateMachine",
					states = UIPlayButtonStates,
				},
				
				{
					class = "TimeBasedInterpolator",
				},
				
				{
					class = "Fade",
				},
			},
		},
		
		{
			class = "PuzzleCheckButton",
			name = "Bgm",
			x = 6,
			y = 279,

            onStateChange = function(state)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				AudioManager:ToggleBgm(state, true);
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_mainmenu_button_music",
				},
			},
		},
		
		{
			class = "PuzzleCheckButton",
			name = "Sfx",
			x = 59,
			y = 279,

            onStateChange = function(state)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				AudioManager:ToggleSfx(state, true);
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_mainmenu_button_sound",
				},
			},
		},
		
		{
			class = "PuzzleButton",
			name = "Hand",
			x = 112,
			y = 279,
			doUpdate = true,

            onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				BladeManager:ToggleHandsettings();
			end,
			
			components =
			{
				{
					class = "PuzzleCompositeSprite",
					images =
					{
						{ "ui_mainmenu_handset1", true, 0, 0 },
						{ "ui_logo_hand1", false, -30, -25 },
					},
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
				
				{
					class = "StateMachine",
					states = UIHandStates,
				},
				
				{
					class = "Timer",
					duration = 2500,
				},

				{
					class = "TimeBasedInterpolator",
				},
			},
		},
		
		{
			class = "PuzzleCheckButton",
			name = "iCloud",
			x = 380 - 53,
			y = 279,

            onStateChange = function(state)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				if (state == true) then
					ShowiCloudChoices();
				else
					EnableiCloudSync(false);
				end
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_mainmenu_icloud",
				},
			},
		},
				
        {
			class = "PuzzlePicture",
			name = "GearBackdrop",
			x = 213 - 53,
			y = 277,
			hide = true,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_mainmenu_gearbackground",
				},
			},
		},
		
        {
			class = "PuzzleButton",
			name = "Leaderboard",
			x = 380 - 53,
			y = 280,
			hide = true,
			
            onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				ShowLeaderboard();
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_mainmenu_gamecenter",
				},
			},
		},		
		
        {
			class = "PuzzleButton",
			name = "Achievement",
			x = 326 - 53,
			y = 280,
			hide = true,
			
            onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				ShowAchievements();
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_mainmenu_achievement",
				},
			},
		},		
		
        {
			class = "PuzzleButton",
			name = "Twitter",
			x = 272 - 53,
			y = 280,
			hide = true,
			
            onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				if (GameKit.GetUserLanguage() == "zh-Hans") then
					OpenSelfSinaWeibo();
				else
					OpenSelfTwitter();
				end
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_mainmenu_twitter",
				},
			},
		},

        {
			class = "PuzzleButton",
			name = "History",
			x = 218 - 53,
			y = 280,
			hide = true,
			
            onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				UIManager:GetWidgetComponent("MainEntry", "Play", "StateMachine"):ChangeState("inactive");
				UpdateHistoryUI();
				StageManager:ChangeStageWithMotion("MainEntry", "History", 0, -APP_HEIGHT);
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_mainmenu_history",
				},
			},
		},		

        {
			class = "PuzzleButton",
			name = "Gear",
			x = 434 - 53,
			y = 280,
			doUpdate = true,
			
            onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				ToggleMainMenuGears();
			end,
			
			components =
			{
				{
					class = "PuzzleAnimation",
					anim = "ui_mainmenu_gear_off",
					animating = true,
				},
			},
		},

        {
			class = "PuzzleButton",
			name = "Info",
			x = 434,
			y = 280,
			
            onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				UIManager:GetWidgetComponent("MainEntry", "Play", "StateMachine"):ChangeState("inactive");
				StageManager:ChangeStageWithMotion("MainEntry", "Info", 0, -APP_HEIGHT);
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_mainmenu_info",
				},
			},
		},
--[[ @DEBUG
        {
			class = "PuzzleButton",
			name = "test",
			--transparent = true,
			onMouseUp = function()
				AudioManager:PlaySfx(SFX_UI_IRON_DOOR_OPEN);
				StageManager:ChangeStage("Legion");
				--SaveToCloud();
				
				--GameKit.ShowInterstitial("Default");
				--UpdateAchievement(ACH_NINJA_GRANNY_SPOT);

				--log("GC: "..tostring(GameKit.HasGameCenterAuthenticated()))
				--local obj = IAP_ITEM_CALLBACK[9101];
				--if (obj) then BuyProduct(obj[1], obj[2], true); end
			end,
		},
--]]
	},
	
	groups =
	{
		Buttons = { "Play", "Sfx", "Bgm", "Hand", "Gear", "Info", "iCloud" },
		GearOptions = { "GearBackdrop", "Leaderboard", "Achievement", "Twitter", "History" },
	},
};

-------------------------------------------------------------------------
UI_CREDIT_POS = { 30, 135 };
UI_CREDIT_PAGE_MAX = 7;

GameUITemplate
{
	name = "Info",
	x = 0,
	y = 320,
	reloadable = true,
	textures = { "ui_mapbk.png", "ui_credit.png", "ui_button.png" },

	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_map_background",
		},
		
		{
			class = "LinearMotion",
			velocity = UI_MOTION_VELOCITY,
		},
	},

	widgets =
	{
--[[ @DEBUG
		{
			class = "PuzzleButton",
			name = "3",
			x = 200,
			y = 300,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_button_back",
                },
			},

			onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_START_GAME);
				IOManager:SetValue(IO_CAT_CONTENT, "ChallengeMode", "Duration", 0);
			end,
		},
--]]		
--[[ @DEBUG
		{
			class = "PuzzleButton",
			name = "1",
			x = 0,
			y = 300,
			
			onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_START_GAME);
				ResetAchievements();

				local wp = IOManager:GetRecord(IO_CAT_HACK, "Weapon");
				wp[1] = 1;
				wp[2] = 1;
				wp[3] = 1;

				local mo = IOManager:GetRecord(IO_CAT_HACK, "Money");
				mo["Koban"] = 10;
				mo["Coin"] = 200;
				--mo["Koban"] = 9000;
				--mo["Coin"] = 900000;
				MoneyManager:Create();
				
				ShopManager:Create();
				
				LevelManager:LockAllLevels();
				local lv = IOManager:GetRecord(IO_CAT_CONTENT, "Level");
				lv["Normal"] = {};
				lv["Shadow"] = {};
--				IOManager:GetRecord(IO_CAT_CONTENT, "Tutorial")["Completed"] = false;
				IOManager:GetRecord(IO_CAT_CONTENT, "Tutorial")["Completed"] = true;
			    lv["Normal"][1] = { Distance = 3000, Coin = 0, Score = 100000, Medal=3, };
			end,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_button_back",
                },
			},
		},
--]]		
--[[ @DEBUG
		{
			class = "PuzzleButton",
			name = "2",
			x = 430,
			y = 300,
			
			onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_OBJECT_JADE);

				local wp = IOManager:GetRecord(IO_CAT_HACK, "Weapon");
				--wp[1] = 6;
				--wp[2] = 6;
				--wp[3] = 6;
				wp[1] = 10;
				wp[2] = 10;
				wp[3] = 10;

				local av = IOManager:GetRecord(IO_CAT_HACK, "Avatar");
				local al = IOManager:GetRecord(IO_CAT_HACK, "AvatarLv");
				local ae = IOManager:GetRecord(IO_CAT_HACK, "AvatarExp");
				for i = 1, AVATAR_MAX do
					av[i] = 1;
					ae[i] = 0;
					al[i] = 12;
				end
--				al[1] = 12;
				av[AVATAR_THIEF] = 1;
				ae[AVATAR_THIEF] = 1;
				al[AVATAR_THIEF] = 12;
--				IOManager:SetValue(IO_CAT_HACK, "Avatar", "Equip", AVATAR_THIEF);

				local ja = IOManager:GetRecord(IO_CAT_HACK, "Jade");
				for i = 1, 5 do -- JADE_MAX do
					ja[i] = 10;
				end
				ja[JADE_EFFECT_INNO_PROTECT] = 1;
				--IOManager:SetValue(IO_CAT_HACK, "Jade", "Equip", JADE_EFFECT_INNO_PROTECT);

				local sc = IOManager:GetRecord(IO_CAT_HACK, "Scroll");
				for i = 1, SCROLL_MAX do
					sc[i] = 1;
				end

				local mo = IOManager:GetRecord(IO_CAT_HACK, "Money");
				mo["Koban"] = 500;
				mo["Coin"] = 90000;--900000;
				MoneyManager:Create();

				ShopManager:Create();
				
				LevelManager:UnlockAllLevels();
			end,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_button_back",
                },
			},
		},
--]]	
		{
			class = "PuzzleButton",
			name = "BACK",
			x = UI_BUTTON_POS[1],
			y = 0,
			
			onMouseUp = function(x, y)
				StageManager:ChangeStageWithMotion("Info", "MainEntry", 0, APP_HEIGHT);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_button_back",
                },
			},
		},
		
		{
			class = "PuzzleButton",
			name = "Mail",
			x = UI_BUTTON_POS[2],
			y = 0,
			
			onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			    OpenMail(GameKit.GetLocalizedString("mail_title2"), true);
			end,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_button_mail",
                },
			},
		},		

		{
			class = "PuzzleButton",
			name = "Restore",
			x = UI_BUTTON_POS[3],
			y = 0,
			onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				GameKit.RestorePurchases();
			end,
			
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_button_restore",
                },
			},
		},

		{
			class = "PuzzlePicture",
			name = "Content",
			x = 0,
			y = 135,
			doUpdate = true,
			indie = true,
			--axis = AXIS_XY_CENTER,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "credit_01",
                },

				{
					class = "LinearMotion",
					velocity = 700 * APP_SCALE_FACTOR,
				},
				
				{
					class = "StateMachine",
					states = UICreditStates,
				},
				
				{
					class = "Timer",
					duration = 1000,
				},
				
				{
					class = "Attribute",
				},
			},
		},		
	},
};

-------------------------------------------------------------------------
if (IS_DEVICE_IPAD or IS_PLATFORM_ANDROID) then
	UI_HISTORY_ORIGIN = { 440, 135 };
	UI_HISTORY_OFFSET = 21.5;
else
	UI_HISTORY_ORIGIN = { 440, 137 };
	UI_HISTORY_OFFSET = 26;
end

GameUITemplate
{
	name = "History",
	reloadable = true,
	textures = { "ui_history.png", "ui_mapbk.png", "ui_mapbar.png", "ui_button.png" },

	onSwipe =
	{
		host =
		{
			"Content",
			GAME_STAT_SUBJECTS[1], GAME_STAT_SUBJECTS[2], GAME_STAT_SUBJECTS[3], GAME_STAT_SUBJECTS[4], GAME_STAT_SUBJECTS[5],
			GAME_STAT_SUBJECTS[6], GAME_STAT_SUBJECTS[7], GAME_STAT_SUBJECTS[8], GAME_STAT_SUBJECTS[9], GAME_STAT_SUBJECTS[10], 
			GAME_STAT_SUBJECTS[11], GAME_STAT_SUBJECTS[12], GAME_STAT_SUBJECTS[13], GAME_STAT_SUBJECTS[14],
		},
		size = { UI_HISTORY_OFFSET, UI_HISTORY_OFFSET },
		range = { 0, SCREEN_UNIT_X },
		offset = UI_HISTORY_OFFSET,
		bound = { -4 * UI_HISTORY_OFFSET, 6 * UI_HISTORY_OFFSET },
        axis = UI_SWIPE_AXIS_Y,
	},

	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_map_background",
		},
		
		{
			class = "LinearMotion",
			velocity = UI_MOTION_VELOCITY,
		}
	},

	widgets =
	{
		{
			class = "PuzzlePicture",
			name = "Content",
			x = 0,
			y = 130,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_history_info",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[1],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2],
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 1,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[2],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 1,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 2,
			postfix = "m",

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[3],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 2,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 3,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[4],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 3,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 4,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[5],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 4,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 5,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[6],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 5,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 6,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[7],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 6,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 7,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[8],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 7,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 8,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[9],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 8,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 9,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[10],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 9,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 10,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[11],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 10,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 11,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[12],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 11,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 12,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[13],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 12,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 13,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = GAME_STAT_SUBJECTS[14],
			x = UI_HISTORY_ORIGIN[1],
			y = UI_HISTORY_ORIGIN[2] + UI_HISTORY_OFFSET * 13,
			align = NUMBER_ALIGNMENT_RIGHT,
			value = 14,

			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
			},
		},

		{
			class = "PuzzlePicture",
			name = "Roof",
			x = 0,
			y = 0,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
                    images =
					{
						{ "ui_history_roof", true, 0, 0 },
						{ "ui_history_floor", true, 0, 290 },
					},
                },
			},
		},
		
		{
			class = "PuzzlePicture",
			name = "Title",
			y = 70,
			axis = AXIS_X_CENTER,
			--indie = true,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_history_title",
				},
			},
		},

		{
			class = "PuzzleButton",
			name = "BACK",
			x = UI_BUTTON_POS[1],
			y = 0,
			
			onMouseUp = function(x, y)
				StageManager:ChangeStageWithMotion("History", "MainEntry", 0, APP_HEIGHT);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_button_back",
                },
			},
		},
	},
};

-------------------------------------------------------------------------
UI_MAP_LEVEL_SIZE = { 216 * APP_SCALE_FACTOR, 196 * APP_SCALE_FACTOR };
--UI_MAP_LEVEL_OFFSET = 300 * APP_SCALE_FACTOR;
UI_MAP_LEVEL_OFFSET = 300 * APP_SCALE_FACTOR / APP_UNIT_X;

if (IS_DEVICE_IPAD or IS_PLATFORM_ANDROID) then
--	UI_MAP_LEVEL_ORIGIN = { (SCREEN_UNIT_X - UI_MAP_LEVEL_SIZE[1]) * 0.5 , 250 };
	UI_MAP_LEVEL_ORIGIN = { (SCREEN_UNIT_X - UI_MAP_LEVEL_SIZE[1]) * 0.5 / APP_UNIT_X, 300 / APP_UNIT_Y };
else
	UI_MAP_LEVEL_ORIGIN = { (SCREEN_UNIT_X - UI_MAP_LEVEL_SIZE[1]) * 0.5 / APP_UNIT_X, 110 / APP_UNIT_Y };
end

UM_LOCK = 2;
--UM_STARBK = 3;
--UM_STAR_1 = 4;
--UM_STAR_2 = 5;
--UM_STAR_3 = 6;

GameUITemplate
{
	name = "EndlessMap",
	reloadable = true,
	textures = { "ui_map.png", "ui_mapbar.png", "ui_mapbk.png", "ui_mapbk_night.png", "ui_button.png", "ui_ad.png", },

	onSwipe =
	{
		host = { "Map0", "Map1", "Map2", "Map3", "Map4", "Map5", "GameDifficulty", },
		size = { UI_MAP_LEVEL_SIZE[1], UI_MAP_LEVEL_SIZE[2] },
		range = { UI_MAP_LEVEL_ORIGIN[2] * APP_UNIT_Y, (UI_MAP_LEVEL_ORIGIN[2] + UI_MAP_LEVEL_SIZE[2]) * APP_UNIT_Y },
		offset = UI_MAP_LEVEL_OFFSET,
        axis = UI_SWIPE_AXIS_X,
		autoCentering = true,
		onArrival = ChangeMapTitle,
	},

	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_map_background",
		},

		{
			class = "LinearMotion",
			velocity = UI_MOTION_VELOCITY,
		},
		
		{
			class = "Attribute",
		},
	},

	widgets =
	{
		UW_SHOP_BUT,
---[[ @Challenge
		UW_DAILY_BUT,		
--]]
		{
			class = "PuzzleButton",
			name = "BACK",
			x = UI_BUTTON_POS[1],
			y = 0,
			
			onMouseUp = function(x, y)
				SwitchDayNightUI();

				StageManager:ChangeStageWithMotion("EndlessMap", "MainEntry", 0, APP_HEIGHT);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_button_back",
                },
			},
		},

		UW_COIN_NUM,
		UW_KOBAN_NUM,

		{
			class = "PuzzlePicture",
			name = "Title",
			--x = 132,
			y = 70,
			doUpdate = true,
			--indie = true,
			axis = AXIS_X_CENTER,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_map_title1",
				},
				
				{
					class = "TimeBasedInterpolator",
				},
			},
		},

        {
			class = "PuzzleButton",
			name = "Map0",
			x = UI_MAP_LEVEL_ORIGIN[1],
			y = UI_MAP_LEVEL_ORIGIN[2],
            doUpdate = true,
--			indie = true,

            onMouseUp = function(x, y)
				LevelManager:EnterTutorialMap();
			end,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_map_level0",
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
				
				{
					class = "TimeBasedInterpolator",
				},
            },
		},

        {
			class = "PuzzleButton",
			name = "Map1",
			x = UI_MAP_LEVEL_ORIGIN[1] + UI_MAP_LEVEL_OFFSET * 1,
			y = UI_MAP_LEVEL_ORIGIN[2],
            doUpdate = true,
--			indie = true,
			
            onMouseUp = function(x, y)
				LevelManager:EnterMap(1);
			end,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
                    images =
					{
						{ "ui_map_level1" },
						{ "ui_map_level_locked", false },
--						{ "ui_map_star1", false, 42, 176 },
--						{ "ui_map_star1", false, 66, 179 },
--						{ "ui_map_star1", false, 93, 179 },
--						{ "ui_map_star1", false, 121, 179 },
					},
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
				
				{
					class = "TimeBasedInterpolator",
				},
	        },
		},

        {
			class = "PuzzleButton",
			name = "Map2",
			x = UI_MAP_LEVEL_ORIGIN[1] + UI_MAP_LEVEL_OFFSET * 2,
			y = UI_MAP_LEVEL_ORIGIN[2],
            doUpdate = true,
--			indie = true,
			
            onMouseUp = function(x, y)
				LevelManager:EnterMap(2);
			end,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
                    images =
					{
						{ "ui_map_level2" },
						{ "ui_map_level_locked", false },
--						{ "ui_map_star1", false, 42, 176 },
--						{ "ui_map_star1", false, 66, 179 },
--						{ "ui_map_star1", false, 93, 179 },
--						{ "ui_map_star1", false, 121, 179 },
					},
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
				
				{
					class = "TimeBasedInterpolator",
				},
            },
		},

        {
			class = "PuzzleButton",
			name = "Map3",
			x = UI_MAP_LEVEL_ORIGIN[1] + UI_MAP_LEVEL_OFFSET * 3,
			y = UI_MAP_LEVEL_ORIGIN[2],
            doUpdate = true,
--			indie = true,
			
            onMouseUp = function(x, y)
				LevelManager:EnterMap(3);
			end,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
                    images =
					{
						{ "ui_map_level3" },
						{ "ui_map_level_locked", false },
--						{ "ui_map_star1", false, 42, 176 },
--						{ "ui_map_star1", false, 66, 179 },
--						{ "ui_map_star1", false, 93, 179 },
--						{ "ui_map_star1", false, 121, 179 },
					},
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
				
				{
					class = "TimeBasedInterpolator",
				},
            },
		},

        {
			class = "PuzzleButton",
			name = "Map4",
			x = UI_MAP_LEVEL_ORIGIN[1] + UI_MAP_LEVEL_OFFSET * 4,
			y = UI_MAP_LEVEL_ORIGIN[2],
            doUpdate = true,
--			indie = true,

			onMouseUp = function(x, y)
				LevelManager:EnterMap(4);
			end,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
                    images =
					{
						{ "ui_map_level4" },
						{ "ui_map_level_locked", false },
--						{ "ui_map_star1", false, 42, 176 },
--						{ "ui_map_star1", false, 66, 179 },
--						{ "ui_map_star1", false, 93, 179 },
--						{ "ui_map_star1", false, 121, 179 },
					},
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
				
				{
					class = "TimeBasedInterpolator",
				},
            },
		},

        {
			class = "PuzzleButton",
			name = "Map5",
			x = UI_MAP_LEVEL_ORIGIN[1] + UI_MAP_LEVEL_OFFSET * 5,
			y = UI_MAP_LEVEL_ORIGIN[2],
            doUpdate = true,
--			indie = true,

			onMouseUp = function(x, y)
				LevelManager:EnterMap(5);
			end,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
                    images =
					{
						{ "ui_map_level5" },
						{ "ui_map_level_locked", false },
--						{ "ui_map_star1", false, 42, 176 },
--						{ "ui_map_star1", false, 66, 179 },
--						{ "ui_map_star1", false, 93, 179 },
--						{ "ui_map_star1", false, 121, 179 },
					},
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
				
				{
					class = "TimeBasedInterpolator",
				},
            },
		},

		{
			class = "PuzzleButton",
			name = "GameDifficulty",
			x = UI_MAP_LEVEL_ORIGIN[1] + UI_MAP_LEVEL_OFFSET * 6,
			y = UI_MAP_LEVEL_ORIGIN[2],
            doUpdate = true,
--			indie = true,
		
			onMouseUp = function(x, y)
				LevelManager:EnterDifficulty();
			end,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
					indie = true,
                    images =
					{
						{ "ui_map_shadow" },
						{ "ui_map_level_locked", false },
						{ "ui_map_mode_shadow", false, 32 * APP_SCALE_FACTOR, 176 * APP_SCALE_FACTOR },
						{ "ui_map_normal", false },
						{ "ui_map_mode_normal", false, 32 * APP_SCALE_FACTOR, 176 * APP_SCALE_FACTOR },
					},
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
				
				{
					class = "TimeBasedInterpolator",
				},
            },
		},

        {
			class = "PuzzleButton",
			name = "AdChar",
			x = UI_BUTTON_POS[4],
			y = 5,
			doUpdate = true,
			hide = true,
			
            onMouseUp = function()
				PerformAdCharAction();
			end,
			
			components =
			{
				{
					class = "PuzzleAnimation",
					anim = "ad_cat_show",
					--animating = true,
					sync = true,
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
				
				{
					class = "TimeBasedInterpolator",
				},
			},
		},
	},
};

-------------------------------------------------------------------------
UI_SHOP_ITEM_SIZE = { 68 * APP_SCALE_FACTOR, 68 * APP_SCALE_FACTOR };
UI_SHOP_ITEM_OFFSET = 140;

UI_SHOP_CAT_ORIGIN = { -4, 257 };
UI_SHOP_CAT_OFFSET = -11;
UI_SHOP_CAT_SIZE = { 105, 71 };
if (IS_DEVICE_IPAD or IS_PLATFORM_ANDROID) then
	UI_SHOP_ITEM_ORIGIN = { 30, 160 };
	UI_SHOP_TARGET_OFFSET = { -17, -35 };
	UI_SHOP_NUM_OFFSET = 15;
else
	UI_SHOP_ITEM_ORIGIN = { 30, 175 };
	UI_SHOP_TARGET_OFFSET = { -17, -42 };
	UI_SHOP_NUM_OFFSET = 22;
end

UI_SHOP_COIN_OFFSET =
{
	{ -5, 66 },
	{ -14, 66 },
	{ -23, 66 },
	{ -32, 66 },
	{ -41, 66 },
	{ -50, 66 },
	{ -50, 66 },
	{ -50, 66 },
};

GameUITemplate
{
	name = "ShopCategory",
	reloadable = true,

	onSwipe =
	{
		host = { "Item1", "Item2", "Item3", "Item4", "Item5", "Item6",
				 "ItemTarget",
				 "ItemNum1", "ItemNum2", "ItemNum3", "ItemNum4", "ItemNum5", "ItemNum6", },
		size = { UI_SHOP_ITEM_SIZE[1], UI_SHOP_ITEM_SIZE[2] },
		range = { UI_SHOP_ITEM_ORIGIN[2] * APP_UNIT_Y, (UI_SHOP_ITEM_ORIGIN[2] + UI_SHOP_ITEM_SIZE[2]) * APP_UNIT_Y },
		bound = { -8 * UI_SHOP_ITEM_SIZE[1], UI_SHOP_ITEM_SIZE[1] },
		offset = UI_SHOP_ITEM_OFFSET,
        axis = UI_SWIPE_AXIS_X,
	},
	
	components =
	{
		{
			class = "PuzzleCompositeSprite",
			indie = true,
			images =
			{
				{ "ui_shop_background_down", true, 0, 194 * APP_SCALE_FACTOR },
--				{ "ui_shop_background_down", true, 0, 230 * APP_SCALE_FACTOR },
			},
		},
	},

	widgets =
	{
        {
			class = "PuzzleButton",
			name = "Item1",
			x = UI_SHOP_ITEM_ORIGIN[1],
			y = UI_SHOP_ITEM_ORIGIN[2],
            doUpdate = true,
			
            onMouseUp = function(x, y)
				ShopManager:UpdateShopTargetInfo(1);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
                    images =
					{
						{ "ui_shopicon_weapon_katana01" },
						{ "ui_shop_upgrade_lv1", false, 36, 51 },
						{ "ui_shop_soldout", false, 0, 0 },
					},
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
            },
		},
		
        {
			class = "PuzzleButton",
			name = "Item2",
			x = UI_SHOP_ITEM_ORIGIN[1] + UI_SHOP_ITEM_OFFSET * 1,
			y = UI_SHOP_ITEM_ORIGIN[2],
            doUpdate = true,
			
            onMouseUp = function(x, y)
				ShopManager:UpdateShopTargetInfo(2);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
                    images =
					{
						{ "ui_shopicon_weapon_katana01" },
						{ "ui_shop_upgrade_lv1", false, 36, 51 },
						{ "ui_shop_soldout", false, 0, 0 },
					},
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
            },
		},
		
        {
			class = "PuzzleButton",
			name = "Item3",
			x = UI_SHOP_ITEM_ORIGIN[1] + UI_SHOP_ITEM_OFFSET * 2,
			y = UI_SHOP_ITEM_ORIGIN[2],
            doUpdate = true,
			
            onMouseUp = function(x, y)
				ShopManager:UpdateShopTargetInfo(3);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
                    images =
					{
						{ "ui_shopicon_weapon_katana01" },
						{ "ui_shop_upgrade_lv1", false, 36, 51 },
						{ "ui_shop_soldout", false, 0, 0 },
					},
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
            },
		},
		
        {
			class = "PuzzleButton",
			name = "Item4",
			x = UI_SHOP_ITEM_ORIGIN[1] + UI_SHOP_ITEM_OFFSET * 3,
			y = UI_SHOP_ITEM_ORIGIN[2],
            doUpdate = true,
			
            onMouseUp = function(x, y)
				ShopManager:UpdateShopTargetInfo(4);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
                    images =
					{
						{ "ui_shopicon_weapon_katana01" },
						{ "ui_shop_upgrade_lv1", false, 36, 51 },
						{ "ui_shop_soldout", false, 0, 0 },
					},
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
            },
		},
		
        {
			class = "PuzzleButton",
			name = "Item5",
			x = UI_SHOP_ITEM_ORIGIN[1] + UI_SHOP_ITEM_OFFSET * 4,
			y = UI_SHOP_ITEM_ORIGIN[2],
            doUpdate = true,
			
            onMouseUp = function(x, y)
				ShopManager:UpdateShopTargetInfo(5);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
                    images =
					{
						{ "ui_shopicon_weapon_katana01" },
						{ "ui_shop_upgrade_lv1", false, 36, 51 },
						{ "ui_shop_soldout", false, 0, 0 },
					},
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
            },
		},

        {
			class = "PuzzleButton",
			name = "Item6",
			x = UI_SHOP_ITEM_ORIGIN[1] + UI_SHOP_ITEM_OFFSET * 5,
			y = UI_SHOP_ITEM_ORIGIN[2],
            doUpdate = true,
			
            onMouseUp = function(x, y)
				ShopManager:UpdateShopTargetInfo(6);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
                    images =
					{
						{ "ui_shopicon_weapon_katana01" },
						{ "ui_shop_upgrade_lv1", false, 36, 51 },
						{ "ui_shop_soldout", false, 0, 0 },
					},
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
            },
		},

        {
			class = "PuzzleNumber",
			name = "ItemNum1",
			numberOffset = -1,
			prefix = UI_COIN_PREFIX,
            doUpdate = true,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_money_0",
                },			

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
			},
		},

        {
			class = "PuzzleNumber",
			name = "ItemNum2",
			numberOffset = -1,
			prefix = UI_COIN_PREFIX,
            doUpdate = true,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_money_0",
                },			

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
			},
		},

        {
			class = "PuzzleNumber",
			name = "ItemNum3",
			numberOffset = -1,
			prefix = UI_COIN_PREFIX,
            doUpdate = true,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_money_0",
                },			

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
			},
		},

        {
			class = "PuzzleNumber",
			name = "ItemNum4",
			numberOffset = -1,
			prefix = UI_COIN_PREFIX,
            doUpdate = true,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_money_0",
                },			

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
			},
		},

        {
			class = "PuzzleNumber",
			name = "ItemNum5",
			numberOffset = -1,
			prefix = UI_COIN_PREFIX,
            doUpdate = true,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_money_0",
                },			

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
			},
		},

        {
			class = "PuzzleNumber",
			name = "ItemNum6",
			numberOffset = -1,
			prefix = UI_COIN_PREFIX,
            doUpdate = true,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_money_0",
                },			

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
			},
		},

        {
            class = "PuzzlePicture",
            name = "ItemTarget",
            x = UI_SHOP_ITEM_ORIGIN[1] + UI_SHOP_TARGET_OFFSET[1],
            y = UI_SHOP_ITEM_ORIGIN[2] + UI_SHOP_TARGET_OFFSET[2],
			doUpdate = true,
            
            components =
            {
                {
                    class = "PuzzleAnimation",
					anim = "ui_shop_target",
					animating = true,
                },

                {
                    class = "LinearMotion",
                    velocity = UI_SWIPE_MOTION_VELOCITY,
                },
            },
        },
		
		{
			class = "PuzzleCheckButton",
			name = "Cat1",
			x = UI_SHOP_CAT_ORIGIN[1],
			y = UI_SHOP_CAT_ORIGIN[2],
			state = true,
			
            onStateChange = function(state)
				ShopManager:SwitchShopCategory(1);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_shop_button_weapon",
				},
			},
		},

		{
			class = "PuzzleCheckButton",
			name = "Cat2",
			x = UI_SHOP_CAT_ORIGIN[1] + UI_SHOP_CAT_SIZE[1] + UI_SHOP_CAT_OFFSET,
			y = UI_SHOP_CAT_ORIGIN[2],
			state = false,
			
            onStateChange = function(state)
				ShopManager:SwitchShopCategory(2);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_shop_button_jade",
				},
			},
		},

		{
			class = "PuzzleCheckButton",
			name = "Cat3",
			x = UI_SHOP_CAT_ORIGIN[1] + (UI_SHOP_CAT_SIZE[1] + UI_SHOP_CAT_OFFSET) * 2,
			y = UI_SHOP_CAT_ORIGIN[2],
			state = false,
			
            onStateChange = function(state)
				ShopManager:SwitchShopCategory(3);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_shop_button_avatar",
				},
			},
		},

		{
			class = "PuzzleCheckButton",
			name = "Cat4",
			x = UI_SHOP_CAT_ORIGIN[1] + (UI_SHOP_CAT_SIZE[1] + UI_SHOP_CAT_OFFSET) * 3,
			y = UI_SHOP_CAT_ORIGIN[2],
			state = false,
			
            onStateChange = function(state)
				ShopManager:SwitchShopCategory(4);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_shop_button_coin",
				},
			},
		},

		{
			class = "PuzzleCheckButton",
			name = "Cat5",
			x = UI_SHOP_CAT_ORIGIN[1] + (UI_SHOP_CAT_SIZE[1] + UI_SHOP_CAT_OFFSET) * 4,
			y = UI_SHOP_CAT_ORIGIN[2],
			state = false,
			
            onStateChange = function(state)
				ShopManager:SwitchShopCategory(5);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_shop_button_treasure",
				},
			},
		},
	},
};

-------------------------------------------------------------------------
UI_SHOPINFO_POS =
{
--	["ShopInfo"] = { 210, 24 },
--	["ShopInfo"] = { 32, 0 },
	["ShopInfo"] = { 0, 0 },
	["ShopUpgrade"] = { 0 * APP_SCALE_FACTOR, 75 * APP_SCALE_FACTOR },
};

UI_SHOP_COST_POS = { 130 * APP_SCALE_FACTOR, 230 * APP_SCALE_FACTOR };
UI_SHOP_COST_OFFSET = { 0, -12 * APP_SCALE_FACTOR, -21 * APP_SCALE_FACTOR, -29 * APP_SCALE_FACTOR, -35 * APP_SCALE_FACTOR, -42 * APP_SCALE_FACTOR, -42 * APP_SCALE_FACTOR, -42 * APP_SCALE_FACTOR };

UI_SHOPINFO_INFO_POS = { 21 * APP_SCALE_FACTOR, 12 * APP_SCALE_FACTOR };
UI_SHOPINFO_ICON_POS = { 160 * APP_SCALE_FACTOR, 30 * APP_SCALE_FACTOR };
UI_SHOPINFO_SALES_POS = { 185 * APP_SCALE_FACTOR, 5 * APP_SCALE_FACTOR };
UI_SHOPINFO_LV_POS = { 171 * APP_SCALE_FACTOR, 78 * APP_SCALE_FACTOR };
UI_SHOPINFO_UPGICON_POS = { 230 * APP_SCALE_FACTOR, 30 * APP_SCALE_FACTOR };
UI_SHOPINFO_UPGLV_POS = { 241 * APP_SCALE_FACTOR, 78 * APP_SCALE_FACTOR };
UI_SHOPINFO_UPG_ARROW = { 166 * APP_SCALE_FACTOR, 115 * APP_SCALE_FACTOR };
UI_SHOPINFO_UPG_ARROW_SP = { 148 * APP_SCALE_FACTOR, 115 * APP_SCALE_FACTOR };

UI_SHOPINFO_DESC_POS =
{
	[1] = { 22 * APP_SCALE_FACTOR, 97 * APP_SCALE_FACTOR },  -- ST_WEAPON
	[2] = { 20 * APP_SCALE_FACTOR, 56 * APP_SCALE_FACTOR },  -- ST_JADE
	[3] = { 24 * APP_SCALE_FACTOR, 58 * APP_SCALE_FACTOR },  -- ST_UPGRADE
};

UI_SHOPINFO_VALUE_POS = 
{
	[1] =  -- ST_WEAPON
	{
		{ 127 * APP_SCALE_FACTOR, 39 * APP_SCALE_FACTOR },
		{ 127 * APP_SCALE_FACTOR, 58 * APP_SCALE_FACTOR },
		{ 127 * APP_SCALE_FACTOR, 77 * APP_SCALE_FACTOR },
	},
	[2] =  -- ST_JADE
	{
		{ 160 * APP_SCALE_FACTOR, 39 * APP_SCALE_FACTOR },
		{ 160 * APP_SCALE_FACTOR, 58 * APP_SCALE_FACTOR },
	},
	[3] =  -- ST_UPGRADE
	{
		{ 160 * APP_SCALE_FACTOR, 39 * APP_SCALE_FACTOR },
	},
};

UI_SHOPINFO_POSTVALUE_POS = 
{
	[1] =  -- ST_WEAPON
	{
		{ 202 * APP_SCALE_FACTOR, 39 * APP_SCALE_FACTOR },
		{ 202 * APP_SCALE_FACTOR, 58 * APP_SCALE_FACTOR },
		{ 202 * APP_SCALE_FACTOR, 77 * APP_SCALE_FACTOR },
	},
	[2] =  -- ST_JADE
	{
		{ 229 * APP_SCALE_FACTOR, 39 * APP_SCALE_FACTOR },
		{ 229 * APP_SCALE_FACTOR, 58 * APP_SCALE_FACTOR },
	},
	[3] =  -- ST_UPGRADE
	{
		{ 229 * APP_SCALE_FACTOR, 39 * APP_SCALE_FACTOR },
	},
};

GameUITemplate
{
	name = "Shop",
	transparent = true,
	reloadable = true,
	textures = { "ui_shop.png", "ui_shopbk.png", "ui_shopboss.png", "ui_iteminfo.png", "ui_button.png",
				 "ui_shopicon.png", "ui_avatar.png" },

	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_shop_background_up",
		},
	},

	widgets =
	{
        {
            class = "PuzzlePicture",
            x = 25,
            y = 16, --y = 32,
            name = "Seller",
			doUpdate = true,
            
            components =
            {
                {
                    class = "PuzzleAnimation",
                    anim = "ui_shop_seller_idle",
					animating = true,
                },
				
				{
					class = "StateMachine",
					states = ShopSellerStates,
				},
            },
        },
		
		UW_COIN_NUM,
		UW_KOBAN_NUM,

		{
			class = "PuzzleButton",
			name = "BACK",
			x = UI_BUTTON_POS[1],
			y = 0,
			
			onMouseUp = function(x, y)
				StageManager:ChangeStage("ShopCloseDoor");
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
		
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_button_back",
				},
			},
		},
	},
};


-------------------------------------------------------------------------
GameUITemplate
{
	name = "ShopInfo",
	y = 24,
	axis = AXIS_X_CENTER,
	axisOffset = 65,
	indie = true,
	transparent = true,
	reloadable = true,

	components =
	{
        {
			class = "PuzzleSprite",
			image = "ui_shop_infobackground",
        },
	},

	widgets =
	{
        {
            class = "PuzzlePicture",
            x = 160,
            y = 30,
            name = "ItemIcon",
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_itemicon_weapon_katana01",
                },
            },
        },

        {
            class = "PuzzlePicture",
            x = 171,
            y = 78,
            name = "ItemLv",
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_upgrade_lv1",
                },
            },
        },

        {
            class = "PuzzlePicture",
            x = 21,
            y = 12,
            name = "ItemInfo",
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_iteminfo_katana",
                },
            },
        },

        {
            class = "PuzzlePicture",
            x = 22,
            y = 97,
            name = "ItemDesc",
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_iteminfo_katana",
                },
            },
        },
		
        {
			class = "PuzzleNumber",
            x = 127,
            y = 32,
			name = "ItemValue1",
			align = NUMBER_ALIGNMENT_RIGHT,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_rednumber_0",
                },			
			},
		},
		
        {
			class = "PuzzleNumber",
            x = 127,
            y = 62,
			name = "ItemValue2",
			align = NUMBER_ALIGNMENT_RIGHT,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_rednumber_0",
                },			
			},
		},
		
        {
			class = "PuzzleNumber",
            x = 127,
            y = 81,
			name = "ItemValue3",
			align = NUMBER_ALIGNMENT_RIGHT,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_rednumber_0",
                },
			},
		},

		{
			class = "PuzzleButton",
			name = "Buy",
			x = 83,
			y = 128,
			doUpdate = true,
			
			onMouseUp = function(x, y)
				ShopManager:BuyTargetItem();
			end,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_button_buy",
                },
				
				{
					class = "TimeBasedInterpolator",
				},
			},
		},

		{
			class = "PuzzleButton",
			name = "Upgrade",
			x = 83,
			y = 128,
			doUpdate = true,
			
			onMouseUp = function(x, y)
				StageManager:ChangeStage("ShopUpgrade");
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_button_upgrade",
                },
				
				{
					class = "TimeBasedInterpolator",
				},
			},
		},
	},

	groups =
	{
		WeaponValues = { "ItemValue1", "ItemValue2", "ItemValue3", },
		DoubleValues = { "ItemValue1", "ItemValue2", },
		SingleValues = { "ItemValue1", },
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "ShopUpgrade",
	modal = MODAL_MODE_NORMAL,
	axis = AXIS_X_CENTER,
	indie = true,
	reloadable = true,
	textures = { "ui_upgrade.png" },

	components =
	{
        {
			class = "PuzzleSprite",
			image = "ui_upgrade_infobackground",
        },

		{
			class = "LinearMotion",
			velocity = 850 * APP_SCALE_FACTOR,
		}
	},

	widgets =
	{
		{
			class = "PuzzleButton",
			name = "Go",
			x = 62,
			y = 212,
			doUpdate = true,
			
			onMouseUp = function(x, y)
				ShopManager:UpgradeAction();
			end,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_upgrade_upgradebutton",
                },			
				
				{
					class = "TimeBasedInterpolator",
				},
			},
		},

        {
            class = "PuzzlePicture",
            x = 0,--160,
            y = 0,--30,
            name = "ItemIcon",
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_itemicon_weapon_katana01",
                },
            },
        },

        {
            class = "PuzzlePicture",
            x = 171,
            y = 78,
            name = "ItemLv",
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_upgrade_lv1",
                },
            },
        },

        {
            class = "PuzzlePicture",
            x = 21,
            y = 12,
            name = "ItemInfo",
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_iteminfo_katana",
                },
            },
        },

        {
            class = "PuzzlePicture",
            x = 22,
            y = 97,
            name = "ItemDesc",
       
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_iteminfo_katana",
                },
            },
        },
		
        {
			class = "PuzzleNumber",
            x = 127,
            y = 39,
			name = "ItemValue1",
			align = NUMBER_ALIGNMENT_RIGHT,
		
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_rednumber_0",
                },			
			},
		},
		
        {
			class = "PuzzleNumber",
            x = 127,
            y = 58,
			name = "ItemValue2",
			align = NUMBER_ALIGNMENT_RIGHT,
		
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_rednumber_0",
                },			
			},
		},
		
        {
			class = "PuzzleNumber",
            x = 127,
            y = 77,
			name = "ItemValue3",
			align = NUMBER_ALIGNMENT_RIGHT,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_rednumber_0",
                },
			},
		},

        {
            class = "PuzzlePicture",
            x = 166,
            y = 115,
            name = "ItemArrow",
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_upgrade_weaponinfo",
                },
            },
        },

        {
			class = "PuzzleNumber",
            x = 75 + 127,
            y = 39,
			name = "ItemValuePost1",
			align = NUMBER_ALIGNMENT_RIGHT,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_rednumber_0",
                },			
			},
		},
		
        {
			class = "PuzzleNumber",
            x = 75 + 127,
            y = 58,
			name = "ItemValuePost2",
			align = NUMBER_ALIGNMENT_RIGHT,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_rednumber_0",
                },			
			},
		},
		
        {
			class = "PuzzleNumber",
            x = 75 + 127,
            y = 77,
			name = "ItemValuePost3",
			align = NUMBER_ALIGNMENT_RIGHT,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_shop_rednumber_0",
                },			
			},
		},

        {
			class = "PuzzleNumber",
			x = UI_SHOP_COST_POS[1],
			y = UI_SHOP_COST_POS[2],
			name = "Cost",
			value = 1,
			numberOffset = -1,
			prefix = UI_COIN_PREFIX,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_money_0",
                },			
			},
		},
	},

	groups =
	{
		WeaponValues = { "ItemValue1", "ItemValue2", "ItemValue3", },
		DoubleValues = { "ItemValue1", "ItemValue2", },
		SingleValues = { "ItemValue1", },
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "ScrollUnlock",
	modal = MODAL_MODE_NORMAL,
	axis = AXIS_XY_CENTER,
	indie = true,
	reloadable = true,
	textures = { "ui_unlocked.png", "ui_dialog.png" },

	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_unlocked_scrollbk",
		},

		{
			class = "LinearMotion",
			velocity = 850 * APP_SCALE_FACTOR,
		},
	},

	widgets =
	{
        {
            class = "PuzzlePicture",
            x = -96,
            y = -65,
            name = "Title",
            
            components =
            {
                {
                    class = "PuzzleSprite",
					image = "ui_unlocked_title",
                },
            },
        },
	
        {
            class = "PuzzlePicture",
            x = 1,
            y = -24,
            name = "LightEffect",
			doUpdate = true,
            
            components =
            {
                {
                    class = "PuzzleSprite",
					image = "ui_unlocked_shine",
                },

				{
					class = "TimeBasedInterpolator",
				},
            },
        },

        {
            class = "PuzzlePicture",
            x = 67,
            y = 43,
            name = "Icon",
            
            components =
            {
                {
                    class = "PuzzleSprite",
					image = "ui_scroll_icon_01",
                },
            },
        },

        {
			class = "PuzzleButton",
			name = "OK",
			width = SCREEN_UNIT_X,
			height = SCREEN_UNIT_Y,
			transparent = true,
			
            onMouseUp = function()
				if (UIManager:GetUIComponent("ScrollUnlock", "Motion"):IsDone()) then
					AudioManager:PlaySfx(SFX_UI_BUTTON_2);
					StageManager:ChangeStage("ScrollUnlockExit");
				end
			end,
		},
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "JadeUnlock",
	modal = MODAL_MODE_NORMAL,
	axis = AXIS_XY_CENTER,
	indie = true,
	reloadable = true,
	textures = { "ui_shopicon.png", "ui_unlocked.png", "ui_dialog.png" },

	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_unlocked_scrollbk",
		},
		
		{
			class = "LinearMotion",
			velocity = 850 * APP_SCALE_FACTOR,
		},
	},

	widgets =
	{
        {
            class = "PuzzlePicture",
            x = -96,
            y = -65,
            name = "Title",
            
            components =
            {
                {
                    class = "PuzzleSprite",
					image = "ui_unlocked_title",
                },
            },
        },

        {
            class = "PuzzlePicture",
            x = 1,
            y = -24,
            name = "LightEffect",
			doUpdate = true,
            
            components =
            {
                {
                    class = "PuzzleSprite",
					image = "ui_unlocked_shine",
                },

				{
					class = "TimeBasedInterpolator",
				},
            },
        },

        {
            class = "PuzzlePicture",
            x = 55,
            y = 28,
            name = "Icon",
            
            components =
            {
                {
                    class = "PuzzleSprite",
					image = "ui_shopicon_upgrade_jade1",
                },
            },
        },

        {
			class = "PuzzleButton",
			name = "OK",
			width = SCREEN_UNIT_X,
			height = SCREEN_UNIT_Y,
			transparent = true,
			
            onMouseUp = function()
				if (UIManager:GetUIComponent("JadeUnlock", "Motion"):IsDone()) then
					AudioManager:PlaySfx(SFX_UI_BUTTON_2);
					StageManager:ChangeStage("JadeUnlockExit");
				end
			end,
		},
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "LevelUnlock",
	modal = MODAL_MODE_NORMAL,
	axis = AXIS_XY_CENTER,
	indie = true,
	reloadable = true,
	textures = { "ui_map.png" },

	components =
	{
		{
			class = "PuzzleCompositeSprite",
			images =
			{
				{ "ui_map_level1" },
				{ "ui_map_mode_shadow", false, 32 * APP_SCALE_FACTOR, 176 * APP_SCALE_FACTOR },
			},
		},

		{
			class = "LinearMotion",
			velocity = 850 * APP_SCALE_FACTOR,
		},
	},

	widgets =
	{
        {
            class = "PuzzlePicture",
            x = -78,
            y = -65,
            name = "Title",
            
            components =
            {
                {
                    class = "PuzzleSprite",
					image = "ui_unlocked_map",
                },
            },
        },

		{
			class = "PuzzleButton",
			name = "Go",
            x = 57,
            y = 180,
			doUpdate = true,
			
			onMouseUp = function(x, y)
				ResetDropdownUI("LevelUnlock");
				UIManager:ToggleUI("LevelUnlock");
				
				LevelManager:EnterNextMap();
				GotoScrollSelect();
				
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
		
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_stat_button_next",
				},
				
				{
					class = "TimeBasedInterpolator",
				},
			},
		},

		{
			class = "PuzzleButton",
			name = "GoShadow",
            x = 0,
            y = 0,
			width = 220 * APP_SCALE_FACTOR,
			height = 240 * APP_SCALE_FACTOR,
			transparent = true,
			
			onMouseUp = function(x, y)
				ResetDropdownUI("LevelUnlock");
				UIManager:ToggleUI("LevelUnlock");
				
				GotoMapSelect();
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
		},
	},
};

-------------------------------------------------------------------------
UI_PAUSE_OFFSET = { 110, 8 };

GameUITemplate
{
	name = "GamePause",
	modal = MODAL_MODE_NORMAL,
	axis = AXIS_XY_CENTER,
	indie = true,
	reloadable = true,
	textures = { "ui_pause.png", "ui_dialog.png" },

	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_pause_scroll",
		},
	},

	widgets =
	{
        {
            class = "PuzzlePicture",
            name = "Backdrop",
			x = 44,
			y = 192,
			
            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_pause_greybackgound",
				},
			},
	    },

        {
			class = "PuzzleButton",
			name = "Resume",
			x = 59,
			y = 61,
			
            onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				PauseGame(false);
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_pause_button_resume",
				},
			},
		},

        {
			class = "PuzzleButton",
			name = "Exit",
			x = 59,
			y = 127,
			
            onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				SwitchGamePauseUI(false);
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_pause_button_exit",
				},
			},
		},
		
		{
			class = "PuzzleCheckButton",
			name = "Bgm",
			x = 70,
			y = 208,
			
            onStateChange = function(state)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				AudioManager:ToggleBgm(state, true);
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_pause_button_music",
				},
			},
		},
		
		{
			class = "PuzzleCheckButton",
			name = "Sfx",
			x = 150,
			y = 208,
			
            onStateChange = function(state)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				AudioManager:ToggleSfx(state, true);
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_pause_button_sound",
				},
			},
		},
--[[ @Vibrate		
		{
			class = "PuzzleCheckButton",
			name = "Vibrate",
			x = 170,
			y = 208,
			
            onStateChange = function(state)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				BladeManager:EnableDeviceVibration(state);
			end,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_pause_button_vibrate",
				},
			},
		},
--]]		
        {
            class = "PuzzlePicture",
            x = 55,
            y = 104,
            name = "Message",
			
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_pause_message",
                },
			},
	    },

        {
			class = "PuzzleButton",
			name = "Yes",
			x = 41,
			y = 173,
			
            onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				StageManager:ChangeStage("PreExitGame");
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_pause_button_yes",
				},
			},
		},

        {
			class = "PuzzleButton",
			name = "No",
			x = 154,
			y = 173,
			
            onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				SwitchGamePauseUI(true);
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_pause_button_no",
				},
			},
		},
	},
};

-------------------------------------------------------------------------
DOOR_CLOSE_LEFT_POS  = { -5, -5 };
DOOR_CLOSE_RIGHT_POS = { 235, -5 };
DOOR_OPEN_LEFT_POS   = { -5 - DOOR_HALF_SIZE, -5 };
DOOR_OPEN_RIGHT_POS  = { 235 + DOOR_HALF_SIZE, -5 };
DOOR_VELOCITY = 750;
DOOR_OBSERVERS = { "Door", "ScrollSelect", "AvatarStat", "TreasureSelect", "GameStat" };

GameUITemplate
{
	name = "Door",
	transparent = true,
	modal = true,
	reloadable = true,
	textures = { "ui_door.png", "ui_door_night.png" },
	
	widgets =
	{
        {
            class = "PuzzlePicture",
            name = "DoorLeft",
			x = -5,
			y = -5,
			doUpdate = true,

            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_door_left",
				},

				{
					class = "StateMachine",
					states = DoorStates,
					intial = "opened_left",
				},
				
				{
					class = "LinearMotion",
					velocity = DOOR_VELOCITY,
				},
				
				{
					class = "Shaker",
					minValue = 1,
					maxValue = 2,
					count = 2,
					velocity = 1500,
				},
				
				{
					class = "Timer",
					duration = 500,
				},
			},
	    },

        {
            class = "PuzzlePicture",
            name = "DoorRight",
			x = 235,
			y = -5,
			doUpdate = true,
			
            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_door_right",
				},

				{
					class = "StateMachine",
					states = DoorStates,
					intial = "opened_right",
				},

				{
					class = "LinearMotion",
					velocity = DOOR_VELOCITY,
				},
				
				{
					class = "Shaker",
					minValue = 1,
					maxValue = 3,
					count = 2,
					velocity = 1500,
				},
				
				{
					class = "Timer",
					duration = 500,
				},				
			},
	    },
	},
};

-------------------------------------------------------------------------
UI_SCROLL_ORIGIN = { 0, 50 };
UI_SCROLL_OFFSET = 59;

if (IS_DEVICE_IPAD or IS_PLATFORM_ANDROID) then
	UI_SCROLL_SIZE = { 507, 142 };
	UI_SCROLL_COIN_OFFSET = { 90, 33 };
	UI_SCROLL_ASSIGN_POS = { 74 * APP_SCALE_FACTOR, 35 * APP_SCALE_FACTOR };
	UI_SCROLL_UNLOCK_POS = { 69 * APP_SCALE_FACTOR, 35 * APP_SCALE_FACTOR };
	UI_SCROLL_MASTER = 304;
else
	UI_SCROLL_SIZE = { 237, 59 };
	UI_SCROLL_COIN_OFFSET = { 80, 33 };
	UI_SCROLL_ASSIGN_POS = { 69, 33 };
	UI_SCROLL_UNLOCK_POS = { 58, 30 };
	UI_SCROLL_MASTER = 152;
end
UI_SCROLL_LV_POS = { 3 * APP_SCALE_FACTOR, 3 * APP_SCALE_FACTOR };

UI_SCROLL_BUTTON_OFFSET = { 160, 23 };
UI_SCROLL_VELOCITY = 800;

GameUITemplate
{
	name = "ScrollSelect",
	transparent = true,
	reloadable = true,
	textures = { "ui_scroll.png", "ui_scrollbk.png", "ui_button.png", "ui_lock.png", },

	onSwipe =
	{
		host = { "Scroll1", "Scroll2", "Scroll3", "Scroll4", "Scroll5", "Scroll6",
				 "ScrollCoinNum1", "ScrollCoinNum2", "ScrollCoinNum3", "ScrollCoinNum4", "ScrollCoinNum5", "ScrollCoinNum6",
				 "ScrollButton1", "ScrollButton2", "ScrollButton3", "ScrollButton4", "ScrollButton5", "ScrollButton6", },
		size = { UI_SCROLL_SIZE[1], UI_SCROLL_SIZE[2] },
		range = { UI_SCROLL_ORIGIN[1], UI_SCROLL_ORIGIN[1] + UI_SCROLL_SIZE[1] },
		offset = UI_SCROLL_OFFSET,
        axis = UI_SWIPE_AXIS_Y,
		bound = { -UI_SCROLL_SIZE[2], UI_SCROLL_SIZE[2] },
	},

	widgets =
	{
		{
			class = "PuzzlePicture",
			name = "DoorLeft",
			x = -5,
			y = -5,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_door_left",
                },
			},
		},

		{
			class = "PuzzlePicture",
			name = "DoorRight",
			x = 235,
			y = -5,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_door_right",
                },
			},
		},

		{
			class = "PuzzlePicture",
			name = "ScrollBackdrop",
			x = 0,
			y = 0,
			doUpdate = true,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_scroll_background",
                },
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},

		{
			class = "PuzzleButton",
			name = "Scroll1",
			x = UI_SCROLL_ORIGIN[1],
			y = UI_SCROLL_ORIGIN[2],
			doUpdate = true,

            components = 
            {
                {
                    class = "PuzzleCompositeSprite",
					primary = 2,
					indie = true,
                    images =
					{
                        { "ui_scroll_iconbar_01", true },
                        { "ui_scroll_target", false },
						{ "ui_scroll_button_assign", false, UI_SCROLL_ASSIGN_POS[1], UI_SCROLL_ASSIGN_POS[2] },
						{ "ui_shop_upgrade_lv1", false, UI_SCROLL_LV_POS[1], UI_SCROLL_LV_POS[2] },
						{ "ui_lvunlock_2", false, UI_SCROLL_UNLOCK_POS[1], UI_SCROLL_UNLOCK_POS[2] },
					},
					blendMode = GraphicsEngine.BLEND_FADEOUT,
                },

				{
					class = "TimeBasedInterpolator",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
            },
			
			onMouseUp = function(x, y)
				ScrollManager:UpdateTargetScroll(1);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
		},
		
		{
			class = "PuzzleButton",
			name = "Scroll2",
			x = UI_SCROLL_ORIGIN[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 1,
			doUpdate = true,

            components = 
            {
                {
                    class = "PuzzleCompositeSprite",
					primary = 2,
					indie = true,
                    images =
					{
                        { "ui_scroll_iconbar_02", true },
                        { "ui_scroll_target", false },
						{ "ui_scroll_button_assign", false, UI_SCROLL_ASSIGN_POS[1], UI_SCROLL_ASSIGN_POS[2] },
						{ "ui_shop_upgrade_lv1", false, UI_SCROLL_LV_POS[1], UI_SCROLL_LV_POS[2] },
						{ "ui_lvunlock_2", false, UI_SCROLL_UNLOCK_POS[1], UI_SCROLL_UNLOCK_POS[2] },
					},
					blendMode = GraphicsEngine.BLEND_FADEOUT,
                },

				{
					class = "TimeBasedInterpolator",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
            },
			
			onMouseUp = function(x, y)
				ScrollManager:UpdateTargetScroll(2);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
		},

		{
			class = "PuzzleButton",
			name = "Scroll3",
			x = UI_SCROLL_ORIGIN[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 2,
			doUpdate = true,

            components = 
            {
                {
                    class = "PuzzleCompositeSprite",
					primary = 2,
					indie = true,
                    images =
					{
                        { "ui_scroll_iconbar_03", true },
                        { "ui_scroll_target", false },
						{ "ui_scroll_button_assign", false, UI_SCROLL_ASSIGN_POS[1], UI_SCROLL_ASSIGN_POS[2] },
						{ "ui_shop_upgrade_lv1", false, UI_SCROLL_LV_POS[1], UI_SCROLL_LV_POS[2] },
						{ "ui_lvunlock_2", false, UI_SCROLL_UNLOCK_POS[1], UI_SCROLL_UNLOCK_POS[2] },
					},
					blendMode = GraphicsEngine.BLEND_FADEOUT,
                },

				{
					class = "TimeBasedInterpolator",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
            },
			
			onMouseUp = function(x, y)
				ScrollManager:UpdateTargetScroll(3);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
		},

		{
			class = "PuzzleButton",
			name = "Scroll4",
			x = UI_SCROLL_ORIGIN[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 3,
			doUpdate = true,

            components = 
            {
                {
                    class = "PuzzleCompositeSprite",
					primary = 2,
					indie = true,
                    images =
					{
                        { "ui_scroll_iconbar_04", true },
                        { "ui_scroll_target", false },
						{ "ui_scroll_button_assign", false, UI_SCROLL_ASSIGN_POS[1], UI_SCROLL_ASSIGN_POS[2] },
						{ "ui_shop_upgrade_lv1", false, UI_SCROLL_LV_POS[1], UI_SCROLL_LV_POS[2] },
						{ "ui_lvunlock_2", false, UI_SCROLL_UNLOCK_POS[1], UI_SCROLL_UNLOCK_POS[2] },
					},
					blendMode = GraphicsEngine.BLEND_FADEOUT,
                },

				{
					class = "TimeBasedInterpolator",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
            },
			
			onMouseUp = function(x, y)
				ScrollManager:UpdateTargetScroll(4);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
		},

		{
			class = "PuzzleButton",
			name = "Scroll5",
			x = UI_SCROLL_ORIGIN[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 4,
			doUpdate = true,

            components = 
            {
                {
                    class = "PuzzleCompositeSprite",
					primary = 2,
					indie = true,
                    images =
					{
                        { "ui_scroll_iconbar_05", true },
                        { "ui_scroll_target", false },
						{ "ui_scroll_button_assign", false, UI_SCROLL_ASSIGN_POS[1], UI_SCROLL_ASSIGN_POS[2] },
						{ "ui_shop_upgrade_lv1", false, UI_SCROLL_LV_POS[1], UI_SCROLL_LV_POS[2] },
						{ "ui_lvunlock_2", false, UI_SCROLL_UNLOCK_POS[1], UI_SCROLL_UNLOCK_POS[2] },
					},
					blendMode = GraphicsEngine.BLEND_FADEOUT,
                },

				{
					class = "TimeBasedInterpolator",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
            },
			
			onMouseUp = function(x, y)
				ScrollManager:UpdateTargetScroll(5);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
		},

		{
			class = "PuzzleButton",
			name = "Scroll6",
			x = UI_SCROLL_ORIGIN[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 5,
			doUpdate = true,

            components = 
            {
                {
                    class = "PuzzleCompositeSprite",
					primary = 2,
					indie = true,
                    images =
					{
                        { "ui_scroll_jadebar_06", true },
                        { "ui_scroll_target", false },
						{ "ui_scroll_button_assign", false, UI_SCROLL_ASSIGN_POS[1], UI_SCROLL_ASSIGN_POS[2] },
						{ "ui_shop_upgrade_lv1", false, UI_SCROLL_LV_POS[1], UI_SCROLL_LV_POS[2] },
						{ "ui_lvunlock_2", false, UI_SCROLL_UNLOCK_POS[1], UI_SCROLL_UNLOCK_POS[2] },
					},
					blendMode = GraphicsEngine.BLEND_FADEOUT,
                },

				{
					class = "TimeBasedInterpolator",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
            },
			
			onMouseUp = function(x, y)
				ScrollManager:UpdateTargetScroll(6);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
		},

		{
			class = "PuzzleNumber",
			name = "ScrollCoinNum1",
			x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_COIN_OFFSET[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_COIN_OFFSET[2],
			value = SCROLL_DATA[1][SCROLL_T_COST],
			numberOffset = -1,
			doUpdate = true,
--			indie = true,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_scroll_moneynumber_0",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = "ScrollCoinNum2",
			x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_COIN_OFFSET[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 1 + UI_SCROLL_COIN_OFFSET[2],
			value = SCROLL_DATA[2][SCROLL_T_COST],
			numberOffset = -1,
			doUpdate = true,
--			indie = true,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_scroll_moneynumber_0",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = "ScrollCoinNum3",
			x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_COIN_OFFSET[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 2 + UI_SCROLL_COIN_OFFSET[2],
			value = SCROLL_DATA[3][SCROLL_T_COST],
			numberOffset = -1,
			doUpdate = true,
--			indie = true,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_scroll_moneynumber_0",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = "ScrollCoinNum4",
			x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_COIN_OFFSET[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 3 + UI_SCROLL_COIN_OFFSET[2],
			value = SCROLL_DATA[4][SCROLL_T_COST],
			numberOffset = -1,
			doUpdate = true,
--			indie = true,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_scroll_moneynumber_0",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = "ScrollCoinNum5",
			x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_COIN_OFFSET[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 4 + UI_SCROLL_COIN_OFFSET[2],
			value = SCROLL_DATA[5][SCROLL_T_COST],
			numberOffset = -1,
			doUpdate = true,
--			indie = true,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_scroll_moneynumber_0",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},
		{
			class = "PuzzleNumber",
			name = "ScrollCoinNum6",
			x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_COIN_OFFSET[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 5 + UI_SCROLL_COIN_OFFSET[2],
			value = 0,--SCROLL_DATA[6][SCROLL_T_COST],
			numberOffset = -1,
			doUpdate = true,
--			indie = true,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_scroll_moneynumber_0",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},

		{
			class = "PuzzleButton",
			name = "ScrollButton1",
			x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_BUTTON_OFFSET[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_BUTTON_OFFSET[2],
			doUpdate = true,

			onMouseUp = function(x, y)
				ScrollManager:BuyOrRefundScroll(1);
			end,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_scroll_button_buy",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},

		{
			class = "PuzzleButton",
			name = "ScrollButton2",
			x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_BUTTON_OFFSET[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 1 + UI_SCROLL_BUTTON_OFFSET[2],
			doUpdate = true,

			onMouseUp = function(x, y)
				ScrollManager:BuyOrRefundScroll(2);
			end,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_scroll_button_buy",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},
		
		{
			class = "PuzzleButton",
			name = "ScrollButton3",
			x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_BUTTON_OFFSET[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 2 + UI_SCROLL_BUTTON_OFFSET[2],
			doUpdate = true,

			onMouseUp = function(x, y)
				ScrollManager:BuyOrRefundScroll(3);
			end,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_scroll_button_buy",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},
		
		{
			class = "PuzzleButton",
			name = "ScrollButton4",
			x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_BUTTON_OFFSET[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 3 + UI_SCROLL_BUTTON_OFFSET[2],
			doUpdate = true,

			onMouseUp = function(x, y)
				ScrollManager:BuyOrRefundScroll(4);
			end,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_scroll_button_buy",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},
		
		{
			class = "PuzzleButton",
			name = "ScrollButton5",
			x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_BUTTON_OFFSET[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 4 + UI_SCROLL_BUTTON_OFFSET[2],
			doUpdate = true,

			onMouseUp = function(x, y)
				ScrollManager:BuyOrRefundScroll(5);
			end,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_scroll_button_buy",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},

		{
			class = "PuzzleButton",
			name = "ScrollButton6",
			x = UI_SCROLL_ORIGIN[1] + UI_SCROLL_BUTTON_OFFSET[1],
			y = UI_SCROLL_ORIGIN[2] + UI_SCROLL_OFFSET * 5 + UI_SCROLL_BUTTON_OFFSET[2],
			doUpdate = true,

			onMouseUp = function(x, y)
			end,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_scroll_button_buy",
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},

		{
			class = "PuzzlePicture",
			name = "ScrollCover",
			x = 0,
			y = 0,
			doUpdate = true,
			
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_scroll_cover",
                },
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},

		{
			class = "PuzzlePicture",
			name = "Master",
			x = SCREEN_UNIT_X * 0.5,--250,
			y = SCREEN_UNIT_Y,--170,
			doUpdate = true,
			indie = true,

            components =
            {
                {
                    class = "PuzzleAnimation",
                    anim = "ui_scroll_master_idle",
					animating = true,
                },

				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY * APP_SCALE_FACTOR,
				},
			},
		},

		{
			class = "PuzzlePicture",
			name = "ScrollText",
			x = 244,
			y = 40,
			doUpdate = true,

            components =
            {
                {
                    class = "PuzzleCompositeSprite",
					primary = 2,
					indie = true,
                    images =
					{
						{ "ui_scroll_dialog", true },
						{ "ui_scroll_dialog_00", true, 13 * APP_SCALE_FACTOR, 33 * APP_SCALE_FACTOR },
					},
                },
				
				{
					class = "TimeBasedInterpolator",
				},
			},
		},
		
        {
			class = "PuzzleRadioButtonGroup",
			name = "Category",
			x = UI_SCROLL_ORIGIN[1],
			y = UI_SCROLL_ORIGIN[2] - 35,
			offsetX = 1,
			count = 3,
			doUpdate = true,
			
            onStateOn = function(index)
				ScrollManager:SwitchCategory(index);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
				{
					class = "PuzzleSpriteGroup",
					sprites =
					{
						{ name="PuzzleSprite", image="ui_scroll_button_scroll" },
						{ name="PuzzleSprite", image="ui_scroll_button_jade" },
						{ name="PuzzleSprite", image="ui_scroll_button_charater" },
					},
				},
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
            },
		},

		{
			class = "PuzzleButton",
			name = "Start",
			x = 390,
			y = 4,
			scale = 1.4,
			doUpdate = true,
			
			onMouseUp = function(x, y)
				ScrollManager:Complete();								
				AudioManager:PlaySfx(SFX_UI_START_GAME);		
			end,

            components =
            {
                {
                    class = "PuzzleAnimation",
                    anim = "ui_scroll_button_start",
					animating = true,
                },
				
				{
					class = "LinearMotion",
					velocity = UI_SCROLL_VELOCITY,
				},
			},
		},

        {
			class = "PuzzleButton",
			name = "Back",
			x = UI_BUTTON_POS[1],
			y = 280,
			
            onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				StageManager:ChangeStage("PostScrollSelectExit");
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_button_back",
				},
			},
		},

		UW_KOBAN_NUM,
		UW_COIN_NUM,
	},

	groups =
	{
		ScrollWidgets =
		{
			"ScrollBackdrop", "ScrollCover", "Category",
			"Scroll1", "Scroll2", "Scroll3", "Scroll4", "Scroll5", "Scroll6",
		},
		
		MoneyWidgets =
		{
			"ScrollCoinNum1", "ScrollCoinNum2", "ScrollCoinNum3", "ScrollCoinNum4", "ScrollCoinNum5",
			"ScrollButton1", "ScrollButton2", "ScrollButton3", "ScrollButton4", "ScrollButton5",
		},
		
		ButtonWidgets =
		{
			"Start", "Back", "KobanNum", "CoinNum", --"Category", 
		},
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "Medal",
	transparent = true,
	reloadable = true,
	textures = { "ui_medal.png" },

	widgets =
	{
--[[	
		{
            class = "PuzzlePicture",
            name = "MedalEffect",
			doUpdate = true,

            components = 
            {
				{
					class = "PuzzleAnimation",
					anim = "ui_medal1",
				},
				
				{
					class = "StateMachine",
					states = UIMedalEffectStates,
				}
			},
		},
--]]
		{
            class = "PuzzlePicture",
            name = "MedalDistance",
            x = 110, --x = 116,
            y = 30,
			doUpdate = true,

            components = 
            {
				{
					class = "PuzzleAnimation",
					anim = "ui_medal_500m",
				},
				
				{
					class = "StateMachine",
					states = UIMedalDistanceStates,
				}
			},
		},
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "InGame",
	transparent = true,
	reloadable = true,
	textures = { "ui_ingame.png", "object.png" },

	widgets =
	{
		UW_LIFEBAR,
		UW_LIFEBAR_NUM,
		UW_ENERGYBAR,
		UW_ENERGYBAR_NUM,

		{
			class = "PuzzlePicture",
			name = "JadeIcon",
			--x = 17,
			--y = 55,
			x = 310,
			y = 30,
			doUpdate = true,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "effect_jadeicon_01",
				},
				
				{
					class = "StateMachine",
					states = JadeStates,
				},
				
				{
					class = "Fade",
				},
				
				{
					class = "TimeBasedInterpolator",
				}
			},
		},
	
		{
			class = "PuzzlePicture",
			name = "JadeText",
			--x = 17 + 24,
			--y = 55 + 3,
			x = 310 + 24,
			y = 30 + 3,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "effect_jadebuff_01",
				},
			},
		},

        {
            class = "PuzzleButton",
            name = "Pause",
            x = 430,
            y = 0,
			width = 50 * APP_SCALE_FACTOR,
			height = 50 * APP_SCALE_FACTOR,
			transparent = true,

            onMouseUp = function()
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
                PauseGame(true);
            end,
        },

		{
            class = "PuzzlePicture",
            name = "Medal",
            x = 0,
            y = 0,

            components = 
            {
				{
					class = "PuzzleCompositeSprite",
					images = 
					{
						--{ "ui_medal_01", true, UI_INGAME_MEDAL_POS[1][1], UI_INGAME_MEDAL_POS[1][2] },
						--{ "ui_medal_01", true, UI_INGAME_MEDAL_POS[2][1], UI_INGAME_MEDAL_POS[2][2] },
						--{ "ui_medal_01", true, UI_INGAME_MEDAL_POS[3][1], UI_INGAME_MEDAL_POS[3][2] },
						{ "ui_button_pause", true, 440, 10 },
					},
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = "CoinNum",
			x = UI_INGAME_COIN_ORIGIN[1],
			y = UI_INGAME_COIN_ORIGIN[2],
			numberOffset = -1,
			prefix = UI_COIN_PREFIX,
			doUpdate = true,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_money_0",
				},
		
				{
					class = "TimeBasedInterpolator",
				},
				
				{
					class = "LinearMotion",
					velocity = 250,
				},
			},
		},

		{
			class = "PuzzlePicture",
			name = "TipText",
			x = 134,
			y = 250,
			doUpdate = true,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_ingame_tip1",
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
				
				{
					class = "TimeBasedInterpolator",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = "DistanceCounter",
			x = 200,
			y = 280,
			value = 999,
			postfix = "postfis",
			numberOffset = -4,
			doUpdate = true,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_distance_0",
				},
				
				{
					class = "StateMachine",
					states = DistanceCounterStates,
					initial = "inactive",
				},
				
				{
					class = "Timer",
					duration = DISTANCE_COUNTER_SPEED,
				},
				
				{
					class = "TimeBasedInterpolator",
				},
			},
		},

        {
            class = "PuzzleNumber",
            name = "Combo",
            x = 280,
            y = 53,
            doUpdate = true,
            postfix = "postfix",
            postfixOffset = 10,
            
            components = 
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_hits_0",
                },

                {
                    class = "TimeBasedInterpolator",
                },
                
                {
                    class = "StateMachine",
                    states = ComboStates,
                },
                        
                {
                    class = "Timer",
                    duration = COMBO_LIVE_DURATION,
                },                
            },
        },

        {
            class = "PuzzlePicture",
            name = "CriticalText",
            x = 320,
            y = 85,
			doUpdate = true,

            components = 
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_critical",
                },

                {
                    class = "TimeBasedInterpolator",
                },

                {
                    class = "StateMachine",
                    states = TextEffectStates,
                },

                {
                    class = "Timer",
                    duration = TEXTEFFECT_LIVE_DURATION,
                },                
			},
		},

		{
			class = "PuzzleButton",
			name = "Scroll1",
			x = UI_SCROLL_POS[1][1],
			y = UI_SCROLL_POS[1][2],
			doUpdate = true,

			onMouseUp = function()
				ScrollManager:UseScroll(1);
				--AudioManager:PlaySfx(SFX_SCROLL_USE);
			end,

			components =
			{
				{
					class = "PuzzleCompositeSprite",
					indie = true,
					images = 
					{
						{ "ui_scroll_icon_01", true, },
						{ "ui_cooldown", false, },
					},
				},
				
				{
					class = "StateMachine",
					states = ScrollCooldownStates,
				},
				
				{
					class = "TimeBasedInterpolator",
				},
				
				{
					class = "Attribute",
				},
			},
		},

		{
			class = "PuzzleButton",
			name = "Scroll2",
			x = UI_SCROLL_POS[2][1],
			y = UI_SCROLL_POS[2][2],
			doUpdate = true,
		
			onMouseUp = function()
				ScrollManager:UseScroll(2);
				--AudioManager:PlaySfx(SFX_SCROLL_USE);
			end,

			components =
			{
				{
					class = "PuzzleCompositeSprite",
					indie = true,
					images = 
					{ 
						{ "ui_scroll_icon_01", true, },
						{ "ui_cooldown", false, },
					},
				},
				
				{
					class = "StateMachine",
					states = ScrollCooldownStates,
				},
				
				{
					class = "TimeBasedInterpolator",
				},
				
				{
					class = "Attribute",
				},
			},
		},

		UW_WEAPON_3,
		UW_WEAPON_2,
		UW_WEAPON_1,
--[[ @DEBUG
        {
			class = "PuzzleButton",
			name = "ninja",
			--transparent = true,
			x = 440,
			y = 64,
			width = 40,
			height = 40,
--x=0,y=0,width=100,height=100,
            onMouseUp = function()
--				AudioManager:PlaySfx(SFX_OBJECT_JADE);
--				LevelManager.m_BossModeChance = 100;
--				LevelManager:EnterBossMode_Shadow();

--				EnemyManager:LaunchEnemy(Innocent_ElderSP)
--				LevelManager:AttackCastleByInnocent();
--				LevelManager:BoostDistance(500);
--				LevelManager:BoostDistance(1500);
				LevelManager:BoostDistance(3000);
--				LevelManager:BoostDistance(9960);
			end,
		},
---]]		
--[[ @DEBUG
        {
			class = "PuzzleText",
			name = "BossChance",
			value = "0 %",
            x = 90,
            y = 300,
		},
        {
            class = "PuzzleText",
            name = "Wave",
			value = "Lv0 / m0",
            x = 90,
            y = 300,
		},
--]]
    },
};

--------------------------------------------------------------------------------
GameUITemplate
{
	name = "PreGameScroll",
	transparent = true,
	reloadable = true,
	textures = { "effect_magic.png" },
	modal = MODAL_MODE_NORMAL,

	widgets =
	{
        {
            class = "PuzzlePicture",
            name = "ScrollPreEffectBKUp",
            x = -480,
            y = 62,
			doUpdate = true,

            components = 
            {
				{
					class = "PuzzleAnimation",
					anim = "scrolleffect_background_up",
					animating = true,
				},
				
				{
					class = "StateMachine",
					states = ScrollPreEffectBackdropStates,
				},
		
				{
					class = "LinearMotion",
					velocity = 2500,
				},
			},
		},

        {
            class = "PuzzlePicture",
            name = "ScrollPreEffectBKDown",
            x = 480,
            y = 169,
			doUpdate = true,

            components = 
            {
				{
					class = "PuzzleAnimation",
					anim = "scrolleffect_background_down",
					animating = true,
				},
				
				{
					class = "StateMachine",
					states = ScrollPreEffectBackdropStates,
				},
		
				{
					class = "LinearMotion",
					velocity = 2500,
				},
			},
		},

        {
            class = "PuzzlePicture",
            name = "ScrollPreEffectMCOut",
--            x = 108,
--            y = 33,
			doUpdate = true,
--			indie = true,
--			axis = AXIS_X_CENTER,
			axis = AXIS_XY_CENTER,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "scrolleffect_magiccircle_outter",
				},
				
				{
					class = "StateMachine",
					states = ScrollPreEffectStates,
				},
				
				{
					class = "TimeBasedInterpolator",
				},
				
				{
					class = "Timer",
					duration = MAGIC_CIRCLE_DURATION,
				},			
			},
		},

        {
            class = "PuzzlePicture",
            name = "ScrollPreEffectMCIn",
--            x = 123,
--            y = 48,
			doUpdate = true,
--			indie = true,
--			axis = AXIS_X_CENTER, 
			axis = AXIS_XY_CENTER,
			
			components =
			{
				{
					class = "PuzzleCompositeSprite",
					indie = true,
					images =
					{
						{ "scrolleffect_magiccircle_inner", true },
						{ "scrolleffect_magiccircle_symbol_01", false, 71 * APP_SCALE_FACTOR, 71 * APP_SCALE_FACTOR },--86, 86 },
					},
				},
				
				{
					class = "TimeBasedInterpolator",
				},
			},
		},
	},

	groups =
	{
		AllWidgets = { "ScrollPreEffectBKUp", "ScrollPreEffectBKDown", "ScrollPreEffectMCOut", "ScrollPreEffectMCIn", },
	},
};

--------------------------------------------------------------------------------
GameUITemplate
{
	name = "GameScroll",
	transparent = true,
	modal = MODAL_MODE_NOBACKDROP,

	widgets =
	{
	},
};

--------------------------------------------------------------------------------
GameUITemplate
{
	name = "GameCountdown",
	transparent = true,
	reloadable = true,
	textures = { "ui_text.png" },
	modal = MODAL_MODE_NOBACKDROP, --MODAL_MODE_NORMAL,
	
	widgets =
	{

        {
            class = "PuzzlePicture",
            name = "LevelText",
            x = 167,
            y = 135,
			doUpdate = true,

            components = 
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_stat_ready",
                },

                {
                    class = "TimeBasedInterpolator",
                },

                {
                    class = "StateMachine",
                    states = CountdownTextEffectStates,
					initial = "done",
                },
				
				{
					class = "Timer",
					duration = 1000,
				}
			},
		},
	},
};

-------------------------------------------------------------------------
UI_AVATARSTAT_POS = { 113, 12 };

GameUITemplate
{
	name = "AvatarStat",
	reloadable = true,
	textures = { "object.png", "ui_dialog.png", "ui_avatar.png", "ui_particle.png" },

	components =
	{
		{
			class = "StateMachine",
			states = UIStatStates,
		},
		
		{
			class = "Timer",
			duration = 300,
		}
	},
	
	widgets =
	{
		{
			class = "PuzzlePicture",
			name = "DoorLeft",
			x = -5,
			y = -5,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_door_left",
                },
			},
		},

		{
			class = "PuzzlePicture",
			name = "DoorRight",
			x = 235,
			y = -5,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_door_right",
                },
			},
		},

		{
			class = "PuzzlePicture",
			name = "Background",
			x = UI_AVATARSTAT_POS[1],
			y = UI_AVATARSTAT_POS[2],
--			axis = AXIS_XY_CENTER,
			indie = true,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_pause_scroll",
                },
			},
		},

        {
            class = "PuzzlePicture",
            name = "AvatarShine",
            x = 40,
            y = 26,
            doUpdate = true,
			indie = true,
			
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_unlocked_shine",
                },
				
				{
					class = "TimeBasedInterpolator",
				},
            },
        },
		
        {
            class = "PuzzlePicture",
            name = "Paperfall",
            x = 57,
            y = 25,
            doUpdate = true,
			indie = true,
			
            components =
            {
                {
                    class = "PuzzleAnimation",
                    anim = "ui_particle_paperfall",
					animating = true,
                },
				
				{
					class = "TimeBasedInterpolator",
				},
            },
        },
		
        {
            class = "PuzzlePicture",
            name = "AvatarName",
            x = 70,
            y = 43,
			indie = true,
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_lvup_01",
                },
            },
        },

        {
            class = "PuzzlePicture",
            name = "AvatarIcon",
            x = 94,
            y = 74,
			indie = true,
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "avatar_ninjagirl_move_01",
                },
            },
        },

        {
            class = "PuzzlePicture",
            name = "AvatarLv",
            x = 104,
            y = 156,
			doUpdate = true,
			indie = true,
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_lvup_lv1",
                },
		
				{
					class = "TimeBasedInterpolator",
				},
            },
        },

		{
			class = "PuzzleProgressbar",
			name = "LifeBar",
			x = 50,
			y = 181,
			maxValue = 100,
			value = 100,
			doUpdate = true,
			indie = true,
		
			components =
			{
				{
					class = "PuzzleCompositeSprite",
					primary = 2,
					images = 
					{ 
						{ "ui_lifebar_base", true },
						{ "ui_lifebar_life", true, 20 * APP_SCALE_FACTOR, 9 * APP_SCALE_FACTOR },
					},
				},
		
				{
					class = "SpeedBasedInterpolator",
				},
			},
		},

		{
			class = "PuzzleNumber",
			name = "LifeBarNumber",
			x = 50 + 35,
			y = 181 + 9,
			value = 100,
			maxValue = 100,
			signSlash = true,
			indie = true,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_lifebar_0",
				},
			},
		},
	
		{
			class = "PuzzleProgressbar",
			name = "EnergyBar",
			x = 50,
			y = 208,
			maxValue = 100,
			value = 100,
			doUpdate = true,
			indie = true,
		
			components =
			{
				{
					class = "PuzzleCompositeSprite",
					primary = 2,
					images = 
					{ 
						{ "ui_energybar_base", true },
						{ "ui_energybar_energy", true, 20 * APP_SCALE_FACTOR, 9 * APP_SCALE_FACTOR },
					},
				},
		
				{
					class = "SpeedBasedInterpolator",
				},
		   },
		},

		{
			class = "PuzzleNumber",
			name = "EnergyBarNumber",
			x = 50 + 35,
			y = 208 + 9,
			value = 100,
			maxValue = 100,
			signSlash = true,
			indie = true,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_lifebar_0",
				},
			},
		},

		{
			class = "PuzzleProgressbar",
			name = "ExpBar",
			x = 48,
			y = 236,
			maxValue = 100,
			value = 0,
			doUpdate = true,
			indie = true,
		
			components =
			{
				{
					class = "PuzzleCompositeSprite",
					primary = 2,
					images = 
					{ 
						{ "ui_expbar_base", true },
						{ "ui_expbar_exp", true, 31 * APP_SCALE_FACTOR, 9 * APP_SCALE_FACTOR },
					},
				},

				{
					class = "TimeBasedInterpolator",
				},
		   },
		},

		{
			class = "PuzzleNumber",
			name = "ExpBarNumber",
			x = 93,
			y = 245,
			value = EXP_GAIN_MIN,
			signPlus = true,
			doUpdate = true,
			indie = true,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_lifebar_0",
				},
				
				{
					class = "TimeBasedInterpolator",
				},
			},
		},
--[[
		{
			class = "PuzzleButton",
			name = "Skip",
			width = SCREEN_UNIT_X,
			height = SCREEN_UNIT_Y,
			transparent = true,
			
			onMouseUp = function(x, y)
				LevelManager:SkipAvatarStat();
			end,
		},
--]]		
	},

	groups =
	{
		CenterWidgets = { "AvatarName", "AvatarIcon", "AvatarLv", "AvatarShine", "Paperfall",
						  "LifeBar", "LifeBarNumber", "EnergyBar", "EnergyBarNumber", "ExpBar", "ExpBarNumber" },
	},
};

-------------------------------------------------------------------------
TREASURE_ORIGIN = { 70, 141 };
TREASURE_OFFSET = 130;
TREASURE_ICON_OFFSET = 115;
TREASURE_NUM_OFFSET = 141;
TREASURE_RESULT_POS =
{
	[TREASURE_TYPE_COIN] = { 160, 169 },
	[TREASURE_TYPE_KOBAN] = { 160, 169 },
	[TREASURE_TYPE_BOOST] = { 154 - TREASURE_ICON_OFFSET, 157 },
};

TREASURE_DOUBLER_OFFSET =
{
	[TREASURE_TYPE_COIN] = 380,
	[TREASURE_TYPE_KOBAN] = 335,
}

GameUITemplate
{
	name = "TreasureSelect",
	transparent = true,
	reloadable = true,
--	textures = { "ui_stat.png", "ui_stat_treasure.png", },
	textures = { "ui_stat.png", "ui_stat_bk.png", "ui_stat_widget.png", "ui_stat_treasure.png", },

	widgets =
	{
		{
			class = "PuzzlePicture",
			name = "DoorLeft",
			x = -5,
			y = -5,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_door_left",
                },
			},
		},

		{
			class = "PuzzlePicture",
			name = "DoorRight",
			x = 235,
			y = -5,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_door_right",
                },
			},
		},
		
        {
            class = "PuzzlePicture",
            x = 0,
            y = 72,
            name = "Background",
			doUpdate = true,

            components =
            {
                {
                    class = "PuzzleAnimation",
                    anim = "ui_stat_background_close",
                },
				
				{
					class = "StateMachine",
					states = UIStatStates,
				},
				
				{
					class = "Timer",
					duration = 300,
				}
			},
		},

		UW_KOBAN_NUM,
		UW_COIN_NUM,

		{
            class = "PuzzlePicture",
            name = "Medal",
            x = 40,
            y = 0,

            components = 
            {
				{
					class = "PuzzleCompositeSprite",
					images = 
					{ 
						{ "ui_stat_medal_01", true, 200, 0 },
						{ "ui_stat_medal_01", true, 225, 0 },
						{ "ui_stat_medal_01", true, 250, 0 },
						{ "ui_stat_reached_500m", true, 110, 30 },
					},
				},
			},
		},
		
		{
			class = "PuzzleButton",
			name = "Box1",
			x = TREASURE_ORIGIN[1],
			y = TREASURE_ORIGIN[2],
			doUpdate = true,
			
			onMouseUp = function(x, y)
				PickTreasureBox(1);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
			
			components =
			{
				{
					class = "PuzzleAnimation",
					anim = "ui_stat_box1_idle",
					animating = true,
				},
				
				{
					class = "LinearMotion",
					velocity = 800,
				},

				{
					class = "TimeBasedInterpolator",
				},
			},	
		},

		{
			class = "PuzzleButton",
			name = "Box2",
			x = TREASURE_ORIGIN[1] + TREASURE_OFFSET,
			y = TREASURE_ORIGIN[2],
			doUpdate = true,
			
			onMouseUp = function(x, y)
				PickTreasureBox(2);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
			
			components =
			{
				{
					class = "PuzzleAnimation",
					anim = "ui_stat_box1_idle",
					animating = true,
				},
				
				{
					class = "LinearMotion",
					velocity = 800,
				},

				{
					class = "TimeBasedInterpolator",
				},
			},	
		},

		{
			class = "PuzzleButton",
			name = "Box3",
			x = TREASURE_ORIGIN[1] + TREASURE_OFFSET * 2,
			y = TREASURE_ORIGIN[2],
			doUpdate = true,
			
			onMouseUp = function(x, y)
				PickTreasureBox(3);
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
			
			components =
			{
				{
					class = "PuzzleAnimation",
					anim = "ui_stat_box1_idle",
					animating = true,
				},
				
				{
					class = "LinearMotion",
					velocity = 800,
				},

				{
					class = "TimeBasedInterpolator",
				},
			},	
		},
		
        {
            class = "PuzzlePicture",
            name = "TreasureText",
            x = 117,
            y = 83,
--			indie = true,
			axis = AXIS_X_CENTER,
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_stat_box_pickreward",
                },
            },
        },
				
        {
            class = "PuzzlePicture",
            name = "TreasureResult",
            x = TREASURE_RESULT_POS[1][1],
            y = TREASURE_RESULT_POS[1][2],
			doUpdate = true,
            
            components =
            {
				{
					class = "PuzzleCompositeSprite",
					images = 
					{ 
						{ "ui_stat_youget", true, 0, 0 },
						{ "ui_stat_koban", true, TREASURE_ICON_OFFSET, 0 },
					},
				},
				
				{
					class = "LinearMotion",
					velocity = 1000,
				},
            },
        },
				
        {
            class = "PuzzleNumber",
            name = "TreasureNum",
            x = TREASURE_RESULT_POS[1][1] + TREASURE_NUM_OFFSET,
            y = TREASURE_RESULT_POS[1][2],
			doUpdate = true,
            
            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_stat_scorenumber_0",
				},
				
				{
					class = "LinearMotion",
					velocity = 800,
				},
            },
        },
				
        {
            class = "PuzzlePicture",
            name = "Doubler",
            x = TREASURE_RESULT_POS[1][1] + TREASURE_NUM_OFFSET,
            y = TREASURE_RESULT_POS[1][2],
            
            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_stat_double",
				},
			},
		},
	},

	groups =
	{
		AllWidgets = { "Medal", "Box1", "Box2", "Box3", "TreasureNum", "TreasureText", "TreasureResult", "Doubler" },
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "GameStat",
	transparent = true,
	reloadable = true,
--	textures = { "ui_stat.png", "ui_stat_best.png", "ui_avatar.png", },
	textures = { "ui_stat.png", "ui_stat_best.png", "ui_avatar.png", "ui_stat_bk.png", "ui_stat_widget.png", "ui_stat_treasure.png", },

	widgets =
	{
		{
			class = "PuzzlePicture",
			name = "DoorLeft",
			x = -5,
			y = -5,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_door_left",
                },
			},
		},

		{
			class = "PuzzlePicture",
			name = "DoorRight",
			x = 235,
			y = -5,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_door_right",
                },
			},
		},
		
        {
            class = "PuzzlePicture",
            x = 0,
            y = 72,
            name = "Background",
			doUpdate = true,

            components =
            {
                {
                    class = "PuzzleAnimation",
                    anim = "ui_stat_background_close",
                },
				
				{
					class = "StateMachine",
					states = UIStatStates,
				},
				
				{
					class = "Timer",
					duration = 300,
				}
			},
		},

		UW_KOBAN_NUM,
		UW_COIN_NUM,

		{
            class = "PuzzlePicture",
            name = "StatText",
            x = 0,
            y = 0,
            
            components =
            {
				{
					class = "PuzzleCompositeSprite",
					images = 
					{ 
						{ "ui_stat_score", true, 78, 126 },
						{ "ui_stat_title_01", true, 151, 79 },
					},
				},
            },
        },

        {
            class = "PuzzlePicture",
            x = 35,
            y = 15,
            name = "BestScoreEffect",
			doUpdate = true,
--			indie = true,
			axis = AXIS_X_CENTER,
            
            components =
            {
                {
                    class = "PuzzleAnimation",
                    anim = "ui_stat_bestscore",
                },
            },
        },
		
        {
            class = "PuzzlePicture",
            x = 305,
            y = 5,
            name = "BestScoreText",
            
            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_stat_record_prefix",
				},
            },
		},

        {
            class = "PuzzleNumber",
            name = "BestScoreNum",
			x = 390,
            y = 5,
			numberOffset = -4,
			--prefix = "prefix",
            
            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_stat_record_0",
				},
            },
        },

        {
            class = "PuzzleNumber",
            name = "DistanceNum",
            x = 290,
            y = 128,
			postfix = "m",
            
            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_stat_scorenumber_0",
				},
            },
        },
				
        {
            class = "PuzzleNumber",
            name = "CoinGetNum",
            x = 290,
            y = 158,
            
            components =
            {
				{
					class = "PuzzleSprite",
					image = "ui_stat_scorenumber_0",
				},
            },
        },
				
        {
            class = "PuzzleNumber",
            name = "ScoreNum",
            x = 290,
            y = 209,
			doUpdate = true,
			
			components =
			{
                {
                    class = "PuzzleSprite",
                    image = "ui_stat_scorenumber_0",
                },
				
				{
					class = "TimeBasedInterpolator",
				},
			},
        },

        {
            class = "PuzzlePicture",
            x = 20,
            y = 40,
            name = "Avatar",
            
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "avatar_ninjagirl_move_01",
                },
            },
        },

		{
			class = "PuzzleButton",
			name = "Skip",
			width = SCREEN_UNIT_X,
			height = SCREEN_UNIT_Y,
			transparent = true,
			
			onMouseUp = function(x, y)
				SkipGameStat();
			end,
		},
	
		{
			class = "PuzzleButton",
			name = "Twitter",
			x = 12,
			y = 267,
			
			onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
--[[ @OLD				
				OpenTwitter();
--]]
				if (GameKit.GetUserLanguage() == "zh-Hans") then
					ComposeSocialMessage(GAO_SOCIAL_SINAWEIBO);
				else
					ComposeSocialMessage(GAO_SOCIAL_TWITTER);
				end
			end,
		
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_stat_twitter",
				},
			},
		},

		{
			class = "PuzzleButton",
			name = "Facebook",
			x = 74,
			y = 267,
			
			onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
--[[ @OLD				
				OpenFacebook();
--]]				
				ComposeSocialMessage(GAO_SOCIAL_FACEBOOK);
			end,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_stat_facebook",
				},
			},
		},
	
		{
			class = "PuzzleButton",
			name = "Gamecenter",
			x = 136,
			y = 267,
			
			onMouseUp = function(x, y)
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				ShowLeaderboard();
			end,
		
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_stat_gamecenter",
				},
			},
		},

		{
			class = "PuzzleButton",
			name = "Again",
			x = 218,
			y = 265,
			
			onMouseUp = function(x, y)
				GameKit.LogEventWithParameter("GameStat", "again", "action", false);

				GotoScrollSelect();
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,
			
			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_stat_button_again",
				},
			},
		},		

		{
			class = "PuzzleButton",
			name = "Shop",
			x = 353,
			y = 265,
			
			onMouseUp = function(x, y)
				GameKit.LogEventWithParameter("GameStat", "shop", "action", false);

				GotoShop();
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

			components =
			{
				{
					class = "PuzzleCompositeSprite",
					indie = true,
					images = 
					{ 
						{ "ui_stat_button_shop", true },
						{ "ui_shop_tip1", true, 82 * APP_SCALE_FACTOR, 0 },
					},
				},
			},
		},
		
		{
			class = "PuzzleButton",
			name = "Exit",
			x = UI_BUTTON_POS[1],
			y = 267,
			
			onMouseUp = function(x, y)
				GotoMapSelect();
				AudioManager:PlaySfx(SFX_UI_BUTTON_1);
			end,

            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_button_back",
                },
			},
		},		
	},

	groups =
	{
		AllWidgets = { "Again", "Shop", "DistanceNum", "CoinGetNum", "ScoreNum", "StatText", "Avatar",
					   "BestScoreEffect", "BestScoreText", "BestScoreNum", "Facebook", "Twitter", "Gamecenter", "Exit" },
		ButtonWidgets = { "Shop", "Again", "Twitter", "Gamecenter", "Facebook", "Exit" },
		SkipWidgets = { "DistanceNum", "CoinGetNum", "ScoreNum" },
	},
};

-------------------------------------------------------------------------
UI_REVIVE_POS = { 165, 200 };

GameUITemplate
{
	name = "Revive",
	x = UI_REVIVE_POS[1],
	y = UI_REVIVE_POS[2],
	modal = MODAL_MODE_NOBACKDROP,
	reloadable = true,
	textures = { "ui_revive.png" },
	axis = AXIS_X_CENTER,
	--axisOffset = 75,
	indie = true,

	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_revive",
		},
		
		{
			class = "LinearMotion",
			velocity = 400 * APP_SCALE_FACTOR,
		},
		
		{
			class = "Timer",
			duration = REVIVE_WAIT_DURAION,
		},
		
		{
			class = "StateMachine",
			states = UIReviveStates,
		},
	},

	widgets =
	{
        {
			class = "PuzzleButton",
			name = "Action",
			x = 0,
			y = 0,
			width = 182 * APP_SCALE_FACTOR,
			height = 74 * APP_SCALE_FACTOR,
			transparent = true,
			
            onMouseUp = function(x, y)
				ReviveGame(true);
			end,
		},	
	
		{
			class = "PuzzleNumber",
			name = "Cost",
			x = 98,
			y = 43,
			value = 1,
			numberOffset = -1,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_revive_number0",
				},
			},
		},

		{
			class = "PuzzleProgressbar",
			name = "Clock",
			x = 45,
			y = 70,
			maxValue = 100,
			value = 100,
			doUpdate = true,
		
			components =
			{
				{
					class = "PuzzleCompositeSprite",
					primary = 2,
					images = 
					{ 
						{ "ui_revive_base", true },
						{ "ui_revive_progress", true, 0, 0 },
					},
				},
				
				{
					class = "TimeBasedInterpolator",
				},
			},
		},
	},
};

-------------------------------------------------------------------------
UI_BOOST_POS = { 320, 45 };

GameUITemplate
{
	name = "Boost",
	x = UI_BOOST_POS[1],
	y = UI_BOOST_POS[2],
	transparent = true,
	reloadable = true,
	textures = { "ui_revive.png" },
	axis = AXIS_X_CENTER,
	axisOffset = 160,
	indie = true,

	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_headstart",
		},
		
		{
			class = "LinearMotion",
			velocity = 400 * APP_SCALE_FACTOR,
		},
		
		{
			class = "Timer",
			duration = BOOST_WAIT_DURAION,
		},
		
		{
			class = "StateMachine",
			states = UIBoostStates,
		},
	},

	widgets =
	{
        {
			class = "PuzzleButton",
			name = "Action",
			x = 0,
			y = 0,
			width = 182 * APP_SCALE_FACTOR,
			height = 74 * APP_SCALE_FACTOR,
			transparent = true,
			
            onMouseUp = function(x, y)
				LevelManager:BoostDistanceByCoin();
			end,
		},	

		{
			class = "PuzzleNumber",
			name = "Cost",
			x = 93,
			y = 43,
			value = 1,
			numberOffset = -1,
			
			components = 
			{
				{
					class = "PuzzleSprite",
					image = "ui_revive_number0",
				},
			},
		},
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "Tutorial",
	transparent = true,
	reloadable = true,
	textures = { "ui_tutorial.png", "ui_tutorial_weapon.png", "ui_tip.png" },

	widgets =
	{
		{
            class = "PuzzlePicture",
            name = "Screen",
			x = 0,
			y = 0,

            components = 
            {
				{
					class = "PuzzleSprite",
					image = "ui_tutorial_step1",
				},
			},
		},

		{
            class = "PuzzlePicture",
            name = "Dialog",
			x = 265,
			y = 20,
			doUpdate = true,

            components = 
            {
				{
					class = "PuzzleCompositeSprite",
					images =
					{
						{ "ui_tutorial_redword_dialog", true, 0, 0 },
						{ "ui_tutorial_redword_dialog1", true, 13 * APP_SCALE_FACTOR, 15 * APP_SCALE_FACTOR },
					},
					primary = 2,
					indie = true,
				},

				{
					class = "TimeBasedInterpolator",
				},
			},
		},

		{
            class = "PuzzlePicture",
            name = "Hand",
			x = 200,
			y = 200,
			doUpdate = true,

            components = 
            {
				{
					class = "PuzzleSprite",
					image = "ui_tutorial_hand_slash",
				},
				
				{
					class = "StateMachine",
					states = UITutorialHandStates,
				},
				
				{
					class = "LinearMotion",
					velocity = 150,
				},
				
				{
					class = "Timer",
					duration = 1200,
				}
			},
		},
		
		{
            class = "PuzzlePicture",
            name = "Ending",
			--x = 68,
			--y = 103,
			--indie = true,
			axis = AXIS_XY_CENTER,
			doUpdate = true,

            components = 
            {
				{
					class = "PuzzleSprite",
					image = "ui_tutorial_redword_system6",
				},

				{
					class = "TimeBasedInterpolator",
				},
			},
		},
		
		{
            class = "PuzzlePicture",
            name = "Message",
			x = 120,
			y = 277,
			doUpdate = true,

            components = 
            {
				{
					class = "PuzzleSprite",
					image = "ui_tutorial_redword_system2",
				},

				{
					class = "TimeBasedInterpolator",
				},
			},
		},

		{
            class = "PuzzlePicture",
            name = "Continue",
			x = 160,
			y = 277,
			doUpdate = true,

            components = 
            {
				{
					class = "PuzzleSprite",
					image = "ui_tutorial_redword_system1",
				},

				{
					class = "TimeBasedInterpolator",
				},
			},
		},
	},

	groups =
	{
		AllWidgets = { "Screen", "Dialog", "Hand", "Ending", "Message", "Continue" },
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "Wait",
	modal = MODAL_MODE_NORMAL,
	axis = AXIS_XY_CENTER,
	indie = true,
	reloadable = true,
	--transparent = true,
	textures = { "ui_wait.png" },

    components =
    {
		{
			class = "PuzzleSprite",
			image = "ui_wait_scroll",
		},
	},

	widgets =
	{
        {
            class = "PuzzlePicture",
            name = "Content",
			x = 98,
			y = 36,
			doUpdate = true,
			
			components =
			{	
				{
					class = "PuzzleAnimation",
					anim = "ui_wait_ninja",
					animating = true,
				},
		
				{
					class = "StateMachine",
					states = UIWaitStates,
				},
				
				{
					class = "Timer",
					duration = 1000,
				},
			},
		},
		
        {
            class = "PuzzlePicture",
            name = "Dot",
			x = 167,
			y = 100,
			doUpdate = true,
			
			components =
			{	
				{
					class = "PuzzleAnimation",
					anim = "ui_wait_dot",
					animating = true,
				},
			},
		},
	},
};

-------------------------------------------------------------------------
UI_FEEDBACK_POS = { 69, 51 };

GameUITemplate
{
	name = "SendFeedback",
	x = UI_FEEDBACK_POS[1],
	y = UI_FEEDBACK_POS[2],
	modal = MODAL_MODE_NORMAL,
	reloadable = true,
	textures = { "ui_feedback.png" },
	indie = true,
	axis = AXIS_XY_CENTER,

    components =
    {
        {
            class = "PuzzleSprite",
			image = "ui_feedback_background",
			blendMode = GraphicsEngine.BLEND_FADEOUT,
        },
		
		{
			class = "TimeBasedInterpolator",
		}
	},

	widgets =
	{
        {
            class = "PuzzlePicture",
            name = "Title",
			x = 97,
			y = 40,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_feedback_title_help",
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
			},
        },

        {
            class = "PuzzlePicture",
            name = "Char",
			x = 239,
			y = -30,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_feedback_greenninja",
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
			},
        },

        {
            class = "PuzzleButton",
            name = "Option1",
			x = 64,
			y = 66,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_feedback_button_feedback",
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
			},

            onMouseUp = function()
                AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				SendFeedbackOption1();
            end,
        },

        {
            class = "PuzzleButton",
            name = "Option2",
			x = 64,
			y = 121,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_feedback_button_bomb",
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
			},

            onMouseUp = function()
                AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				SendFeedbackOption2();
			end,
        },

        {
            class = "PuzzleButton",
            name = "Skip",
			x = 278,
			y = 185,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_feedback_skip",
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
			},

            onMouseUp = function()
                AudioManager:PlaySfx(SFX_UI_BUTTON_2);
				StageManager:PopStageForPopup();
			end,
        },
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "SendLove",
	x = UI_FEEDBACK_POS[1],
	y = UI_FEEDBACK_POS[2],
	modal = MODAL_MODE_NORMAL,
	reloadable = true,
	textures = { "ui_feedback.png" },
	indie = true,
	axis = AXIS_XY_CENTER,

    components =
    {
        {
            class = "PuzzleSprite",
			image = "ui_feedback_background",
			blendMode = GraphicsEngine.BLEND_FADEOUT,
        },

        {
            class = "Attribute",
        },
		
		{
			class = "TimeBasedInterpolator",
		}
	},

	widgets =
	{
        {
            class = "PuzzlePicture",
            name = "Title",
			x = 97,
			y = 40,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_feedback_title_thank",
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
			},
        },

        {
            class = "PuzzlePicture",
            name = "Char",
			x = 239,
			y = -30,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_feedback_blueninja",
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
			},
        },

        {
            class = "PuzzleButton",
			name = "Option1",
			x = 64,
			y = 66,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_feedback_button_dent",
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
			},

            onMouseUp = function()
                AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				SendLoveOption1();
            end,
        },

        {
            class = "PuzzleButton",
			name = "Option2",
			x = 64,
			y = 121,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_feedback_button_twitter",
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
			},

            onMouseUp = function()
                AudioManager:PlaySfx(SFX_UI_BUTTON_1);
				SendLoveOption2();
            end,
        },

        {
            class = "PuzzleButton",
            name = "Skip",
			x = 278,
			y = 185,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_feedback_skip",
					blendMode = GraphicsEngine.BLEND_FADEOUT,
				},
			},

            onMouseUp = function()
                AudioManager:PlaySfx(SFX_UI_BUTTON_2);
				StageManager:PopStageForPopup();
			end,
        },
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "Gift",
	modal = MODAL_MODE_NORMAL,
	axis = AXIS_XY_CENTER,
	indie = true,
	reloadable = true,
	textures = { "ui_avatar.png", "ui_dialog.png", "ui_gift.png", "ui_particle.png" },

    components =
    {
		{
			class = "PuzzleSprite",
			image = "ui_gift",
		},
	},

	widgets =
	{
        {
            class = "PuzzlePicture",
            name = "AvatarShine",
            x = 120,
            y = 20,
            doUpdate = true,
			indie = true,
			
            components =
            {
                {
                    class = "PuzzleSprite",
                    image = "ui_unlocked_shine",
                },
				
				{
					class = "TimeBasedInterpolator",
				},
            },
        },

        {
            class = "PuzzlePicture",
            name = "AvatarIcon",
            x = 174,
            y = 68,
			indie = true,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ui_shopicon_avatar_charater05",
				},
			},
		},
		
        {
            class = "PuzzlePicture",
            name = "Paperfall",
            x = 137,
            y = 31,
            doUpdate = true,
			indie = true,
			
            components =
            {
                {
                    class = "PuzzleAnimation",
                    anim = "ui_particle_paperfall",
					animating = true,
                },
				
				{
					class = "TimeBasedInterpolator",
				},
            },
        },
		
        {
            class = "PuzzleButton",
            name = "Action",
			width = SCREEN_UNIT_X,
			height = SCREEN_UNIT_Y,
			transparent = true,
			indie = true,

            onMouseUp = function()
				GetPaidGift();
			end,
        },
	},
};

-------------------------------------------------------------------------
UI_BOSS_POS = { 145, 280 };
if (IS_DEVICE_IPAD or IS_PLATFORM_ANDROID) then
	UI_BOSSBK_OFFSET = { -3 + 1, -30 + 5};
else
	UI_BOSSBK_OFFSET = { -3, -30 };
end

GameUITemplate
{
	name = "BossLifebar",
	transparent = true,
	reloadable = true,
	textures = { "ui_boss.png" },
	--indie = true,

	components =
	{
		{
			class = "LinearMotion",
			velocity = 100 * APP_SCALE_FACTOR,
		},		
	},

	widgets =
	{
		{
			class = "PuzzlePicture",
			name = "BossBarFire",
			x = UI_BOSS_POS[1] + UI_BOSSBK_OFFSET[1],
			y = UI_BOSS_POS[2] + UI_BOSSBK_OFFSET[2],
			doUpdate = true,

			components =
			{
				{
					class = "PuzzleAnimation",
					anim = "ui_boss_lifebarfire",
					animating = true,
				},
				
				{
					class = "LinearMotion",
					velocity = 120,
				},
			},
		},

		{
			class = "PuzzleProgressbar",
			name = "BossBar",
			x = UI_BOSS_POS[1],
			y = UI_BOSS_POS[2],
			maxValue = 100,
			value = 0,
			doUpdate = true,
		
			components =
			{
				{
					class = "PuzzleCompositeSprite",
					indie = true,
					primary = 2,
					images = 
					{ 
						{ "ui_boss_lifebar_base", true },
						{ "ui_boss_lifebar_life", true, 31 * APP_SCALE_FACTOR, 8 * APP_SCALE_FACTOR },
					},
				},
		
				{
					class = "TimeBasedInterpolator",
				},
				
				{
					class = "LinearMotion",
					velocity = 120,
				},
				
				{
					class = "Shaker",
					minValue = 1,
					maxValue = 3,
					count = 4,
					velocity = 1000,
				},
			},
		},
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "MoviePlayback",
	transparent = true,

	widgets =
	{
	},
};

-------------------------------------------------------------------------
GameUITemplate
{
	name = "Ad",
	x = 0,
	y = 0,
	transparent = true,
--	reloadable = true,
--	textures = { "ui_ad.png", },

	components =
	{
	},

	widgets =
	{
		{
			class = "PuzzleButton",
			name = "Banner",
			x = 0,
			y = 270,
			axis = AXIS_X_CENTER,
			doUpdate = true,

			onMouseUp = function(x, y)
				local index = UIManager:GetWidgetComponent("Ad", "Banner", "Attribute"):Get("AdIndex");
				if (index) then
					AudioManager:PlaySfx(SFX_UI_BUTTON_1);
					
					if (index == 1) then
						GameKit.LogEventWithParameter("AdBanner", "BonniesBrunch2", "click", false);
					else
						GameKit.LogEventWithParameter("AdBanner", "BurnTheCorn", "click", false);
					end

					ExitAd();
					AD_BANNER_CALLBACK[index]();
				end
			end,

			components =
			{
				{
					class = "PuzzleSprite",
					image = "ad_banner_01",
				},
				
				{
					class = "LinearMotion",
					velocity = 180,
				},
				
				{
					class = "Attribute",
				},
			},
		},
	},
};


-------------------------------------------------------------------------
GameUITemplate
{
	name = "ChallengeRule",
	modal = MODAL_MODE_NORMAL,
	axis = AXIS_XY_CENTER,
	indie = true,
	reloadable = true,
	textures = { "ui_challenge.png" },

	components =
	{
		{
			class = "PuzzleSprite",
			image = "ui_challenge",
		},
	},

	widgets =
	{
        {
			class = "PuzzleButton",
			name = "OK",
			x = 0,
			y = 0,
			width = SCREEN_UNIT_X,
			height = SCREEN_UNIT_Y,
			transparent = true,
			
            onMouseUp = function()
				StageManager:ChangeStage("ScrollSelectAction");
			end,
		},
	},
};
