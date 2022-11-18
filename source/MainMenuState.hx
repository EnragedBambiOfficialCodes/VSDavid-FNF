package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;

//
/*import io.newgrounds.NG;*/ // this is useless -DavidDX
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story_mode', 'freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story_mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	public static var kadeEngineVer:String = "1.2";
	public static var curModVer:String = '0.1';
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		FlxG.mouse.visible = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		var decheckeredbggoesbrr = new FlxBackdrop(Paths.image('Main_Checker'), 0.2, 0.2, true, true);
		decheckeredbggoesbrr.scrollFactor.set(0, 0.07);
		decheckeredbggoesbrr.screenCenter();
		decheckeredbggoesbrr.velocity.set(50,50);
		add(decheckeredbggoesbrr);

		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		//var tex = Paths.getSparrowAtlas('FNF_main_menu_assets'); fuckkkk

		for (i in 0...optionShit.length)
			{
				var menuItem:FNFSprite = new FNFSprite((i * 310) + 70, 900);
				menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.addOffset('selected', (i == 0) ? 600 : 400, 100);
				menuItem.playAnim('idle');
				menuItem.ID = i;
				//menuItem.screenCenter(X);
				menuItems.add(menuItem);
				var scr:Float = (optionShit.length - 4) * 0.135;
				if(optionShit.length < 6) scr = 0;
				menuItem.scrollFactor.set(0, scr);
				menuItem.antialiasing = FlxG.save.data.antialiasing;
				menuItem.setGraphicSize(Std.int(menuItem.width * 0.4));
				menuItem.updateHitbox();
				new FlxTimer().start(0.5, function(tmr:FlxTimer) {
					FlxTween.tween(menuItem, {y: 600}, 0.5, {
							 ease: FlxEase.backOut,
							startDelay: 0.1 + (0.2 * i)
				   });
				});
				
			}

		FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, 'DavidDX Engine ${curModVer} (KE 1.2)', 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		super.create();
	}

	var selectedSomethin:Bool = false;

	var mouse:Bool = false;
	var lol:Bool = true;
	var clickd = FlxG.mouse.justPressed;

	override function update(elapsed:Float)
		{
			menuItems.forEach(function(menu:FlxSprite){
				if(mouse){
					if(!FlxG.mouse.overlaps(menu)){
						menu.animation.play('idle');
					}
				}
				if(FlxG.mouse.overlaps(menu)){
					if(lol){
						curSelected = menu.ID;
						mouse = true;
						menu.animation.play('selected');
					}
					if(FlxG.mouse.justPressed && lol){
						FlxG.mouse.visible = false;
						selectShit();
					}
				}
			});
	
			if (FlxG.sound.music.volume < 0.8)
			{
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			}
	
			if (!selectedSomethin)
			{
				if (controls.BACK)
				{
					FlxG.switchState(new TitleState());
				}
			}
	
			super.update(elapsed);
			
	}

	// Took it from the scrapped psych build!!!
	function selectShit(){
		if (optionShit[curSelected] == 'donate')
			{
				#if linux
				Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
				#else
				FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
				#end
			}
			else
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));



				FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = optionShit[curSelected];

							switch (daChoice)
							{
								case 'story_mode':
									FlxG.switchState(new StoryMenuState());
									trace("Story Menu Selected");
								case 'freeplay':
									FlxG.switchState(new FreeplayState());
									trace("Freeplay Menu Selected");

								case 'options':
									FlxG.switchState(new OptionsMenu());
							}
						});
					}
				});
			}
	}
}
