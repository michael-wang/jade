--***********************************************************************
-- @file UIPuzzleWidget.lua
--***********************************************************************

--=======================================================================
-- PuzzleTextWidget
--=======================================================================

TEXT_DEFAULT_VALUE = "_TEXT_";

PuzzleTextWidget =
{
    --
    -- Fields
    --
	m_GameObject = nil,

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
    Create = function(self, t, ui)
		-- Create widget
		local o = self:Instance
		{
			m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
			m_Value = t.value or TEXT_DEFAULT_VALUE,
		};

		CreateDefaultUIComponents(o, ui, t);

        -- Determine rendering route
        if (g_AppData:GetData("UIDebug")) then
            o.OnRender = o.Render_Debug;
        else
            o.OnRender = o.Render_Release;
        end

        -- Determine if it will do Update procedure
        if (t["doUpdate"]) then
            o.OnUpdate = o.Update;
        end

		return o;
	end,
    ---------------------------------------------------------------
	Render_Release = function(self)
	end,
    ---------------------------------------------------------------
	Render_Debug = function(self)
		--self.m_GameObject:Render();

		local x, y = self.m_GameObject["Transform"]:GetTranslate();
		g_FontRenderer:Draw(x * APP_UNIT_X, y * APP_UNIT_Y, self.m_Value);
	end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	Update = function(self)
		self.m_GameObject:Update();
	end,
    ---------------------------------------------------------------
	OnReset = function(self)
		self.m_Value = "";
	end,
    ---------------------------------------------------------------
	SetValue = function(self, value)
		self.m_Value = value;
	end,
    ---------------------------------------------------------------
	SetInteger = function(self, value)
		self.m_Value = tostring(math.ceil(value));
	end,
};



--=======================================================================
-- PuzzlePictureWidget
--=======================================================================

PICTURE_STATE_NORMAL = 1;
PICTURE_STATE_PRESSED = 2;
PICTURE_DEFAULT_SCALE = 1.0;

PuzzlePictureWidget =
{
    --
    -- Fields
    --
	m_GameObject = nil,

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
	Create = function(self, t, ui)
		-- Create widget object
        local o = self:Instance
		{
			m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
			m_Scale = t.scale or PICTURE_DEFAULT_SCALE;

            m_State = PICTURE_STATE_NORMAL;
			m_OnMouseDown = t.onMouseDown,
			m_OnMouseUp = t.onMouseUp,
            m_OnMouseMove = t.onMouseMove,
		};

		CreateDefaultUIComponents(o, ui, t);
        
        -- Determine rendering route
        if (g_AppData:GetData("UIDebug")) then
            o.OnRender = o.Render_Debug;
        else
            o.OnRender = o.Render_Release;
        end

        -- Determine if it will do Update procedure
        if (t["doUpdate"]) then
            o.OnUpdate = o.Update;
        end
        
        -- Determin input handling process
        if (not t.onMouseDown) then
            o.OnMousePressed = nil;
        end
        if (not t.onMouseUp) then
            o.OnMouseReleased = nil;
        end
        if (not t.onMouseMove) then
            o.OnMouseMove = nil;
        end
        
		return o;
	end,
    ---------------------------------------------------------------
	Init = function(self)
        if (self.m_Scale ~= PICTURE_DEFAULT_SCALE) then
            self.m_GameObject["Transform"]:SetScale(self.m_Scale);
        end

        self.m_Sprite = self.m_GameObject["Sprite"] or self.m_GameObject["PuzzleAnimation"];

		if (self.m_Sprite ~= nil) then				
			local width, height = self.m_Sprite:GetSize();
			self.m_GameObject["Bound"]:SetSize(width * self.m_Scale, height * self.m_Scale);
		end
	end,
    ---------------------------------------------------------------
	SetImage = function(self, name)
		self.m_Sprite:SetImage(name);
	end,
    ---------------------------------------------------------------
	ResetImage = function(self, name)
		self.m_Sprite:ResetImage(name);
	end,
    ---------------------------------------------------------------
	Render_Release = function(self)
		self.m_GameObject:Render();
	end,
    ---------------------------------------------------------------
	Render_Debug = function(self)
		self.m_GameObject:Render();

		if (self.m_Sprite == nil) then
        	local x, y = self.m_GameObject["Transform"]:GetTranslate();
			local sx, sy = self.m_GameObject["Bound"]:GetSize();
			DrawRectangle(x, y, x + sx, y + sy, COLOR_PURPLE[1], COLOR_PURPLE[2], COLOR_PURPLE[3], ALPHA_THREEQUARTER);
		end
	end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	Update = function(self)
		self.m_GameObject:Update();
	end,
    ---------------------------------------------------------------
	OnMousePressed = function(self, x, y, obj)        
        if (obj == nil) then
            if (self.m_GameObject["Bound"]:IsPicked(x, y)) then
                if (self.m_OnMouseDown ~= nil) then
                    self.m_OnMouseDown(x, y);
                end
                
                self.m_State = PICTURE_STATE_PRESSED;
                --return true;
            end
        else
            if (self.m_GameObject["Bound"]:IsPickedObject(obj)) then
                if (self.m_OnMouseDown ~= nil) then
                    self.m_OnMouseDown(self);
                end

                self.m_State = PICTURE_STATE_PRESSED;
                --return true;
            end
        end
        
        --return false;
	end,
    ---------------------------------------------------------------
	OnMouseReleased = function(self, x, y, obj)
        if (self.m_State == PICTURE_STATE_PRESSED) then
            if (self.m_OnMouseUp ~= nil) then
                if (self.m_OnMouseUp(self)) then
                    self.m_State = PICTURE_STATE_NORMAL;
                end
            else
                self.m_State = PICTURE_STATE_NORMAL;
            end
        end
    end,
    ---------------------------------------------------------------
	OnMouseMove = function(self, x, y)
        if (self.m_OnMouseMove ~= nil and self.m_State == PICTURE_STATE_PRESSED) then
            self.m_OnMouseMove(x, y);
        end
    end,
};



--=======================================================================
-- PuzzleButtonWidget
--=======================================================================

BUTTON_STATE_NORMAL = 1;
BUTTON_STATE_HOVERED = 2;
BUTTON_STATE_PRESSED = 3;
BUTTON_STATE_LOCKED = 4;
BUTTON_STATE_RELEASED = 5;

BUTTON_DEFAULT_WIDTH = 50;
BUTTON_DEFAULT_HEIGHT = 50;
BUTTON_DEFAULT_SCALE = 1.0;

BUTTON_COLOR_SET =
{
	{ 0.1, 0.8, 0.1, ALPHA_THREEQUARTER },
	{ 0.6, 0.9, 0.7, ALPHA_THREEQUARTER },
	{ 0.6, 0.2, 0.7, ALPHA_THREEQUARTER },
	{ 0.1, 0.1, 0.1, ALPHA_THREEQUARTER },
};

