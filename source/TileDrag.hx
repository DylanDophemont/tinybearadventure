package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;

class TileDrag extends FlxSprite {
	
	private var _id: Int;

	public static var F_SIZE: Int = 16;

	private var _fromButton: Button = null;

	public function new() {
		super();

		_id = 0;

		loadGraphic(AssetPaths.tiles__png, false, F_SIZE, F_SIZE);
		this.animation.frameIndex = _id;

		this.offset = new FlxPoint(F_SIZE/2, F_SIZE/2);
	}

	public function getId():Int {
		return _id;
	}

	public function getButton():Button {
		return _fromButton;
	}

	public function setButton(b:Button):Void {
		if (b != null) {
			_id = b.getId();
			_fromButton = b;
			this.animation.frameIndex = _id;
		} else {
			_fromButton = null;
		}
	}

	override public function update():Void {
		super.update();

		if (FlxG.mouse.pressed) {
			var p = FlxG.mouse.getWorldPosition();
			this.x = p.x;
			this.y = p.y;
		} else {
			this.kill();
		}
	}
}
