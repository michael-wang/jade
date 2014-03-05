--***********************************************************************
-- @file GameAudio.lua
--***********************************************************************

SFX_UI_BUTTON_1 = 1001;
SFX_UI_BUTTON_2 = 1002;
SFX_UI_BUTTON_3 = 1003;
SFX_UI_SWITCH_WEAPON_1 = 2001;
SFX_UI_SWITCH_WEAPON_2 = 2002;
SFX_UI_SWITCH_WEAPON_3 = 2003;
SFX_UI_SWITCH_WEAPON = { 2001, 2002, 2003 };
SFX_UI_WEAPON_SLOT = { 2002, 2003 };
SFX_UI_WEAPON_KATANA_1 = 2011;
SFX_UI_WEAPON_KATANA_2 = 2012;
SFX_UI_WEAPON_BLADE_1 = 2013;
SFX_UI_WEAPON_BLADE_2 = 2014;
SFX_UI_WEAPON_SPEAR_1 = 2015;
SFX_UI_WEAPON_SPEAR_2 = 2016;
SFX_UI_WEAPON_CRITICAL = 2017;
SFX_UI_LEVEL_MEDAL = 2018;
SFX_UI_MONEY_REFUND = 2019;
SFX_UI_MONEY_SPEND = 2020;
SFX_UI_MONEY_GAIN = 2021;
SFX_UI_WOOD_DOOR_OPEN = 2022;
SFX_UI_WOOD_DOOR_CLOSE = 2023;
SFX_UI_IRON_DOOR_OPEN = 2024;
SFX_UI_IRON_DOOR_CLOSE = 2025;
SFX_UI_STAT_ACCUM = 2026;
SFX_UI_START_GAME = 2027;
SFX_UI_BEST_SCORE = 2028;
SFX_UI_REVIVE = 2029;
SFX_UI_WARNING = 2030;
SFX_UI_WEAPON_LIGHTSABER = 2031;
SFX_UI_ACH = 2032;

SFX_OBJECT_NO_ENERGY = 3001;
SFX_OBJECT_BOMB = 3002;
SFX_OBJECT_COIN = 3003;
SFX_OBJECT_BOOST = 3004;
SFX_OBJECT_JADE = 3005;
SFX_OBJECT_SPEEDBOOST = 3006;
SFX_OBJECT_BOMB_LOOP = 3007;
SFX_OBJECT_TRAP_SHOW = 3008;
SFX_OBJECT_TRAP_ON = 3009;
SFX_OBJECT_COIN_LV1 = 3011;
SFX_OBJECT_COIN_LV2 = 3012;
SFX_OBJECT_COIN_LV3 = 3013;
SFX_OBJECT_COINS = { 3011, 3012, 3012, 3013, 3013 };

SFX_SCROLL_USE = 4001;
SFX_SCROLL_CIRCLE = 4002;
SFX_SCROLL_SYMBOL = 4003;
SFX_SCROLL_HEAL_LIFE = 4004;
SFX_SCROLL_HEAL_ENERGY = 4005;
SFX_SCROLL_SHIELD_HIT = 4006;
SFX_SCROLL_SHIELD_ON = 4007;
--SFX_SCROLL_POISON = 4008;
SFX_SCROLL_FREEZE = 4008;
SFX_SCROLL_METEOR_ENTER = 4009;
SFX_SCROLL_METEOR_HIT = 4010;
SFX_SCROLL_METEOR_EXIT = 4011;


SFX_CHAR_AVATAR_FEMALE_WOUNDED_1 = 5001;
SFX_CHAR_AVATAR_FEMALE_WOUNDED_2 = 5002;
SFX_CHAR_AVATAR_FEMALE_WOUNDED = { 5001, 5002 };
SFX_CHAR_AVATAR_MALE_WOUNDED_1 = 5003;
SFX_CHAR_AVATAR_MALE_WOUNDED_2 = 5004;
SFX_CHAR_AVATAR_MALE_WOUNDED = { 5003, 5004 };

SFX_CHAR_INNOCENT_MAN = 5101;
SFX_CHAR_INNOCENT_WOMAN = 5102;
SFX_CHAR_INNOCENT_ELDER = 5103;
SFX_CHAR_SKILL_BLOCK = 5104;
SFX_CHAR_SKILL_HEAL = 5105;
SFX_CHAR_SKILL_INVINCIBLE = 5106;

SFX_CHAR_NINJA_WOUNDED_1 = 5111;
SFX_CHAR_NINJA_WOUNDED_2 = 5112;
SFX_CHAR_NINJA_WOUNDED_3 = 5113;
SFX_CHAR_NINJA_WOUNDED_4 = 5114;
SFX_CHAR_NINJA_WOUNDED_5 = 5115;
SFX_CHAR_NINJA_WOUNDED_6 = 5116;
SFX_CHAR_NINJA_WOUNDED = { 5111, 5112, 5113, 5114, 5115, 5116 };

SFX_CHAR_ANIMAL_WOUNDED_1 = 5121;
SFX_CHAR_ANIMAL_WOUNDED_2 = 5122;
SFX_CHAR_ANIMAL_WOUNDED_3 = 5123;
SFX_CHAR_ANIMAL_WOUNDED = { 5121, 5122, 5123 };

