var vcrshader:CustomShader = new CustomShader('ntsc_1');
FlxG.game.addShader(vcrshader);
var vcr2shader:CustomShader = new CustomShader('ntsc_2');
FlxG.game.addShader(vcr2shader);

function destroy() FlxG.game.setFilters([]);