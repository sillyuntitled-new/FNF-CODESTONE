var grpUnderlay:FlxGroup;

var underlayAlpha:Float = FlxG.save.data.underlay_alphaFactor;

function postCreate()
{
    insert(members.indexOf(strumLines), grpUnderlay = new FlxGroup());

    for (strumLine in strumLines.members)
        if (strumLine.visible)
            for (strum in strumLine.members)
            {
                var spr:FunkinSprite = grpUnderlay.add(new FunkinSprite().makeGraphic(1, strum.camera.height, FlxColor.BLACK));
                spr.scale.x = strum.width;
                spr.updateHitbox();
                spr.camera = camHUD;
                spr.extra["__linkedStrum"] = strum;
            }

    updateUnderlay();
}

function updateUnderlay()
    for (underlay in grpUnderlay.members)
    {
        var strum:Strum = underlay.extra["__linkedStrum"];

        underlay.origin.y = strum.y + strum.height / 2;
        underlay.alpha = strum.alpha * underlayAlpha;
        underlay.x = strum.x + (strum.width - underlay.width) / 2;
        underlay.angle = underlay.frameOffsetAngle = strum.angle % 360;
    }

function update(elapsed:Float)
    updateUnderlay();