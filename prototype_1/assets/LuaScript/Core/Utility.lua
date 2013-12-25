--***********************************************************************
-- @file Utility.lua
--***********************************************************************

--=======================================================================
-- Predefined Colors
--=======================================================================

COLOR_BLACK = { 0, 0, 0 };
COLOR_WHITE = { 1, 1, 1 };
COLOR_GRAY = { 0.1, 0.1, 0.1 };

COLOR_RED = { 1, 0, 0 };
COLOR_GREEN = { 0, 1, 0 };
COLOR_BLUE = { 0, 0, 1 };

COLOR_YELLOW = { 1, 1, 0 };
COLOR_CYAN = { 0, 1, 1 };
COLOR_MAGENTA = { 1, 0, 1 };

COLOR_ORANGE = { 1, 0.666, 0 };
COLOR_PINK = { 1, 0.666, 0.666 };
COLOR_PURPLE = { 0.666, 0.333, 1 };

COLOR_DARKRED = { 0.333, 0, 0 };
COLOR_DARKGREEN = { 0, 0.333, 0 };
COLOR_DARKBLUE = { 0, 0, 0.333 };

ALPHA_MAX = 1;
ALPHA_THREEQUARTER = 0.75;
ALPHA_HALF = 0.5;
ALPHA_QUARTER = 0.25;
ALPHA_ZERO = 0;



--=======================================================================
-- LuaTimer
--=======================================================================

LuaTimer =
{
	m_CurrentTime = 0,
	m_LastTime = 0,
	m_DeltaTime = 0,
	m_Paused = false;

    Instance = function(self, o)
        o = o or {};
        setmetatable(o, self);
        self.__index = self;
        return o;
    end,

    Create = function(self)
		print("LuaTimer creation done");
		return self:Instance();
    end,

	Update = function(self)
		if (not self.m_Paused) then
			self.m_CurrentTime = os.clock() * 1000;
			self.m_DeltaTime = self.m_CurrentTime - self.m_LastTime;
			self.m_LastTime = self.m_CurrentTime;
		end
	end,

    GetElapsedTime = function(self)
        return os.clock();
    end,

	GetDeltaTime = function(self)
		return self.m_DeltaTime;
	end,

	Pause = function(self)
		self.m_Paused = true;
		self.m_DeltaTime = 0;
	end,

	Resume = function(self)
		self.m_Paused = false;
		self.m_LastTime = os.clock();
	end,
};



--=======================================================================
-- Data Manager
--=======================================================================

-------------------------------------------------------------------------
DataManager =
{
    --
    -- Fields
    --
    m_DataPool = {},

    --
    -- Private Methods
    --
    Instance = function(self, o)
        o = o or {};
        setmetatable(o, self);
        self.__index = self;
        return o;
    end,

    Create = function(self)
        local o = self:Instance();

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------------
    SetData = function(self, name, data)
        self.m_DataPool[name] = data;        
    end,
    ---------------------------------------------------------------------
    SetDataInRange = function(self, name, data, min, max)
        assert(min);
        assert(max);
        assert(min <= max);
        
        if (data < min) then
            self.m_DataPool[name] = min;
        elseif (data > max) then
            self.m_DataPool[name] = max;
        else
            self.m_DataPool[name] = data;
        end

        return self.m_DataPool[name];
    end,
    ---------------------------------------------------------------------    
    GetData = function(self, name)
        return self.m_DataPool[name];
    end,
    ---------------------------------------------------------------------    
    ModifyData = function(self, name, data)
        assert(self.m_DataPool[name]);
        self.m_DataPool[name] = self.m_DataPool[name] + data;
        return self.m_DataPool[name];
    end,
    ---------------------------------------------------------------------    
    ModifyDataInRange = function(self, name, data, min, max)
        assert(self.m_DataPool[name]);
        return self:SetDataInRange(name, self.m_DataPool[name] + data, min, max);
    end,
    ---------------------------------------------------------------------
    Dump = function(self)
        DumpTable(self.m_DataPool);
    end,
};



--=======================================================================
-- Utilities
--=======================================================================

