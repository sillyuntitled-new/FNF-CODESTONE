import haxe.ds.StringMap;

/**
 * Contains all characters to be used mid-song.
 * ```haxe
 * charMap[strumLine index][character index].get(curCharacter name);
 * ```
 */
public var charMap:Array<Array<StringMap<Character>>> = [];
function charMapNullCheck(strumIndex:Int, charIndex:Int):Void {
	if (charMap[strumIndex] == null) charMap[strumIndex] = [];
	if (charMap[strumIndex][charIndex] == null) charMap[strumIndex][charIndex] = new StringMap();
}

/**
 * Returns an array of call cached characters.
 * Mostly used to call functions that only run on strumLine characters.
 * example: "gamePostCreate"
 * @return Array<Character>
 */
public function getCachedCharacters():Array<Character> {
	var chars:Array<Character> = [];
	for (strumMap in charMap)
		for (memberMap in strumMap)
			for (tag => char in memberMap)
				chars.push(char);
	for (strumLine in strumLines)
		for (char in strumLine.characters)
			if (chars.contains(char))
				chars.remove(char);
	return chars;
}

// partially stole from gorefield lol
function create():Void {
	// add preexisting
	for (strumIndex => strumLine in strumLines.members) {
		for (charIndex => char in strumLine.characters) {
			// null check
			charMapNullCheck(strumIndex, charIndex);
			// script stuff
			function precacheSelf(?charName:String):Character return precacheCharacter(strumIndex, charName ?? 'bf', charIndex, false);
			function changeSelf(?charName:String, ?updateBar:Bool):Void changeCharacter(strumIndex, charName ?? 'bf', charIndex, updateBar ?? true);
			char.scripts.set('precacheChar', precacheSelf);
			char.scripts.set('changeChar', changeSelf);
			// le code
			charMap[strumIndex][charIndex].set(char.curCharacter, char);
			trace('Adding pre-existing character "' + char.curCharacter + '" of index ' + charIndex + ', on strumLine ' + strumIndex + '.');
		}
	}
	// precache
	for (event in events)
		if (event.name == 'Change Character')
			precacheCharacter(event.params[0], event.params[1], event.params[2], false);
}
function postCreate():Void
	for (char in getCachedCharacters())
		char.scripts.call('gamePostCreate');

public function precacheCharacter(strumIndex:Int, ?charName:String, ?memberIndex:Int, ?existsPrint:Bool):Character {
	// fuck hscript
	charName ??= 'bf'; memberIndex ??= 0; existsPrint ??= true;

	// null check
	charMapNullCheck(strumIndex, memberIndex);

	// precache process
	if (!charMap[strumIndex][memberIndex].exists(charName)) {
		// vars
		var strumLine:StrumLine = strumLines.members[strumIndex];
		var existingChar:Character = strumLine.characters[memberIndex];

		var newChar:Character = new Character(existingChar.x, existingChar.y, charName, existingChar.isPlayer);
		charMap[strumIndex][memberIndex].set(newChar.curCharacter, newChar);
		newChar.active = false;
		trace('Precached character "' + newChar.curCharacter + '" of index ' + memberIndex + ', on strumLine ' + strumIndex + '.');

		if (newChar.animateAtlas != null) newChar.animateAtlas.drawComplex(FlxG.camera);
		else newChar.drawComplex(FlxG.camera);

		var chartLine = SONG.strumLines[strumIndex];
		stage.applyCharStuff(newChar, chartLine.position == null ? (switch(chartLine.type) {
			case 0: 'dad';
			case 1: 'boyfriend';
			case 2: 'girlfriend';
		}) : chartLine.position, memberIndex);
		remove(newChar); // remove from state as they are not needed yet

		// script stuff
		function precacheSelf(?charName:String):Character return precacheCharacter(strumIndex, charName ?? 'bf', charIndex, false);
		function changeSelf(?charName:String, ?updateBar:Bool):Void changeCharacter(strumIndex, charName ?? 'bf', charIndex, updateBar ?? true);
		newChar.scripts.set('precacheChar', precacheSelf);
		newChar.scripts.set('changeChar', changeSelf);
		scripts.call('onCharacterCached', [newChar, strumIndex, memberIndex]);
		newChar.scripts.call('onSelfCached', [newChar, strumIndex, memberIndex]);
		return newChar;
	}
	if (existsPrint) trace('This character already exists! (char:' + charName + ', line:' + strumIndex + ', index:' + memberIndex + ')');
	return charMap[strumIndex][memberIndex].get(charName);
}

