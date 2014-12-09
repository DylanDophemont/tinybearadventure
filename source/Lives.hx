package;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;

class Lives extends FlxTypedGroup<FlxSprite> {
	
	public static var F_SIZE: Int = 8;
	public static var MAX_LIVES: Int = 5;

	private var _lives: Int = 5;

	public function new(x, y) {
		super();

		for (i in 0..._lives) {
			var h = new FlxSprite(x-(F_SIZE*2+F_SIZE*i)-(i*F_SIZE/4), y+F_SIZE/2).loadGraphic(AssetPaths.heart__png, false, F_SIZE, F_SIZE);
			h.animation.frameIndex = 1;
			this.add(h);
		}
	}

	public function gainLife():Void {
		if (_lives < MAX_LIVES) {
			this.members[_lives].animation.frameIndex = 1;
			_lives++;
		}
	}

	public function loseLife():Void {
		if (_lives > 0) {
			_lives--;
			this.members[_lives].animation.frameIndex = 0;
		}
	}

	public function getNumLives():Int {
		return _lives;
	}

}
