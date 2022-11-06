// used the bp code for coding references, anyways the code is mine but the bp code eased me to create all of this stuff and used a part of it to get it working
package storymenu;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import flixel.group.FlxSpriteGroup;
import openfl.Lib;
import openfl.system.System;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
#if desktop
import Discord.DiscordClient;
#end
import WeekData;

class StoryMenuState extends MusicBeatState//the start of el code
{
    var bg:FlxSprite;
    var week1:FlxSprite;
    var lol:Bool = false;
    var week1Text:FlxText;
    var week2:FlxSprite;
    var uiShit:FlxSprite;
    // the reason Im adding this is because the playstate crashes the entire game if weekdata
    public static var weekFuckas:String;

    var week2Text:FlxText;
    var asses:FlxTypedGroup<FlxSprite>;
    public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

    override public function create(){        
        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.alpha = 1;
        add(bg);
        uiShit = new FlxSprite().loadGraphic(Paths.image('storey_menu_ui'));
        uiShit.alpha = 1;
        add(uiShit);
        asses = new FlxTypedGroup<FlxSprite>();
        add(asses);
        FlxG.mouse.visible = true;
        super.create();

        //farty sharty
        week1 = new FlxSprite(100, 70).loadGraphic(Paths.image('story0'));
        week1.scale.set(0.8, 0.8);
        week1.updateHitbox();
        asses.add(week1);
        week1Text = new FlxText(80, 480, 320, 'Tutorial\nWeek');
        week1Text.setFormat(Paths.font('vcr.ttf'), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        week1Text.borderSize = 2.75;
        asses.add(week1Text);

        week2 = new FlxSprite(500, 70).loadGraphic(Paths.image('story'));
        week2.scale.set(0.8, 0.8);
        week2.updateHitbox();
        asses.add(week2);
        week2Text = new FlxText(480, 480, 320, 'David\nWeek');
        week2Text.setFormat(Paths.font('vcr.ttf'), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        week2Text.borderSize = 2.75;
        asses.add(week2Text);
    }

    override public function update(elapsed:Float){
        super.update(elapsed);
        var laClick = (FlxG.mouse.overlaps(week1) && FlxG.mouse.justPressed && !lol);
        var laClick2 = (FlxG.mouse.overlaps(week2) && FlxG.mouse.justPressed && !lol);

        if(laClick){ 
            FlxG.sound.play(Paths.sound('confirmMenu'));
            goToWeek('tutorial/tutorial-hard');
        }

        if(laClick2){
            FlxG.sound.play(Paths.sound('confirmMenu'));
            goToWeek2('fuck/fuck-hard');
        }
        if (controls.BACK){
            MusicBeatState.switchState(new MainMenuState());
        }
    }

    function goToWeek(insertsonghere1:String){
        FlxFlicker.flicker(week1, 1, 0.06, false, false, function(flick:FlxFlicker){
            PlayState.isStoryMode = true;
            weekFuckas = 'Tutorial Week';
            trace(weekFuckas);
            PlayState.storyPlaylist = [insertsonghere1];
            PlayState.storyWeek = 1;
            PlayState.storyDifficulty = 2;
            PlayState.campaignScore = 0;
            PlayState.campaignMisses = 0;
            PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0]);
            FlxTween.tween(FlxG.camera, {zoom:5}, 0.8, {ease:FlxEase.expoIn});
            FlxTween.tween(bg, {alpha:0}, 0.8, {ease:FlxEase.expoIn});
            asses.forEach(function(s:FlxSprite){
                FlxTween.tween(s, {alpha:0}, 0.1, {ease:FlxEase.expoIn, 
                    onComplete:function(twn:FlxTween){
                        s.kill();
                    }   
                });
            });
            new FlxTimer().start(1, function(tmr:FlxTimer) {
                LoadingState.loadAndSwitchState(new PlayState());
            });

        });

    }
    function goToWeek2(insertsonghere1:String){
        FlxFlicker.flicker(week2, 1, 0.06, false, false, function(flick:FlxFlicker){
            weekFuckas = '???';
            trace(weekFuckas);
            FlxTween.tween(FlxG.camera, {zoom:5}, 0.8, {ease:FlxEase.expoIn});
            FlxTween.tween(bg, {alpha:0}, 0.8, {ease:FlxEase.expoIn});
            asses.forEach(function(s:FlxSprite){
                FlxTween.tween(s, {alpha:0}, 0.1, {ease:FlxEase.expoIn, 
                    onComplete:function(twn:FlxTween){
                        s.kill();
                    }   
                });
            });
            new FlxTimer().start(1, function(tmr:FlxTimer) {
                Application.current.window.alert("Songs and sprites weren't made. They're coming as soon as the creator learns how to make music.", "Error going into week");
                DiscordClient.shutdown();
                Sys.exit(1);
            });

        });

    }
    function weekIsLocked(weekNum:Int) {
		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[weekNum]);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}
}