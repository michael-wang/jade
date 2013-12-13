--***********************************************************************
-- @file PuzzleComponent.lua
--***********************************************************************

--=======================================================================
-- Globals
--=======================================================================

--[[

    << NOTE >>
    1) PuzzleSprite does not support switching between different image files
    2) PuzzleAnimation does not support different size images per frame


    << Data Structure >>
	g_PuzzleAnimations
			         - []name --> g_PuzzleImages
											   - image --> g_PuzzleTextures
											   - uv
											   - size
]]

-- Used for BuildSprite()
PUZZLE_TYPE_IMAGE = 1;
PUZZLE_TYPE_ANIMATION = 2;

PUZZLE_DUMMY_TEX = "__PUZZLE_DUMMY_TEX";

DEFAULT_BLEND_MODE = GraphicsEngine.BLEND_WHITEOUT;

g_PuzzleTextures = {};
g_PuzzleTexturesRefCount = {};
g_PuzzleImages = {};
g_PuzzleAnimations = {};
g_RetainedTextures = {};
g_FilteredTextures = {};



--=======================================================================
-- Data Loading Functions
--=======================================================================

--[[

	Example:

	PuzzleImage
	{
		name = "ker.pi",
		image = "xd.png",

		{
			name = "image1",
			uv = { 0,0,0.5,1, },
			size = { 394,167 },
		},

		{
			name = "image2",
			uv = { 0.5,0,1,1, },
			size = { 394,167 },
		},
	}

	======>

	g_PuzzleTextures["xd.png"] = <GaoTexture*>
    
    g_PuzzleTexturesRefCount["xd.png"] = ref count of <GaoTexture*>

	g_PuzzleImages["image1"] =
	{
		name = "xd.png",
		uv = { 0,0,0.5,1, },
		size = { 394,167 },
	},

	g_PuzzleImages["image2"] =
	{
		name = "xd.png",
		uv = { 0.5,0,1,1, },
		size = { 394,167 },
	},

Parameters:

	noRender - for SpriteGroupComponent

--]]

-------------------------------------------------------------------------
function PuzzleImage(t)
	assert(t.name, "Puzzle image has no name!");
	assert(t.image, "Puzzle image has no image: " .. t.name);

	for _, subject in ipairs(t) do
		assert(subject.name, "Puzzle has no name!");
		assert(g_PuzzleImages[subject.name] == nil, "Puzzle name has duplicated: " .. subject.name);

		g_PuzzleImages[subject.name] = subject;
		subject.textureName = t.image;
		subject.name = nil;

	end

	if (t.filter) then
		g_FilteredTextures[t.image] = true;
	end
end

-------------------------------------------------------------------------
function PuzzleAnimation(t)
	assert(t.name, "Puzzle animation has no name");
    assert(t.puzzle, "Puzzle animation has no puzzle: " .. t.name);
	assert(t.image, "Puzzle animation has no image: " .. t.name);

	for _, subject in ipairs(t) do
		assert(subject.name, "Puzzle has no name!");
		assert(g_PuzzleAnimations[subject.name] == nil, "Puzzle name has duplicated: " .. subject.name);

		g_PuzzleAnimations[subject.name] = subject;
	end    
end

-------------------------------------------------------------------------
function GetTexture(name)
    if (g_PuzzleTexturesRefCount[name] == nil) then
		if (g_FilteredTextures[name]) then
			log("FILTERED TEXTURE: " .. name);
	        g_PuzzleTextures[name] = g_GraphicsEngine:CreateFilteredTexture(name);
		else
	        g_PuzzleTextures[name] = g_GraphicsEngine:CreateTexture(name);
		end

        g_PuzzleTexturesRefCount[name] = 1;
		
		if (APP_DEBUG_MODE) then
			log("[+] CreateTexture: "..name)
		end
    elseif (g_PuzzleTexturesRefCount[name] == 0) then
        g_GraphicsEngine:ReloadTexture(g_PuzzleTextures[name]);
        g_PuzzleTexturesRefCount[name] = g_PuzzleTexturesRefCount[name] + 1;

		if (APP_DEBUG_MODE) then
			log("[*] ReloadTexture: "..name)
		end
    else
        g_PuzzleTexturesRefCount[name] = g_PuzzleTexturesRefCount[name] + 1;
    end
    
    assert(g_PuzzleTextures[name], "GetTexture error: " .. name);
    
    return g_PuzzleTextures[name];
end

