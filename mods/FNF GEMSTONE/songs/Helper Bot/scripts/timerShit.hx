import flixel.util.FlxStringUtil;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxSpriteUtil;

var remainingTime, timeTxt, remainingHiders, distanceTxt:FunkinText;
var white:FunkinSprite;
var playerAmt:Int = FlxG.random.int(8, 13);
public var playerRemaining:Int = playerAmt;

function postCreate() {
    remainingTime = new FunkinText(0, 80, FlxG.width, 'Time Remaining:');
    remainingTime.setFormat(Paths.font('newRobloxBold.ttf'), 30, FlxColor.WHITE, 'center');
    remainingTime.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
    remainingTime.camera = newHUDcam;
    add(remainingTime);

    timeTxt = new FunkinText(0, 110, FlxG.width, 'Time Remaining:\n' + FlxStringUtil.formatTime(inst.length));
    timeTxt.setFormat(Paths.font('newRobloxBold.ttf'), 38, FlxColor.WHITE, 'center');
    timeTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
    timeTxt.camera = newHUDcam;
    add(timeTxt);

    add(white = FlxSpriteUtil.drawRoundRect(new FunkinSprite(10, FlxG.height - 35).makeGraphic(300, 40, FlxColor.TRANSPARENT), 0, 0, 300, 40, 5, 5, FlxColor.WHITE)).camera = newHUDcam;

    distanceTxt = new FunkinText(-480, FlxG.height - 30, FlxG.width, 'It is 400.00 studs away');
    distanceTxt.setFormat(Paths.font('newRobloxBold.ttf'), 20, 0xFF27292B, 'center');
    distanceTxt.camera = newHUDcam;
    add(distanceTxt);

    remainingHiders = new FunkinText(520, 80, FlxG.width, playerAmt + '/' + playerAmt);
    remainingHiders.setFormat(Paths.font('newRobloxBold.ttf'), 50, FlxColor.WHITE, 'center');
    remainingHiders.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
    remainingHiders.camera = newHUDcam;
    add(remainingHiders);

    var aliveTxt = new FunkinText(520, 140, FlxG.width, 'Hiders Alive');
    aliveTxt.setFormat(Paths.font('newRobloxBold.ttf'), 35, FlxColor.WHITE, 'center');
    aliveTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
    aliveTxt.camera = newHUDcam;
    add(aliveTxt);
}

function beatHit(curBeat:Int) {
    if (FlxG.random.bool(1) && playerRemaining > 3){
        if (PlayState.difficulty == 'pico' && canGo) remaining(1);
        else if (PlayState.difficulty != 'pico') remaining(1);
        new FlxTimer().start(FlxG.random.float(1, 4), () -> sendRandomChatMessage());
    }
}

var distance = 400.00;
var elapsedTime = 0;
var isLeft = true;
function postUpdate(elapsed:Float) {
    timeTxt.text = FlxStringUtil.formatTime((inst.length - Conductor.songPosition) / 1000);
    elapsedTime += elapsed;

    if (PlayState.difficulty == 'pico') {
        if (elapsedTime >= 0.2){
            elapsedTime = 0;
            var actualDistance = Math.sqrt(Math.pow(it.getMidpoint().x - boyfriend.getMidpoint().x, 2) + Math.pow(it.getMidpoint().y - boyfriend.getMidpoint().y, 2)) * 0.01;
            distance = lerp(distance, actualDistance, 0.1);
        }
    } else {
        if (elapsedTime >= 0.2){
            elapsedTime = 0;
            distance += isLeft ? FlxG.random.float(0, 10) : FlxG.random.float(-10, 0);
        }
        if (FlxG.random.bool(0.01)) isLeft = !isLeft;
        if (distance >= 600) isLeft = false;
        if (distance <= 50) isLeft = true;
    }
    
    distanceTxt.text = 'It is ' + addEndZeros(FlxMath.roundDecimal(distance, 2), 2) + ' studs away';

    camHUD.scroll.x = camGame.scroll.x;
    camHUD.scroll.y = camGame.scroll.y;
}

public static function remaining(value:Float) {
    playerRemaining -= value;
    remainingHiders.text = Std.int(playerRemaining) + '/' + playerAmt;
}

function addEndZeros(value:Float, totalDecimals:Int):String {
    var parts = Std.string(value).split(".");
    var decimalPart = if (parts.length > 1) parts[1] else "";
    while (decimalPart.length < totalDecimals) decimalPart += "0";
    return parts[0] + "." + decimalPart;
}