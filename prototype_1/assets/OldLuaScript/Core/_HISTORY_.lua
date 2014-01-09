

2013.10.31
@IOManager
 - Add IO_ICLOUD_DATA


2013.08.08
@ObjectComponent
 - Add CircleBoundComponent:IsPickedNonTransformIndie()
@UIPuzzleWidget
 - Add PuzzleProgressbarWidget:GetMaxValue()


2013.07.11
@ObjectComponent
 - Add FadeComponent:IsDone()


2013.07.02
@UIManager
 - Mod UIManager:CreateGameUITemplate()


2013.06.25
@ObjectFactory
 - Add CenterGameObject()
 

2013.06.19
@PuzzleComponent
 - Mod PuzzleAnimationComponent:SetAnimation()
 - Add InsertFilteredTexture()
 
 
2013.06.07
# iPhone5 screen resolution '1136x640' support
@Core
 - Mod PLAIN_DEVICE_SCRIPT_POOL{}
@ObjectComponent
 - Add TransformComponent:ModifyScale()
@Prebuild
 - Add new output file 'iphone5.bottle'

 
2013.06.05
@Core
 - Mod InitializeLuaIphone()
@ObjectComponent
 - Add TransformComponent:SetIndieTranslate()/SetIndieTranslateX()/SetIndieTranslateY()
 - Add TransformComponent:SetIndieTranslateAttached()/ModifyIndieTranslateAttached()/ReattachIndieObject()
@ObjectFactory
 - Add GameObject:GoIndie()/IsIndieTranslated()
@PuzzleComponent
 - Mod PuzzleCompositeSpriteComponent:Create()
@UIManager
 - Add AlignObject()
 - Mod CreateDefaultUIComponents()
 - Add ResetDropdownUI()/OpenDropdownUI()/CloseDropdownUI()
@Utility
 - Add DrawIndieRectangle()/DrawIndieCircle()


2013.05.31
# Modify PrebuildPuzzle process to adapt iPhone5 files
@Core
 - Mod PLAIN_DEVICE_SCRIPT_POOL{}/PREBUILD_DEVICE_SCRIPT_POOL{}
 
 
2013.05.14
@ObjectFactory
 - Mod GameObject:Create()
 - Add GameObject:RenderPreLayered()/UpdatePreLayered()
 

2013.05.10
# Modify all g_GraphicsEngine:DrawCircle() to DrawCircle()
# Modify all g_GraphicsEngine:DrawRectangle() to DrawRectangle()
@PuzzleComponent
 - Add PuzzleCompositeSpriteComponent:SetIndieOffset()
@Utility
 - Add DrawCircle()/DrawRectangle()


2013.03.18
@Core
 - Mod InitializeLuaIphone()
@ObjectComponent
 - Mod TransformComponent:Create()/SetTranslate()/SetTranslateEx()/SetTranslateAttached()
 
 
2013.03.14
@UIManager
 - Add UIFrame:EnableSwipe()
 - Mod UIFrame:InitializeSwipe()/OnSwipeBeganAxis()
 - Mod UIFrame:OnSwipeMovedAxisX()/OnSwipeMovedAxisY()/OnSwipeEndedAxisX()/OnSwipeEndedAxisY()


2013.03.12
@PuzzleComponent
 - Mod PuzzleSpriteComponent:ResetImage()
 - Mod PuzzleCompositeSpriteComponent:ResetImage()


2013.02.26
@PoolManager
 - Mod PoolManager:DeactivateResource()
@UIManager
 - Mod UIFrame:InitializeSwipe()/OnSwipeBeganAxis()/OnSwipeEndedAxisX()
 

2013.02.12
# Add 'Translation Unit' to Transform Component
@Core
 - Mod PLAIN_DEVICE_SCRIPT_POOL{}
 - Mod InitializeLuaIphone()/InitializeAppData()
@ObjectComponent
 - Mod TransformComponent:SetTranslate()/SetTranslateEx()/SetTranslateAttached()
 - Mod TransformComponent:ModifyTranslate()/ModifyTranslateEx()/ModifyTranslateAttached()


2013.01.31
# Add 'wav2caf.sh' and 'wav2aifc.sh' to Prebuild folder
@PuzzleComponent
 - Mod GetTexture()/UnloadTexture()
@UIPuzzleWidget
 - Rem ProgressbarWidget{}
@PoolManager
 - Mod PoolManager:ActivateResource()
 

2013.01.29
@IOManager
 - Add OnEnterForeground()


2013.01.18
@PuzzleComponent
 - Mod ListCurrentUsedTextures()


2013.01.11
@StageManager
 - Add StageManager:ChangeStageForPopup()/PushStageForPopup()/PopStageForPopup()
@UIManager
 - Add UIManager:ScaleUI()/SetAllWidgetsAlpha()
 - Add UIFrame:SetAllWidgetsAlpha()
 

2013.01.04
@Core
 - Mod PreInitialize()
@ObjectComponent
 - Add 'BOUND_RESULT_PICKED' and 'BOUNT_RESULT_NEARLY'
 - Add CircleBoundComponent:IsNearlyPickedObject()
 - Mod RectangleBoundComponent:Create()/OnRender()


2013.01.02
@IOManager
 - Add 'IO_CAT_STAT'
 - Mod IOManager:ModifyValue()
@UIManager
 - Add UIManager:CenterSwipeObjects()
 - Add UIFrame:CenterSwipeObjects()
 

2012.12.28
@IOManager
 - Mod OnGameCenterAuthorized()/OnGameCenterScoreSubmitted()/OnGameCenterAchievementSubmitted()
 

