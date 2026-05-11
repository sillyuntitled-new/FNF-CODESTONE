//

var newBG:FlxSprite;
var backDrop:FlxSprite;
var story_mode:FlxSprite;

function create() {
    newBG = new FlxSprite(0, 0).loadGraphic(Paths.image("bg"));
    newBG.scale.set(1.15, 1.15);
    newBG.updateHitbox();
    newBG.scrollFactor.set();
    newBG.screenCenter();
    add(newBG);

    backDrop = new FlxSprite(0, 0).loadGraphic(Paths.image("backDrop"));
    backDrop.updateHitbox();
    backDrop.scrollFactor.set();
    backDrop.screenCenter(FlxAxes.Y);
    add(backDrop);

    story_mode = new FlxSprite(0, 0).loadGraphic(Paths.image("story_mode"));
    story_mode.updateHitbox();
    story_mode.scrollFactor.set();
    story_mode.screenCenter(FlxAxes.Y);
    add(story_mode);
}

function postCreate() {
    bg.destroy();

    forceCenterX = false;
    for (i => button in menuItems.members)
        button.x -= button.x - 20;
}

import funkin.editors.ui.UIState;

function postUpdate() {
if (FlxG.keys.justPressed.P) FlxG.switchState(new UIState(true, "PasswordState")); 
}