PuzzleButtonWidget =
{
    --
    -- Fields
    --
	m_GameObject = nil,

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
    Create = function(self, t, ui)
		-- Create widget
		local o = self:Instance
		{
			--m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
			m_Locked = t.locked,
			m_Name = t.name,
			m_Width = t.width or BUTTON_DEFAULT_WIDTH,
			m_Height = t.height or BUTTON_DEFAULT_HEIGHT,
			m_Scale = t.scale or BUTTON_DEFAULT_SCALE,
			m_OnMouseDown = t.onMouseDown,
			m_OnMouseUp = t.onMouseUp,
			m_OnMouseHover = t.onMouseHover,
		};
        
        -- Circular/Rectangle button bound
        if (t.circular) then
			o.m_GameObject = ObjectFactory:CreateGameObject("UICircularObject");
        else
			o.m_GameObject = ObjectFactory:CreateGameObject("UIObject");
        end

		CreateDefaultUIComponents(o, ui, t);

        -- Determine rendering route
        if (g_AppData:GetData("UIDebug")) then
			if (t.transparent) then
	            o.OnRender = o.Render_Release;
			else
				o.OnRender = o.Render_Debug;
			end
        else
            o.OnRender = o.Render_Release;
        end

        -- Determine if it will do Update procedure
        if (t["doUpdate"]) then
            o.OnUpdate = o.Update;
        end

		return o;
	end,
    ---------------------------------------------------------------
	Init = function(self)
		if (self.m_GameObject["Sprite"] ~= nil) then
            self.m_Sprite = self.m_GameObject["Sprite"];
            self.m_ImageNames = {};
            self:SetImage(self.m_Sprite:GetImageName(), true);
		else
            self.m_GameObject["Bound"]:SetSize(self.m_Width * self.m_Scale, self.m_Height * self.m_Scale);

            -- Set initial state
            if (self.m_Locked) then
                self:ChangeState(BUTTON_STATE_LOCKED);
            else
                self:ChangeState(BUTTON_STATE_NORMAL);
            end
        end
    end,
    ---------------------------------------------------------------
	Render_Release = function(self)
		self.m_GameObject:Render();
	end,
    ---------------------------------------------------------------
	Render_Debug = function(self)
		self.m_GameObject:Render();
---[[
		if (self.m_Sprite == nil) then
--]]		
            local x, y = self.m_GameObject["Transform"]:GetTranslate();

            if (g_AppData:GetData("UIShowColor")) then
                if (self.m_GameObject["Bound"]:GetType() == BOUND_TYPE_RECTANGLE) then
                    local sx, sy = self.m_GameObject["Bound"]:GetSize();
					if (self.m_Indie) then
	                    DrawIndieRectangle(x, y, sx, sy, self.m_Color[1], self.m_Color[2], self.m_Color[3], self.m_Color[4]);
					else
	                    DrawRectangle(x, y, sx, sy, self.m_Color[1], self.m_Color[2], self.m_Color[3], self.m_Color[4]);
					end
                else
                    DrawCircle(x, y, self.m_GameObject["Bound"]:GetRadius(), self.m_Color[1], self.m_Color[2], self.m_Color[3], self.m_Color[4]);
                end
            end
			
			if (self.m_Name and g_AppData:GetData("UIShowText")) then
				g_FontRenderer:Draw(x * APP_UNIT_X, y * APP_UNIT_Y, self.m_Name);
			end
---[[
		end
--]]		
	end,
    ---------------------------------------------------------------
	SetImage = function(self, imageName, imageIgnored, imageReset)
		if (self.m_Sprite ~= nil) then
			if (imageReset) then
                self.m_Sprite:ResetImage(imageName);
            elseif (not imageIgnored) then
                self.m_Sprite:SetImage(imageName);
            end

            self.m_ImageNames[BUTTON_STATE_NORMAL] = imageName;
            --self.m_ImageNames[BUTTON_STATE_HOVERED] = imageName .. "_hovered";
            self.m_ImageNames[BUTTON_STATE_PRESSED] = imageName .. "_pressed";
            self.m_ImageNames[BUTTON_STATE_LOCKED] = imageName .. "_locked";
            
			if (self.m_Scale ~= BUTTON_DEFAULT_SCALE) then
				self.m_GameObject["Transform"]:SetScale(self.m_Scale);
			end

			local width, height = self.m_Sprite:GetSize();
			self.m_GameObject["Bound"]:SetSize(width * self.m_Scale, height * self.m_Scale);
		end

		-- Set initial state
		if (self.m_Locked) then
			self:ChangeState(BUTTON_STATE_LOCKED);
		else
			self:ChangeState(BUTTON_STATE_NORMAL);
		end
	end,
    ---------------------------------------------------------------
	ChangeSkin = function(self)
		if (g_AppData:GetData("UIShowColor")) then
			self.m_Color = BUTTON_COLOR_SET[self.m_State];
		end
		
		if (self.m_Sprite ~= nil) then
			self.m_Sprite:SetImage(self.m_ImageNames[self.m_State]);
		end
	end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	Reload = function(self)
		self:ChangeSkin();
	end,
    ---------------------------------------------------------------
	Update = function(self)
		self.m_GameObject:Update();
	end,
    ---------------------------------------------------------------
	-- NOTE: iPhone has no BUTTON_STATE_HOVERED state
	OnMouseMove = function(self, x, y, obj)
		if (self.m_State ~= BUTTON_STATE_LOCKED) then
            if (obj == nil) then
                if (self.m_GameObject["Bound"]:IsPicked(x, y)) then
                    self:ChangeState(BUTTON_STATE_HOVERED);
                else
                    self:ChangeState(BUTTON_STATE_NORMAL);
                end
            else
                if (self.m_GameObject["Bound"]:IsPickedObject(obj)) then
                    self:ChangeState(BUTTON_STATE_HOVERED);
                else
                    self:ChangeState(BUTTON_STATE_NORMAL);
                end
            end
		end
	end,
    ---------------------------------------------------------------
	OnMousePressed = function(self, x, y, obj)
		if (self.m_State ~= BUTTON_STATE_LOCKED) then
            if (obj == nil) then
                if (self.m_GameObject["Bound"]:IsPicked(x, y)) then
                    self:ChangeState(BUTTON_STATE_PRESSED);
                    return true;
                end
            else
                if (self.m_GameObject["Bound"]:IsPickedObject(obj)) then
                    self:ChangeState(BUTTON_STATE_PRESSED);
                    return true;
                end
            end
		end
        
        return false;
	end,
    ---------------------------------------------------------------
	OnMouseReleased = function(self, x, y, obj)
		if (self.m_State ~= BUTTON_STATE_LOCKED) then
			local previousState = self.m_State;
			
			self:ChangeState(BUTTON_STATE_RELEASED);

            if (obj == nil) then
                if (self.m_GameObject["Bound"]:IsPicked(x, y)) then
                    if (previousState == BUTTON_STATE_PRESSED and self.m_OnMouseUp) then
                        self.m_OnMouseUp(self);
	                    return true;
                    end
                end
            else
                if (self.m_GameObject["Bound"]:IsPickedObject(obj)) then
                    if (previousState == BUTTON_STATE_PRESSED and self.m_OnMouseUp) then
                        self.m_OnMouseUp(self);
	                    return true;
                    end
                end
            end
		end
            
        return false;
	end,
    ---------------------------------------------------------------
	ChangeState = function(self, state)
		-- Hovered
		if (state == BUTTON_STATE_HOVERED) then
			if (self.m_State == BUTTON_STATE_PRESSED or self.m_State == BUTTON_STATE_HOVERED) then
				return;
			end

			if (self.m_OnMouseHover ~= nil) then
				self.m_OnMouseHover(self);
			end
		-- Pressed
		elseif (state == BUTTON_STATE_PRESSED) then
			if (self.m_OnMouseDown ~= nil) then
				self.m_OnMouseDown(self);
			end
		-- Released
		elseif (state == BUTTON_STATE_RELEASED) then
			-- Return to Normal state
			state = BUTTON_STATE_NORMAL;
		--else
		end

		self.m_State = state;
		self:ChangeSkin();
	end,
    ---------------------------------------------------------------
	Enable = function(self, enable)
		if (enable) then
			self.m_State = BUTTON_STATE_NORMAL;
		else
			self.m_State = BUTTON_STATE_LOCKED;
		end

		self.m_Locked = not enable;
		
		self:ChangeSkin();
	end,
};