2012.12.20
@UIManager
 - Add UIManager:MoveWidgetToLast()
@UIPuzzleWidget
 - Mod PuzzleRadioButtonGroupWidget:Select()
 - Add PuzzleRadioButtonGroupWidget:Reselect()


2012.12.08
@PuzzleComponent
 - Add PuzzleSprite:SetBlendingMode()
 

2012.12.04
@ObjectComponent
 - Add LinearMotionComponent:SetCycling()
 - Mod LinearMotionComponent:OnUpdate()
 

2012.11.13
@ObjectComponent
 - Add FadeComponent:SetCycling()
 - Mod FadeComponent:OnUpdate()
 

2012.11.06
@UIManager
 - Add UIManager:MoveUIToFirst()/MoveUIToLast()
 - Add UIManager:CloseUI()
 
 
2012.10.25
@PuzzleComponent
  - Mod PuzzleImage()/GetTexture()
  - Add PuzzleAnimationComponent:PauseAnimation()


2012.08.13
@Utility
 - Add UpdateGOTranslate()/CycleGOTranslate()


2012.07.29
@IOManager
 - Mod OnEnterBackground()/OnReceiveLocalNotification()
 - Add OnGameCenterInitialized()
 - Remove InitializeGameKit()
 

2012.07.03
@PuzzleComponent
 - Add PuzzleCompositeSpriteComponent:GetSprite()
@Utility
 - Add UpdateGoRotate()
 - Add CycleGOAlpha()/CycleGOScale()/CycleGORotate()
@PrebuildLevel
 - Mod ParseLevelSet()


2012.06.21
@UIPuzzleWidget
 - Add PuzzleNumberWidget:ResetPrefix()
 - Mod PuzzleNumberWidget:Render_PrePost()


2012.06.12
@ObjectComponent
 - Add TimerComponent:EnableUpdate()
@StageManager
 - Mod StageManager:ChangeStageWithMotion()/UpdateUIMotionStage()
 

2012.06.07
# Add PrebuildLevel.lua/.bat


2012.05.31
# Add Twitter support


2012.05.21
@UIManager
 - Add UIManager/UIFrame:ResetSwipe()


2012.05.18
@PuzzleComponent
 - Add PuzzleSpriteComponent/PuzzleCompositeSpriteComponent/PuzzleSpriteGroupComponent:UnloadByDummy()
 - Add PreloadTexture()
 - Mod UnloadTexture()/ReleaseTexture()
@ObjectFactory
 - Add GameObject:UnloadByDummy()
 

2012.05.14
@PuzzleComponent
 - Add ListCurrentUsedTextures()
 

2012.05.08
@UIPuzzleWidget
 - Mod PuzzleNumberWidget:Render_PrePost()
@StageManager
 - Add StageManager:GetStageState()


2012.05.07
# Move 'GamePuzzle' from Game Data to Platform-specific Data script
@Core
 - Mod InitializeLuaIphone()
@Prebuild
 - Mod Preload()


2012.04.30
@PuzzleComponent
 - Mod GetTexture()/ReleaseTexture()/UnloadTexture()
@ObjectComponent
 - Add TimerComponent:SetElapsedTime()


2012.04.05
@ObjectComponent
 - Mod LinearMotionComponent:AttachCallback()/AttachUpdateCallback()/AttachCompleteCallback()/OnUpdate()
@UIManager
 - Mod UIFrame:OnSwipeEndedAxisX()/OnSwipeEndedAxisY()


2012.04.03
# Change UI released/pressed operations to reversed order
@UIManager
 - Mod UIFrame:AddWidget()/RemoveWidget()
 - Mod UIFrame:OnMousePressed()/OnMouseMove()/OnMouseReleased()
 - Add UIFrame:LockAllWidgets()/IsMotionDone()
 - Add UIManager:GetWidgetGroup()
 - Mod UIManager:UnlockAllButtons()/LockAllButtons()/LockAllButtonsExcept()
@PuzzleComponent
 - Mod PuzzleSpriteGroupComponent:Create()
 

2012.03.29
@ObjectComponent
 - Add RectangleBoundComponent:GetOffset()
 - Add CircleBoundComponent:GetOffset()


2012.03.23
@ObjectComponent
 - Add ShakerComponent:IsDone()
 

2012.03.19
# Add Shaker game component
@UIManager
 - Mod UIFrame:InitializeSwipe()/OnSwipeMovedAxisX()/OnSwipeMovedAxisY()/OnSwipeEndedAxisX()/OnSwipeEndedAxisY()
@ObjectComponent
 - Add ShakerComponent{}
 - Mod LinearMotionComponent:OnUpdate()
 

2012.03.16
@UIManager
 - Mod UIManager:Create()
 

2012.03.06
@Utility
 - Add DrawFullscreenColorMask()
 - Mod DumpTable()
@ObjectComponent
 - Mod TimeBasedInterpolatorComponent:AttachUpdateCallback()/AttachCompleteCallback()
 

2012.02.29
@ObjectFactory
 - Mod ObjectFactory:AttachGameComponent()
@Utility
 - Add DrawFullscreenMask()
 

2012.02.23
@Utility
 - Add UpdateWidgetNumber()
 

2012.02.21
@UIPuzzleWidget
 - Add PuzzleRadioButtonGroupWidget:OnMousePressed()
 - Mod PuzzleRadioButtonGroupWidget:OnMouseReleased()
