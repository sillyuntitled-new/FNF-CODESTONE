import flixel.tweens.FlxEase;

var ghostsArray:Array = [];

function postCreate() {
    for (i in strumLines.members) {
        i.onHit.add(onStrumlineHit);
    }
}

function onStrumlineHit(event:NoteHitEvent) {
    var lane = event.note.strumLine;
    var prevNoteTime:Float = lane.extra.get('prevNoteTime') ?? -1000;
    var note:Note = event.note;

    if (note.sustainParent == null) {
        if (note.strumTime == prevNoteTime) {
            var prevNoteData:Int = lane.extra.get('prevNoteData') ?? 0;
            var chars:Array = getCharsForLane(lane);
            for (char in chars) {
                createGhostAnim(char, prevNoteData, event.animSuffix);
            }
        }
        lane.extra.set('prevNoteTime', note.strumTime);
        lane.extra.set('prevNoteData', note.noteData);
    }
}

function getCharsForLane(lane) {
    var chars:Array = [];

    if (lane.characters != null && lane.characters.length > 0) {
        for (c in lane.characters) {
            if (c != null && chars.indexOf(c) == -1)
                chars.push(c);
        }
        return chars;
    }

    var idx:Int = strumLines.members.indexOf(lane);

    if (idx == 0) {
        if (dad != null) chars.push(dad);
    } else if (idx == 1) {
        if (boyfriend != null) chars.push(boyfriend);
    }

    if (gf != null && gf.strumLine == lane && chars.indexOf(gf) == -1)
        chars.push(gf);

    return chars;
}

function createGhostAnim(char:Character, noteData:Int, animSuffix:String) {
    var charX:Float = char.x;
    var charY:Float = char.y;
    var charName:String = char.curCharacter;
    var charIsPlayer:Bool = char.isPlayer;
    var charColor = char.iconColor;
    var charAlpha:Float = char.alpha;

    var ghost:Character = new Character(charX, charY, charName, charIsPlayer);
    ghost.color = charColor;
    ghost.alpha = charAlpha * 0.5;
    ghost.playSingAnim(noteData, animSuffix, 'LOCK');
    ghost.danceOnBeat = false;

    ghostsArray.push(ghost);
    insert(Math.max(0, members.indexOf(char) - 1), ghost);

    var moveDistance:Float = 200;
    var targetX:Float = charX + (charIsPlayer ? moveDistance : -moveDistance);

    FlxTween.tween(ghost, { x: targetX }, 0.4, { ease: FlxEase.sineInOut });
    FlxTween.tween(ghost, { alpha: 0 }, 0.4, {
        ease: FlxEase.sineInOut,
        onComplete: function(tween:FlxTween) {
            ghostsArray.remove(ghost);
            ghost.kill();
            remove(ghost, true);
            ghost.destroy();
        }
    });
}