-------------------------------------------------------------------------
function DumpTable(t, name, depth)
	if (type(t) ~= "table") then
		log("  Wrong type for DumpTable(): " .. type(t));
		return;
	end

	depth = depth or 0;
	
	if (depth > 5) then  -- Max depth is 5
		return;
	end
	
	local indent = "";
	for i = 1, depth do
		indent = indent .. "   ";
	end
	
	if (depth == 0) then
		log("\n===[DumpTable]=== " .. (name or ""));
	end

	for k, v in pairs(t) do
		local vtype = type(v);

		if (vtype == "userdata") then
			log(indent .. tostring(k) .. " => [" .. vtype .. "] ");
		else
			log(indent .. tostring(k) .. " => [" .. vtype .. "] " .. tostring(v));
		end

		if (vtype == "table") then
			DumpTable(v, tostring(k), depth + 1);
		end
	end
    
	if (depth == 0) then
	    log("===[DumpTable]=== END\n");
	end
end

-------------------------------------------------------------------------
function CollectGarbage(option)
    collectgarbage(option);
end

-------------------------------------------------------------------------
function ShowMemoryUsage(title)
    local memoryInUse = collectgarbage("count");
    g_AppData:SetData("MemoryInUse", memoryInUse);
    log(string.format("[%s] MemoryInUse: %.f KB", title or "_", memoryInUse));
end

--[[ @Windows/Mac Only
-------------------------------------------------------------------------
function OnKeyPressed(key)
	if (g_InputSystem:IsKeyPressed(key)) then
		if (g_KeyState[key] ~= true) then
			g_KeyState[key] = true;
			return true;
		end
	else
		g_KeyState[key] = false;
	end

	return false;
end

-------------------------------------------------------------------------
function OnMousePressed(button)
	if (g_InputSystem:IsMouseButtonPressed(button)) then
		if (g_MouseState[button] ~= true) then
			g_MouseState[button] = true;
			return true;
		end
	else
		g_MouseState[button] = false;
	end

	return false;
end

-------------------------------------------------------------------------
function GetMousePosition()
	return g_InputSystem:GetMousePositionX(), g_InputSystem:GetMousePositionY();
end
--]]

-------------------------------------------------------------------------
function RandShuffle(t)
	assert(type(t) == "table");
	
	local range = table.maxn(t);
	for i = 1, range - 1 do
		local index = math.random(i, range);
		t[i], t[index] = t[index], t[i];
	end
end

-------------------------------------------------------------------------
function RandDeck(t)
	assert(type(t) == "table");

	local pool = t;
	local counter = table.maxn(t);

	return function()
		counter = counter + 1;
		
		if (counter > table.maxn(pool)) then
			RandShuffle(pool);
			counter = 1;
		end

		return pool[counter];
	end
end

-------------------------------------------------------------------------
function RandMultiDeck(t)
	assert(type(t) == "table");

	local pool = t;
	local counter = table.maxn(t);

	return function(num)
		num = num or 1;
		
		if (num == 1) then
			counter = counter + 1;
			
			if (counter > table.maxn(pool)) then
				RandShuffle(pool);
				counter = 1;
			end
	
			return pool[counter];
		else
			if (counter + num > table.maxn(pool)) then
				RandShuffle(pool);
				counter = 1;
			end
	
			local result = {};
			for index = counter, counter + num - 1 do
				table.insert(result, pool[index]);
			end

			counter = counter + num;
			
			return result;
		end
	end
end

-------------------------------------------------------------------------
function RandColor()
    return math.random(), math.random(), math.random();
end

