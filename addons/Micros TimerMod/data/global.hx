function new()
{
	FlxG.save.data.microTimerMod ??= true;
	FlxG.save.data.timerStyle ??= "default";
	FlxG.save.data.timerColor ??= "defColor";
	FlxG.save.data.isClock ??= true;
	FlxG.save.data.microDisplayed ??= "microRemaining";
	FlxG.save.data.psychDisplayed ??= "psychRemaining";
}