--=======================================================================
-- PuzzleCheckButtonWidget
--=======================================================================
CHECKBUTTON_STATE_ON = 1;
CHECKBUTTON_STATE_OFF = 2;
CHECKBUTTON_DEFAULT_WIDTH = 32;
CHECKBUTTON_DEFAULT_HEIGHT = 32;

CHECKBUTTON_COLOR_SET =
{
	{ 0, 0, 1,   ALPHA_THREEQUARTER },
	{ 0, 0, 0.2, ALPHA_THREEQUARTER },
};

PuzzleCheckButtonWidget =
{
    --
    -- Fields
    --
	m_GameObject = nil,

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
	Create = function(self, t, ui)
		-- Create widget object
        local o = self:Instance
		{
			m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
			m_State = t.state,
			m_Name = t.name,
			m_Width = t.width or CHECKBUTTON_DEFAULT_WIDTH,
			m_Height = t.height or CHECKBUTTON_DEFAULT_HEIGHT,
			m_OnStateChange = t.onStateChange,
		};

		CreateDefaultUIComponents(o, ui, t);

        -- Determine rendering route
        if (g_AppData:GetData("UIDebug")) then
            o.OnRender = o.Render_Debug;
        else
            o.OnRender = o.Render_Release;
        end

        -- Determine if it will do Update procedure
        if (t["doUpdate"]) then
            o.OnUpdate = o.Update;
        end

		return o;
	end,
    ---------------------------------------------------------------
	Init = function(self)
		if (self.m_GameObject["Sprite"] ~= nil) then			
			self.m_Sprite = self.m_GameObject["Sprite"];			
			self.m_GameObject["Bound"]:SetSize(self.m_Sprite:GetSize());
			
			local name = self.m_Sprite:GetImageName();
			self.m_OnStateImageName = name;
			self.m_OffStateImageName = name .. "_off";
		else
			self.m_GameObject["Bound"]:SetSize(self.m_Width, self.m_Height);
		end
		
		-- Set default/init appearance
		if (self.m_State == nil) then
			self.m_State = true;
		end
		self:ChangeSkin();
	end,
    ---------------------------------------------------------------
	Render_Release = function(self)
		self.m_GameObject:Render();
	end,
    ---------------------------------------------------------------
	Render_Debug = function(self)
		self.m_GameObject:Render();

        if (self.m_Sprite == nil) then
            if (g_AppData:GetData("UIShowColor")) then
                local color;
                if (self.m_State) then
                    color = CHECKBUTTON_COLOR_SET[CHECKBUTTON_STATE_ON];
                else
                    color = CHECKBUTTON_COLOR_SET[CHECKBUTTON_STATE_OFF];
                end
                
                local x, y = self.m_GameObject["Transform"]:GetTranslate();
                DrawRectangle(x, y, self.m_Width, self.m_Height, color[1], color[2], color[3], color[4]);
                
                if (self.m_Name and g_AppData:GetData("UIShowText")) then
                    g_FontRenderer:Draw(x, y, self.m_Name);
                end
            end
        end
	end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	Reload = function(self)
		self:ChangeSkin();
	end,
    ---------------------------------------------------------------
	Update = function(self)
		self.m_GameObject:Update();
	end,
    ---------------------------------------------------------------
	OnMouseReleased = function(self, x, y, obj)
        if (obj == nil) then
            if (not self.m_GameObject["Bound"]:IsPicked(x, y)) then
                return false;
            end
        else
            if (not self.m_GameObject["Bound"]:IsPickedObject(obj)) then
                return false;
            end
        end
		
		self:ChangeState(not self.m_State, true);

        return true;
	end,
    ---------------------------------------------------------------
	ChangeState = function(self, state, action)
        self.m_State = state;

		if (self.m_OnStateChange and action) then
			self.m_OnStateChange(state);
		end

		self:ChangeSkin();
    end,
    ---------------------------------------------------------------
	ChangeSkin = function(self)
		if (self.m_Sprite) then
			if (self.m_State) then
				self.m_Sprite:SetImage(self.m_OnStateImageName);
			else
				self.m_Sprite:SetImage(self.m_OffStateImageName);
			end
		end
    end,
};



--=======================================================================
-- PuzzleRadioButtonGroupWidget
--=======================================================================
RADIOBUTTON_STATE_ON = 1;
RADIOBUTTON_STATE_OFF = 2;
RADIOBUTTON_DEFAULT_WIDTH = 32;
RADIOBUTTON_DEFAULT_HEIGHT = 32;

RADIOBUTTON_COLOR_SET =
{
	{ 0.1, 0.9, 0.1, ALPHA_THREEQUARTER },
	{ 0.6, 0.2, 0.7, ALPHA_THREEQUARTER },
};