-------------------------------------------------------------------------
function RandElement(t)
    return t[ math.random(1, #t) ];
end

-------------------------------------------------------------------------
function ModifyValueByRandRange(value, factor)
    return value + math.random(-factor, factor);
end

-------------------------------------------------------------------------
function ModifyPairByRandRange(value, factor)
    return value[1] + math.random(-factor, factor), value[2] + math.random(-factor, factor);
end

-------------------------------------------------------------------------
function Sqrt(x, y)
	return math.sqrt(x * x + y * y);
end

-------------------------------------------------------------------------
function Square(x, y)
	if (y == nil) then
		return (x * x);
	else
		return (x * x + y * y);
	end
end

-------------------------------------------------------------------------
function Normalize(x, y)
	local v = math.sqrt(x * x + y * y);

	if (v == 0) then
		return 0, 0;
	else
		return (x / v), (y / v);
	end
end

-------------------------------------------------------------------------
function Clamp(value, min, max)
    assert(min);
    assert(max);
    assert(min <= max);
    
    if (value < min) then
        return min;
    elseif (value > max) then
        return max;
    else
        return value;
    end
end

-------------------------------------------------------------------------
function UpdateGOTranslate(value, go)
	local x = go["Attribute"]:Get("CyclePosX");
	local y = go["Attribute"]:Get("CyclePosY");
	
	if (go["Attribute"]:Get("CycleAxisX")) then
		go["Transform"]:SetTranslate(x + value, y);
	else
		go["Transform"]:SetTranslate(x, y + value);
	end
end

-------------------------------------------------------------------------
function UpdateGORotate(value, go)
	go:SetRotateByRadian(math.pi * 2 * value);
end

-------------------------------------------------------------------------
function UpdateGOScale(value, go)
    go:SetScale(value);
end

-------------------------------------------------------------------------
function UpdateGOAlpha(value, go)
    go:SetAlpha(value);
end

-------------------------------------------------------------------------
function UpdateWidgetNumber(value, widget)
    widget:SetValue(value);
end

-------------------------------------------------------------------------
function CycleGOTranslate(go, value, halfDuration, axisX)
	assert(go["Attribute"], "AttributeComponent is required")
	go["Attribute"]:Set("CyclePosX", go["Transform"]:GetTranslateX());
	go["Attribute"]:Set("CyclePosY", go["Transform"]:GetTranslateY());
	
	if (axisX) then
		go["Attribute"]:Set("CycleAxisX", true);
	else
		go["Attribute"]:Set("CycleAxisX", false);
	end
	
	local interGC = go["Interpolator"];
	interGC:ResetTarget(0, value, halfDuration);
	interGC:AppendNextTarget(value, 0, halfDuration);
	interGC:SetCycling(true);
	interGC:AttachUpdateCallback(UpdateGOTranslate, go);
end

-------------------------------------------------------------------------
function CycleGORotate(go, beginValue, endValue, halfDuration)
	local interGC = go["Interpolator"];
	interGC:ResetTarget(beginValue, endValue, halfDuration);
	interGC:SetCycling(true);
	interGC:AttachUpdateCallback(UpdateGORotate, go["Transform"]);
end

-------------------------------------------------------------------------
function CycleGOScale(go, beginValue, endValue, halfDuration)
	local interGC = go["Interpolator"];
	interGC:ResetTarget(beginValue, endValue, halfDuration);
	interGC:AppendNextTarget(endValue, beginValue, halfDuration);
	interGC:SetCycling(true);
	interGC:AttachUpdateCallback(UpdateGOScale, go["Transform"]);
end

-------------------------------------------------------------------------
function CycleGOAlpha(go, beginValue, endValue, halfDuration, gc)
	local interGC = go["Interpolator"];
	interGC:ResetTarget(beginValue, endValue, halfDuration);
	interGC:AppendNextTarget(endValue, beginValue, halfDuration);
	interGC:SetCycling(true);	
	interGC:AttachUpdateCallback(UpdateGOAlpha, (gc or go["Sprite"]));
end

-------------------------------------------------------------------------
function DrawRectangle(x, y, width, height, r, g, b, a)
	x = x * APP_UNIT_X;
	y = y * APP_UNIT_Y;
	g_GraphicsEngine:DrawRectangle(x, y, x + width, y + height, r, g, b, a);
end

-------------------------------------------------------------------------
function DrawIndieRectangle(x, y, width, height, r, g, b, a)
	g_GraphicsEngine:DrawRectangle(x, y, x + width, y + height, r, g, b, a);
end

-------------------------------------------------------------------------
function DrawCircle(x, y, radius, r, g, b, a)
	g_GraphicsEngine:DrawCircle(x, y, radius, r, g, b, a);
end

-------------------------------------------------------------------------
function DrawIndieCircle(x, y, radius, r, g, b, a)
	g_GraphicsEngine:DrawCircle(x, y, radius, r, g, b, a);
end

-------------------------------------------------------------------------
function DrawFullscreenMask()
	g_GraphicsEngine:DrawRectangle(0, 0, SCREEN_UNIT_X, SCREEN_UNIT_Y, 0.1, 0.1, 0.1, ALPHA_THREEQUARTER);
end

-------------------------------------------------------------------------
function DrawFullscreenColorMask(r, g, b, a)
	g_GraphicsEngine:DrawRectangle(0, 0, SCREEN_UNIT_X, SCREEN_UNIT_Y, r, g, b, a);
end
