package;

import haxe.Log;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.util.FlxDestroyUtil;

class EatAction extends Action {

	public static var MAX_TRIES: Int = 3;
	private var _tries: Int = 0;

	private var _isStarted: Bool = false;

	private var _splashSound: FlxSound;
	private var _eatSound: FlxSound;

	public function new() {
		super(Main.gameWidth/2, Main.gameHeight/2, Action.TYPE_EAT);

		this.loadGraphic(AssetPaths.eat__png, true, 32, 32);

		this.animation.add("move", [0, 1], 4, true);
		this.animation.callback = _onFrame;

		#if flash
			_eatSound = FlxG.sound.load(AssetPaths.bite__mp3);
			_splashSound = FlxG.sound.load(AssetPaths.splash__mp3);
		#else 
			_eatSound = FlxG.sound.load(AssetPaths.bite__wav);
			_splashSound = FlxG.sound.load(AssetPaths.splash__wav);
		#end

		this.visible = false;
	}

	override public function start(x, y) {
		super.start(x, y);
		_isStarted = true;
		_tries = 0;
		_splashSound.play(true);
	}

	private function _onFrame(name, n, i):Void {
		if (_isStarted && i == 1 && !isOver()) {
			_tries++;
			if (_tries >= MAX_TRIES) {
				_eatSound.play(true);
				_isStarted = false;
				setIsOver(true);
				this.visible = false;
			}
		}
	}

	override public function destroy():Void {
		_eatSound = FlxDestroyUtil.destroy(_eatSound);
		_splashSound = FlxDestroyUtil.destroy(_splashSound);
		super.destroy();
	}

	override public function update():Void {
		this.animation.play("move");
		super.update();
	}
}