SFX_CHAR_UNDEAD_WOUNDED_1 = 5131;
SFX_CHAR_UNDEAD_WOUNDED_2 = 5132;
SFX_CHAR_UNDEAD_WOUNDED = { 5131, 5132 };

SFX_CHAR_GIANT_WOUNDED_1 = 5141;
SFX_CHAR_GIANT_WOUNDED_2 = 5142;
SFX_CHAR_GIANT_WOUNDED = { 5141, 5142 };

SFX_CHAR_OBJECT_WOUNDED_1 = 5151;
SFX_CHAR_OBJECT_WOUNDED = { 5151 };

SFX_CHAR_NINJA_SKILL_1 = 5161;
SFX_CHAR_NINJA_SKILL_2 = 5162;
SFX_CHAR_NINJA_SKILL_3 = 5163;
SFX_CHAR_NINJA_SKILL = { 5161, 5162, 5163 };
SFX_CHAR_DEAD_SKILL_1 = 5171;
SFX_CHAR_DEAD_SKILL_2 = 5172;
SFX_CHAR_DEAD_SKILL = { 5171, 5172 };

SFX_CHAR_NINJA_ESCAPE = 5201;
SFX_CHAR_NINJA_BOMB = 5202;
SFX_CHAR_KABUKI_TRAP = 5203;

SFX_ENEMY_ATTACK_MELEE_LIGHT = 5212;
SFX_ENEMY_ATTACK_MELEE_HEAVY = 5213;
SFX_ENEMY_ATTACK_BULLET_LIGHT = 5214;
SFX_ENEMY_ATTACK_BULLET_HEAVY = 5215;
SFX_ENEMY_ATTACK_BULLET_GUN = 5216;

