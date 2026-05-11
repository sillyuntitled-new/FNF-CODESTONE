// script by TheSanyaBEST

import flixel.util.FlxAxes;

var newHealthBar:FunkinSprite;

function postCreate() {
	healthBarBG.alpha = 1;

	insert(members.indexOf(healthBar) + 1, newHealthBar = new FunkinSprite(0, 610).loadGraphic(Paths.image("game/newHealthBar")));
	newHealthBar.screenCenter(FlxAxes.X);
	newHealthBar.antialiasing = Options.antialiasing;
	newHealthBar.camera = camHUD;

	var menuItemSpace = 72;
    accuracyTxt.x += menuItemSpace;
    scoreTxt.x -= menuItemSpace;
	for (health in [newHealthBar,  iconP1, iconP2]) health.y += 8;
	for (health in [healthBarBG, healthBar]) health.y += -30;
	for (stats in [accuracyTxt, missesTxt, scoreTxt]) stats.y -= 10;
}