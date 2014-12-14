package;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;

class Lives extends FlxTypedGroup<FlxSprite> {
	
	public static var F_SIZE: Int = 8;
	public static var MAX_LIVES: Int = 5;

	private var _lives: Int = 5;

	private var _numLives: GameText;

	public function new(x, y) {
		super();

		var h = new FlxSprite(x-F_SIZE*2, y+F_SIZE/2).loadGraphic(AssetPaths.heart__png, false, F_SIZE, F_SIZE);
		h.animation.frameIndex = 1;
		this.add(h);

		_numLives = new GameText(x-F_SIZE*3.1, y+F_SIZE/3.5, Std.string(_lives));
		this.add(_numLives);
	}

	public function gainLife():Void {
		if (_lives < MAX_LIVES) {
			_lives++;
			_numLives.text = Std.string(_lives);
		}
	}

	public function loseLife():Void {
		if (_lives > 0) {
			_lives--;
			_numLives.text = Std.string(_lives);
		}
	}

	public function getNumLives():Int {
		return _lives;
	}

}
