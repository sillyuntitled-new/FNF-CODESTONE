import funkin.game.PlayState;

function postCreate() {
	if (FlxG.save.data.middleScroll) {
    if (PlayState.opponentMode) {
		  for (strum in playerStrums) strum.visible = false;
      for (cpuStrum in cpuStrums) cpuStrum.x = ((FlxG.width/2) - (Note.swagWidth * 2)) + (Note.swagWidth * cpuStrums.members.indexOf(cpuStrum));
      if (FlxG.save.data.middleOp){
      	for (strum in playerStrums) strum.visible = true;
        for (i in 2...4) {
          playerStrums.members[i].x = 756 + i * 105;
        }
        for (i in 0...2) {
          playerStrums.members[i].x = 80 + i * 105;
        }
      }
    }else{
			for (strum in cpuStrums) strum.visible = false;
      for (playerStrum in playerStrums) playerStrum.x = ((FlxG.width/2) - (Note.swagWidth * 2)) + (Note.swagWidth * playerStrums.members.indexOf(playerStrum));
      if (FlxG.save.data.middleOp){
      	for (strum in cpuStrums) {
      	  strum.visible = true;
      	}
        for (i in 2...4) {
          cpuStrums.members[i].x = 756 + i * 110;
        }
        for (i in 0...2) {
          cpuStrums.members[i].x = 80 + i * 110;
        }
      }
    }
  }
}

function update(){
	if (FlxG.save.data.middleScroll){
	  if (PlayState.opponentMode){
	    if (FlxG.save.data.middleOp){
	    	for (i in strumLines.members[1]) {
  			  i.alpha = FlxG.save.data.middleOpA;
  			}
	      for (i in strumLines.members[1].notes) {
          i.alpha = FlxG.save.data.middleOpA;
	      }
	    }
  	}else{
  		if (FlxG.save.data.middleOp){
  			for (i in strumLines.members[0]) {
  			  i.alpha = FlxG.save.data.middleOpA;
  			}
	      for (i in strumLines.members[0].notes) {
          i.alpha = FlxG.save.data.middleOpA;
	      }
  		}
  	}
	}
}