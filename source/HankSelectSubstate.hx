package;

//import flixel.system.macros.FlxAssetPaths;
import flixel.addons.transition.FlxTransitionableState;
import flixel.input.gamepad.FlxGamepad;
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
import io.newgrounds.NG;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
//import flixel.system.FlxAssets;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class HankSelectSubstate extends MusicBeatSubstate
{
	var curSelected:Int = 0;
    var curDiff:Int = 0;

    var backdropColors:Array<Int> = [0xFF00d0ff, 0xFF9aab2e, 0xFFc02c2c, 0xFFff9100];

	var curSelectedText:FlxText;
	public static var firstStart:Bool = true;

    var diffShit:Array<String> = ['easy', 'normal', 'hard', 'insane'];

	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;
	
	public var imageDiff:FlxSprite;
    public static var tweened:Bool = false;

    var hank:FlxSprite;

    var accelerantWord:FlxSprite;
    var backdrop:FlxBackdrop;
    var pressEnter:FlxSprite;
    var pbText:FlxText;
    var arrow:FlxSprite;
    var leftArrowHitBox:FlxSprite;
    var rightArrowHitBox:FlxSprite;

	override function create()
	{
        #if debug
		FlxG.debugger.drawDebug = true;
		#end
        
        if (!FlxG.sound.music.playing)
            {
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
            }
            
        FlxTransitionableState.defaultTransIn = null;
		FlxTransitionableState.defaultTransOut = null;
        
        super.create();

        backdrop = new FlxBackdrop(Paths.image('menuDesat'));
		backdrop.y = 0;
		backdrop.velocity.set(-50, 0);
		add(backdrop);

        accelerantWord = new FlxSprite(-400, -10);   //460
        accelerantWord.frames = Paths.getSparrowAtlas('KadeEngineLogoBumpin');
        accelerantWord.animation.addByPrefix('idle', 'logo bumpin', 24, true);
        accelerantWord.animation.play('idle');
        add(accelerantWord);
        FlxTween.tween(accelerantWord, {x: 460}, 1, {ease: FlxEase.expoInOut});

        var behindOptions = new FlxSprite(0, 0);
		behindOptions.frames = Paths.getSparrowAtlas('behind_options', 'shared');
		behindOptions.animation.addByPrefix('idle', 'idle', 24, true);
		behindOptions.animation.play('idle');
		behindOptions.scrollFactor.set();
		add(behindOptions);

        hank = new FlxSprite(100, -900);
        hank.frames = Paths.getSparrowAtlas('characters/STEVE', 'shared');
        hank.animation.addByPrefix('hank', 'STEVE idle dance', 24, true, false, false);
        hank.animation.play('hank');
        add(hank);

        FlxTween.tween(hank, {y: 60}, 1, {ease: FlxEase.expoInOut});

        imageDiff = new FlxSprite(1280, 320);
        imageDiff.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
        imageDiff.animation.addByPrefix('easy', 'EASY');
        imageDiff.animation.addByPrefix('normal', 'NORMAL', 24, true);
        imageDiff.animation.addByPrefix('hard', 'HARD');
        imageDiff.animation.addByPrefix('insane', 'INSANE');
        //imageDiff.animation.play('baby');
        add(imageDiff);

        FlxTween.tween(imageDiff, {x: 600}, 1, {ease: FlxEase.expoInOut});
        tweened = true;

        pressEnter = new FlxSprite(350, 500);
        pressEnter.frames = Paths.getSparrowAtlas('titleEnter');
        pressEnter.animation.addByPrefix('idle', 'Press Enter To Begin', 24, true, false, false);
        pressEnter.scale.set(0.7, 0.7);
        pressEnter.animation.play('idle');
        add(pressEnter);

        FlxTween.tween(pressEnter, {y: 400}, 1, {ease: FlxEase.expoInOut});

        pbText = new FlxText(570, 485, 0, 'placeholder', 32);
        pbText.font = Paths.font('vcr.ttf');
        pbText.color = FlxColor.WHITE;
        pbText.alpha = 0;
        //add(pbText);

        FlxTween.tween(pbText, {alpha: 1}, 1);

        arrow = new FlxSprite(20, 20);
        arrow.frames = Paths.getSparrowAtlas('back_arrow');
        arrow.animation.addByPrefix('static', 'back arrow static');
        arrow.animation.addByPrefix('selected', 'back arrow selected');
        arrow.animation.play('static');
        add(arrow);

        leftArrowHitBox = new FlxSprite(600, 320).makeGraphic(42, 76, FlxColor.WHITE);
        leftArrowHitBox.alpha = 0;
        add(leftArrowHitBox);

        rightArrowHitBox = new FlxSprite(620, 320).makeGraphic(42, 76, FlxColor.WHITE);
        rightArrowHitBox.alpha = 0;
        add(rightArrowHitBox);

        changeDiff();

        //pbText.text = 'BEST RUN: \nScore: ${Highscore.getScore('accelerant', curSelected)}\nCombo: ${Highscore.getCombo('accelerant', curSelected)}';
    }
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.LEFT)
            {
                changeDiff(-1);
            }
        if (FlxG.keys.justPressed.RIGHT)
            {
                changeDiff(1);
            }
        if (FlxG.keys.justPressed.ESCAPE)
            {
                FlxG.switchState(new MainMenuState());
            }

        if (FlxG.mouse.overlaps(arrow)) {
            arrow.animation.play('selected');
            arrow.updateHitbox();
            if (FlxG.mouse.justPressed) {
                getOut();
            }
        }
        else {
            arrow.animation.play('static');
            arrow.updateHitbox();
        }

        if (FlxG.mouse.overlaps(imageDiff)) {
            if (FlxG.mouse.wheel == 1) {
                changeDiff(1);
            }
            if (FlxG.mouse.wheel == -1) {
                changeDiff(-1);
            }
        }

        if (FlxG.mouse.overlaps(leftArrowHitBox)) {
            if (FlxG.mouse.justPressed) {
                changeDiff(-1);
            }
        }
        if (FlxG.mouse.overlaps(rightArrowHitBox)) {
            if (FlxG.mouse.justPressed) {
                changeDiff(1);
            }
        } 

        
        if (FlxG.keys.justPressed.ENTER) {
        //    PUT CODE HERE!! THIS IS JUST FOR REFERENCE
            switch (curDiff) {
                case 0:
                    PlayState.SONG = Song.loadFromJson('ugh-easy', 'ugh');
                    PlayState.storyDifficulty = 0;
                case 1:
                    PlayState.SONG = Song.loadFromJson('ugh', 'ugh');
                    PlayState.storyDifficulty = 2;
                case 2:
                    PlayState.SONG = Song.loadFromJson('ugh-hard', 'ugh');
                    PlayState.storyDifficulty = 3;
                case 3:
                    PlayState.SONG = Song.loadFromJson('ugh-insane', 'ugh');
                    PlayState.storyDifficulty = 4;
            }
            PlayState.isStoryMode = false;
            var blackLmao:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
            add(blackLmao);
            // little thingy here for eyes as well
            var eyes:FlxSprite = new FlxSprite(100, 100).loadGraphic(Paths.image('eyes/eye'));
            add(eyes);

            var flash:FlxSprite = new FlxSprite(eyes.x, eyes.y).loadGraphic(Paths.image('eyes/flash'));
            (flash);
            
            new FlxTimer().start(1, function(tmr:FlxTimer)
                {
                    remove(flash);
                });
            new FlxTimer().start(2, function(tmr:FlxTimer) 
                {
                    LoadingState.loadAndSwitchState(new PlayState());
                });
        }
        
    }

    function changeDiff(change:Int = 0) {
        curDiff += change;

        if (curDiff > 2)
            curDiff = 0;
        if (curDiff < 0)
            curDiff = 2;

        switch (curDiff) {
            case 0:
                imageDiff.animation.play('easy');
                rightArrowHitBox.x = 857;
            case 1:
                imageDiff.animation.play('normal');
                rightArrowHitBox.x = 867;
            case 2:
                imageDiff.animation.play('hard');
                rightArrowHitBox.x = 932;
            case 3:
                imageDiff.animation.play('insane');
                rightArrowHitBox.x = 942;
        }

        trace(rightArrowHitBox.x);

        //pbText.text = 'BEST RUN: \nScore: ${Highscore.getScore('accelerant', curSelected)}\nCombo: ${Highscore.getCombo('accelerant', curSelected)}';

        FlxTween.tween(backdrop, {color: backdropColors[curDiff]}, 0.001, {ease: FlxEase.expoInOut});
    }

    function getOut() {
        FlxG.sound.play(Paths.sound('cancelMenu'));
        FlxTween.tween(pressEnter, {y: 720}, 0.2, {ease: FlxEase.expoInOut});
        FlxTween.tween(hank, {y: -900}, 0.2, {ease: FlxEase.expoInOut});
        FlxTween.tween(imageDiff, {x: 1280}, 0.2, {ease: FlxEase.expoInOut});
        FlxTween.tween(accelerantWord, {x: -400}, 0.1, {ease: FlxEase.expoInOut});
        new FlxTimer().start(0.3, function(tmr:FlxTimer)
            {
                close();
            });
    }
}