public function changeCharacter(strumIndex:Int, ?charName:String, ?memberIndex:Int, ?updateBar:Bool):Void {
	// fuck hscript
	charName ??= 'bf'; memberIndex ??= 0; updateBar ??= true;

	// if new char no exist
	if (!charMap[strumIndex][memberIndex].exists(charName)) {
		trace('This character doesn\'t exist, please cache it early on to prevent lag. (char:' + charName + ', line:' + strumIndex + ', index:' + memberIndex + ')');
		precacheCharacter(strumIndex, charName, memberIndex);
	}

	// vars
	var oldChar:Character = strumLines.members[strumIndex].characters[memberIndex];
	var newChar:Character = charMap[strumIndex][memberIndex].get(charName);

	// null check
	if (oldChar == null || newChar == null) return;
	if (oldChar.curCharacter == newChar.curCharacter) return trace('It\'s the same character bro. (char:' + newChar.curCharacter + ', line:' + strumIndex + ', index:' + memberIndex + ')');

	// icon change + healthBar color update
	if (memberIndex == 0 && updateBar) {
		if (strumIndex == 0) { // opponent side
			iconP2.setIcon(newChar.getIcon());
			if (Options.colorHealthBar) healthBar.createColoredEmptyBar(newChar.iconColor ?? (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000));
			healthBar.updateBar();
			healthBar.updateHitbox();
		} else if (strumIndex == 1) { // player side
			iconP1.setIcon(newChar.getIcon());
			if (Options.colorHealthBar) healthBar.createColoredFilledBar(newChar.iconColor ?? (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33));
			healthBar.updateBar();
			healthBar.updateHitbox();
		}
	}

	// swaps old and new char
	insert(members.indexOf(oldChar), newChar);
	newChar.active = true;
	oldChar.active = false;
	remove(oldChar);

	// make it seemless
	newChar.setPosition(oldChar.x, oldChar.y);
	newChar.playAnim(oldChar.animation?.name, true, oldChar.lastAnimContext);
	newChar.animation?.curAnim?.curFrame = oldChar.animation?.curAnim?.curFrame;
	for (prop in ['cameras', 'visible', 'alpha', 'blend', 'flipY', 'color'])
		Reflect.setProperty(newChar, prop, Reflect.getProperty(oldChar, prop));
	// newChar.flipX = oldChar.flipX && !oldChar.isPlayer; // not sure how to handle flipX

	// fully apply change
	strumLines.members[strumIndex].characters[memberIndex] = newChar;
	trace('Changed character from "' + oldChar.curCharacter + '" to "' + newChar.curCharacter + '" of index ' + memberIndex + ', on strumLine ' + strumIndex + '!');
	scripts.call('onChangeCharacter', [oldChar, newChar, strumIndex, memberIndex, updateBar]);
	oldChar.scripts.call('onCharacterChangeTo', [newChar, strumIndex, memberIndex, updateBar]);
	newChar.scripts.call('onCharacterChangeFrom', [oldChar, strumIndex, memberIndex, updateBar]);
}

function onEvent(event):Void {
	switch (event.event.name) {
		case 'Change Character':
			changeCharacter(event.event.params[0], event.event.params[1], event.event.params[2], event.event.params[3]);
	}
}