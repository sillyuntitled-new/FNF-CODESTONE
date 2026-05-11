import funkin.backend.utils.NdllUtil;
import openfl.system.Capabilities;

// WINDOW SIZE CHANGE VAR
public var resizex:Int = Capabilities.screenResolutionX / 1.5;
public var resizey:Int = Capabilities.screenResolutionY / 1.5;

// MONITOR RESOLUTION
public var fsX:Int = Capabilities.screenResolutionX;
public var fsY:Int = Capabilities.screenResolutionY;

// DEFAULT WINDOW POSITIONS
public var winX:Int = fsX / 3;
public var winY:Int = fsY / 3;

window.x = winX;
window.y = winY;
window.width = fsX / 3;
window.height = fsY / 3;
changex = window.x;
changey = window.y;
window.fullscreen = false;
window.resizable = true;
window.borderless = true;
var mCam:FlxCamera;
var bCam:FlxCamera;
var setTransparency = NdllUtil.getFunction("ndllexample", "ndllexample_set_windows_transparent", 4);
var defY = 0;

function postCreate() {
	setTransparency(true, 5, 5, 5);
	FlxG.cameras.remove(camHUD, false);
        mCam = new FlxCamera(0, 100, 500, 500);
        mCam.bgColor = FlxColor.WHITE;
        FlxG.cameras.add(mCam);

        bCam = new FlxCamera(780, 100, 500, 500);
        bCam.bgColor = FlxColor.WHITE;
        FlxG.cameras.add(bCam);

	FlxG.cameras.add(camHUD, false);

    	trans = new FlxSprite();
	trans.makeGraphic(2000, 2000, FlxColor.fromRGB(5,5,5,255));
	trans.screenCenter();
	trans.camera = camGame;
	trans.origin.set(0, 0);
	add(trans);

	dad.x -= 50;
	gf.visible = false;


    	for (i in [missesTxt, accuracyTxt, scoreTxt, healthBar, healthBarBG, iconP1, iconP2]) {
        	i.visible = false;
    	}

	for (i in 0...4) {
    		playerStrums.members[i].x = 400 + i * 120;
    		cpuStrums.members[i].x = -1000;
	}

	defY = playerStrums.members[1].y;

	comboGroup.cameras = [camHUD];
	for (strum in strumLines) {
		for (note in strum.notes) {
			if (note.isSustainNote) {
			note.alpha = 1;
			}
    		}
	}
}


function update(elapsed) {
	mCam.scroll.x = dad.x - 50;
	mCam.scroll.y = dad.y + 50;
	bCam.scroll.x = boyfriend.x - 50;
	bCam.scroll.y = boyfriend.y + 200;
	camHUD.zoom = 1;
	camGame.scroll.x = 0;
	camGame.scroll.y = 200;
	defaultCamZoom = 0.5;
	FlxG.camera.followLerp = 0.01;
}

function destroy() {
	trace("destroyed");
	setTransparency(false, 5, 5, 5);
	window.borderless = false;
}
function beatHit(curBeat) {
	FlxTween.tween(window, {y:winY - 50}, Conductor.crochet / 2 / 1000, {ease:FlxEase.quadOut, onComplete:fall});
	FlxTween.tween(mCam, {y:100 + 50}, Conductor.crochet / 2 / 1000, {ease:FlxEase.quadOut, onComplete:fallL});
	FlxTween.tween(bCam, {y:100 + 50}, Conductor.crochet / 2 / 1000, {ease:FlxEase.quadOut, onComplete:fallR});
	if (curBeat % 2 == 0) {
	for (i in 0...2) {
    		playerStrums.members[i].x = (500) + i * 120;
    		playerStrums.members[i].y = defY - 50;
		FlxTween.tween(playerStrums.members[i], {x: 400 + i * 120, y:defY}, Conductor.crochet / 2 / 1000, {ease:FlxEase.quadOut});
	}
	for (i in 2...4) {
    		playerStrums.members[i].x = (300) + i * 120;
    		playerStrums.members[i].y = defY - 50;
		FlxTween.tween(playerStrums.members[i], {x: 400 + i * 120, y:defY}, Conductor.crochet / 2 / 1000, {ease:FlxEase.quadOut});
	}
	} else {
	for (i in 0...2) {
    		playerStrums.members[i].x = (300) + i * 120;
    		playerStrums.members[i].y = defY - 50;
		FlxTween.tween(playerStrums.members[i], {x: 400 + i * 120, y:defY}, Conductor.crochet / 2 / 1000, {ease:FlxEase.quadOut});
	}
	for (i in 2...4) {
    		playerStrums.members[i].x = (500) + i * 120;
    		playerStrums.members[i].y = defY - 50;
		FlxTween.tween(playerStrums.members[i], {x: 400 + i * 120, y:defY}, Conductor.crochet / 2 / 1000, {ease:FlxEase.quadOut});
	}
	}
	trace(curBeat % 4);
}

function fall() {
	FlxTween.tween(window, {y:winY}, Conductor.crochet / 2 / 1000, {ease:FlxEase.quadIn,});
}
function fallL() {
	FlxTween.tween(mCam, {y:100}, Conductor.crochet / 2 / 1000, {ease:FlxEase.quadIn,});
}
function fallR() {
	FlxTween.tween(bCam, {y:100}, Conductor.crochet / 2 / 1000, {ease:FlxEase.quadIn,});
}

function postUpdate() {
	PlayState.instance.comboGroup.visible = false;
	add(PlayState.instance.comboGroup);
}