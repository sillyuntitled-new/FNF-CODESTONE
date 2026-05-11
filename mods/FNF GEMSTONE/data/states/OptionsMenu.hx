import funkin.options.type.TextOption;
import funkin.options.type.NumOption;
import funkin.options.TreeMenuScreen;

var curMenu:TreeMenuScreen; // to not mess up other OptionsMenu overrides

function update()
{
    for (menu in tree)
        if (curMenu != menu && menu.rawName == "optionsTree.appearance-name")
        {
            curMenu = menu;

            menu.add(new TextOption("Underlay Options (ADDON)", "Change the Strumline Underlay addon preferences here.", " >", () -> {
                var menuTree:TreeMenuScreen = menu.parent.addMenu(new TreeMenuScreen("Strumline Underlay Options", "All the settings for the Strumline Underlay."));

                menuTree.add(new NumOption("Alpha Factor", "Factor for how much the underlay should copy the strum's opacity.", 0, 100, 1, null, (num:Float) -> {
                    FlxG.save.data.underlay_alphaFactor = num / 100;
                    FlxG.save.flush();
                }));
            }));
        }
}