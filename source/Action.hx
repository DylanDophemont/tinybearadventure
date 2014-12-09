package;

import haxe.Log;

import flixel.FlxSprite;

class Action extends FlxSprite {

	public static var TYPE_EAT: Int = 0;
	public static var TYPE_FIGHT: Int = 1;

	private var _isOver: Bool = false;

	public var type: Int;

	public function new(x, y, t) {
		super(x, y);

		type = t;
	}

	public function start(x, y):Void {
		this.x = x;
		this.y = y;
		setIsOver(false);
		this.visible = true;
	}

	public function setIsOver(o:Bool):Void {
		_isOver = o;
	}

	public function isOver():Bool {
		return _isOver;
	}

}
