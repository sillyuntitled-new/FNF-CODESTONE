import funkin.backend.assets.ModsFolder;
import funkin.backend.system.framerate.SystemInfo;
import funkin.backend.system.macros.GitCommitMacro;
var ascii ="
                     AAAAAAAAAAA
                 AAAAAAAAAAAAAAAAAAA
               AAAAA             AAAAA
             AAAAx                  AAAA
            AAAf                     JAAA
           AAA                        AAA
          AAA            yKS          LAA
          AAZ         wAAAAAAA        LAA
          AA         FAAA  AAA        AAA
          AA         AAA  AAA1        AAA
          AAA       NAAAAAAA         AAA
          AAAF     cAAAAAAz        AAAA
           AAAA   AAAAAH         eAAAA
            AAAAAAAAAA        pAAAAA
                    AA     AAAAAA
                    AA    AAAA
                    AA    AAA
                    AA    AAA
                    AAAATAAAA
                   AAAAAAAAAAA
                 AAAAAy   uAAAAA
                AAAT         AAA
                AAA          ZAAA
                AAA          AAAA
                AAAB        BAAA
                 AAAAAAAAAAAAAA
                   AAAAAAAAAA
"; // yep

var bg:FlxSprite;
var selectionUnderlay:FlxSprite;

var loadModMock:FunkinText;

var lastBeat:Int = 0;
var mods:Array<String>;
var libraries:Array<String>;

var options = [];
var selection = 0;

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
    var t = new FunkinText(x, y, 0, str, 16, outline);
    t.antialiasing = Options.antialiasing;
    t.alignment = align;
    t.font = Paths.font("perfectdos.ttf");
    return t;
}

function create() {

    mods = ModsFolder.getModsList();
    mods.push(null);

    libraries = ModsFolder.getLoadedMods();

    bg = makeRect(0, 0, FlxG.width, FlxG.height, 0x44ffffff);
    add(bg);

    var asc = makeText(16, 16, ascii, 10);
    asc.size = 12;
    asc.x = FlxG.width - asc.width - 16;
    asc.color = 0xffb265bd;
    add(asc);

    var nfetchHeader = "Codename Engine" + (GitCommitMacro.commitHash != null ? " | Commit #" + GitCommitMacro.commitNumber + ", " + GitCommitMacro.commitHash : "");

    var neofetch = makeText(16, 16, "", 10, "right");
    neofetch.text = nfetchHeader+ "\n"+
                    repeat("-", nfetchHeader.length) + "\n"+
                    "OS: " + SystemInfo.osInfo + "\n"+
                    "CPU: " + SystemInfo.cpuName + "\n"+
                    "GPU: " + SystemInfo.gpuName +"\n\n"+
                    "Libraries: " + libraries.length + "\n" +
                    "Mods: " + (mods.length - 1);


    neofetch.size = 12;
    neofetch.x = FlxG.width - asc.width - 16 - neofetch.width;
    add(neofetch);

    selectionUnderlay = makeRect(16, 16, 1, 16, 0xffffffff);
    selectionUnderlay.origin.x = 0;
    add(selectionUnderlay);

    loadModMock = makeText(16, FlxG.height - 16 * 2, "$ funkin.backend.assets.ModsFolder.switchMod(\"idk bro\")");
    add(loadModMock);


    add(makeText(16, 16, "[ESCAPE] - return to main menu\n[  F6  ] - reload current mod\n[RETURN] - load selected mod\n\ncurrently loaded: " + ModsFolder.currentModFolder));

    for (i in 0...mods.length) {
        var letext = makeText(16, 128 + 16 * i, mods[i] ?? "Disable Mods", 16, "left", false);
        add(letext);
        options.push(letext);
    }
}

function update(delta) {
    if (lastBeat != curBeat) {
        lastBeat = curBeat;
        onBeatHit();
    }

    if (bg.alpha > 0) bg.alpha -= delta * Conductor.crochet / 1000;

    if (FlxG.keys.justPressed.ESCAPE) {
        FlxG.switchState(new MainMenuState());
        CoolUtil.playMenuSFX(2);
    }
    if (FlxG.keys.justPressed.F6) {
        CoolUtil.playMenuSFX(2);
        FlxG.sound.music.fadeOut(0.3, 0);
        ModsFolder.reloadMods();
    };

    changeSelection((controls.DOWN_P ? 1 : 0) + (controls.UP_P ? -1 : 0) - FlxG.mouse.wheel);

    selectionUnderlay.y = 128 + 16 * selection;
    selectionUnderlay.scale.x = options[selection].width;

    for (i in 0...options.length) {
        options[i].color = (i == selection ? 0xff000000 : 0xffffffff);
    }

    loadModMock.text = "$ funkin.backend.assets.ModsFolder.switchMod(\"" + StringTools.replace(mods[selection], "\'", "\\\'") + "\")";
    if (mods[selection] == null) loadModMock.text = "$ funkin.backend.assets.ModsFolder.switchMod(null)";

    if (controls.ACCEPT) {
        CoolUtil.playMenuSFX(2);
        FlxG.sound.music.fadeOut(1, 0);
        ModsFolder.switchMod(mods[selection]);
    }

}

function changeSelection(delta) {
    if (delta == 0) return;
    CoolUtil.playMenuSFX(0);
    selection = FlxMath.wrap(selection + delta, 0, mods.length-1);
}

function onBeatHit() {
    bg.alpha = Math.sin(curMeasureFloat) * 0.05 + 0.1;
}
