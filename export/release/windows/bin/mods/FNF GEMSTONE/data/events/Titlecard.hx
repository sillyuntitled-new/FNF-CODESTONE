import flixel.tweens.FlxTween;
import flixel.tweens.FlxTweenType;

var titlecard:FlxSprite;
var composer1:FlxSprite;

function create(){
    titlecard = new FlxSprite(-120, 100);
    titlecard.antialiasing = Options.antialiasing;
    titlecard.scale.set(0.5, 0.5);
    titlecard.camera = camHUD;
    //titlecard.screenCenter(FlxAxes.X);
    add(titlecard);
    titlecard.alpha = 0;

    composer1 = new FlxSprite(0, 100);
    composer1.antialiasing = Options.antialiasing;
    composer1.scale.set(0.5, 0.5);
    composer1.camera = camHUD;
    //composer1.screenCenter(FlxAxes.X);
    add(composer1);
    composer1.alpha = 0;
}

function onEvent(eventEvent) {
    if (eventEvent.event.name == "Titlecard") {
        var flxeaseTitle:String = eventEvent.event.params[1] + (eventEvent.event.params[1] == "linear" ? "" : eventEvent.event.params[3]);
        var flxeaseComposer:String = eventEvent.event.params[2] + (eventEvent.event.params[2] == "linear" ? "" : eventEvent.event.params[3]);

        titlecard.loadGraphic(Paths.image('titlecards/'+ eventEvent.event.params[0] + '/first_thing'));
        composer1.loadGraphic(Paths.image('titlecards/'+ eventEvent.event.params[0] + '/second_thing'));

        FlxTween.tween(titlecard, {alpha: 1}, 1, {ease: Reflect.field(FlxEase, flxeaseTitle)});
        FlxTween.tween(composer1, {y: 330, alpha: 1}, 2, {ease: Reflect.field(FlxEase, flxeaseComposer)});

        new FlxTimer().start(eventEvent.event.params[4], function(tmr:FlxTimer)
			{
			    FlxTween.tween (titlecard, {x: 2600}, 2, {ease: Reflect.field(FlxEase, flxeaseTitle)});
                FlxTween.tween (composer1, {x: -2600}, 2, {ease: Reflect.field(FlxEase, flxeaseComposer)});
		    });
    }
}
