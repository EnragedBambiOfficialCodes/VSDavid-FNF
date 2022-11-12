//le code for credits popup
package;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class CreditsPopupL extends FlxSpriteGroup{
    public var instance:CreditsPopupL;
    public var boxLol:FlxSprite;
    public var text:FlxText;

    // el code made by DavidDX so L bozo!!!!
    public function new(x:Float, y:Float, songuhh:String){
        super(x, y);
        /*ball sex 
            -Project Tea*/
        boxLol = new FlxSprite().makeGraphic(400, 80);
        boxLol.alpha = 0.6;
        add(boxLol);

        text = new FlxText(1, -5, 650, '', 16);
        text.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        switch(songuhh.toLowerCase()){
            case 'tutorial' | 'bopeebo' | 'fresh' | 'dad-battle':
                text.text += 'Composer(s):KawaiSprite\nVisuals:PhantomArcade\nCharting:N/A\nCoder(s):DavidDX, ShadowMario, ninjamuffin99';
                boxLol.updateHitbox();
            case 'secret':
                text.text += 'Composer(s):WillowMakedMusic\nVisuals:DavidDX\nCharting:DavidDX\nCoder(s):DavidDX';
                boxLol.updateHitbox();
            case 'abuse':
                text.text += 'Composer(s):CarCarWhoah\nVisuals:DavidDX\nCharting:DavidDX\nCoder(s):DavidDX\nCover:DavidDX, PearlescentMoon';
                boxLol.updateHitbox();
            default:
                text.text = '';
                remove(boxLol);
        }
        add(text);


    }
}