@IOManager
 - Mod IOManager:SetValue()/GetValue()/ModifyValue()


2012.02.16
@PuzzleComponent
 - Add PuzzleAnimationComponent:StopAnimation()
 

2012.02.13
# Add UI widget grouping functionality
@UIPuzzleWidget
 - Mod PuzzleCheckButtonWidget:Init()
@UIManager
 - Add UIManager:ToggleWidgetGroup()/AddTimeDelayEffect()
 - Mod UIManager:CreateGameUITemplate()
 - Add UIFrame:AddWidgetGroups()
@StageManager
 - Add StageManager:ChangeStageWithMotion()/UpdateUIMotionStage()
 

2012.02.10
# Refactor PuzzleCheckButton widget
@UIPuzzleWidget
 - Mod PuzzleCheckButtonWidget:Create()/Reload()/ChangeState()/ChangeSkin()
 - Add PuzzleRadioButtonGroupWidget:ChangeSkin()
 

2012.02.09
# Add local notification functionality
@Core
 - Add OnEnterBackgroundDelegate()/OnReceiveLocalNotificationDelegate()
@IOManager
 - Add IOManager:Dump()
 - Add OnEnterBackground()/OnReceiveLocalNotification()
@UIPuzzleWidget
 - Add PuzzleCheckButtonWidget:ChangeSkin()
 - Mod PuzzleCheckButtonWidget:OnMouseReleased()/ChangeState()
@RoutineManager
 - Mod RoutineManager:Create()
 - Add RoutineManager:AddObject_Debug()/AddObject_Release()
 - Add RoutineManager:AddGroupObjects_Debug()/AddGroupObjects_Release()


2012.02.07
# Add '-s' strip debug information at 'luac' precompiled process
@Prebuild
 - Mod Prebuild()
@IOManager
 - Add IOMAnager:ModifyValue()
@ObjectComponent
 - Mod CircleBoundComponent:GetCenter()
  
 
2012.02.03
@IOManager
 - Add IOManager:SetRecord()/GetRecord()
 - Mod IOManager:SetValue()/GetValue()
@PuzzleComponent
 - Mod BuildSprite()
 

2012.02.02
@PuzzleComponent
 - Add PuzzleCompositeSpriteComponent:ResetImage()


2012.02.01
# Create GlyphFontRenderer() only in 'DEBUG' mode
# Remove EaglPolySprite class
# Remove EaglAvpAudioRenderer class
@Core
 - Mod PreInitialize()
@PuzzleComponent
 - Add PuzzleSpriteComponent:SetVertexData()/SetQuadVertices()/SetQuadTexCoords()
 - Mod PuzzleAnimationComponent to inheritant from PuzzleSpriteComponent
 - Remove PuzzlePolySpriteComponent{}
 - Mod CreateSprite()
 

2012.01.30
# Add 'Luabins' to LuabindX project & ThirdParty folder
# Add 'IOManager' class for serialization
# Rename all log() to log()
# Rename prebuild scripts name
@ObjectComponent
 - Refactor RectangleBoundComponent & CircleBoundComponent
 - Add CircleBoundComponent:IsPickedObjectIndie()/OnRenderIndie()/SetOffset()
 - Mod CircleBoundComponent:Create()/SetSize()
@Utility
 - Mod DumpTable()
 - Remove Say()/SayPair()/SayTable()
@Core
 - Add log()/logp()
@IOManager
 - Add IOManager{}
@Prebuild
 - Mod Preload()


2012.01.26
# Create new XCode Project 'GaoUni' for Universal & OpenGL ES2 support
# Add 'APP_DEVICE' variable
# Add 'GameGlobal_iPad.lua' script
# Mod entity rotation to radian-based operation
# Refactor alpha blending functionality
# Remove 'GridManager.lua' & 'AIComponent.lua'
@Core
 - Add UpdateMain()/RenderMain()
 - Mod InitializeLuaIphone()/PreInitialize()
@PuzzleComponent
 - Add SpriteComponent:SetRenderSize()/ResetRenderSizeAndRadius()
 - Refactor 'DrawOffset' functionality
 - Remove OES sprite functionality
@ObjectComponent
 - Add TransformComponent:SetRotateByRadian()/SetRotateByDegree()
 - Add TransformComponent:ModifyRotateByRadian()/ModifyRotateByRadian()
 - Add TransformComponent:GetRotateByRadian()/GetRotateByRadian()
 - Remove TransformComponent:SetRotateAngle()/GetRotateAngle()
@UIManager
 - Mod UIFrame:Create()/Render_Release()/Render_Debug()
@Prebuild
 - Add iPhone/iPad support
 

2012.01.14
@ObjectComponent
 - Add TimeBasedInterpolatorComponent:SetCycling()
 - Mod TimeBasedInterpolatorComponent:OnInterpolatingEnd()
@TaskManager
 - Add StateChangeTask{}
@UIPuzzleWidget
 - Mod PuzzleButtonWidget:Enable()


2012.01.09
@UIPuzzleWidget
 - Mod PuzzleButtonWidget:SetImage()


2012.01.08
@ObjectComponent
 - Mod ConstSpeedInterpolatorComponent:OnUpdate()
 - Add InterpolatorComponent:IsOnInterpolating()/SetEnd()
 - Rename InterpolatorComponent to TimeBasedInterpolatorComponent
 - Rename ConstSpeedInterpolatorComponent to SpeedBasedInterpolatorComponent
 