PuzzleRadioButtonGroupWidget =
{
    --
    -- Fields
    --
	m_GameObject = nil,
	m_WidgetGO = nil,
	m_WidgetEnabled = nil,
	m_ImageNames = nil,

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
	Create = function(self, t, ui)
		-- Create widget object
        local o = self:Instance
		{
			m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
			m_StateOnIndex = t.default,
			m_Name = t.name,
			m_Width = t.width or RADIOBUTTON_DEFAULT_WIDTH,
			m_Height = t.height or RADIOBUTTON_DEFAULT_HEIGHT,
			m_OffsetX = t.offsetX,
			m_OffsetY = t.offsetY,
			m_Count = t.count,
			m_OnStateOn = t.onStateOn,
		};

		CreateDefaultUIComponents(o, ui, t);

        -- Determine rendering route
        if (g_AppData:GetData("UIDebug")) then
            o.OnRender = o.Render_Debug;
        else
            o.OnRender = o.Render_Release;
        end

        -- Determine if it will do Update procedure
        if (t["doUpdate"]) then
            o.OnUpdate = o.Update;
        end

		return o;
	end,
    ---------------------------------------------------------------
	Init = function(self)
		assert(self.m_OffsetX ~= nil or self.m_OffsetY ~= nil, "PuzzleRadioButtonGroupWidget error");
		assert(self.m_Count);

		self.m_WidgetGO = {};
		self.m_WidgetEnabled = {};
		
        local ox, oy = self.m_GameObject["Transform"]:GetTranslate();
		
		if (self.m_GameObject["SpriteGroup"]) then
		--========================
		-- Release version
		--========================
			self.m_ImageNames = {};
			self.m_Sprite = self.m_GameObject["SpriteGroup"];		

			local width, height = self.m_Sprite:GetSprite(1):GetSize();
			for i = 1, self.m_Count do
				local x = ox;
				local y = oy;
				local offsetX = 0;
				local offsetY = 0;
				
				if (self.m_OffsetX) then
					offsetX = (width + self.m_OffsetX) * (i - 1);
					x = x + offsetX;
				else
					offsetY = (height + self.m_OffsetY) * (i - 1);
					y = y + offsetY;
				end

				self.m_WidgetGO[i] = ObjectFactory:CreateGameObject("UIObject");
				self.m_WidgetGO[i]:GoIndie();				
				self.m_WidgetGO[i]["Transform"]:SetTranslate(x, y);
				self.m_WidgetGO[i]["Bound"]:SetSize(width, height);
				self.m_WidgetEnabled[i] = true;
				
				--log("#"..i.." => x/y: "..x.." , "..y.."  bo: "..width.." , "..height)
				self.m_Sprite:SetOffset(i, offsetX, offsetY);
				local spriteGC = self.m_Sprite:GetSprite(i);

				self.m_ImageNames[i] =
				{
					[RADIOBUTTON_STATE_ON] = spriteGC:GetImageName(),
					[RADIOBUTTON_STATE_OFF] = spriteGC:GetImageName() .. "_off",
				};
			end
		else
		--========================
		-- Debug version
		--========================
			for i = 1, self.m_Count do
				local x = ox;
				local y = oy;
				local offsetX = 0;
				local offsetY = 0;
				
				if (self.m_OffsetX) then
					offsetX = (self.m_Width + self.m_OffsetX) * (i - 1);
					x = x + offsetX;
				else
					offsetY = (self.m_Height + self.m_OffsetY) * (i - 1);
					y = y + offsetY;
				end

				self.m_WidgetGO[i] = ObjectFactory:CreateGameObject("UIObject");
				self.m_WidgetGO[i]["Transform"]:SetTranslate(x, y);
				self.m_WidgetGO[i]["Bound"]:SetSize(self.m_Width, self.m_Height);				
				self.m_WidgetEnabled[i] = true;
			end
		end
		
		self:Select(self.m_StateOnIndex or 1, false);
	end,
    ---------------------------------------------------------------
	Render_Release = function(self)
		self.m_GameObject:Render();
	end,
    ---------------------------------------------------------------
	Render_Debug = function(self)
		self.m_GameObject:Render();
---[[		
        if (self.m_Sprite == nil) then
--]]		
            if (g_AppData:GetData("UIShowColor")) then                
                local ox, oy = self.m_GameObject["Transform"]:GetTranslate();

				for i = 1, self.m_Count do
					if (self.m_WidgetEnabled[i]) then
						local x = ox;
						local y = oy;					
						if (self.m_OffsetX) then
							x = x + (self.m_Width + self.m_OffsetX) * (i - 1);
						else
							y = y + (self.m_Height + self.m_OffsetY) * (i - 1);
						end
						
						local color;
						if (self.m_StateOnIndex == i) then
							color = RADIOBUTTON_COLOR_SET[RADIOBUTTON_STATE_ON];
						else
							color = RADIOBUTTON_COLOR_SET[RADIOBUTTON_STATE_OFF];
						end
	
						DrawRectangle(x, y, self.m_Width, self.m_Height, color[1], color[2], color[3], color[4]);
					end
				end
                
                if (self.m_Name and g_AppData:GetData("UIShowText")) then
                    g_FontRenderer:Draw(ox, oy, self.m_Name);
                end
            end
---[[			
        end
--]]		
	end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	Reload = function(self)
		self:ChangeSkin()
	end,
    ---------------------------------------------------------------
	Update = function(self)
		self.m_GameObject:Update();
	end,
    ---------------------------------------------------------------
	OnMousePressed = function(self, x, y, obj)
		local index;
        if (obj == nil) then
			for i = 1, self.m_Count do
				if (self.m_WidgetEnabled[i] and self.m_WidgetGO[i]["Bound"]:IsPicked(x, y)) then
					index = i;
				end
			end
        else
			for i = 1, self.m_Count do
				if (self.m_WidgetEnabled[i] and self.m_WidgetGO[i]["Bound"]:IsPickedObject(obj)) then
					index = i;
				end
			end
        end
		
		self.m_PressedIndex = index;

		if (index) then
			return true;
		end
	end,
    ---------------------------------------------------------------
	OnMouseReleased = function(self, x, y, obj)
		if (self.m_PressedIndex == nil) then
			return false;
		end
		
		local index;
        if (obj == nil) then
			for i = 1, self.m_Count do
				if (self.m_WidgetEnabled[i] and self.m_WidgetGO[i]["Bound"]:IsPicked(x, y)) then
					index = i;
				end
			end
        else
			for i = 1, self.m_Count do
				if (self.m_WidgetEnabled[i] and self.m_WidgetGO[i]["Bound"]:IsPickedObject(obj)) then
					index = i;
				end
			end
        end
		
		-- Has picked one of the widgets
		if (index) then
			self:Select(index, true);
			return true;
		end
	end,
    ---------------------------------------------------------------
	ChangeSkin = function(self, index)
		if (self.m_Sprite) then
			for i = 1, self.m_Count do
				if (index == i) then
					self.m_Sprite:GetSprite(i):SetImage(self.m_ImageNames[i][RADIOBUTTON_STATE_ON]);
				else
					self.m_Sprite:GetSprite(i):SetImage(self.m_ImageNames[i][RADIOBUTTON_STATE_OFF]);
				end
			end
		end
	end,
    ---------------------------------------------------------------
	Select = function(self, index, action)
		if (self.m_StateOnIndex == index) then
			return;
		end
		
		self.m_StateOnIndex = index;

		if (self.m_OnStateOn ~= nil and action) then
			self.m_OnStateOn(index);
		end

		self:ChangeSkin(index);
    end,
    ---------------------------------------------------------------
	Reselect = function(self, index)
		self.m_StateOnIndex = index;
		self:ChangeSkin(index);
    end,
    ---------------------------------------------------------------
	Enable = function(self, index, enable)
		self.m_WidgetEnabled[index] = enable;
		
		if (self.m_Sprite) then
			self.m_Sprite:EnableRender(index, enable);
		end
	end,
};



--=======================================================================
-- PuzzleNumberWidget
--=======================================================================

NUMBER_DEFAULT_VALUE = 0;
NUMBER_SIGN_PLUS = "plus";
NUMBER_SIGN_MINUS = "minus";
NUMBER_SIGN_SLASH = "slash";
NUMBER_SIGN_COLON = "colon";

NUMBER_RENDER_DEFAULT = 1;
NUMBER_RENDER_PMSIGN = 2;
NUMBER_RENDER_PREPOST = 3;

NUMBER_ALIGNMENT_LEFT = 1;
NUMBER_ALIGNMENT_RIGHT = 2;

