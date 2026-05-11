import flixel.FlxObject;
import flixel.ui.FlxBar;
import flixel.math.FlxRect;
import funkin.backend.FunkinText;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;

public var timerColor:FlxColor;
switch (FlxG.save.data.timerColor)
{
	case "defColor":
		timerColor = 0xFFFFFFFF;
	case "green":
		timerColor = 0xFF00FF00;
	case "BFC":
		timerColor = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : 0xFF66FF33;
	case "dadC":
		timerColor = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : 0xFFFF0000;
}
if (FlxG.save.data.microTimerMod == true) // if the timer is one
{
	function formatTime(seconds:Int):String // formats the song length into a timer value (e.x: 216 => "03:36")
	{
		var min:Int = Math.floor(seconds / 60);
		var sec:Int = seconds % 60;

		return StringTools.lpad(Std.string(min), "0", 2) + ":" + StringTools.lpad(Std.string(sec), "0", 2);
	}
	if (FlxG.save.data.timerStyle == "default")
	{
		var timerBarBG:FlxSprite;
		var timerBar:FlxSprite;
		var decorClock:FlxSprite;
		var decorSecond:FlxSprite;
		var decorMinute:FlxSprite;
		var timerpos:FlxSprite;
		var num1:FlxSprite;
		var num2:FlxSprite;
		var num3:FlxSprite;
		var num4:FlxSprite;
		var scrollDir:String;
		if (Options.downscroll)
		{
			scrollDir = 'downscroll';
		}
		else
		{
			scrollDir = 'upscroll';
		}
		function numToString(num:Int) // converts number to string with number name (e.x: 3 => 'three')
		{
			var nums = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];
			return nums[num];
		}
		function postCreate()
		{
			timerBarBG = CoolUtil.loadAnimatedGraphic(new FlxSprite(), Paths.image('game/timer/base'));
			timerBarBG.x = FlxG.width - timerBarBG.width - 10;
			timerBarBG.y = FlxG.height - timerBarBG.height - 10;
			timerBarBG.scrollFactor.set();

			timerBar = CoolUtil.loadAnimatedGraphic(new FlxSprite(timerBarBG.x + 12, timerBarBG.y + 6), Paths.image('game/timer/actualcodedthing'));
			timerBar.color = timerColor;
			timerBar.scrollFactor.set();
			timerBar.clipRect = new FlxRect(0, 0, 14, timerBar.height);

			decorClock = CoolUtil.loadAnimatedGraphic(new FlxSprite(timerBarBG.x - 31, 0), Paths.image('game/timer/decor_clock'));
			decorClock.scrollFactor.set();

			decorSecond = CoolUtil.loadAnimatedGraphic(new FlxSprite(decorClock.x + 10, 0), Paths.image('game/timer/decor_seconds'));
			decorSecond.scrollFactor.set();

			decorMinute = CoolUtil.loadAnimatedGraphic(new FlxSprite(decorClock.x + 10, 0), Paths.image('game/timer/decor_minutes'));
			decorMinute.scrollFactor.set();

			timerpos = CoolUtil.loadAnimatedGraphic(new FlxSprite(timerBar.x + 70, timerBar.y + 18), Paths.image('game/timer/timerpos'));
			timerpos.scrollFactor.set();

			num1 = CoolUtil.loadAnimatedGraphic(new FlxSprite(timerpos.x + 1, timerpos.y + 38),
				Paths.image('game/timer/numberfonts/' + scrollDir + '/numberfont_pos1'));
			num1.scrollFactor.set();

			num2 = CoolUtil.loadAnimatedGraphic(new FlxSprite(timerpos.x + 32, timerpos.y + 31),
				Paths.image('game/timer/numberfonts/' + scrollDir + '/numberfont_pos2'));
			num2.scrollFactor.set();

			num3 = CoolUtil.loadAnimatedGraphic(new FlxSprite(timerpos.x + 79, timerpos.y + 17),
				Paths.image('game/timer/numberfonts/' + scrollDir + '/numberfont_pos3'));
			num3.scrollFactor.set();

			num4 = CoolUtil.loadAnimatedGraphic(new FlxSprite(timerpos.x + 114, timerpos.y + 8),
				Paths.image('game/timer/numberfonts/' + scrollDir + '/numberfont_pos4'));
			num4.scrollFactor.set();

			for (h in [num1, num2, num3, num4])
			{
				h.frames = Paths.getFrames(h.graphic.key);

				h.animation.addByPrefix('zero', 'zero', 1, false);
				h.animation.addByPrefix('one', 'one', 1, false);
				h.animation.addByPrefix('two', 'two', 1, false);
				h.animation.addByPrefix('three', 'three', 1, false);
				h.animation.addByPrefix('four', 'four', 1, false);
				h.animation.addByPrefix('five', 'five', 1, false);
				h.animation.addByPrefix('six', 'six', 1, false);
				h.animation.addByPrefix('seven', 'seven', 1, false);
				h.animation.addByPrefix('eight', 'eight', 1, false);
				h.animation.addByPrefix('nine', 'nine', 1, false);
			}

			if (Options.downscroll == false)
			{
				timerBarBG.flipY = false;
				timerBar.flipY = false;
				timerpos.flipY = false;

				for (j in [num1, num2, num3, num4])
				{
					j.flipY = false;
				}

				decorClock.y = timerBarBG.y + 53;
				decorSecond.y = decorClock.y + 16;
				decorMinute.y = decorClock.y + 16;
			}
			else
			{
				timerBarBG.flipY = true;
				timerBar.flipY = true;
				timerpos.flipY = true;

				for (j in [num1, num2, num3, num4])
				{
					j.flipY = true;
				}

				decorClock.y = timerBarBG.y + 60;
				decorSecond.y = decorClock.y + 10;
				decorMinute.y = decorClock.y + 10;
			}

			add(timerBarBG);
			add(timerBar);
			add(decorClock);
			add(decorSecond);
			add(decorMinute);
			add(timerpos);
			add(num1);
			add(num2);
			add(num3);
			add(num4);

			for (e in [
				timerBarBG,
				timerBar,
				decorClock,
				decorSecond,
				decorMinute,
				timerpos,
				num1,
				num2,
				num3,
				num4
			])
			{
				e.cameras = [camHUD];
			}

			if (FlxG.save.data.isClock == false)
			{
				decorClock.x = 1018237876948372;
				decorSecond.x = 1018237876948372;
				decorMinute.x = 1018237876948372;
			}

			var hpbgpos:Float = healthBarBG.x;

			for (finger in [healthBarBG, healthBar, iconP1, iconP2, scoreTxt, missesTxt, accuracyTxt])
			{
				finger.x -= hpbgpos;
				finger.x += ((FlxG.width - timerBarBG.width - 20) - healthBarBG.width) / 2;
			}
		}
		function update(elapsed:Float)
		{
			if (FlxG.save.data.microDisplayed == "microRemaining")
			{
				num1.animation.play(numToString(formatTime(Math.floor((inst.length - inst.time) / 1000)).charAt(0)));
				num2.animation.play(numToString(formatTime(Math.floor((inst.length - inst.time) / 1000)).charAt(1)));
				num3.animation.play(numToString(formatTime(Math.floor((inst.length - inst.time) / 1000)).charAt(3)));
				num4.animation.play(numToString(formatTime(Math.floor((inst.length - inst.time) / 1000)).charAt(4)));
			}
			else if (FlxG.save.data.microDisplayed == "microElapsed")
			{
				num1.animation.play(numToString(formatTime(Math.floor(inst.time / 1000)).charAt(0)));
				num2.animation.play(numToString(formatTime(Math.floor(inst.time / 1000)).charAt(1)));
				num3.animation.play(numToString(formatTime(Math.floor(inst.time / 1000)).charAt(3)));
				num4.animation.play(numToString(formatTime(Math.floor(inst.time / 1000)).charAt(4)));
			}

			if (FlxG.save.data.isClock == true)
			{
				timerBar.clipRect = new FlxRect(0, 0, ((inst.time / inst.length) * (timerBar.width - 14)) + 14, timerBar.height);
			}
			else
			{
				timerBar.clipRect = new FlxRect(0, 0, ((inst.time / inst.length) * timerBar.width), timerBar.height);
			}

			if (decorMinute != null && decorSecond != null)
			{
				decorMinute.angle = (inst.time / inst.length) * 360;
				decorSecond.angle = (inst.time / inst.length) * 21600;
			}
		}
	}
	else if (FlxG.save.data.timerStyle == "psychEngine")
	{
		public var blackbar:FlxSprite;
		public var whitebar:FlxSprite;
		public var blackback:FlxSprite;
		public var textTimer:FunkinText;
		function postCreate()
		{
			blackbar = CoolUtil.loadAnimatedGraphic(new FlxSprite(0, 0), Paths.image('game/timer/psychTimer'));
			blackbar.scrollFactor.set();
			blackbar.screenCenter();
			blackbar.y -= (FlxG.height / 2) - (blackbar.height * 1.5);

			textTimer = new FunkinText(blackbar.x, blackbar.y - 5, blackbar.width, SONG.meta.displayName, 32);
			textTimer.borderSize = 2;
			textTimer.alignment = FlxTextAlign.CENTER;
			textTimer.scrollFactor.set();

			blackback = new FlxSprite(blackbar.x + 1, blackbar.y + 1).makeGraphic(blackbar.width - 2, blackbar.height - 2, FlxColor.BLACK);

			whitebar = new FlxSprite(blackbar.x + 2, blackbar.y + 2).makeGraphic(blackbar.width - 4, blackbar.height - 4, timerColor);
			whitebar.clipRect = new FlxRect(0, 0, 0, whitebar.height);

			add(blackback);
			add(whitebar);
			add(blackbar);
			add(textTimer);

			for (zxckm in [blackback, whitebar, blackbar, textTimer])
			{
				zxckm.cameras = [camHUD];
			}
		}
		function update(elapsed:Float)
		{
			if (FlxG.save.data.psychDisplayed == "psychRemaining")
			{
				textTimer.text = formatTime(Math.floor((inst.length - inst.time) / 1000));
			}
			else if (FlxG.save.data.psychDisplayed == "psychElapsed")
			{
				textTimer.text = formatTime(Math.floor((inst.time) / 1000));
			}
			else if (FlxG.save.data.psychDisplayed == "psychSN")
			{
				// do nothing because it should already be the song name
			}
			whitebar.clipRect = new FlxRect(0, 0, ((inst.time / inst.length) * whitebar.width), whitebar.height);
		}
	}
}
