

class LilBuddy extends flixel.FlxSprite {
    public var isPlayer:Bool;
    public var isGF:Bool;
    public var yOffset = 0;
    public var graphictouse:String = 'lilOpp';
    public function new(strumLineTypeID:Int, ?yOffset:Float = -60)
    {
        super(0,0);
        this.yOffset = yOffset;

        switch(strumLineTypeID){
            case 1:
                this.isPlayer = true;
                this.graphictouse = 'lilBf';
            case 2:
                this.isPlayer = false;
                this.graphictouse = 'lilGf';
                this.isGF = true;
            default:
                this.isPlayer = false;
                this.graphictouse = 'lilOpp';

        }

        loadGraphic(Paths.image('editors/charter/' +graphictouse), true, 300, 256);
        animation.add("idle", [0, 1], 12, true);
		animation.add("0", [3, 4, 5], 12, false);
		animation.add("1", [6, 7, 8], 12, false);
		animation.add("2", [9, 10, 11], 12, false);
		animation.add("3", [12, 13, 14], 12, false);
        animation.finishCallback = function(name:String){
			animation.play(name, true, false, animation.getByName(name).numFrames - 2);
		}
		animation.play("idle");
        if(isGF) x -= 100;
    }
}