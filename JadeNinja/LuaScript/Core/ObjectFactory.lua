--***********************************************************************
-- @file ObjectFactory.lua
--***********************************************************************

--=======================================================================
-- Game Object Events
--=======================================================================

EVENT_RENDER = 1;
EVENT_UPDATE = 2;
--[[
EVENT_PRERENDER = 3;
EVENT_POSTRENDER = 4;
EVENT_PREUPDATE = 5;
EVENT_POSTUPDATE = 6;
EVENT_CREATE = 7;
EVENT_DESTROY = 8;
EVENT_KEY_UP = 9;
EVENT_KEY_DOWN = 10;
EVENT_MOUSE_UP = 11;
EVENT_MOUSE_DOWN = 12;
EVENT_MOUSE_MOVE = 13;
--]]



--=======================================================================
-- ObjectFactory
--=======================================================================

ObjectFactory =
{
    --
    -- Fields
    --
    m_GameObjectTemplates = {},
    m_GameComponentTemplates = {},
    m_GameComponentParents = {},	-- Storage for component inheritance

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
    CreateGameObject = function(self, class)
		local got = self.m_GameObjectTemplates[class];
        assert(got, "Game object template has not found: " .. class);

        -- Create game object
        local obj = GameObject:Create(class, got);
        
        -- Create game components
        for _, com in ipairs(got.components) do
			self:AttachGameComponent(obj, com);
        end

        return obj;
    end,
    ---------------------------------------------------------------
    AddGameObjectTemplate = function(self, template)
        self.m_GameObjectTemplates[template.class] = template;
    end,
    ---------------------------------------------------------------
    AddGameComponentTemplate = function(self, component, class, parent)
		self.m_GameComponentTemplates[class] = component;

		if (parent ~= nil) then
			self.m_GameComponentParents[class] = parent;
		end
    end,
    ---------------------------------------------------------------
	AttachGameComponent = function(self, obj, com)
		assert(self.m_GameComponentTemplates[com.class], "AttachGameComponent error: "..com.class);
		
		local parent = self.m_GameComponentParents[com.class];
		local component = self.m_GameComponentTemplates[com.class]:Create(com, obj);
		obj:AddComponent(parent or com.class, component);
	end,
--[[
    ---------------------------------------------------------------
    DumpGCT = function(self)
		log("[Game Component Templates]");

        for k, v in pairs(self.m_GameComponentTemplates) do
			log("  " .. k);
        end
    end,
    ---------------------------------------------------------------
    DumpGOT = function(self)
		log("[Game Object Templates]");

        -- Game objects
        for k, v in pairs(self.m_GameObjectTemplates) do
			log(k .. " -> ");

            -- Game components
			for _, cv in pairs(v) do
				log("  " .. cv["class"]);
            end
        end
    end,
--]]
};



--=======================================================================
-- GameObject
--=======================================================================

GO_LAYER_PRE = 1;
GO_LAYER_POST = 2;

