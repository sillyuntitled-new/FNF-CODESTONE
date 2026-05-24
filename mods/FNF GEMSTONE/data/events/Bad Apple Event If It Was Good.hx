// EVENT CODED BY BIMAGAMONGMOP. PLAY MY MOD: https://gamebanana.com/mods/501754
import openfl.geom.ColorTransform;

var bgRGB:Array<Int> = [];
var bfRGB:Array<Int> = [];
var dadRGB:Array<Int> = [];
var gfRGB:Array<Int> = [];
var staticRGB:Array<Int> = [];
var notesRGB:Array<Int> = [];
var staticOppRGB:Array<Int> = [];
var notesOppRGB:Array<Int> = [];
var bfHPRGB:Array<Int> = [];
var dadHPRGB:Array<Int> = [];
var easing:String = '';

var ignoreDad:Bool = false;
var ignoreBF:Bool = false;
var ignoreGF:Bool = false;
var ignoreIcons:Bool = false;
var ignoreBG:Bool = false;
var ignorePlayerStatic:Bool = false;
var ignorePlayerScrolling:Bool = false;
var ignoreOppStatic:Bool = false;
var ignoreOppScrolling:Bool = false;

function getRGB(color:FlxColor):Array<Int>{
	trace("RGB VALUES: " + [color >> 16 & 0xff, (color >> 8) & 0xff, color & 0xff]);
	return [color >> 16 & 0xff, (color >> 8) & 0xff, color & 0xff];
}

function onEvent(event){
    if(event.event.name == 'Bad Apple Event If It Was Good'){
        var time = event.event.params[0];
        easing = event.event.params[10] + event.event.params[11];

        ignoreDad = event.event.params[12];
        ignoreBF = event.event.params[13];
        ignoreGF = event.event.params[14];
        ignoreIcons = event.event.params[15];
        ignoreBG = event.event.params[16];
        ignorePlayerStatic = event.event.params[17];
        ignorePlayerScrolling = event.event.params[18];
        ignoreOppStatic = event.event.params[19];
        ignoreOppScrolling = event.event.params[20];

        var stageKeys:Array<String> = stage.stageSprites.keys();
        
        // chars
        var bfCol:FlxColor = event.event.params[2];
        bfRGB = getRGB(bfCol);
        var dadCol:FlxColor = event.event.params[3];
        dadRGB = getRGB(dadCol);
        var gfCol:FlxColor = event.event.params[4];
        gfRGB = getRGB(gfCol);

        // bg
        var bgCol:FlxColor = event.event.params[5];
        bgRGB = getRGB(bgCol);

        // player strums
        var staticCol:FlxColor = event.event.params[6];
        staticRGB = getRGB(staticCol);
        var notesCol:FlxColor = event.event.params[7];
        notesRGB = getRGB(notesCol);

        // opp strums
        var staticOppCol:FlxColor = event.event.params[8];
        staticOppRGB = getRGB(staticOppCol);
        var notesOppCol:FlxColor = event.event.params[9];
        notesOppRGB = getRGB(notesOppCol);

        // health icons
        var bfIconCol:FlxColor = boyfriend.iconColor;
        bfHPRGB = getRGB(bfIconCol);
        var dadIconCol:FlxColor = dad.iconColor;
        dadHPRGB = getRGB(dadIconCol);

        if(time == 0 || time == 0.0) time = 0.00001;

        if(event.event.params[1] == true){
            for(strum in strumLines.members) for(char in strum.characters) FlxTween.tween(char.colorTransform, {redMultiplier: 1, blueMultiplier: 1, greenMultiplier: 1, redOffset: 0, greenOffset: 0, blueOffset: 0}, time, {ease: getEaseFromStr(easing)});
            for (col in [iconP1.colorTransform, iconP2.colorTransform]) FlxTween.tween(col, {redMultiplier: 1, blueMultiplier: 1, greenMultiplier: 1, redOffset: 0, greenOffset: 0, blueOffset: 0}, time, {ease: getEaseFromStr(easing)});
            for (note in player.notes) FlxTween.tween(note.colorTransform, {redMultiplier: 1, blueMultiplier: 1, greenMultiplier: 1, redOffset: 0, greenOffset: 0, blueOffset: 0}, time, {ease: getEaseFromStr(easing)});
            for (note in player.members) FlxTween.tween(note.colorTransform, {redMultiplier: 1, blueMultiplier: 1, greenMultiplier: 1, redOffset: 0, greenOffset: 0, blueOffset: 0}, time, {ease: getEaseFromStr(easing)});
            for (note in cpu.notes) FlxTween.tween(note.colorTransform, {redMultiplier: 1, blueMultiplier: 1, greenMultiplier: 1, redOffset: 0, greenOffset: 0, blueOffset: 0}, time, {ease: getEaseFromStr(easing)});
            for (note in cpu.members) FlxTween.tween(note.colorTransform, {redMultiplier: 1, blueMultiplier: 1, greenMultiplier: 1, redOffset: 0, greenOffset: 0, blueOffset: 0}, time, {ease: getEaseFromStr(easing)});
            for (daBG in stageKeys) FlxTween.tween(stage.stageSprites.get(daBG).colorTransform, {redMultiplier: 1, blueMultiplier: 1, greenMultiplier: 1, redOffset: 0, greenOffset: 0, blueOffset: 0}, time, {ease: getEaseFromStr(easing)});
        }else{
            for(strum in strumLines.members){
                if(strum.data.type == 2) continue;
                for(char in strum.characters){
                    if(char.isPlayer && !ignoreBF) FlxTween.tween(char.colorTransform, {redMultiplier: 0, blueMultiplier: 0, greenMultiplier: 0, redOffset: bfRGB[0], greenOffset: bfRGB[1], blueOffset: bfRGB[2]}, time, {ease: getEaseFromStr(easing)});
                    if(!char.isPlayer && !ignoreDad) FlxTween.tween(char.colorTransform, {redMultiplier: 0, blueMultiplier: 0, greenMultiplier: 0, redOffset: dadRGB[0], greenOffset: dadRGB[1], blueOffset: dadRGB[2]}, time, {ease: getEaseFromStr(easing)});
                }
            }
            if(!ignoreIcons){
                FlxTween.tween(iconP1.colorTransform, {redMultiplier: 0, blueMultiplier: 0, greenMultiplier: 0, redOffset: bfHPRGB[0], greenOffset: bfHPRGB[1], blueOffset: bfHPRGB[2]}, time, {ease: getEaseFromStr(easing)});
                FlxTween.tween(iconP2.colorTransform, {redMultiplier: 0, blueMultiplier: 0, greenMultiplier: 0, redOffset: dadHPRGB[0], greenOffset: dadHPRGB[1], blueOffset: dadHPRGB[2]}, time, {ease: getEaseFromStr(easing)});
            }
            if(!ignoreGF){
                for(strum in strumLines.members){
                    if(strum.data.type == 0 || strum.data.type == 1) continue;
                    for(char in strum.characters) FlxTween.tween(char.colorTransform, {redMultiplier: 0, blueMultiplier: 0, greenMultiplier: 0, redOffset: gfRGB[0], greenOffset: gfRGB[1], blueOffset: gfRGB[2]}, time, {ease: getEaseFromStr(easing)});
                }
            }
            if(!ignoreBG) for (daBG in stageKeys) FlxTween.tween(stage.stageSprites.get(daBG).colorTransform, {redMultiplier: 0, blueMultiplier: 0, greenMultiplier: 0, redOffset: bgRGB[0], greenOffset: bgRGB[1], blueOffset: bgRGB[2]}, time, {ease: getEaseFromStr(easing)});
            if(!ignorePlayerStatic) for (note in player.members) FlxTween.tween(note.colorTransform, {redMultiplier: 0, blueMultiplier: 0, greenMultiplier: 0, redOffset: staticRGB[0], greenOffset: staticRGB[1], blueOffset: staticRGB[2]}, time, {ease: getEaseFromStr(easing)});
            if(!ignorePlayerScrolling) for (note in player.notes) FlxTween.tween(note.colorTransform, {redMultiplier: 0, blueMultiplier: 0, greenMultiplier: 0, redOffset: notesRGB[0], greenOffset: notesRGB[1], blueOffset: notesRGB[2]}, time, {ease: getEaseFromStr(easing)});
            if(!ignoreOppStatic) for (note in cpu.members) FlxTween.tween(note.colorTransform, {redMultiplier: 0, blueMultiplier: 0, greenMultiplier: 0, redOffset: staticOppRGB[0], greenOffset: staticOppRGB[1], blueOffset: staticOppRGB[2]}, time, {ease: getEaseFromStr(easing)});
            if(!ignoreOppScrolling) for (note in cpu.notes) FlxTween.tween(note.colorTransform, {redMultiplier: 0, blueMultiplier: 0, greenMultiplier: 0, redOffset: notesOppRGB[0], greenOffset: notesOppRGB[1], blueOffset: notesOppRGB[2]}, time, {ease: getEaseFromStr(easing)});          
        }
    }
}

