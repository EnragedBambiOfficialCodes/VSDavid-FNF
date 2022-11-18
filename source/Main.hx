package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
#if CRASH_HANDLER
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

using StringTools;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 120; // How many frames per second the game should run at.
	var skipSplash:Bool = false; // the fuck
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();
		//The fuck?? wwwweeeeeeeeeeeeeaaaaaaaaaaaaauuuuuuuuuhhhhhhhhhhhhggggggggggg phooone
		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end
		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	// gonna create a crash handler...
	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end

		
		
	}
	// this was made by me though lol just a fix of mine though -DaveXC
	 // Crash handler if this works though
	// why doesn't it do anything bruh naw what the fuck???????????????????????????????
	//pussy
	#if CRASH_HANDLER
	private  function onCrash(e:UncaughtErrorEvent):Void
	 {
		 var errMsg:String = "";
		 var path:String;
		 var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		 var dateNow:String = Date.now().toString();
 
		 dateNow = dateNow.replace(" ", "_");
		 dateNow = dateNow.replace(":", "'");
 
		 path = "./crash_log/" + "KE_" + dateNow + ".txt";
 
		 for (stackItem in callStack)
		 {
			 switch (stackItem)
			 {
				 case FilePos(s, file, line, column):
					 errMsg += file + " (line " + line + ")\n";
				 default:
					 Sys.println(stackItem);
			 }
		 }
 
		 errMsg += "\nUncaught Error: " + e.error;

		 if (!FileSystem.exists("./crash_log/"))
			FileSystem.createDirectory("./crash_log/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));
 
		 Application.current.window.alert(errMsg, "Error!");
		 Sys.exit(1);
	 }
	 #end

	
}
