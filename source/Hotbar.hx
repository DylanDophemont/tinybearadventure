package;

import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;

class Hotbar extends FlxTypedGroup<Button> {
	
	public function new(x, y) {
		super();

		for (i in 1...Main.NUM_BUTTONS+1) {
			var b = new Button(x + i*Button.F_SIZE, y, FlxRandom.intRanged(2, 3));
			this.add(b);
		}
	}

}