2012.01.06
# Add PuzzleNumber UI widget alignment left/right functionality
@ObjectComponent
 - Mod InterpolatorComponent:Reset()/OnUpdate()
 - Add InterpolatorComponent:AttachUpdateCallback()/AttachCompleteCallback()
 - Add LinearMotion:AttachUpdateCallback()/AttachCompleteCallback()
 - Refactor ConstSpeedInterpolatorComponent{}
@Utility
 - Add UpdateGOAlpha()/UpdateGOScale()
@UIPuzzleWidget
 - Mod PuzzleNumberWidget:Create()/SetValue()/Render_Default()


2012.01.03
# Refactor UI Swipe functionality (Y-axis incomplete)
# Add PuzzleRadioButtonGroup UI widget
@UIPuzzleWidget
 - Add PuzzleButtonWidget:Enable()
 - Add PuzzleRadioButtonGroupWidget{}
@UIManager
 - Mod UIFrame:InitializeSwipe()/OnSwipeBeganAxisX()/OnSwipeEndedAxisX()
 - Add UIFrame:OnSwipeMovedAxisX()/SetSwipeDataRecord()
 - Add UIManager:GetWidgetTranslate()
@PuzzleComponent
 - Add PuzzleSpriteGroupComponent:GetCount()


2011.12.27
# Add Luabind function GameKit.GetCurrentSystemTime()


2011.12.21
# Add HourTimer UI widget
@UIPuzzleWidget
 - Add PuzzleHourTimerWidget{}
 - Mod PuzzleTimerWidget:SetSecond()


2011.12.19
# Add animation frequency functionality
@PuzzleComponent
 - Add PuzzleAnimationComponent:SetFrequency()


2011.12.06
@UIPuzzleWidget
 - Add PuzzlePictureWidget:SetImage()/ResetImage()
 

2011.11.29
@PuzzleComponent
 - Mod PuzzleCompositeSpriteComponent:Create()
@UIManager
 - Add UIManager:ExchangeWidgetOrder()/GetTouchPos()
 - Add UIFrame:RemoveWidget()/GetWidgetObjectAndOrder()


2011.10.17
@StateMachineComponent
 - Add StateMachineComponent:ResetStateSet()


2011.10.06
@PuzzleComponent
 - Add PuzzleCompositeSpriteComponent:GetOffset()
 - Mod PuzzleSliderWidget:Init()/SetValue()


2011.10.03
# Add PuzzleProgressbar widget
@UIPuzzleWidget
 - Add PuzzleSliderWidget{}
 - Add PuzzleNumberWidget:SetValuePair()
 - Add PuzzleSliderWidget:SetValuePair()


2011.09.20
# Add PuzzleAnimation GC callback functionality
# Add PuzzleAnimation GC 'sync' parameter
@PuzzleComponent
 - Rename PuzzleAnimationComponent:OnUpdate() to OnUpdateNormal()
 - Add PuzzleAnimationComponent:OnUpdateCallback()/AttachCallback()
 - Mod PuzzleAnimationComponent:Create()/ResetAnimation()


2011.09.14
@ObjectComponent
 - Add ConstSpeedInterpolatorComponent
 

2011.08.22
@ObjectComponent
 - Add AttributeComponent:ModifyInRange()
 

2011.08.16
@PoolManager
 - Add PoolManager:ActivateResource()/DeactivateResource()
 - Add PoolManager:ResetPool()/IsInactivePoolEmpty()/IsActivePoolEmpty()
 

2011.07.22
@ObjectComponent
 - Add InterpolatorComponent:SetLooping()
 - Mod InterpolatorComponent:OnUpdate()


2011.07.21
# Modify texture parameter to GL_REPEAT
@PuzzleComponent
 - Add SpriteComponent:SetTexCoordsU()/SetTexCoordsV()


2011.07.19
# Add GameKit Game Center leaderboard/achievements support
@Core
 - Add InitializeGameKit()/OnGameCenterAuthorized()/OnGameCenterScoreSubmitted()
 - Add OnGameCenterAchievementSubmitted()/OnGameCenterAchievementReset()
 

2011.07.07
# Add Button widget transparent functionality
@UIPuzzleWidget
 - Mod PuzzleButtonWidget:Create()


2011.07.05
# Add Bounding GC 'debug' rendering parameter
@ObjectComponent
 - Mod RectangleBoundComponent:Create()/OnRender()
 - Mod CircleBoundComponent:Create()/OnRender()


2011.06.22
@ObjectComponent
 - Add RectangleShapeComponent:SetOffset()
 - Mod RectangleBoundComponent:GetCenter()
 

2011.06.19
# Modify button widget OnTouchBegan/OnTouchEnded logic
# Add RectangleBound GC offset (partial) functionality
@UIManager
 - Mod UIManager:OnMousePressed()/OnMouseReleased()
@UIPuzzleWidget
 - Mod PuzzleButtonWidget:OnMouseReleased()
@ObjectComponent
 - Add RectangleBoundComponent:SetOffset()
 - Mod RectangleBoundComponent:IsPickedObject()


2011.04.21
# Add UI reload/unload functionality
@UIManager
 - Add UIManager:ActivateModalUI()/DeactivateModalUI()
 - Mod UIManager:ActivateUI()/DeactivateUI()
 - Add UIFrame:Reload()/Unload()
 - Mod UIFrame:Create()
@ObjectFactory
 - Add GameObject:EnableReloadable()
@PuzzleComponent
 - Add UnloadTexture()
 - Mod PuzzleCompositeSpriteComponent:Create()/Reload()/Unload()
 - Add PuzzleSpriteGroup:Reload()/Unload()
