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

    for i=1, #florType do
        florType[i].tipoColisao = false
        print(florType[i].tipoColisao)
    end

    -- print(#apoio .. " oi")
    --print(suporte.y)

    --BOTÕES E OBJETOS
    local mc = display.newRect(sceneGroup,w,h,30,30);
    mc.x, mc.y = w /2, h /2
    mc:setFillColor(1,0,0)
    physics.addBody(mc, "dynamic", {bounce=0, friction = 0.1});
    mc.isFixedRotation = true


    local botoes = {}
    botoes[1] = display.newImageRect(sceneGroup, "images/arrow.png", 80, 80);
    botoes[1].x, botoes[1].y = w * .3, h * .88
    botoes[1].name = "right"
    botoes[2] = display.newImageRect(sceneGroup, "images/arrow.png", 80, 80);
    botoes[2].x, botoes[2].y = w * .21, h * .88
    botoes[2].rotation = 180
    botoes[2].name = "left"

    local botaoPular = display.newImageRect(sceneGroup, "images/arrow.png", 80,80);
    botaoPular.x, botaoPular.y = w * .8, h * .88
    botaoPular.rotation = 270
    botaoPular.name = "botaoPular"

    local passoX = 0
    local score = 0
    local sensorChao = false --necessário obj.type na plataforma no tiled

    --MECÂNICAS DO JOGO
    --MOVIMENTAÇÃO E INTERATIVIDADE COM O PERSONAGEM
    local function movimetacao(e)
        if e.phase == "began" or e.phase == "moved" then
            --code
            if e.target.name == "right" then
                --code
                passoX = 4
                --mc:setSequence("andandoDireita")
            elseif e.target.name == "left" then
                --code
                passoX = -4
                --mc:setSequence("andandoEsquerda")
            end
        elseif e.phase == "ended" or e.phase == "cancelled" then
            --code
            passoX = 0
            if e.target.name == "right" then
                --mc:setSequence("paradoDireita")
            elseif e.target.name == "left" then
                --mc:setSequence("paradoEsquerda")
            end
        end
    end

    local function jump(e)
        --code jump
        if e.phase == "began" or e.phase == "moved" then
            --code
            if e.target.name == "botaoPular"  and sensorChao == true then
                --code
                mc:setLinearVelocity( 0, -200 )
                --mc:setSequence("andandoDireita")
            end
        elseif e.phase == "ended" or e.phase == "cancelled" then
            --code
        end
    end

    local function onCollision(self, e)
        if e.phase == "began" then
            --code
            if e.other.name == "flor" then
                --code
                e.other:removeSelf()
                score = score + 1
            end
            
            if e.other.name == "plataforma" or e.other.name == "suporte" then
                sensorChao = true
            end
        -- print(self.name .. " colidiu com " .. e.other.name)
        elseif e.phase == "ended" then
        --     --code
            if e.other.name == "plataforma" or e.other.name == "suporte" then
                sensorChao = false
            end
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
        
        for i=1, #suporteType do
            if (mc.y <= suporteType[i].y - 25) then
                suporteType[i].tipoColisao = true
            else
                suporteType[i].tipoColisao = false
            end
        end

        
        --print(suporteType[3].tipoColisao)
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