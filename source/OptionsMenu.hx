package;

import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{
		if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;
		
		if (FlxG.save.data.noteskin == null)
			FlxG.save.data.noteskin = 0;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		
		//Note skin text stuff here
		var h;
		if (FlxG.save.data.noteskin == 1) h = 'Circle note skin' ;
		else if (FlxG.save.data.noteskin == 2) h = 'ddr note skin';
		else if (FlxG.save.data.noteskin == 3) h = 'flixel note skin';
		else h = 'normal note skin';
		
		controlsStrings = CoolUtil.coolStringFile((FlxG.save.data.dfjk ? 'DFJK' : 'WASD') + "\n" + (FlxG.save.data.newInput ? "New input" : "Old Input") + "\n" + (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll') + '\n'+ h + "\nLoad replays"+"\nCheck for updates");
		
		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}


		versionShit = new FlxText(5, FlxG.height - 18, 0, "Offset (Left, Right): " + FlxG.save.data.offset, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

			if (controls.BACK)
				FlxG.switchState(new MainMenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			
			if (controls.RIGHT_R)
			{
				FlxG.save.data.offset++;
				versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
			}

			if (controls.LEFT_R)
				{
					FlxG.save.data.offset--;
					versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
				}
	

			if (controls.ACCEPT)
			{
				if (curSelected != 4)
					grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.dfjk = !FlxG.save.data.dfjk;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.dfjk ? 'DFJK' : 'WASD'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected;
						grpControls.add(ctrl);
						if (FlxG.save.data.dfjk)
							controls.setKeyboardScheme(KeyboardScheme.Solo, true);
						else
							controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
						
					case 1:
						FlxG.save.data.newInput = !FlxG.save.data.newInput;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.newInput ? "New input" : "Old Input"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
					case 2:
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						grpControls.add(ctrl);
					case 3:
						FlxG.save.data.noteskin = FlxG.save.data.noteskin + 1;
						if (FlxG.save.data.noteskin > 3) FlxG.save.data.noteskin = 0;
						
						var h;
						if (FlxG.save.data.noteskin == 1) h = 'Circle note skin';
						else if (FlxG.save.data.noteskin == 2) h = 'ddr note skin';
						else if (FlxG.save.data.noteskin == 3) h = 'flixel note skin';
						else h = 'normal note skin';
						
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, h, true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						grpControls.add(ctrl);
					case 4:
						trace('switch');
						FlxG.switchState(new LoadReplayState());
					case 5: 
						trace('wants update lol');
						var http = new haxe.Http("https://raw.githubusercontent.com/Spongeyboi/Jade-Engine/master/version.downloadMe");

						http.onData = function (data:String) {

							if (!MainMenuState.kadeEngineVer.contains(data.trim()) && !OutdatedSubState.leftState)
							{
								trace('outdated lmao! ' + data.trim() + ' != ' + MainMenuState.kadeEngineVer);
								OutdatedSubState.needVer = data;
								FlxG.switchState(new OutdatedSubState());
							}
							else
							{
								var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "No updates needed", true, false);
								  ctrl.isMenuItem = true;
								  ctrl.targetY = curSelected - 5;
								  grpControls.add(ctrl);
							}
						}

						http.onError = function (error) {
						  trace('error: $error');
						  var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Error checking for updates", true, false);
						  ctrl.isMenuItem = true;
						  ctrl.targetY = curSelected - 5;
						  grpControls.add(ctrl);
						}

						http.request();
						FlxG.switchState(new OutdatedSubState());
				}
			}
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
