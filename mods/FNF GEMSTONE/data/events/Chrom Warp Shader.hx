var chromWarp:CustomShader = new CustomShader("chroma-outline");
var oldValue:Float;

function create()
{
    chromWarp.distortion = 0;
    camGame.addShader(chromWarp);
    oldValue = 0;
}

function onEvent(e)
{
    if(e.event.name == "Chrom Warp Shader")
    {
        oldValue = e.event.params[0];
        tweenShader(e.event.params[0], e.event.params[1]);
    }
}

function tweenShader(newValue:Float, duration:Float)
{
    FlxTween.num(oldValue, newValue, duration, { ease: FlxEase.cubeOut }, function(val:Float){
        chromWarp.data.distortion.value = [val];
    });
}