function getEaseFromStr(?ease:String = ''){
	switch(ease.toLowerCase()){
		case 'backin': return FlxEase.backIn;
		case 'backinout': return FlxEase.backInOut;
		case 'backout': return FlxEase.backOut;
		case 'bouncein': return FlxEase.bounceIn;
		case 'bounceinout': return FlxEase.bounceInOut;
		case 'bounceout': return FlxEase.bounceOut;
		case 'circin': return FlxEase.circIn;
		case 'circinout': return FlxEase.circInOut;
		case 'circout': return FlxEase.circOut;
		case 'cubein': return FlxEase.cubeIn;
		case 'cubeinout': return FlxEase.cubeInOut;
		case 'cubeout': return FlxEase.cubeOut;
		case 'elasticin': return FlxEase.elasticIn;
		case 'elasticinout': return FlxEase.elasticInOut;
		case 'elasticout': return FlxEase.elasticOut;
		case 'expoin': return FlxEase.expoIn;
		case 'expoinout': return FlxEase.expoInOut;
		case 'expoout': return FlxEase.expoOut;
		case 'quadin': return FlxEase.quadIn;
		case 'quadinout': return FlxEase.quadInOut;
		case 'quadout': return FlxEase.quadOut;
		case 'quartin': return FlxEase.quartIn;
		case 'quartinout': return FlxEase.quartInOut;
		case 'quartout': return FlxEase.quartOut;
		case 'quintin': return FlxEase.quintIn;
		case 'quintinout': return FlxEase.quintInOut;
		case 'quintout': return FlxEase.quintOut;
		case 'sinein': return FlxEase.sineIn;
		case 'sineinout': return FlxEase.sineInOut;
		case 'sineout': return FlxEase.sineOut;
		case 'smoothstepin': return FlxEase.smoothStepIn;
		case 'smoothstepinout': return FlxEase.smoothStepInOut;
		case 'smoothstepout': return FlxEase.smoothStepInOut;
		case 'smootherstepin': return FlxEase.smootherStepIn;
		case 'smootherstepinout': return FlxEase.smootherStepInOut;
		case 'smootherstepout': return FlxEase.smootherStepOut;
        default: return FlxEase.linear;
	}
	return FlxEase.linear;
}