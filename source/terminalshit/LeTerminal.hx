package terminalshit;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import flixel.FlxG;
import lime.app.Application;
import flixel.math.FlxRandom;
import flixel.tweens.FlxTween;
import haxe.ds.Map;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import openfl.system.System;

import LoadingState;

using StringTools;

class LeTerminal extends FlxState{

    public var curChar:String = '';
    public var leText1:String = 'Vs DavidDX Command Prompt v0.1 \nAll rights reserved\n>';
    public var text:FlxText;
    public var DaList:Array<DaCommandos> = new Array<DaCommandos>();//DA COMANDOS

    var unfilteredSymbols:Array<String> =
    [
        "period",
        "backslash",
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine",
        "zero",
        "shift",
        "semicolon",
        "alt",
        "lbracket",
        "rbracket",
        "comma",
        "plus"
    ];

    var filteredSymbols:Array<String> =
    [
        ".",
        "/",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "0",
        "",
        ";",
        "",
        "[",
        "]",
        ",",
        "="
    ];
    public var fakely_typed_text:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
    override public function create(){
        Main.fpsVar.visible = false;
        // why is it even nessesary UPDATE: Imma add isTerminalMode onto PlayState for el covers :)
        text = new FlxText(0,0,FlxG.width,32);
        text.text = leText1;
        text.setFormat(Paths.font('vcr.ttf'), 16);
        text.size *= 2;
        text.antialiasing = false;
        add(text);
        super.create();

        DaList.push(new DaCommandos("exit", 'Closes the game', function(arguments:Array<String>){
            resetText(false);
            System.exit(1);
        }));
        DaList.push(new DaCommandos("exittomainmenu", 'Exits to Main Menu', function(arguments:Array<String>){
            resetText(false);
            FlxG.switchState(new TitleState());
        }));
        DaList.push(new DaCommandos("gotosong", 'Goes to a song', function(arguments:Array<String>){
            if(arguments.length != 1){
                resetText(false);
                updateTextSex('\nNot enough arguments. Expected [songname]');
            }
            else{
                switch(arguments[0]){
                    case 'dadbattle':
                        gotosong('dad-battle-hard', 'dad-battle');
                }
            }
        }));
        
    }
    public function updateTextSex(value:String){
        text.text = leText1 + value;
    }

    public function resetText(boolean:Bool){
        leText1 = text.text + (boolean ? "\n> " : "");
        text.text = leText1;
        curChar = "";
        var finalthing:String = "";
        var splits:Array<String> = text.text.split("\n");
        if (splits.length <= 22)
        {
            return;
        }
        var split_end:Int = Math.round(Math.max(splits.length - 22,0));
        for (i in split_end...splits.length)
        {
            var split:String = splits[i];
            if (split == "")
            {
                finalthing = finalthing + "\n";
            }
            else
            {
                finalthing = finalthing + split + (i < (splits.length - 1) ? "\n" : "");
            }
        }
        leText1 = finalthing;
        text.text = finalthing;
    }
    

    override public function update(elapsed:Float){
        super.update(elapsed);
        var keyJustPressed:FlxKey = cast(FlxG.keys.firstJustPressed(), FlxKey);

        if (keyJustPressed == FlxKey.ENTER)
        {
            var calledFunc:Bool = false;
            var arguments:Array<String> = curChar.split(" ");
            for (v in DaList)
            {
                if (v.commandFucked == arguments[0] || (v.commandFucked == curChar && v.deAnotherBoolean)) //argument 0 should be the actual command at the moment
                {
                    arguments.shift();
                    calledFunc = true;
                    v.DaCall(arguments);
                    break;
                }
            }
            if (!calledFunc)
            {
                resetText(false); //resets the text
                updateTextSex(arguments[0] + " is not recognized as internal or external command, \noperable program or batch file.");
            }
            resetText(true);
            return;
        }

        if (keyJustPressed != FlxKey.NONE)
        {
            if (keyJustPressed == FlxKey.BACKSPACE)
            {
                curChar = curChar.substr(0,curChar.length - 1);

            }
            else if (keyJustPressed == FlxKey.SPACE)
            {
                curChar += " ";

            }
            else
            {
                var toShow:String = keyJustPressed.toString().toLowerCase();
                for (i in 0...unfilteredSymbols.length)
                {
                    if (toShow == unfilteredSymbols[i])
                    {
                        toShow = filteredSymbols[i];
                        break;
                    }
                }
                if (FlxG.keys.pressed.SHIFT)
                {
                    toShow = toShow.toUpperCase();
                }
                curChar += toShow;
            }
            updateTextSex(curChar);
        }
        if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.BACKSPACE)
        {
            curChar = "";
        }
        if (FlxG.keys.justPressed.ESCAPE)
        {
            Main.fpsVar.visible = ClientPrefs.showFPS;
            FlxG.switchState(new MainMenuState());
        }
    }

    function gotosong(path:String, songy:String){
        PlayState.isStoryMode = false;
        PlayState.SONG = Song.loadFromJson(path, songy);
        PlayState.storyDifficulty = 2;
        PlayState.storyWeek = 2;
        PlayState.campaignScore = 0;

        LoadingState.loadAndSwitchState(new PlayState());
    }

}
class DaCommandos{
    public var commandFucked:String = 'undefined';
    public var help:String = 'If you read this, fuck you'; // - DaveXC
    public var DaCall:Dynamic;
    public var deBoolean:Bool;
    public var deAnotherBoolean:Bool;

    public function new(command:String, helpMe:String, leCall:Dynamic, deBoolean = true, deAnotherBoolean:Bool = false){
        commandFucked = command;
        help = helpMe;
        DaCall = leCall;
        this.deBoolean = deBoolean;
        this.deAnotherBoolean = deAnotherBoolean;
    }

}