PuzzleNumberWidget =
{
    --
    -- Fields
    --
	m_GameObject = nil,
	m_Value = 0,
	m_NamePrefix = nil,
	m_Sprite = nil,
	m_ValuesTable = nil,

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
    Create = function(self, t, ui)
		-- Create widget
		local o = self:Instance
		{
			m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
			m_Value = t.value or NUMBER_DEFAULT_VALUE,
            m_MaxValue = t.maxValue,
            m_MinValue = t.minValue,
            m_SignPlus = t.signPlus,
            m_SignMinus = t.signMinus,
            m_SignSlash = t.signSlash,
            m_Prefix = t.prefix,
            m_Postfix = t.postfix,
            m_PostfixOffset = t.postfixOffset,
            m_NumberOffset = t.numberOffset or 0,
			m_Alignment = t.align or NUMBER_ALIGNMENT_LEFT,
		};
		
		CreateDefaultUIComponents(o, ui, t);

        -- Determine rendering procedure according to parameters
        if (t.signPlus or t.signMinus or t.signSlash) then
            o.Render_Release = o.Render_SignSlash;
        elseif (t.prefix or t.postfix) then
            o.Render_Release = o.Render_PrePost;
        else
            o.Render_Release = o.Render_Default;
        end

        -- Determine rendering route
        if (g_AppData:GetData("UIDebug")) then
            o.OnRender = o.Render_Debug;
        else
            o.OnRender = o.Render_Release;
        end

        -- Determine if it will do Update procedure
        if (t["doUpdate"]) then
            o.OnUpdate = o.Update;
        end

		return o;
	end,
    ---------------------------------------------------------------
	Init = function(self)
		if (self.m_GameObject["Sprite"] ~= nil) then
			self.m_Sprite = self.m_GameObject["Sprite"];
			self.m_Width = self.m_Sprite:GetSize() + self.m_NumberOffset;
			
			-- Get (length-1) substring for m_NamePrefix
			local name = self.m_Sprite:GetImageName();
			self.m_NamePrefix = string.sub(name, 1, string.len(name) - 1);            
		end
        
        -- Sign plus/minus & Slash
        
        if (self.m_SignPlus) then
            self.m_SignPlus = self.m_NamePrefix .. NUMBER_SIGN_PLUS;
        end

        if (self.m_SignMinus) then
            self.m_SignMinus = self.m_NamePrefix .. NUMBER_SIGN_MINUS;
        end

        if (self.m_SignSlash) then
            self.m_SignSlash = self.m_NamePrefix .. NUMBER_SIGN_SLASH;
            
            assert(self.m_MaxValue);
            self:SetMaxValue(self.m_MaxValue);
        end
        
        -- Prefix/Postfix
        
        if (self.m_Prefix) then
            self.m_Prefix = self.m_NamePrefix .. self.m_Prefix;
            self.m_Sprite:SetImage(self.m_Prefix);
			self.m_PrefixWidth = self.m_Sprite:GetSize();
        end

        if (self.m_Postfix) then
            self.m_Postfix = self.m_NamePrefix .. self.m_Postfix;
            self.m_PrefixWidth = self.m_PrefixWidth or 0;
            self.m_PostfixOffset = self.m_PostfixOffset or 0;
        end

		self:SetValue(self.m_Value);
    end,
    ---------------------------------------------------------------
	ResetPrefix = function(self, prefix)
        self.m_Prefix = self.m_NamePrefix .. prefix;
        self.m_Sprite:SetImage(self.m_Prefix);
		self.m_PrefixWidth = self.m_Sprite:GetSize();
	end,
    ---------------------------------------------------------------
	Render_Default = function(self)
		if (self.m_Alignment == 1) then  -- Alignment LEFT
			for index, digit in ipairs(self.m_ValuesTable) do
				self.m_Sprite:SetImage(digit);
				self.m_Sprite:DrawOffset(self.m_Width * (index - 1), 0);
			end
		else
			for index = self.m_ValueLength, 1, -1 do
				self.m_Sprite:SetImage(self.m_ValuesTable[self.m_ValueLength - (index - 1)]);
				self.m_Sprite:DrawOffset(-self.m_Width * (index - 1), 0);
			end
		end
    end,
    ---------------------------------------------------------------
	Render_SignSlash = function(self)
        local offset = 1;
        
        -- Plus/Minus sign
        if (self.m_SignPlus and self.m_Value > 0) then
            self.m_Sprite:SetImage(self.m_SignPlus);
            self.m_Sprite:DrawOffset(0, 0);
            offset = offset + 1;
        elseif (self.m_SignMinus and self.m_Value < 0) then
            self.m_Sprite:SetImage(self.m_SignMinus);
            self.m_Sprite:DrawOffset(0, 0);
            offset = offset + 1;
        end
        
        -- Numbers
        for index, digit in ipairs(self.m_ValuesTable) do
            self.m_Sprite:SetImage(digit);
            self.m_Sprite:DrawOffset(self.m_Width * (offset - 1), 0);
            offset = offset + 1;
        end
        
        -- Slash sign
        if (self.m_SignSlash) then
            self.m_Sprite:SetImage(self.m_SignSlash);
            self.m_Sprite:DrawOffset(self.m_Width * (offset - 1), 0);
            offset = offset + 1;

            -- Max value
            for index, digit in ipairs(self.m_MaxValuesTable) do
                self.m_Sprite:SetImage(digit);
                self.m_Sprite:DrawOffset(self.m_Width * (offset - 1), 0);
                offset = offset + 1;
            end
        end
	end,
    ---------------------------------------------------------------
	Render_PrePost = function(self)
		if (self.m_Alignment == 1) then  -- Alignment LEFT
			local offset = 1;
			
			-- Prefix
			if (self.m_Prefix) then
				self.m_Sprite:SetImage(self.m_Prefix);
				self.m_Sprite:DrawOffset(0, 0);
			end
	
			-- Number
			for index, digit in ipairs(self.m_ValuesTable) do
				self.m_Sprite:SetImage(digit);
				self.m_Sprite:DrawOffset(self.m_Width * (offset - 1) + self.m_PrefixWidth, 0);
				offset = offset + 1;
			end
	
			-- Postfix
			if (self.m_Postfix) then
				self.m_Sprite:SetImage(self.m_Postfix);
				self.m_Sprite:DrawOffset(self.m_Width * (offset - 1) + self.m_PrefixWidth + self.m_PostfixOffset, 0);
			end
		else -- Alignment RIGHT
			if (self.m_Postfix) then
				self.m_Sprite:SetImage(self.m_Postfix);
				self.m_Sprite:DrawOffset(self.m_Width, 0);
			end
	
			for index = self.m_ValueLength, 1, -1 do
				self.m_Sprite:SetImage(self.m_ValuesTable[self.m_ValueLength - (index - 1)]);
				self.m_Sprite:DrawOffset(-self.m_Width * (index - 1), 0);
			end

			if (self.m_Prefix) then
				self.m_Sprite:SetImage(self.m_Prefix);
				self.m_Sprite:DrawOffset(-self.m_Width * self.m_ValueLength, 0);
			end
		end
    end,
    ---------------------------------------------------------------
	Render_Debug = function(self)
		if (self.m_Sprite ~= nil) then
            self:Render_Release();
		end
	end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	Update = function(self)
		self.m_GameObject:Update();
	end,
    ---------------------------------------------------------------
	SetValue = function(self, value)        
		self.m_Value = math.floor(value);
		self.m_ValuesTable = {};

        if (self.m_MinValue and self.m_Value < self.m_MinValue) then
            self.m_Value = self.m_MinValue;
        elseif (self.m_MaxValue and self.m_Value > self.m_MaxValue) then
            self.m_Value = self.m_MaxValue;
        end
		
		local numStr = tostring(self.m_Value);
		for i = 1, string.len(numStr) do
			self.m_ValuesTable[i] = self.m_NamePrefix .. string.sub(numStr, i, i);
		end
		
		if (self.m_Alignment == NUMBER_ALIGNMENT_RIGHT) then
			self.m_ValueLength = #self.m_ValuesTable;
		end
		
		return self.m_Value;
	end,
    ---------------------------------------------------------------
	ModifyValue = function(self, value)
		return self:SetValue(self.m_Value + value);
	end,
    ---------------------------------------------------------------
	GetValue = function(self)
		return self.m_Value;
	end,
    ---------------------------------------------------------------
	SetMaxValue = function(self, value)
		self.m_MaxValue = math.floor(value);
		self.m_MaxValuesTable = {};
		
		local numStr = tostring(self.m_MaxValue);
		for i = 1, string.len(numStr) do
			self.m_MaxValuesTable[i] = self.m_NamePrefix .. string.sub(numStr, i, i);
		end
	end,
    ---------------------------------------------------------------
	SetValuePair = function(self, value)
		self:SetMaxValue(value);
		self:SetValue(value);
	end,
};



--=======================================================================
-- PuzzleTimerWidget
--=======================================================================

