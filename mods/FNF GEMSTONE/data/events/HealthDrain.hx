var drain:Float;

function onEvent(push){
    if (push.event.name == 'HealthDrain'){
        onDadHit(push);
        drain = push.event.params[0];
    }
}

function onDadHit(push) {
    if (!FlxG.save.data.original) {
        if (health > 0.10) {
            health -= drain;
        }
    }
}