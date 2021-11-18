package;

import flixel.FlxSprite;

import flixel.system.FlxSound;

import flixel.util.FlxTimer;

import flixel.*;

import flixel.tweens.FlxEase;

import flixel.tweens.FlxTween;

class WarningState extends MusicBeatState

{

var music:FlxSound;

var wentout:Bool = false;

override function create()

{

super.create();

FlxG.sound.music.fadeIn(0.5, 0.7, 0.1);

var WS:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('WarningScreen', 'preload'));

add(WS);

}

override function update(elapsed:Float)

{

if (controls.ACCEPT && !wentout)

{

wentout = true;

FlxG.sound.music.fadeIn(0.5, 0.1, 0.7);

FlxG.switchState(new MainMenuState());

}

super.update(elapsed);

}



}