PuzzleTimerWidget =
{
    --
    -- Fields
    --
	m_GameObject = nil,
    m_Minute = 0,
	m_Second = 0,
	m_NamePrefix = nil,
	m_Sprite = nil,
	m_ValuesTable = nil,

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
    Create = function(self, t, ui)
		-- Create widget
		local o = self:Instance
		{
			m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
            m_Minute = t.minute or NUMBER_DEFAULT_VALUE,
			m_Second = t.second or NUMBER_DEFAULT_VALUE,
            m_NumberOffset = t.numberOffset or 0,
		};
		
		CreateDefaultUIComponents(o, ui, t);

        -- Determine rendering route
        if (g_AppData:GetData("UIDebug")) then
            o.OnRender = o.Render_Debug;
        else
            o.OnRender = o.Render_Release;
        end

        -- Determine if it will do Update procedure
        if (t["doUpdate"]) then
            o.OnUpdate = o.Update;
        end

		return o;
	end,
    ---------------------------------------------------------------
	Init = function(self)
		if (self.m_GameObject["Sprite"] ~= nil) then
			self.m_Sprite = self.m_GameObject["Sprite"];
			self.m_Width = self.m_Sprite:GetSize() + self.m_NumberOffset;
			
			-- Get (length-1) substring for m_NamePrefix
			local name = self.m_Sprite:GetImageName();
			self.m_NamePrefix = string.sub(name, 1, string.len(name) - 1);            

            self.m_SignColon = self.m_NamePrefix .. NUMBER_SIGN_COLON;
		end

		self:SetTime(self.m_Minute, self.m_Second);
    end,
    ---------------------------------------------------------------
	Render_Release = function(self)
        local offset = 1;

        -- Timer minute
        for index, digit in ipairs(self.m_MinuteValuesTable) do
            self.m_Sprite:SetImage(digit);
            self.m_Sprite:DrawOffset(self.m_Width * (offset - 1), 0);
            offset = offset + 1;
        end
        
        -- Colon sign
        self.m_Sprite:SetImage(self.m_SignColon);
        self.m_Sprite:DrawOffset(self.m_Width * (offset - 1), 0);
        offset = offset + 1;

        -- Timer second
        for index, digit in ipairs(self.m_SecondValuesTable) do
            self.m_Sprite:SetImage(digit);
            self.m_Sprite:DrawOffset(self.m_Width * (offset - 1), 0);
            offset = offset + 1;
        end
    end,
    ---------------------------------------------------------------
	Render_Debug = function(self)
		if (self.m_Sprite ~= nil) then
            self:Render_Release();
		end
	end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	Update = function(self)
		self.m_GameObject:Update();
	end,
    ---------------------------------------------------------------
    SetMinute = function(self, minute)
        if (self.m_Minute < 0) then
            return;
        end
        
		self.m_Minute = minute;
		self.m_MinuteValuesTable = {};

        local numStr = tostring(self.m_Minute);        
        for i = 1, string.len(numStr) do
            self.m_MinuteValuesTable[i] = self.m_NamePrefix .. string.sub(numStr, i, i);
        end
        
        return self.m_Minute;
    end,
    ---------------------------------------------------------------
    SetSecond = function(self, second)        
        self.m_Second = second;
        self.m_SecondValuesTable = {};

        if (self.m_Second < 0) then
			if (self.m_Minute > 0) then
	            self.m_Second = 59;
	            self:ModifyMinute(-1);
			else
				self.m_Second = 0;
			end
        elseif (self.m_Second > 59) then
            self.m_Second = 0;
            self:ModifyMinute(1);
        end
        
        local numStr;
        if (self.m_Second == 0) then
            numStr = "00";
        elseif (self.m_Second < 10) then
            numStr = "0" .. self.m_Second;
        else
            numStr = tostring(self.m_Second);
        end

        for i = 1, string.len(numStr) do
            self.m_SecondValuesTable[i] = self.m_NamePrefix .. string.sub(numStr, i, i);
        end
        
        return self.m_Minute * 60 + self.m_Second;
    end,
    ---------------------------------------------------------------
	ModifyMinute = function(self, minute)
		return self:SetMinute(self.m_Minute + minute);
	end,
    ---------------------------------------------------------------
	ModifySecond = function(self, second)
		return self:SetSecond(self.m_Second + second);
	end,
    ---------------------------------------------------------------
	SetTime = function(self, minute, second)
        self:SetMinute(minute);
        self:SetSecond(second);
	end,
    ---------------------------------------------------------------
	GetTime = function(self)
		return self.m_Minute * 60 + self.m_Second;
	end,
};



--=======================================================================
-- PuzzleHourTimerWidget
--=======================================================================

