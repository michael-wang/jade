--***********************************************************************
-- @file GameState.lua
--***********************************************************************

-------------------------------------------------------------------------
GameStates_01 =
{    
    ---------------------------------------------------------------------
    inactive =
    {
        OnEnter = function(go)
            log("inactive!");
        end,
    
        OnExecute = function(go)
        end,    
        
        OnExit = function(go)
        end,
    },
    ---------------------------------------------------------------------
    active =
    {
        OnEnter = function(go)            
            log("active!");
        end,
    
        OnExecute = function(go)
        end,    
        
        OnExit = function(go)
        end,
    },
};
