local buttons = {"Resume", "Restart", "Options", "Exit"}
local canpause = true
local inMenu = false
local curSelect = 1

function onCreate()
    luaDebugMode = true
    precacheSound('scrollMenu')

    makeLuaSprite('fade', nil, -500, 300)
    makeGraphic("fade", 5000, 5000, '000000')
    setObjectCamera('fade', 'other')
    screenCenter('fade', 'xy')
    addLuaSprite('fade', true)
    setObjectOrder("fade", 4)
    setProperty('fade.alpha', 0)
end

function onCreatePost()
    createInstance("backdrop", "flixel.addons.display.FlxBackdrop", {nil, 0x10})
    setObjectCamera("backdrop", 'other')
    setProperty("backdrop.alpha", 0)
    loadGraphic("backdrop", "gridig")
    setObjectOrder("backdrop", 5)
    addInstance("backdrop")

end

function onPause()
    openCustomSubstate("lookyispro", true)
    return Function_Stop
end

function onCustomSubstateCreatePost(name)
    if name == 'lookyispro' then
        curSelect = 1
        inMenu = true
        playSound("scrollMenu", 1)
        doTweenAlpha("fade", "fade", 0.5, 1, "linear")
        doTweenAlpha("backdrop", "backdrop", 0.1, 1, "linear")

        for looky, button in ipairs(buttons) do
            makeLuaText(button, button, 1000, 0, -100)
            setObjectCamera(button, "other")
            setObjectOrder(button, 8)
            setProperty(button .. ".alpha", 1)
            screenCenter(button, 'x')
            setTextSize(button, 70)
            setTextFont(button, "Mabook.ttf")
            addLuaText(button)
            doTweenY(button .. "HEY", button, -50 + (looky * 150), 2, "expoOut")
        end

        makeLuaSprite('mewhen', "pause/mewhen", -1000, -30) -- 470
        setObjectCamera('mewhen', 'other')
        addLuaSprite('mewhen', true)
        scaleObject("mewhen", 0.7, 0.7)
        setObjectOrder("mewhen", 8)
        setProperty('mewhen.alpha', 1)
        doTweenX("mewhen", "mewhen", -470, 2, "expoOut")

        makeLuaSprite('mewhenagain', "pause/mewhenagain", 1000, -30) -- 400
        setObjectCamera('mewhenagain', 'other')
        addLuaSprite('mewhenagain', true)
        scaleObject("mewhenagain", 0.7, 0.7)
        setObjectOrder("mewhenagain", 8)
        setProperty('mewhenagain.alpha', 1)
        doTweenX("mewhenagain", "mewhenagain", 400, 2, "expoOut")

        makeLuaText("songName", songName, 1000, 0, -100) -- 150
        setObjectOrder("songName", 8)
        setObjectCamera('songName', 'other')
        setTextSize("songName", 50)
        screenCenter("songName", 'x')
        setTextFont("songName", "Mabook.ttf")
        addLuaText("songName")
        doTweenY("songName", "songName", 30, 2, "expoOut")
    end
end

function onCustomSubstateUpdate(name, elapsed)
    setProperty("backdrop.y", getProperty("backdrop.y") + 1)
    if keyboardJustPressed("T") then
        exitSong()
    end
    if keyJustPressed("down") then
        playSound("scrollMenu", 1)
        if curSelect == 1 then
            curSelect = 2

            doTweenX("ResumeSizeX", "Resume.scale", 1, 0.4, "expoOut")
            doTweenY("ResumeSizeY", "Resume.scale", 1, 0.4, "expoOut")

            doTweenX("RestartSizeX", "Restart.scale", 1.1, 0.4, "expoOut")
            doTweenY("RestartSizeY", "Restart.scale", 1.1, 0.4, "expoOut")

            doTweenX("OptionsSizeX", "Options.scale", 1, 0.4, "expoOut")
            doTweenY("OptionsSizeY", "Options.scale", 1, 0.4, "expoOut")

            doTweenX("ExitSizeX", "Exit.scale", 1, 0.4, "expoOut")
            doTweenY("ExitSizeY", "Exit.scale", 1, 0.4, "expoOut")

            doTweenAlpha("Resume", "Resume", 0.8, 0.1, "expoOut")
            doTweenAlpha("Restart", "Restart", 1, 0.1, "expoOut")
            doTweenAlpha("Options", "Options", 0.8, 0.1, "expoOut")
            doTweenAlpha("Exit", "Exit", 0.8, 0.1, "expoOut")
        elseif curSelect == 2 then
            curSelect = 3

            doTweenX("ResumeSizeX", "Resume.scale", 1, 0.4, "expoOut")
            doTweenY("ResumeSizeY", "Resume.scale", 1, 0.4, "expoOut")

            doTweenX("RestartSizeX", "Restart.scale", 1, 0.4, "expoOut")
            doTweenY("RestartSizeY", "Restart.scale", 1, 0.4, "expoOut")

            doTweenX("OptionsSizeX", "Options.scale", 1.1, 0.4, "expoOut")
            doTweenY("OptionsSizeY", "Options.scale", 1.1, 0.4, "expoOut")

            doTweenX("ExitSizeX", "Exit.scale", 1, 0.4, "expoOut")
            doTweenY("ExitSizeY", "Exit.scale", 1, 0.4, "expoOut")

            doTweenAlpha("Resume", "Resume", 0.8, 0.1, "expoOut")
            doTweenAlpha("Restart", "Restart", 0.8, 0.1, "expoOut")
            doTweenAlpha("Options", "Options", 1, 0.1, "expoOut")
            doTweenAlpha("Exit", "Exit", 0.8, 0.1, "expoOut")
        elseif curSelect == 3 then
            curSelect = 4

            doTweenX("ResumeSizeX", "Resume.scale", 1, 0.4, "expoOut")
            doTweenY("ResumeSizeY", "Resume.scale", 1, 0.4, "expoOut")

            doTweenX("RestartSizeX", "Restart.scale", 1, 0.4, "expoOut")
            doTweenY("RestartSizeY", "Restart.scale", 1, 0.4, "expoOut")

            doTweenX("OptionsSizeX", "Options.scale", 1, 0.4, "expoOut")
            doTweenY("OptionsSizeY", "Options.scale", 1, 0.4, "expoOut")

            doTweenX("ExitSizeX", "Exit.scale", 1.1, 0.4, "expoOut")
            doTweenY("ExitSizeY", "Exit.scale", 1.1, 0.4, "expoOut")

            doTweenAlpha("Resume", "Resume", 0.8, 0.1, "expoOut")
            doTweenAlpha("Restart", "Restart", 0.8, 0.1, "expoOut")
            doTweenAlpha("Options", "Options", 0.8, 0.1, "expoOut")
            doTweenAlpha("Exit", "Exit", 1, 0.1, "expoOut")
        end
    end
    if keyJustPressed("up") then
        playSound("scrollMenu")
        if curSelect == 3 then
            curSelect = 2

            doTweenX("ResumeSizeX", "Resume.scale", 1, 0.4, "expoOut")
            doTweenY("ResumeSizeY", "Resume.scale", 1, 0.4, "expoOut")

            doTweenX("RestartSizeX", "Restart.scale", 1.1, 0.4, "expoOut")
            doTweenY("RestartSizeY", "Restart.scale", 1.1, 0.4, "expoOut")

            doTweenX("OptionsSizeX", "Options.scale", 1, 0.4, "expoOut")
            doTweenY("OptionsSizeY", "Options.scale", 1, 0.4, "expoOut")

            doTweenX("ExitSizeX", "Exit.scale", 1, 0.4, "expoOut")
            doTweenY("ExitSizeY", "Exit.scale", 1, 0.4, "expoOut")

            doTweenAlpha("Resume", "Resume", 0.8, 0.1, "expoOut")
            doTweenAlpha("Restart", "Restart", 1, 0.1, "expoOut")
            doTweenAlpha("Options", "Options", 0.8, 0.1, "expoOut")
            doTweenAlpha("Exit", "Exit", 0.8, 0.1, "expoOut")
        elseif curSelect == 4 then
            curSelect = 3

            doTweenX("ResumeSizeX", "Resume.scale", 1, 0.4, "expoOut")
            doTweenY("ResumeSizeY", "Resume.scale", 1, 0.4, "expoOut")

            doTweenX("RestartSizeX", "Restart.scale", 1, 0.4, "expoOut")
            doTweenY("RestartSizeY", "Restart.scale", 1, 0.4, "expoOut")

            doTweenX("OptionsSizeX", "Options.scale", 1.1, 0.4, "expoOut")
            doTweenY("OptionsSizeY", "Options.scale", 1.1, 0.4, "expoOut")

            doTweenX("ExitSizeX", "Exit.scale", 1, 0.4, "expoOut")
            doTweenY("ExitSizeY", "Exit.scale", 1, 0.4, "expoOut")

            doTweenAlpha("Resume", "Resume", 0.8, 0.1, "expoOut")
            doTweenAlpha("Restart", "Restart", 0.8, 0.1, "expoOut")
            doTweenAlpha("Options", "Options", 1, 0.1, "expoOut")
            doTweenAlpha("Exit", "Exit", 0.8, 0.1, "expoOut")
        elseif curSelect == 2 then
            curSelect = 1

            doTweenX("ResumeSizeX", "Resume.scale", 1.1, 0.4, "expoOut")
            doTweenY("ResumeSizeY", "Resume.scale", 1.1, 0.4, "expoOut")

            doTweenX("RestartSizeX", "Restart.scale", 1, 0.4, "expoOut")
            doTweenY("RestartSizeY", "Restart.scale", 1, 0.4, "expoOut")

            doTweenX("OptionsSizeX", "Options.scale", 1, 0.4, "expoOut")
            doTweenY("OptionsSizeY", "Options.scale", 1, 0.4, "expoOut")

            doTweenX("ExitSizeX", "Exit.scale", 1, 0.4, "expoOut")
            doTweenY("ExitSizeY", "Exit.scale", 1, 0.4, "expoOut")

            doTweenAlpha("Resume", "Resume", 1, 0.1, "expoOut")
            doTweenAlpha("Restart", "Restart", 0.8, 0.1, "expoOut")
            doTweenAlpha("Options", "Options", 0.8, 0.1, "expoOut")
            doTweenAlpha("Exit", "Exit", 0.8, 0.1, "expoOut")
        end
    end
    if keyboardJustPressed('ENTER') then
        if curSelect == 1 then
            doTweenAlpha("mewhena", "mewhen", 0, 0.2, 'linear')
            doTweenAlpha("mewhenaa", "mewhenagain", 0, 0.2, 'linear')
            for looky, button in ipairs(buttons) do
                doTweenAlpha(button .. "HEY", button, 0, 0.2, "linear")
            end
            doTweenAlpha("backdrop", "backdrop", 0, 0.2, "linear")
            inMenu = false
            doTweenAlpha("songNameBYE", "songName", 0, 0.2, "expoOut")
            doTweenAlpha("fade", "fade", 0, 0.2, 'linear')
            closeCustomSubstate();
        elseif curSelect == 2 then
            restartSong()
        elseif curSelect == 3 then
            runHaxeCode([[
                        import options.OptionsState;
                import backend.MusicBeatState;
                game.paused = true;
                game.vocals.volume = 0;
                MusicBeatState.switchState(new OptionsState());
                OptionsState.onPlayState = true;
                ]])
        elseif curSelect == 4 then
            exitSong()
        end
    end
end

-- pause menu?