PuzzleHourTimerWidget = PuzzleTimerWidget:Instance
{
    --
    -- Fields
    --
	m_GameObject = nil,
	m_Hour = 0,
    m_Minute = 0,
	m_Second = 0,
	m_NamePrefix = nil,
	m_Sprite = nil,
	m_ValuesTable = nil,
	m_EndCallback = nil,
	m_HourCallback = nil,

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
    Create = function(self, t, ui)
		-- Create widget
		local o = self:Instance
		{
			m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
			m_Hour = t.hour or NUMBER_DEFAULT_VALUE,
            m_Minute = t.minute or NUMBER_DEFAULT_VALUE,
			m_Second = t.second or NUMBER_DEFAULT_VALUE,
            m_NumberOffset = t.numberOffset or 0,
		};
		
		CreateDefaultUIComponents(o, ui, t);

        -- Determine rendering route
        if (g_AppData:GetData("UIDebug")) then
            o.OnRender = o.Render_Debug;
        else
            o.OnRender = o.Render_Release;
        end

        -- Determine if it will do Update procedure
        if (t["doUpdate"]) then
            o.OnUpdate = o.Update;
        end

		return o;
	end,
    ---------------------------------------------------------------
	Init = function(self)
		if (self.m_GameObject["Sprite"] ~= nil) then
			self.m_Sprite = self.m_GameObject["Sprite"];
			self.m_Width = self.m_Sprite:GetSize() + self.m_NumberOffset;
			
			-- Get (length-1) substring for m_NamePrefix
			local name = self.m_Sprite:GetImageName();
			self.m_NamePrefix = string.sub(name, 1, string.len(name) - 1);            

            self.m_SignColon = self.m_NamePrefix .. NUMBER_SIGN_COLON;
		end

		self:SetTime(self.m_Hour, self.m_Minute, self.m_Second);
    end,
    ---------------------------------------------------------------
	Render_Release = function(self)
        local offset = 1;

        -- Timer hour
        for index, digit in ipairs(self.m_HourValuesTable) do
            self.m_Sprite:SetImage(digit);
            self.m_Sprite:DrawOffset(self.m_Width * (offset - 1), 0);
            offset = offset + 1;
        end
        
        -- Colon sign
        self.m_Sprite:SetImage(self.m_SignColon);
        self.m_Sprite:DrawOffset(self.m_Width * (offset - 1), 0);
        offset = offset + 1;

        -- Timer minute
        for index, digit in ipairs(self.m_MinuteValuesTable) do
            self.m_Sprite:SetImage(digit);
            self.m_Sprite:DrawOffset(self.m_Width * (offset - 1), 0);
            offset = offset + 1;
        end
        
        -- Colon sign
        self.m_Sprite:SetImage(self.m_SignColon);
        self.m_Sprite:DrawOffset(self.m_Width * (offset - 1), 0);
        offset = offset + 1;

        -- Timer second
        for index, digit in ipairs(self.m_SecondValuesTable) do
            self.m_Sprite:SetImage(digit);
            self.m_Sprite:DrawOffset(self.m_Width * (offset - 1), 0);
            offset = offset + 1;
        end
    end,
    ---------------------------------------------------------------
	SetHour = function(self, hour)
		self.m_Hour = hour;
		self.m_HourValuesTable = {};

        local numStr;
        if (self.m_Hour == 0) then
            numStr = "00";
        elseif (self.m_Hour < 10) then
            numStr = "0" .. self.m_Hour;
        else
            numStr = tostring(self.m_Hour);
        end

        for i = 1, string.len(numStr) do
            self.m_HourValuesTable[i] = self.m_NamePrefix .. string.sub(numStr, i, i);
        end
        
        return self.m_Hour;
    end,
    ---------------------------------------------------------------
    SetMinute = function(self, minute)        
        self.m_Minute = minute;
        self.m_MinuteValuesTable = {};

        if (self.m_Minute < 0) then
			if (self.m_Hour > 0) then
				self.m_Minute = 59;
				self:ModifyHour(-1);
			end
        elseif (self.m_Minute > 59) then
            self.m_Minute = 0;
            self:ModifyHour(1);
        end
        
        local numStr;
        if (self.m_Minute == 0) then
            numStr = "00";
        elseif (self.m_Minute < 10) then
            numStr = "0" .. self.m_Minute;
        else
            numStr = tostring(self.m_Minute);
        end

        for i = 1, string.len(numStr) do
            self.m_MinuteValuesTable[i] = self.m_NamePrefix .. string.sub(numStr, i, i);
        end
        
        return self.m_Minute;
    end,
    ---------------------------------------------------------------
    SetSecond = function(self, second)        
        self.m_Second = second;
        self.m_SecondValuesTable = {};

        if (self.m_Second < 0) then
			if (self.m_Minute > 0) then
	            self.m_Second = 59;
	            self:ModifyMinute(-1);
			else
				if (self.m_Hour > 0) then
					self:ModifyHour(-1);
					self:SetMinute(59);
					self.m_Second = 59;
					
					if (self.m_HourCallback) then
						self.m_HourCallback(self.m_Hour);
					end
				else
					self.m_Second = 0;
					
					if (self.m_EndCallback) then
						self.m_EndCallback();
					end
				end
			end
        elseif (self.m_Second > 59) then
            self.m_Second = 0;
            self:ModifyMinute(1);
        end
        
        local numStr;
        if (self.m_Second == 0) then
            numStr = "00";
        elseif (self.m_Second < 10) then
            numStr = "0" .. self.m_Second;
        else
            numStr = tostring(self.m_Second);
        end

        for i = 1, string.len(numStr) do
            self.m_SecondValuesTable[i] = self.m_NamePrefix .. string.sub(numStr, i, i);
        end
        
        return self.m_Minute * 60 + self.m_Second;
    end,
    ---------------------------------------------------------------
	ModifyHour = function(self, hour)
		return self:SetHour(self.m_Hour + hour);
	end,
    ---------------------------------------------------------------
	SetTime = function(self, hour, minute, second)
        self:SetHour(hour);
        self:SetMinute(minute);
        self:SetSecond(second);
	end,
    ---------------------------------------------------------------
	GetTime = function(self)
		return self.m_Hour, self.m_Minute, self.m_Second;
	end,
    ---------------------------------------------------------------
	GetHour = function(self)
		return self.m_Hour;
	end,
    ---------------------------------------------------------------
	AttachCallback = function(self, endFunc, hourFunc)
		self.m_EndCallback = endFunc;
		self.m_HourCallback = hourFunc;
	end,
};



--=======================================================================
-- PuzzleProgressbarWidget
--=======================================================================

PuzzleProgressbarWidget =
{
    --
    -- Fields
    --
	m_GameObject = nil,
    m_SpriteGC = nil,

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
	Create = function(self, t, ui)
		-- Create widget object
        local o = self:Instance
		{
			m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
			m_Name = t.name,
			m_Value = t.value or 0,
			m_ValueLength = 0,
			m_MaxValue = t.maxValue or 100,
		};

		CreateDefaultUIComponents(o, ui, t);

        -- Determine if it will do Update procedure
        if (t["doUpdate"]) then
            o.OnUpdate = o.Update;
        end

		return o;
	end,
    ---------------------------------------------------------------
	Init = function(self)
        assert(self.m_GameObject["Sprite"]);
        assert(self.m_GameObject["Sprite"]:GetImageCount() == 2);
        
        self.m_SpriteGC = self.m_GameObject["Sprite"];
        self.m_MaxLength, self.m_Height = self.m_SpriteGC:GetSize();
        self.m_CoordU1, self.m_CoordV1, self.m_CoordU2, self.m_CoordV2 = self.m_SpriteGC:GetTexCoords();
        
		self:SetValue(self.m_Value);
	end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	Update = function(self)
		self.m_GameObject:Update();
	end,
    ---------------------------------------------------------------
	OnRender = function(self)
        self.m_GameObject:Render();
    end,
    ---------------------------------------------------------------
	OnReset = function(self)
		self.m_Value = 0;
		self.m_ValueLength = 0;
	end,
    ---------------------------------------------------------------
	SetMaxValue = function(self, value)
		self.m_MaxValue = value;
		self:SetValue(self.m_Value);
	end,
    ---------------------------------------------------------------
	SetValue = function(self, value)
        ---------------------------------
        -- Calculate progress bar values
        ---------------------------------
		self.m_Value = value;

		if (self.m_Value < 0) then
			self.m_Value = 0;
		elseif (self.m_Value > self.m_MaxValue) then
			self.m_Value = self.m_MaxValue;
		end

		self.m_ValueLength = self.m_MaxLength * (self.m_Value / self.m_MaxValue);
        --log("ValueLength: ".. self.m_ValueLength.." => [v / m] = "..self.m_Value.." / "..self.m_MaxValue)

        ---------------------------------
        -- Modify progress bar outlook
        ---------------------------------
        local newCoord = self.m_CoordU1 + (self.m_CoordU2 - self.m_CoordU1) * (self.m_Value / self.m_MaxValue);
        
        -- Primary sprite is index 2
        self.m_SpriteGC:SetRenderSizeAndTexCoords(2, self.m_ValueLength, self.m_Height, self.m_CoordU1, self.m_CoordV1, newCoord, self.m_CoordV2);
        
        return self.m_Value;
	end,
    ---------------------------------------------------------------
	SetValuePair = function(self, value)
		self:SetMaxValue(value);
		self:SetValue(value);
	end,
    ---------------------------------------------------------------
	ModifyValue = function(self, value)
		return self:SetValue(self.m_Value + value);
	end,
    ---------------------------------------------------------------
	GetValue = function(self)
		return self.m_Value;
	end,
    ---------------------------------------------------------------
	GetMaxValue = function(self, value)
		return self.m_MaxValue;
	end,
    ---------------------------------------------------------------
    SetImage = function(self, name)
        -- Primary sprite is index 2
        self.m_SpriteGC:SetImage(2, name);
        self.m_CoordU1, self.m_CoordV1, self.m_CoordU2, self.m_CoordV2 = self.m_SpriteGC:GetTexCoords();
    end,
};



--=======================================================================
-- PuzzleSliderWidget
--=======================================================================

