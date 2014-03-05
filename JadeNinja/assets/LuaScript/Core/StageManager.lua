--***********************************************************************
-- @file StageManager.lua
--***********************************************************************

--=======================================================================
-- StageManager
--=======================================================================

StageManager =
{
    --
    -- Fields
    --
    m_GameStageTemplates = {},
	m_StagesStack = {},
	m_CurrentStage = nil,
	m_CurrentStageState = nil,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------------
    AddStageTemplate = function(self, template)
        self.m_GameStageTemplates[template.id] = template;
    end,
    ---------------------------------------------------------------------
	ChangeStage = function(self, id, state)
        assert(self.m_GameStageTemplates[id], "StageManager:ChangeStage() error: [id] " .. id);
		
		-- Proceed 'OnExit' of old stage
		local oldUI;
        if (self.m_CurrentStage and self.m_CurrentStage["OnExit"]) then
        --log("OnExit >>> " .. self.m_CurrentStage["id"]);            
            
			if IS_PLATFORM_ANDROID then
				local msg = "OnExit Stage: " .. self.m_CurrentStage["id"];
				g_JavaInterface:TestFlightPassCheckpoint(msg);
			end

            self.m_CurrentStage["OnExit"](self.m_CurrentStageState);
			oldUI = self.m_CurrentStage["ui"];
        end

		-- Change to new stage
        self.m_CurrentStage = self.m_GameStageTemplates[id];
        self.m_CurrentStageState = state;
		
		-- UI related
		local newUI = self.m_CurrentStage["ui"];
		
		if (oldUI ~= newUI) then
			if (oldUI) then
				UIManager:ToggleUI(oldUI);
			end
			if (newUI) then
				UIManager:ToggleUI(newUI);
			end
		end
	
		-- Proceed 'OnEnter' of new stage
        if (self.m_CurrentStage["OnEnter"]) then
        --log("OnEnter << " .. self.m_CurrentStage["id"]);    

			if IS_PLATFORM_ANDROID then
				local msg = "OnEnter Stage: " .. self.m_CurrentStage["id"];
				g_JavaInterface:TestFlightPassCheckpoint(msg);
			end

            self.m_CurrentStage["OnEnter"](self.m_CurrentStageState);
        end
    end,
    ---------------------------------------------------------------------
	ChangeStageWithMotion = function(self, sourceStageId, destStageId, x, y, destX, destY)	
		if (self.m_IsOnMotion) then
			return;
		end
			
		local sourceUI = self.m_GameStageTemplates[sourceStageId]["ui"];
		local destUI = self.m_GameStageTemplates[destStageId]["ui"];

		self.m_UIMotionSourceUI = sourceUI;
		self.m_UIMotionDestUI = destUI;
		self.m_UIMotionDestStage = destStageId;
		self.m_IsOnMotion = true;

		UIManager:ToggleUI(destUI);
		
		local ui1 = UIManager:GetUI(sourceUI);
		ui1:GetComponent("Motion"):ResetTarget(x, y);
		ui1:LockAllWidgets(true);

		local ui2 = UIManager:GetUI(destUI);
		ui2:GetComponent("Motion"):ResetTarget((destX or 0), (destY or 0));
		ui2:LockAllWidgets(true);

		self.m_GameStageTemplates["UIMotionStage"]["ui"] = destUI;
        self.m_CurrentStage = self.m_GameStageTemplates["UIMotionStage"];
		self.m_CurrentStage["OnEnter"]();
	end,
    ---------------------------------------------------------------------
	ChangeStageForPopup = function(self, id, skipOldUI, skipNewUI)
        assert(self.m_GameStageTemplates[id], "StageManager:ChangeStage() error: [id] " .. id);
		local oldUI;
		local newUI;
		
        if (self.m_CurrentStage and self.m_CurrentStage["OnExit"]) then

			if IS_PLATFORM_ANDROID then
				local msg = "OnExit Stage: " .. self.m_CurrentStage["id"];
				g_JavaInterface:TestFlightPassCheckpoint(msg);
			end

            self.m_CurrentStage["OnExit"](self.m_CurrentStageState);
			oldUI = self.m_CurrentStage["ui"];
        end

        self.m_CurrentStage = self.m_GameStageTemplates[id];
        self.m_CurrentStageState = state;
		newUI = self.m_CurrentStage["ui"];
		
		-- UI related
		if (skipOldUI) then
			if (newUI) then
				UIManager:ToggleUI(newUI);
			end
		end
	
		if (skipNewUI) then
			if (oldUI) then
				UIManager:ToggleUI(oldUI);
			end
		end
		
        if (self.m_CurrentStage["OnEnter"]) then

			if IS_PLATFORM_ANDROID then
				local msg = "OnEnter Stage: " .. self.m_CurrentStage["id"];
				g_JavaInterface:TestFlightPassCheckpoint(msg);
			end

            self.m_CurrentStage["OnEnter"](self.m_CurrentStageState);
        end
    end,
    ---------------------------------------------------------------------
	UpdateUIMotionStage = function(self)
		if (UIManager:GetUIComponent(self.m_UIMotionDestUI, "Motion"):IsDone()) then
			self.m_IsOnMotion = false;
			
			UIManager:ToggleUI(self.m_UIMotionSourceUI);
			UIManager:GetUI(self.m_UIMotionSourceUI):LockAllWidgets(false);
			UIManager:GetUI(self.m_UIMotionDestUI):LockAllWidgets(false);

			self:ChangeStage(self.m_UIMotionDestStage);
		end
	end,
    ---------------------------------------------------------------------
    GetCurrentStageId = function(self)
        assert(self.m_CurrentStage ~= nil);
        return self.m_CurrentStage["id"];
    end,
    ---------------------------------------------------------------------    
	GetStageState = function(self)
		return self.m_CurrentStageState;
	end,
    ---------------------------------------------------------------------    
    IsOnStage = function(self, id)
        if (self.m_GameStageTemplates[id] == self.m_CurrentStage) then
            return true;
        end
        
        return false;
    end,
    ---------------------------------------------------------------------
	PushStage = function(self, id, state)
        if (self.m_CurrentStage ~= nil) then
            table.insert(self.m_StagesStack, self.m_CurrentStage["id"]);
        end
        
        self:ChangeStage(id, state);
	end,
    ---------------------------------------------------------------------
	PopStage = function(self)
        local id = table.remove(self.m_StagesStack)
        
        if (id ~= nil) then         
            self:ChangeStage(id);
        end
	end,
    ---------------------------------------------------------------------
	PushStageForPopup = function(self, id)
        if (self.m_CurrentStage ~= nil) then
            table.insert(self.m_StagesStack, self.m_CurrentStage["id"]);
        end
        
        self:ChangeStageForPopup(id, true, false);
	end,
    ---------------------------------------------------------------------
	PopStageForPopup = function(self)
        local id = table.remove(self.m_StagesStack)
        
        if (id ~= nil) then         
            self:ChangeStageForPopup(id, false, true);
        end
	end,
    ---------------------------------------------------------------------
	ProcessInput = function(self)
		if (self.m_CurrentStage["ProcessInput"] ~= nil) then
			self.m_CurrentStage["ProcessInput"]();
		end
	end,
    ---------------------------------------------------------------------
	TouchBegan = function(self, x, y)
		if (self.m_CurrentStage["TouchBegan"] ~= nil) then
			self.m_CurrentStage["TouchBegan"](x, y);
		end
	end,
    ---------------------------------------------------------------------
	TouchMoved = function(self, x, y)
		if (self.m_CurrentStage["TouchMoved"] ~= nil) then
			self.m_CurrentStage["TouchMoved"](x, y);
		end
	end,
    ---------------------------------------------------------------------
	TouchEnded = function(self, x, y)
		if (self.m_CurrentStage["TouchEnded"] ~= nil) then
			self.m_CurrentStage["TouchEnded"](x, y);
		end
	end,
    ---------------------------------------------------------------------
	Update = function(self)
		if (self.m_CurrentStage["Update"] ~= nil) then
			self.m_CurrentStage["Update"]();
		end
	end,
    ---------------------------------------------------------------------
	Render = function(self)
		if (self.m_CurrentStage["Render"] ~= nil) then
			self.m_CurrentStage["Render"]();
		end
	end,
    ---------------------------------------------------------------------
	RenderNonTransform = function(self)
		if (self.m_CurrentStage["RenderNonTransform"] ~= nil) then
			self.m_CurrentStage["RenderNonTransform"]();
		end
	end,
};



--------------------------------------------------------------------------------
function GameStageTemplate(t)
    assert(t.id ~= nil, "Failed to create game stage template");
    
    StageManager:AddStageTemplate(t);
end

--------------------------------------------------------------------------------
GameStageTemplate
{
    id = "UIMotionStage",
	
	OnEnter = function()
		--log("enter @ UIMotionStage")	
	end,

	OnExit = function()
		--log("exit @ UIMotionStage")
	end,

	Update = function(args)
		StageManager:UpdateUIMotionStage();
	end,
};
