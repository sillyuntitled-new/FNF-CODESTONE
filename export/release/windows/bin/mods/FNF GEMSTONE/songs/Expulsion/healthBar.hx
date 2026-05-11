function postCreate() {
    final offsetX:Float = !downscroll ? 0 : 0;
    final offsetY:Float = !downscroll ? 0 : 0;
    
    var newBar:FlxSprite = new FlxSprite(healthBarBG.x + offsetX, healthBarBG.y + offsetY, Paths.image('theHealthBar'));
    newBar.antialiasing = Options.antialiasing;
    newBar.camera = camHUD;
    insert(members.indexOf(accuracyTxt), newBar);
    
    healthBarBG.visible = false;
}