--***********************************************************************
-- @file UIManager.lua
--***********************************************************************

--=======================================================================
-- Constants
--=======================================================================

UI_FADE_DURATION = 250;
UI_SWIPE_AXIS_X = 1;
UI_SWIPE_AXIS_Y = 2;
UI_SWIPE_MOTION_VELOCITY = 1300 * APP_SCALE_FACTOR;

AQ_UI_SHOW = 1;
AQ_UI_HIDE = 2;
AQ_FADE_IN = 3;
AQ_FADE_OUT = 4;
AQ_WIDGET_MOTION = 5;
AQ_WIDGET_SCALE = 6;

AXIS_X_CENTER = 10001;
AXIS_Y_CENTER = 10002;
AXIS_XY_CENTER = 10003;
AXIS_XY_ANY = 10004;


--=======================================================================
-- UIManager
--=======================================================================

UIManager =
{
    --
    -- Fields
    --
    m_GameUITemplates = {},
    m_GameUIWidgetTemplates = {},
    m_ActiveUI = {},
	m_ModalUI = {},
	
	m_OnModalUI = false,
	m_MouseWasPressed = false,
	m_OnEffect = false,

	m_PositionX = 0,
	m_PositionY = 0,

    --
    -- Private Methods
    --
    ---------------------------------------------------------------
    Instance = function(self, o)
        o = o or {};
        setmetatable(o, self);
        self.__index = self;
        return o;
    end,
    ---------------------------------------------------------------
    Create = function(self)
        -- Create component
        local o = self:Instance();

		-- Create TaskManager for UI
		g_UITaskMgr = TaskManager:Create();

		GameObjectTemplate
		{
			class = "UIFade",
		
			components =
			{
				{
					class = "Transform",
				},
		
				{
					class = "RectangleShape",
					width = SCREEN_UNIT_X,
					height = SCREEN_UNIT_Y,
					color = { 0, 0, 0, 0 },
				},
		
				{
					class = "TimeBasedInterpolator",
				},
			},
		};
		
		g_FadeFrameUI = ObjectFactory:CreateGameObject("UIFade");
		g_FadeFrameUI["Interpolator"]:AttachCallback(UpdateFadeFrameAlpha);
		
        return o;
    end,

    --
    -- Public Methods
    --
	--------------------------------------------------------------------------------
    AddGameUIWidgetTemplate = function(self, widget, class)
		self.m_GameUIWidgetTemplates[class] = widget;
    end,
	--------------------------------------------------------------------------------
    CreateGameUITemplate = function(self, template, newName)
        local name = newName or template.name;
        assert(self.m_GameUITemplates[name] == nil, "UI template name has duplicated: " .. name);

        -- Create UI frame object
		local ui = UIFrame:Create(template, name);

        -- Create UI widgets
		local widgetCount = 0;
        
        for _, widget in pairs(template.widgets) do
            assert(widget.class, "UI widget class error");
            assert(self.m_GameUIWidgetTemplates[widget.class], "UI widget template has not found: " .. widget.class);

            -- Set default name for widget if not specified
            widgetCount = widgetCount + 1;
            if (widget.name == nil) then
                widget.name = string.format("%s_w%d", name, widgetCount);
            end

			if (template.indie) then	-- If parent UI frame is indie, all its widgets must be indie too
				widget.indie = template.indie;
				--log("WID: "..widget.name.." @ ui: "..name)
				if (IS_DEVICE_IPAD) then
					widget.x = (widget.x or 0) * 2;
					widget.y = (widget.y or 0) * 2;
				elseif IS_PLATFORM_ANDROID then
					widget.x = (widget.x or 0) * APP_SCALE_FACTOR;
					widget.y = (widget.y or 0) * APP_SCALE_FACTOR;
				end
			end
            
            assert(ui.m_Widgets[widget.name] == nil, "UI widget name duplicated: [" .. name .. "] " .. widget.name);
            
            -- Create widget object
            local obj = self.m_GameUIWidgetTemplates[widget.class]:Create(widget, ui);

			if (template.reloadable) then
				obj.m_GameObject:EnableReloadable(true);
			end

            -- Create specified components for widget
            if (widget.components ~= nil) then
                for _, com in ipairs(widget.components) do
                    -- Create and add new component to object
                    ObjectFactory:AttachGameComponent(obj.m_GameObject, com);
                end
            end
---[[
			if (widget.axis ~= nil) then
				--log("AlignObject @ WIDGET: "..widget.name)
				AlignObject(widget, obj.m_GameObject, ui.m_GameObject);
			end
--]]
            -- Initialize widget if necessary
            if (obj.Init ~= nil) then
                obj:Init();
            end

            -- Add widget to parent frame
            ui:AddWidget(widget.name, obj, widget.hide);
        end

        -- UI swipe functions
        if (template.onSwipe) then
			ui:InitializeSwipe(template.onSwipe);
        end
		
		-- UI widget groups
		if (template.groups) then
			ui:AddWidgetGroups(template.groups);
		end

		-- UI effects
		if (template.effects) then
			ui.onShow = template.effects.onShow;
			ui.onHide = template.effects.onHide;
		end

		-- Insert it to UI templates
		self.m_GameUITemplates[name] = ui;
    end,
	--------------------------------------------------------------------------------
    CloneUI = function(self, name, newName)
        assert(self.m_GameUITemplates[name] ~= nil);
        
        self:CreateGameUITemplate(self:GetUITemplate(name), newName);
    end,
	--------------------------------------------------------------------------------
	ResetUI = function(self, name)
		if (self.m_GameUITemplates[name] ~= nil) then
			self.m_GameUITemplates[name]:Reset();
		end
	end,
 	--------------------------------------------------------------------------------
	FadeCycle = function(self)
		g_UITaskMgr:AddTask(UIFadeCycleTask, { ALPHA_ZERO, ALPHA_MAX, 500 }, 550);
	end,
 	--------------------------------------------------------------------------------
	ProceedEffects = function(self, fxList, ui)
		assert(fxList);

		for _, fx in ipairs(fxList) do
			local fxType = fx[1];
			
			if (fxType == AQ_FADE_IN) then
				g_UITaskMgr:AddTask(UIFadeTask, { ALPHA_MAX, ALPHA_ZERO, UI_FADE_DURATION }, UI_FADE_DURATION);
			elseif (fxType == AQ_FADE_OUT) then
				g_UITaskMgr:AddTask(UIFadeTask, { ALPHA_ZERO, ALPHA_MAX, UI_FADE_DURATION }, UI_FADE_DURATION);
			elseif (fxType == AQ_WIDGET_MOTION) then
				local motionCom = ui:GetWidgetComponent(fx[2], "Motion");				
				ui:GetWidgetComponent(fx[2], "Transform"):SetTranslate(fx[3], fx[4]);
				g_UITaskMgr:AddTask(UIMotionTask, { motionCom, fx[5], fx[6] }, fx[7]);
			elseif (fxType == AQ_WIDGET_SCALE) then
				local interCom = ui:GetComponent("Interpolator");				
				g_UITaskMgr:AddTask(UIScaleTask, { ui, interCom, fx[2], fx[3], fx[4] }, fx[4]);
			else
				assert(false, "Unsupported UI effect type: "..fxType);
			end
		end
	end,
 	--------------------------------------------------------------------------------
	ProceedPreEffects = function(self, fxList, ui)
		for _, fx in ipairs(fxList) do
			if(fx[1] == AQ_WIDGET_SCALE) then
				ui:ScaleAllWidgets(fx[2]);
			end
		end
	end,
	--------------------------------------------------------------------------------
	AddToQueue = function(self, op, ui, args)
		if (op == AQ_UI_SHOW) then
			if (ui.onShow) then
				self:ProceedPreEffects(ui.onShow, ui);
				g_UITaskMgr:AddTask(UIActivateTask, args);			
				self:ProceedEffects(ui.onShow, ui);
			else
				self:ActivateUI(args);
			end
		elseif (op == AQ_UI_HIDE) then
			if (ui.onHide) then
				self:ProceedEffects(ui.onHide, ui);			
				g_UITaskMgr:AddTask(UIDeactivateTask, args);
			else
				self:DeactivateUI(args);
			end
		end
	end,
	--------------------------------------------------------------------------------
	UpdateModalUIStatus = function(self)
		if (#self.m_ModalUI > 0) then
			self.m_OnModalUI = true;
		else
			self.m_OnModalUI = false;
		end
	end,
	--------------------------------------------------------------------------------
	AddTimeDelayEffect = function(self, duration)
		g_UITaskMgr:AddTask(TimeDelayTask, nil, duration);
	end,
	
    --========================
    -- Activate/Deactivate UI
    --========================

	--------------------------------------------------------------------------------
	ActivateUI = function(self, ui)
		ui:Reload();
		
		table.insert(self.m_ActiveUI, ui);
	end,
	--------------------------------------------------------------------------------
	DeactivateUI = function(self, index)
		local ui = table.remove(self.m_ActiveUI, index);

		ui:Unload();
	end,
	--------------------------------------------------------------------------------
	ActivateModalUI = function(self, ui)
		ui:Reload();
		
		table.insert(self.m_ModalUI, ui);
		self:UpdateModalUIStatus();
	end,
	--------------------------------------------------------------------------------
	DeactivateModalUI = function(self, index)
		local ui = table.remove(self.m_ModalUI, index);
		self:UpdateModalUIStatus();

		ui:Unload();
	end,
	--------------------------------------------------------------------------------
	CloseUI = function(self, uiName)
		for i, v in ipairs(self.m_ActiveUI) do
			if (v:GetName() == uiName) then
				local ui = table.remove(self.m_ActiveUI, i);
				ui:Unload();
				return;
			end
		end
		log("UIManager:CloseUI() not found: "..uiName);
	end,
	
    --========================
    -- Activate/Deactivate UI
    --========================

	--------------------------------------------------------------------------------
	MoveUIToFirst = function(self, uiName)
		for i, v in ipairs(self.m_ActiveUI) do
			if (v:GetName() == uiName) then
				local ui = table.remove(self.m_ActiveUI, i);
				table.insert(self.m_ActiveUI, ui, 1);
				return;
			end
		end
	end,
	--------------------------------------------------------------------------------
	MoveUIToLast = function(self, uiName)
		for i, v in ipairs(self.m_ActiveUI) do
			if (v:GetName() == uiName) then
				local ui = table.remove(self.m_ActiveUI, i);
				table.insert(self.m_ActiveUI, ui);
				return;
			end
		end
	end,
	
    --========================
    -- Toggle 
    --========================

	--------------------------------------------------------------------------------
	ToggleUI = function(self, name)
		local ui = self.m_GameUITemplates[name];
		assert(ui, "UI does not exist: "..name);
		
		if (ui:IsModal()) then
			for index, modalUI in ipairs(self.m_ModalUI) do
				if (modalUI.m_Name == name) then
					--table.remove(self.m_ModalUI, index);
					--self:UpdateModalUIStatus(ui);
					--log("ModalUI [off]: " .. name);
					self:DeactivateModalUI(index);
					return;
				end
			end
			
			--table.insert(self.m_ModalUI, ui);
			--self:UpdateModalUIStatus(ui);			
			--log("ModalUI [on]: " .. name);
			self:ActivateModalUI(ui);
		else
			for index, activeUI in ipairs(self.m_ActiveUI) do
				if (activeUI.m_Name == name) then
	                --log("ToggleUI [off]: " .. name);
					self:AddToQueue(AQ_UI_HIDE, activeUI, index);
					return;
				end
			end	
            --log("ToggleUI [on] : " .. name);
			self:AddToQueue(AQ_UI_SHOW, ui, ui);
		end		
	end,
	--------------------------------------------------------------------------------
	ToggleWidgetGroup = function(self, uiName, groupName, enable)
		local ui = self.m_GameUITemplates[uiName];
		assert(ui.m_WidgetGroups[groupName]);
		
		for _, widget in ipairs(ui.m_WidgetGroups[groupName]) do
			ui.m_Widgets[widget].show = enable;
		end
	end,

    --========================
    -- Enable/Disable
    --========================

	--------------------------------------------------------------------------------
	EnableUI = function(self, name, enable)
		local ui = self.m_GameUITemplates[name];
		assert(ui, "UI does not exist: "..name);
		
		if (ui:IsModal()) then
			if (enable) then
				table.insert(self.m_ModalUI, ui);
				self:UpdateModalUIStatus();
			else
				for index, modalUI in ipairs(self.m_ModalUI) do
					if (modalUI.m_Name == name) then
						table.remove(self.m_ModalUI, index);
						self:UpdateModalUIStatus();
						return;
					end
				end
			end
		else
			if (enable) then
				table.insert(self.m_ActiveUI, ui);
			else
				for index, activeUI in ipairs(self.m_ActiveUI) do
					if (activeUI.m_Name == name) then
						table.remove(self.m_ActiveUI, index);
						return;
					end
				end
			end
		end
	end,
	--------------------------------------------------------------------------------
    EnableWidget = function(self, ui, widget, enable)
		assert(self.m_GameUITemplates[ui].m_Widgets[widget], "widget: "..widget)
        self.m_GameUITemplates[ui].m_Widgets[widget].show = enable;
    end,

    --========================
    -- Getters
    --========================

    -------------------------------------------------------------------------
	GetUI = function(self, name)
		return self.m_GameUITemplates[name];
	end,
	--------------------------------------------------------------------------------
	GetUIObject = function(self, name)
		return self.m_GameUITemplates[name].m_GameObject;
	end,
	--------------------------------------------------------------------------------
	GetUIComponent = function(self, ui, comp)
		return self.m_GameUITemplates[ui].m_GameObject[comp];
	end,
	--------------------------------------------------------------------------------
	GetUITemplate = function(self, ui)
		return self.m_GameUITemplates[ui].m_Template;
	end,
	--------------------------------------------------------------------------------
	GetWidget = function(self, ui, widget)
		--assert(self.m_GameUITemplates[ui], "GetWidget error: [ui] "..ui);
		--assert(self.m_GameUITemplates[ui].m_Widgets[widget], "GetWidget error: [widget] "..widget);
		return self.m_GameUITemplates[ui].m_Widgets[widget];
	end,
	--------------------------------------------------------------------------------
	GetWidgetObject = function(self, ui, widget)
		--assert(self.m_GameUITemplates[ui], "GetWidgetObject error: [ui] "..ui);
		--assert(self.m_GameUITemplates[ui].m_Widgets[widget], "GetWidgetObject error: [widget] "..widget);
		return self.m_GameUITemplates[ui].m_Widgets[widget].m_GameObject;
	end,
	--------------------------------------------------------------------------------
	GetWidgetComponent = function(self, ui, widget, comp)
		assert(self.m_GameUITemplates[ui].m_Widgets[widget], "GetWidgetComponent error: [widget] "..widget.." [ui] "..ui);
		assert(self.m_GameUITemplates[ui].m_Widgets[widget].m_GameObject[comp], "GetWidgetComponent error: [com] "..comp.." [widget] "..widget.." [ui] "..ui);
		return self.m_GameUITemplates[ui].m_Widgets[widget].m_GameObject[comp];
	end,
	--------------------------------------------------------------------------------
    GetWidgetEnable = function(self, ui, widget)
        return self.m_GameUITemplates[ui].m_Widgets[widget].show;
    end,
	--------------------------------------------------------------------------------
	GetWidgetGroup = function(self, ui, group)
		return self.m_GameUITemplates[ui].m_WidgetGroups[group];
	end,
	--------------------------------------------------------------------------------
	ScaleUI = function(self, ui, scale)
		self.m_GameUITemplates[ui]:ScaleAllWidgets(scale);
	end,
	--------------------------------------------------------------------------------
	SetUIAlpha = function(self, ui, alpha)
		self.m_GameUITemplates[ui]:SetAllWidgetsAlpha(alpha);
	end,
	--------------------------------------------------------------------------------
	ExchangeWidgetOrder = function(self, ui, widget1, widget2)
		local frame = self.m_GameUITemplates[ui];
		local object1, index1 = frame:GetWidgetObjectAndOrder(widget1);
		local object2, index2 = frame:GetWidgetObjectAndOrder(widget2);
		
		self.m_GameUITemplates[ui].m_OrderedWidgets[index1] = object2;
		self.m_GameUITemplates[ui].m_OrderedWidgets[index2] = object1;
	end,
	--------------------------------------------------------------------------------
	MoveWidgetToLast = function(self, ui, widget)
		local frame = self.m_GameUITemplates[ui];
		local orderedWidgets = frame.m_OrderedWidgets;
		local object, index = frame:GetWidgetObjectAndOrder(widget);
		
		table.remove(orderedWidgets, index);
		table.insert(orderedWidgets, object);
	end,

    --=============================
    -- Misc
    --=============================
	
  	--------------------------------------------------------------------------------
    SetUITranslate = function(self, ui, x, y)
        self.m_GameUITemplates[ui].m_GameObject["Transform"]:SetTranslate(x, y);
    end,
  	--------------------------------------------------------------------------------
    SetUITranslateEx = function(self, ui, obj)
        self.m_GameUITemplates[ui].m_GameObject["Transform"]:SetTranslateEx(obj);
    end,
  	--------------------------------------------------------------------------------
    GetUITranslate = function(self, ui)
        return self.m_GameUITemplates[ui].m_GameObject["Transform"]:GetTranslate();
    end,
  	--------------------------------------------------------------------------------
    SetWidgetTranslate = function(self, ui, widget, x, y)
        local widgetGo = self.m_GameUITemplates[ui].m_Widgets[widget].m_GameObject;
        local frameGo = self.m_GameUITemplates[ui].m_GameObject;
        frameGo:ReattachObject(widgetGo, x, y);
    end,
  	--------------------------------------------------------------------------------
    ModifyWidgetTranslate = function(self, ui, widget, x, y)
        local widgetGo = self.m_GameUITemplates[ui].m_Widgets[widget].m_GameObject;
        local frameGo = self.m_GameUITemplates[ui].m_GameObject;
        local ox, oy = widgetGo["Transform"]:GetTranslate();
        frameGo:ReattachObject(widgetGo, ox + x, oy + y);
    end,
  	--------------------------------------------------------------------------------
    GetWidgetTranslate = function(self, ui, widget)
		return self.m_GameUITemplates[ui].m_Widgets[widget].m_GameObject["Transform"]:GetTranslate();
	end,
  	--------------------------------------------------------------------------------
	ResetSwipe = function(self, ui)
		self.m_GameUITemplates[ui]:ResetSwipe();
	end,
  	--------------------------------------------------------------------------------	
	CenterSwipeObjects = function(self, ui, index)
		self.m_GameUITemplates[ui]:CenterSwipeObjects(index);
	end,

    --=============================
    -- Render/Update/ProcessInput
    --=============================
    
	--------------------------------------------------------------------------------
	Render = function(self)
		for _, ui in ipairs(self.m_ActiveUI) do
			ui:Render();
		end
		
		if (self.m_OnModalUI) then
			for _, ui in ipairs(self.m_ModalUI) do
				ui:Render();
			end
		end

		if (self.m_OnEffect) then
			g_FadeFrameUI:Render();
		end
	end,
	--------------------------------------------------------------------------------
	Update = function(self)
		if (self.m_OnModalUI) then
			for _, ui in ipairs(self.m_ModalUI) do
				ui:Update();
			end
		else
			for _, ui in ipairs(self.m_ActiveUI) do
				ui:Update();
			end
		end
		
		g_UITaskMgr:Update();
		
		self.m_OnEffect = not g_UITaskMgr:IsDone();
	end,
--[[	
	--------------------------------------------------------------------------------
	ProcessInput = function(self)
		-- NOTE: No support for modal frame yet
		
		-- Get mouse coordinate for ui frame/widget pick
		local x = g_InputSystem:GetMousePositionX();
		local y = g_InputSystem:GetMousePositionY();

		--
		-- Check if mouse just pressed or released
		--
		local mousePressed = g_InputSystem:IsMouseButtonPressed(InputSystem.MOUSEBUTTON_LEFT);

		-- Mouse has pressed
		if (not self.m_MouseWasPressed and mousePressed) then
			self.m_MouseWasPressed = true;

			for _, ui in pairs(self.m_ActiveUI) do
				if (ui:OnMousePressed(x, y)) then
					return true;
				end
			end
		-- Mouse has released
		elseif (self.m_MouseWasPressed and not mousePressed) then
			self.m_MouseWasPressed = false;

			for _, ui in pairs(self.m_ActiveUI) do
				if (ui:OnMouseReleased(x, y)) then
					return true;
				end
			end
		end

		-- Mouse has moved
		if ((self.m_PositionX ~= x) or (self.m_PositionY ~= y)) then
			self.m_PositionX = x;
			self.m_PositionY = y;

			for _, ui in pairs(self.m_ActiveUI) do
				ui:OnMouseMove(x, y);
			end
		end

		return false;
	end,
--]]	
	--------------------------------------------------------------------------------	
	TouchBegan = function(self, x, y, obj)
        --assert(x and y);
		-- Block all inputs when proceeding effects
		if (self.m_OnEffect) then
			return;
		end
		        
        self.m_PositionX = x;
        self.m_PositionY = y;

		if (self.m_OnModalUI) then
			-- Proceed only topest modal UI
			local ui = self.m_ModalUI[ #self.m_ModalUI ];
			if (ui:OnMousePressed(x, y, obj)) then
				return true;
			end
		else
			local result = false;
			
			for _, ui in ipairs(self.m_ActiveUI) do
				if (ui:OnMousePressed(x, y, obj)) then
					return true;
				end
			end
			
			return result;
		end
		
		return false;
	end,
	--------------------------------------------------------------------------------
	TouchMoved = function(self, x, y, obj)
        --assert(x and y);
		-- Block all inputs when proceeding effects
		if (self.m_OnEffect) then
			return;
		end

		if (self.m_OnModalUI) then
			-- Proceed only topest modal UI
			local ui = self.m_ModalUI[ #self.m_ModalUI ];
			ui:OnMouseMove(x, y, obj);
		else
			for _, ui in ipairs(self.m_ActiveUI) do
				ui:OnMouseMove(x, y, obj);
			end
		end

        --self.m_PositionX = x;
        --self.m_PositionY = y;
	end,
	--------------------------------------------------------------------------------
	TouchEnded = function(self, x, y, obj)
        --assert(x and y);
		-- Block all inputs when proceeding effects
		if (self.m_OnEffect) then
			return;
		end
    
		if (self.m_OnModalUI) then
			-- Proceed only topest modal UI
			local ui = self.m_ModalUI[ #self.m_ModalUI ];
			if (ui:OnMouseReleased(x, y, obj)) then
				return true;
			end
		else
			for _, ui in ipairs(self.m_ActiveUI) do
				if (ui:OnMouseReleased(x, y, obj)) then
					return true;
				end
			end
		end
		
		return false;
	end,
	--------------------------------------------------------------------------------
	GetTouchPos = function(self)
		return self.m_PositionX, self.m_PositionY;
	end,
	--------------------------------------------------------------------------------
	-- Return true if back key consumed, false if not.
	ProcessBack = function(self)
		-- g_Logger:Show("ProcessBack");

		local back = self:FindActiveBackUI();
		if back then

			-- process only if there is no modal UI.
			if (self.m_OnModalUI) then
				-- g_Logger:Show("ProcessBack: back consumed, but NOT processed.");
			else
				if (back["m_OnMouseUp"] ~= nil) then
					back["m_OnMouseUp"](0, 0);
					-- g_Logger:Show("ProcessBack: back consumed, and also processed.");
				else
					-- g_Logger:Show("ProcessBack find back UI, but cannot find its m_OnMouseUp.");
				end
			end

			return true;
		end

		local consumeBack = not self:IsInMainMenu();
		return consumeBack;
	end,
	--------------------------------------------------------------------------------
	FindActiveBackUI = function(self)
		if (self.m_ActiveUI == nil) then
			return nil;
		end

		for _, ui in ipairs(self.m_ActiveUI) do
			local widgets = ui["m_Widgets"];
			if (widgets) then
				if (widgets["BACK"]) then
					return widgets["BACK"];
				elseif (widgets["Exit"]) then
					return widgets["Exit"];
				elseif (widgets["Pause"]) then
					return widgets["Pause"];
				end
			end
		end

		return nil;
	end,
	--------------------------------------------------------------------------------
	IsInMainMenu = function(self)

		local id = StageManager:GetCurrentStageId();
		-- g_Logger:Show("Current stage:" .. id);

		if id == "MainEntry" then
			return true;
		end

		return false;
	end,
};



--=======================================================================
-- UIFrame
--=======================================================================

FRAME_COLOR = { 0.8, 0.1, 0.1, ALPHA_THREEQUARTER };
FRAME_MODAL_COLOR = { 0.1, 0.1, 0.1, ALPHA_THREEQUARTER };
FRAME_DEFAULT_WIDTH = 250;
FRAME_DEFAULT_HEIGHT = 250;

MODAL_MODE_NORMAL = 1;
MODAL_MODE_NOBACKDROP = 2;

UIFrame =
{
    --
    -- Fields
    --
	m_GameObject = nil,
    m_Template = nil,
	m_Widgets = nil,
    m_OrderedWidgets = nil,
	m_WidgetsCount = 0,
	m_Locked = false,

    --
    -- Private Methods
    --
	--------------------------------------------------------------------------------
    Instance = function(self, o)
        o = o or {};
        setmetatable(o, self);
        self.__index = self;
        return o;
    end,
	--------------------------------------------------------------------------------
	Create = function(self, t, name, reloadable)
		-- Create frame object
        local o = self:Instance
		{
			m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
			m_Name = name,
            m_Template = t,
			m_Modal = t.modal,
			m_Transparent = t.transparent,
			m_Widgets = {},
            m_OrderedWidgets = {},
			m_WidgetsCount = 0,
			m_Locked = false,
		};
		
		if (t.reloadable) then
			o.m_GameObject:EnableReloadable(true);
			o.m_Textures = t.textures;
		end

		-- Create default components
		o.m_GameObject["Transform"]:SetTranslate(t.x or 0, t.y or 0);
		o.m_GameObject["Bound"]:SetSize(t.width or FRAME_DEFAULT_WIDTH, t.height or FRAME_DEFAULT_HEIGHT);
		
		if (t.indie) then
			o.m_GameObject:GoIndie();
		end

		-- Create specified components
		if (t.components ~= nil) then
			for _, com in ipairs(t.components) do	-- Create and add new component to object
				ObjectFactory:AttachGameComponent(o.m_GameObject, com);
			end
		end
        
        -- Determine rendering route
        if (g_AppData:GetData("UIDebug")) then
            self.Render = self.Render_Debug;
        else
            self.Render = self.Render_Release;
        end
		
		if (t.axis ~= nil) then
			--log("AlignObject @ UIFrame: "..name)
			AlignObject(t, o.m_GameObject);
		end

		return o;
	end,
	--------------------------------------------------------------------------------
	Reload = function(self)
		if (self.m_GameObject:IsReloadable()) then		
			self.m_GameObject:Reload();

			for _, widget in ipairs(self.m_OrderedWidgets) do
				widget.m_GameObject:Reload();
				
				if (widget.Reload) then
					widget:Reload();
				end
			end
		end
	end,
	--------------------------------------------------------------------------------
	Unload = function(self)
		if (self.m_GameObject:IsReloadable() and self.m_Textures) then
			for _, texture in ipairs(self.m_Textures) do
				UnloadTexture(texture);
			end
		end
	end,
	--------------------------------------------------------------------------------
	Render_Release = function(self)		
		-- Model frame backdrop
		if (self.m_Modal == MODAL_MODE_NORMAL) then
			DrawIndieRectangle(0, 0, SCREEN_UNIT_X, SCREEN_UNIT_Y, FRAME_MODAL_COLOR[1], FRAME_MODAL_COLOR[2], FRAME_MODAL_COLOR[3], FRAME_MODAL_COLOR[4]);
		end

        self.m_GameObject:Render();

		-- Render widgets
        for _, widget in ipairs(self.m_OrderedWidgets) do
            if (widget.show) then
                widget:OnRender();
            end
        end
	end,
	--------------------------------------------------------------------------------
	Render_Debug = function(self)
		-- Model frame backdrop
		if (self.m_Modal == MODAL_MODE_NORMAL) then
			DrawIndieRectangle(0, 0, SCREEN_UNIT_X, SCREEN_UNIT_Y, FRAME_MODAL_COLOR[1], FRAME_MODAL_COLOR[2], FRAME_MODAL_COLOR[3], FRAME_MODAL_COLOR[4]);
		end

		if (not self.m_Transparent and g_AppData:GetData("UIShowColor") and self.m_GameObject["Sprite"] == nil) then
			local x, y = self.m_GameObject["Transform"]:GetTranslate();
			local sx, sy = self.m_GameObject["Bound"]:GetSize();
			DrawRectangle(x, y, sx, sy, FRAME_COLOR[1], FRAME_COLOR[2], FRAME_COLOR[3], FRAME_COLOR[4]);
			
			if (self.m_Name and g_AppData:GetData("UIShowText")) then
				g_FontRenderer:Draw(x, y, self.m_Name);
			end
		end
        
        self.m_GameObject:Render();

		-- Render widgets
        for _, widget in ipairs(self.m_OrderedWidgets) do
            if (widget.show) then
                widget:OnRender();
            end
        end
	end,

    --
    -- Public Methods
    --
	--------------------------------------------------------------------------------
	GetName = function(self)
		return self.m_Name;
	end,
	--------------------------------------------------------------------------------
	AddWidgetGroups = function(self, groups)
		self.m_WidgetGroups = groups;
	end,
	--------------------------------------------------------------------------------
	EnableWidget = function(self, name, enable)
        self.m_Widgets[name].show = enable;
	end,
	--------------------------------------------------------------------------------
	DisableAllWidgets = function(self)
        for _, widget in ipairs(self.m_OrderedWidgets) do
            widget.show = false;
        end
	end,
	--------------------------------------------------------------------------------
	AddWidget = function(self, name, widget, hide)
		self.m_Widgets[name] = widget;
        widget.show = not hide;
		
        table.insert(self.m_OrderedWidgets, widget);
		self.m_WidgetsCount = self.m_WidgetsCount + 1;		
	end,
	--------------------------------------------------------------------------------
	RemoveWidget = function(self, name)
		assert(self.m_Widgets[name]);
		
        for index, widget in ipairs(self.m_OrderedWidgets) do
			if (widget == self.m_Widgets[name]) then
				self.m_Widgets[name] = nil;
				table.remove(self.m_OrderedWidgets, index);
				self.m_WidgetsCount = self.m_WidgetsCount - 1;
				return index, widget;
			end
		end
	end,
	--------------------------------------------------------------------------------
	GetWidget = function(self, name)
		return self.m_Widgets[name];
	end,
	--------------------------------------------------------------------------------
	GetWidgetObject = function(self, name)
		return self.m_Widgets[name].m_GameObject;
	end,
	--------------------------------------------------------------------------------
	GetWidgetComponent = function(self, name, comp)
		return self.m_Widgets[name].m_GameObject[comp];
	end,
	--------------------------------------------------------------------------------
	GetComponent = function(self, comp)
		return self.m_GameObject[comp];
	end,
	--------------------------------------------------------------------------------
	GetTemplate = function(self)
		return self.m_Template;
	end,
	--------------------------------------------------------------------------------
	GetWidgetObjectAndOrder = function(self, name)
		assert(self.m_Widgets[name]);
		
        for index, widget in ipairs(self.m_OrderedWidgets) do
			if (widget == self.m_Widgets[name]) then
				return widget, index;
			end
		end
	end,
	--------------------------------------------------------------------------------
	IsModal = function(self)
		return self.m_Modal;
	end,
	--------------------------------------------------------------------------------
	IsMotionDone = function(self)
	    for _, widget in ipairs(self.m_OrderedWidgets) do
			if (widget.m_GameObject["Motion"] and widget.m_GameObject["Motion"]:IsOnMotion()) then
				return false;
			end
		end
		return true;
	end,
	--------------------------------------------------------------------------------
	LockAllWidgets = function(self, locked)
		self.m_Locked = locked;
	end,
	--------------------------------------------------------------------------------
    UnlockAllButtons = function(self)
        for _, widget in ipairs(self.m_OrderedWidgets) do
            if (widget.Enable) then
                widget:Enable(true);
            end
        end
    end,
	--------------------------------------------------------------------------------
    LockAllButtons = function(self)
        for _, widget in ipairs(self.m_OrderedWidgets) do
            if (widget.Enable) then
                widget:Enable(false);
            end
        end
    end,
	--------------------------------------------------------------------------------
    LockAllButtonsExcept = function(self, exception)
        for name, widget in pairs(self.m_Widgets) do
            if (widget.Enable) then
                if (name == exception) then
                    widget:Enable(true);
                else
                    widget:Enable(false);
                end
            end
        end
    end,
	--------------------------------------------------------------------------------
	ScaleAllWidgets = function(self, scale)
		self.m_GameObject["Transform"]:SetScale(scale);
		
        for _, widget in ipairs(self.m_OrderedWidgets) do
			widget.m_GameObject["Transform"]:SetScale(scale);
		end
	end,
	--------------------------------------------------------------------------------
	SetAllWidgetsAlpha = function(self, alpha)
		if (self.m_GameObject["Sprite"]) then
			self.m_GameObject["Sprite"]:SetAlpha(alpha);
		end
		
        for _, widget in ipairs(self.m_OrderedWidgets) do
			if (widget.m_GameObject["Sprite"]) then
				widget.m_GameObject["Sprite"]:SetAlpha(alpha);
			end
		end
	end,
	--------------------------------------------------------------------------------
	Update = function(self)
		-- Update frame
		self.m_GameObject:Update();

		-- Update widgets
        for _, widget in ipairs(self.m_OrderedWidgets) do
            if (widget.show and widget.OnUpdate) then
                widget:OnUpdate();
            end
        end
	end,
	--------------------------------------------------------------------------------
	Reset = function(self)
        for _, widget in ipairs(self.m_OrderedWidgets) do
			if (widget.OnReset ~= nil) then
				widget:OnReset();
			end
		end
	end,
	--------------------------------------------------------------------------------
	OnMousePressed = function(self, x, y, obj)
		if (self.m_Locked) then
			return false;
		end
		
		if (self.m_SwipeData and self.m_SwipeData["OnSwipeBegan"](self, x, y)) then
			return true;
		end

        local inputHandled = false;
        --for _, widget in ipairs(self.m_OrderedWidgets) do
		for i = self.m_WidgetsCount, 1, -1 do
			local widget = self.m_OrderedWidgets[i];
			if (widget.show and widget.OnMousePressed) then
				if (widget:OnMousePressed(x, y, obj)) then
					inputHandled = true;
				end
			end
		end
        
        if (self.m_GameObject["Bound"]:IsPicked(x, y)) then
            inputHandled = true;
        end
		
		-- If the frame is transparent, give other objects a chance to handle input
		if (self.m_Transparent) then
			inputHandled = false;
		end

        return inputHandled;
	end,
	--------------------------------------------------------------------------------
	OnMouseMove = function(self, x, y, obj)		
		if (self.m_Locked) then
			return false;
		end

		if (self.m_SwipeData) then
			self.m_SwipeData["OnSwipeMoved"](self, x, y);
			return;
		end

        --for _, widget in ipairs(self.m_OrderedWidgets) do
		for i = self.m_WidgetsCount, 1, -1 do
			local widget = self.m_OrderedWidgets[i];
			if (widget.show and widget.OnMouseMove) then
				widget:OnMouseMove(x, y, obj);
			end
		end
	end,
	--------------------------------------------------------------------------------
	OnMouseReleased = function(self, x, y, obj)
		if (self.m_Locked) then
			return false;
		end

		if (self.m_SwipeData and self.m_SwipeData["onSwiping"]) then
			self.m_SwipeData["OnSwipeEnded"](self, x, y);
			return true;
		end

        local inputHandled = false;
        --for _, widget in ipairs(self.m_OrderedWidgets) do
		for i = self.m_WidgetsCount, 1, -1 do
			local widget = self.m_OrderedWidgets[i];
			if (widget.show and widget.OnMouseReleased) then
				if (widget:OnMouseReleased(x, y, obj)) then
					return true;
				end
			end
		end

        if (self.m_GameObject["Bound"]:IsPicked(x, y)) then
            inputHandled = true;
        end

		-- If the frame is transparent, give other objects a chance to handle input
		if (self.m_Transparent) then
			inputHandled = false;
		end

        return inputHandled;
	end,

    --=============================
    -- Swipe Functions
    --=============================
	--------------------------------------------------------------------------------
	InitializeSwipe = function(self, swipeData)
		assert(swipeData["host"] and swipeData["size"] and swipeData["range"] and
			   swipeData["offset"] and swipeData["axis"]);
		
	    self.m_SwipeData = swipeData;
        self.m_SwipeData["onSwiping"] = false;
		self.m_SwipeData["enabled"] = true;
		self.m_SwipeData["obj"] = {};
		self.m_SwipeData["pos"] = {};
		
		for index, name in ipairs(self.m_SwipeData["host"]) do
			self.m_SwipeData["obj"][index] = self.m_Widgets[name].m_GameObject;
			
			local x, y = self.m_Widgets[name].m_GameObject["Transform"]:GetTranslate();
			self.m_SwipeData["pos"][index] = { x, y };
		end
		
		self.m_SwipeData["swipeDuration"] = 0;
		self.m_SwipeData["centerIndex"] = 1;
		self.m_SwipeData["maxIndex"] = #self.m_SwipeData["host"];

		if (self.m_SwipeData["bound"] == nil) then
			local objCount = #self.m_SwipeData["host"] / (self.m_SwipeData["line"] or 1);
			local objSize = swipeData["size"][1];
			local halfOffset = swipeData["offset"] * 0.5;
			self.m_SwipeData["bound"] = { - objCount * objSize - halfOffset, objSize + halfOffset };
		end
		
		self.m_SwipeData["OnSwipeBegan"] = self.OnSwipeBeganAxis;
		
		if (self.m_SwipeData["axis"] == UI_SWIPE_AXIS_X) then
--			self.m_SwipeData["center"] = math.floor((SCREEN_UNIT_X - swipeData["size"][1]) * 0.5);
			self.m_SwipeData["center"] = math.floor((SCREEN_UNIT_X - swipeData["size"][1]) * 0.5 / APP_UNIT_X);
			self.m_SwipeData["OnSwipeMoved"] = self.OnSwipeMovedAxisX;
			self.m_SwipeData["OnSwipeEnded"] = self.OnSwipeEndedAxisX;
		elseif (self.m_SwipeData["axis"] == UI_SWIPE_AXIS_Y) then
--			self.m_SwipeData["center"] = math.floor((SCREEN_UNIT_Y - swipeData["size"][2]) * 0.5);
			self.m_SwipeData["center"] = math.floor((SCREEN_UNIT_Y - swipeData["size"][2]) * 0.5 / APP_UNIT_Y);
			self.m_SwipeData["OnSwipeMoved"] = self.OnSwipeMovedAxisY;
			self.m_SwipeData["OnSwipeEnded"] = self.OnSwipeEndedAxisY;
		else
			assert(false, "Error occurred at InitializeSwipe()");
		end
	end,
	--------------------------------------------------------------------------------
	EnableSwipe = function(self, enable)
		self.m_SwipeData["enabled"] = enable;
	end,
	--------------------------------------------------------------------------------
	CenterSwipeObjects = function(self, centerIndex)
		assert(self.m_SwipeData["obj"][centerIndex], "CenterSwipeObjects error: [index] "..centerIndex);
		self.m_SwipeData["centerIndex"] = centerIndex;

		local ox, oy = self.m_SwipeData["obj"][1]["Transform"]:GetTranslate();
		local x, y = self.m_SwipeData["obj"][centerIndex]["Transform"]:GetTranslate();
		x = ox - x;
		y = oy - y;
		
		for i, pos in ipairs(self.m_SwipeData["pos"]) do
			self.m_GameObject:ReattachObject(self.m_SwipeData["obj"][i], pos[1] + x, pos[2] + y);
		end
	end,
	--------------------------------------------------------------------------------
	ResetSwipe = function(self)
		for index, obj in ipairs(self.m_SwipeData["obj"]) do
			self.m_SwipeData["obj"][index]["Transform"]:SetTranslateEx(self.m_SwipeData["pos"][index]);
		end
		
		self.m_SwipeData["x"] = 0;
		self.m_SwipeData["y"] = 0;
		self.m_SwipeData["onSwiping"] = false;
	end,
	--------------------------------------------------------------------------------
	OnSwipeBeganAxis = function(self, x, y)
		if (self.m_SwipeData["enabled"]) then
			self.m_SwipeData["swipeDuration"] = g_Timer:GetElapsedTime();
			self.m_SwipeData["x"] = x;
			self.m_SwipeData["y"] = y;
			self.m_SwipeData["xBegin"] = x;
			self.m_SwipeData["yBegin"] = y;
		end
	end,
	--------------------------------------------------------------------------------
	OnSwipeMovedAxisX = function(self, x, y)
		if ((not self.m_SwipeData["enabled"]) or
			(y < self.m_SwipeData["range"][1] or y > self.m_SwipeData["range"][2])) then
			return;
		end

		local deltaMove = x - (self.m_SwipeData["x"] or x);
		local oldPos = self.m_SwipeData["obj"][1]["Transform"]:GetTranslateX();
		local modMove = Clamp(oldPos + deltaMove, self.m_SwipeData["bound"][1], self.m_SwipeData["bound"][2]) - oldPos;
		modMove = modMove / APP_UNIT_X;

		for _, obj in ipairs(self.m_SwipeData["obj"]) do
			obj["Transform"]:ModifyTranslate(modMove, 0);
		end

		self.m_SwipeData["x"] = x;
		self.m_SwipeData["onSwiping"] = true;
	end,
	--------------------------------------------------------------------------------
	OnSwipeMovedAxisY = function(self, x, y)
		if ((not self.m_SwipeData["enabled"]) or
			(x < self.m_SwipeData["range"][1] or x > self.m_SwipeData["range"][2])) then
			return;
		end

		local deltaMove = y - (self.m_SwipeData["y"] or y);
		local oldPos = self.m_SwipeData["obj"][1]["Transform"]:GetTranslateY();
		local modMove = Clamp(oldPos + deltaMove, self.m_SwipeData["bound"][1], self.m_SwipeData["bound"][2]) - oldPos;
		modMove = modMove / APP_UNIT_Y;

		for _, obj in ipairs(self.m_SwipeData["obj"]) do
			obj["Transform"]:ModifyTranslate(0, modMove);
		end

		self.m_SwipeData["y"] = y;
		self.m_SwipeData["onSwiping"] = true;
	end,
	--------------------------------------------------------------------------------
	OnSwipeEndedAxisX = function(self, x, y)
		self.m_SwipeData["onSwiping"] = false;
		
		if ((not self.m_SwipeData["enabled"]) or (not self.m_SwipeData["autoCentering"])) then
			return;
		end
		
		local newCenterIndex = self.m_SwipeData["centerIndex"];
		local xDiff = x - self.m_SwipeData["xBegin"];

		-- Quick swipe gesture
		local swipeDuration = g_Timer:GetElapsedTime() - self.m_SwipeData["swipeDuration"];
		if (swipeDuration <= 200) then

			if (0 < xDiff) then
			-- Center to previous index
				newCenterIndex = newCenterIndex - 1;
			elseif (xDiff < 0) then
			-- Center to next index
				newCenterIndex = newCenterIndex + 1;
			end
		
			if (newCenterIndex < 1) then
				newCenterIndex = 1;
			elseif (newCenterIndex > self.m_SwipeData["maxIndex"]) then
				newCenterIndex = self.m_SwipeData["maxIndex"];
			end

		else
			local threshold = 0.9;
			local center = self.m_SwipeData["center"];
			local centerIndex = self.m_SwipeData["centerIndex"];
			-- g_Logger:Show("OnSwipeEndedAxisX centerIndex:" .. centerIndex .. ", xDiff:" .. xDiff);

			if (0 < xDiff) then
				-- g_Logger:Show("Swipe direction o-->", obj move to right);

				for i = centerIndex, 1, -1 do

					local obj = self.m_SwipeData["obj"][i];
					local pos = obj["Transform"]:GetTranslateX();
					-- g_Logger:Show("i:" .. i .. ", pos:" .. pos .. ", center:" .. center);

					if (pos <= center) then

						local dx = center - pos;
						local dxNext = self.m_SwipeData["obj"][i + 1]["Transform"]:GetTranslateX() - pos;
						local dxToPrev = dxNext * threshold;
						-- g_Logger:Show("dxToPrev:" .. dxToPrev .. ", dx:" .. dx );

						if (dxToPrev <= dx) then
							newCenterIndex = i + 1;
						else
							newCenterIndex = i;
						end

						break;
					end

				end
			elseif (xDiff < 0) then
				-- g_Logger:Show("Swipe direction: <--o, obj move to left.");

				local maxIndex = self.m_SwipeData["maxIndex"];

				for i = centerIndex, maxIndex do

					local obj = self.m_SwipeData["obj"][i];
					local pos = obj["Transform"]:GetTranslateX();
					-- g_Logger:Show("i:" .. i .. ", pos:" .. pos .. ", center:" .. center);

					if (center < pos) then

						local dx = pos - center;
						local dxPrev = pos - self.m_SwipeData["obj"][i - 1]["Transform"]:GetTranslateX();
						local dxToNext = dxPrev * threshold;
						-- g_Logger:Show("dxToNext:" .. dxToNext .. ", dx:" .. dx );

						if (dxToNext <= dx) then
							newCenterIndex = i - 1;
						else
							newCenterIndex = i;
						end

						break;
					end
				end
			end

		end

		g_Logger:Show("OnSwipeEndedAxisX newCenterIndex:" .. newCenterIndex);

		local finalOffset = self.m_SwipeData["center"] - self.m_SwipeData["obj"][newCenterIndex]["Transform"]:GetTranslateX();

		--log("NEW CENTER INDEX: "..newCenterIndex.." / finalOffset: "..finalOffset)
		self.m_SwipeData["centerIndex"] = newCenterIndex;
--finalOffset = finalOffset / APP_UNIT_X;
		
		for _, obj in ipairs(self.m_SwipeData["obj"]) do
			local ox, oy = obj["Transform"]:GetTranslate();
			obj["Motion"]:ResetTarget(ox + finalOffset, oy);
--obj["Motion"]:ResetTarget((ox + finalOffset) / APP_UNIT_X, oy);
		end
		
		if (self.m_SwipeData["onArrival"]) then
			self.m_SwipeData["obj"][1]["Motion"]:AttachCompleteCallback(self.m_SwipeData["onArrival"], newCenterIndex);
		end
	end,
	--------------------------------------------------------------------------------
	OnSwipeEndedAxisY = function(self, x, y)
		self.m_SwipeData["onSwiping"] = false;

		if ((not self.m_SwipeData["enabled"]) or (not self.m_SwipeData["autoCentering"])) then
			return;
		end

		----------------------
		-- Re-position
		----------------------
		if (self.m_SwipeData["autoCentering"]) then
			local center = self.m_SwipeData["center"];		
			local offset = 1000000;
			local final = 0;
			local centerIndex = 0;
			
			for index, obj in ipairs(self.m_SwipeData["obj"]) do
				local pos = obj["Transform"]:GetTranslateY();
				
				if (offset > math.abs(center - pos)) then
					offset = math.abs(center - pos);
					final = center - pos;
					centerIndex = index;
				end			
			end
	
			for _, obj in ipairs(self.m_SwipeData["obj"]) do
				local ox, oy = obj["Transform"]:GetTranslate();
				obj["Motion"]:ResetTarget(ox, oy + final);
			end
			
			if (self.m_SwipeData["onArrival"]) then
				self.m_SwipeData["obj"][1]["Motion"]:AttachCompleteCallback(self.m_SwipeData["onArrival"], centerIndex);
			end
		--elseif (self.m_SwipeData["autoReposition"]) then		
		end
	end,
	--------------------------------------------------------------------------------
	SetSwipeDataRecord = function(self, key, value)
		self.m_SwipeData[key] = value;
	end,
};



--=======================================================================
-- UIObject
--=======================================================================

--------------------------------------------------------------
GameObjectTemplate
{
    class = "UIObject",
    components =	-- Default components for UI frame and all UI widgets
    {
        {
            class = "Transform",
        },

        {
            class = "RectangleBound",
            size = 1,
			--debug = true,
        },
	}
};

--------------------------------------------------------------
GameObjectTemplate
{
    class = "UICircularObject",

    components =
    {
        {
            class = "Transform",
        },

        {
            class = "CircleBound",
            radius = 1,
        },
	}
};



--=======================================================================
-- Utility Function
--=======================================================================

------------------------------------------------------------------------------
function GameUITemplate(t)
	assert(t.name ~= nil and t.widgets ~= nil, "Failed to create game ui template.");

	--log("Creating UI: "..t.name)
    UIManager:CreateGameUITemplate(t);
end

------------------------------------------------------------------------------
function CreateDefaultUIComponents(widget, ui, t)
	local uiGO = ui.m_GameObject;
	local widgetGO = widget.m_GameObject;

	if (t.indie) then
		--log("INDIE widget: "..t.name.." / ui: "..ui.m_Name)
		widgetGO:GoIndie();
	end

	-- Must be done after GoIndie()
	widgetGO["Bound"]:SetSize(t.width or 1, t.height or 1);
	widget.m_Id = uiGO["Transform"]:AttachObject(widgetGO, t.x or 0, t.y or 0);

	if (APP_DEBUG_MODE) then
		widget.m_Indie = t.indie;
	end
end

------------------------------------------------------------------------------
function AlignObject(subject, mainGO, parentGO)
	local axis = subject.axis;
	local offset = (subject.axisOffset or 0) * APP_SCALE_FACTOR;
	local x, y = mainGO["Transform"]:GetTranslate();
	local w, h = mainGO["Sprite"]:GetSize();

	if (parentGO) then
		if (axis == AXIS_XY_CENTER) then
			x = (SCREEN_UNIT_X - w) * 0.5 / APP_UNIT_X;
			y = (SCREEN_UNIT_Y - h) * 0.5 / APP_UNIT_Y;
		elseif (axis == AXIS_X_CENTER) then
			x = ((SCREEN_UNIT_X - w) * 0.5 + offset) / APP_UNIT_X;
		elseif (axis == AXIS_Y_CENTER) then
			y = ((SCREEN_UNIT_Y - h) * 0.5 + offset) / APP_UNIT_Y;
		end
		-- Position changed, must be re-attached
		parentGO:ReattachObject(mainGO, x, y);
	else
		if (axis == AXIS_XY_CENTER) then
			x = (SCREEN_UNIT_X - w) * 0.5;
			y = (SCREEN_UNIT_Y - h) * 0.5;
		elseif (axis == AXIS_X_CENTER) then
			x = ((SCREEN_UNIT_X - w) * 0.5 + offset);
			y = y * APP_UNIT_Y;
		elseif (axis == AXIS_Y_CENTER) then
			x = x * APP_UNIT_X;
			y = ((SCREEN_UNIT_Y - h) * 0.5 + offset);
		end
		-- Translate the UI frame
		mainGO["Transform"]:SetTranslate(x, y);
	end
end

------------------------------------------------------------------------------
function UpdateFadeFrameAlpha(value)
	--log("alpha: "..value)
	g_FadeFrameUI["Shape"]:SetAlpha(value);
end

--------------------------------------------------------------------------------
function ResetDropdownUI(ui)
	local transGC = UIManager:GetUIComponent(ui, "Transform");
	local x, y = transGC:GetTranslate();
	transGC:ModifyTranslate(0, -SCREEN_UNIT_Y);
end

--------------------------------------------------------------------------------
function OpenDropdownUI(ui)
	local transGC = UIManager:GetUIComponent(ui, "Transform");
	local motionGC = UIManager:GetUIComponent(ui, "Motion");
	local x, y = transGC:GetTranslate();
	motionGC:ResetTarget(x, y + SCREEN_UNIT_Y + 5);
	motionGC:AppendNextTarget(x, y + SCREEN_UNIT_Y);
end

--------------------------------------------------------------------------------
function CloseDropdownUI(ui)
	local transGC = UIManager:GetUIComponent(ui, "Transform");
	local motionGC = UIManager:GetUIComponent(ui, "Motion");
	local x, y = transGC:GetTranslate();
	motionGC:ResetTarget(x, y + 5);
	motionGC:AppendNextTarget(x, y - SCREEN_UNIT_Y);
end
