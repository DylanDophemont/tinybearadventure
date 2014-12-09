package;

import haxe.Log;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxRandom;

class FightAction extends Action {

	public static var MAX_STRIKES: Int = 5;
	private var _strikes: Int = 0;

	private var _fightSoundOne: FlxSound;
	private var _fightSoundTwo: FlxSound;
	private var _hurtSound: FlxSound;

	private var _isStarted: Bool = false;

	public function new() {
		super(Main.gameWidth/2, Main.gameHeight/2, Action.TYPE_FIGHT);

		this.loadGraphic(AssetPaths.fight__png, true, 32, 32);

		this.animation.add("move", [0, 1, 2], 6, true);
		this.animation.callback = _onFrame;
#if flash
		_fightSoundOne = FlxG.sound.load(AssetPaths.fight1__mp3);
		_fightSoundTwo = FlxG.sound.load(AssetPaths.fight2__mp3);
		_hurtSound = FlxG.sound.load(AssetPaths.hurt__mp3);
#else
		_fightSoundOne = FlxG.sound.load(AssetPaths.fight1__wav);
		_fightSoundTwo = FlxG.sound.load(AssetPaths.fight2__wav);
		_hurtSound = FlxG.sound.load(AssetPaths.hurt__wav);
#end
		this.visible = false;
	}

	override public function start(x, y) {
		super.start(x, y);
		_isStarted = true;
		_strikes = 0;
	}

	private function _onFrame(name, n, i):Void {
		cast(FlxG.state, PlayState).getBear().color = 0xffffffff;
		if (_isStarted && i == 2 && !isOver()) {
			_strikes++;

			if (FlxRandom.chanceRoll(40)) {
				cast(FlxG.state, PlayState).getLives().loseLife();
				_hurtSound.play(true);
				FlxG.camera.shake(.005, .3);
				cast(FlxG.state, PlayState).getBear().color = 0xffdf6a4e;
			} else {
				if (FlxRandom.intRanged(0, 1) == 0) {
					_fightSoundOne.play(true);
				} else {
					_fightSoundTwo.play(true);
				}
			}

			if (_strikes >= MAX_STRIKES) {
				_isStarted = false;
				setIsOver(true);
				this.visible = false;
			}
		}
	}

	override public function destroy():Void {
		_fightSoundOne = FlxDestroyUtil.destroy(_fightSoundOne);
		_fightSoundTwo = FlxDestroyUtil.destroy(_fightSoundTwo);
		_hurtSound = FlxDestroyUtil.destroy(_hurtSound);
		super.destroy();
	}

	override public function update():Void {
		this.animation.play("move");
		super.update();
	}
}
