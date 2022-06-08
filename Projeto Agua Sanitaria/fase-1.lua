local composer = require( "composer" )
 
local scene = composer.newScene()

display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )

local physics = require("physics")
physics.start()
physics.setGravity(0, 20);


function scene:create( event )

    local w = display.contentWidth
    local h = display.contentHeight

    local botaoPular = display.newRect(w,h,640,720);
    botaoPular.x, botaoPular.y = w * .75, h / 2
    botaoPular:setFillColor(0)
    botaoPular.name = "botaoPular"
    --botaoPular.alpha = 0
    --botaoPular.isVisible = false

    local background = display.newImageRect("image/background.png", w, h);
    background.x, background.y = w / 2, h / 2
    background.name = "background"

    local mc = display.newRect(w,h,120,120);
    mc.x, mc.y = w * .5, h * .8
    mc:setFillColor(1,1,0)
    physics.addBody(mc, "dynamic", {bounce=0, friction = 0.1});
    mc.isFixedRotation = 0
    local sensor = 0

    local plataformas = {}
    --PLATAFORMA 1
    plataformas[1] = display.newRect(w,h,1280,60);
    plataformas[1].x, plataformas[1].y = w / 2, h * .85
    physics.addBody(plataformas[1], "static", {bounce=0, friction = 0.3});
    plataformas[1].objType = "ground"
    plataformas[1]:setFillColor(0)
    plataformas[1].isVisible = false

    --PLATAFORMA 2
    --[plataformas[2] = display.newRect(w,h,200,20);
    --plataformas[2].x, plataformas[2].y = 425, h * .8
    --physics.addBody(plataformas[2], "static", {bounce=0, friction = 0.3});
    --plataformas[2].objType = "ground"
    --plataformas[2]:setFillColor(0)

    local pontos = {}
    pontos[1] = display.newCircle(w * .1, plataformas[1].y - 100, 20);
    physics.addBody(pontos[1], "static", {bounce=0, friction = 0});
    pontos[1].objType = "score"
    pontos[2] = display.newCircle(w * .8, plataformas[1].y - 100, 20);
    physics.addBody(pontos[2], "static", {bounce=0, friction = 0});
    pontos[2].objType = "score"

    --BOTÕES PARA MOVIMENTAÇÃO
    local botoes = {}
    botoes[1] = display.newImageRect("image/arrow.png", 140, 140);
    botoes[1].x, botoes[1].y = w * .2, h * .88
    botoes[1].name = "right"
    botoes[2] = display.newImageRect("image/arrow.png", 140, 140);
    botoes[2].x, botoes[2].y = w * .07, h * .88
    botoes[2].rotation = 180
    botoes[2].name = "left"

    local passoX = 0

    --MOVIMENTAÇÃO E INTERATIVIDADE COM O PERSONAGEM
    local function movimetacao(e)
        if e.phase == "began" or e.phase == "moved" then
            --code
            if e.target.name == "right" then
                --code
                passoX = 4
                --pessoa:setSequence("andandoDireita")
            elseif e.target.name == "left" then
                --code
                passoX = -4
                --pessoa:setSequence("andandoEsquerda")
            end
        elseif e.phase == "ended" or e.phase == "cancelled" then
            --code
            passoX = 0
            if e.target.name == "right" then
                --pessoa:setSequence("paradoDireita")
            elseif e.target.name == "left" then
                --pessoa:setSequence("paradoEsquerda")
            end
        end
    end


    local function jump(e)
        --code jump
        if e.phase == "began" or e.phase == "moved" then
            --code
            if e.target.name == "botaoPular" and sensor == 0 then
                --code
                mc:setLinearVelocity(0, -250)
                --pessoa:setSequence("andandoDireita")
            end
        elseif e.phase == "ended" or e.phase == "cancelled" then
            --code
            if e.target.name == "botaoPular" then
                --code
            end
        end
    end

    --COLISÃO DO PERSONAGEM
    local function mcColisao(self, e)
        if e.phase == "began" then
            --code
            if e.other.objType == "ground" then
                sensor = 0
            end

            if e.other.objType == "score" then
                --code
                e.other:removeSelf()
            end
        elseif e.phase == "ended" then
            --code
            if e.other.objType == "ground" then
                sensor = 1
            end
        end
    end

    local function update()
        --code update
        mc.x = mc.x + passoX
        --detectorPulo.x, detectorPulo.y = mc.x, mc.y * 1.12

        if mc.y > 720 then
            mc.y = 0
        elseif mc.x > 1280 then
            mc.x = 0
        elseif mc.x < 0 then
            mc.x = w
        end
    end

    mc.collision = mcColisao
    mc:addEventListener("collision")
    botaoPular:addEventListener("touch", jump)
    Runtime:addEventListener("enterFrame", update)
    for i=1, #botoes do
        botoes[i]:addEventListener("touch", movimetacao)
    end
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