-------------------------------------------------------------------------
function ReleaseTexture(name)
    if (g_PuzzleTexturesRefCount[name] == nil or g_PuzzleTexturesRefCount[name] == 0) then
		return;
	end

    g_PuzzleTexturesRefCount[name] = g_PuzzleTexturesRefCount[name] - 1;

    if (g_PuzzleTexturesRefCount[name] == 0 and g_RetainedTextures[name] == nil) then
		UnloadTexture(name);
    end
end

-------------------------------------------------------------------------
-- NOTE: UIManager can directly call UnloadTexture()
-------------------------------------------------------------------------
function UnloadTexture(name)
	if (g_PuzzleTextures[name]) then
		g_PuzzleTexturesRefCount[name] = 0;		-- Must set to zero for direct call
		g_RetainedTextures[name] = nil;
		g_GraphicsEngine:UnloadTexture(g_PuzzleTextures[name]);

		if (APP_DEBUG_MODE) then
			log("  [-] UnloadTexture: "..name)
		end
	end
end

-------------------------------------------------------------------------
function PreloadTexture(name)
	if (APP_DEBUG_MODE) then
		log("[###] PreloadTexture: "..name)
	end
	g_RetainedTextures[name] = true;
	GetTexture(name);
end

-------------------------------------------------------------------------
function InsertFilteredTexture(name)
	g_FilteredTextures[name] = true;
end

-------------------------------------------------------------------------
function BuildSprite(go, gc, name, puzzleType, blendMode)
    assert(gc.m_Sprite == nil, "Duplicated sprite");
    
    gc.m_PuzzleImageName = name;

    if (puzzleType == PUZZLE_TYPE_IMAGE) then
        gc.m_PuzzleImage = g_PuzzleImages[name];		
		assert(gc.m_PuzzleImage, "PuzzleImage error: "..name);

        gc.m_TextureName = g_PuzzleImages[name].textureName;        
    else -- PUZZLE_TYPE_ANIMATION
        gc.m_PuzzleImage = g_PuzzleImages[g_PuzzleAnimations[name][1].name];
		assert(gc.m_PuzzleImage, "PuzzleImage error [ANIM]: "..name);
		
        gc.m_TextureName = gc.m_PuzzleImage.textureName;
    end
	assert(gc.m_TextureName, "Texture name error: "..name);

    gc.m_Sprite = CreateSprite(go, gc.m_TextureName, gc.m_PuzzleImage, blendMode);
    assert(gc.m_Sprite, "Failed to create sprite");

    go["Transform"]:AttachObject(go, 0, 0, gc);
end

-------------------------------------------------------------------------
function CreateSprite(go, texture, img, blendMode)
    local sprite;
    
    if (go:IsReloadable()) then
		--log("reloadable texture : "..texture)
        sprite = g_GraphicsEngine:PrecreateSprite(go["Transform"]:GetObject());
    else
		--log("NON-reloadable texture : "..texture)
        sprite = g_GraphicsEngine:CreateSprite(go["Transform"]:GetObject(), GetTexture(texture));
        sprite:SetRenderSizeAndTexCoords(img.size[1], img.size[2], img.uv[1], img.uv[2], img.uv[3], img.uv[4]);
    end
	
	sprite:SetBlendingMode((blendMode or DEFAULT_BLEND_MODE));
    
    return sprite;
end

-------------------------------------------------------------------------
function ListCurrentUsedTextures(category)
	if (category) then
		log("\n##### " .. category .. " @ Current Used Textures #####")
	else
		log("\n##### Current Used Textures #####")
	end
	
	for name, count in pairs(g_PuzzleTexturesRefCount) do
		if (count > 0) then
			log("  "..name.."       [ref] "..count);
		end
	end
	
	log("###############################\n");
end



--=======================================================================
-- PuzzleSpriteComponent
--=======================================================================

