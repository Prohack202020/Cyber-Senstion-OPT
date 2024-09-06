import funkin.options.OptionsMenu;
import funkin.backend.MusicBeatState;
import funkin.savedata.FunkinSave;
var virusSpookyPath:String;
var virusShader:CustomShader;
var diff:Float = 0;
var time:Float = 0;

var virusLocked:Bool = false;
var virusIndex:Int = -1;

var curSelected:Int = 0;
var grpSongsText:FlxTypedGroup;
var grpSongBars:FlxTypedGroup;

var selected = false;
var songbar:FlxSprite;
var songText:FunkinText;
var diffText2:FlxText;
var icon:HealthIcon;
var grpIcon:FlxTypedGroup;



//ART
var grpArt:FlxTypedGroup;
var artname = ["mayhem","sha", "ct","old","def","soft","tans","dust","hope"];
var artcover:FlxSprite;

//SONG CHECK
var ch1song = ["Open System","Wear A Mask","Last Hope"];
var mayhemSong = ["You And Me","Fun Till End","Light It Up"];
var shaSong = ["Virus","Malware","Crowd Control", "Errorians", "Our Hope"];

//Background

function create()
{
        //PRELOAD

        for (i in 0...songs.length)
            {
                //curPlayingInstt = Paths.inst(songs[i].name, songs[i].difficulties);
                //FlxG.sound.cache(curPlayingInstt);
                //curPlayingInstt = Paths.inst(songs[i].name, songs[i].difficulties['EX']);
               // FlxG.sound.cache(curPlayingInstt);
               // curPlayingInstt = null;
            }

        for(k=>s in songs) {
			if (s.name == Options.freeplayLastSong) {
				curSelected = k;
			}
		}
		if (songs[curSelected] != null) {
			for(k=>diff in songs[curSelected].difficulties) {
				if (diff == Options.freeplayLastDifficulty) {
					curDifficulty = k;
				}
			}
		}


}
function postCreate() {
    remove(members[1]);
    virusShader = new CustomShader('glitch');
    virusSpookyPath = Paths.getPath("songs/virus/song/her.ogg");

    FlxG.camera.addShader(virusShader);


    //BG
    members[0].visible = false;
    bglol = new FlxSprite(-800, -800);
    bglol.makeGraphic(FlxG.width, FlxG.height, 0xFF616161);
    bglol.scrollFactor.set(0, 0);
    bglol.screenCenter(FlxAxes.XY);
    bgShader = new CustomShader('bgMenu');
    bglol.shader = bgShader;
    add(bglol);


    //Song

    for(i in 0...grpSongs.members.length) 
        {
            if(grpSongs.members[i]!=null) grpSongs.members[i].destroy();
            grpSongs.remove(grpSongs.members[i]);
        }
    for(i in 0...iconArray.length) 
        {
            if(iconArray[i]!=null) iconArray[i].destroy();
            remove(iconArray[i], true);
        }
    
    grpSongs.clear();
    iconArray = [];

    remove(interpColor);

    grpSongBars = new FlxTypedGroup();
	add(grpSongBars);

    grpSongsText = new FlxTypedGroup();
	add(grpSongsText);

   grpIcon = new FlxTypedGroup();
   add(grpIcon);
   
   grpArt = new FlxTypedGroup();
   add(grpArt);





    for (i in 0...songs.length)
		{
			songText = new FunkinText(983.12, (0 * i) + 30,0, songs[i].displayName, 42);
            songText.alignment = 'RIGHT';
            songText.font = Paths.font('freeplay.ttf');
			songText.y = i * 129;

            
            songText.ID = i;
			

            songbar = new FlxSprite(0, (0 * i) + 100);
            songbar.loadGraphic(Paths.image('menus/freeplay/songbar'));
            songbar.antialiasing = true;
            songbar.scrollFactor.set(0, 0);
            songbar.x = FlxG.width - songbar.width + 260;
            songbar.y = songText.y - 33;
            songbar.scale.set(2/3, 2/3);
            songbar.updateHitbox();

            songbar.ID = i;
            
            
            grpSongBars.add(songbar);
            grpSongsText.add(songText);
 

            icon = new HealthIcon(songs[i].icon);
            icon.x = songText.x - 130;
            icon.scale.set(0.6,0.6);
            icon.y = songText.y - 54;
            icon.ID = i;

			grpIcon.add(icon);



		}

    for(i in 0...artname.length)
	{
		artcover = new FlxSprite(94, 115).loadGraphic(Paths.image("menus/freeplay/cover/" + artname[i]));
		artcover.antialiasing = true;
		artcover.scale.set(2/3, 2/3);
        artcover.angle = -10;
        artcover.alpha = 0;
		artcover.updateHitbox();
		artcover.ID = i;
		//if(imgss.ID == 0) imgss.screenCenter(FlxAxes.XY); //512.5 232.5
		//if(imgss.ID == 1) {imgss.screenCenter(FlxAxes.Y); imgss.x = 200; imgss.y +=10;}//200 247
		//if(imgss.ID == 2) {imgss.screenCenter(FlxAxes.Y); imgss.x = 900;}//900 272
		grpArt.add(artcover);
	}

    

    diffText2 = new FunkinText(1050,320, 0, "DIFF", 24);
    diffText2.font = songText.font;
    diffText2.alpha = 1;
    add(diffText2);

    overlay = new FlxSprite(0, 0);
    overlay.loadGraphic(Paths.image('menus/freeplay/overlay'));
    overlay.antialiasing = true;
    overlay.scrollFactor.set(0, 0);
    overlay.updateHitbox();
    add(overlay);

    for(i in 0...songs.length)
        if (songs[i].name == "virus") {
            virusIndex = i;
            break;
        }

    if (virusLocked) {
        for(a in grpSongsText.members[virusIndex].members) {
            var indexes = [for (i in 0...a.frames.frames.length) i];
            var sortedIndexes = [];
            while(indexes.length > 0) {
                var i = indexes[FlxG.random.int(0, indexes.length-1)];
                sortedIndexes.push(i);
                indexes.remove(i);
            }
            a.animation.add("glitch", sortedIndexes, 24, true);
            a.animation.play("glitch");
        }

        iconArray[virusIndex].color = 0xFF000000;
        var tr = iconArray[virusIndex].colorTransform;
        tr.redMultiplier = tr.greenMultiplier = tr.blueMultiplier = 0;
        tr.redOffset = tr.greenOffset = tr.blueOffset = 255;
        tr.alphaMultiplier = 0.5;
        iconArray[virusIndex].blend = 1;
    }

    funText = new FunkinText(10,10, songs[curSelected].displayName, 62);
    funText.alignment = 'RIGHT';
    funText.font = Paths.font('freeplay.ttf');
    funText.text = songs[curSelected].displayName + " - " + songs[curSelected].difficulties[curDifficulty] + " - " + songs[curSelected].composer;
    funText.size = 42;
    funText.antialiasing = true;
    add(funText);

    comText = new FunkinText(10,53, songs[curSelected].displayName, 62);
    comText.alignment = 'RIGHT';
    comText.font = Paths.font('freeplay.ttf');
    comText.text = songs[curSelected].composer;
    comText.size = 32;
    comText.antialiasing = true;
    add(comText);

    scText = new FunkinText(10,FlxG.height - 46, songs[curSelected].displayName, 62);
    scText.alignment = 'LEFT';
    scText.font = Paths.font('freeplay.ttf');
    scText.text = songs[curSelected].composer;
    scText.size = 32;
    scText.antialiasing = true;
    add(scText);

   /*
    changeSelection2(0);
    updateOptions();*/

    changeItem(0, true);
    changedaDiff(0,true);
    scoreBG.visible = diffText.visible  = false;
    addVirtualPad('LEFT_FULL', 'A_B');
    addVirtualPadCamera();

    

}







