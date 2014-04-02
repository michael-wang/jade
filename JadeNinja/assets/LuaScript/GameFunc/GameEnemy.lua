--***********************************************************************
-- @file GameEnemy.lua
--***********************************************************************

-------------------------------------------------------------------------
EnemyManager =
{
	m_EnemyPool = nil,
	m_ActiveEnemies = nil,
	m_EnemyDropPool = nil,
	m_ActiveEnemyDrops = nil,	
	m_EnemyBulletPool = nil,
	m_EnemyShadowPool = nil,
	m_EnemyEffectPool = nil,
	m_ActiveEnemyEffects = nil,
	
	m_DropRate = DEFAULT_DROP_RATE,
	m_ExpBallRate = 0,
	m_ComboCount = 0,
	m_CoinGetCount = 0,
	m_SpeedFactor = 1,
	m_CoinMultiplier = 1,
	
	m_JadeWidgetSM = nil,
	m_BladeEnchant = nil,
	m_BladeEnchantChance = 0,
	m_InnocentHitCount = 0,
	m_ShouldDoBlockAchievement = true,
	m_InnocentProtect = false,
	m_IsPushbackStatusLocked = false,

	--===================================================================
	-- Create & Reset
	--===================================================================

	---------------------------------------------------------------------
	Create = function(self)		
		--------------------------------
		-- Enemy
		--------------------------------		
		self.m_EnemyPool = PoolManager:Create("Enemy", ENEMY_MAX, "inactive");
		self.m_ActiveEnemies = self.m_EnemyPool:GetActivePool();
		
		--------------------------------
		-- Enemy Initialization: Enchants & Lifebar
		--------------------------------
		for _, enemy in ipairs(self.m_EnemyPool:GetInactivePool()) do
			local enchant = ObjectFactory:CreateGameObject("EnemyEnchant");
			enemy:AttachLayerObject(enchant);
			enemy["Attribute"]:Set("enchant", enchant);

			local lifebar = ObjectFactory:CreateGameObject("EnemyLifebar");
			enemy:AttachLayerObject(lifebar);
			enemy["Attribute"]:Set("lifebar", lifebar);
		end

		--------------------------------
		-- Drop
		--------------------------------
	    self.m_EnemyDropPool = PoolManager:Create("EnemyDrop", ENEMY_DROP_MAX, "inactive");
		self.m_ActiveEnemyDrops = self.m_EnemyDropPool:GetActivePool();

		for _, drop in ipairs(self.m_EnemyDropPool:GetInactivePool()) do
			drop["Interpolator"]:AttachUpdateCallback(UpdateGOAlpha, drop["Sprite"]);
		end
		
		self:ToggleDifficulty(IOManager:GetValue(IO_CAT_CONTENT, "Level", "Difficulty"));

		--------------------------------
		-- Jade
		--------------------------------	
		--self.m_JadeObject = UIManager:GetWidgetObject("InGame", "Jade");
		--self.m_JadeObject["StateMachine"]:ChangeState("inactive");
		
		--------------------------------
		-- Bullet & Shadow
		--------------------------------
		self.m_EnemyBulletPool = PoolManager:Create("EnemyBullet", ENEMY_MAX, "inactive");
		
		self.m_EnemyShadowPool = PoolManager:Create("EnemyShadow", ENEMY_MAX);
		
		--------------------------------
		-- Effect
		--------------------------------
		self.m_EnemyEffectPool = PoolManager:Create("EnemyEffect", EFFECT_MAX, "inactive");
		self.m_ActiveEnemyEffects = self.m_EnemyEffectPool:GetActivePool();

		--------------------------------
		-- Combo
		--------------------------------
		self.m_ComboWidget = UIManager:GetWidget("InGame", "Combo");
		self.m_ComboWidgetSM = UIManager:GetWidgetComponent("InGame", "Combo", "StateMachine");
		self.m_ComboWidgetSM:ChangeState("hide");
		self.m_ComboCount = 0;
		
		--------------------------------
		-- Coin Num
		--------------------------------
		self.m_InGameCoinMotionGC = UIManager:GetWidgetComponent("InGame", "CoinNum", "Motion");
		
		self.m_JadeWidgetSM = UIManager:GetWidgetComponent("InGame", "JadeIcon", "StateMachine");
		local jadeGC = UIManager:GetWidgetComponent("InGame", "JadeIcon", "Interpolator");
		jadeGC:AttachCallback(UpdateGOScale, UpdateGOScale, UIManager:GetWidgetComponent("InGame", "JadeIcon", "Transform"));

		--------------------------------
		-- Function
		--------------------------------
		self:SetEnemyInTutorial(false);
		self:SetEnemyInBossMode(false);
		
		log("EnemyManager creation done");
	end,
	---------------------------------------------------------------------
	Reset = function(self)
		--------------------------------
		-- Enemy
		--------------------------------
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			enemy["Motion"]:Reset();
			enemy["Interpolator"]:Reset();
			
			enemy["SpriteGroup"]:EnableRender(1, false);
			enemy["SpriteGroup"]:EnableRender(2, false);
			enemy["SpriteGroup"]:EnableRender(3, true);

			self:RemoveAllEnchants(enemy, false);
		end

		self.m_EnemyPool:ResetPool();
		
		--------------------------------
		-- Drop, Jade, Bullet, Shadow & Effect
		--------------------------------
		self.m_EnemyDropPool:ResetPool();

		self.m_EnemyBulletPool:ResetPool();
		
		self.m_EnemyShadowPool:ResetPool();
		
		self.m_EnemyEffectPool:ResetPool();
		
		self.m_LaunchEnchant = nil;
		self.m_BladeEnchant = nil;
		self.m_BladeEnchantChance = 0;
		self.m_InnocentHitCount = 0;
		self.m_ShouldDoBlockAchievement = true;

		--------------------------------
		-- Combo
		--------------------------------
		self:ResetCombo();
		self:ResetCoin();
		
		--------------------------------
		-- Function
		--------------------------------
		self:SetEnemyInTutorial(false);
		self:SetEnemyInBossMode(false);
		
		ScrollManager:DeactivateEquippedJade();

		log("EnemyManager reset");
	end,
	---------------------------------------------------------------------	
	Reload = function(self)
		for _, enemy in ipairs(self.m_EnemyPool:GetInactivePool()) do
			enemy:UnloadByDummy();
			enemy["Attribute"]:Get("enchant"):UnloadByDummy();
		end	

		for _, effect in ipairs(self.m_EnemyEffectPool:GetInactivePool()) do
			effect:UnloadByDummy();
		end

		for _, drop in ipairs(self.m_EnemyDropPool:GetInactivePool()) do
			drop:Reload();
		end

		for _, bullet in ipairs(self.m_EnemyBulletPool:GetInactivePool()) do
			bullet:Reload();
		end

		for _, shadow in ipairs(self.m_EnemyShadowPool:GetInactivePool()) do
			shadow:Reload();
		end
		
		log("EnemyManager reloaded");
	end,
	---------------------------------------------------------------------	
	Unload = function(self)
		self.m_EnemyPool:ResetPool();
		for _, enemy in ipairs(self.m_EnemyPool:GetInactivePool()) do
			enemy:UnloadByDummy();
			
			local enchantGO = enemy["Attribute"]:Get("enchant");
			enchantGO["StateMachine"]:ChangeState("inactive");
			enchantGO:UnloadByDummy();
		end

		self.m_EnemyEffectPool:ResetPool();
		for _, effect in ipairs(self.m_EnemyEffectPool:GetInactivePool()) do
			effect:UnloadByDummy();
		end
		
		self.m_EnemyDropPool:ResetPool();
		self.m_EnemyBulletPool:ResetPool();
		self.m_EnemyShadowPool:ResetPool();

		for _, drop in ipairs(self.m_EnemyDropPool:GetInactivePool()) do
			drop:Unload();
		end

		for _, bullet in ipairs(self.m_EnemyBulletPool:GetInactivePool()) do
			bullet:Unload();
		end

		for _, shadow in ipairs(self.m_EnemyShadowPool:GetInactivePool()) do
			shadow:Unload();
		end
		
		log("EnemyManager unloaded");
	end,
	---------------------------------------------------------------------
	Stop = function(self)
		self:RemoveAllDrops();
		self:ResetCombo();
		
		--for _, enemy in ipairs(self.m_ActiveEnemies) do
		for i = #self.m_ActiveEnemies, 1, -1 do
			local enemy = self.m_ActiveEnemies[i];
			if (enemy["Attribute"]:Get("static")) then
				--enemy["Motion"]:Reset();
				self:DeactivateEnemy(enemy);
			end
		end
	end,
	
	--===================================================================
	-- Life bar
	--===================================================================
	
	---------------------------------------------------------------------
	ResetEnemyLifebar = function(self, enemy)
		local lifebar = enemy["Attribute"]:Get("lifebar");
		lifebar["Shape"]:SetSize(2, ENEMY_BAR_SIZE[1], ENEMY_BAR_SIZE[2]);
		lifebar["Shape"]:SetSize(3, ENEMY_BAR_SIZE[1], ENEMY_BAR_SIZE[2]);
		lifebar["Shape"]:EnableRenderAll(false);
	end,
	---------------------------------------------------------------------
	EnableEnemyLifebar = function(self, enemy, enable)
---[[ @Screenshot	
		local lifebar = enemy["Attribute"]:Get("lifebar");
		lifebar["Shape"]:EnableRenderAll(enable);
--]]		
	end,
	---------------------------------------------------------------------
	ModifyEnemyLife = function(self, enemy, value)
		local life = enemy["Attribute"]:Modify("life", value);
		local lifebar = enemy["Attribute"]:Get("lifebar");

		if (life > 0) then
			local width = ENEMY_BAR_SIZE[1] * life / enemy["Attribute"]:Get("maxLife");
			lifebar["StateMachine"]:ChangeState("active", width);
			
			if (not enemy["Attribute"]:Get("lifeWounded")) then
				enemy["Attribute"]:Set("lifeWounded", true);
---[[ @Screenshot	
				lifebar["Shape"]:EnableRenderAll(true);
--]]				
			end
		else
			lifebar["Shape"]:EnableRenderAll(false);
		end
				
		return life;
	end,

	--===================================================================
	-- @Attribute
	--===================================================================

	---------------------------------------------------------------------
	SetAnimation = function(self, go, anim)
		go["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):ResetAnimation(go["Attribute"]:Get("look") .. anim, true);
	end,
	---------------------------------------------------------------------
	SetSpeedFactor = function(self, speed)
		self.m_SpeedFactor = speed;
	end,
	---------------------------------------------------------------------
	SetSpeed = function(self, go)
		go["Motion"]:SetVelocity(go["Attribute"]:Get("speed") * self.m_SpeedFactor);
	end,
	---------------------------------------------------------------------
	SetHalfSpeed = function(self, go)
		--log("SetHalfSpeed : "..go["Attribute"]:Get("speed") * self.m_SpeedFactor * 0.5)
		go["Motion"]:SetVelocity(go["Attribute"]:Get("speed") * self.m_SpeedFactor * 0.5);
	end,
	---------------------------------------------------------------------
	SetInnocentSpeed = function(self, go)
		go["Motion"]:SetVelocity(go["Attribute"]:Get("speed"));
	end,
	---------------------------------------------------------------------
	RestoreSpeed = function(self, go)
		if (go["Attribute"]:Get("stateFreezed") or self.m_LaunchEnchant == "freeze_scroll") then
			go["Motion"]:SetVelocity(go["Attribute"]:Get("speed") * self.m_SpeedFactor * 0.5);
		elseif (go["Attribute"]:Get("stateStunned")) then
			go["Motion"]:SetVelocity(ENEMY_STUNBACK_VELOCITY);
		else
			go["Motion"]:SetVelocity(go["Attribute"]:Get("speed") * self.m_SpeedFactor);
		end
	end,

	--===================================================================
	-- @Attack
	--===================================================================

	---------------------------------------------------------------------
	SetEnemyInTutorial = function(self, enable)
		if (enable) then
			self.m_DropRate = 0;
			self.CanHurtEnemy = self.CanHurtEnemyInTutorial;
			self.HurtEnemy = self.HurtEnemyInTutorial;
			self.UpdateCombo = self.UpdateComboInTutorial;			
		else
			self.m_DropRate = DEFAULT_DROP_RATE;
			self.CanHurtEnemy = self.CanHurtEnemyInGame;
			self.HurtEnemy = self.HurtEnemyInGame;
			self.UpdateCombo = self.UpdateComboInGame;			
		end
	end,
	---------------------------------------------------------------------
	SetEnemyInBossMode = function(self, enable)
		if (enable) then
			self.HurtEnemy = self.HurtEnemyInBossMode;
		else
			self.HurtEnemy = self.HurtEnemyInGame;
		end
	end,
	---------------------------------------------------------------------
	CanHurtEnemyInGame = function(self, enemy, defendable)
		if (enemy["Attribute"]:Get("invincible")) then
			BladeManager:ShowParryEffect(enemy);
			return false;
		end
		
		if (defendable and enemy["Attribute"]:Get("defendable") and not enemy["Attribute"]:Get("stateStunned")) then
			if (math.random(1, 100) <= enemy["Attribute"]:Get("parryRate")) then
				enemy["StateMachine"]:ChangeState("skill_defend");
				
				if (self.m_ShouldDoBlockAchievement) then
					self.m_ShouldDoBlockAchievement = false;
					UpdateAchievement(ACH_ENEMY_BLOCKED);
				end
				
				return false;
			end
		end

		return true;
	end,
	---------------------------------------------------------------------
	CanHurtEnemyInTutorial = function(self, enemy, defendable)
		if (defendable and enemy["Attribute"]:Get("defendable")) then
			enemy["StateMachine"]:ChangeState("tutorial_defend");
			return false;
		end			

		return true;
	end,
	---------------------------------------------------------------------
	HurtEnemyInTutorial = function(self, enemy, blade, power, skillType)
	    enemy["StateMachine"]:ChangeState("die");			
	end,
	---------------------------------------------------------------------
	HurtEnemyInGame = function(self, enemy, blade, power, skillType)
		-- Show critical text & fx if required
		if (blade["Attribute"]:Get("criticalHit")) then
			BladeManager:ShowCriticalHit(enemy);
			blade["Attribute"]:Clear("criticalHit");
			
			if (self.m_BladeEnchant == "enemy_crit") then
				self.m_JadeWidgetSM:ChangeState("trigger");
			end
		end

		if (self:ModifyEnemyLife(enemy, -power) > 0) then
		-- Enemy is wounded
			if (enemy["Attribute"]:Get("enchantable")) then
				enemy["StateMachine"]:ChangeState("wounded", (skillType == WEAPON_SKILL_KNOCKBACK));
			else
				enemy["Attribute"]:Get("enchant")["StateMachine"]:ChangeState("cask_wounded", enemy);
			end
		else
		-- Enemy is dying
	        enemy["StateMachine"]:ChangeState(enemy["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_DEAD] or "die");			
		end
	end,
	---------------------------------------------------------------------
	HurtEnemyInBossMode = function(self, enemy, blade, power, skillType)
		-- Show critical text & fx if required
		if (blade["Attribute"]:Get("criticalHit")) then
			BladeManager:ShowCriticalHit(enemy);
			blade["Attribute"]:Clear("criticalHit");
			
			if (self.m_BladeEnchant == "enemy_crit") then
				self.m_JadeWidgetSM:ChangeState("trigger");
			end
		end
		
		local template = enemy["Attribute"]:Get("template");
		local tempSkill = template[ENEMY_TEMPLATE_SKILL];
		
		if (template[ENEMY_TEMPLATE_TYPE] == ET_BOSS) then
		-- =============== BOSS =============
			self:HurtBoss(enemy, power, (skillType == WEAPON_SKILL_KNOCKBACK));
		else
		-- =============== Normal Enemy =============
			if (self:ModifyEnemyLife(enemy, -power) > 0) then
			-- Enemy is wounded
				if (template[ENEMY_TEMPLATE_TYPE] == ET_BOSSMINION) then
					enemy["StateMachine"]:ChangeState("wounded", (skillType == WEAPON_SKILL_KNOCKBACK));
				else
					if (enemy["Attribute"]:Get("enchantable")) then
						enemy["StateMachine"]:ChangeState("wounded", (skillType == WEAPON_SKILL_KNOCKBACK));
					else
						enemy["Attribute"]:Get("enchant")["StateMachine"]:ChangeState("cask_wounded", enemy);
					end
				end
			else
			-- Enemy is dying
		        enemy["StateMachine"]:ChangeState(tempSkill[ES_DEAD] or "die");			
			end
		end
	end,
	---------------------------------------------------------------------
	HurtBoss = function(self, enemy, power, doPushback)
		local life = enemy["Attribute"]:Modify("life", -power);
		if (life <= 0) then
			life = 0;
			enemy["StateMachine"]:ChangeState("boss_die");
			LevelManager:ExitBossMode(enemy);
		else
			enemy["StateMachine"]:ChangeState("boss_wounded", doPushback);
		end

		UIManager:GetWidget("BossLifebar", "BossBar"):SetValue(life);
		UIManager:GetWidgetComponent("BossLifebar", "BossBar", "Shaker"):Shake();
	end,
	---------------------------------------------------------------------
	ChangeWeapon = function(self, weaponType)
		if (weaponType == WEAPON_TYPE_KATANA) then
			self.AttackEnemyDelegate = self.AttackEnemyByKatana;
		elseif (weaponType == WEAPON_TYPE_BLADE) then
			self.AttackEnemyDelegate = self.AttackEnemyByBlade;
		else -- WEAPON_TYPE_SPEAR
			self.AttackEnemyDelegate = self.AttackEnemyBySpear;
		end
	end,
	---------------------------------------------------------------------
	AttackInnocent = function(self, enemy, blade)
		if (blade["Bound"]:IsPickedObject(enemy)) then
			if (enemy["Attribute"]:Get("innocentSP")) then
				enemy["StateMachine"]:ChangeState("innocent_block");
				return true;
			end
		
			if (self.m_InnocentProtect) then
				self.m_JadeWidgetSM:ChangeState("trigger");
				return false;
			else
				enemy["StateMachine"]:ChangeState("innocent_die");
				blade["Attribute"]:Clear("criticalHit");
				return true;
			end
		end
	end,
	---------------------------------------------------------------------
	AttackEnemyByKatana = function(self, enemy, blade, power, skillType)
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			if (enemy["StateMachine"]:IsStateChangeAllowed("die")) then
				if (enemy["Attribute"]:Get("innocent")) then
					if (self:AttackInnocent(enemy, blade)) then
						return;
					end
				else
				-- Normal enemy
					if (blade["Bound"]:IsPickedObject(enemy)) then
						if (self:CanHurtEnemy(enemy, true)) then
							self:HurtEnemy(enemy, blade, power, skillType);
						end
						return;
					end
				end
			end
		end
	end,
	---------------------------------------------------------------------
	AttackEnemyByBlade = function(self, enemy, blade, power, skillType)
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			if (enemy["StateMachine"]:IsStateChangeAllowed("die")) then
				if (enemy["Attribute"]:Get("innocent")) then
					if (self:AttackInnocent(enemy, blade)) then
						return;
					end
				else
				-- Normal enemy					
					if (blade["Bound"]:IsPickedObject(enemy)) then
						if (self:CanHurtEnemy(enemy, false)) then
							self:HurtEnemy(enemy, blade, power, skillType);
						end
						return;
					end
				end
			end
		end
	end,
	---------------------------------------------------------------------
	AttackEnemyBySpear = function(self, enemy, blade, power, skillType)
		local enemyGot = 0;
		local skillValue = BladeManager:GetSkillValue();
		
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			if (enemy["StateMachine"]:IsStateChangeAllowed("die")) then
				if (enemy["Attribute"]:Get("innocent")) then
				-- Innocent people
					if (blade["Bound"]:IsPickedObject(enemy)) then
						if (enemy["Attribute"]:Get("innocentSP")) then
							enemy["StateMachine"]:ChangeState("innocent_block");
							return;
						end

						if (self.m_InnocentProtect) then
							self.m_JadeWidgetSM:ChangeState("trigger");
						else
							enemy["StateMachine"]:ChangeState("innocent_die");
							blade["Attribute"]:Clear("criticalHit");
							self.m_InnocentHitCount = self.m_InnocentHitCount + 1;
	
							enemyGot = enemyGot + 1;
							if (enemyGot >= skillValue) then
								return;
							end
						end
					end
				else
				-- Normal enemy
					if (blade["Bound"]:IsPickedObject(enemy)) then
						if (self:CanHurtEnemy(enemy, true)) then
							self:HurtEnemy(enemy, blade, power, skillType);
						end

						enemyGot = enemyGot + 1;
						if (enemyGot >= skillValue) then
							return;
						end
					end
				end
			end
		end
	end,
	---------------------------------------------------------------------
	AttackEnemy = function(self, blade, power, skillType)
		table.sort(self.m_ActiveEnemies, SortGameObjectReversed);
		
		self:AttackEnemyDelegate(enemy, blade, power, skillType)
--[[ @NearHit
		if (self:AttackEnemyDelegate(enemy, blade, power, skillType)) then
			UpdateAchievement(ACH_NEAR_HIT);
		end
--]]		
	end,
	---------------------------------------------------------------------
	HealEnemy = function(self, go)
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			local attr = enemy["Attribute"];
			if ((go ~= enemy) and
				(attr:Get("lifeWounded")) and
				(attr:Get("enchantable")) and
				--(attr:Get("template")[ENEMY_TEMPLATE_TYPE] ~= ET_BOSS) and
				(not enemy["StateMachine"]:IsCurrentState("die"))) then
			
				local healValue = attr:Get("maxLife") - attr:Get("life");	
				self:ModifyEnemyLife(enemy, healValue);
				attr:Clear("lifeWounded");
				
				-- Heal will remove all enchnats on enemy
				self:RemoveAllEnchants(enemy, true);
				self:AddEnchant(enemy, "heal");

				return true;
			end
		end
	end,
--[[	
	---------------------------------------------------------------------
	HealBoss = function(self, value)
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			if (enemy["Attribute"]:Get("invincible")) then
				local maxLife = enemy["Attribute"]:Get("maxLife");
				local life = enemy["Attribute"]:Get("life") + value;
				if (life > maxLife) then
					life = maxLife;
				end
				
				enemy["Attribute"]:Set("life", life);
				UIManager:GetWidget("InGame", "BossBar"):SetValue(life);
				self:AddEnchant(enemy, "heal_boss");
				--log("heal +"..value.." => life: "..life)
				return;
			end
		end
	end,
--]]	
	---------------------------------------------------------------------
	LaunchEnemy = function(self, template)
		if (template[ENEMY_TEMPLATE_TYPE] == ET_NONE) then
			return;
		end
		
		--assert(#template == 12 or #template == 13, "Enemy Template Error: "..template[ENEMY_TEMPLATE_LOOK])
		local enemy = self.m_EnemyPool:ActivateResource();
		if (enemy == nil) then
			--log("Enemy has reached max");
			return;
		end

		--======================
		-- Attributes
		--======================
		enemy["Attribute"]:Clear("lifeWounded");
		enemy["Attribute"]:Clear("skillUsed");
		enemy["Attribute"]:Clear("shadow");
		enemy["Attribute"]:Clear("defendable");
		enemy["Attribute"]:Clear("enchantable");
		enemy["Attribute"]:Clear("innocent");
		enemy["Attribute"]:Clear("monkey");
		enemy["Attribute"]:Clear("static");
		enemy["Attribute"]:Clear("invincible");
		enemy["Attribute"]:Clear("minions");
		enemy["Attribute"]:Clear("parryRate");
		enemy["Attribute"]:Clear("innocentSP");
				
		if (LevelManager:IsShadowDifficulty()) then
			local life = math.ceil(template[ENEMY_TEMPLATE_LIFE] * ENEMY_SHADOW_LIFE);
			enemy["Attribute"]:Set("maxLife", life);
			enemy["Attribute"]:Set("life", life);
			enemy["Attribute"]:Set("power", math.ceil(template[ENEMY_TEMPLATE_ATTACK] * ENEMY_SHADOW_POWER));
			enemy["Attribute"]:Set("speed", math.ceil(template[ENEMY_TEMPLATE_SPEED] * ENEMY_SHADOW_SPEED));
			
			local energy = math.ceil(template[ENEMY_TEMPLATE_LIFE] * 0.119) + 5;		-- 0.119 = 1 / (4.2 * 2)
			if (energy < 5) then
				energy = 5;
			elseif (energy > 20) then
				energy = 20;
			end
			enemy["Attribute"]:Set("energy", energy);
		else
			enemy["Attribute"]:Set("maxLife", template[ENEMY_TEMPLATE_LIFE]);	
			enemy["Attribute"]:Set("life", template[ENEMY_TEMPLATE_LIFE]);	
			enemy["Attribute"]:Set("power", template[ENEMY_TEMPLATE_ATTACK]);
			enemy["Attribute"]:Set("speed", template[ENEMY_TEMPLATE_SPEED]);

			local energy = math.ceil(template[ENEMY_TEMPLATE_LIFE] * 0.5);
			if (energy < 3) then
				energy = 3;
			elseif (energy > 9) then
				energy = 9;
			end
			enemy["Attribute"]:Set("energy", energy);
		end
		
		enemy["Attribute"]:Set("template", template);
		enemy["Attribute"]:Set("look", template[ENEMY_TEMPLATE_LOOK]);

		--======================
		-- Abilities
		--======================
		local ability = template[ENEMY_TEMPLATE_ABILITY];		
		if (ability == EA_DEFEND) then
			enemy["Attribute"]:Set("enchantable", true);
			enemy["Attribute"]:Set("defendable", true);
			enemy["Attribute"]:Set("parryRate", template[ENEMY_TEMPLATE_SPRATE]);
		elseif (ability == EA_STATIC) then
			enemy["Attribute"]:Set("static", true);
		elseif (ability == EA_INNOCENT) then
			enemy["Attribute"]:Set("innocent", true);
		elseif (ability == EA_INNOCENT_SP) then
			enemy["Attribute"]:Set("innocent", true);
			enemy["Attribute"]:Set("innocentSP", true);
			enemy["Attribute"]:Set("energy", 0);
		elseif (ability == EA_MONKEY) then
			enemy["Attribute"]:Set("monkey", true);
		elseif (ability == EA_INVINCIBLE) then
			enemy["Attribute"]:Set("enchantable", true);
			enemy["Attribute"]:Set("invincible", true);
		elseif (ability == EA_NONE) then
			enemy["Attribute"]:Set("enchantable", true);
		elseif (ability == EA_NONSTOP) then
			-- N/A
		else
			assert(false, "Enemy ability not supported: "..ability);
		end

		--======================
		-- Render Layer
		--======================
		if (template[ENEMY_TEMPLATE_LAYER] == EL_POSTRENDER) then
			LevelManager:SetEnemyFlyMovement(enemy, true);			
            self:AttachShadow(enemy);
			
			AddToPostRenderQueue(enemy);
		elseif (template[ENEMY_TEMPLATE_LAYER] == EL_PRERENDER) then
			AddToPreRenderQueue(enemy);
		else
			AddToRenderQueue(enemy);
		end

		--======================
		-- Scopes
		--======================
		if (template[ENEMY_TEMPLATE_SCOPE][1] == ER_BULLET) then
			enemy["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):AttachCallback(template[ENEMY_TEMPLATE_LOOK] .. ENEMY_ANIM_ATTACK, template[ENEMY_TEMPLATE_SCOPE][2], LaunchBullet, enemy);
		else -- ER_MELEE
			enemy["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):AttachCallback(template[ENEMY_TEMPLATE_LOOK] .. ENEMY_ANIM_ATTACK, template[ENEMY_TEMPLATE_SCOPE][2], AttackCastle, enemy);
		end

		--======================
		-- Components
		--======================
		enemy["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):SetAlpha(ALPHA_MAX);
	    enemy["SpriteGroup"]:EnableRender(1, false);
	    enemy["SpriteGroup"]:EnableRender(2, false);
		enemy["SpriteGroup"]:EnableRender(3, true);

		enemy["SpriteGroup"]:GetSprite(1):ResetImage(template[ENEMY_TEMPLATE_LOOK] .. ENEMY_ANIM_WOUNDED_SINGLE, true);
		enemy["SpriteGroup"]:GetSprite(2):ResetImage(template[ENEMY_TEMPLATE_LOOK] .. ENEMY_ANIM_WOUNDED_SINGLE, true);
		enemy["SpriteGroup"]:GetSprite(3):ResetAnimation(template[ENEMY_TEMPLATE_LOOK] .. ENEMY_ANIM_MOVE, true);

		self:ResetEnemyLifebar(enemy);

		local width, height = enemy["SpriteGroup"]:GetSprite(ENEMY_MAIN_SPRITE):GetSize();
		local scale = template[ENEMY_TEMPLATE_SCALE] or 1.0;
		
		if (IS_DEVICE_IPAD) then
			width = width * 0.5;
			height = height * 0.5;
		elseif IS_PLATFORM_ANDROID then
			width = width / APP_SCALE_FACTOR;
			height = height / APP_SCALE_FACTOR;
		end
		
		local radius = math.max(width, height) * 0.5;
				
		-- Special case: Boss
		if (template[ENEMY_TEMPLATE_TYPE] == ET_BOSS or template[ENEMY_TEMPLATE_TYPE] == ET_BOSSMINION) then
			enemy["Attribute"]:Clear("enchantable");
			
			if (template[ENEMY_TEMPLATE_LOOK] == "boss_devilsamurai") then
				radius = radius * 0.65;
			end
		end
		
		enemy["Transform"]:SetScale(scale);
		enemy["Interpolator"]:Reset();

		-- Speed & Collision bound		
		if (ability == EA_INNOCENT) then
			self:SetInnocentSpeed(enemy);
			enemy["Bound"]:SetRadius(radius * scale * 0.4);
			enemy["Bound"]:SetOffset(radius * 0.5, radius * 0.6);
		else
			self:SetSpeed(enemy);
			enemy["Bound"]:SetRadius(radius * scale * 0.6);
			enemy["Bound"]:SetOffset(radius * 0.4, radius * 0.4);
		end

		-- Adjust position of enemy life bar
		local lifebar = enemy["Attribute"]:Get("lifebar");
		local offsetX = (width - ENEMY_BAR_SIZE[1]) * 0.25;
		local offsetY = 0;
		if (scale > 1.0) then
			offsetY = -20;
		end
		enemy["Transform"]:ReattachObject(lifebar, offsetX, offsetY);

		enemy["StateMachine"]:ResetStateSet(EnemyStates);		
		enemy["StateMachine"]:ChangeState("initial");
		
		if (self.m_LaunchEnchant and enemy["Attribute"]:Get("enchantable")) then
			self:AddEnchant(enemy, self.m_LaunchEnchant);
		end

		return enemy;
	end,
	---------------------------------------------------------------------
	LaunchEnemyWithPosition = function(self, enemyType, x, y)
		local enemy = self:LaunchEnemy(enemyType);
		
		if (enemy) then
			enemy["Transform"]:SetTranslate(x, y);
		end
		
		return enemy;
	end,
	---------------------------------------------------------------------
	DeactivateEnemy = function(self, go)
--[[	
		local shadow = go["Attribute"]:Get("shadow");		
		if (shadow) then
			self:DetachShadow(shadow);
			go["Attribute"]:Clear("shadow");
			RemoveFromPostRenderQueue(go);
		else
			RemoveFromRenderQueue(go);
		end
--]]
		local layer = go["Attribute"]:Get("template")[ENEMY_TEMPLATE_LAYER];
		if (layer == EL_POSTRENDER) then
			self:DetachShadow(go["Attribute"]:Get("shadow"));
			go["Attribute"]:Clear("shadow");
			
			RemoveFromPostRenderQueue(go);
		elseif (layer == EL_PRERENDER) then
			RemoveFromPreRenderQueue(go);
		else
			RemoveFromRenderQueue(go);
		end			

		go["Motion"]:Reset();	
		self.m_EnemyPool:DeactivateResource(go);
	end,
	---------------------------------------------------------------------
	GetActiveEnemy = function(self)
		return self.m_ActiveEnemies[1];
	end,
	---------------------------------------------------------------------
	IsActiveEnemyState = function(self, state)
		local enemy = self.m_ActiveEnemies[1];
		if (enemy) then
			return enemy["StateMachine"]:IsCurrentState(state);
		end
	end,
	---------------------------------------------------------------------
	IsActiveEnemiesState = function(self, state)
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			if (not enemy["StateMachine"]:IsCurrentState(state)) then
				return false;
			end
		end
		return true;
	end,
	---------------------------------------------------------------------
	ChangeActiveEnemiesState = function(self, state)
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			enemy["StateMachine"]:ChangeState(state);
		end
	end,
	---------------------------------------------------------------------
	EnchantAllEnemies = function(self, enchant)
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			if (enemy["Attribute"]:Get("enchantable") and enemy["StateMachine"]:IsStateChangeAllowed("die")) then				
				self:AddEnchant(enemy, enchant);
			end
		end
	end,
	---------------------------------------------------------------------
	RemoveAllInnocents = function(self)
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			if (enemy["Attribute"]:Get("innocent")) then
			    self:DeactivateEnemy(enemy);
			end
		end
	end,
	---------------------------------------------------------------------
	RemoveAllEnemiesEnchant = function(self, enchant)
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			local enchantGO = enemy["Attribute"]:Get("enchant");
			if (enchantGO["StateMachine"]:IsCurrentState(enchant)) then
				enchantGO["StateMachine"]:ChangeState("inactive");
			end
		end
	end,
	---------------------------------------------------------------------
	DodgeAllEnemies = function(self)
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			local state = enemy["StateMachine"]:GetCurrentState();
			if ((state == "preattack") or (state == "attack")) then
				enemy["StateMachine"]:ChangeState(enemy["Attribute"]:Get("template")[ENEMY_TEMPLATE_SKILL][ES_MOVE] or "move");
			end
		end
	end,
	---------------------------------------------------------------------
	KillAllEnemies = function(self)
		self:RemoveAllBullets();
		
		for i = #self.m_ActiveEnemies, 1, -1 do
			local enemy = self.m_ActiveEnemies[i];
			
			if (enemy["Attribute"]:Get("innocent")) then
				self:DeactivateEnemy(enemy);
			elseif (enemy["Attribute"]:Get("monkey")) then
				enemy["StateMachine"]:ChangeState("monkey_die");
			else
				local enemyType = enemy["Attribute"]:Get("template")[ENEMY_TEMPLATE_TYPE];
				if (enemyType == ET_BOSS) then
					if (enemy["StateMachine"]:IsStateChangeAllowed("die")) then
						self:HurtBoss(enemy, SCROLL_METEOR_BOSS_DAMAGE, false);
					end
				elseif (enemyType == ET_OBJECT) then
					self:DeactivateEnemy(enemy);
				elseif (not enemy["StateMachine"]:IsCurrentState("die")) then
					self:RemoveAllEnchants(enemy, false);
					enemy["StateMachine"]:UnlockAllStates();
					enemy["StateMachine"]:ChangeState("die", true);
					BatchUpdateAchievement(ACH_METEOR_COUNT_LV1);
				end
			end
		end		
	end,
	---------------------------------------------------------------------
	RunawayAllEnemies = function(self)
		self:ResetCombo();
		self:RemoveAllBullets();
		self:RemoveAllDrops();

		for i = #self.m_ActiveEnemies, 1, -1 do
			local enemy = self.m_ActiveEnemies[i];
			local enemyType = enemy["Attribute"]:Get("template")[ENEMY_TEMPLATE_TYPE];
			
			if (ENEMY_CAN_SWIPED[enemyType]) then
				self:DeactivateEnemy(enemy);
			else
				self:RemoveAllEnchants(enemy, false);
				enemy["StateMachine"]:UnlockAllStates();
				enemy["StateMachine"]:ChangeState("runaway");				
			end
		end
	end,
	---------------------------------------------------------------------
	PushbackAllEnemies = function(self, distance)
		if (not self.m_IsPushbackStatusLocked) then
			for _, enemy in ipairs(self.m_ActiveEnemies) do
				if (enemy["Attribute"]:Get("enchantable") and enemy["StateMachine"]:IsStateChangeAllowed("die")) then
					enemy["StateMachine"]:ChangeState("pushback", distance);
				end
			end
		end
	end,
	---------------------------------------------------------------------
	CleanupFromRevive = function(self)
		self:ResetCombo();
		self:RemoveAllBullets();
		self:RemoveAllDrops();
		
		self.m_IsPushbackStatusLocked = true;
		
		for i = #self.m_ActiveEnemies, 1, -1 do
			local enemy = self.m_ActiveEnemies[i];
			local enemyType = enemy["Attribute"]:Get("template")[ENEMY_TEMPLATE_TYPE];
			
			if (ENEMY_CAN_SWIPED[enemyType]) then
				self:DeactivateEnemy(enemy);
			elseif (enemyType == ET_BOSS) then
				if (enemy["StateMachine"]:IsStateChangeAllowed("die")) then
					enemy["StateMachine"]:ChangeState("pushback", 100);
				end
			else
				enemy["StateMachine"]:UnlockAllStates();
				self:RemoveAllEnchants(enemy, false);
				enemy["StateMachine"]:ChangeState("pushback_die");
			end
		end
	end,
	---------------------------------------------------------------------
	UnlockPushbackStatus = function(self)
		self.m_IsPushbackStatusLocked = false;
	end,
	---------------------------------------------------------------------
	OnEnemyWounded = function(self, go, sm)
		if (self.m_BladeEnchant and
			self.m_BladeEnchantChance and
			go["Attribute"]:Get("enchantable") and
			math.random(1, 100) <= self.m_BladeEnchantChance) then
			
			self.m_JadeWidgetSM:ChangeState("trigger");
			self:AddEnchant(go, self.m_BladeEnchant);
		end
		
		if (go["Attribute"]:Get("stateStunned")) then
			sm:ChangeState("stunned");
		else
			local template = go["Attribute"]:Get("template");
			local skillWounded = template[ENEMY_TEMPLATE_SKILL][ES_WOUNDED];
			
			if (skillWounded and math.random(1, 100) <= 80) then
				sm:ChangeState(skillWounded);
			elseif (template[ENEMY_TEMPLATE_LAYER] == EL_POSTRENDER) then  -- Special case for flying enemies
				sm:ChangeState(template[ENEMY_TEMPLATE_SKILL][ES_MOVE]);
			else
				sm:ChangeState("move");
			end
		end
	end,
	---------------------------------------------------------------------
	OnBossWounded = function(self, go, sm)
		local template = go["Attribute"]:Get("template");
		local skillWounded = template[ENEMY_TEMPLATE_SKILL][ES_WOUNDED];
		
		if (skillWounded and math.random(1, 100) <= 90) then
			sm:ChangeState(skillWounded);
		else
			sm:ChangeState("move");
		end
	end,
	---------------------------------------------------------------------
	IsAllEnemiesCleared = function(self)
		return self.m_EnemyPool:IsActivePoolEmpty();
	end,
	---------------------------------------------------------------------
	--SetParryRate = function(self, rate)
		--log("SetParryRate => "..rate.." %")
		--self.m_ParryRate = rate;
	--end,
	---------------------------------------------------------------------
	GetInnocentHitCount = function(self)
		return self.m_InnocentHitCount;
	end,

	--===================================================================
	-- Drop & Treasure
	--===================================================================

	---------------------------------------------------------------------
	ToggleDifficulty = function(self, difficulty)
	end,
	---------------------------------------------------------------------
	SetDropRate = function(self, rate)
		--log("Drop Rate => "..rate.." %")
		self.m_DropRate = rate;
	end,
	---------------------------------------------------------------------
	GetDropRate = function(self)
		return self.m_DropRate;
	end,
	---------------------------------------------------------------------
	SetEnergyBallRate = function(self, rate)	
		self.m_ExpBallRate = rate;
	end,
	---------------------------------------------------------------------
	SetCoinMutiplier = function(self, mutiplier)
		--log("SetCoinMutiplier : x"..mutiplier)
		self.m_CoinMultiplier = mutiplier;
	end,
	---------------------------------------------------------------------
	DetermineCoinType = function(self)
		local dice = math.random(1, 100);
		
		for i = 1, DROP_DATA_NUM do
			if (dice <= DROP_COIN_DATA[i][COIN_CHANCE]) then
				return DROP_COIN_DATA[i];
			end
		end
		
		assert(false, "DetermineCoinType error");
	end,
	---------------------------------------------------------------------
	LaunchDrop = function(self, go)
		self:LaunchEnergyBall(go);

		if (math.random(1, 100) <= self.m_DropRate) then
			self:LaunchCoin(go);
		end
	end,
	---------------------------------------------------------------------	
	LaunchBossDrop = function(self, go)
		for i = 1, 100 do
			local x, y = go["Transform"]:GetTranslate();
			local r = go["Bound"]:GetRadius();
			local coinType = LevelManager:GetMapIndex();
			local data = { x, y, r, coinType };
			g_TaskManager:AddTask(CallbackTask, { LaunchCoinCallback, nil, nil, data }, 50, 0);
		end
	end,
	---------------------------------------------------------------------
	LaunchCoin = function(self, go)
		local coinType = self:DetermineCoinType();
		local drop = self.m_EnemyDropPool:ActivateResource();
		
		if (drop) then
			local x, y = go["Transform"]:GetTranslate();
			local r = go["Bound"]:GetRadius();

			drop["Transform"]:SetTranslate(x + r, y + r);
			drop["Transform"]:SetScale(coinType[COIN_SCALE]);
			drop["Sprite"]:ResetAnimation(coinType[COIN_LOOK], true);
            drop["Sprite"]:SetAlpha(ALPHA_MAX);
			drop["Motion"]:Reset();
			drop["Interpolator"]:Reset();
			drop["Attribute"]:Set("Count", coinType[COIN_VALUE]);
			drop["Attribute"]:Set("Type", DROP_TYPE_COIN);
			drop["StateMachine"]:ChangeState("coin_moving");
		end
	end,
	---------------------------------------------------------------------
	LaunchCoinSet = function(self, go)
		local coinType = self:DetermineCoinType();
		--local coinNum = math.random(30, 35);
		--for i = 1, coinNum do
		for i = 1, 30 do  -- Launch 30 coins
			local drop = self.m_EnemyDropPool:ActivateResource();		
			if (drop) then
				local x, y = go["Transform"]:GetTranslate();
				local r = go["Bound"]:GetRadius();

				drop["Transform"]:SetTranslate(ModifyValueByRandRange(x + r, 15), ModifyValueByRandRange(y + r, 15));
				drop["Transform"]:SetScale(coinType[COIN_SCALE]);
				drop["Sprite"]:ResetAnimation(coinType[COIN_LOOK], true);
				drop["Sprite"]:SetAlpha(ALPHA_MAX);
				drop["Motion"]:Reset();
				drop["Interpolator"]:Reset();
				drop["Attribute"]:Set("Count", coinType[COIN_VALUE]);
				drop["Attribute"]:Set("Type", DROP_TYPE_COIN);
				drop["StateMachine"]:ChangeState("coin_moving");
			end
		end		
	end,
	---------------------------------------------------------------------
	LaunchEnergyBall = function(self, go)
		local drop = self.m_EnemyDropPool:ActivateResource();
		
		if (drop) then
			local x, y = go["Transform"]:GetTranslate();
			local r = go["Bound"]:GetRadius();
			local maxLife = go["Attribute"]:Get("maxLife");
			local energy = go["Attribute"]:Get("energy");
			
			if (self.m_BladeEnchant == "energy_gain" and math.random(1, 100) <= self.m_ExpBallRate) then
				LevelManager:GainExp(maxLife * 2);
				drop["Sprite"]:ResetAnimation("bigenergyball", true);
				--self.m_JadeWidgetSM:ChangeState("trigger");
			else			
				LevelManager:GainExp(maxLife);
				drop["Sprite"]:ResetAnimation("energyball", true);
			end

			drop["Transform"]:SetTranslate(x + r, y + r);
            drop["Sprite"]:SetAlpha(ALPHA_MAX);
			drop["Motion"]:Reset();
			drop["Interpolator"]:Reset();
			drop["Attribute"]:Set("Count", energy);
			drop["StateMachine"]:ChangeState("energyball_moving");
		end
	end,
	---------------------------------------------------------------------
	DeactivateDrop = function(self, go)
		self.m_EnemyDropPool:DeactivateResource(go);
		
		RemoveFromRenderQueue(go);
	end,
	---------------------------------------------------------------------
	RemoveAllDrops = function(self)
		--for _, go in ipairs(self.m_ActiveEnemyDrops) do
		for _, go in ipairs(self.m_EnemyDropPool:GetActivePool()) do
			self.m_EnemyDropPool:DeactivateResource(go);		
			RemoveFromRenderQueue(go);
		end
	end,
	---------------------------------------------------------------------
	GainCoin = function(self, drop)
		local coin = drop["Attribute"]:Get("Count") or 1;
		drop["Transform"]:SetScale(1.0);
		AudioManager:PlaySfx(SFX_OBJECT_COINS[coin]);
		--AudioManager:PlaySfx(SFX_OBJECT_COIN);
		MoneyManager:ModifyCoin(coin * self.m_CoinMultiplier);
		
		self.m_CoinGetCount = self.m_CoinGetCount + coin;
		self.m_InGameCoinMotionGC:ResetTarget(UI_INGAME_COIN_ORIGIN[1], UI_INGAME_COIN_ORIGIN[2] + 5);
		self.m_InGameCoinMotionGC:AppendNextTarget(UI_INGAME_COIN_ORIGIN[1], UI_INGAME_COIN_ORIGIN[2]);		
	end,
	---------------------------------------------------------------------
	GetActiveDrop = function(self)
		local dropPool = self.m_EnemyDropPool:GetActivePool();
		return dropPool[1];
	end,
	---------------------------------------------------------------------
	IsActiveDropState = function(self, state)
		local drop = self.m_EnemyDropPool:GetActivePool()[1];
		
		if (drop) then
			return drop["StateMachine"]:IsCurrentState(state);
		end
	end,
--[[ @CoinAutoPickup	
	---------------------------------------------------------------------
	AttackDrops = function(self, blade)
        if (#self.m_ActiveEnemyDrops == 0) then
			return;
		end
		
		local bladeBound = blade["Bound"];
		for _, drop in ipairs(self.m_ActiveEnemyDrops) do
			if (drop["StateMachine"]:IsStateChangeAllowed("shiny") and bladeBound:IsPickedObject(drop)) then
				local dropType = drop["Attribute"]:Get("Type");

				if (dropType == DROP_TYPE_COIN) then
				--====================================
				-- Coin
				--====================================
					local coin = (drop["Attribute"]:Get("Count") or 1) * self.m_CoinMultiplier;
					MoneyManager:ModifyCoin(coin);
					self:ModifyCoin(coin);	
					AudioManager:PlaySfx(SFX_OBJECT_COIN);
				elseif (dropType == DROP_TYPE_JADE) then					
				--====================================
				-- Jade
				--====================================
					local attr = drop["Attribute"]:Get("Attr");
					local effect = drop["Attribute"]:Get("Effect");
					--log("  => jade # "..drop["Attribute"]:Get("Effect").."  dur: "..attr[ST_JADE_DURATION].." sec");
					
					-- Exit from previous jade effect
					local prevEffect = self.m_JadeObject["Attribute"]:Get("Effect");
					if (prevEffect) then
						--log("  <<< Exit Jade @ "..prevEffect);
						JADE_EFFECT_FUNC[prevEffect]["Exit"]();
					end

					self.m_JadeObject["Timer"]:Reset(attr[ST_JADE_DURATION] * 1000 - JADE_BLINK_DURATION);
					self.m_JadeObject["Attribute"]:Set("Chance", attr[ST_JADE_CHANCE]);
					self.m_JadeObject["Attribute"]:Set("Effect", effect);
					self.m_JadeObject["StateMachine"]:ChangeState("jade", effect);
					
					drop["Attribute"]:Clear("Attr");
					drop["Attribute"]:Clear("Effect");
					
					AudioManager:PlaySfx(SFX_OBJECT_JADE);
				end
				
				drop["StateMachine"]:ChangeState("shiny");				
				return;
			end
		end
	end,
--]]
	--===================================================================
	-- Bullet
	--===================================================================

	---------------------------------------------------------------------
	LaunchBullet = function(self, go)
		local bullet = self.m_EnemyBulletPool:ActivateResource();
		if (bullet == nil) then
			return;
		end
				
		local bulletData = ENEMY_BULLET[go["Attribute"]:Get("look")];
		assert(bulletData);
		
		local x, y = go["Bound"]:GetCenter();
		bullet["Transform"]:SetTranslate(x, y);
		bullet["Sprite"]:ResetAnimation(bulletData[1], true, true);
		--local radius = bullet["Sprite"]:GetSize() * 0.5;
		--bullet["Bound"]:SetRadius(radius);
		bullet["Motion"]:SetVelocity(bulletData[2]);
		bullet["Motion"]:ResetTarget(LevelManager:GetBulletTargetPos(x, y));
		bullet["Attribute"]:Set("owner", go);
		bullet["StateMachine"]:ChangeState("shoot");

		AudioManager:PlaySfx(go["Attribute"]:Get("template")[ENEMY_TEMPLATE_SFX][ES_PREATTACK]);
	end,
	---------------------------------------------------------------------
	DeactivateBullet = function(self, go)
		self.m_EnemyBulletPool:DeactivateResource(go);
		RemoveFromRenderQueue(go);
	end,
	---------------------------------------------------------------------
	RemoveAllBullets = function(self)		
		for _, go in ipairs(self.m_EnemyBulletPool:GetActivePool()) do
			self.m_EnemyBulletPool:DeactivateResource(go);		
			RemoveFromRenderQueue(go);
		end
	end,

	--===================================================================
	-- Shadow
	--===================================================================

	---------------------------------------------------------------------
	AttachShadow = function(self, go)
		local shadow = self.m_EnemyShadowPool:ActivateResource();
		if (shadow == nil) then
			return;
		end

		local x, y = go["Transform"]:GetTranslate();
		shadow["Transform"]:SetTranslate(x, y + ENEMY_SHADOW_OFFSET);

		go["Attribute"]:Set("shadow", shadow);
		
		AddToPreRenderQueue(shadow);
	end,
	---------------------------------------------------------------------
	DetachShadow = function(self, go)
		self.m_EnemyShadowPool:DeactivateResource(go);

		RemoveFromPreRenderQueue(go);
	end,

	--===================================================================
	-- Effect
	--===================================================================

	---------------------------------------------------------------------
	LaunchEffect = function(self, go, type)
		local effect = self.m_EnemyEffectPool:ActivateResource();
		if (effect == nil) then
			return;
		end

		local x, y = go["Transform"]:GetTranslate();	
		local template = ENEMY_EFFECT[type];
		
		effect["Sprite"]:ResetAnimation(template[1], true);
		effect["Transform"]:SetTranslate(x + template[2], y + template[3]);
		effect["Transform"]:SetScale(2.0); -- for BOMB
		effect["StateMachine"]:ChangeState("active");
	
        AddToPostRenderQueue(effect);
	end,
	---------------------------------------------------------------------
	DeactivateEffect = function(self, go)
		self.m_EnemyEffectPool:DeactivateResource(go);
		
		RemoveFromPostRenderQueue(go);
	end,
	---------------------------------------------------------------------
	LaunchBomb = function(self, go)
        self:SetAnimation(go, ENEMY_ANIM_SKILL_ENTER);
		self:LaunchEffect(go, EFFECT_BOMB);
		self:RemoveAllEnchants(go, false);
		AudioManager:PlaySfx(SFX_OBJECT_BOMB);

		LevelManager:ShakeScene();
		
		if (LevelManager:AttackCastle(go)) then
			UpdateAchievement(ACH_BOMBER_MAN);
		end
	end,

	--===================================================================
	-- Enchant
	--===================================================================

	---------------------------------------------------------------------
	AddEnchant = function(self, go, enchant)
		local enchantGO = go["Attribute"]:Get("enchant");
		enchantGO["StateMachine"]:ChangeState(enchant, go);
	end,
	---------------------------------------------------------------------
	RemoveAllEnchants = function(self, go, lifebar)
		local enchantGO = go["Attribute"]:Get("enchant");
		enchantGO["StateMachine"]:ChangeState("inactive");		
		self:EnableEnemyLifebar(go, lifebar);
	end,
	---------------------------------------------------------------------
	HasEnchants = function(self, go)
		local enchantGO = go["Attribute"]:Get("enchant");
		if (enchantGO["StateMachine"]:IsCurrentState("inactive")) then
			return false
		end
		return true;
	end,
	---------------------------------------------------------------------
	SetLaunchEnchant = function(self, enchant)
		--log("SetLaunchEnchant: "..enchant)
		self.m_LaunchEnchant = enchant;
	end,
	---------------------------------------------------------------------
	SetBladeEnchant = function(self, enchant, chance)
		--log("SetBladeEnchant: "..enchant)
		self.m_BladeEnchant = enchant;
		self.m_BladeEnchantChance = chance;
	end,
	---------------------------------------------------------------------
	ClearBladeEnchant = function(self)
		self.m_BladeEnchant = nil;
		self.m_BladeEnchantChance = 0;
	end,
	---------------------------------------------------------------------
	EnableInnocentProtect = function(self, enable)
		self.m_InnocentProtect = enable;
	end,
	---------------------------------------------------------------------
	LaunchMultipleInnocent = function(self)
		for i = 1, 3 do
			g_TaskManager:AddTask(CallbackTask, { LaunchInnocentCallback }, math.random(200, 800), 0);
		end
	end,

	--===================================================================
	-- Stat & Combo
	--===================================================================
	---------------------------------------------------------------------
	UpdateComboInGame = function(self)
		self.m_ComboCount = self.m_ComboCount + 1;

		if (self.m_ComboCount == 20) then
			LevelManager:LaunchComboEffect(1);
		elseif (self.m_ComboCount == 50) then
			LevelManager:LaunchComboEffect(2);
		elseif (self.m_ComboCount == GC_ACHEIVEMENT_MAX[ACH_COMBO_MAX_LV1]) then
			LevelManager:LaunchComboEffect(3);
			UpdateAchievement(ACH_COMBO_MAX_LV1, GC_ACHEIVEMENT_MAX[ACH_COMBO_MAX_LV1], true);
		elseif (self.m_ComboCount == GC_ACHEIVEMENT_MAX[ACH_COMBO_MAX_LV2]) then
			UpdateAchievement(ACH_COMBO_MAX_LV2, GC_ACHEIVEMENT_MAX[ACH_COMBO_MAX_LV2], true);
		elseif (self.m_ComboCount == GC_ACHEIVEMENT_MAX[ACH_COMBO_MAX_LV3]) then
			UpdateAchievement(ACH_COMBO_MAX_LV3, GC_ACHEIVEMENT_MAX[ACH_COMBO_MAX_LV3], true);
		end

		if (self.m_ComboCount > 1) then		
			self.m_ComboWidget:SetValue(self.m_ComboCount);
---[[ @Screenshot
			self.m_ComboWidgetSM:ChangeState("show");
--]]			
		end
	end,
	---------------------------------------------------------------------
	UpdateComboInTutorial = function(self)
	end,
	---------------------------------------------------------------------
	ResetCombo = function(self)
		self.m_ComboCount = 0;
		self.m_ComboWidgetSM:ChangeState("hide");
		LevelManager:RemoveComboEffect();
	end,
	---------------------------------------------------------------------
	GetTotalComboCount = function(self)
		return self.m_TotalComboCount;
	end,
	---------------------------------------------------------------------
	ResetCoin = function(self)
		self.m_CoinGetCount = 0;
	end,
	---------------------------------------------------------------------
	GetCoin = function(self)
		return self.m_CoinGetCount;
	end,
--[[
	---------------------------------------------------------------------
	ModifyCoin = function(self, num)
		self.m_CoinGetCount = self.m_CoinGetCount + num;
	end,
	---------------------------------------------------------------------
	LaunchTreasure = function(self)
		if (self.m_EnemyTreasure["StateMachine"]:IsCurrentState("inactive")) then
			local dice = math.random(1, 100);
			if (dice <= 33) then

				local dropType = math.random(1, 100);
				local dropIndex;
				if (dropType <= TREASURE_DROP[1][1]) then
					dropIndex = 1;
				elseif (dropType <= TREASURE_DROP[2][1]) then
					dropIndex = 2;
				else
					dropIndex = 3;
				end

				self.m_EnemyTreasure["Sprite"]:SetImage(TREASURE_DROP[dropIndex][3]);
				self.m_EnemyTreasure["Attribute"]:Set("life", TREASURE_DROP[dropIndex][2]);
				self.m_EnemyTreasure["Attribute"]:Set("opened", TREASURE_DROP[dropIndex][4]);
				
				AddToRenderQueue(self.m_EnemyTreasure);

				return self.m_EnemyTreasure;
			end
		end
	end,
	---------------------------------------------------------------------
	LaunchTreasureDrops = function(self, go)
		local x, y = go["Transform"]:GetTranslate();
		x = x + 46; -- Radius of treasure chest
		y = y + 28;
		
		local dropsCount = math.random(4, 8);
		
		for i = 1, dropsCount do
			local drop = self.m_EnemyDropPool:ActivateResource();

			if (drop) then                    
				drop["Transform"]:SetTranslate(ModifyValueByRandRange(x, 30), ModifyValueByRandRange(y, 30));
				drop["Sprite"]:ResetAnimation(DROP_COIN_DATA[1][2], true);
				drop["StateMachine"]:ChangeState("show");
			else
				return;
			end
		end
	end,
	---------------------------------------------------------------------
	DeactivateTreasure = function(self, go)
		self.m_EnemyTreasure["StateMachine"]:ChangeState("inactive");
		
		RemoveFromRenderQueue(go);
	end,
--]]	
--[[	
	---------------------------------------------------------------------
	EnchantRandomEnemies = function(self, enchant)
		local candidates = {};
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			if (enemy["Attribute"]:Get("enchantable") and enemy["StateMachine"]:IsStateChangeAllowed("die") and self:IsEnemyInRange(enemy)) then
				table.insert(candidates, enemy);
			end
		end

		if (#candidates <= ENEMY_SCROLL_RAND_THESHOLD) then
			for _, enemy in ipairs(candidates) do
			    self:AddEnchant(enemy, enchant);
			end
		else
			for _, enemy in ipairs(candidates) do
				if (math.random(1, 100) <= ENEMY_SCROLL_HIT_CHANCE) then
					self:AddEnchant(enemy, enchant);
				end
			end
		end
	end,
	---------------------------------------------------------------------
	KillRandomEnemies = function(self)
		local candidates = {};
		for _, enemy in ipairs(self.m_ActiveEnemies) do
			if (not enemy["Attribute"]:Get("innocent") and
				enemy["StateMachine"]:IsStateChangeAllowed("die") and self:IsEnemyInRange(enemy)) then
				table.insert(candidates, enemy);
			end
		end
		
		if (#candidates <= ENEMY_SCROLL_RAND_THESHOLD) then
			for _, enemy in ipairs(candidates) do
			    enemy["StateMachine"]:ChangeState("die", true);
			end
		else
			for _, enemy in ipairs(candidates) do
				if (math.random(1, 100) <= ENEMY_SCROLL_HIT_CHANCE) then
					enemy["StateMachine"]:ChangeState("die", true);
				end
			end
		end
	end,
	---------------------------------------------------------------------
	IsEnemyInRange = function(self, go)
		if (go["Transform"]:GetTranslateX() >= 0) then
			return true;
		end
		return false;
	end,
--]]	
};



--=======================================================================
-- @Utility
--=======================================================================
-------------------------------------------------------------------------
function LaunchInnocentCallback()
	EnemyManager:LaunchEnemy(RandElement(BOSS_INNOCENT_POOL));
	EnemyManager:LaunchEnemy(RandElement(BOSS_INNOCENT_POOL));	
	if (math.random(1, 100) > 50) then
		EnemyManager:LaunchEnemy(RandElement(BOSS_INNOCENT_POOL));
	end
	
	if (math.random(1, 100) > 66) then
		EnemyManager:LaunchEnemy(Enemy_ObjectBombcask);
	end
end

-------------------------------------------------------------------------
function LaunchCoinCallback(data)
	local drop = EnemyManager.m_EnemyDropPool:ActivateResource();
	
	if (drop) then
		local x = data[1];
		local y = data[2];
		local r = data[3];
		local coinType = DROP_COIN_DATA[ data[4] ] or DROP_COIN_DATA[1];

		drop["Transform"]:SetTranslate(ModifyValueByRandRange(x + r, 30), ModifyValueByRandRange(y + r, 30));
		drop["Transform"]:SetScale(coinType[COIN_SCALE]);
		drop["Sprite"]:ResetAnimation(coinType[COIN_LOOK], true);
		drop["Sprite"]:SetAlpha(ALPHA_MAX);
		drop["Motion"]:Reset();
		drop["Interpolator"]:Reset();
		drop["Attribute"]:Set("Count", coinType[COIN_VALUE]);
		drop["Attribute"]:Set("Type", DROP_TYPE_COIN);
		drop["StateMachine"]:ChangeState("coin_moving");
	end
end

-------------------------------------------------------------------------
function LaunchBullet(go)
	EnemyManager:LaunchBullet(go);
end

-------------------------------------------------------------------------
function SetEnemyEnchant(enemy, effectGo, effectId)
	local fx = EFFECT_OFFSET[effectId];
	local offset = fx[enemy["Attribute"]:Get("template")] or fx["Default"];

	enemy:ReattachObject(effectGo, offset[1], offset[2]);

	effectGo["Sprite"]:ResetAnimation(EFFECT_ANIM[effectId], true);
end

--=======================================================================
-- @Value Update Utility
--=======================================================================

-------------------------------------------------------------------------
function UpdateGOScaleAndAngle(value, go)
    go:SetScale(value);
    go:SetRotateByDegree(200 * (value - (ENEMY_SCALE_EXPLODE - 1.0)));
end



--=======================================================================
-- @Splite Utility
--=======================================================================

-------------------------------------------------------------------------

SPLIT_FACTOR = 20;
SPLIT_OFFSET = 10;
SPLIT_DURATION = 750;

--[[

     1   2
   _________
 8 |   |   | 3
   _________
 7 |   |   | 4
   _________
     6   5

--]]

-------------------------------------------------------------------------
function SpliteSprite(go, sliceDir)
    local sprite1 = go["SpriteGroup"]:GetSprite(1);
    local sprite2 = go["SpriteGroup"]:GetSprite(2);

--[[    
    -- Must do it before GetTexCoords()
    local name = go["Attribute"]:Get("look") .. ENEMY_ANIM_WOUNDED_SINGLE;
    sprite1:ResetImage(name);
    sprite2:ResetImage(name);    
--]]

--[[ @Random slices
    local sliceType = sliceDir or math.random(1, 4);
--]]

	local sliceType, transX, transY = BladeManager:GetSliceData();
	--log("sliceType: "..sliceType.." => transX: "..transX.." transY: "..transY);

    local width, height = sprite1:GetSize();
    local u1, v1, u2, v2 = sprite1:GetTexCoords();	
    local slicePoint1, slicePoint2;

	if (sliceType == 1) then
		slicePoint1 = math.random(width * 0.25, width * 0.5);
		slicePoint2 = math.min(slicePoint1 + transX, width);
	elseif (sliceType == 2) then
		slicePoint1 = math.random(width * 0.5, width * 0.75);
		slicePoint2 = math.max(slicePoint1 - transX, 0);
	elseif (sliceType == 3) then
		slicePoint1 = math.random(height * 0.25, height * 0.5);
		slicePoint2 = math.min(slicePoint1 + transY, height);
	elseif (sliceType == 4) then
		slicePoint1 = math.random(height * 0.5, height * 0.75);
		slicePoint2 = math.max(slicePoint1 - transY, 0);
	else
        assert(false, "Non supported slice type");
    end
	
    local vx, vy, ox, oy;

	if (sliceType == 1 or sliceType == 2) then
	-- Vertical slices
		local sliceTexCoord1 = (slicePoint1 / width) * (u2 - u1) + u1;
		local sliceTexCoord2 = (slicePoint2 / width) * (u2 - u1) + u1;

		sprite1:SetQuadVertices(0, 0, 0, height, slicePoint1, 0, slicePoint2, height);
		sprite1:SetQuadTexCoords(u1, v1, u1, v2, sliceTexCoord1, v1, sliceTexCoord2, v2);

		sprite2:SetQuadVertices(slicePoint1, 0, slicePoint2, height, width, 0, width, height);
		sprite2:SetQuadTexCoords(sliceTexCoord1, v1, sliceTexCoord2, v2, u2, v1, u2, v2);

		vx = slicePoint1 - slicePoint2;
        vy = -height;
        
        ox = SPLIT_OFFSET;
        oy = 0;
	else
	-- Horizontal slices
		local sliceTexCoord1 = (slicePoint1 / height) * (v2 - v1) + v1;
		local sliceTexCoord2 = (slicePoint2 / height) * (v2 - v1) + v1;

		sprite1:SetQuadVertices(0, 0, 0, slicePoint2, width, 0, width, slicePoint1);
		sprite1:SetQuadTexCoords(u1, v1, u1, sliceTexCoord2, u2, v1, u2, sliceTexCoord1);

		sprite2:SetQuadVertices(0, slicePoint2, 0, height, width, slicePoint1, width, height);
		sprite2:SetQuadTexCoords(u1, sliceTexCoord2, u1, v2, u2, sliceTexCoord1, u2, v2);

        vx = width;
        vy = slicePoint1 - slicePoint2;
        
        ox = 0;
        oy = SPLIT_OFFSET;
	end

    go["SplitX"], go["SplitY"] = Normalize(vx, vy);
    go["OffsetX"], go["OffsetY"] = ox, oy;
    
    go["SpriteGroup"]:EnableRender(1, true);
    go["SpriteGroup"]:EnableRender(2, true);
    go["SpriteGroup"]:EnableRender(3, false);

    go["Interpolator"]:AppendNextTarget(0, 1, SPLIT_DURATION);
    go["Interpolator"]:AttachCallback(UpdateEnemySplit, EndEnemySplit, go);
end

-------------------------------------------------------------------------
function UpdateEnemySplit(value, go)
    local vx = go["SplitX"] * value * SPLIT_FACTOR;
    local vy = go["SplitY"] * value * SPLIT_FACTOR;
	
    go["SpriteGroup"]:SetOffset(1, vx, vy);
    go["SpriteGroup"]:SetOffset(2, -vx + go["OffsetX"], -vy + go["OffsetY"]);

    go["SpriteGroup"]:GetSprite(1):SetAlpha(1 - value);
    go["SpriteGroup"]:GetSprite(2):SetAlpha(1 - value);    
end

-------------------------------------------------------------------------
function EndEnemySplit(value, go)
    go["SpriteGroup"]:EnableRender(1, false);
    go["SpriteGroup"]:EnableRender(2, false);
    go["SpriteGroup"]:EnableRender(3, true);
end
