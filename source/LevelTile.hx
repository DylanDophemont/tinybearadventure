package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;

class LevelTile extends FlxSprite {

	public static var NONE: Int = 0;
	public static var PLAIN: Int = 1;
	public static var DUNGEON: Int = 2;
	public static var FOOD: Int = 3;

	private var _id: Int;

	public static var F_SIZE: Int = 16;

	private var _hasBear:Bool = false;

	public function new(x, y, id:Int) {
		super(x, y);

		_id = id;

		loadGraphic(AssetPaths.tiles__png, false, F_SIZE, F_SIZE);
		this.animation.frameIndex = _id;

		this.offset = new FlxPoint(F_SIZE/2, F_SIZE/2);
	}

	public function hasBear():Bool {
		return _hasBear;
	}

	public function setBear(b:Bool) {
		_hasBear = b;
	}

	public function setId(id:Int):Void {
		_id = id;
		this.animation.frameIndex = _id;
	}

	public function getId():Int {
		return _id;
	}

	override public function update():Void {
		super.update();

		var p = cast(FlxG.state, PlayState);

		if (!PlayState.tilePlaced && p.getBear().isDone) {
			var d = p.getTileDrag();
			if (d.alive && d.getId() != _id && !_hasBear && FlxG.mouse.justReleased && FlxMath.distanceBetween(this, d) < F_SIZE/2) {
				this.setId(d.getId());
				FlxG.camera.shake(.01, .2);
				p.emitDust(x-F_SIZE/2, y-F_SIZE/2);
				PlayState.tilePlaced = true;
			}
		}
	}

}
