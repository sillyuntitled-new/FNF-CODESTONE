function onEvent(e) { // almost the same as the camera movents BTW IF YOU'D LIKE TO USE THIS SCRIPT CREDIT ME FIRST ->> JDANIEL ALEATORIO
    if(e.event.name == 'Middle Focus') {
        var dataBF = getStrumlineCamPos(e.event.params[3]);
        var dataDAD = getStrumlineCamPos(e.event.params[4]);

        var middlePosition = { // I feel so smart
            x: FlxMath.lerp(dataBF.pos.x, dataDAD.pos.x, 0.5), 
            y: FlxMath.lerp(dataBF.pos.y, dataDAD.pos.y, 0.5)
        };
        curCameraTarget = -1; // thanks boboa for the suggestion
        camFollow.setPosition(middlePosition.x, middlePosition.y);
        
        if (e.event.params[5] == false) FlxG.camera.snapToTarget();
        else if(e.event.params[1] != 'CLASSIC') {
            var oldFollow = FlxG.camera.followEnabled; // fun fact: my dumb ass brain left this variable after changing the camera value, which means it would always be false
            FlxG.camera.followEnabled = false;

            FlxTween.tween(FlxG.camera.scroll, {x: middlePosition.x-FlxG.camera.width*0.5, y: middlePosition.y-FlxG.camera.height*0.5},(Conductor.stepCrochet / 1000) * e.event.params[0], { 
                ease: CoolUtil.flxeaseFromString(e.event.params[1], e.event.params[2]),
                onComplete: (_) -> FlxG.camera.followEnabled = oldFollow
            });
        }
    }
}