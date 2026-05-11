import funkin.editors.charter.Charter;
import funkin.editors.ui.UIUtil;
import LilBuddy;

var lilBuddiesEnabled = true;
var iconPosition = true;
var lilBuddies = [];
var lilStage:FlxSprite;

var notesHited = 0;
function measureHit(m)
{
	for(lilBuddy in lilBuddies)
	{
		lilBuddy.animation.play("idle");
	}
}
function update(_)
{
	var idx = 0;

	for(lilBuddy in lilBuddies)
	{
		if(lilBuddy.ID == null) continue;
		var strum = strumLines.members[idx];
		if(strum == null) continue;
		var offsetX = lilBuddy.isPlayer ? -65 : 45;
		var offsetY = lilBuddy.yOffset;
		if(lilBuddy.isGF) offsetY = -40;
		if(lilBuddy.isGF) offsetX -= 65;
		if (iconPosition)
		{
			var spacing = 40; 
			var baseX = 100;
			var baseY = FlxG.height - 300; 

			lilBuddy.x = baseX;
			lilBuddy.y = baseY - offsetY;
			lilBuddy.scrollFactor.set(0,0);
			lilBuddy.scale.set(1,1);
			lilStage.visible = true;
			lilStage.x = baseX - 40;
			lilStage.y = baseY - 5;
		}
		else
		{
			if(lilStage.visible) lilStage.visible = false;
			if(lilBuddy.scale.x != 0.7) lilBuddy.scale.set(0.7,0.7);
			UIUtil.follow(
				lilBuddy,
				strum,
				offsetX,
				lilBuddy.yOffset = FlxMath.lerp(offsetY, strum.draggable ? -51 : -60, 1/12)
			);
		}
		if(!FlxG.sound.music.playing)
			lilBuddy.animation.play("idle");

		//lilBuddy.alpha = (strum.strumLine.type == 2 && lilBuddy.animation.curAnim.name == "idle") ? 0.2 : 1;

		idx++;
	}

	for(i in notesGroup.members)
	{
		if (i.__passed != (i.__passed = i.step < Conductor.curStepFloat)) {
			if (i.__passed && FlxG.sound.music.playing)
			{
				var lilBuddy = lilBuddies[i.strumLineID];
				lilBuddy.animation.play(i.id, true);
				i.__passed = !i.__passed;
			}
		}
	}

	if((FlxG.mouse.justReleased || !strumLines.draggable) && strumLines.isDragging)
	{
		reload_lil_buddies(null);
	}

}
function postCreate(){
	lilStage = new FlxSprite(0,0,Paths.image("editors/charter/lilStage"));
	lilStage.cameras = [charterCamera];
	//lilStage.visible = lilBuddiesEnabled && !iconPosition;
	lilStage.scrollFactor.set(0,0);
	add(lilStage);

	topMenu[3].childs.insert(topMenu[3].childs.length, null);

	topMenu[3].childs.insert(topMenu[3].childs.length, {
		label: "Show Lil Buddies",
		icon: lilBuddiesEnabled ? 1 : 0,
		onSelect: enable_lil_buddies
	});
	topMenu[3].childs.insert(topMenu[3].childs.length, {
		label: "Refresh Lil Buddies",
		onSelect: reload_lil_buddies
	});

	topMenu[3].childs.insert(topMenu[3].childs.length, {
		label: "Put Lil Buddies in the Bottom Left?",
		icon: iconPosition ? 1 : 0,
		onSelect: toggle_icon_position
	});

	var i = 0;

	for(strum in strumLines.members)
	{
		var newLilBuddy = new LilBuddy(strum.strumLine.type, strum.draggable ? -51 : -60);
		newLilBuddy.ID = i;
		newLilBuddy.cameras = [charterCamera];
		newLilBuddy.scale.set(0.7,0.7);
		newLilBuddy.visible = lilBuddiesEnabled;
		strum.healthIcons.alpha = lilBuddiesEnabled && !iconPosition ? 0.2 : 1;
		newLilBuddy.updateHitbox();
		lilBuddies.push(newLilBuddy);
		add(newLilBuddy);
		i++;
	}


}


function reload_lil_buddies(_) {
	for(lilBuddy in lilBuddies)
	{
		lilBuddy.destroy();
	}

	lilBuddies = [];

	var i = 0;
	for(strum in strumLines.members)
	{
		var newLilBuddy = new LilBuddy(strum.strumLine.type, strum.draggable ? -51 : -60);
		newLilBuddy.ID = i;
		newLilBuddy.cameras = [charterCamera];
		newLilBuddy.scale.set(0.7,0.7);
		newLilBuddy.visible = lilBuddiesEnabled;
		strum.healthIcons.alpha = lilBuddiesEnabled && !iconPosition ? 0.2 : 1;
		newLilBuddy.updateHitbox();
		lilBuddies.push(newLilBuddy);
		add(newLilBuddy);
		i++;
	}
}

function toggle_icon_position(t) {
	t.icon = (iconPosition = !iconPosition) ? 1 : 0;
	for(strum in strumLines.members)
	{
		// strum.healthIcons.visible = !lilBuddiesEnabled;
		strum.healthIcons.alpha = lilBuddiesEnabled && iconPosition ? 1 : 0.2;
		var scale =  lilBuddiesEnabled ? 0.3 : 0.6;
	}
	for(lilBuddy in lilBuddies)
	{
		lilBuddy.visible = lilBuddiesEnabled;
	}
}

function enable_lil_buddies(t) {
	t.icon = (lilBuddiesEnabled = !lilBuddiesEnabled) ? 1 : 0;
	for(strum in strumLines.members)
	{
		// strum.healthIcons.visible = !lilBuddiesEnabled;
		strum.healthIcons.alpha = lilBuddiesEnabled && !iconPosition ? 0.2 : 1;
		var scale = lilBuddiesEnabled && !iconPosition ? 0.3 : 0.6;
	}
	for(lilBuddy in lilBuddies)
	{
		lilBuddy.visible = lilBuddiesEnabled;
	}
}