@UIPuzzleWidget
 - Add PuzzleButtonWidget:Reload()
 - Add PuzzleCheckButtonWidget:Reload()


2011.04.12
@UIPuzzleWidget
 - Mod all widgets Render_Debug()/Render_Release()


2011.03.29
@UIManager
 - Mod UIManager:FadeCycle()
@TaskManager
 - Add UIFadeCycleTask{}
@UIPuzzleWidget
 - Add PuzzleTimerWidget:GetTime()
 

2011.03.22
@PuzzleComponent
 - Add PuzzleSprite:ResetImage()
@UIManager
 - Add UIFrame:InitializeSwipe()/OnSwipeEndedDefault()
 - Add UIFrame:OnSwipeBeganAxisX()/OnSwipeEndedAxisX()/OnSwipeBeganAxisY()/OnSwipeEndedAxisY()
 - Mod UIFrame:OnMouseMove()/OnMousePressed()/OnMouseReleased()
 - Remove UIManager:OnSwipeBegin()/OnSwipeEnd()


2011.03.21
# Add sprite blending mode support
@PuzzleComponent
 - Mod PuzzleSpriteComponent:Create()
@TaskManager
 - Add UIScaleTask{}
@UIManager
 - Mod UIManager:ProceedEffects()/ProceedPreEffects()
 - Add UIFrame:ScaleAllWidgets()
 

2011.03.20
# Fix PuzzleAnimationComponent animation duration bug
@PrebuildPuzzle
 - Mod animation duration unit from 'second' to 'millisecond'
@PuzzleComponent
 - Mod PuzzleAnimationComponent:OnUpdate()


2011.03.18
# Add UI & Stage binding
# Add UI effects system
# Add UI multilayer modal frames
@UIManager
 - Refactor
 - Add UIManager:Create()
@TaskManager
 - Mod TaskManager:Update()
 - Add UIActivateTask{}/UIDeactivateTask{}/AudioTask{}
 - Mod UIMotionTask{}/UIFadeTask{}
@StageManager
 - Mod StageManager:ChangeStage()


2011.03.03
@UIManager
 - Add UIFrame:UnlockAllButtons()/LockAllButtons()/LockAllButtonsExcept()
@TaskManager
 - Add TaskManager:IsDone()
@PuzzleComponent
 - Mod PuzzleAnimationComponent:ResetAnimation()
 

2011.02.23
# Refactor PuzzleAnimationComponent
@PuzzleComponent
 - Refactor PuzzleAnimationComponent{}
 

2011.02.19
# Refactor PrebuildPuzzle.lua
@PuzzleComponent
 - Mod PuzzleAnimation()


2011.02.11
@PuzzleComponent
 - Mod PuzzleAnimationComponent:Reset()
@UIPuzzleWidget
 - Add PuzzleTimerWidget{}
 - Mod PuzzleProgressbar:SetValue()/ModifyValue()
@ObjectComponent
 - Add RectangleBoundComponent:GetCenter()


2011.02.03
# Change glColorPointer() to glColor4ub()
# Add EaglOesSprite class
@PuzzleComponent
 - Add BuildSprite()
 - Refactor PuzzleSpriteComponent/PuzzleAnimationComponent


2011.02.02
@ObjectFactory
 - Add GameObject:RenderMultiLayered()/UpdateMultiLayered()
 - Mod GameObject:Create()/DetachLayerObject()
 - Mod ObjectFactory:CreateGameObject()


2011.01.30
@Utility
 - Add RandElement()
 

2011.01.28
@ObjectFactory
 - Mod GameObject:AttachObject()/DetachObject()
 - Add GameObject:AttachLayerObject()/DetachLayerObject()/RenderLayered()/UpdateLayered()
@ObjectComponent
 - Mod TransformComponent:SetTranslate()/ModifyTranslate()/AttachObject()
 - Mod TransformComponent:SetTranslateEx()/ModifyTranslateEx()
 - Add TransformComponent:SetTranslateAttached()/ModifyTranslateAttached()
 - Add RectangleBoundComponent:GetRadius()
 

2011.01.26
@UIPuzzleWidget
 - Mod PuzzlePictureWidget:OnMouseReleased()
@ObjectFactory
 - Refactor GameObject{}
 - Mod ObjectFactory:CreateGameObject()
 - Add GameObject:ToggleRenderAndUpdate()/IsRenderEnabled()
 - Mod VelocityComponent:Reset()
 

2011.01.24
@ObjectComponent
 - Add VelocityComponent:Reset()
 - Mod TimerComponent:ResetRandRange()
@PuzzleComponent
 - Add PuzzleAnimationComponent:ResetFlip()
 - Add PuzzleCompositeSpriteComponent:IsRenderEnabled()


2011.01.22
# Change glColor4f() to glColor4ub()
# Modify all g_GraphicsEngine:DrawCircle()/DrawRectangle()


2011.01.20
# Rename InputEvent to IOManager
@UIManager
 - Add UIManager:GetWidgetEnable()
 - Rename UIFrame:EnableRender() to EnableWidget()
@StageManager
 - Mod StageManager:PushStage() 
@IOManager
 - Add DeserializeFile()/SerializeFile()/WriteLine()/WriteData()/DumpData()
 
 
2011.01.19
@Utility
 - Add ModifyValueByRandRange()/ModifyPairByRandRange()
@ObjectComponent
 - Add TransformComponent:GetRotateAngle()/GetScale()
 - Mod TransformComponent:SetRotateAngle()/SetScale()
