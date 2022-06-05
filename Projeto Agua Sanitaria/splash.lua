local composer = require( "composer" )
 
local scene = composer.newScene()

local w = display.contentWidth
local h = display.contentHeight

local function iniciar()
    composer.gotoScene("fase-1")
end


function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    local start = display.newRect(sceneGroup,w,h,150,60);
    start.x, start.y = w / 2, h / 2

    local options = {
        text = "Start",
        x = start.x,
        y = start.y,
        font = native.systemFont,
        fontSize = 20,
        align = "center"
    }

    local texto = display.newText(options);
    sceneGroup:insert(texto)
    texto:setFillColor(0,0,1)

    start:addEventListener("tap", iniciar)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene