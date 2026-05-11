import flixel.util.FlxStringUtil;
import flixel.group.FlxTypedGroup;

import funkin.menus.FreeplaySonglist;
import funkin.game.PlayState;
import funkin.savedata.FunkinSave;

// these two got nuked lmaooo
//import funkin.vis.dsp.SpectralAnalyzer;
//import funkin.vis.dsp.FFT;

import funkin.backend.utils.AudioAnalyzer;

import Type;
import Reflect;
using StringTools;

/**
 * A more familiar interpolation formula. 
 * Adapted from Claire's `ccInterp()` function from her Lua scripts.
 * 
 * Returns the difference needed. Think of this as a different version of `CoolUtils`' `fpsLerp()` function.
 * 
 * @param   delta       Time elapsed since the previous frame in seconds.
 * @param   value       The value to interpolate.
 * @param   target      The value to interpolate to. 
 * @param   timescale   The speed of the interpolation.
 */
function clefInterp(delta, value, target, timescale = 1) {
    if (value > target) return delta * (Math.abs(value - target) * timescale);
    if (value < target) return delta * (Math.abs(value - target) * -timescale);
    return value;
}

/**
 * A familiar rectangle function.
 * Condensed form of Claire's `ccRect()` function from her Lua scripts.
 * 
 * @param   x           X position of the sprite.
 * @param   y           Y position of the sprite.
 * @param   w           Width of the rectangle.
 * @param   h           Height of the rectangle.
 * @param   col         Color of the rectangle.
 */
function makeRect(x, y, w, h, col) {
    s = new FlxSprite(x,y).makeGraphic(w,h,col);
    return s;
}

function repeat(char, loops = 0) {
    if (loops <= 0) return "";

    var str = "";
    for (i in 0...loops) {
        str += char;
    }

    return str;
}

function makeText(x, y, str = "", size = 16, align = "left", outline = true) {
    var t = new FunkinText(x, y, 0, str, size, outline);
    t.antialiasing = Options.antialiasing;
    t.alignment = align;
//     t.font = Paths.font("perfectdos.ttf");
    return t;
}

var selection = 0;
function changeSelection(delta, reference) {
    if (delta == 0 || reference == null) return;
    selection += delta;
    if (selection > reference.length-1) selection = 0;
    if (selection < 0) selection = reference.length - 1;

//     trace(selection + " / " + reference.length);

    CoolUtil.playMenuSFX(0);
}

var visBar:FlxSprite;
var spect:AudioAnalyzer;

var bg;
var songList;
var group = [];

var diffText;

var gap = 64;
var selectionY = 0;
var isSelected = false;
var transitioningOut = false;

var modeNum     = 0;
var lastModeNum = 0;
var currentMode = [
    "Solo",
    "Opponent",
    "Co-Op",
    "Swapped Co-Op"
];

var customValuesText;
var pbText;

var menuSong_Seekhead:Float = 0;
var menuSong_Tempo:Float = 0;
var menuSong_TimeSig:String = "4 4";

var inst:FlxSound;

var selectedDiff = 0;
function changeDiff(delta, reference) {
    if (delta == 0 || reference == null) return;
    selectedDiff += delta;
    if (selectedDiff > reference.length-1) selectedDiff = 0;
    if (selectedDiff < 0) selectedDiff = reference.length - 1;

//     trace(selection + " / " + reference.length);

    CoolUtil.playMenuSFX(0);
}

function postCreate() {

    if (!FlxG.sound.music.playing) CoolUtil.playMenuSong();

    add(new FlxSprite(0, 0).loadGraphic(Paths.image('menus/menuEditors')));
    bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/menuTransparent'));
    add(bg);

    visBar = makeRect(1,1,128,1,0x60ffffff);
    visBar.origin.set(128, 0);
    add(visBar);

    customValuesText = new FunkinText(16, 16, FlxG.width * 0.33, "", 16, true);
    customValuesText.antialiasing = Options.antialiasing;
    customValuesText.alignment = "right";
    add(customValuesText);

    pbText = new FunkinText(16, 16, FlxG.width * 0.16, "", 16, true);
    pbText.antialiasing = Options.antialiasing;
    pbText.alignment = "right";
    add(pbText);

    songList = FreeplaySonglist.get();

    diffText = makeText(32, 96, "", 20);
    add(diffText);

    for (i in 0...songList.songs.length) {
        //var text = makeText(0, i * gap, (songList.songs[i] == null ? "Random" : songList.songs[i].displayName), 24, "false");
        var text = new Alphabet(0, i * gap, (songList.songs[i] == null ? "Random" : songList.songs[i].displayName), false, false);
        group.push(text);
        add(text);
    }
    spect = new AudioAnalyzer(FlxG.sound.music);
}


var levels = [];
var cache = [];
var numBars = 256;

function postDraw() {
    if (spect != null && spect.sound.playing) drawFourier();

     for (i in 0...levels.length-1) {
        visBar.y = i * (FlxG.height / numBars);
        visBar.scale.x = levels[i] * (3 - 2 * diffText.alpha);
        visBar.x = FlxG.width / 2 - (visBar.width / 2) + ((FlxG.width / 2 - (visBar.width / 2)) * (diffText.alpha));
        visBar.origin.set((visBar.width - (visBar.width / 2 * (1-diffText.alpha))), 0);
        visBar.draw();
    }

//     if (levels.length > FlxG.height) levels.shift();
}

function drawFourier() {

    levels = spect.getLevels(Conductor.songPosition, numBars, cache);
    
}

function formatCaps(input) {
    // yanderedev ass code
    var caps = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" ];
    var temp = input.substring(1);

    for (c in caps) {
        temp = StringTools.replace(temp, c, " " + c);
    }

    // TODO: fill this out
    return input.charAt(0).toUpperCase() + temp;
}

var playingInst = false;

var randomPeak  = 0;
var randomDelta = 0;
var delayRandom = 0;
function postUpdate(delta) {
    numBars = FlxG.height;

    if (!isSelected) changeSelection((controls.DOWN_P ? 1 : 0) + (controls.UP_P ? -1 : 0) - FlxG.mouse.wheel, group);

    selectionY -= clefInterp(delta, selectionY, selection * gap - (isSelected ? FlxG.height / 2 * -1 + 10 : 0), 10);

    for (i in 0...group.length) {
        if (!transitioningOut) group[i].y = (FlxG.height / 2) + (i * gap) - selectionY;
        group[i].x -= clefInterp(delta, group[i].x, (selection == i ? (isSelected ? 32 : 64) : (isSelected ? 0 : 16)), 10);
        group[i].alpha = group[i].x /32;
    }

    bg.color = (songList.songs[selection] == null ? 0xffffffff : songList.songs[selection].color);

    if (controls.RESET) {
        randomPeak = randomDelta = FlxG.random.int(0-songList.songs.length - 2, songList.songs.length - 2);
        isSelected = true;
    }

    if (controls.SWITCHMOD && isSelected) {
        if (!playingInst) {
            // save conductor status
            menuSong_Seekhead = Conductor.songPosition;
            menuSong_Tempo = Conductor.bpm;
            menuSong_TimeSig = Conductor.beatsPerMeasure + " " + Conductor.stepsPerBeat;

            // play the instrumental
            FlxG.sound.music.stop();
            FlxG.sound.music = FlxG.sound.load(Paths.inst(songList.songs[selection].name));
            FlxG.sound.music.play();
            Conductor.changeBPM(songList.songs[selection].bpm, songList.songs[selection].beatsPerMeasure, songList.songs[selection].stepsPerBeat);

            // refresh vis
            spect = new AudioAnalyzer(FlxG.sound.music);

        } else {

            // restore conductor status
            FlxG.sound.music.stop();
            CoolUtil.playMenuSong();
            FlxG.sound.music.time = Conductor.songPosition = menuSong_Seekhead;
            Conductor.changeBPM(menuSong_Tempo, menuSong_TimeSig.split(" ")[0], menuSong_TimeSig.split(" ")[1]);

            // refresh vis
            spect = new AudioAnalyzer(FlxG.sound.music);
        }
        playingInst = !playingInst;
    }

    if (controls.ACCEPT) {
        CoolUtil.playMenuSFX(1);
        if (!isSelected) {
            if (songList.songs[selection] == null) {
                randomPeak = randomDelta = FlxG.random.int(0-songList.songs.length - 2, songList.songs.length - 2);
                isSelected = true;
            } else {
                isSelected = true;
            }
        } else {
            trace("| "+songList.songs[selection].name);
            trace("| "+(songList.songs[selection].difficulties == null ? null : songList.songs[selection].difficulties[selectedDiff]));
            trace("| "+modeNum == 1 || modeNum == 3);
            trace("| "+modeNum > 1);
            PlayState.loadSong(songList.songs[selection].name, (songList.songs[selection].difficulties == null ? null : songList.songs[selection].difficulties[selectedDiff]), (modeNum == 1 || modeNum == 3), modeNum > 1);
            FlxG.switchState(new PlayState());
        }
    }

    if (randomDelta != 0) {
        delayRandom -= delta;
    }

    if (randomDelta != 0) {
        changeSelection(randomDelta, group);
        randomDelta = 0;
    }

    if (controls.BACK) {
        if (isSelected && group.length > 1) {
            isSelected = false;
            CoolUtil.playMenuSFX(2);
        } else {
            CoolUtil.playMenuSFX(2);
            FlxG.switchState(new MainMenuState());
        }
    }

    if (group.length == 1) isSelected = true;

    if (isSelected && (songList.songs[selection] != null)) {
        if (songList.songs[selection].difficulties != null) changeDiff((controls.DOWN_P ? 1 : 0) + (controls.UP_P ? -1 : 0) - FlxG.mouse.wheel, songList.songs[selection].difficulties);

        if (selectedDiff > songList.songs[selection].difficulties.length-1) selectedDiff = (songList.songs[selection].difficulties.length - 1);

        if (controls.LEFT_P)  modeNum--;
        if (controls.RIGHT_P) modeNum++;

        //yanderedev method
               if ( songList.songs[selection].opponentModeAllowed &&  songList.songs[selection].coopAllowed) {
            if (modeNum > 3) modeNum = 0;
            if (modeNum < 0) modeNum = 3;
        } else if ( songList.songs[selection].opponentModeAllowed && !songList.songs[selection].coopAllowed) {
            if (modeNum > 1) modeNum = 0;
            if (modeNum < 0) modeNum = 1;
        } else if (!songList.songs[selection].opponentModeAllowed &&  songList.songs[selection].coopAllowed) {
            if (modeNum ==1) modeNum = (lastModeNum < 1 ? 2 : 0);
            if (modeNum > 2) modeNum = 0;
            if (modeNum < 0) modeNum = 2;
        } else {
            modeNum = 0;
        }

        lastModeNum = modeNum;

        if (songList.songs[selection].difficulties != null && isSelected) {
            diffText.text = currentMode[modeNum]+"\n\n";
            for (i in songList.songs[selection].difficulties) {
                diffText.text += (songList.songs[selection].difficulties[selectedDiff] == i ? "> " : "| ")+i+"\n";
            }
        } else {
            diffText.text = "Normal";
        }
    }

    diffText.x -= clefInterp(delta, diffText.x, (isSelected ? 32 : 0), 10);
    diffText.alpha = (diffText.x / 32);

    if (songList.songs[selection] != null ){
        var hs = FunkinSave.getSongHighscore(songList.songs[selection].name, (songList.songs[selection].difficulties == null ? "normal" : songList.songs[selection].difficulties[selectedDiff]));
        pbText.text = "Personal Best\n" + (hs.score > 0 ? hs.score + "\n" + FlxStringUtil.formatMoney(hs.accuracy * 100,true,true) + "%\n" + (hs.misses == 0 ? "Full Combo" : hs.misses + (hs.misses > 1 ? " misses" : " miss")) +
                      "\n" + hs.date : "Unplayed");


        customValuesText.text = "Tempo\n"+songList.songs[selection].bpm +
                                "\n\nTime Signature\n"+songList.songs[selection].beatsPerMeasure + "/"+songList.songs[selection].stepsPerBeat +
                                "\n\n" + (songList.songs[selection].coopAllowed || songList.songs[selection].opponentModeAllowed ? (songList.songs[selection].opponentModeAllowed ? "Opponent Mode" : "\n\n") + (songList.songs[selection].coopAllowed ? "\nCo-op Mode" : "\n") : "") + "\n\n";
        if (songList.songs[selection].customValues != null) {
            var fields = Reflect.fields(songList.songs[selection].customValues);

            for (f in fields) {
                customValuesText.text += formatCaps(f) + "\n" + Reflect.field(songList.songs[selection].customValues, f) + "\n\n";
            }
        }
    } else {
        pbText.text = "";
    }

    customValuesText.x = FlxG.width - (diffText.alpha * 16) - customValuesText.width;
    customValuesText.alpha = diffText.alpha;

   


    pbText.x = FlxG.width - (diffText.alpha * 150) - 16 - pbText.width;
}

function destroy() {
    if (inst != null) inst.stop();
    if (!FlxG.sound.music.playing) CoolUtil.playMenuSong();

}