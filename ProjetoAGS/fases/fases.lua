local composer = require( "composer" )
local tiled = require "com.ponywolf.ponytiled"
local physics = require "physics"
local json = require "json"

physics.start()

local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
function voltarParaMenu(sceneGroup)
    local w = display.contentWidth
    local h = display.contentHeight
    local voltar = display.newRoundedRect(sceneGroup, 0, 0, 60, 60, 5)
    voltar.x, voltar.y = w * .9, h * .1
    voltar:setFillColor(114/255, 9/255, 183/255)
    local options = {
        text = 'X',
        x = 0,
        y = 0,
        font = native.systemFontBold,
        fontSize = 35,
        align = 'center'
    }
    
    local letrax = display.newText(options)
    letrax.x, letrax.y = voltar.x, voltar.y
    sceneGroup:insert(letrax)
    local options = {
        effect = 'zoomOutInFade',
        time = 400
    }
    voltar:addEventListener("tap", function() composer.gotoScene( "menu", options ) end)
    return voltar, letrax
end
 
function exibeTitulo(sceneGroup)
    local w = display.contentWidth
    local h = display.contentHeight

    local options = {
        --parent = 'sceneGroup',
        text = 'FASE '..event.params.nfase,
        x = w / 2,
        y = h / 2,
        font = native.systemFontBold,
        fontSize = 50,
        align = 'center'
    }
    local titulo = display.newText(options)
    sceneGroup:insert(titulo)
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    -- Code here runs when the scene is first created but has not yet appeared on screen
     
    local sceneGroup = self.view
    local phase = event.phase

    local w = display.contentWidth
    local h = display.contentHeight

    --Criar o mapa
    -- Load a "pixel perfect" map from a JSON export
    display.setDefault("magTextureFilter", "nearest")
    display.setDefault("minTextureFilter", "nearest")
    
    local background = display.newRect(sceneGroup,w / 2, h / 2 , 2000, 576);
    background:setFillColor(0, 0, .2)

    --local mapData = json.decodeFile(system.pathForFile("maps/fase03.json", system.ResourceDirectory))  -- load from json export -- Não é mais utilizado.
    local faseAtual = "maps/fase"..event.params.nfase..".json" --Carrega a fase atual com base no botão clicado na tela de escolhas.
    print(faseAtual)
    local mapData = json.decodeFile(system.pathForFile(faseAtual, system.ResourceDirectory))  -- load from json export
    local map = tiled.new(mapData, "objects")
    map.x,map.y = display.contentCenterX - map.designedWidth/2, display.contentCenterY - map.designedHeight/2

    sceneGroup:insert(map)
    voltarParaMenu(sceneGroup)
    
    --IMPORTS DO MAP
    plataforma = map:findObject("plataforma")
    suporte = map:findObject("suporte")
    
    suporteType = map:listTypes("suporte")
    florType = map:listTypes("flor")
    -- espinhosType = map:listTypes("espinhos")

    for i=1, #florType do
        florType[i].tipoColisao = false
    end

    -- for i=1, #espinhosType do
    --     espinhosType[i].tipoColisao = true
    --     espinhosType[i].ativado = true
    --     print(espinhosType[i].tipo)
    -- end

    --BOTÕES E OBJETOS
    -- local sheetData = {
    --     width = 68,
    --     height = 72,
    --     numFrames = 16
    -- }

    -- local personagem = graphics.newImageSheet( "objects/ash.png", sheetData )

    -- local sequences = {
    --     {name = "paradoEsquerda", start = 5, count = 1, time = 300, loopCount = 1, loopDirection = 'forward'},
    --     {name = "paradoDireita", start = 9, count = 1, time = 300, loopCount = 1, loopDirection = 'forward'},
    --     {name = "andandoEsquerda", start = 6, count = 3, time = 300, loopCount = 0, loopDirection = 'forward'},
    --     {name = "andandoDireita", start = 10, count = 3, time = 300, loopCount = 0, loopDirection = 'forward'}
    -- }

    -- local mc = display.newSprite(sceneGroup, personagem, sequences);
    -- mc.x, mc.y = w /2, h /2
    -- --mc:setFillColor(1,0,0)
    -- physics.addBody(
    --     mc, "dynamic", {bounce=0, friction = 0.1},
    --     { box={ halfWidth=34, halfHeight=38, x=0, y=34 }, isSensor=true }
    -- );
    -- mc.isFixedRotation = true
    -- mc.sensorOverlaps = 0

    local mc = display.newRect(sceneGroup,w,h,30,30);
    mc.x, mc.y = w /2, h /2
    mc:setFillColor(1,0,0)
    physics.addBody(
        mc, "dynamic", {bounce=0, friction = 0.1},
        { box={ halfWidth=16, halfHeight=16, x=0, y=16 }, isSensor=true }
    );
    mc.isFixedRotation = true
    mc.sensorOverlaps = 0

    --Sprite Espinhos
    -- local sheet = {
    --     sheetContentWidth = 96,
    --     sheetContentHeight = 96,
    --     width = 32,
    --     height = 32,
    --     numFrames = 8
    -- }

    -- local spikeSheet = graphics.newImageSheet( "objects/spikes.png", sheet )

    -- local sequencesSpike = {
    --     {name = "spikeOn", frames = { 8,7,6,5,4,3,2,1 }, time = 300, loopCount = 1, loopDirection = 'forward'},
    --     {name = "spikeOff", start = 1, count = 8, time = 300, loopCount = 1, loopDirection = 'forward'}
    -- }

    -- for i = 1, #espinhosType do
    -- espinhosType[i] = display.newSprite(sceneGroup, spikeSheet, sequencesSpike);
    -- end

    local botoes = {}
    for i=1, 2 do
        botoes[i] = display.newImageRect(sceneGroup, "images/arrow.png", 80, 80);
    end
    --Botão 1
    botoes[1].x, botoes[1].y = w * .3, h * .88
    botoes[1].name = "right"
    --Botão 2
    botoes[2].x, botoes[2].y = w * .21, h * .88
    botoes[2].name = "left"
    botoes[2].rotation = 180

    local botaoPular = display.newImageRect(sceneGroup, "images/arrow.png", 80,80);
    botaoPular.x, botaoPular.y = w * .8, h * .88
    botaoPular.rotation = 270
    botaoPular.name = "botaoPular"


    --MECÂNICAS DO JOGO
    --MOVIMENTAÇÃO E INTERATIVIDADE COM O PERSONAGEM
    local passoX = 0
    local score = 0
    
    local function movimetacao(e)
        if e.phase == "began" then
            --code
            if e.target.name == "right" then
                --code
                passoX = 4
                -- mc:setSequence("andandoDireita")
            elseif e.target.name == "left" then
                --code
                passoX = -4
                -- mc:setSequence("andandoEsquerda")
            end
        elseif e.phase == "ended" or e.phase == "cancelled" then
            --code
            passoX = 0
            if e.target.name == "right" then
                -- mc:setSequence("paradoDireita")
            elseif e.target.name == "left" then
                -- mc:setSequence("paradoEsquerda")
            end
        end
    end

    local function jump(e)
        --code jump
        if e.phase == "began" and mc.sensorOverlaps > 0  then
            --code
            local vx, vy = mc:getLinearVelocity()
            mc:setLinearVelocity( vx, 0 )
            mc:applyLinearImpulse( nil, -.2, mc.x, mc.y )

            -- for i=1, #espinhosType do

            --     if espinhosType[i].ativado == false then
            --         espinhosType[i]:setSequence("spikeOn")
            --         espinhosType[i]:play()
            --         espinhosType[i].ativado = true
            --         espinhosType[i].tipoColisao = true
            --     else
            --         espinhosType[i]:setSequence("spikeOff")
            --         espinhosType[i]:play()
            --         espinhosType[i].ativado = false
            --         espinhosType[i].tipoColisao = false
            --     end
            -- end
        end
    end

    local function onCollision(self, e)
        if ( e.selfElement == 2 and (e.other.name == "plataforma" or e.other.name == "suporte") ) then
            -- Foot sensor has entered (overlapped) a ground object
            if ( e.phase == "began" ) then
                self.sensorOverlaps = self.sensorOverlaps + 1
            -- Foot sensor has exited a ground object
            elseif ( e.phase == "ended" ) then
                self.sensorOverlaps = self.sensorOverlaps - 1
            end
        end

        if e.phase == "began" then
            --code
            if e.other.name == "flor" then
                --code
                e.other:removeSelf()
                score = score + 1
            end
    
            if e.other.name == "espinho" then
                print("abobora")
            end

        elseif e.phase == "ended" then
            --code
        end
    end

    local function onPreCollision(self, e)
        if (e.other.tipoColisao == false) then
            e.contact.isEnabled = false
        end
    end

    local function update()
        --code update
        mc.x = mc.x + passoX
        -- mc:play()
        
        for i=1, #suporteType do
            if (mc.y <= suporteType[i].y - 25) then
                suporteType[i].tipoColisao = true
            else
                suporteType[i].tipoColisao = false
            end
        end

        if score == #florType then
            --code
            --mc:setSequence("comemoracao")
            -- event.params.nfase = event.params.nfase + 1
        end
    end

    mc.preCollision = onPreCollision
    mc:addEventListener("preCollision")

    mc.collision = onCollision
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