PuzzleSliderWidget = PuzzleProgressbarWidget:Instance
{
    --
    -- Fields
    --
	m_GameObject = nil,
    m_SpriteGC = nil,

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
	Create = function(self, t, ui)
		-- Create widget object
        local o = self:Instance
		{
			m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
			m_Name = t.name,
			m_Value = t.value or 0,
			m_ValueLength = 0,
			m_MaxValue = t.maxValue or 100,
		};

		CreateDefaultUIComponents(o, ui, t);

        -- Determine if it will do Update procedure
        if (t["doUpdate"]) then
            o.OnUpdate = o.Update;
        end

		return o;
	end,
    ---------------------------------------------------------------
	Init = function(self)
        assert(self.m_GameObject["Sprite"]);
        assert(self.m_GameObject["Sprite"]:GetImageCount() == 3);
        
        self.m_SpriteGC = self.m_GameObject["Sprite"];
        self.m_MaxLength, self.m_Height = self.m_SpriteGC:GetSize();
        self.m_CoordU1, self.m_CoordV1, self.m_CoordU2, self.m_CoordV2 = self.m_SpriteGC:GetTexCoords();
		
		self.m_ConeOffsetX, self.m_ConeOffsetY = self.m_SpriteGC:GetOffset(3);

		self:SetValue(self.m_Value);
	end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	SetValue = function(self, value)
		self.m_Value = value;

		if (self.m_Value < 0) then
			self.m_Value = 0;
		elseif (self.m_Value > self.m_MaxValue) then
			self.m_Value = self.m_MaxValue;
		end

		self.m_ValueLength = self.m_MaxLength * (self.m_Value / self.m_MaxValue);

        -- Modify progress bar outlook
        local newCoord = self.m_CoordU1 + (self.m_CoordU2 - self.m_CoordU1) * (self.m_Value / self.m_MaxValue);
        self.m_SpriteGC:SetRenderSizeAndTexCoords(2, self.m_ValueLength, self.m_Height, self.m_CoordU1, self.m_CoordV1, newCoord, self.m_CoordV2);

        -- Modify progress cone outlook
		self.m_SpriteGC:SetOffset(3, self.m_ValueLength + self.m_ConeOffsetX, self.m_ConeOffsetY);
	end,
};


--[[
--=======================================================================
-- ProgressbarWidget 
-- (non-puzzle widget for temporary usage)
--=======================================================================

PBAR_COLOR_SET =
{
	{ 1, 0, 0, ALPHA_MAX },
	{ 0, 1, 0, ALPHA_MAX },
	{ 1, 1, 1, ALPHA_MAX },
};

ProgressbarWidget =
{
    --
    -- Fields
    --
	m_GameObject = nil,

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
	Create = function(self, t, ui)
		-- Create widget object
        local o = self:Instance
		{
			m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
			m_Name = t.name,
			m_Value = t.value or 0,
			m_ValueLength = 0,
			m_MaxValue = t.maxValue or 100,
			m_MaxLength = t.width or 100,
		};

		CreateDefaultUIComponents(o, ui, t);
		return o;
	end,
    ---------------------------------------------------------------
	Init = function(self)
		self:SetValue(self.m_Value);
	end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	OnUpdate = function(self)
		self.m_GameObject:Update();
	end,
    ---------------------------------------------------------------
	OnRender = function(self)
        local x, y = self.m_GameObject["Transform"]:GetTranslate();
        local sizeX, sizeY = self.m_GameObject["Bound"]:GetSize();

        -- Draw outline
        DrawRectangle(x, y, sizeX, sizeY, PBAR_COLOR_SET[3][1], PBAR_COLOR_SET[3][2], PBAR_COLOR_SET[3][3], PBAR_COLOR_SET[1][4]);
            
        -- Draw depleted part
        DrawRectangle(x + 1, y + 1, sizeX - 1, sizeY - 1, PBAR_COLOR_SET[1][1], PBAR_COLOR_SET[1][2], PBAR_COLOR_SET[1][3], PBAR_COLOR_SET[1][4]);
            
        -- Draw progressing part
        if (self.m_ValueLength > 0) then
            DrawRectangle(x + 1, y + 1, self.m_ValueLength - 1, sizeY - 1, PBAR_COLOR_SET[2][1], PBAR_COLOR_SET[2][2], PBAR_COLOR_SET[2][3], PBAR_COLOR_SET[2][4]);
        end

        if (g_AppData:GetData("UIShowText")) then
            local str = string.format("%d / %d", self.m_Value, self.m_MaxValue);
            g_FontRenderer:Draw(x + sizeX * 0.3, y + sizeY * 0.3, str);
            
            if (self.m_Name ~= nil) then
                g_FontRenderer:Draw(x, y - sizeY * 0.85, self.m_Name);
            end
        end        
	end,
    ---------------------------------------------------------------
	OnReset = function(self)
		self.m_Value = 0;
		self.m_ValueLength = 0;
	end,
    ---------------------------------------------------------------
	SetMaxValue = function(self, value)
		self.m_MaxValue = value;
		self:SetValue(self.m_Value);
	end,
    ---------------------------------------------------------------
	SetValue = function(self, value)
		self.m_Value = value;

		if (self.m_Value < 0) then
			self.m_Value = 0;
		elseif (self.m_Value > self.m_MaxValue) then
			self.m_Value = self.m_MaxValue;
		end

		self.m_ValueLength = self.m_MaxLength * (self.m_Value / self.m_MaxValue);
		
		return self.m_Value;
	end,
    ---------------------------------------------------------------
	ModifyValue = function(self, value)
		return self:SetValue(self.m_Value + value);
	end,
    ---------------------------------------------------------------
	GetValue = function(self)
		return self.m_Value;
	end,
};
--]]

--[[
--=======================================================================
-- XXXWidget
--=======================================================================

XXXWidget =
{
    --
    -- Fields
    --
	m_GameObject = nil,

    --
    -- Private Methods
    --
    Instance = function(self, o)
        o = o or {};
        setmetatable(o, self);
        self.__index = self;
        return o;
    end,

	Create = function(self, t, ui)
		-- Create widget object
        local o = self:Instance
		{
			m_GameObject = ObjectFactory:CreateGameObject("UIObject"),
		};

		CreateDefaultUIComponents(o, ui, t);

        -- Determine if it will do Update procedure
        if (t["doUpdate"]) then
            o.OnUpdate = o.Update;
        end

		return o;
	end,

    --
    -- Public Methods
    --
	Update = function(self)
		self.m_GameObject:Update();
	end,

	OnRender = function(self)
		self.m_GameObject:Render();
	end,

	--OnMouseMove = function(self, x, y)
	--end,

	--OnMousePressed = function(self, x, y)
	--end,

	--OnMouseReleased = function(self, x, y)
	--end,
};
--]]



--=======================================================================
-- Register game UI widget templates
--=======================================================================

UIManager:AddGameUIWidgetTemplate(PuzzleTextWidget, "PuzzleText");
UIManager:AddGameUIWidgetTemplate(PuzzlePictureWidget, "PuzzlePicture");
UIManager:AddGameUIWidgetTemplate(PuzzleButtonWidget, "PuzzleButton");
UIManager:AddGameUIWidgetTemplate(PuzzleCheckButtonWidget, "PuzzleCheckButton");
UIManager:AddGameUIWidgetTemplate(PuzzleRadioButtonGroupWidget, "PuzzleRadioButtonGroup");
UIManager:AddGameUIWidgetTemplate(PuzzleNumberWidget, "PuzzleNumber");
UIManager:AddGameUIWidgetTemplate(PuzzleTimerWidget, "PuzzleTimer");
UIManager:AddGameUIWidgetTemplate(PuzzleHourTimerWidget, "PuzzleHourTimer");
UIManager:AddGameUIWidgetTemplate(PuzzleProgressbarWidget, "PuzzleProgressbar");
UIManager:AddGameUIWidgetTemplate(PuzzleSliderWidget, "PuzzleSlider");
--UIManager:AddGameUIWidgetTemplate(ProgressbarWidget, "Progressbar");
