package;

import flixel.text.FlxText;

class GameText extends FlxText {
	
	public function new(x, y, t:String, ?width = 0, ?s = 8) {
		super(x, y, width, t);
		this.setFormat(null, s, 0xfff3e4a1, null, 2, 0xff351722);
	}

}