PuzzleSpriteComponent =
{
    --
    -- Fields
    --
    m_Sprite = nil,
	m_PuzzleImage = nil,
	m_PuzzleImageName = nil,

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
    Create = function(self, t, go, noRender)
		assert(go:CheckDependency(t.class, "Transform"), "Transform GC has not existed.");
        
        local o = self:Instance();
        
        if (t.image) then        
			BuildSprite(go, o, t.image, PUZZLE_TYPE_IMAGE, t.blendMode);
        end

		-- Add events
        if (not noRender) then
            go:AddEvent(EVENT_RENDER, o, t["order"]);
        end

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
	GetObject = function(self)
		return self.m_Sprite;
	end,
    ---------------------------------------------------------------
    Reload = function(self)        
        self.m_Sprite:SetTexture(GetTexture(self.m_TextureName));
        self:SetImage(self.m_PuzzleImageName);
    end,
    ---------------------------------------------------------------
    Unload = function(self)
        ReleaseTexture(self.m_TextureName);
    end,
	---------------------------------------------------------------
	UnloadByDummy = function(self)
		ReleaseTexture(self.m_TextureName);
		self.m_TextureName = PUZZLE_DUMMY_TEX;
	end,
    ---------------------------------------------------------------
    CreateImage = function(self, name, go)
        assert(self.m_Sprite == nil);
        assert(g_PuzzleImages[name], "Puzzle image does not exist: " .. name);

        BuildSprite(go, self, name, PUZZLE_TYPE_IMAGE);
    end,
    ---------------------------------------------------------------
	SetImage = function(self, name)
		local img = g_PuzzleImages[name];
		
		if (img ~= nil) then
			self.m_PuzzleImage = img;
			self.m_PuzzleImageName = name;
            self.m_Sprite:SetRenderSizeAndTexCoords(img.size[1], img.size[2], img.uv[1], img.uv[2], img.uv[3], img.uv[4]);
		end
	end,
    ---------------------------------------------------------------
	ResetImage = function(self, name)
		local img = g_PuzzleImages[name];
		
		if (img ~= nil) then
			if (self.m_TextureName ~= g_PuzzleImages[name].textureName) then
				ReleaseTexture(self.m_TextureName);
				self.m_TextureName = g_PuzzleImages[name].textureName;
				self.m_Sprite:SetTexture(GetTexture(self.m_TextureName));
			end
			
			self.m_PuzzleImage = img;
			self.m_PuzzleImageName = name;
            self.m_Sprite:SetRenderSizeAndTexCoords(img.size[1], img.size[2], img.uv[1], img.uv[2], img.uv[3], img.uv[4]);
		end
	end,
    ---------------------------------------------------------------
	SetRenderSizeAndTexCoords = function(self, width, height, u1, v1, u2, v2)
        self.m_Sprite:SetRenderSizeAndTexCoords(width, height, u1, v1, u2, v2);
	end,
    ---------------------------------------------------------------
	SetRenderSize = function(self, width, height)
		self.m_Sprite:SetRenderSize(width, height);
	end,
    ---------------------------------------------------------------
	SetTexCoords = function(self, u1, v1, u2, v2)
		self.m_Sprite:SetTexCoords(u1, v1, u2, v2);
	end,
    ---------------------------------------------------------------
	SetTexCoordsU = function(self, u1, u2)
		self.m_Sprite:SetTexCoordsU(u1, u2);
	end,
    ---------------------------------------------------------------
	SetTexCoordsV = function(self, v1, v2)
		self.m_Sprite:SetTexCoordsV(v1, v2);
	end,
    ---------------------------------------------------------------
	GetTexCoords = function(self)
		return self.m_PuzzleImage.uv[1], self.m_PuzzleImage.uv[2], self.m_PuzzleImage.uv[3], self.m_PuzzleImage.uv[4];
	end,
    ---------------------------------------------------------------
	GetSize = function(self)
		return self.m_PuzzleImage.size[1], self.m_PuzzleImage.size[2];
	end,
    ---------------------------------------------------------------
	GetImageSize = function(self)
		return self.m_Sprite:GetWidth(), self.m_Sprite:GetHeight();
	end,
    ---------------------------------------------------------------
	GetImageName = function(self)
		return self.m_PuzzleImageName;
	end,
    ---------------------------------------------------------------
	SetOffset = function(self, x, y)
		self.m_Sprite:SetOffset(x, y);
	end,
    ---------------------------------------------------------------
	GetImageCount = function(self)
		return 1;
	end,
    ---------------------------------------------------------------
    SetAlpha = function(self, value)
        self.m_Sprite:SetAlpha(value);
    end,
    ---------------------------------------------------------------
    GetAlpha = function(self)
        return self.m_Sprite:GetAlpha();
    end,
    ---------------------------------------------------------------
    --SetColor = function(self, r, g, b)
    --    self.m_Sprite:SetColor(r, g, b);
    --end,
    ---------------------------------------------------------------	
    ToggleFlipX = function(self)
        self.m_Sprite:ToggleFlipX();
    end,
    ---------------------------------------------------------------	
    ToggleFlipY = function(self)
        self.m_Sprite:ToggleFlipY();
    end,
    ---------------------------------------------------------------	
    ResetFlip = function(self)
        self.m_Sprite:ResetFlip();
    end,
    ---------------------------------------------------------------
	ResetRenderSizeAndRadius = function(self)
		self.m_Sprite:SetRenderSizeAndRadius(self.m_PuzzleImage.size[1], self.m_PuzzleImage.size[2]);
	end,
    ---------------------------------------------------------------
    SetTranslate = function(self, x, y)
        y = g_AppData:GetData("Height") - self.m_PuzzleImage.size[2] - y;
        self.m_Sprite:SetTransform(x, y);
    end,
    ---------------------------------------------------------------
    SetVertexData = function(self, index, x, y, texCoordU, texCoordV)
        self.m_Sprite:SetVertexData(index, x, y, texCoordU, texCoordV);
    end,
    ---------------------------------------------------------------
    SetQuadVertices = function(self, x1, y1, x2, y2, x3, y3, x4, y4)
        self.m_Sprite:SetQuadVertices(x1, y1, x2, y2, x3, y3, x4, y4);
    end,
    ---------------------------------------------------------------
    SetQuadTexCoords = function(self, u1, v1, u2, v2, u3, v3, u4, v4)
        self.m_Sprite:SetQuadTexCoords(u1, v1, u2, v2, u3, v3, u4, v4);
    end,
    ---------------------------------------------------------------
	SetBlendingMode = function(self, blendMode)
		self.m_Sprite:SetBlendingMode(blendMode);
	end,
    ---------------------------------------------------------------
	DrawOffset = function(self, x, y)
		self.m_Sprite:DrawOffset(x, y);
	end,

    --
    -- Events
    --
    ---------------------------------------------------------------
    OnRender = function(self)
		self.m_Sprite:Draw();
    end,
    ---------------------------------------------------------------
    OnRenderOffset = function(self, x, y)
		self.m_Sprite:DrawOffset(x, y);
    end,
};