@PuzzleComponent
 - Mod PuzzleCompositeSpriteComponent:SetImage()
@UIPuzzleWidget
 - Add PuzzleProgressbar:SetImage()
 

2011.01.18
@ObjectComponent
 - Mod InterpolatorComponent:OnUpdate()


2011.01.17
# Add GraphicsEngine::SetBlendFunction()
# Move EaglApplication to from iOSApp to Eagl project


2011.01.14
# Compile for thumb
 - arm7 on
 - arm6 off
@UIPuzzleWidget
 - Mod PuzzleNumberWidget:Init()/SetValue()/Render_PrePost()
 - Add PuzzlePictureWidget:OnMousePressed()/OnMouseReleased()/OnMouseMove()


2011.01.11
@file ObjectComponent
 - Mod LinearMotionComponent:AttachCallback()/OnUpdate()
@file AIComponent
 - Add GridTargetAssaultAIComponent{}
@file StateMachineComponent
 - Add StateMachineComponent:RevertPreviousState()


2011.01.10
# Fix Circle-Rectangle collision
# Fix Rectangle-Rectangle collision
# Add file GridManager
# Add file AIComponent
@file GridManager
 - Add GridManager{}
@file AIComponent
 - Add GridGroupMoverAIComponent{}
@file ObjectComponent
 - Add CircleBoundComponent:IsCircleRectanglePicked()
 - Mod CircleBoundComponent:IsPickedObject()
 - Mod RectangleBoundComponent:IsPickedObject()
@file Core
 - Mod CORE_SCRIPT_FILES{}


2010.12.29
# Add Circular button UI widget
@file PuzzleComponent
 - Mod PuzzleAnimationComponent:Reset()
@file UIManager
 - Add UICircularObject UI widget template
@file UIPuzzleWidget
 - Mod PuzzleButtonWidget:Create()/Render_Debug()


2010.12.28
# Refactor Accelerometer functionality
# Add EaglAccelerometer class
# Add EaglDefine.h
@file StateMachineComponent
 - Mod StateMachineComponent:Create()


2010.12.27
@file PuzzleComponent
 - Add PuzzleAnimationComponent:SetImage()
@file ObjectComponent
 - Mod RectangleBoundComponent:IsPickedObject()
 - Add RectangleBoundComponent/CircleBoundComponent:IsAbove()


2010.12.23
@file PuzzleComponent
 - Mod PuzzleCompositeSpriteComponent:SetPrimary()/SetImage()


2010.12.22
# Rebuild Xcode project
# Rename folder 'Xcode32' to 'Xcode'
# Rename folder 'iPhoneBasedApp' to 'iOSApp'
# Disable dumping AppData{}
# Disable EaglTimer log
# Disable random seed log
# Move AppFlag setup procedure from Core to GameCore
# Split folder 'Game' to 'GameFunc' & 'GameData'
# Add prebuild script file 'monkey.dat'
@file Core
 - Mod InitializeLuaIphone()/InitializeAppData()/PostInitialize()
 - Mod MainLoopIphoneFTDebug()
 - Comment Core Routines (PC/Mac)
@file Prebuild
 - Refactor
@file GameCore
 - Split GAME_SCRIPT_FILES{} to GAME_FUNC_FILES{} & GAME_DATA_FILES{}
 

2010.12.21
@file ObjectFactory
 - Mod GameObject:ReattachObject()
@file UIManager
 - Add UIManager:ModifyWidgetTranslate()
 - Mod UIManager:TouchBegan()/TouchMoved()/TouchEnded()
 - Add UIManager:OnSwipeBegin()/OnSwipeEnd()
 

2010.12.16
@file ObjectComponent
 - Add AttributeComponent:IsNil()
 - Mod RectangleBoundComponent/CircleBoundComponent:IsPickedObjectAbove()
 

2010.12.15
@file ObjectComponent
 - Add CompositeShapeComponent rectangle/circle shapes support 
 - Mod RectangleBoundComponent/CircleBoundComponent:Create()
 - Add AttributeComponent:Reset()
@file StateMachineComponent
 - Add StateMachineComponent:IsStateChangeAllowed()
 

2010.12.14
# Add Bound GC collision point detection
# Add PuzzleSprite null image creation
@file ObjectComponent
 - Mod RectangleBoundComponent/CircleBoundComponent:IsPickedObjectAbove()
 - Add RectangleBoundComponent/CircleBoundComponent:GetRelativeHeight()
 - Add CircleBoundComponent:SetSize()/GetCollisionPoint()
@file PuzzleComponent
 - Add PuzzleSpriteComponent:CreateImage()
 - Mod PuzzleSpriteComponent:Create()
 

2010.12.10
@file UIPuzzleWidget
 - Mod PuzzleCheckButtonWidget:Render_Debug()
 - Add PuzzleCheckButtonWidget:ChangeState()


2010.12.02
@file Utility
 - Add Clamp()
 

2010.12.01
@file RoutineManager
 - Add RoutineManager:RemoveGroupObjects()
 - Mod RoutineManager:AddGroupObjects()
@file ObjectComponent
 - Add TimerComponent:ToggleUpdate()
 - Mod TimerComponent:Create()/OnUpdate()
 

2010.11.28
@file ObjectComponent
 - Add RectangleBoundComponent:GetType()
 - Add CircleBoundComponent:GetType()
 - Rename RectangleBoundComponent:IsPickedObjectAndHigher() to IsPickedObjectAbove()
 - Rename CircleBoundComponent:IsPickedObjectAndHigher() to IsPickedObjectAbove()


