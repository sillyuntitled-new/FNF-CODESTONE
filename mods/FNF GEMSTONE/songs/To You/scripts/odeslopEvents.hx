introLength = 0;
public var MDP:Bool = 'noUI';
public var camAspect:FlxCamera;
var heart:FlxSprite = new FlxSprite(50, -280);
var frame:FlxSprite = new FlxSprite(0, 0);
var love:FlxSprite = new FlxSprite(143, 369);
var aspect:FlxSprite = new FlxSprite(0, 0);
var borderL:FlxSprite = new FlxSprite(-40, -120);
var borderR:FlxSprite = new FlxSprite(960, -120);


var realStageGroup = [
    'ground', 'iloveyou', 'signs', 'face', 'back'
];
var fakeStageGroup = [
    'bg'
];

function realStage(show:Bool) {
    for (elementName in realStageGroup) {
        var sprite = stage.getSprite(elementName);
        if (sprite != null) {
            sprite.visible = show;
        }
    }

    for (elementName in fakeStageGroup) {
        var sprite = stage.getSprite(elementName);
        if (sprite != null) {
            sprite.visible = !show;
        }
    }
}


function create(){
    GameOverSubstate.script = "data/scripts/gameOverWWCD"; 
    realStage(false); 

    heart.frames = Paths.getSparrowAtlas("stages/abbey/heart"); 
    heart.animation.addByPrefix("start", "heart start", 9, true);
    heart.animation.addByPrefix("anim", "heart anim", 9, false);
    heart.animation.addByPrefix("stay", "heart stay", 9, true);
    heart.alpha = 0;
    heart.antialiasing = true;
    add(heart);
    heart.animation.play("start");

    love.loadGraphic(Paths.image('stages/abbey/love')); 
    love.scale.set(1.7, 1.7);
    love.antialiasing = true;
    love.alpha = 0;
    add(love);

    aspect.loadGraphic(Paths.image('stages/abbey/aspect')); 
    add(aspect);

    frame.loadGraphic(Paths.image('stages/abbey/frame')); 
    frame.scale.set(0.67,0.67);
    frame.screenCenter();
    frame.alpha = 0;
    frame.antialiasing = true;
    add(frame);


    borderL.frames = Paths.getSparrowAtlas("stages/abbey/loveBorders"); 
    borderL.animation.addByPrefix("loop", "Symbol", 3, true);
    borderL.alpha = 0;
    borderL.scale.set(0.7, 0.7);
    borderL.antialiasing = true;
    add(borderL);
    borderL.animation.play("loop");

    borderR.frames = Paths.getSparrowAtlas("stages/abbey/loveBorders"); 
    borderR.animation.addByPrefix("loop", "Symbol", 3, true);
    borderR.alpha = 0;
    borderR.scale.set(-0.7, 0.7);
    borderR.antialiasing = true;
    add(borderR);
    borderR.animation.play("loop");


    heart.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int) {
        if (name == "anim" && heart.animation.finished) {
            heart.animation.play("stay");
        }
    };
}

function postCreate(){//UI STUFF
    camAspect = new FlxCamera();
    camAspect.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(camAspect, false);

    PlayState.instance.comboGroup.visible = false;
    frame.camera = camHUD;
    aspect.camera = camAspect;
    heart.cameras = [camBorder];
    borderL.cameras = [camAspect];
    borderR.cameras = [camAspect];
    MDP = 'noUI';
}

function onStrumCreation(e)
    e.sprite = "game/notes/red";

function onNoteCreation(e) {
    e.noteSprite = "game/notes/red";
    e.note.splash = "red";
}

function onSongStart(){
    for (playerStrum in playerStrums) FlxTween.tween(playerStrum, {alpha: 0}, 0.000001, {ease:FlxEase.quartOut});
    FlxTween.tween(heart, {alpha: 1}, 2.5, {ease:FlxEase.cubeInOut});
}

function beatHit(){
    if (curCameraTarget == 0){
        if (curBeat >= 203){
            camMoveAmount = 75;
        }
    } else {
        camMoveAmount = 25;
    }
}


function stepHit(s) {
    switch(s) {
        case 5:
            heart.animation.play("anim");
        case 25:
            FlxTween.tween(heart, {y: 200}, 1.8, {ease:FlxEase.quartIn});
            FlxTween.tween(heart, {alpha: 0}, 1.8, {ease:FlxEase.quartIn});
        case 48:
            FlxTween.tween(frame, {alpha: 1}, 1, {ease:FlxEase.quartOut});
            FlxTween.tween(stage.getSprite('box'), {alpha: 0}, 1, {ease:FlxEase.quartOut});
            for (playerStrum in playerStrums) FlxTween.tween(playerStrum, {alpha: 1}, 1, {ease:FlxEase.quartOut});
        case 816:
            realStage(true);
            FlxTween.tween(borderL, {alpha: 1}, 1.8, {ease:FlxEase.quartOut});
            FlxTween.tween(borderR, {alpha: 1}, 1.8, {ease:FlxEase.quartOut});
        case 1152:
            playerStrums.visible = false;
            stage.getSprite('box').alpha = 1;
            camMoveAmount = 0;
            love.alpha = 1;
            FlxTween.tween(frame, {alpha: 0}, 0.5, {ease:FlxEase.quartOut});
            FlxTween.tween(borderL, {alpha: 0}, 0.5, {ease:FlxEase.quartOut});
            FlxTween.tween(borderR, {alpha: 0}, 0.5, {ease:FlxEase.quartOut});
        case 1176:
            FlxTween.tween(love, {alpha: 0}, 0.15, {ease:FlxEase.quartOut});
        }
}