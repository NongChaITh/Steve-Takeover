package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	// steve dialog sound shit
	var swagDialogSteve:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'ugh':
				FlxG.sound.playMusic(Paths.music('CoolBackground'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			
			case 'ugh':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(-1500, 10);
		portraitLeft.frames = Paths.getSparrowAtlas('DialogueSteve/STEVE', 'shared');
		portraitLeft.animation.addByPrefix('normal', 'Steve 1 idle', 24, false);
		portraitLeft.animation.addByPrefix('being', 'Steve 2 idle', 24, false);
		portraitLeft.animation.addByPrefix('angry', 'Steve 3 idle', 24, false);
		portraitLeft.animation.addByPrefix('mad', 'Steve 4 idle', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		portraitLeft.screenCenter(X);
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(700, 200);
		portraitRight.frames = Paths.getSparrowAtlas('DialogueSteve/bfPortraits', 'shared');
		portraitRight.animation.addByPrefix('normal', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		/*swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);*/

		swagDialogSteve = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogSteve.font = 'Pixel Arial 11 Bold';
		swagDialogSteve.color = 0xFF3F2021;
		swagDialogSteve.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogSteve);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			//swagDialogue.color = FlxColor.WHITE;
			swagDialogSteve.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		//dropText.text = swagDialogue.text;
		dropText.text = swagDialogSteve.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'ugh')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogSteve.alpha -= 1 / 5;
						dropText.alpha = swagDialogSteve.alpha;
						//swagDialogue.alpha -= 1 / 5;
						//dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogSteve.text = ;
		swagDialogSteve.resetText(dialogueList[0]);
		swagDialogSteve.start(0.04, true);
		//swagDialogue.resetText(dialogueList[0]);
		//swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'steve':
				portraitRight.visible = false;
				swagDialogSteve.sounds = [FlxG.sound.load(Paths.sound('Steve-dialogue-voice'), 0.6)];
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			case 'steve2':
				portraitRight.visible = false;
				swagDialogSteve.sounds = [FlxG.sound.load(Paths.sound('Steve-dialogue-voice'), 0.6)];
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			case 'steve3':
				portraitRight.visible = false;
				swagDialogSteve.sounds = [FlxG.sound.load(Paths.sound('Steve-dialogue-voice'), 0.6)];
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			case 'mad':
				portraitRight.visible = false;
				swagDialogSteve.sounds = [FlxG.sound.load(Paths.sound('Steve-dialogue-voice'), 0.6)];
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}

			case 'bf':
				portraitLeft.visible = false;
				box.flipX = false;
				swagDialogSteve.sounds = [FlxG.sound.load(Paths.sound('boyfriendText'), 0.6)];
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
			
		if (curCharacter.startsWith('steve'))
			{
				box.flipX = true;
				if (curCharacter.contains('being'))
				{
					portraitLeft.animation.play('being');
				}
				else if (curCharacter.contains('angry'))
				{
					portraitLeft.animation.play('angry');
				}
				else if (curCharacter.contains('mad'))
				{
					portraitLeft.animation.play('mad');
				}
				else
				{
					portraitLeft.animation.play('normal');
				}
			}
			else if (curCharacter.startsWith('bf'))
			{
				box.flipX = false;
				if (curCharacter.contains('normal'))
				{
					portraitRight.animation.play('normal');
				}
			}
		}
	}