--=======================================================================
-- PuzzleAnimationComponent
--=======================================================================

PuzzleAnimationComponent = PuzzleSpriteComponent:Instance
{
    --
    -- Fields
    --
	m_CurrentAnim = nil,
	m_CurrentFrame = nil,
	m_CurrentFrameDuration = nil,
	m_CurrentTime = nil,
	m_FramesCount = nil,
	m_Looping = false,
	m_Done = false,
	m_Retained = false,
	m_Frequency = 1,

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
    Create = function(self, t, go, noRender)
		assert(go:CheckDependency(t.class, "Transform"), "Transform GC has not existed.");
		assert(t.anim);
		assert(g_PuzzleAnimations[t.anim], "Fail to get PuzzleAnimation object: " .. t.anim);
		assert(g_PuzzleImages[g_PuzzleAnimations[t.anim][1].name], "Fail to load PuzzleImage for animation: " .. g_PuzzleAnimations[t.anim][1].name);

		-- Create component
		local o = self:Instance
		{
			m_TransformGC = go["Transform"],
		};

        BuildSprite(go, o, t.anim, PUZZLE_TYPE_ANIMATION, t.blendMode);

        -- Initialize animation
        o:SetAnimation(t.anim, t.animating);
		
		-- Check if has callback or not
		if (t.sync) then
			o.OnUpdate = o.OnUpdateCallback;
		else
			o.OnUpdate = o.OnUpdateNormal;
		end
        
		-- Add events
        if (not noRender) then
            go:AddEvent(EVENT_RENDER, o, t["order"]);
        end
        go:AddEvent(EVENT_UPDATE, o, t["order"]);

        return o;
    end,
    
    --
    -- Public Methods
    --
    ---------------------------------------------------------------
    Reload = function(self)        
        self.m_Sprite:SetTexture(GetTexture(self.m_TextureName));
        
        local img = self.m_PuzzleImage;
        self.m_Sprite:SetRenderSizeAndTexCoords(img.size[1], img.size[2], img.uv[1], img.uv[2], img.uv[3], img.uv[4]);
    end,
    ---------------------------------------------------------------
	Animate = function(self)
		self.m_CurrentFrame = 1;
		self.m_CurrentTime = 0.0;
		self.m_Done = false;
		
        self.m_Sprite:SetTexCoords(self.m_PuzzleImage.uv[1], self.m_PuzzleImage.uv[2], 
                                   self.m_PuzzleImage.uv[3], self.m_PuzzleImage.uv[4]);
	end,
    ---------------------------------------------------------------
    SetAnimation = function(self, name, animating)
		local anim = g_PuzzleAnimations[name];
        assert(anim, "PuzzleAnimation error: " .. name);

		if (self.m_CurrentAnim ~= anim) then
			self.m_CurrentAnim = anim;
			self.m_CurrentFrameDuration = anim[1].duration * self.m_Frequency;
			self.m_FramesCount = #anim;
			self.m_PuzzleImage = g_PuzzleImages[self.m_CurrentAnim[1].name];
			self.m_Looping = anim.looping;
			self.m_Retained = anim.retained;
		end

		self:Animate();
		self.m_Done = not animating;	-- Must do it after Animate()

--[[ @Old Method
		if (self.m_CurrentAnim == anim) then
			if (animating) then
				self:Animate();
			end
			return;
		end

		self.m_CurrentAnim = anim;
		self.m_CurrentFrameDuration = anim[1].duration * self.m_Frequency;
		self.m_FramesCount = #anim;
        self.m_PuzzleImage = g_PuzzleImages[self.m_CurrentAnim[1].name];
		self.m_Looping = anim.looping;
		self.m_Retained = anim.retained;

        if (animating) then
            self.m_CurrentFrame = 1;
            self.m_CurrentTime = 0.0;
            self.m_Done = false;
        else
            self.m_Done = true;
        end
        self.m_Sprite:SetTexCoords(self.m_PuzzleImage.uv[1], self.m_PuzzleImage.uv[2], 
                                   self.m_PuzzleImage.uv[3], self.m_PuzzleImage.uv[4]);
--]]								   
    end,
    ---------------------------------------------------------------
    ResetAnimation = function(self, name, animating, looping, retained)
		local anim = g_PuzzleAnimations[name];
        assert(anim, "PuzzleAnimation error: " .. name);

		self.m_CurrentAnim = anim;
		self.m_CurrentFrameDuration = anim[1].duration * self.m_Frequency;
		self.m_FramesCount = #anim;
        self.m_PuzzleImage = g_PuzzleImages[self.m_CurrentAnim[1].name];

        if (looping == nil) then
            self.m_Looping = anim.looping;
        else
            self.m_Looping = looping;
        end

        if (retained == nil) then
            self.m_Retained = anim.retained;
        else
            self.m_Retained = retained;
        end

        if (animating) then
            self.m_CurrentFrame = 1;
            self.m_CurrentTime = 0.0;
            self.m_Done = false;
			
			if (self.m_CurrentAnim == self.m_CallbackAnim and self.m_CurrentFrame == self.m_CallbackFrame) then
				self.m_CallbackFunction(self.m_CallbackSubject);
			end		
        else
            self.m_Done = true;
        end
        
        -- Change texture if it has different image
        if (self.m_TextureName ~= anim.image) then
            ReleaseTexture(self.m_TextureName);
            self.m_TextureName = anim.image;
            self.m_Sprite:SetTexture(GetTexture(self.m_TextureName));
        end

        local img = self.m_PuzzleImage;
		assert(img, "Puzzle animation image error: "..name)
        self.m_Sprite:SetRenderSizeAndTexCoords(img.size[1], img.size[2], img.uv[1], img.uv[2], img.uv[3], img.uv[4]);
    end,
    ---------------------------------------------------------------
	StopAnimation = function(self, name)
		if (name) then
			if (self.m_CurrentAnim == g_PuzzleAnimations[name]) then
				self.m_Done = true;
				self.m_Retained = false;
			end
		else
			self.m_Done = true;
			self.m_Retained = false;
		end
	end,
    ---------------------------------------------------------------
	PauseAnimation = function(self, enable)
		self.m_Done = enable;
	end,
    ---------------------------------------------------------------
	IsDone = function(self)
		return self.m_Done;
	end,
    ---------------------------------------------------------------
	SetLooping = function(self, isLooping)
		self.m_Looping = isLooping;
	end,
    ---------------------------------------------------------------
	SetRetained = function(self, isRetained)
		self.m_Retained = isRetained;
	end,
    ---------------------------------------------------------------
    SetDuration = function(self, name, duration)
		local anim = g_PuzzleAnimations[name];
        assert(anim);
        
        for _, frame in ipairs(anim) do
            frame.duration = duration;
        end
    end,
    ---------------------------------------------------------------
	SetFrequency = function(self, frequency)
		self.m_Frequency = frequency;
	end,
    ---------------------------------------------------------------
	AttachCallback = function(self, anim, frame, func, go)
		self.m_CallbackAnim = g_PuzzleAnimations[anim];
		self.m_CallbackFrame = frame;
		self.m_CallbackFunction = func;
		self.m_CallbackSubject = go;
	end,
    ---------------------------------------------------------------
	DrawOffset = function(self, x, y)
		if (not self.m_Done or self.m_Retained) then
            self.m_Sprite:DrawOffset(x, y);
        end
	end,

    --
    -- Events
    --
    ---------------------------------------------------------------
    OnRender = function(self)
		if (not self.m_Done or self.m_Retained) then
			self.m_Sprite:Draw();
		end
    end,
    ---------------------------------------------------------------
    OnRenderOffset = function(self, x, y)
		if (not self.m_Done or self.m_Retained) then
			self.m_Sprite:DrawOffset(x, y);
		end
    end,
    ---------------------------------------------------------------
	OnUpdateNormal = function(self)
		if (self.m_Done) then
			return;
		end

		self.m_CurrentTime = self.m_CurrentTime + g_Timer:GetDeltaTime();

		if (self.m_CurrentTime >= self.m_CurrentFrameDuration) then
			self.m_CurrentTime = 0.0;
			
			if (self.m_CurrentFrame < self.m_FramesCount) then
				self.m_CurrentFrame = self.m_CurrentFrame + 1;
			else
				if (self.m_Looping) then
					self.m_CurrentFrame = 1;
				else
					self.m_Done = true;
					return;
				end
			end

			local animFrame = self.m_CurrentAnim[self.m_CurrentFrame];
			self.m_CurrentFrameDuration = animFrame.duration * self.m_Frequency;

			local img = g_PuzzleImages[animFrame.name];
            self.m_Sprite:SetTexCoords(img.uv[1], img.uv[2], img.uv[3], img.uv[4]);
		end
	end,
    ---------------------------------------------------------------
	OnUpdateCallback = function(self)
		if (self.m_Done) then
			return;
		end

		self.m_CurrentTime = self.m_CurrentTime + g_Timer:GetDeltaTime();

		if (self.m_CurrentTime >= self.m_CurrentFrameDuration) then
			self.m_CurrentTime = 0.0;
			
			if (self.m_CurrentFrame < self.m_FramesCount) then
				self.m_CurrentFrame = self.m_CurrentFrame + 1;
				
				if (self.m_CurrentAnim == self.m_CallbackAnim and self.m_CurrentFrame == self.m_CallbackFrame) then
					self.m_CallbackFunction(self.m_CallbackSubject);
				end
			else
				if (self.m_Looping) then
					self.m_CurrentFrame = 1;
				else
					self.m_Done = true;
					return;
				end
			end

			local animFrame = self.m_CurrentAnim[self.m_CurrentFrame];
			self.m_CurrentFrameDuration = animFrame.duration * self.m_Frequency;

			local img = g_PuzzleImages[animFrame.name];
            self.m_Sprite:SetTexCoords(img.uv[1], img.uv[2], img.uv[3], img.uv[4]);
		end
	end,
};



