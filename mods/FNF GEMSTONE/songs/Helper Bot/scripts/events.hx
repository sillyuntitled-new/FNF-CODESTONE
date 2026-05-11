if (PlayState.difficulty != 'hard') disableScript();

function beatHit(_:Int) {
    switch (_) {
        case 12 | 13 | 14:
            defaultCamZoom = FlxG.camera.zoom += 0.08;
    }
}