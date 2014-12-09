package;

import haxe.Log;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxMath;

class Button extends FlxSprite {
	
	private var _id: Int;

	public static var F_SIZE: Int = 16;

	private var _isEnabled:Bool = true;

	public function new(x, y, id:Int) {
		super(x, y);

		loadGraphic(AssetPaths.tilebuttons__png, false, F_SIZE, F_SIZE);

		_id = id;
		this.setId(_id);
	}

	public function getId():Int {
		return _id;
	}

	public function setId(id:Int):Void {
		_id = id;
		this.animation.frameIndex = _id;
		if (_id != 0) {
			_isEnabled = true;
		} else {
			_isEnabled = false;
		}
	}

	public function isEnabled():Bool {
		return _isEnabled;
	}

	override public function update():Void {
		super.update();
	}
}