2010.11.27
# Add GraphicsEngine::DrawCircle()
# Rename GraphicsEngine::DrawRect() to DrawRectangle()
@file ObjectComponent
 - Add ColorCircleComponent{}
 - Rename ColorRectComponent{} to RectangleShapeComponent{}
 - Rename ColorCircleComponent{} to CircleShapeComponent{}
 - Rename CompositeColorRectComponent{} to CompositeShapeComponent{}
 - Rename 'Rect' to 'Shape'
 - Rename RectPickComponent{} to RectangleBoundComponent{}
 - Rename CirclePickComponent{} to CircleBoundComponent{}
 - Rename 'Pick' to 'Bound'
 - Refactor CircleBoundComponent{}


2010.11.26
@file ObjectComponent
 - Add VelocityComponent:SetVelocity()
@file StateMachineComponent
 - Mod StateMachineComponent:ChangeState()/LockState()/UnlockState()/UnlockAllStates()
 

2010.11.24
@file ObjectComponent
 - Add AttributeComponent{}
@file StageManager
 - Add StageManager:RenderNonTransform()


2010.11.23
# Add Frame Time Counter
# Add GAO_INPUT_ACCELEROMETER_NORMALIZED_XY
# Mod App Update Frequency from 60 to 30
@file InputEvent
 - Remove InitializeMWCounter()
@file Core
 - Add InitializeMWCounter()
 - Add InitializeFTCounter()
 - Add MainLoopIphoneFTDebug()
@file ObjectComponent
 - Add RectPickComponent:IsPickedObjectAndHigher()/IsPickedObjectAndLower()


2010.11.19
@file RoutineManager
 - Refactor RoutineManager{}
@file ObjectComponent
 - Rename LinearMotionComponent:ToggleUpdate() to Pause()


2010.11.18
@file ObjectComponent
 - Add RectPickComponent:GetArea()
 - Mod RectPickComponent:IsPickedObjectNonTransform()/IsPickedObjectWorldTransform()


2010.11.17
@file StateMachineComponent
 - Mod StateMachineComponent:UnlockAllStates()/LockState()/UnlockState()
 - Refactor StateMachineComponent:ChangeState()/OnUpdate()
@file RoutineManager
 - Mod RoutineManager:RemoveGroup()
@file ObjectComponent
 - Mod LinearMotionComponent/InterpolatorComponent/FadeComponent:Reset()
 - Add VelocityComponent


2010.11.16
# Add EaglPolySprite class
# Refactor EaglSprite::Draw()/SetAlpha()
@file PuzzleComponent
 - Add PuzzlePolySpriteComponent
 - Add PuzzleSpriteGroupComponent


2010.11.11
# Add Texture reload/unload functionality
@file RoutineManager
 - Mod MoveObjectToFirst()/MoveObjectToLast()
@file ObjectFactory
 - Add GameObject:Reload()/Unload()/IsReloadable()
 - Mod ObjectFactory:CreateGameObject()/AddGameObjectTemplate()
@file PuzzleComponent
 - Add g_PuzzleTexturesRefCount{}
 - Add GetTexture()/ReleaseTexture()
 - Add PuzzleSpriteComponent:Reload/Unload()
 - Mod PuzzleSpriteComponent:Create()
 - Add PuzzleAnimationComponent:Reload/Unload()
 - Mod PuzzleAnimationComponent:Create()
 

2010.11.10
@file RoutineManager
 - Remove MoveObjectByIndex()
 - Add MoveObjectToFirst()/MoveObjectToLast()/GetObjectIndex()
 - Mod RemoveObject()
@file UIPuzzleWidget
 - Mod PuzzleCheckButtonWidget:Create()
 

2010.11.02
# Add PuzzleSprite/PuzzleAnimation image flip functionality
@file Utility
 - Mod DataManager:SetDataInRange()
@file ObjectComponent
 - Add RectPickComponent:IsPickedObjectWorldTransform()
 - Add RectPickComponent:IsPickedObjectNonTransform()
@file PuzzleComponent
 - Add PuzzleSpriteComponent:ToggleFlipX()/ToggleFlipY()
 - Mod PuzzleSpriteComponent:Create()/SetTexCoords()
 - Add PuzzleAnimationComponent:ToggleFlipX()/ToggleFlipY()
 - Mod PuzzleAnimationComponent:Create()/Reset()/OnUpdate()
 - Add PuzzleAnimationComponent parent to Sprite


2010.11.01
@file ObjectComponent
 - Add TimerComponent:GetElapsedTime()
 

2010.10.29
@file ObjectComponent
 - Add FadeComponent:Reset()


2010.10.28
# Sync Gao/GaoTemplate/GKSandbox/Bistro/Ninja projects
# Integrate GameKit functionality
# Add PuzzleNumberWidget prefix/postfix text support
@file UIPuzzleWidget
 - Refactor PuzzleNumberWidget{}
 

2010.10.27
# Optimize UI widgets update procedure
@file UIManager
 - Mod UIFrame:Update()
@file UIPuzzleWidget
 - Rename all OnUpdate() to Update()
 - Add 'doUpdate' parameter


2010.10.19
# Add GaoApp namespace
@file Core
 - Mod GetRootPath() to GaoApp.GetRootPath()
@file Utility
 - Add SayPair() & SayTable()
 

2010.10.17
# Add Accelerometer support
# Add CompositeColorRect game component
@file InputEvent
 - Add OnDeviceAccelerate()
@file ObjectComponent
 - Add CompositeShapeComponent{}
 - Add ColorRect parent to Rect