--=======================================================================
-- PuzzleCompositeSpriteComponent
--=======================================================================

PuzzleCompositeSpriteComponent =
{
    --
    -- Fields
    --
    m_SpriteGroup = nil,
    m_Sprite = nil,
	m_PuzzleImageNames = nil,
    m_Primary = nil,

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
		assert(go:CheckDependency(t.class, "Transform"), "Transform GC has not existed.");
		assert(t.images);
        
		local o = self:Instance();
        
        o.m_SpriteGroup = {};
		o.m_TextureNames = {};
        o.m_PuzzleImageNames = t.images;

        for index, imageAttr in ipairs(t.images) do
            local img = g_PuzzleImages[imageAttr[1] ];
            assert(img, "Puzzle image does not exist: "..imageAttr[1]);

            local sprite = CreateSprite(go, img.textureName, img, t.blendMode);

            local enableRender = imageAttr[2];
            if (enableRender == nil) then
                enableRender = true;
            end
            
            o.m_SpriteGroup[index] = { sprite, enableRender };
			o.m_TextureNames[index] = img.textureName;
			
			local x = imageAttr[3] or 0;
			local y = imageAttr[4] or 0;
			if (go:IsIndieTranslated() or t.indie) then
				sprite:SetOffset(x, y);
			else
				sprite:SetOffset(x * APP_UNIT_X, y * APP_UNIT_Y);
			end
        end

        o.SetPrimary(o, t.primary);

		-- Add events
        go:AddEvent(EVENT_RENDER, o, t["order"]);

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
    Reload = function(self)
        for index, sprite in ipairs(self.m_SpriteGroup) do
	        sprite[1]:SetTexture(GetTexture(self.m_TextureNames[index]));
	        self:SetImage(index, self.m_PuzzleImageNames[index][1]);
		end
    end,
    ---------------------------------------------------------------
    Unload = function(self)
        for index, sprite in ipairs(self.m_SpriteGroup) do
	        ReleaseTexture(self.m_TextureNames[index]);
		end
    end,
	---------------------------------------------------------------
	UnloadByDummy = function(self)
        for index, sprite in ipairs(self.m_SpriteGroup) do
	        ReleaseTexture(self.m_TextureNames[index]);
			self.m_TextureNames[index] = PUZZLE_DUMMY_TEX;
		end
	end,
    ---------------------------------------------------------------
    EnableRender = function(self, index, enable)
        self.m_SpriteGroup[index][2] = enable;
    end,
    ---------------------------------------------------------------
    IsRenderEnabled = function(self, index)
        return self.m_SpriteGroup[index][2];
    end,
    ---------------------------------------------------------------
	SetOffset = function(self, index, x, y)
		self.m_SpriteGroup[index][1]:SetOffset(x * APP_UNIT_X, y * APP_UNIT_Y);
    end,
    ---------------------------------------------------------------
	SetIndieOffset = function(self, index, x, y)
		self.m_SpriteGroup[index][1]:SetOffset(x , y);
    end,
    ---------------------------------------------------------------
	GetOffset = function(self, index)
		local sprite = self.m_SpriteGroup[index][1];
		return sprite:GetOffsetX(), sprite:GetOffsetY();
	end,
    ---------------------------------------------------------------
    SetPrimary = function(self, index)
        index = index or 1;
        self.m_Primary = index;
        
        self.m_Sprite = self.m_SpriteGroup[index];
        assert(self.m_Sprite);
        
        self.m_PuzzleImageName = self.m_PuzzleImageNames[index][1];
        assert(self.m_PuzzleImageName);
        
        self.m_PuzzleImage = g_PuzzleImages[self.m_PuzzleImageName];
        assert(self.m_PuzzleImage);
    end,
    ---------------------------------------------------------------
	SetImage = function(self, index, name)
        -- Has no index, use primary index
        if (name == nil) then
            name = index;
            index = self.m_Primary;
        end
    
		local img = g_PuzzleImages[name];
		if (img ~= nil) then
            self.m_PuzzleImage = img;
            self.m_PuzzleImageName = name;
			self.m_SpriteGroup[index][1]:SetRenderSizeAndTexCoords(img.size[1], img.size[2], img.uv[1], img.uv[2], img.uv[3], img.uv[4]);
        --else
        --    log("SetImage error: " .. name .. " @index: " .. index);
		end
	end,
    ---------------------------------------------------------------
	ResetImage = function(self, index, name)
        if (name == nil) then
            name = index;
            index = self.m_Primary;
        end

		local img = g_PuzzleImages[name];
		if (img ~= nil) then
			if (self.m_TextureName ~= g_PuzzleImages[name].textureName) then
				ReleaseTexture(self.m_TextureNames[index]);
		        self.m_TextureNames[index] = g_PuzzleImages[name].textureName;
		        self.m_SpriteGroup[index][1]:SetTexture(GetTexture(self.m_TextureNames[index]));
			end

            self.m_PuzzleImage = img;
            self.m_PuzzleImageName = name;
			self.m_SpriteGroup[index][1]:SetRenderSizeAndTexCoords(img.size[1], img.size[2], img.uv[1], img.uv[2], img.uv[3], img.uv[4]);
		end
	end,
    ---------------------------------------------------------------
	SetRenderSizeAndTexCoords = function(self, index, width, height, u1, v1, u2, v2)
		self.m_SpriteGroup[index][1]:SetRenderSizeAndTexCoords(width, height, u1, v1, u2, v2);
	end,
    ---------------------------------------------------------------
    SetAlpha = function(self, index, value)
        -- Has no index, use primary index
        if (value == nil) then
            value = index;
            index = self.m_Primary;
        end

        self.m_SpriteGroup[index][1]:SetAlpha(value);
    end,
    ---------------------------------------------------------------
	GetImageName = function(self)
		return self.m_PuzzleImageName;
	end,
    ---------------------------------------------------------------
	GetSize = function(self)
		return self.m_PuzzleImage.size[1], self.m_PuzzleImage.size[2];
	end,
    ---------------------------------------------------------------
	GetTexCoords = function(self)
		return self.m_PuzzleImage.uv[1], self.m_PuzzleImage.uv[2], self.m_PuzzleImage.uv[3], self.m_PuzzleImage.uv[4];
	end,
    ---------------------------------------------------------------
	GetImageCount = function(self)
		return #self.m_SpriteGroup;
	end,    
    ---------------------------------------------------------------
    GetSprite = function(self, index)
        return self.m_SpriteGroup[index][1];
    end,

    --
    -- Events
    --
    ---------------------------------------------------------------
    OnRender = function(self)
        for _, sprite in ipairs(self.m_SpriteGroup) do
            if (sprite[2]) then
                sprite[1]:Draw();
            end
        end
    end,
};
    


