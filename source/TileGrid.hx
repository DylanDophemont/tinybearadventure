package;

import haxe.Log;

import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;

class TileGrid extends FlxTypedGroup<LevelTile> {

	private var _startTile: LevelTile;

	private var _boundry: FlxRect;

	public function new(?offsetX = 0, ?offsetY = 0) {
		super();

		_addTiles(offsetX, offsetY);

		_boundry = new FlxRect(offsetX+LevelTile.F_SIZE/2, offsetY+LevelTile.F_SIZE/2, Main.GRID_SIZE*LevelTile.F_SIZE-LevelTile.F_SIZE/2, Main.GRID_SIZE*LevelTile.F_SIZE-LevelTile.F_SIZE/2);
	}

	public function getBoundry():FlxRect {
		return _boundry;
	}

	private function _addTiles(ox, oy):Void {
		for (i in 0...Main.GRID_SIZE) {
			for (j in 0...Main.GRID_SIZE) {

				var t = new LevelTile(j*LevelTile.F_SIZE+ox, i*LevelTile.F_SIZE+oy, FlxRandom.intRanged(2, 3));
				if (i == Std.int(Main.GRID_SIZE/2) && j == Std.int(Main.GRID_SIZE/2)) {
					_startTile = t;
					_startTile.setId(1);
					_startTile.setBear(true);
				}
				this.add(t);
			}
		}
	}

	public function getStartTile():LevelTile {
		return _startTile;
	}

}