2010.10.15
# Add PuzzleNumber plus/minus sign
# Add PuzzleNumber slash sign & max value
@file UIPuzzleWidget
 - Mod PuzzleNumberWidget{}


2010.10.12
# Add PuzzleProgressbar widget
@file PuzzleComponent
 - Add PuzzleSpriteComponent:GetImageCount()
 - Mod PuzzleCompositeSpriteComponent{}
@file UIPuzzleWidget
 - Add PuzzleProgressbarWidget{}
  

2010.10.10
# Upgrade to Luabind 0.9.1


2010.10.09
# Add PuzzleCompositeSprite game component
# Mod obj["PuzzleSprite"] to obj["Sprite"]
@file PuzzleComponent
 - Add PuzzleCompositeSpriteComponent{}
 - Add PuzzleSprite parent to Sprite


2010.10.06
# Add RectPickComponent auto-sizing
@file ObjectFactory
 - Mod ObjectFactory:CreateGameObject()
@file ObjectComponent
 - Add ColorRect:GetSize()
 - Mod RectPick:Create()
@file PuzzleComponent
 - Rename PuzzleSpriteComponent:GetSize() to GetImageSize()
 - Rename PuzzleSpriteComponent:GetRenderSize() to GetSize()
 - Rename PuzzleAnimationComponent:GetRenderSize() to GetSize()
@file UIPuzzleWidget
 - Rename PuzzleSprite:GetRenderSize() to GetSize()
 

2010.10.01
# Add memory warning counter
@file PuzzleComponent
 - Add PuzzleSpriteComponent:GetAlpha()
 - Add PuzzleAnimationComponent:GetAlpha()
@file UIPuzzleWidget
 - Mod TEXT_DEFAULT_VALUE
 - Add 
@file InputEvent
 - Add InitializeMWCounter()
 - Mod OnReceiveMemoryWarning()
@file Core
 - Mod PostInitialize()
 - Mod InitializeAppData()


2010.9.28
@file UIManager
 - Mod UIFrame:Render_Debug()
 - Mod UIFrame:OnMousePressed()
 - Mod UIFrame:OnMouseReleased()


2010.9.27
# Remove file _TODO_.lua
# Add UIManager layered widgets support
# Add UIPuzzleWidget rendering route
# Add ShowMessage()
@file UIManager
 - Mod UIManager:CreateGameUITemplate()
 - Rename UIManager:DisableRenderAllWidget() to DisableAllWidgets()
 - Rename UIManager:EnableRenderWidget() to EnableWidget()
 - Refactor UIFrame{}
@file UIPuzzleWidget
 - Refactor ALL
@file GameCore
 - Rename TouchBeganDelegate to TouchBegan
 - Rename TouchMovedDelegate to TouchMoved
 - Rename TouchEndedDelegate to TouchEnded
@file InputEvent
 - Refactor


2010.9.26
# Remove file SpriteComponent
# Modify visual structure of code
# Add DataManager functionality
@file Core
 - Mod CORE_SCRIPT_FILES{}
 - Add PreInitialize()
 - Add PostInitialize()
 - Add InitializeAppData()
 - Refactor
@file Utility
 - Add DataManager{}
 - Add CollectGarbage()
 - Add ShowMemoryUsage()
@file UIManager
 - Rem UI_SHOW_COLOR
 - Rem UI_SHOW_TEXT
@file UIPuzzleWidget
 - Rem UI_SHOW_COLOR
 - Rem UI_SHOW_TEXT
 - Rename PuzzleProgressbarWidget{} to ProgressbarWidget{}
@file ObjectComponent
 - Rem PICK_SHOW_BOUND
 - Mod RectPickComponent:IsPickedWorldTransform()
@file InputEvent
 - Add OnReceiveMemoryWarning


2010.9.24
@file ObjectComponent
 - Mod RectPickComponent:IsPicked()
 - Add RectPickComponent:IsPickedNonTransform()
 - Add RectPickComponent:IsPickedWorldTransform()


2010.9.21
@file ObjectFactory
 - Mod CreateGameObject()
@file StateMachineComponent 
 - Add GetCurrentStateArgs()
 - Mod ChangeState()
@file UIManager
 - Mod TouchBegan()
 - Mod TouchMoved()
 - Mod TouchEnded()
 

2010.9.7
@file ObjectFactory
 - Add GetClass()
@file StateMachineComponent
 - Mod Create()
 - Mod ChangeState()
@file ObjectComponent
 - Add TimerComponent{}


2010.9.4
# Reorganize files into Core/Game folders
@file Core
 - Mod ReloadAllScripts()
 - Mod Reload()
 - Mod LoadScript()
@file Prebuild
 - Mod Prebuild()


2010.9.2
@file StageManager
 - Mod StageManager:ChangeStage()
 

2010.9.1
@file TaskManager
 - Add InterpolateTask{}
 - Mod CallbackTask{}
@file UIPuzzleWidget
 - Mod ProgressbarWidget:OnRender()
@file ObjectFactory
 - Mod GameObjectTemplate
@file StageManager
 - Refactor StageManager{}


2010.8.26
@file ObjectComponent
 - Add TransformComponent:SetTranslateEx()
 - Add TransformComponent:ModifyTranslateEx()
@file UIManager
 - Add UIManager:SetUITranslate()
 - Add UIManager:SetUITranslateEx()
 - Add UIManager:CloneUI()
 - Mod UIManager:CreateGameUITemplate()
 - Mod UIFrame:Create()