--=======================================================================
-- PuzzleSpriteGroupComponent
--=======================================================================

PuzzleSpriteGroupComponent =
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
		assert(go:CheckDependency(t.class, "Transform"), "Transform GC has not existed.");
		assert(t.sprites);

		-- Create C objects
 		local transObj = go["Transform"]:GetObject();
        local spriteGroup = {};
        
        for index, sprite in ipairs(t.sprites) do
			local x = sprite.x or 0;
			local y = sprite.y or 0;
            local spriteCom;

            if (sprite.name == "PuzzleSprite") then
                spriteCom = PuzzleSpriteComponent:Create(sprite, go, true);
            elseif (sprite.name == "PuzzleAnimation") then
                spriteCom = PuzzleAnimationComponent:Create(sprite, go, true);
            else
                assert("PuzzleSpriteGroupComponent catch a non-supported type: " .. sprite.name);
            end
			
            if (sprite.enable == nil) then
                spriteGroup[index] = { spriteCom, true, x, y };
            else
                spriteGroup[index] = { spriteCom, sprite.enable, x, y };
            end
        end

		-- Create component
		local o = self:Instance
		{
			m_SpriteGroup = spriteGroup,
		};

		-- Add events
        go:AddEvent(EVENT_RENDER, o, t["order"]);

        return o;
    end,

    --
    -- Public Methods
    --
    ---------------------------------------------------------------
    Reload = function(self)
        for _, sprite in ipairs(self.m_SpriteGroup) do
	        sprite[1]:Reload();
		end
    end,
    ---------------------------------------------------------------
    Unload = function(self)
        for _, sprite in ipairs(self.m_SpriteGroup) do
	        sprite[1]:Unload();
		end
    end,
	---------------------------------------------------------------
	UnloadByDummy = function(self)
 		--for i, sprite in ipairs(self.m_SpriteGroup) do
		--log("   => UnloadByDummy # " .. i .. ": "..sprite[1].m_TextureName)
        for _, sprite in ipairs(self.m_SpriteGroup) do
	        sprite[1]:UnloadByDummy();
		end
	end,
    ---------------------------------------------------------------
    GetSprite = function(self, index)
        return self.m_SpriteGroup[index][1];
    end,
    ---------------------------------------------------------------
    EnableRender = function(self, index, enable)
        self.m_SpriteGroup[index][2] = enable;
    end,
    ---------------------------------------------------------------
    IsRenderEnabled = function(self, index)
        return self.m_SpriteGroup[index][2];
    end,
    ---------------------------------------------------------------
	SetOffset = function(self, index, x, y)
        self.m_SpriteGroup[index][3] = x;
        self.m_SpriteGroup[index][4] = y;
    end,
    ---------------------------------------------------------------
	GetCount = function(self)
		return #self.m_SpriteGroup;
	end,
    
    --
    -- Events
    --
    ---------------------------------------------------------------
    OnRender = function(self)
        for _, sprite in ipairs(self.m_SpriteGroup) do
            if (sprite[2]) then
                sprite[1]:DrawOffset(sprite[3], sprite[4]);
            end
        end
    end,
};



--=======================================================================
-- Register game component templates
--=======================================================================

ObjectFactory:AddGameComponentTemplate(PuzzleSpriteComponent, "PuzzleSprite", "Sprite");
ObjectFactory:AddGameComponentTemplate(PuzzleAnimationComponent, "PuzzleAnimation", "Sprite");
ObjectFactory:AddGameComponentTemplate(PuzzleCompositeSpriteComponent, "PuzzleCompositeSprite", "Sprite");
ObjectFactory:AddGameComponentTemplate(PuzzleSpriteGroupComponent, "PuzzleSpriteGroup", "SpriteGroup");
