--***********************************************************************
-- @file ObjectComponent.lua
--***********************************************************************

--=======================================================================
-- TransformComponent
--=======================================================================

TransformComponent =
{
    --
    -- Fields
    --
    m_Transform = nil,
	m_X = 0,
	m_Y = 0,

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
    Create = function(self, t, go)
        -- Create C objects
        local transform = g_GraphicsEngine:CreateTransform();

		-- Set default transform values
		t.x = t.x or 0;
		t.y = t.y or 0;
		t.angle = t.angle or 0;
		t.scale = t.scale or 1;

        -- Create component
        local o = self:Instance
		{
			m_Transform = transform,
			m_X = t.x,
			m_Y = t.y,
		};
		
		if (go:IsIndieTranslated()) then
			o.SetTranslate = o.SetIndieTranslate;
			o.SetTranslateX = o.SetIndieTranslateX;
			o.SetTranslateY = o.SetIndieTranslateY;
			o.SetTranslateEx = o.SetIndieTranslateEx;
			o.SetTranslateAttached = o.SetIndieTranslateAttached;
			o.ModifyTranslate = o.ModifyIndieTranslate;
			o.ModifyTranslateEx = o.ModifyIndieTranslateEx;
			o.ModifyTranslateAttached = o.ModifyIndieTranslateAttached;
		--else
		end

		if (t.x ~= 0 or t.y ~= 0) then
			transform:SetTranslate(t.x, t.y);
		end

		if (t.angle ~= 0) then
			transform:SetRotateByRadian(t.angle);
		end

		if (t.scale ~= 1) then
			transform:SetScale(t.scale);
		end

        return o;
    end,

    --
    -- Public Methods
    --
	
	--=============================================================
	-- Object
	--=============================================================
    ---------------------------------------------------------------
	GoIndie = function(self)
		self.SetTranslate = self.SetIndieTranslate;
		self.SetTranslateX = self.SetIndieTranslateX;
		self.SetTranslateY = self.SetIndieTranslateY;
		self.SetTranslateEx = self.SetIndieTranslateEx;
		self.SetTranslateAttached = self.SetIndieTranslateAttached;
		self.ModifyTranslate = self.ModifyIndieTranslate;
		self.ModifyTranslateEx = self.ModifyIndieTranslateEx;
		self.ModifyTranslateAttached = self.ModifyIndieTranslateAttached;
	end,
    ---------------------------------------------------------------
	GetObject = function(self)
		return self.m_Transform;
	end,
    ---------------------------------------------------------------
	AttachObject = function(self, go, offsetX, offsetY, component)
		self.m_AttachedObject = self.m_AttachedObject or {};

		-- Translate attached object
		local o = component or go["Transform"];
		o:SetTranslate(self.m_X + offsetX, self.m_Y + offsetY);

		-- Insert to attached list
		table.insert(self.m_AttachedObject,
			{
				gc = o,
				x = offsetX,
				y = offsetY,
			}
		);
        
        self.SetTranslate = self.SetTranslateAttached;
        self.ModifyTranslate = self.ModifyTranslateAttached;

		return table.maxn(self.m_AttachedObject);
	end,
    ---------------------------------------------------------------
	DetachObject = function(self, go)
        assert(self.m_AttachedObject);
        
        for index, obj in ipairs(self.m_AttachedObject) do
            if (obj.gc == go["Transform"]) then
                table.remove(self.m_AttachedObject, index);
                return;
            end
        end
        
        assert(false, "DetachObject error");
	end,
    ---------------------------------------------------------------
	DetachAllObjects = function(self)
        assert(self.m_AttachedObject);

        for i = 1, #self.m_AttachedObject do
            table.remove(self.m_AttachedObject);
        end
        
        assert(#self.m_AttachedObject == 0);
	end,
    ---------------------------------------------------------------
    ReattachObject = function(self, go, offsetX, offsetY)
        assert(self.m_AttachedObject);
        
        for _, obj in ipairs(self.m_AttachedObject) do
            if (obj.gc == go["Transform"]) then
                obj.gc:SetTranslate(self.m_X + offsetX, self.m_Y + offsetY);
                obj.x = offsetX;
                obj.y = offsetY;
                return;
            end
        end
    end,

	--=============================================================
	-- Translation
	--=============================================================
    ---------------------------------------------------------------
    SetTranslate = function(self, x, y)
		self.m_X = x;
		self.m_Y = y;
        self.m_Transform:SetTranslate(self.m_X * APP_UNIT_X, self.m_Y * APP_UNIT_Y);
    end,
    ---------------------------------------------------------------
    SetIndieTranslate = function(self, x, y)
		self.m_X = x;
		self.m_Y = y;
        self.m_Transform:SetTranslate(x, y);
    end,
    ---------------------------------------------------------------
    SetTranslateX = function(self, x)
		self.m_X = x;
        self.m_Transform:SetTranslate(self.m_X * APP_UNIT_X, self.m_Y * APP_UNIT_Y);
    end,
    ---------------------------------------------------------------
    SetIndieTranslateX = function(self, x)
		self.m_X = x;
        self.m_Transform:SetTranslate(x, self.m_Y);
    end,
    ---------------------------------------------------------------
    SetTranslateY = function(self, y)
		self.m_Y = y;
        self.m_Transform:SetTranslate(self.m_X * APP_UNIT_X, self.m_Y * APP_UNIT_Y);
    end,
    ---------------------------------------------------------------
    SetIndieTranslateY = function(self, y)
		self.m_Y = y;
        self.m_Transform:SetTranslate(self.m_X, y);
    end,
    ---------------------------------------------------------------
    SetTranslateEx = function(self, obj)
		self.m_X = obj[1];
		self.m_Y = obj[2];
        self.m_Transform:SetTranslate(self.m_X * APP_UNIT_X, self.m_Y * APP_UNIT_Y);
    end,
    ---------------------------------------------------------------
    SetIndieTranslateEx = function(self, obj)
		self.m_X = obj[1];
		self.m_Y = obj[2];
        self.m_Transform:SetTranslate(self.m_X, self.m_Y);
    end,
    ---------------------------------------------------------------
    SetTranslateAttached = function(self, x, y)
		self.m_X = x;
		self.m_Y = y;
        self.m_Transform:SetTranslate(self.m_X * APP_UNIT_X, self.m_Y * APP_UNIT_Y);

        for _, obj in ipairs(self.m_AttachedObject) do
            obj.gc:SetTranslate(self.m_X + obj.x, self.m_Y + obj.y);
		end
    end,
    ---------------------------------------------------------------
    SetIndieTranslateAttached = function(self, x, y)
		self.m_X = x;
		self.m_Y = y;
        self.m_Transform:SetTranslate(self.m_X, self.m_Y);

        for _, obj in ipairs(self.m_AttachedObject) do
            obj.gc:SetTranslate(self.m_X + obj.x, self.m_Y + obj.y);
		end
    end,
    ---------------------------------------------------------------
	ModifyTranslate = function(self, x, y)
 		self.m_X = self.m_X + x;
		self.m_Y = self.m_Y + y;
        self.m_Transform:SetTranslate(self.m_X * APP_UNIT_X, self.m_Y * APP_UNIT_Y);
	end,
    ---------------------------------------------------------------
	ModifyIndieTranslate = function(self, x, y)
 		self.m_X = self.m_X + x;
		self.m_Y = self.m_Y + y;
        self.m_Transform:SetTranslate(self.m_X, self.m_Y);
	end,
    ---------------------------------------------------------------
	ModifyTranslateEx = function(self, obj)
 		self.m_X = self.m_X + obj[1];
		self.m_Y = self.m_Y + obj[2];
        self.m_Transform:SetTranslate(self.m_X * APP_UNIT_X, self.m_Y * APP_UNIT_Y);
	end,
    ---------------------------------------------------------------
	ModifyIndieTranslateEx = function(self, obj)
 		self.m_X = self.m_X + obj[1];
		self.m_Y = self.m_Y + obj[2];
        self.m_Transform:SetTranslate(self.m_X, self.m_Y);
	end,
    ---------------------------------------------------------------
    ModifyTranslateAttached = function(self, x, y)
 		self.m_X = self.m_X + x;
		self.m_Y = self.m_Y + y;
        self.m_Transform:SetTranslate(self.m_X * APP_UNIT_X, self.m_Y * APP_UNIT_Y);

        for _, obj in ipairs(self.m_AttachedObject) do
            obj.gc:SetTranslate(self.m_X + obj.x, self.m_Y + obj.y);
		end
    end,
    ---------------------------------------------------------------
    ModifyIndieTranslateAttached = function(self, x, y)
 		self.m_X = self.m_X + x;
		self.m_Y = self.m_Y + y;
        self.m_Transform:SetTranslate(self.m_X, self.m_Y);

        for _, obj in ipairs(self.m_AttachedObject) do
            obj.gc:SetTranslate(self.m_X + obj.x, self.m_Y + obj.y);
		end
    end,
    ---------------------------------------------------------------
	GetTranslate = function(self)
		return self.m_X, self.m_Y;
	end,
    ---------------------------------------------------------------
	GetTranslateX = function(self)
		return self.m_X;
	end,
    ---------------------------------------------------------------
	GetTranslateY = function(self)
		return self.m_Y;
	end,

	--=============================================================
	-- Rotation
	--=============================================================
    ---------------------------------------------------------------
    SetRotateByRadian = function(self, radian)
        self.m_Transform:SetRotateByRadian(radian);
    end,
    ---------------------------------------------------------------
    SetRotateByDegree = function(self, degree)
        self.m_Transform:SetRotateByDegree(degree);
    end,
    ---------------------------------------------------------------
    GetRotateByRadian = function(self)
        return self.m_Transform:GetRotateByRadian();
    end,
    ---------------------------------------------------------------
    GetRotateByDegree = function(self)
        return self.m_Transform:GetRotateByDegree();
    end,

	--=============================================================
	-- Scale
	--=============================================================
    ---------------------------------------------------------------
    SetScale = function(self, scale)
        self.m_Transform:SetScale(scale);
    end,
    ---------------------------------------------------------------
    ModifyScale = function(self, value)
		self.m_Transform:ModifyScale(value);
		return self.m_Transform:GetScale();
    end,
    ---------------------------------------------------------------
    GetScale = function(self)
        return self.m_Transform:GetScale();
    end,

	--=============================================================
	-- Distance
	--=============================================================
    ---------------------------------------------------------------
	GetDistanceSqr = function(self, x, y)
		return Square(self.m_X - x, self.m_Y - y);
	end,
};



--=======================================================================
-- LinearMotionComponent
--=======================================================================

MOTION_DEFAULT_VELOCITY = 50;
MOTION_VELOCITY_FACTOR = 0.001;

LinearMotionComponent =
{
    --
    -- Fields
    --
	m_GameObject = nil,
	m_TransformGC = nil,
	m_TargetsQueue = nil,
	m_CurrentTarget = nil,
	m_MovePixel = nil,
	m_CallbackUpdateFunction = nil,
	m_CallbackCompleteFunction = nil,
	m_CallbackObject = nil,
	m_OnMotion = false,
	m_Velocity = 0.0,
	m_Pause = false,
	m_Cycling = false,

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
    Create = function(self, t, go)
		-- Check dependency
		assert(go:CheckDependency(t.class, "Transform"), "Transform GC has not existed.");

        -- Create component
        local o = self:Instance
		{
			m_GameObject = go,
			m_TransformGC = go["Transform"],
			m_TargetsQueue = {},
			m_CurrentTarget = {},
			m_MovePixel = {},
			m_Velocity = (t.velocity or MOTION_DEFAULT_VELOCITY) * MOTION_VELOCITY_FACTOR,
		};

		-- Add events
        go:AddEvent(EVENT_UPDATE, o);

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	SetVelocity = function(self, velocity)
		self.m_Velocity = velocity * MOTION_VELOCITY_FACTOR;
	end,
    ---------------------------------------------------------------
	GetVelocity = function(self)
		return self.m_Velocity;
	end,
    ---------------------------------------------------------------
	AppendFirstTarget = function(self, x, y)
		table.insert(self.m_TargetsQueue, 1, { x, y });
		self.m_OnMotion = false;
	end,
    ---------------------------------------------------------------
	AppendNextTarget = function(self, x, y)
		table.insert(self.m_TargetsQueue, { x, y });
	end,
    ---------------------------------------------------------------
	ResetTarget = function(self, x, y)
		self:Reset();	
		table.insert(self.m_TargetsQueue, { x, y });
	end,
    ---------------------------------------------------------------
	Reset = function(self)
        for i = 1, #self.m_TargetsQueue do
            table.remove(self.m_TargetsQueue);
        end
        assert(#self.m_TargetsQueue == 0);
        
		self.m_OnMotion = false;
	end,
    ---------------------------------------------------------------
	IsOnMotion = function(self)
		return self.m_OnMotion;
	end,
    ---------------------------------------------------------------
	IsDone = function(self)
		if ((not self.m_OnMotion) and (table.maxn(self.m_TargetsQueue) == 0)) then
			return true;
		end

		return false;
	end,
    ---------------------------------------------------------------
	IsPaused = function(self)
		return self.m_Pause;
	end,
    ---------------------------------------------------------------
	Pause = function(self, enable)
		self.m_Pause = enable;
	end,
    ---------------------------------------------------------------
	SetCycling = function(self, cycling)
		self.m_Cycling = cycling;
	end,
    ---------------------------------------------------------------
	GetCurrentTarget = function(self)
		if (self.m_CurrentTarget == nil) then
			return 0, 0;
		end

		return self.m_CurrentTarget[1], self.m_CurrentTarget[2];
	end,
    ---------------------------------------------------------------
	AttachCallback = function(self, updateFunc, completeFunc, object)
        self.m_CallbackUpdateFunction = updateFunc;
		self.m_CallbackCompleteFunction = completeFunc;
		self.m_CallbackObject = object;
	end,
    ---------------------------------------------------------------
	AttachUpdateCallback = function(self, updateFunc, object)
        self.m_CallbackUpdateFunction = updateFunc;
		self.m_CallbackObject = object;
		self.m_CallbackCompleteFunction = nil;
	end,
    ---------------------------------------------------------------
	AttachCompleteCallback = function(self, completeFunc, object)
		self.m_CallbackCompleteFunction = completeFunc;
		self.m_CallbackObject = object;
        self.m_CallbackUpdateFunction = nil;
	end,

    --
    -- Events
    --
    ---------------------------------------------------------------
	OnUpdate = function(self)
		if (self.m_Pause or #self.m_TargetsQueue == 0) then
			return;
		end

		if (self.m_OnMotion) then
            local deltaTime = g_Timer:GetDeltaTime();
            self.m_CurrentTime = self.m_CurrentTime + deltaTime;

			if (self.m_CurrentTime < self.m_Duration) then
				self.m_TransformGC:ModifyTranslate(self.m_MovePixel[1] * deltaTime, self.m_MovePixel[2] * deltaTime);
                
                -- Proceed update callback if existed
                if (self.m_CallbackUpdateFunction ~= nil) then
                    self.m_CallbackUpdateFunction(self.m_GameObject, self.m_CallbackObject);
                end
            else
				self.m_TransformGC:SetTranslate(self.m_CurrentTarget[1], self.m_CurrentTarget[2]);
                
                local obj = table.remove(self.m_TargetsQueue, 1);
                self.m_OnMotion = false;

				if (self.m_Cycling) then
					table.insert(self.m_TargetsQueue, obj);
				end
            
                -- Proceed arrival callback if existed
				if (self.m_CallbackCompleteFunction ~= nil) then
                    self.m_CallbackCompleteFunction(self.m_GameObject, self.m_CallbackObject);
				end
            end
		else
			self.m_CurrentTarget = self.m_TargetsQueue[1];

            local x, y = self.m_TransformGC:GetTranslate();
			self.m_MovePixel[1] = self.m_CurrentTarget[1] - x;
			self.m_MovePixel[2] = self.m_CurrentTarget[2] - y;
            
            --if (self.m_MovePixel[1] == 0 and self.m_MovePixel[2] == 0) then
            --    table.remove(self.m_TargetsQueue, 1);
            --    return;
            --end
            
            if (math.abs(self.m_MovePixel[1]) >= math.abs(self.m_MovePixel[2])) then
                self.m_Duration = math.abs(self.m_MovePixel[1] / self.m_Velocity);
            else
                self.m_Duration = math.abs(self.m_MovePixel[2] / self.m_Velocity);
            end
            
            self.m_MovePixel[1] = self.m_MovePixel[1] / self.m_Duration;
            self.m_MovePixel[2] = self.m_MovePixel[2] / self.m_Duration;

            self.m_CurrentTime = 0;
			self.m_OnMotion = true;
		end
	end,
};



--=======================================================================
-- TimeBasedInterpolatorComponent
--=======================================================================

INTER_BEGIN = 1;
INTER_END = 2;
INTER_DURATION = 3; 	-- Used by TimeBasedInterpolatorComponent
INTER_SPEED = 3;  		-- Used by SpeedBasedInterpolatorComponent

TimeBasedInterpolatorComponent =
{
    --
    -- Fields
    --
	m_TargetsQueue = nil,
	m_CurrentTarget = nil,
	m_CallbackUpdateFunction = nil,
	m_CallbackCompleteFunction = nil,
	m_CallbackObject = nil,
	m_Pause = false,
	m_Looping = false,
	m_Cycling = false,

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
    Create = function(self, t, go)
        -- Create component
        local o = self:Instance
		{
			m_TargetsQueue = {},
			m_CurrentTarget = {},
			m_CurrentValue = t.value or 0,
		};

		-- Add events
        go:AddEvent(EVENT_UPDATE, o);

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	AppendNextTarget = function(self, beginValue, endValue, duration)
		table.insert(self.m_TargetsQueue, {	beginValue, endValue, duration });
	end,
    ---------------------------------------------------------------
	ResetTarget = function(self, beginValue, endValue, duration)
        self:Reset();
		table.insert(self.m_TargetsQueue, { beginValue, endValue, duration });
	end,
    ---------------------------------------------------------------
	Reset = function(self)
        for i = 1, #self.m_TargetsQueue do
            table.remove(self.m_TargetsQueue);
        end
        assert(#self.m_TargetsQueue == 0);
		
		self.m_CurrentValue = 0;
		self.m_OnInterpolating = false;
	end,
    ---------------------------------------------------------------
	SetEnd = function(self)
		if (self.m_OnInterpolating) then
			self:OnInterpolatingEnd();
		end
	end,
    ---------------------------------------------------------------
	AttachCallback = function(self, upfunc, comfunc, object)
		self.m_CallbackUpdateFunction = upfunc;
		self.m_CallbackCompleteFunction = comfunc;
		self.m_CallbackObject = object;
	end,
    ---------------------------------------------------------------
	AttachUpdateCallback = function(self, upfunc, object)
		self.m_CallbackUpdateFunction = upfunc;
		self.m_CallbackCompleteFunction = nil;
		self.m_CallbackObject = object;
	end,
    ---------------------------------------------------------------
	AttachCompleteCallback = function(self, comfunc, object)
		self.m_CallbackUpdateFunction = nil;
		self.m_CallbackCompleteFunction = comfunc;
		self.m_CallbackObject = object;
	end,
    ---------------------------------------------------------------
	SetValue = function(self, value)
		self.m_CurrentValue = value;
	end,
    ---------------------------------------------------------------
	GetValue = function(self)
		return self.m_CurrentValue;
	end,
    ---------------------------------------------------------------
	SetLooping = function(self, looping)
		self.m_Looping = looping;
	end,
    ---------------------------------------------------------------
	SetCycling = function(self, cycling)
		self.m_Cycling = cycling;
	end,
    ---------------------------------------------------------------
	Pause = function(self, enable)
		self.m_Pause = enable;
	end,
    ---------------------------------------------------------------
	IsOnInterpolating = function(self)
		return self.m_OnInterpolating;
	end,
    ---------------------------------------------------------------
	IsDone = function(self)
		if ((not self.m_OnInterpolating) and (table.maxn(self.m_TargetsQueue) == 0)) then
			return true;
		end

		return false;
	end,
    ---------------------------------------------------------------
	OnInterpolatingEnd = function(self)
		self.m_CurrentValue = self.m_CurrentTarget[INTER_END];

		if (self.m_CallbackUpdateFunction) then
			self.m_CallbackUpdateFunction(self.m_CurrentValue, self.m_CallbackObject);
		end

		if (self.m_CallbackCompleteFunction) then
			self.m_CallbackCompleteFunction(self.m_CurrentValue, self.m_CallbackObject);
		end

		if (not self.m_Looping) then
			local obj = table.remove(self.m_TargetsQueue, 1);

			if (self.m_Cycling) then
				table.insert(self.m_TargetsQueue, obj);
			end
		end
				
		self.m_OnInterpolating = false;
	end,

    --
    -- Events
    --
    ---------------------------------------------------------------
	OnUpdate = function(self)
		if (self.m_Pause or #self.m_TargetsQueue == 0) then
			return;
		end

		if (self.m_OnInterpolating) then
            local deltaTime = g_Timer:GetDeltaTime();
			self.m_CurrentTime = self.m_CurrentTime + deltaTime;

			-- Check if duration is due
			if (self.m_CurrentTime < self.m_CurrentTarget[INTER_DURATION]) then
				self.m_CurrentValue = self.m_CurrentValue + deltaTime * self.m_DeltaValue;

                if (self.m_CallbackUpdateFunction) then
                    self.m_CallbackUpdateFunction(self.m_CurrentValue, self.m_CallbackObject);
                end
			else
				self:OnInterpolatingEnd();
			end
		else
			-- Get next target coordinate
			self.m_CurrentTarget = self.m_TargetsQueue[1];
			self.m_CurrentValue = self.m_CurrentTarget[INTER_BEGIN];

			self.m_DeltaValue = ((self.m_CurrentTarget[INTER_END] - self.m_CurrentValue) / self.m_CurrentTarget[INTER_DURATION]);
			self.m_CurrentTime = 0;
			self.m_OnInterpolating = true;

            -- Proceed update callback if existed
            if (self.m_CallbackUpdateFunction ~= nil) then
                self.m_CallbackUpdateFunction(self.m_CurrentValue, self.m_CallbackObject);
            end
		end
	end,
};



--=======================================================================
-- SpeedBasedInterpolatorComponent
--=======================================================================

SpeedBasedInterpolatorComponent = TimeBasedInterpolatorComponent:Instance
{
    --
    -- Fields
    --
	m_Duration = 0,

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
    Create = function(self, t, go)
        -- Create component
        local o = self:Instance
		{
			m_TargetsQueue = {},
			m_CurrentTarget = {},
			m_CurrentValue = t.value or 0,
		};

		-- Add events
        go:AddEvent(EVENT_UPDATE, o);

        return o;
    end,

    --
    -- Events
    --
    ---------------------------------------------------------------
	OnUpdate = function(self)
		if (self.m_Pause or #self.m_TargetsQueue == 0) then
			return;
		end

		if (self.m_OnInterpolating) then
            local deltaTime = g_Timer:GetDeltaTime();
			self.m_CurrentTime = self.m_CurrentTime + deltaTime;

			-- Check if duration is due
			if (self.m_CurrentTime < self.m_Duration) then
				self.m_CurrentValue = self.m_CurrentValue + deltaTime * self.m_DeltaValue;

                if (self.m_CallbackUpdateFunction) then
                    self.m_CallbackUpdateFunction(self.m_CurrentValue, self.m_CallbackObject);
                end
			else
				self:OnInterpolatingEnd();
			end
		else
			self.m_CurrentTarget = self.m_TargetsQueue[1];
			
			local distance = self.m_CurrentTarget[INTER_END] - self.m_CurrentTarget[INTER_BEGIN];
			local speed = self.m_CurrentTarget[INTER_SPEED];
			
			self.m_Duration = 1000 * (distance / speed);
			self.m_DeltaValue = speed * 0.001;

			if (distance < 0) then
				self.m_Duration = -self.m_Duration;
				self.m_DeltaValue = -self.m_DeltaValue;
			end
			
			self.m_CurrentValue = self.m_CurrentTarget[INTER_BEGIN];
			self.m_CurrentTime = 0;
			self.m_OnInterpolating = true;

            -- Proceed update callback if existed
            if (self.m_CallbackUpdateFunction ~= nil) then
                self.m_CallbackUpdateFunction(self.m_CurrentValue, self.m_CallbackObject);
            end
		end
	end,
};



--=======================================================================
-- FadeComponent
--=======================================================================

FADE_BEGIN = 1;
FADE_END = 2;
FADE_DURATION = 3;
FADE_DEFAULT_ALPHA = 255;

FadeComponent =
{
    --
    -- Fields
    --
	m_SpriteGC = nil,
	m_TargetsQueue = nil,
	m_CurrentTarget = nil,
	m_Cycling = false,

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
    Create = function(self, t, go)
		-- Check dependency
        assert(go["Sprite"] or go["PuzzleAnimation"]);

        -- Create component
        local o = self:Instance
		{
			m_SpriteGC = go["Sprite"] or go["PuzzleAnimation"],
			m_TargetsQueue = {},
			m_CurrentTarget = {},
			m_CurrentAlpha = t.alpha or FADE_DEFAULT_ALPHA,
		};
        
        if (t.alpha ~= nil) then
            o:SetAlpha(t.alpha);
        end

		-- Add events
        go:AddEvent(EVENT_UPDATE, o);

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	AppendNextTarget = function(self, beginAlpha, endAlpha, duration)
		table.insert(self.m_TargetsQueue, {	beginAlpha, endAlpha, duration });
	end,
    ---------------------------------------------------------------
	ResetTarget = function(self, beginAlpha, endAlpha, duration)
		self:Reset();
		table.insert(self.m_TargetsQueue, {	beginAlpha, endAlpha, duration });
	end,
    ---------------------------------------------------------------
	Reset = function(self)
        for i = 1, #self.m_TargetsQueue do
            table.remove(self.m_TargetsQueue);
        end
        assert(#self.m_TargetsQueue == 0);

		self.m_OnFading = false;
	end,
    ---------------------------------------------------------------
	IsDone = function(self)
		if ((not self.m_OnFading) and (table.maxn(self.m_TargetsQueue) == 0)) then
			return true;
		end

		return false;
	end,
    ---------------------------------------------------------------
	SetCycling = function(self, cycling)
		self.m_Cycling = cycling;
	end,
    ---------------------------------------------------------------
	SetAlpha = function(self, alpha)
		self.m_CurrentAlpha = alpha;
		self.m_SpriteGC:SetAlpha(alpha);
	end,
    ---------------------------------------------------------------
	GetAlpha = function(self)
		return self.m_CurrentAlpha;
	end,

    --
    -- Events
    --
    ---------------------------------------------------------------
	OnUpdate = function(self)
		if (table.maxn(self.m_TargetsQueue) == 0) then
			return;
		end

		if (self.m_OnFading) then
			self.m_CurrentTime = self.m_CurrentTime + g_Timer:GetDeltaTime();

			-- Check if fading duration is due
			if (self.m_CurrentTime < self.m_CurrentTarget[FADE_DURATION]) then
				self:SetAlpha(self.m_CurrentAlpha + g_Timer:GetDeltaTime() * self.m_DeltaAlpha);
			else
				self:SetAlpha(self.m_CurrentTarget[FADE_END]);

				local obj = table.remove(self.m_TargetsQueue, 1);

				if (self.m_Cycling) then
					table.insert(self.m_TargetsQueue, obj);
				end
				
				self.m_OnFading = false;
			end
		else
			-- Get next target coordinate
			self.m_CurrentTarget = self.m_TargetsQueue[1];

			self:SetAlpha(self.m_CurrentTarget[FADE_BEGIN]);
			self.m_DeltaAlpha = ((self.m_CurrentTarget[FADE_END] - self.m_CurrentAlpha) / self.m_CurrentTarget[FADE_DURATION]);

			self.m_CurrentTime = 0;
			self.m_OnFading = true;
		end
	end,
};



--=======================================================================
-- RectangleBoundComponent
--=======================================================================

BOUND_TYPE_RECTANGLE = 1;
BOUND_TYPE_CIRCLE = 2;

BOUND_RESULT_PICKED = 1;
BOUNT_RESULT_NEARLY = 2;

RectangleBoundComponent =
{
    --
    -- Fields
    --
	m_TransformGC = nil,
	m_SizeX = 0,
	m_SizeY = 0,
    m_Area = 0,
	m_OffsetX = 0,
	m_OffsetY = 0,

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
    Create = function(self, t, go)
		-- Check dependency
		assert(go:CheckDependency(t.class, "Transform"), "Transform GC has not existed.");

        -- Create component
        local o = self:Instance
		{
			m_TransformGC = go["Transform"],
			m_OffsetX = t.offsetX or 0,
			m_OffsetY = t.offsetY or 0,
			m_Debug = t.debug,
		};
--[[ @WorldTransform
        -- Determine if it can do world transform
        if (t.worldTransform == nil) then
            o.IsPicked = o.IsPickedNonTransform;
        else
            o.IsPicked = o.IsPickedWorldTransform;
        end
--]]
		if (go:IsIndieTranslated()) then
			o.IsPicked = o.IsPickedNonTransformIndie;
		else
			o.IsPicked = o.IsPickedNonTransform;
		end

        -- Determine if it is auto-sized
        if (t.autoSize == nil) then
            o:SetSize(t.width or t.size, t.height or t.size);
        else
            local obj;
            if (go["SpriteGroup"]) then
                obj = go["SpriteGroup"]:GetSprite(1);
            else
                obj = go["Sprite"] or go["Shape"];
            end            
            assert(obj, "RectangleBoundComponent auto sizing error");
            o:SetSize(obj:GetSize());
        end

		-- Add events
		if (t.debug) then
			go:AddEvent(EVENT_RENDER, o, t["order"]);
		end

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	GoIndie = function(self)
		self.IsPicked = self.IsPickedNonTransformIndie;
	end,
    ---------------------------------------------------------------
	IsPickedNonTransform = function(self, x, y)
		local ox = self.m_TransformGC:GetTranslateX() + self.m_OffsetX;
		local oy = self.m_TransformGC:GetTranslateY() + self.m_OffsetY;
		ox = ox * APP_UNIT_X;
		oy = oy * APP_UNIT_Y;

		if (x >= ox and x <= ox + self.m_SizeX and
			y >= oy and y <= oy + self.m_SizeY) then
			return true;
		end

		return false;
	end,
    ---------------------------------------------------------------
	IsPickedNonTransformIndie = function(self, x, y)
		local ox = self.m_TransformGC:GetTranslateX() + self.m_OffsetX;
		local oy = self.m_TransformGC:GetTranslateY() + self.m_OffsetY;

		if (x >= ox and x <= ox + self.m_SizeX and
			y >= oy and y <= oy + self.m_SizeY) then
			return true;
		end

		return false;
	end,
--[[	
    ---------------------------------------------------------------	
	IsPickedWorldTransform = function(self, x, y)
		local ox = self.m_TransformGC:GetTranslateX() + self.m_OffsetX + g_AppData:GetData("WorldTranslateX");
		local oy = self.m_TransformGC:GetTranslateY() + self.m_OffsetY + g_AppData:GetData("WorldTranslateY");
		ox = ox * APP_UNIT_X;
		oy = oy * APP_UNIT_Y;

		if (x >= ox and x <= ox + self.m_SizeX and y >= oy and y <= oy + self.m_SizeY) then
			return true;
		end

		return false;
	end,
--]]	
    ---------------------------------------------------------------	
	IsPickedObject = function(self, go)
		local ox = self.m_TransformGC:GetTranslateX() + self.m_OffsetX;
		local oy = self.m_TransformGC:GetTranslateY() + self.m_OffsetY;
        local pickGC = go["Bound"];
		ox = ox * APP_UNIT_X;
		oy = oy * APP_UNIT_Y;

        if (pickGC:GetType() == BOUND_TYPE_CIRCLE) then
        -- Rectangle-Circle collision
            return pickGC:IsCircleRectanglePicked(ox, oy, self.m_SizeX, self.m_SizeY);
        else        
        -- Rectangle-Rectangle collision
            local x, y = go["Transform"]:GetTranslate();
            local width, height = pickGC:GetSize();
			x = x * APP_UNIT_X;
			y = y * APP_UNIT_Y;
            
            if ((ox < x + width) and (ox + self.m_SizeX > x) and (oy < y + height) and (oy + self.m_SizeY > y)) then
                return true;
            end
            
            return false;
        end

		return false;
	end,
    ---------------------------------------------------------------
    IsPickedObjectAbove = function(self, go)
        if (self.m_TransformGC:GetTranslateY() * APP_UNIT_Y + self.m_SizeY + self.m_OffsetY < go["Bound"]:GetRelativeHeight() and
            self:IsPickedObject(go)) then
            return true;
        end

        return false;
    end,
    ---------------------------------------------------------------
    IsAbove = function(self, go)
        if (self.m_TransformGC:GetTranslateY() * APP_UNIT_Y + self.m_SizeY + self.m_OffsetY < go["Bound"]:GetRelativeHeight()) then
            return true;
        end

        return false;
    end,
    ---------------------------------------------------------------
	SetSize = function(self, x, y)
        assert(x);
        assert(y);
        
		self.m_SizeX = x;
		self.m_SizeY = y;
        self.m_Area = x * y;
	end,
    ---------------------------------------------------------------
	GetSize = function(self)
		return self.m_SizeX, self.m_SizeY;
	end,
    ---------------------------------------------------------------
	SetOffset = function(self, x, y)
		self.m_OffsetX = x or 0;
		self.m_OffsetY = y or 0;
	end,
    ---------------------------------------------------------------
	GetOffset = function(self, x, y)
		return self.m_OffsetX, self.m_OffsetY;
	end,
    ---------------------------------------------------------------
	GetCenter = function(self)
        local ox, oy = self.m_TransformGC:GetTranslate();
		return ox + self.m_OffsetX + self.m_SizeX * 0.5, oy + self.m_OffsetY + self.m_SizeY * 0.5;
	end,
    ---------------------------------------------------------------
	GetRadius = function(self)
		return math.max(self.m_SizeX, self.m_SizeY) * 0.5;
	end,
    ---------------------------------------------------------------
	GetArea = function(self)
		return self.m_Area;
	end,
    ---------------------------------------------------------------
    GetRelativeHeight = function(self)
        return self.m_TransformGC:GetTranslateY() + self.m_SizeY + self.m_OffsetY;
    end,
    ---------------------------------------------------------------
    GetType = function(self)
        return BOUND_TYPE_RECTANGLE;
    end,
	
    --
    -- Events
    --
    ---------------------------------------------------------------
    OnRender = function(self)
		if (self.m_Debug or g_AppData:GetData("GOShowPick")) then
			local x = (self.m_TransformGC:GetTranslateX() + self.m_OffsetX) * APP_UNIT_X;
			local y = (self.m_TransformGC:GetTranslateY() + self.m_OffsetY) * APP_UNIT_Y;
			DrawRectangle(x, y, self.m_SizeX, self.m_SizeY, COLOR_PINK[1], COLOR_PINK[2], COLOR_PINK[3], ALPHA_HALF);
		end
	end,
};



--=======================================================================
-- CircleBoundComponent
--=======================================================================

CircleBoundComponent =
{
    --
    -- Fields
    --
    m_GameObject = nil,
	m_TransformGC = nil,
	m_Radius = 0,
    m_Size = 0,
	m_OffsetX = 0,
	m_OffsetY = 0,

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
    Create = function(self, t, go)
		-- Check dependency
		assert(go:CheckDependency(t.class, "Transform"), "Transform GC has not existed.");

        -- Create component
        local o = self:Instance
		{
            m_GameObject = go,
			m_TransformGC = go["Transform"],
			m_Debug = t.debug,
		};
--[[ @WorldTransform
        -- Determine if it can do world transform
        if (t.worldTransform == nil) then
            o.IsPicked = o.IsPickedNonTransform;
        else
            o.IsPicked = o.IsPickedWorldTransform;
        end
--]]		
        o.IsPicked = o.IsPickedNonTransform;
		
		-- Determine if it is indie (non-transform)
		if (t.indie) then
			o.IsPickedObject = o.IsPickedObjectIndie;
			o.OnRender = o.OnRenderIndie;
		else
			o.IsPickedObject = o.IsPickedObjectNormal;
			o.OnRender = o.OnRenderNormal;
		end
        
        -- Determine if it is auto-sized
        if (t.autoSize == nil) then
			o:SetRadius(t.radius);
        else
            local obj;
            if (go["SpriteGroup"]) then
                obj = go["SpriteGroup"]:GetSprite(1);
            else
                obj = go["Sprite"] or go["Shape"];
            end            
            assert(obj, "RectangleBoundComponent auto sizing error");
            o:SetSize(obj:GetSize());
        end
		
		-- Add events (only do rendering in Debug mode)
		if (t.debug) then
			go:AddEvent(EVENT_RENDER, o, t["order"]);
		end

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	IsPickedNonTransform = function(self, x, y)
		local ox = self.m_TransformGC:GetTranslateX() + self.m_CenterX + self.m_OffsetX;
		local oy = self.m_TransformGC:GetTranslateY() + self.m_CenterY + self.m_OffsetY;
		ox = ox * APP_UNIT_X;
		oy = oy * APP_UNIT_Y;

		if (Square(ox - x, oy - y) <= self.m_Radius * self.m_Radius) then
			return true;
		end

		return false;
	end,
    ---------------------------------------------------------------
	IsPickedNonTransformIndie = function(self, x, y)
		local ox = self.m_TransformGC:GetTranslateX() + self.m_CenterX + self.m_OffsetX;
		local oy = self.m_TransformGC:GetTranslateY() + self.m_CenterY + self.m_OffsetY;

		if (Square(ox - x, oy - y) <= self.m_Radius * self.m_Radius) then
			return true;
		end

		return false;
	end,
--[[	
    ---------------------------------------------------------------	
	IsPickedWorldTransform = function(self, x, y)
		local ox = self.m_TransformGC:GetTranslateX() + self.m_CenterX + self.m_OffsetX + g_AppData:GetData("WorldTranslateX");
		local oy = self.m_TransformGC:GetTranslateY() + self.m_CenterY + self.m_OffsetY + g_AppData:GetData("WorldTranslateY");
		ox = ox * APP_UNIT_X;
		oy = oy * APP_UNIT_Y;

		if (Square(ox - x, oy - y) <= self.m_Radius * self.m_Radius) then
			return true;
		end

		return false;
    end,
--]]	
    ---------------------------------------------------------------
	IsPickedObjectNormal = function(self, go)
		local pickGC = go["Bound"];
        
        if (pickGC:GetType() == BOUND_TYPE_CIRCLE) then
        -- Circle-Circle collision
			local ox = self.m_TransformGC:GetTranslateX() + self.m_CenterX + self.m_OffsetX;
			local oy = self.m_TransformGC:GetTranslateY() + self.m_CenterY + self.m_OffsetY;
            local x, y = pickGC:GetCenter();
			ox = ox * APP_UNIT_X;
			oy = oy * APP_UNIT_Y;
			x = x * APP_UNIT_X;
			y = y * APP_UNIT_Y;

            if (Square(ox  - x, oy - y) < Square(self.m_Radius + pickGC:GetRadius())) then
                return true;
            end
        else
        -- Circle-Rectangle collision
            local x, y = go["Transform"]:GetTranslate();
            local width, height = pickGC:GetSize();
			x = x * APP_UNIT_X;
			y = y * APP_UNIT_Y;
            return self:IsCircleRectanglePicked(x, y, width, height);
        end

		return false;
	end,
    ---------------------------------------------------------------
	IsPickedObjectIndie = function(self, go)
		local pickGC = go["Bound"];
        
        if (pickGC:GetType() == BOUND_TYPE_CIRCLE) then
        -- Circle-Circle collision
            local x, y = pickGC:GetCenter();
			x = x * APP_UNIT_X;
			y = y * APP_UNIT_Y;
            if (Square(self.m_CenterX + self.m_OffsetX - x, self.m_CenterY + self.m_OffsetY - y) < Square(self.m_Radius + pickGC:GetRadius())) then
                return true;
            end
        else
        -- Circle-Rectangle collision
			assert(false);
        end

		return false;
	end,
    ---------------------------------------------------------------
	IsNearlyPickedObject = function(self, go, threshold)
		local pickGC = go["Bound"];
        
        if (pickGC:GetType() == BOUND_TYPE_CIRCLE) then
        -- Circle-Circle collision
            local x, y = pickGC:GetCenter();
			x = x * APP_UNIT_X;
			y = y * APP_UNIT_Y;
			local centerDist = Square(self.m_CenterX + self.m_OffsetX - x, self.m_CenterY + self.m_OffsetY - y);
			local radiusDist = Square(self.m_Radius + pickGC:GetRadius());
			
            if (centerDist < radiusDist) then
				return BOUND_RESULT_PICKED;
            elseif (centerDist < radiusDist + threshold) then
				return BOUNT_RESULT_NEARLY;
            end
        else
        -- Circle-Rectangle collision
			assert(false);
        end

		return false;
	end,
    ---------------------------------------------------------------
    IsCircleRectanglePicked = function(self, rectX, rectY, sizeX, sizeY)
        local centerX = self.m_TransformGC:GetTranslateX() + self.m_CenterX + self.m_OffsetX;
        local centerY = self.m_TransformGC:GetTranslateY() + self.m_CenterY + self.m_OffsetY;
		centerX = centerX * APP_UNIT_X;
		centerY = centerY * APP_UNIT_Y;
		
        local closestX = centerX;
        local closestY = centerY;
        
        if (closestX < rectX) then
            closestX = rectX;
        elseif (closestX > rectX + sizeX) then
            closestX = rectX + sizeX;
        end
        
        if (closestY < rectY) then
            closestY = rectY;
        elseif (closestY > rectY + sizeY) then
            closestY = rectY + sizeY;
        end
        
        return (Square(centerX - closestX) + Square(centerY - closestY) < Square(self.m_Radius));
    end,
    ---------------------------------------------------------------
    IsPickedObjectAbove = function(self, go)
        if (self.m_TransformGC:GetTranslateY() * APP_UNIT_Y + self.m_Size + self.m_OffsetY < go["Bound"]:GetRelativeHeight() and
            self:IsPickedObject(go)) then
            return true;
        end

        return false;
    end,
    ---------------------------------------------------------------
    IsAbove = function(self, go)
        if (self.m_TransformGC:GetTranslateY() * APP_UNIT_Y + self.m_Size + self.m_OffsetY < go["Bound"]:GetRelativeHeight()) then
            return true;
        end

        return false;
    end,
    ---------------------------------------------------------------
    SetRadius = function(self, radius)
        assert(radius);

        self.m_Radius = radius;
        self.m_Size = radius * 2;
		self:SetCenter(radius, radius);
    end,
    ---------------------------------------------------------------
	GetRadius = function(self)
		return self.m_Radius;
	end,
    ---------------------------------------------------------------
    SetSize = function(self, width, height)
        assert(width);
        assert(height);
        
        self.m_Radius = math.max(width, height) * 0.5;
        self.m_Size = self.m_Radius * 2;
		self:SetCenter(self.m_Radius, self.m_Radius);
    end,
    ---------------------------------------------------------------
    GetSize = function(self)
        return self.m_Size, self.m_Size;
    end,
    ---------------------------------------------------------------
	SetCenter = function(self, x, y)
		self.m_CenterX = x;
		self.m_CenterY = y;
	end,
    ---------------------------------------------------------------
	GetCenter = function(self)
        local ox, oy = self.m_TransformGC:GetTranslate();
		return ox + self.m_CenterX + self.m_OffsetX, oy + self.m_CenterY + self.m_OffsetY;
	end,
    ---------------------------------------------------------------
	SetOffset = function(self, x, y)
		self.m_OffsetX = x or 0;
		self.m_OffsetY = y or 0;
	end,
    ---------------------------------------------------------------
	GetOffset = function(self, x, y)
		return self.m_OffsetX, self.m_OffsetY;
	end,
    ---------------------------------------------------------------
    GetArea = function(self)
        return self.m_Size * self.m_Size;
    end,
    ---------------------------------------------------------------
    GetRelativeHeight = function(self)
        return self.m_TransformGC:GetTranslateY() + self.m_Size;
    end,
    ---------------------------------------------------------------
    GetType = function(self)
        return BOUND_TYPE_CIRCLE;
    end,
	
    --
    -- Events
    --
    ---------------------------------------------------------------
    OnRenderNormal = function(self)
		if (self.m_Debug or g_AppData:GetData("GOShowPick")) then
	        local x = self.m_TransformGC:GetTranslateX() + self.m_CenterX + self.m_OffsetX;
			local y = self.m_TransformGC:GetTranslateY() + self.m_CenterY + self.m_OffsetY;
			DrawCircle(x, y, self.m_Radius, COLOR_ORANGE[1], COLOR_ORANGE[2], COLOR_ORANGE[3], ALPHA_QUARTER);
		end
	end,
    ---------------------------------------------------------------
    OnRenderIndie = function(self)
		if (self.m_Debug or g_AppData:GetData("GOShowPick")) then
	        local x = self.m_TransformGC:GetTranslateX() + self.m_CenterX + self.m_OffsetX;
			local y = self.m_TransformGC:GetTranslateY() + self.m_CenterY + self.m_OffsetY;
			DrawIndieCircle(x, y, self.m_Radius, COLOR_ORANGE[1], COLOR_ORANGE[2], COLOR_ORANGE[3], ALPHA_QUARTER);
		end
	end,
};



--=======================================================================
-- RectangleShapeComponent
--=======================================================================

RectangleShapeComponent =
{
    --
    -- Fields
    --
	m_TransformGC = nil,
	m_Width = 0,
	m_Height = 0,
	m_ColorR = 0,
	m_ColorG = 0,
	m_ColorB = 0,
	m_Alpha = 0,

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
    Create = function(self, t, go)
		-- Check dependency
		assert(go:CheckDependency(t.class, "Transform"), "Transform GC has not existed.");
        assert(t.width);
        assert(t.height);
        assert(t.color);

        -- Create component
        local o = self:Instance
		{
			m_TransformGC = go["Transform"],
			m_Width = t.width,
			m_Height = t.height,
			m_ColorR = t.color[1],
			m_ColorG = t.color[2],
			m_ColorB = t.color[3],
			m_Alpha = t.color[4] or 255,
			m_OffsetX = t.offsetX or 0,
			m_OffsetY = t.offsetY or 0,
		};

		-- Add events
        go:AddEvent(EVENT_RENDER, o, t["order"]);

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	SetSize = function(self, width, height)
		self.m_Width = width;
		self.m_Height = height;
	end,
    ---------------------------------------------------------------
    GetSize = function(self)
        return self.m_Width, self.m_Height;
    end,
    ---------------------------------------------------------------
	SetColor = function(self, r, g, b, a)
		self.m_ColorR = r or 0;
		self.m_ColorG = g or 0;
		self.m_ColorB = b or 0;
		self.m_Alpha = a or 255;
	end,
    ---------------------------------------------------------------
	GetColor = function(self)
		return self.m_ColorR, self.m_ColorG, self.m_ColorB, self.m_Alpha;
	end,
    ---------------------------------------------------------------
    SetAlpha = function(self, alpha)
        self.m_Alpha = alpha;
    end,
    ---------------------------------------------------------------
	SetOffset = function(self, x, y)
		self.m_OffsetX = x or 0;
		self.m_OffsetY = y or 0;
	end,

    --
    -- Events
    --
    ---------------------------------------------------------------
    OnRender = function(self)
        local x, y = self.m_TransformGC:GetTranslate();
		x = x + self.m_OffsetX;
		y = y + self.m_OffsetY;
        DrawRectangle(x, y, self.m_Width, self.m_Height, self.m_ColorR, self.m_ColorG, self.m_ColorB, self.m_Alpha);
	end,
    ---------------------------------------------------------------
    OnRenderOffset = function(self, x, y)
        local ox = self.m_TransformGC:GetTranslateX() + x;
        local oy = self.m_TransformGC:GetTranslateY() + y;
        DrawRectangle(ox, oy, self.m_Width, self.m_Height, self.m_ColorR, self.m_ColorG, self.m_ColorB, self.m_Alpha);
	end,
};



--=======================================================================
-- CircleShapeComponent
--=======================================================================

CircleShapeComponent =
{
    --
    -- Fields
    --
	m_TransformGC = nil,
	m_Radius = 0,
	m_ColorR = 0,
	m_ColorG = 0,
	m_ColorB = 0,
	m_Alpha = 0,

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
    Create = function(self, t, go)
		-- Check dependency
		assert(go:CheckDependency(t.class, "Transform"), "Transform GC has not existed.");
        assert(t.radius);
        assert(t.color);

        -- Create component
        local o = self:Instance
		{
			m_TransformGC = go["Transform"],
			m_Radius = t.radius,
			m_ColorR = t.color[1],
			m_ColorG = t.color[2],
			m_ColorB = t.color[3],
			m_Alpha = t.color[4] or 255,
		};

		-- Add events
        go:AddEvent(EVENT_RENDER, o, t["order"]);

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	SetRadius = function(self, radius)
		self.m_Radius = radius;
	end,
    ---------------------------------------------------------------
    GetRadius = function(self)
        return self.m_Radius;
    end,
    ---------------------------------------------------------------
	SetColor = function(self, r, g, b, a)
		self.m_ColorR = r or 0;
		self.m_ColorG = g or 0;
		self.m_ColorB = b or 0;
		self.m_Alpha = a or 255;
	end,
    ---------------------------------------------------------------
	GetColor = function(self)
		return self.m_ColorR, self.m_ColorG, self.m_ColorB, self.m_Alpha;
	end,
    ---------------------------------------------------------------
    SetAlpha = function(self, alpha)
        self.m_Alpha = alpha;
    end,

    --
    -- Events
    --
    ---------------------------------------------------------------
    OnRender = function(self)
        local x, y = self.m_TransformGC:GetTranslate();
        DrawCircle(x, y, self.m_Radius, self.m_ColorR, self.m_ColorG, self.m_ColorB, self.m_Alpha);
	end,
    ---------------------------------------------------------------
    OnRenderOffset = function(self, x, y)
        local ox = self.m_TransformGC:GetTranslateX() + x;
        local oy = self.m_TransformGC:GetTranslateY() + y;
        DrawCircle(ox, oy, self.m_Radius, self.m_ColorR, self.m_ColorG, self.m_ColorB, self.m_Alpha);
	end,
};



--=======================================================================
-- CompositeShapeComponent
--=======================================================================

COMPOSITESHAPE_RECT = 1;
COMPOSITESHAPE_CIRCLE = 2;

CompositeShapeComponent =
{
    --
    -- Fields
    --
	m_TransformGC = nil,

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
    Create = function(self, t, go)
		-- Check dependency
		assert(go:CheckDependency(t.class, "Transform"), "Transform GC has not existed.");
        assert(t.shapes);

        -- Create component
        local o = self:Instance
		{
			m_TransformGC = go["Transform"],
            m_Shapes = {},
		};
        
        for index, shape in ipairs(t.shapes) do
            o.m_Shapes[index] = {};
            
            for k, v in ipairs(shape) do
                o.m_Shapes[index][k] = v;
            end
        end
		
		if (t.indie) then
			o.OnRender = o.OnRenderIndie;
		end

		-- Add events
        go:AddEvent(EVENT_RENDER, o, t["order"]);

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	SetSize = function(self, index, width, height)
        index = index or 1;
		self.m_Shapes[index][2] = width;
		self.m_Shapes[index][3] = height;
	end,
    ---------------------------------------------------------------
    GetSize = function(self, index)
        index = index or 1;
        return self.m_Shapes[index][2], self.m_Shapes[index][3];
    end,
    ---------------------------------------------------------------
	SetColor = function(self, index, r, g, b, alpha)
        index = index or 1;
        self.m_Shapes[index][4] = r or 0;
        self.m_Shapes[index][5] = g or 0;
        self.m_Shapes[index][6] = b or 0;
        self.m_Shapes[index][7] = alpha or 255;
	end,
    ---------------------------------------------------------------
	GetColor = function(self, index)
        index = index or 1;
		return self.m_Shapes[index][4], self.m_Shapes[index][5], self.m_Shapes[index][6], self.m_Shapes[index][7];
	end,
    ---------------------------------------------------------------
    SetAlpha = function(self, index, alpha)
        index = index or 1;
        self.m_Shapes[index][7] = alpha;
    end,
    ---------------------------------------------------------------
	SetOffset = function(self, index, x, y)
        index = index or 1;
		self.m_Shapes[index][8] = x;
		self.m_Shapes[index][9] = y;
	end,
    ---------------------------------------------------------------
    EnableRender = function(self, index, enable)
        index = index or 1;
        self.m_Shapes[index][10] = enable;
    end,
    ---------------------------------------------------------------
    EnableRenderAll = function(self, enable)
        for _, shape in ipairs(self.m_Shapes) do
			shape[10] = enable;
		end
    end,

    --
    -- Events
    --
    ---------------------------------------------------------------
    OnRender = function(self)
        local x, y = self.m_TransformGC:GetTranslate();
        
        for _, shape in ipairs(self.m_Shapes) do
            if (shape[10]) then
                if (shape[1] == COMPOSITESHAPE_RECT) then
                    DrawRectangle(x + shape[8], y + shape[9], shape[2], shape[3], shape[4], shape[5], shape[6], shape[7]);
                else  -- COMPOSITESHAPE_CIRCLE
                    DrawCircle(x + shape[8], y + shape[9], shape[2], shape[4], shape[5], shape[6], shape[7]);
                end
            end
        end
	end,
    ---------------------------------------------------------------
	OnRenderIndie = function(self)
        local x, y = self.m_TransformGC:GetTranslate();
		x = x * APP_UNIT_X;
		y = y * APP_UNIT_Y;
        
        for _, shape in ipairs(self.m_Shapes) do
            if (shape[10]) then
                if (shape[1] == COMPOSITESHAPE_RECT) then
                    DrawIndieRectangle(x + shape[8], y + shape[9], shape[2], shape[3], shape[4], shape[5], shape[6], shape[7]);
                else  -- COMPOSITESHAPE_CIRCLE
                    DrawIndieCircle(x + shape[8], y + shape[9], shape[2], shape[4], shape[5], shape[6], shape[7]);
                end
            end
        end
	end,
};



--=======================================================================
-- TimerComponent
--=======================================================================

TimerComponent =
{
    --
    -- Fields
    --

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
    Create = function(self, t, go)
        -- Create component
        local o = self:Instance
		{
            m_ElapsedTime = 0,
            m_Duration = t.duration,
            m_Enabled = not t.disabled,
		};

		-- Add events
        go:AddEvent(EVENT_UPDATE, o);

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
    Reset = function(self, duration)
        if (duration ~= nil) then
            self.m_Duration = duration;
        end
        
        self.m_ElapsedTime = 0;
    end,
    ---------------------------------------------------------------
    ResetRandRange = function(self, min, max)
        if (min ~= nil and max ~= nil) then
            self.m_MinDuration = min;
            self.m_MaxDuration = max;
        end
        
        self.m_Duration = math.random(self.m_MinDuration, self.m_MaxDuration);
        self.m_ElapsedTime = 0;
    end,
    ---------------------------------------------------------------
    IsOver = function(self)
        assert(self.m_Duration, "Timer component has no duration");

        if (self.m_ElapsedTime >= self.m_Duration) then
            return true;
        end
        
        return false;
    end,
    ---------------------------------------------------------------
    SetDuration = function(self, duration)
        assert(duration);
        self.m_Duration = duration;
    end,
    ---------------------------------------------------------------
    GetDuration = function(self)
		return self.m_Duration;
    end,
    ---------------------------------------------------------------
    SetElapsedTime = function(self, time)
        self.m_ElapsedTime = time;
    end,
    ---------------------------------------------------------------
    GetElapsedTime = function(self)
        return self.m_ElapsedTime;
    end,
    ---------------------------------------------------------------
    ToggleUpdate = function(self)
        self.m_Enabled = not self.m_Enabled;
    end,
    ---------------------------------------------------------------
    EnableUpdate = function(self, enabled)
        self.m_Enabled = enabled;
    end,

    --
    -- Events
    --
    ---------------------------------------------------------------
	OnUpdate = function(self)
        if (self.m_Enabled) then
            self.m_ElapsedTime = self.m_ElapsedTime + g_Timer:GetDeltaTime();
        end
    end,
};



--=======================================================================
-- VelocityComponent
--=======================================================================

VELOCITY_DIR_WEST = 1;
VELOCITY_DIR_EAST = 2;
VELOCITY_DIR_SOUTH = 3;
VELOCITY_DIR_NORTH = 4;

VelocityComponent =
{
    --
    -- Fields
    --
    m_HorizontalFunction = nil,
    m_VerticalFunction = nil,

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
    Create = function(self, t, go)
		-- Check dependency
		assert(go:CheckDependency(t.class, "Transform"), "Transform GC has not existed.");

        -- Create component
        local o = self:Instance
		{
			m_GameObject = go,
            m_UpdateEnabled = true,
            m_PreviousPos = { 0, 0 },
            m_Velocity = { 0, 0 },
            m_Direction = t.direction or { VELOCITY_DIR_WEST, VELOCITY_DIR_SOUTH },
		};

		-- Add events
        go:AddEvent(EVENT_UPDATE, o);

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
    Reset = function(self, hDir, vDir)
        self.m_Direction[1] = hDir or self.m_Direction[1];
        self.m_Direction[2] = vDir or self.m_Direction[2];
        self.m_PreviousPos[1], self.m_PreviousPos[2] = self.m_GameObject["Transform"]:GetTranslate();
    end,
    ---------------------------------------------------------------
    AttachCallback = function(self, hFunc, vFunc)
        self.m_HorizontalFunction = hFunc;
        self.m_VerticalFunction = vFunc;
    end,
    ---------------------------------------------------------------
    SetVelocity = function(self, hVel, vVel)
        self.m_Velocity[1] = hVel;
        self.m_Velocity[2] = vVel;

        local hDir, vDir;
        if (hVel < 0) then
            hDir = VELOCITY_DIR_WEST;
        elseif (hVel > 0) then
            hDir = VELOCITY_DIR_EAST;
        else
            hDir = self.m_Direction[1];
        end
        
        if (vVel > 0) then
            vDir = VELOCITY_DIR_SOUTH;
        elseif (vVel < 0) then
            vDir = VELOCITY_DIR_NORTH;
        else
            vDir = self.m_Direction[2];
        end
        
        if (self.m_Direction[1] ~= hDir) then
            self.m_Direction[1] = hDir;
            
            if (self.m_HorizontalFunction) then
                self.m_HorizontalFunction(self.m_GameObject, hDir);
            end
        end

        if (self.m_Direction[2] ~= vDir) then
            self.m_Direction[2] = vDir;

            if (self.m_VerticalFunction) then
                self.m_VerticalFunction(self.m_GameObject, vDir);
            end
        end
    end,
    ---------------------------------------------------------------
    GetVelocity = function(self)
        return self.m_Velocity[1], self.m_Velocity[2];
    end,
    ---------------------------------------------------------------
    SetDirection = function(self, hDir, vDir)
        if (hDir and self.m_Direction[1] ~= hDir) then
            self.m_Direction[1] = hDir;
            
            if (self.m_HorizontalFunction) then
                self.m_HorizontalFunction(self.m_GameObject, hDir);
            end
        end

        if (vDir and self.m_Direction[2] ~= vDir) then
            self.m_Direction[2] = vDir;

            if (self.m_VerticalFunction) then
                self.m_VerticalFunction(self.m_GameObject, vDir);
            end
        end
    end,
    ---------------------------------------------------------------
    GetDirection = function(self)
        return self.m_Direction[1], self.m_Direction[2];
    end,
    ---------------------------------------------------------------
    GetDirH = function(self)
        return self.m_Direction[1];
    end,
    ---------------------------------------------------------------
    GetDirV = function(self)
        return self.m_Direction[2];
    end,
    ---------------------------------------------------------------
    EnableUpdate = function(self, enable)
        self.m_UpdateEnabled = enable;
    end,

    --
    -- Events
    --
    ---------------------------------------------------------------
    OnUpdate = function(self)
        if (not self.m_UpdateEnabled) then
            return;
        end
        
        local ox, oy = self.m_GameObject["Transform"]:GetTranslate();
        self:SetVelocity(ox - self.m_PreviousPos[1], oy - self.m_PreviousPos[2]);
        
        self.m_PreviousPos[1] = ox;
        self.m_PreviousPos[2] = oy;
    end,
};



--=======================================================================
-- AttributeComponent
--=======================================================================

AttributeComponent =
{
    --
    -- Fields
    --

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
    Create = function(self, t, go)
		-- Check dependency

        -- Create component
        local o = self:Instance
		{
            m_AttributePool = {},
		};

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
    Set = function(self, key, value)
        self.m_AttributePool[key] = value;
    end,
    ---------------------------------------------------------------
    Get = function(self, key)
        return self.m_AttributePool[key];
    end,
    ---------------------------------------------------------------
    Modify = function(self, key, value)
        assert(self.m_AttributePool[key], "Key is not set: "..key);
        self.m_AttributePool[key] = self.m_AttributePool[key] + value;
        return self.m_AttributePool[key];
    end,
    ---------------------------------------------------------------
    ModifyInRange = function(self, key, value, min, max)    
        assert(self.m_AttributePool[key]);
		self.m_AttributePool[key] = self.m_AttributePool[key] + value;
		
        if (self.m_AttributePool[key] < min) then
            self.m_AttributePool[key] = min;
        elseif (self.m_AttributePool[key] > max) then
            self.m_AttributePool[key] = max;
        end
	end,
	---------------------------------------------------------------
    Clear = function(self, key)
        self.m_AttributePool[key] = nil;
    end,
    ---------------------------------------------------------------
    Reset = function(self)
        for key, _ in pairs(self.m_AttributePool) do
            self.m_AttributePool[key] = nil;
        end
    end,
    ---------------------------------------------------------------
    IsNil = function(self, key)
        return (self.m_AttributePool[key] == nil);
    end,
};



--=======================================================================
-- ShakerComponent
--=======================================================================

ShakerComponent =
{
    --
    -- Fields
    --
	m_ShakeCount = 0,
	m_ObjectsList = nil,

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
    Create = function(self, t, go)
		-- Check dependency
		assert(go:CheckDependency(t.class, "Transform"), "Transform GC has not existed.");

        -- Create component
        local o = self:Instance
		{
			m_GameObject = go,
			m_TransformGC = go["Transform"],
			m_TargetsQueue = {},
			m_CurrentTarget = {},
			m_MovePixel = {},
			m_Velocity = (t.velocity or MOTION_DEFAULT_VELOCITY) * MOTION_VELOCITY_FACTOR,
			m_ShakeCount = t.count,
			m_ObjectsList = {},
		};

		o:BuildShake(t.minValue, t.maxValue);

		-- Add events
        go:AddEvent(EVENT_UPDATE, o);

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	Reset = function(self)
        for i = 1, #self.m_TargetsQueue do
            table.remove(self.m_TargetsQueue);
        end

        for i = 1, #self.m_ObjectsList do
            table.remove(self.m_ObjectsList);
        end
        
		self.m_OnMotion = false;
	end,
    ---------------------------------------------------------------
	AddObject = function(self, obj)
		assert(obj["Transform"]);
		local x, y = obj["Transform"]:GetTranslate();
		table.insert(self.m_ObjectsList, { obj, x, y });
	end,
    ---------------------------------------------------------------
	AddGroupObjects = function(self, objList)
		assert(type(objList) == "table");
		for _, obj in ipairs(objList) do
			assert(obj["Transform"]);
			local x, y = obj["Transform"]:GetTranslate();
			table.insert(self.m_ObjectsList, { obj, x, y });
		end
	end,
    ---------------------------------------------------------------
	UpdateObjectsPosition = function(self, x, y)
		for _, objSet in ipairs(self.m_ObjectsList) do
			objSet[1]["Transform"]:SetTranslate(objSet[2] + x, objSet[3] + y);
		end
	end,
    ---------------------------------------------------------------
	BuildShake = function(self, minValue, maxValue)
		self.m_RandDeck = RandDeck{
			{ math.random(minValue, maxValue), math.random(minValue, maxValue) },
			{ math.random(minValue, maxValue), -math.random(minValue, maxValue) },
			{ -math.random(minValue, maxValue), math.random(minValue, maxValue) },
			{ -math.random(minValue, maxValue), -math.random(minValue, maxValue) }
		};
	end,
    ---------------------------------------------------------------
	AppendNextTarget = function(self, x, y)
		table.insert(self.m_TargetsQueue, { x, y });
	end,
    ---------------------------------------------------------------
	Shake = function(self)
		if (self.m_OnMotion) then
			for _, objSet in ipairs(self.m_ObjectsList) do
				objSet[1]["Transform"]:SetTranslate(objSet[2], objSet[3]);
			end
		end

        for i = 1, #self.m_TargetsQueue do
            table.remove(self.m_TargetsQueue);
        end
        
		local x, y = self.m_TransformGC:GetTranslate();
		for i = 1, self.m_ShakeCount do
			local positionSet = self.m_RandDeck();
			self:AppendNextTarget(x + positionSet[1], y + positionSet[2]);
		end		
		self:AppendNextTarget(x, y);

		self.m_OnMotion = false;
	end,
    ---------------------------------------------------------------
	IsDone = function(self)
		if ((not self.m_OnMotion) and (table.maxn(self.m_TargetsQueue) == 0)) then
			return true;
		end

		return false;
	end,
	
    --
    -- Events
    --
    ---------------------------------------------------------------
	OnUpdate = function(self)
		if (self.m_Pause or #self.m_TargetsQueue == 0) then
			return;
		end

		if (self.m_OnMotion) then
            local deltaTime = g_Timer:GetDeltaTime();
            self.m_CurrentTime = self.m_CurrentTime + deltaTime;

			if (self.m_CurrentTime < self.m_Duration) then
                self.m_TransformGC:ModifyTranslate(self.m_MovePixel[1] * deltaTime, self.m_MovePixel[2] * deltaTime);
                
				self:UpdateObjectsPosition(self.m_TransformGC:GetTranslate());
            else
                self.m_TransformGC:SetTranslate(self.m_CurrentTarget[1], self.m_CurrentTarget[2]);
                
                table.remove(self.m_TargetsQueue, 1);
                self.m_OnMotion = false;
				
				if (#self.m_TargetsQueue == 0) then
					self:UpdateObjectsPosition(0, 0);
				end
            end
		else
			self.m_CurrentTarget = self.m_TargetsQueue[1];

            local x, y = self.m_TransformGC:GetTranslate();
			self.m_MovePixel[1] = self.m_CurrentTarget[1] - x;
			self.m_MovePixel[2] = self.m_CurrentTarget[2] - y;
            
            if (math.abs(self.m_MovePixel[1]) >= math.abs(self.m_MovePixel[2])) then
                self.m_Duration = math.abs(self.m_MovePixel[1] / self.m_Velocity);
            else
                self.m_Duration = math.abs(self.m_MovePixel[2] / self.m_Velocity);
            end
            
            self.m_MovePixel[1] = self.m_MovePixel[1] / self.m_Duration;
            self.m_MovePixel[2] = self.m_MovePixel[2] / self.m_Duration;

            self.m_CurrentTime = 0;
			self.m_OnMotion = true;
		end
	end,
};

--[[
--=======================================================================
-- RadioComponent
--=======================================================================

RadioComponent =
{
    --
    -- Fields
    --
	m_CurrentTrack = nil,
	m_CurrentTrackNum = 0,
	m_PlayList = nil,
	m_PlayedTrack = nil,
	m_PlayDone = nil,
	m_Looping = nil,
	m_RandTrack = nil,

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
    Create = function(self, t, go)
		-- Create C objects
		local list = {};
		for index, file in pairs(t.track) do
			list[index] = g_AudioEngine:CreateAudio(file);
		end

        -- Create component
        local o = self:Instance
		{
			m_PlayList = list,
			m_Looping = t.loop,
			m_RandTrack = t.rand,
		};

		-- Add events
        go:AddEvent(EVENT_UPDATE, o);

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	Play = function(self, trackNum)
		self.m_CurrentTrackNum = trackNum or 1;

		if (self.m_CurrentTrackNum <= table.maxn(self.m_PlayList)) then
			self.m_CurrentTrack = self.m_PlayList[self.m_CurrentTrackNum];
			self.m_CurrentTrack:Play();
		end
	end,
    ---------------------------------------------------------------
	Stop = function(self)
		if (self.m_CurrentTrack ~= nil) then
			self.m_CurrentTrack:Stop();
			self.m_CurrentTrack = nil;
			self.m_CurrentTrackNum = 0;
		end
	end,

    --
    -- Events
    --
    ---------------------------------------------------------------
	OnUpdate = function(self)
		-- Do not update if there's no track or all done or now playing
		if ((self.m_CurrentTrack == nil) or
			(self.m_PlayDone) or
			(self.m_CurrentTrack:IsPlaying())) then
			return;
		end

		if (self.m_RandTrack) then
			if (self.m_Looping) then
			-- Do rand, do looping
				self.m_CurrentTrackNum = math.random(1, table.maxn(self.m_PlayList));
			else
			-- Do rand, no looping
				-- NOTE: not implemented!
			end
		else
			if (self.m_Looping) then
			-- No rand, do looping
				self.m_CurrentTrackNum = self.m_CurrentTrackNum + 1;

				if (self.m_CurrentTrackNum > table.maxn(self.m_PlayList)) then
					self.m_CurrentTrackNum = 1;
				end
			else
			-- No rand, no looping
				self.m_CurrentTrackNum = self.m_CurrentTrackNum + 1;

				if (self.m_CurrentTrackNum > table.maxn(self.m_PlayList)) then
					self.m_PlayDone = true;
					return;
				end
			end
		end

		-- Play the new track
		self:Play(self.m_CurrentTrackNum);
	end,
};
--]]



--[[
--=======================================================================
-- XXXComponent
--=======================================================================

XXXComponent =
{
    --
    -- Fields
    --

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
    Create = function(self, t, go)
		-- Check dependency

        -- Create component
        local o = self:Instance
		{
		};

		-- Add events

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------

    --
    -- Events
    --
    ---------------------------------------------------------------

};
--]]



--=======================================================================
-- Register game component templates
--=======================================================================

ObjectFactory:AddGameComponentTemplate(TransformComponent, "Transform");
ObjectFactory:AddGameComponentTemplate(LinearMotionComponent, "LinearMotion", "Motion");
ObjectFactory:AddGameComponentTemplate(TimeBasedInterpolatorComponent, "TimeBasedInterpolator", "Interpolator");
ObjectFactory:AddGameComponentTemplate(SpeedBasedInterpolatorComponent, "SpeedBasedInterpolator", "Interpolator");
ObjectFactory:AddGameComponentTemplate(FadeComponent, "Fade");
ObjectFactory:AddGameComponentTemplate(RectangleBoundComponent, "RectangleBound", "Bound");
ObjectFactory:AddGameComponentTemplate(CircleBoundComponent, "CircleBound", "Bound");
ObjectFactory:AddGameComponentTemplate(RectangleShapeComponent, "RectangleShape", "Shape");
ObjectFactory:AddGameComponentTemplate(CircleShapeComponent, "CircleShape", "Shape");
ObjectFactory:AddGameComponentTemplate(CompositeShapeComponent, "CompositeShape", "Shape");
ObjectFactory:AddGameComponentTemplate(TimerComponent, "Timer");
ObjectFactory:AddGameComponentTemplate(VelocityComponent, "Velocity");
ObjectFactory:AddGameComponentTemplate(AttributeComponent, "Attribute");
ObjectFactory:AddGameComponentTemplate(ShakerComponent, "Shaker");
--ObjectFactory:AddGameComponentTemplate(RadioComponent, "Radio");


