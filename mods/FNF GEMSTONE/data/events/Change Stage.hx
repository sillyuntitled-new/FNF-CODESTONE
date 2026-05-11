import funkin.game.Stage;
import funkin.game.StageCharPos;
import funkin.backend.scripting.Script;
import Xml;
import Reflect;
import funkin.editors.charter.Charter;
import Type;
using Lambda;

var stageList = [];
var curStage = {name: "", obj: null};

function create() {
	stageList.push({
		name: PlayState.SONG.stage,
		obj: stage
	});
  // we can't do anything before the first stage loads, but it's safe to look in the state at this point because it's the only stage right now
  stage.extra["contains"] = [];
  stage.state.forEach(s -> stage.extra["contains"].push(s));
  stage.extra["elemOffset"] = 0;
	for (event in PlayState.SONG.events) {
		if (event.name == "Change Stage" && event.params[0] != "") {
			var exists = false;
			for (stage in stageList) {
				if (stage.name == event.params[0]) {
					exists = true;
					break;
				}
			}
			if (!exists) {
				var newstage = {
					name: event.params[0],
					obj: new Stage(event.params[0], null, false)
				}
        newstage.obj.stageName = newstage.name; // just in case
        newstage.obj.extra["elemOffset"] = stage.state.length-1;
        CoolUtil.last(stageList).obj.extra["elemsEnd"] = newstage.obj.extra["elemOffset"];
        var xml = newstage.obj.stageXML;
        var elems:Array<Access> = [];
        var ext = [for (x in xml.elements()) x].filter(n -> n.nodeName == "use-extension" || n.nodeName == "extension" || n.nodeName == "ext");
        for (e in ext) {
          if (Paths.script((e.get("folder")??"data/scripts/")+e.get("script")) == "assets/data/scripts/pixel.hx") {
            trace("Please make your own pixel script ToT");
            e.remove("script");
          }
        }
        newstage.obj.extra["contains"] = [];
        newstage.obj.onAddSprite = (s) -> newstage.obj.extra["contains"].push(s);
        newstage.obj.loadXml(xml);
        newstage.obj.onAddSprite = null; // 0.000001% performance boost
				for (sprite in newstage.obj.stageSprites) {
					if (sprite == null) continue;
					sprite.visible = false;
				}
				for (xmlScript in newstage.obj.xmlImportedScripts) {
          var xml = xmlScript.getScript();
          baseGameCompat(xml, false);
          xml.call("destroy");
					xml.active = false;
				}
				stageList.push(newstage);
				add(newstage.obj);
			}
		}
	}
	defaultCamZoom = stage.defaultZoom;
  curStage = stageList[0];
  // disabling scripts earlier
  for (stage in stageList) {
		if (stage.name != PlayState.SONG.stage) {
      stage.obj.stageScript.call("destroy");
			stage.obj.stageScript.active = false;
		}
	}
}
function onEvent(e) {
  //trace([for (a in strumLines.members) for (b in a.characters) b.curCharacter]);
	if (e.event.name == "Change Stage") {
    var csEvents = PlayState.instance.events.filter(ev -> ev.name == "Change Stage");
    if (Charter.startHere && Charter.startTime > e.event.time) {
      if (Charter.startTime > CoolUtil.last(csEvents).time) {
        trace("Skipped \""+e.event.params[0]+"\" stage because it tried to run multiple events at once");
        return;
      }
    }
		var params = e.event.params;
		var stageName = params[0];
		if (stageName == "" || stageName == curStage.name) return;

		for (stage in stageList) {
			var isTheStage = stage.name == stageName;
			for (sprite in stage.obj.stageSprites) {
				if (sprite == null) continue;
				sprite.visible = isTheStage;
			}
      /*
			for (xmlScript in stage.obj.xmlImportedScripts) {
				xmlScript.getScript().active = isTheStage;
			}
      */
			if (isTheStage) {
        for (xmlScript in stage.obj.xmlImportedScripts) {
          var xml = xmlScript.getScript();
          xml.active = true;
          baseGameCompat(xml, true, curStage.obj);
          xml.call("onStageSwitch", [true], curStage.obj);
          xml.call("create");
          xml.call("postCreate");
        }
				stage.obj.stageScript.active = true;
        baseGameCompat(stage.obj.stageScript, true, curStage.obj);
        stage.obj.stageScript.call("onStageSwitch", [true], curStage.obj);
        stage.obj.stageScript.call("create");
        stage.obj.stageScript.call("postCreate");

        curStage = stage;
				FlxG.camera.zoom = defaultCamZoom = stage.obj.defaultZoom;

				function applyPose(char:Dynamic, tag:String)
				{
						if (stage.obj.characterPoses != null)
						{
							var pos = stage.obj.characterPoses[tag] ?? stage.obj.getDefaultPos(tag);
							if (pos != null && char != null)
							{
                if (char.extra["prevStageInfo"] == null) char.extra["prevStageInfo"] = pos.getOldInfo(char);
                Reflect.setField(pos, "oldInfo", char.extra["prevStageInfo"]);
                pos.revertCharacter(char);
                pos.prepareCharacter(char);
							}
						}
				}
				applyPose(dad, "dad");
				applyPose(boyfriend, "boyfriend");
				applyPose(gf, "girlfriend");

				remove(gf, false);
				remove(dad, false);
				remove(boyfriend, false);

				var gfIndex = findExplicitIdx("girlfriend", stage.obj);
				var dadIndex = findExplicitIdx("dad", stage.obj);
				var bfIndex = findExplicitIdx("boyfriend", stage.obj);

        if (gfIndex < 0) gfIndex = members.indexOf(stage.obj) + 1;
				if (dadIndex < 0) dadIndex = gfIndex + 1;
				if (bfIndex < 0) bfIndex = dadIndex + 1;
        
				if (gf!=null) insert(gfIndex, gf);
				if (dad!=null) insert(dadIndex, dad);
				if (boyfriend!=null) insert(bfIndex, boyfriend);

        PlayState.instance.stage = stage.obj;
			} else {
				if (stage.obj.stageScript.active) {
          baseGameCompat(stage.obj.stageScript, false, stageList.find(i -> i.name == stageName).obj);
          stage.obj.stageScript.active = false;
        }
        for (xmlScript in stage.obj.xmlImportedScripts) {
          var xml = xmlScript.getScript();
          if (xml.active) {
            xml.call("onStageSwitch", [false], stageList.find(i -> i.name == stageName).obj);
            xml.call("destroy");
            baseGameCompat(xml, false, stageList.find(i -> i.name == stageName).obj);
            xml.active = false;
          }
			  }
      }
		}
	}
}
function baseGameCompat(script:Script, goingTo:Bool, ?adjacent:Stage) {
  //trace(script.path + (!goingTo ? " going to " : " going from ") + adjacent?.stageName);
  switch (script.path) {
    case "assets/data/stages/mall-evil.hx":
      if (!goingTo) {
        var shader = script.get("idk");
        if (shader != null) {
          camGame.removeShader(shader);
          script.set("idk", null);
        }
      }
    case "assets/data/stages/philly.hx":
      if (!goingTo) {
        if (script.get("trainMoving")) script.call("trainReset");
      }
  }
}

function findExplicitIdx(char:String, stageRef, custom:Bool = false):Int {
	if (stageRef == null) return null;
  /*
	var xmlIter = Xml.parse(stageRef.stageXML).firstElement().elements();
  var xml = [for (node in xmlIter) if (Options.lowMemoryMode ? node.nodeName != "high-memory" : node.nodeName != "low-memory") node];
  */
  var thisElems = members.filter(m -> stageRef.extra["contains"].contains(m));
  var idx = members.findIndex(elem -> thisElems.contains(elem) && elem.name == char);
  return idx == null ? -1 : idx+1;
}