GameObject =
{
    --
    -- Fields
    --
	m_Class = nil,
    m_Events = nil,
	m_RenderEnabled = true,
	m_UpdateEnabled = true,

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
    Create = function(self, class, t)
        -- Create component
        local o = self:Instance
		{
			m_Class = class,
            m_Reloadable = t.reloadable,
			m_IndieTranslated = t.indie,
			m_Events =
            {
                [EVENT_RENDER] = {},
                [EVENT_UPDATE] = {},
            },
		};
        
        if (t.postLayer == true) then
            o.m_PostLayerObject = {};
            
            o.Render = o.RenderPostLayered;
            o.Update = o.UpdatePostLayered;
        elseif (t.preLayer == true) then
            o.m_PreLayerObject = {};
            
            o.Render = o.RenderPreLayered;
            o.Update = o.UpdatePreLayered;
        elseif (t.multiLayer == true) then
            o.m_PreLayerObject = {};
            o.m_PostLayerObject = {};
            
            o.Render = o.RenderMultiLayered;
            o.Update = o.UpdateMultiLayered;
        end

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	CheckDependency = function(self, com, dep)
		if (self[dep] ~= nil) then
			return true;
		end
		return false;
	end,
    ---------------------------------------------------------------
	AddComponent = function(self, name, comp)
		self[name] = comp;
	end,
    ---------------------------------------------------------------
	GetComponent = function(self, name)
		return self[name];
	end,
    ---------------------------------------------------------------
    GetClass = function(self)
        return self.m_Class;
    end,
    ---------------------------------------------------------------
	AttachObject = function(self, go, offsetX, offsetY)
        assert(self["Transform"]);
        return self["Transform"]:AttachObject(go, (offsetX or 0), (offsetY or 0));
	end,
    ---------------------------------------------------------------
	AttachLayerObject = function(self, go, offsetX, offsetY, layer)
        assert(self["Transform"]);
        self["Transform"]:AttachObject(go, (offsetX or 0), (offsetY or 0));

        if (layer == GO_LAYER_PRE) then
            table.insert(self.m_PreLayerObject, go);
        else
            table.insert(self.m_PostLayerObject, go);
        end
	end,
    ---------------------------------------------------------------
	DetachObject = function(self, id)
        self["Transform"]:DetachObject(id);
	end,
    ---------------------------------------------------------------
	DetachLayerObject = function(self, go, layer)
        self["Transform"]:DetachObject(go);
        
        local t;
        if (layer == GO_LAYER_PRE) then
            t = self.m_PreLayerObject;
        else
            t = self.m_PostLayerObject;
        end
        
        for index, obj in ipairs(t) do
            if (obj == go) then
                table.remove(t, index);
                return;
            end
        end
        
        assert(false, "DetachLayerObject error");
    end,
    ---------------------------------------------------------------
    ReattachObject = function(self, go, offsetX, offsetY)
        assert(self["Transform"]);
        self["Transform"]:ReattachObject(go, offsetX, offsetY);
    end,
    ---------------------------------------------------------------
	ToggleRender = function(self)
        self.m_RenderEnabled = not self.m_RenderEnabled;
	end,
    ---------------------------------------------------------------
	ToggleUpdate = function(self)
        self.m_UpdateEnabled = not self.m_UpdateEnabled;
	end,
    ---------------------------------------------------------------
	ToggleRenderAndUpdate = function(self)
        self.m_RenderEnabled = not self.m_RenderEnabled;
        self.m_UpdateEnabled = not self.m_UpdateEnabled;
	end,
    ---------------------------------------------------------------
	EnableRender = function(self, enable)
		self.m_RenderEnabled = enable;
	end,
    ---------------------------------------------------------------
	EnableUpdate = function(self, enable)
		self.m_UpdateEnabled = enable;
	end,
    ---------------------------------------------------------------
    IsRenderEnabled = function(self)
        return self.m_RenderEnabled;
    end,
    ---------------------------------------------------------------
    AddEvent = function(self, event, component, order)
        assert(self.m_Events[event]);

		if (order == nil) then
			table.insert(self.m_Events[event], component);
		else
			table.insert(self.m_Events[event], order, component);
		end
    end,
    ---------------------------------------------------------------
    Reload = function(self)
		local gc = self["Sprite"] or self["SpriteGroup"];

        if (gc) then
            gc:Reload();
        end
    end,
    ---------------------------------------------------------------
    Unload = function(self)
		local gc = self["Sprite"] or self["SpriteGroup"];

        if (gc) then
            gc:Unload();
        end
    end,
    ---------------------------------------------------------------
    UnloadByDummy = function(self)
		local gc = self["Sprite"] or self["SpriteGroup"];

        if (gc) then
            gc:UnloadByDummy();
        end
    end,
    ---------------------------------------------------------------
    EnableReloadable = function(self, enable)
        self.m_Reloadable = enable;
    end,
    ---------------------------------------------------------------
    IsReloadable = function(self)
        return self.m_Reloadable;
    end,
    ---------------------------------------------------------------
	GoIndie = function(self)
		self.m_IndieTranslated = true;
		self["Transform"]:GoIndie();
		if (self["Bound"]) then
			self["Bound"]:GoIndie();
		end
	end,
    ---------------------------------------------------------------
    IsIndieTranslated = function(self)
		return self.m_IndieTranslated;
	end,
    ---------------------------------------------------------------
	Render = function(self)
		if (self.m_RenderEnabled) then
			for _, com in pairs(self.m_Events[EVENT_RENDER]) do
				com:OnRender();
			end
		end
	end,
    ---------------------------------------------------------------
	RenderOffset = function(self, x, y)
		if (self.m_RenderEnabled) then
			for _, com in pairs(self.m_Events[EVENT_RENDER]) do
				assert(com.OnRenderOffset);
				com:OnRenderOffset(x, y);
			end
		end
	end,
    ---------------------------------------------------------------
    RenderPreLayered = function(self)
		if (self.m_RenderEnabled) then
            for _, go in ipairs(self.m_PreLayerObject) do
                go:Render();
            end

			for _, com in pairs(self.m_Events[EVENT_RENDER]) do
				com:OnRender();
			end
		end
    end,
    ---------------------------------------------------------------
    RenderPostLayered = function(self)
		if (self.m_RenderEnabled) then
			for _, com in pairs(self.m_Events[EVENT_RENDER]) do
				com:OnRender();
			end
            
            for _, go in ipairs(self.m_PostLayerObject) do
                go:Render();
            end
		end
    end,
    ---------------------------------------------------------------
    RenderMultiLayered = function(self)
		if (self.m_RenderEnabled) then
            for _, go in ipairs(self.m_PreLayerObject) do
                go:Render();
            end

			for _, com in pairs(self.m_Events[EVENT_RENDER]) do
				com:OnRender();
			end
            
            for _, go in ipairs(self.m_PostLayerObject) do
                go:Render();
            end
		end
    end,
    ---------------------------------------------------------------
	Update = function(self)
		if (self.m_UpdateEnabled) then
			for _, com in pairs(self.m_Events[EVENT_UPDATE]) do
				com:OnUpdate();
			end
		end
	end,
    ---------------------------------------------------------------
    UpdatePreLayered = function(self)
		if (self.m_UpdateEnabled) then
            for _, go in ipairs(self.m_PreLayerObject) do
                go:Update();
            end

			for _, com in pairs(self.m_Events[EVENT_UPDATE]) do
				com:OnUpdate();
			end
		end
    end,
    ---------------------------------------------------------------
    UpdatePostLayered = function(self)
		if (self.m_UpdateEnabled) then
			for _, com in pairs(self.m_Events[EVENT_UPDATE]) do
				com:OnUpdate();
			end

            for _, go in ipairs(self.m_PostLayerObject) do
                go:Update();
            end
		end
    end,
    ---------------------------------------------------------------
    UpdateMultiLayered = function(self)
		if (self.m_UpdateEnabled) then
            for _, go in ipairs(self.m_PreLayerObject) do
                go:Update();
            end

			for _, com in pairs(self.m_Events[EVENT_UPDATE]) do
				com:OnUpdate();
			end

            for _, go in ipairs(self.m_PostLayerObject) do
                go:Update();
            end
		end
    end,
};



--=======================================================================
-- GameObjectTemplate
--=======================================================================

--------------------------------------------------------------------------------
function GameObjectTemplate(t)
	assert(t.class ~= nil and t.components ~= nil, "Failed to create game object template");

    -- Add template to ObjectFactory
    ObjectFactory:AddGameObjectTemplate(t);
end

--------------------------------------------------------------------------------
function CenterGameObject(go, axis)
	local w, h = go["Sprite"]:GetSize();
    
    if (axis == nil) then
        go["Transform"]:SetTranslate((SCREEN_UNIT_X - w) * 0.5, (SCREEN_UNIT_Y - h) * 0.5);
    elseif (axis == AXIS_X_CENTER) then
        go["Transform"]:SetTranslate((SCREEN_UNIT_X - w) * 0.5, go["Transform"]:GetTranslateY());
    elseif (axis == AXIS_Y_CENTER) then
        go["Transform"]:SetTranslate(go["Transform"]:GetTranslateX(), (SCREEN_UNIT_Y - h) * 0.5);
    end
end
