local composer = require( "composer" )
local widget = require( "widget" )
local lfs = require( "lfs" ) 

local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- ScrollView listener
local function scrollListener( event )
    
    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end

    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "down" ) then print( "Reached top limit" )
        elseif ( event.direction == "left" ) then print( "Reached right limit" )
        elseif ( event.direction == "right" ) then print( "Reached left limit" )
        end
    end

    return true
end

-- Função para escolher uma fase
-- -----------------------------------------------------------------------------------
-- Todas as fases são carregadas pelo arquivo fases.lua por meio de passagem 
-- de parâmetro params.nfase dessa função gotoScene.
-- -----------------------------------------------------------------------------------
local function fase(e)
    local options = {
        effect = "zoomInOutFade",
        time = 400,
        params = {
            nfase = e.target.id
        }
    }
    --local fase = 'fases.fase'..e.target.id --não é mais utilizado
    composer.gotoScene( 'fases.fases', options )
end

-- Função para desenhar os botões das fases de acordo com os arquivos presentes na pasta maps
function plotaLabels(n, sceneGroup)
    local w = display.contentWidth
    local h = display.contentHeight
    
    -- Create the widget
    local scrollView = widget.newScrollView(
        {
            top = h * .05,
            left = w * .4,
            width = w * .6,
            height = h * .9,
            --scrollWidth = 100,
            --scrollHeight = 800,
            backgroundColor = {0, 0, 0},
            listener = scrollListener
        }
    )
    -- Create the labels with texts
    local flabels = {}
    local x, y = 0, 0
    local options = {
        text = '',
        x = 0,
        y = 0,
        font = native.systemFontBold,
        fontSize = 50,
        align = 'center'
    }
    local ftexts = {}
    for i=1, n do
        flabels[i] = display.newRoundedRect(sceneGroup, 0, 0, 80, 80, 5)
        flabels[i].x, flabels[i].y = w * .1 + (x * 100), h * .1 + (y * 100)
        flabels[i]:setFillColor(114/255, 9/255, 183/255)
        
        ftexts[i] = display.newText(options)
        ftexts[i].x, ftexts[i].y = flabels[i].x, flabels[i].y
        if i < 10 then
            ftexts[i].text = '0'..tostring(i)
        else
            ftexts[i].text = tostring(i)
        end
        flabels[i].id = ftexts[i].text
        x = x + 1
        if i % 5 == 0 then
            y = y + 1
            x = 0
        end
        flabels[i]:addEventListener("tap", fase)
        scrollView:insert(flabels[i])
        scrollView:insert(ftexts[i])
        
    end
    sceneGroup:insert(scrollView)
    return flabels, ftexts
end

function getFiles()
    local path = system.pathForFile("maps", system.ResourceDirectory)
    local files = {}; 
    local i = 1;
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            files[i] = file
            print(files[i])
            i = i + 1
        end
    end
    return files
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    files = {}
    files = getFiles() --criar o array de arquivos

    flabels, ftexts = {}
    flabels, ftexts = plotaLabels(#files, sceneGroup) --cria os botões das fases
    --print(flabels[1].id)

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