-------------------------------------------------------------------------
AudioManager =
{
    m_Sfx = {},
    m_Bgm = {},
	m_LoopingSfx = {},
	m_CurrentLoopingSfx = {},
	
	m_SfxEnabled = true,
	m_BgmEnabled = true,
	m_SfxListeners = nil,
	m_BgmListeners = nil,
	m_CurrentBgm = nil,
	
	---------------------------------------------------------------------
    Create = function(self)
        local sfxList = {};
        if IS_PLATFORM_ANDROID then
	        sfxList = {
	            { SFX_UI_BUTTON_1, "sfx_ui_button.ogg" },
	            { SFX_UI_BUTTON_2, "sfx_ui_cancel.ogg" },
				{ SFX_UI_BUTTON_3, "sfx_ui_motion.ogg" },
				
	            { SFX_UI_SWITCH_WEAPON_1, "sfx_ui_switch_weapon1.ogg" },
	            { SFX_UI_SWITCH_WEAPON_2, "sfx_ui_switch_weapon2.ogg" },
	            { SFX_UI_SWITCH_WEAPON_3, "sfx_ui_switch_weapon3.ogg" },
	            { SFX_UI_WEAPON_KATANA_1, "sfx_weapon_katana1.ogg" },
	            { SFX_UI_WEAPON_KATANA_2, "sfx_weapon_katana2.ogg" },
	            { SFX_UI_WEAPON_BLADE_1, "sfx_weapon_blade1.ogg" },
	            { SFX_UI_WEAPON_BLADE_2, "sfx_weapon_blade2.ogg" },
	            { SFX_UI_WEAPON_SPEAR_1, "sfx_weapon_spear1.ogg" },
	            { SFX_UI_WEAPON_SPEAR_2, "sfx_weapon_spear2.ogg" },
				{ SFX_UI_WEAPON_CRITICAL, "sfx_weapon_critical.ogg" },
				{ SFX_UI_LEVEL_MEDAL, "sfx_ui_level_medal.ogg" },
				{ SFX_UI_MONEY_REFUND, "sfx_ui_money_refund.ogg" },
				{ SFX_UI_MONEY_SPEND, "sfx_ui_money_spend.ogg" },
				{ SFX_UI_MONEY_GAIN, "sfx_ui_money_gain.ogg" },
				{ SFX_UI_WOOD_DOOR_OPEN, "sfx_ui_wood_door_open.ogg" },
				{ SFX_UI_WOOD_DOOR_CLOSE, "sfx_ui_wood_door_close.ogg" },
				{ SFX_UI_IRON_DOOR_OPEN, "sfx_ui_iron_door_open.ogg" },
				{ SFX_UI_IRON_DOOR_CLOSE, "sfx_ui_iron_door_close.ogg" },
	            { SFX_UI_STAT_ACCUM, "sfx_ui_stat_accum.ogg" },
				{ SFX_UI_START_GAME, "sfx_ui_start_game.ogg" },
				{ SFX_UI_BEST_SCORE, "sfx_ui_best_score.ogg" },
				{ SFX_UI_REVIVE, "sfx_ui_revive.ogg" },
				{ SFX_UI_WARNING, "sfx_ui_warning.ogg" },
				{ SFX_UI_WEAPON_LIGHTSABER, "sfx_weapon_lightsaber.ogg" },
				{ SFX_UI_ACH, "sfx_ui_achievement.ogg" },
				
				{ SFX_OBJECT_NO_ENERGY, "sfx_object_no_energy.ogg" },
				{ SFX_OBJECT_BOMB, "sfx_object_bomb.ogg" },
	            --{ SFX_OBJECT_COIN, "sfx_object_coin.caf" },
				{ SFX_OBJECT_COIN, "sfx_ui_coin4.ogg" },
				{ SFX_OBJECT_COIN_LV1, "sfx_ui_coin1.ogg" },
				{ SFX_OBJECT_COIN_LV2, "sfx_ui_coin3.ogg" },
				{ SFX_OBJECT_COIN_LV3, "sfx_ui_coin5.ogg" },
				{ SFX_OBJECT_BOOST, "sfx_object_boost.ogg" },
				{ SFX_OBJECT_JADE, "sfx_object_jade.ogg" },
				{ SFX_OBJECT_SPEEDBOOST, "sfx_object_speedboost.ogg" },
				{ SFX_OBJECT_BOMB_LOOP, "sfx_object_bomb_on.ogg", true },
				{ SFX_OBJECT_TRAP_SHOW, "sfx_object_trap_show.ogg" },
				{ SFX_OBJECT_TRAP_ON, "sfx_object_trap_on.ogg" },
				
	            { SFX_SCROLL_USE, "sfx_scroll_use.ogg" },
	            { SFX_SCROLL_CIRCLE, "sfx_scroll_circle.ogg" },
	            { SFX_SCROLL_SYMBOL, "sfx_scroll_symbol.ogg" },
	            { SFX_SCROLL_HEAL_LIFE, "sfx_scroll_heal_life.ogg" },
	            { SFX_SCROLL_HEAL_ENERGY, "sfx_scroll_heal_energy.ogg" },
				{ SFX_SCROLL_SHIELD_HIT, "sfx_scroll_shield_hit.ogg" },
				{ SFX_SCROLL_SHIELD_ON, "sfx_scroll_shield_loop.ogg", true },
				{ SFX_SCROLL_FREEZE, "sfx_scroll_freeze_loop.ogg", true },
				{ SFX_SCROLL_METEOR_ENTER, "sfx_scroll_fireball_start.ogg" },
				{ SFX_SCROLL_METEOR_HIT, "sfx_scroll_fireball_explode.ogg" },
				{ SFX_SCROLL_METEOR_EXIT, "sfx_scroll_fireball_finish.ogg" },

				{ SFX_CHAR_AVATAR_FEMALE_WOUNDED_1, "sfx_char_avatar_female_wounded1.ogg" },
				{ SFX_CHAR_AVATAR_FEMALE_WOUNDED_2, "sfx_char_avatar_female_wounded2.ogg" },
				{ SFX_CHAR_AVATAR_MALE_WOUNDED_1, "sfx_char_avatar_male_wounded1.ogg" },
				{ SFX_CHAR_AVATAR_MALE_WOUNDED_2, "sfx_char_avatar_male_wounded2.ogg" },
				
	            { SFX_CHAR_INNOCENT_MAN, "sfx_char_innocent_male.ogg" },
	            { SFX_CHAR_INNOCENT_WOMAN, "sfx_char_innocent_female.ogg" },
	            { SFX_CHAR_INNOCENT_ELDER, "sfx_char_innocent_oldfemale.ogg" },
	            { SFX_CHAR_SKILL_BLOCK, "sfx_char_skill_block.ogg" },
	            { SFX_CHAR_SKILL_HEAL, "sfx_char_skill_heal.ogg" },
				{ SFX_CHAR_SKILL_INVINCIBLE, "sfx_char_animal_skill.caf" },
				{ SFX_CHAR_NINJA_WOUNDED_1, "sfx_char_ninja_wounded1.ogg" },
				{ SFX_CHAR_NINJA_WOUNDED_2, "sfx_char_ninja_wounded2.ogg" },
				{ SFX_CHAR_NINJA_WOUNDED_3, "sfx_char_ninja_wounded3.ogg" },
				{ SFX_CHAR_NINJA_WOUNDED_4, "sfx_char_ninja_wounded4.ogg" },
				{ SFX_CHAR_NINJA_WOUNDED_5, "sfx_char_ninja_wounded5.ogg" },
				{ SFX_CHAR_NINJA_WOUNDED_6, "sfx_char_ninja_wounded6.ogg" },
				{ SFX_CHAR_ANIMAL_WOUNDED_1, "sfx_char_animal_wounded1.ogg" },
				{ SFX_CHAR_ANIMAL_WOUNDED_2, "sfx_char_animal_wounded2.ogg" },
				{ SFX_CHAR_ANIMAL_WOUNDED_3, "sfx_char_animal_wounded3.ogg" },
				{ SFX_CHAR_UNDEAD_WOUNDED_1, "sfx_char_undead_wounded1.ogg" },
				{ SFX_CHAR_UNDEAD_WOUNDED_2, "sfx_char_undead_wounded2.ogg" },
				{ SFX_CHAR_GIANT_WOUNDED_1, "sfx_char_giant_wounded1.ogg" },
				{ SFX_CHAR_GIANT_WOUNDED_2, "sfx_char_giant_wounded2.ogg" },
				{ SFX_CHAR_OBJECT_WOUNDED_1, "sfx_char_object_wounded.ogg" },
				{ SFX_CHAR_NINJA_SKILL_1, "sfx_char_ninja_skill1.ogg" },
				{ SFX_CHAR_NINJA_SKILL_2, "sfx_char_ninja_skill2.ogg" },
				{ SFX_CHAR_NINJA_SKILL_3, "sfx_char_ninja_skill3.ogg" },
				{ SFX_CHAR_DEAD_SKILL_1, "sfx_char_undead_skill1.ogg" },
				{ SFX_CHAR_DEAD_SKILL_2, "sfx_char_undead_skill2.ogg" },
				{ SFX_CHAR_NINJA_ESCAPE, "sfx_char_ninja_escape.ogg" },
				{ SFX_CHAR_NINJA_BOMB, "sfx_char_ninja_bomb.ogg" },
				{ SFX_CHAR_KABUKI_TRAP, "sfx_char_kabuki_trap.ogg" },
				
				{ SFX_ENEMY_ATTACK_MELEE_LIGHT, "sfx_char_melee_light_hit.ogg" },
				{ SFX_ENEMY_ATTACK_MELEE_HEAVY, "sfx_char_melee_heavy_hit.ogg" },
				{ SFX_ENEMY_ATTACK_BULLET_LIGHT, "sfx_char_bullet_light_hit.ogg" },
				{ SFX_ENEMY_ATTACK_BULLET_HEAVY, "sfx_char_bullet_heavy_hit.ogg" },
				{ SFX_ENEMY_ATTACK_BULLET_GUN, "sfx_char_bullet_heavy_gun.ogg" },
	        };
	    else -- not IS_PLATFORM_ANDROID
	        sfxList = {
	            { SFX_UI_BUTTON_1, "sfx_ui_button.caf" },
	            { SFX_UI_BUTTON_2, "sfx_ui_cancel.caf" },
				{ SFX_UI_BUTTON_3, "sfx_ui_motion.caf" },
				
	            { SFX_UI_SWITCH_WEAPON_1, "sfx_ui_switch_weapon1.caf" },
	            { SFX_UI_SWITCH_WEAPON_2, "sfx_ui_switch_weapon2.caf" },
	            { SFX_UI_SWITCH_WEAPON_3, "sfx_ui_switch_weapon3.caf" },
	            { SFX_UI_WEAPON_KATANA_1, "sfx_weapon_katana1.caf" },
	            { SFX_UI_WEAPON_KATANA_2, "sfx_weapon_katana2.caf" },
	            { SFX_UI_WEAPON_BLADE_1, "sfx_weapon_blade1.caf" },
	            { SFX_UI_WEAPON_BLADE_2, "sfx_weapon_blade2.caf" },
	            { SFX_UI_WEAPON_SPEAR_1, "sfx_weapon_spear1.caf" },
	            { SFX_UI_WEAPON_SPEAR_2, "sfx_weapon_spear2.caf" },
				{ SFX_UI_WEAPON_CRITICAL, "sfx_weapon_critical.caf" },
				{ SFX_UI_LEVEL_MEDAL, "sfx_ui_level_medal.caf" },
				{ SFX_UI_MONEY_REFUND, "sfx_ui_money_refund.caf" },
				{ SFX_UI_MONEY_SPEND, "sfx_ui_money_spend.caf" },
				{ SFX_UI_MONEY_GAIN, "sfx_ui_money_gain.caf" },
				{ SFX_UI_WOOD_DOOR_OPEN, "sfx_ui_wood_door_open.caf" },
				{ SFX_UI_WOOD_DOOR_CLOSE, "sfx_ui_wood_door_close.caf" },
				{ SFX_UI_IRON_DOOR_OPEN, "sfx_ui_iron_door_open.caf" },
				{ SFX_UI_IRON_DOOR_CLOSE, "sfx_ui_iron_door_close.caf" },
	            { SFX_UI_STAT_ACCUM, "sfx_ui_stat_accum.caf" },
				{ SFX_UI_START_GAME, "sfx_ui_start_game.caf" },
				{ SFX_UI_BEST_SCORE, "sfx_ui_best_score.caf" },
				{ SFX_UI_REVIVE, "sfx_ui_revive.caf" },
				{ SFX_UI_WARNING, "sfx_ui_warning.caf" },
				{ SFX_UI_WEAPON_LIGHTSABER, "sfx_weapon_lightsaber.caf" },
				{ SFX_UI_ACH, "sfx_ui_achievement.caf" },
				
				{ SFX_OBJECT_NO_ENERGY, "sfx_object_no_energy.caf" },
				{ SFX_OBJECT_BOMB, "sfx_object_bomb.caf" },
	            --{ SFX_OBJECT_COIN, "sfx_object_coin.caf" },
				{ SFX_OBJECT_COIN, "sfx_ui_coin4.wav" },
				{ SFX_OBJECT_COIN_LV1, "sfx_ui_coin1.wav" },
				{ SFX_OBJECT_COIN_LV2, "sfx_ui_coin3.wav" },
				{ SFX_OBJECT_COIN_LV3, "sfx_ui_coin5.wav" },
				{ SFX_OBJECT_BOOST, "sfx_object_boost.caf" },
				{ SFX_OBJECT_JADE, "sfx_object_jade.caf" },
				{ SFX_OBJECT_SPEEDBOOST, "sfx_object_speedboost.caf" },
				{ SFX_OBJECT_BOMB_LOOP, "sfx_object_bomb_on.caf", true },
				{ SFX_OBJECT_TRAP_SHOW, "sfx_object_trap_show.caf" },
				{ SFX_OBJECT_TRAP_ON, "sfx_object_trap_on.caf" },
				
	            { SFX_SCROLL_USE, "sfx_scroll_use.caf" },
	            { SFX_SCROLL_CIRCLE, "sfx_scroll_circle.caf" },
	            { SFX_SCROLL_SYMBOL, "sfx_scroll_symbol.caf" },
	            { SFX_SCROLL_HEAL_LIFE, "sfx_scroll_heal_life.caf" },
	            { SFX_SCROLL_HEAL_ENERGY, "sfx_scroll_heal_energy.caf" },
				{ SFX_SCROLL_SHIELD_HIT, "sfx_scroll_shield_hit.caf" },
				{ SFX_SCROLL_SHIELD_ON, "sfx_scroll_shield_loop.caf", true },
				--{ SFX_SCROLL_POISON, "sfx_scroll_poison_loop.caf", true },
				{ SFX_SCROLL_FREEZE, "sfx_scroll_freeze_loop.caf", true },
				{ SFX_SCROLL_METEOR_ENTER, "sfx_scroll_fireball_start.caf" },
				{ SFX_SCROLL_METEOR_HIT, "sfx_scroll_fireball_explode.caf" },
				{ SFX_SCROLL_METEOR_EXIT, "sfx_scroll_fireball_finish.caf" },

				{ SFX_CHAR_AVATAR_FEMALE_WOUNDED_1, "sfx_char_avatar_female_wounded1.caf" },
				{ SFX_CHAR_AVATAR_FEMALE_WOUNDED_2, "sfx_char_avatar_female_wounded2.caf" },
				{ SFX_CHAR_AVATAR_MALE_WOUNDED_1, "sfx_char_avatar_male_wounded1.caf" },
				{ SFX_CHAR_AVATAR_MALE_WOUNDED_2, "sfx_char_avatar_male_wounded2.caf" },
				
	            { SFX_CHAR_INNOCENT_MAN, "sfx_char_innocent_male.caf" },
	            { SFX_CHAR_INNOCENT_WOMAN, "sfx_char_innocent_female.caf" },
	            { SFX_CHAR_INNOCENT_ELDER, "sfx_char_innocent_oldfemale.caf" },
	            { SFX_CHAR_SKILL_BLOCK, "sfx_char_skill_block.caf" },
	            { SFX_CHAR_SKILL_HEAL, "sfx_char_skill_heal.caf" },
				{ SFX_CHAR_SKILL_INVINCIBLE, "sfx_char_animal_skill.caf" },
				{ SFX_CHAR_NINJA_WOUNDED_1, "sfx_char_ninja_wounded1.caf" },
				{ SFX_CHAR_NINJA_WOUNDED_2, "sfx_char_ninja_wounded2.caf" },
				{ SFX_CHAR_NINJA_WOUNDED_3, "sfx_char_ninja_wounded3.caf" },
				{ SFX_CHAR_NINJA_WOUNDED_4, "sfx_char_ninja_wounded4.caf" },
				{ SFX_CHAR_NINJA_WOUNDED_5, "sfx_char_ninja_wounded5.caf" },
				{ SFX_CHAR_NINJA_WOUNDED_6, "sfx_char_ninja_wounded6.caf" },
				{ SFX_CHAR_ANIMAL_WOUNDED_1, "sfx_char_animal_wounded1.caf" },
				{ SFX_CHAR_ANIMAL_WOUNDED_2, "sfx_char_animal_wounded2.caf" },
				{ SFX_CHAR_ANIMAL_WOUNDED_3, "sfx_char_animal_wounded3.caf" },
				{ SFX_CHAR_UNDEAD_WOUNDED_1, "sfx_char_undead_wounded1.caf" },
				{ SFX_CHAR_UNDEAD_WOUNDED_2, "sfx_char_undead_wounded2.caf" },
				{ SFX_CHAR_GIANT_WOUNDED_1, "sfx_char_giant_wounded1.caf" },
				{ SFX_CHAR_GIANT_WOUNDED_2, "sfx_char_giant_wounded2.caf" },
				{ SFX_CHAR_OBJECT_WOUNDED_1, "sfx_char_object_wounded.caf" },
				{ SFX_CHAR_NINJA_SKILL_1, "sfx_char_ninja_skill1.caf" },
				{ SFX_CHAR_NINJA_SKILL_2, "sfx_char_ninja_skill2.caf" },
				{ SFX_CHAR_NINJA_SKILL_3, "sfx_char_ninja_skill3.caf" },
				{ SFX_CHAR_DEAD_SKILL_1, "sfx_char_undead_skill1.caf" },
				{ SFX_CHAR_DEAD_SKILL_2, "sfx_char_undead_skill2.caf" },
				{ SFX_CHAR_NINJA_ESCAPE, "sfx_char_ninja_escape.caf" },
				{ SFX_CHAR_NINJA_BOMB, "sfx_char_ninja_bomb.caf" },
				{ SFX_CHAR_KABUKI_TRAP, "sfx_char_kabuki_trap.caf" },
				
				{ SFX_ENEMY_ATTACK_MELEE_LIGHT, "sfx_char_melee_light_hit.caf" },
				{ SFX_ENEMY_ATTACK_MELEE_HEAVY, "sfx_char_melee_heavy_hit.caf" },
				{ SFX_ENEMY_ATTACK_BULLET_LIGHT, "sfx_char_bullet_light_hit.caf" },
				{ SFX_ENEMY_ATTACK_BULLET_HEAVY, "sfx_char_bullet_heavy_hit.caf" },
				{ SFX_ENEMY_ATTACK_BULLET_GUN, "sfx_char_bullet_heavy_gun.caf" },
	        };
	    end
		
		WEAPON_SFX_POOL =
		{
			{ SFX_UI_WEAPON_KATANA_1, SFX_UI_WEAPON_KATANA_2, },
			{ SFX_UI_WEAPON_BLADE_1, SFX_UI_WEAPON_BLADE_2, },
			{ SFX_UI_WEAPON_SPEAR_1, SFX_UI_WEAPON_SPEAR_2, },
		};

		local t1 = os.clock();
        for _, sfx in ipairs(sfxList) do
		--log("SFX ID : "..sfx[1])
            self.m_Sfx[sfx[1]] = g_AudioEngine:CreateAudio(sfx[2]);
			
			if (sfx[3] == true) then
				g_AudioEngine:SetLoop(self.m_Sfx[sfx[1]], true);
				self.m_LoopingSfx[sfx[1]] = true;
			end
			--g_AudioEngine:SetVolume(self.m_Sfx[sfx[1]], 1.0);
        end
		local t2 = os.clock();
		--log("SFX DONE / TIME : ".. (t2-t1))
        
		BGM_MAIN_MENU_ENTER = 1;
		BGM_MAIN_MENU_ON = 2;
        BGM_LEVEL_FAIL = 3;
        BGM_LEVEL_WIN = 4;
		BGM_MAP_1_ENTER = 11;
		BGM_MAP_1_ON = 12;
		BGM_MAP_2_ENTER = 13;
		BGM_MAP_2_ON = 14;
		BGM_MAP_3_ENTER = 15;
		BGM_MAP_3_ON = 16;
		BGM_MAP_4_ENTER = 17;
		BGM_MAP_4_ON = 18;
		BGM_MAP_5_ENTER = 19;
		BGM_MAP_5_ON = 20;
		BGM_BOSS_ENTER = 101;
		BGM_BOSS_ON = 102;

		BGM_MAP_DATA =
		{
			[1] = { BGM_MAP_1_ENTER, BGM_MAP_1_ON, },
			[2] = { BGM_MAP_2_ENTER, BGM_MAP_2_ON, },
			[3] = { BGM_MAP_3_ENTER, BGM_MAP_3_ON, },
			[4] = { BGM_MAP_4_ENTER, BGM_MAP_4_ON, },
			[5] = { BGM_MAP_5_ENTER, BGM_MAP_5_ON, },
			[101] = { BGM_MAP_1_ENTER, BGM_MAP_1_ON, },
		};

        GAME_MENU_BGM =
        {
			{ BGM_MAIN_MENU_ENTER, "bgm_menu_enter.mp3", false },
			{ BGM_MAIN_MENU_ON, "bgm_menu_on.mp3", true },
        };

		GAME_LEVEL_BGM =
		{
			[1] =
			{
				{ BGM_MAP_1_ENTER, "bgm_map1_enter.mp3", false },
				{ BGM_MAP_1_ON, "bgm_map1_on.mp3", true },		
			},
		
			[2] =
			{
				{ BGM_MAP_2_ENTER, "bgm_map2_enter.mp3", false },
				{ BGM_MAP_2_ON, "bgm_map2_on.mp3", true },		
			},

			[3] =
			{
				{ BGM_MAP_3_ENTER, "bgm_map3_enter.mp3", false },
				{ BGM_MAP_3_ON, "bgm_map3_on.mp3", true },
			},
		
			[4] =
			{
				{ BGM_MAP_4_ENTER, "bgm_map1_enter.mp3", false },
				{ BGM_MAP_4_ON, "bgm_map1_on.mp3", true },		
			},
		
			[5] =
			{
				{ BGM_MAP_5_ENTER, "bgm_map2_enter.mp3", false },
				{ BGM_MAP_5_ON, "bgm_map2_on.mp3", true },		
			},

			[101] =
			{
				{ BGM_MAP_1_ENTER, "bgm_map1_enter.mp3", false },
				{ BGM_MAP_1_ON, "bgm_map1_on.mp3", true },		
				{ BGM_LEVEL_WIN, "bgm_level_complete.mp3", false },
			},
		};

		GAME_BOSS_BGM =
		{
			{ BGM_BOSS_ENTER, "bgm_boss_enter.mp3", false },
			{ BGM_BOSS_ON, "bgm_boss_on.mp3", true },		
		};
		
		GAME_STAT_BGM =
		{
			{ BGM_LEVEL_WIN, "bgm_level_complete.mp3", false },
            { BGM_LEVEL_FAIL, "bgm_level_fail.mp3", false },		
		};

		-- Create MENU BGM objects
		--local t1 = os.clock();
        for _, bgm in ipairs(GAME_MENU_BGM) do
			self.m_Bgm[ bgm[1] ] = g_AudioEngine:CreateStreamingAudio(bgm[2], bgm[3]);
        end
		--local t2 = os.clock();
		--log("BGM DONE / TIME : ".. (t2-t1) )

		self.m_SfxListeners =
		{
			UIManager:GetWidget("MainEntry", "Sfx"),
			UIManager:GetWidget("GamePause", "Sfx"),
		};
		
		self.m_BgmListeners =
		{
			UIManager:GetWidget("MainEntry", "Bgm"),
			UIManager:GetWidget("GamePause", "Bgm"),
		};
		
		if (self:UpdateIpodStatus()) then
			self:ToggleBgm(IOManager:GetValue(IO_CAT_OPTION, "Audio", "Bgm"));
		end
		
		self:ToggleSfx(IOManager:GetValue(IO_CAT_OPTION, "Audio", "Sfx"));

		log("AudioManager creation done");
    end,
	---------------------------------------------------------------------
	Reset = function(self)
		if (self.m_CurrentBgm) then
			self.m_CurrentBgm:Stop();
			self.m_CurrentBgm = nil;
		end
		
		if (self.m_Bgm[BGM_LEVEL_FAIL]) then
			self:DestroyBgmList(GAME_STAT_BGM);
		end
		
		for id, _ in pairs(self.m_CurrentLoopingSfx) do
			--log("reset sfx : "..id)
            self.m_Sfx[id]:Stop();
			self.m_CurrentLoopingSfx[id] = nil;
		end

		log("AudioManager reset");
	end,
	
	--===================================================================
	-- SFX
	--===================================================================

	---------------------------------------------------------------------
    PlaySfx = function(self, id)
        if (self.m_SfxEnabled and id) then
			self.m_Sfx[id]:Play();
			
			if (self.m_LoopingSfx[id]) then
				self.m_CurrentLoopingSfx[id] = true;
				--log("looping sfx: "..id)
			end
        end
    end,
	---------------------------------------------------------------------
    StopSfx = function(self, id)
        if (self.m_SfxEnabled and id) then
            self.m_Sfx[id]:Stop();

			if (self.m_LoopingSfx[id]) then
				self.m_CurrentLoopingSfx[id] = nil;
				--log("looping sfx end: "..id)
			end
        end
    end,
	---------------------------------------------------------------------
	IsSfxPlaying = function(self, id)
		return self.m_Sfx[id]:IsPlaying();
	end,
	---------------------------------------------------------------------
	SetWeaponSfx = function(self, weaponType)
		self.m_WeaponSfx = WEAPON_SFX_POOL[weaponType];
	end,
	---------------------------------------------------------------------
    PlayWeaponSfx = function(self)
        if (self.m_SfxEnabled) then
			if (math.random(1, 100) > 50) then
				self.m_Sfx[self.m_WeaponSfx[1]]:Play();
			else
				self.m_Sfx[self.m_WeaponSfx[2]]:Play();
			end
		end
    end,
	---------------------------------------------------------------------
    PlayDoorSfx = function(self, opening)
        if (self.m_SfxEnabled) then
		    if (LevelManager:GetGameDifficulty() == GAME_DIFF_NORMAL) then
				if (opening) then
					self.m_Sfx[SFX_UI_WOOD_DOOR_OPEN]:Play();
				else
					self.m_Sfx[SFX_UI_WOOD_DOOR_CLOSE]:Play();
				end
			else
				if (opening) then
					self.m_Sfx[SFX_UI_IRON_DOOR_OPEN]:Play();
				else
					self.m_Sfx[SFX_UI_IRON_DOOR_CLOSE]:Play();
				end
			end
		end
    end,
	---------------------------------------------------------------------
    PlaySfxInRandom = function(self, pool)
        if (self.m_SfxEnabled and pool) then
			local id = RandElement(pool);
			--log("RAND SFX : "..id)
			if (self.m_Sfx[id]) then
				self.m_Sfx[id]:Play();
			end
		end
    end,
	---------------------------------------------------------------------
	ToggleSfx = function(self, state, doSave)
		self.m_SfxEnabled = state;

		if (doSave) then
			IOManager:SetValue(IO_CAT_OPTION, "Audio", "Sfx", state, true);
		end

		for _, widget in ipairs(self.m_SfxListeners) do
			widget:ChangeState(state);
		end
		
		for id, _ in pairs(self.m_CurrentLoopingSfx) do
			if (state) then
				self.m_Sfx[id]:Play();
			else
				self.m_Sfx[id]:Stop();
			end
		end
	end,
	
	--===================================================================
	-- BGM
	--===================================================================
	
	---------------------------------------------------------------------
	CreateBgmList = function(self, bgmList)
        for _, bgm in ipairs(bgmList) do
			if (self.m_Bgm[ bgm[1] ] == nil) then
				self.m_Bgm[ bgm[1] ] = g_AudioEngine:CreateStreamingAudio(bgm[2], bgm[3]);
--[[				
				self.m_Bgm[ bgm[1] ] = g_AudioEngine:CreateAudio(bgm[2]);
				if (bgm[3] == true) then
					g_AudioEngine:SetLoop(self.m_Bgm[ bgm[1] ], true);
				end
--]]				
			end
        end
	end,
	---------------------------------------------------------------------
	DestroyBgmList = function(self, bgmList)
		--log("DestroyBgmList ======> ")
        for _, bgm in ipairs(bgmList) do
			g_AudioEngine:DestroyAudio(bgm[2]);
			self.m_Bgm[ bgm[1] ] = nil;
			--log("DestroyBgmList : "..bgm[1])
		end
	end,
	---------------------------------------------------------------------
    PlayBgm = function(self, id)
		if (self.m_CurrentBgm) then
			self.m_CurrentBgm:Stop();
		end
		
		self.m_CurrentBgm = self.m_Bgm[id];
		--log("PlayBgm @ "..id)
		
        if (self.m_BgmEnabled and self.m_CurrentBgm) then
			self.m_CurrentBgm:SetVolume(1.0);
            self.m_CurrentBgm:Play();
        end
    end,
	---------------------------------------------------------------------
    StopBgm = function(self)
        if (self.m_BgmEnabled and self.m_CurrentBgm) then
            self.m_CurrentBgm:Stop();
        end
    end,
	---------------------------------------------------------------------
    SetBgm = function(self, id)
		self.m_CurrentBgm = self.m_Bgm[id];
	end,
	---------------------------------------------------------------------
	IsCurrentBgmDone = function(self)
		if (self.m_CurrentBgm) then
			if (self.m_CurrentBgm:IsPlaying()) then
				return false;
			end
		end
		return true;
	end,
	---------------------------------------------------------------------
	IsBgmSettingOn = function(self)
		return IOManager:GetValue(IO_CAT_OPTION, "Audio", "Bgm");
	end,
	---------------------------------------------------------------------
    ToggleCurrentBgm = function(self, enable)
		if (self.m_CurrentBgm) then
			if (enable) then
				self.m_CurrentBgm:Play();
			else
				self.m_CurrentBgm:Stop();
			end
		end
    end,
	---------------------------------------------------------------------
	PlayLevelStartBgm = function(self, mapIndex)
		local data = BGM_MAP_DATA[mapIndex];
		if (data and data[1]) then
			self:PlayBgm(data[1]);
		end
	end,
	---------------------------------------------------------------------
	PlayLevelLoopBgm = function(self, mapIndex)
		local data = BGM_MAP_DATA[mapIndex];
		if (data and data[2]) then
			self:PlayBgm(data[2]);
		end
	end,
	---------------------------------------------------------------------
	ToggleBgm = function(self, state, doSave)
		self.m_BgmEnabled = state;
		
		self:ToggleCurrentBgm(state);

		if (doSave) then
			IOManager:SetValue(IO_CAT_OPTION, "Audio", "Bgm", state, true);
		end
		
		for _, widget in ipairs(self.m_BgmListeners) do
			widget:ChangeState(state);
		end
	end,
	---------------------------------------------------------------------
	SetCurrentBgmVolumeCallback = function(self, go)
		if (self.m_CurrentBgm) then
			go["Interpolator"]:AttachUpdateCallback(SetVolumeCallback, self.m_CurrentBgm);
		end
	end,
	---------------------------------------------------------------------
	UpdateIpodStatus = function(self)
		if ((not IS_PLATFORM_ANDROID) and g_AudioRenderer:IsIpodPlaying()) then
			log("AudioManager: iPod is playing! Turn BGM off!")			
			self:ToggleBgm(false);
			return false;
		end
		return true;
	end,
	---------------------------------------------------------------------
	UpdateBgmStatus = function(self)
		if (self:UpdateIpodStatus()) then
			if (self.m_BgmEnabled and self.m_CurrentBgm) then
				self.m_CurrentBgm:Play();
			end
		end
	end,
};

--------------------------------------------------------------------------------
function PlayBgmCallback(bgm)
	AudioManager:PlayBgm(bgm);
end

--------------------------------------------------------------------------------
function PlaySfxCallback(sfx)
	AudioManager:PlaySfx(sfx);
end

--------------------------------------------------------------------------------
function SetVolumeCallback(value, go)
	go:SetVolume(value);
end