function postUpdate()
    {
       /*  if (FlxG.keys.pressed.J) diffText2.x -= 5;
        if (FlxG.keys.pressed.L) diffText2.x += 5;
        if (FlxG.keys.pressed.I) diffText2.y -= 5;
        if (FlxG.keys.pressed.K) diffText2.y += 5;
        if (FlxG.keys.pressed.O) trace(diffText2);*/

    }

//Song Preview
/**
 * Time elapsed since last autoplay. If this time exceeds `timeUntilAutoplay`, the currently selected song will play.
 */
public var autoplayElapsedd:Float = 0;
/**
 * Whenever the currently selected song instrumental is playing.
 */
public var songInstPlayingg:Bool = true;
/**
 * Path to the currently playing song instrumental.
 */
public var curPlayingInstt:String = null;
function update(elapsed:Float) {

    if (!selected) {
        if(FlxG.mouse.wheel != 0)
            {
                changeItem(-1 * FlxG.mouse.wheel);
            }
        changeItem((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0));
        changedaDiff((controls.LEFT_P ? -1 : 0) + (controls.RIGHT_P ? 1 : 0));
        changeCoopMode((FlxG.keys.justPressed.TAB ? 1 : 0));

    }
    var dontPlaySongThisFrame = false;

    autoplayElapsedd += elapsed;

    //trace(autoplayElapsedd);
    if (!songInstPlayingg && (autoplayElapsedd > timeUntilAutoplay || FlxG.keys.justPressed.SPACE)) {
        if (curPlayingInstt != (curPlayingInstt = Paths.inst(songs[curSelected].name, songs[curSelected].difficulties[curDifficulty])))
            FlxG.sound.playMusic(curPlayingInstt, 0);
        songInstPlayingg = true;
        dontPlaySongThisFrame = true;
    }

    if (controls.ACCEPT && !dontPlaySongThisFrame)
        {
            selectSong();
        }

    if (FlxG.keys.justPressed.B)
        {
            FlxG.switchState(new MainMenuState());
        }


    virusShader.iTime = (time += elapsed);
    bgShader.iTime = (time += elapsed);

    lerpScore = Math.floor(lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

    scText.text = "PERSONAL BEST: " + lerpScore;




}

function changeItem(change:Int = 0, force:Bool = false)
	{

        if (change == 0 && !force) return;
        var value = FlxMath.wrap(curSelected + change, 0, songs.length-1);
		curSelected = value;
		FlxG.sound.play(Paths.sound('menu/scroll'), 0.7);

        changedaDiff(0,true);
        changeArt();

        var tweenlol:FlxTween;
        diffText2.alpha = 0.5;
        diffText2.y -= 10;
        if(tweenlol != null){tweenlol.cancel();}
        tweenlol = FlxTween.tween(diffText2, {y:320,alpha: 1}, 0.2);



            grpSongsText.forEach(function(text:FunkinText) {
                if (text.ID == curSelected)
                {
                    //trace(text.text);
                    FlxTween.tween(text, {alpha: 1}, 0.2);
                    FlxTween.tween(text, {x: 983.12, y: 280.05}, 0.2, {ease: FlxEase.expoOut});
                    //FlxTween.tween(text, {width:174,height: 42}, 0.2, {ease: FlxEase.expoOut});
                    FlxTween.tween(text.scale, {x:1,y: 1}, 0.2, {ease: FlxEase.expoOut});
                      
                }
                else
                {
                    FlxTween.tween(text, {alpha: 0.5}, 0.2);
                    FlxTween.tween(text, {x:(983.12+ text.ID * 90) - (curSelected * 90) + 400 /2,y: (160 + text.ID * 128) - (curSelected * 128) + 128}, 0.2, {ease: FlxEase.expoOut});
                    //lxTween.tween(text, {width:174/3,height: 42/3}, 0.2, {ease: FlxEase.expoOut});
                    FlxTween.tween(text.scale, {x:2/3,y: 2/3}, 0.2, {ease: FlxEase.expoOut});
                    
                }
            });
            
            grpSongBars.forEach(function(sprite:FlxSprite) {
                if (sprite.ID == curSelected)
                {
                    FlxTween.tween(sprite, {alpha: 1}, 0.2);
                    FlxTween.tween(sprite, {x: 777 , y: 244}, 0.2, {ease: FlxEase.expoOut});
                    FlxTween.tween(sprite.scale, {x:2/3,y: 2/3}, 0.2, {ease: FlxEase.expoOut});
                    //FlxTween.tween(sprite, {width:508}, 0.2, {ease: FlxEase.expoOut});
                    
                }
                else
                {
                    FlxTween.tween(sprite, {alpha: 0.5}, 0.2);
                    //777+100
                    FlxTween.tween(sprite, {x:(777 + sprite.ID * 90) - (curSelected * 90) + 400 /2 + 40, y: (119.05 + sprite.ID * 128) - (curSelected * 128) + 128}, 0.2, {ease: FlxEase.expoOut});
                    FlxTween.tween(sprite.scale, {x:0.5,y: 0.5}, 0.2, {ease: FlxEase.expoOut});
                   // FlxTween.tween(sprite, {width:600}, 0.2, {ease: FlxEase.expoOut});
                }
            });

            grpIcon.forEach(function(sprite:HealthIcon) {
                if (sprite.ID == curSelected)
                {
                    FlxTween.tween(sprite, {alpha: 1}, 0.2);
                    FlxTween.tween(sprite, {x: 983.12-130, y: 280.05-54}, 0.2, {ease: FlxEase.expoOut});
                    FlxTween.tween(sprite.scale, {x:0.6,y: 0.6}, 0.2, {ease: FlxEase.expoOut});
                
                }
                else
                {
                    FlxTween.tween(sprite, {alpha: 0.5}, 0.2);
                    FlxTween.tween(sprite, {x:(983.12-70+ sprite.ID * 90) - (curSelected * 90) + 400 /2,y: (100  + sprite.ID * 128) - (curSelected * 128) + 128}, 0.2, {ease: FlxEase.expoOut});

                    FlxTween.tween(sprite.scale, {x:2/5,y: 2/5}, 0.2, {ease: FlxEase.expoOut});
                    
                }
            });

        autoplayElapsedd = 0;
        songInstPlayingg = false;
        coopText.visible = songs[curSelected].coopAllowed || songs[curSelected].opponentModeAllowed;

        funText.text = songs[curSelected].displayName + " - " + songs[curSelected].difficulties[curDifficulty];
        updateScore();
        comText.text = songs[curSelected].composer;
        
    }

	public function changedaDiff(change:Int = 0, force:Bool = false)
	{
		if (change == 0 && !force) return;

		var curSong = songs[curSelected];
		var validDifficulties = curSong.difficulties.length > 0;

        var value = FlxMath.wrap(curDifficulty + change, 0, curSong.difficulties.length-1);
		curDifficulty = value;

		updateScore();

		if (curSong.difficulties.length > 1)
        {
			diffText2.text = '< '+ curSong.difficulties[curDifficulty]+' >';
        }

		else
        {
                diffText2.text = validDifficulties ? curSong.difficulties[curDifficulty] : "-";
        }

        funText.text = songs[curSelected].displayName + " - " + songs[curSelected].difficulties[curDifficulty];

	}


function changeArt()
{

    var curSong = songs[curSelected].displayName;

    switch(curSong)
    {
        case "Open System","Wear A Mask","Last Hope":
            grpArt.forEach(function(sprite:FlxSprite) {
                if(sprite.ID == 3)
                {
                    FlxTween.tween(sprite, {alpha: 1}, 0.2);
                    FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
                }
                else
                {
                    FlxTween.tween(sprite, {alpha: 0}, 0.2);
                    FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
                }

            });
        case "You And Me","Fun Till End","Light It Up":
            grpArt.forEach(function(sprite:FlxSprite) {
                if(sprite.ID == 0)
                    {
                        FlxTween.tween(sprite, {alpha: 1}, 0.2);
                        FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
                    }
                    else
                    {
                        FlxTween.tween(sprite, {alpha: 0}, 0.2);
                        FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
                    }
            });
        case "Virus","Malware","Crowd Control", "Errorians":
            grpArt.forEach(function(sprite:FlxSprite) {
                if(sprite.ID == 1)
                {
                    FlxTween.tween(sprite, {alpha: 1}, 0.2);
                    FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
                }
                else
                {
                    FlxTween.tween(sprite, {alpha: 0}, 0.2);
                    FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
                }

            });
        case "Underground", "Karma":
            grpArt.forEach(function(sprite:FlxSprite) {
                if(sprite.ID == 6)
                    {
                        FlxTween.tween(sprite, {alpha: 1}, 0.2);
                        FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
                    }
                    else
                    {
                        FlxTween.tween(sprite, {alpha: 0}, 0.2);
                        FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
                    }
            });
        case "New Hope", "Hoax":
            grpArt.forEach(function(sprite:FlxSprite) {
                if(sprite.ID == 7)
                    {
                        FlxTween.tween(sprite, {alpha: 1}, 0.2);
                        FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
                    }
                    else
                    {
                        FlxTween.tween(sprite, {alpha: 0}, 0.2);
                        FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
                    }
            });
        case "Our Hope":
            grpArt.forEach(function(sprite:FlxSprite) {
                if(sprite.ID == 8)
                    {
                        FlxTween.tween(sprite, {alpha: 1}, 0.2);
                        FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
                    }
                    else
                    {
                        FlxTween.tween(sprite, {alpha: 0}, 0.2);
                        FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
                    }
            });
        default:
            grpArt.forEach(function(sprite:FlxSprite) {
                if(sprite.ID == 4)
                    {
                        FlxTween.tween(sprite, {alpha: 1}, 0.2);
                        FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
                    }
                    else
                    {
                        FlxTween.tween(sprite, {alpha: 0}, 0.2);
                        FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
                    }
        });

    }


    
}

public function selectSong() {
    updateCoopModes();

    if (songs[curSelected].difficulties.length <= 0) return;
    Options.freeplayLastSong = songs[curSelected].name;
    Options.freeplayLastDifficulty = songs[curSelected].difficulties[curDifficulty];

    PlayState.loadSong(songs[curSelected].name, songs[curSelected].difficulties[curDifficulty],__opponentMode, __coopMode);
    FlxG.switchState(new PlayState());
    //FlxG.switchState(new PlayState());
}

function updateScore() {
    if (songs[curSelected].difficulties.length <= 0) {
        intendedScore = 0;
        return;
    }
    var changes:Array<HighscoreChange> = [];
    var saveData = FunkinSave.getSongHighscore(songs[curSelected].name, songs[curSelected].difficulties[curDifficulty], changes);
    intendedScore = saveData.score;
}




//TURN OFF OLD FUNCTION
function onChangeDiff(event)
    {
        event.cancelled = true;
    }
function onChangeSelection(event)
    {
        event.cancelled = true;
    }
function onUpdateOptionsAlpha(event)
    {
        event.cancelled = true;
    }
function onSelect(event)
    {
        event.cancelled = true;
    }

