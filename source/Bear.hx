package;

import haxe.Log;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;
import flixel.util.FlxDestroyUtil;

class Bear extends FlxSprite {
	
	public static var F_SIZE: Int = 16;
	public static var ANIM_SPEED: Float = .6;

	public var isMoving: Bool = false;
	public var isWorking: Bool = false;
	public var isDone: Bool = true;

	private var _action: Action = null;

	public function new(startTile:LevelTile) {
		super();

		this.x = startTile.x-F_SIZE/2;
		this.y = startTile.y-F_SIZE/2;

		this.loadGraphic(AssetPaths.bear__png, true, F_SIZE, F_SIZE);

		this.animation.add("idle", [0, 1], 1, true);

		this.setFacingFlip(FlxObject.LEFT, false, false);
		this.setFacingFlip(FlxObject.RIGHT, true, false);
	}

	public function moveUp():Void {
		FlxTween.tween(this, { y:y - LevelTile.F_SIZE }, ANIM_SPEED, { type:FlxTween.ONESHOT, ease:FlxEase.quadIn, complete:_finishTween } );
	}

	public function moveDown():Void {
		FlxTween.tween(this, { y:y + LevelTile.F_SIZE }, ANIM_SPEED, { type:FlxTween.ONESHOT, ease:FlxEase.quadIn, complete:_finishTween } );
	}   

	public function moveLeft():Void {
		FlxTween.tween(this, { x:x - LevelTile.F_SIZE }, ANIM_SPEED, { type:FlxTween.ONESHOT, ease:FlxEase.quadIn, complete:_finishTween } );
		this.facing = FlxObject.LEFT;
	}   

	public function moveRight():Void {
		FlxTween.tween(this, { x:x + LevelTile.F_SIZE }, ANIM_SPEED, { type:FlxTween.ONESHOT, ease:FlxEase.quadIn, complete:_finishTween } );
		this.facing = FlxObject.RIGHT;
	}

	private function dontMove():Void {
		isMoving = false;
		checkTile();
	}

	private function _finishTween(T:FlxTween):Void {
		isMoving = false;
		checkTile();
	}

	public function checkTile():Void {
		FlxG.overlap(this, cast(FlxG.state, PlayState).getTileGrid(), _workTile);
	}

	private function _workTile(b:Bear, t:LevelTile):Void {
		if ( !isWorking && FlxG.pixelPerfectOverlap(b, t) ) {
			isWorking = true;

			var p = cast(FlxG.state, PlayState);
			p.getTileGrid().forEach(function(t:LevelTile) {
				t.setBear(false);
			});
			t.setBear(true);

			if (t.getId() == 2) {
				_action = p.getFight();
				_action.start(t.x-LevelTile.F_SIZE, t.y-LevelTile.F_SIZE);
				t.setId(1);
			} else if (t.getId() == 3) {
				_action = p.getEat();
				_action.start(t.x-LevelTile.F_SIZE, t.y-LevelTile.F_SIZE);
				t.setId(1);
			} else {
				isDone = true;
				isWorking = false;
			}
		}
	}

	public function move():Void {
		if (!isMoving) {
			isMoving = true;
			isWorking = false;
			isDone = false;

			var rightDir = false;
			var dir = 0;

			var numWrongDir = 0;

			while (!rightDir) {
				rightDir = _checkMove(dir);
				if (!rightDir) {
					dir++;
					if (!rightDir) numWrongDir++;
				}
					if (numWrongDir > 3) break;

			}

			switch (dir) {
				case 0: moveUp();
				case 1: moveDown();
				case 2: moveLeft();
				case 3: moveRight();
				default: dontMove();
			}
		}
	}

	private function _checkMove(i:Int):Bool {
		var g = cast(FlxG.state, PlayState).getTileGrid();
		var r = g.getBoundry();

		var mx:Float = 0;
		var my:Float = 0;

		var m = true;

		switch (i) {
			case 0: // Up
				mx = x;
				my = y - LevelTile.F_SIZE;
			case 1: // Down
				mx = x;
				my = y + LevelTile.F_SIZE;
			case 2: // Left
				mx = x - LevelTile.F_SIZE;
				my = y;
			case 3: // Right
				mx = x + LevelTile.F_SIZE;
				my = y;

		}
		
		m = r.containsFlxPoint(new FlxPoint(mx+F_SIZE, my+F_SIZE));

		g.forEach(function(t:LevelTile) {
			if (t.getId() == 4 && FlxMath.distanceToPoint(t, new FlxPoint(mx+F_SIZE, my+F_SIZE)) < LevelTile.F_SIZE) m = false;
		});

		return m;
	}

	override public function update():Void {
		this.animation.play("idle");

		if (_action != null && _action.isOver()) {
			isDone = true;
			isWorking = false;
		}

		super.update();
	}

	override public function destroy():Void {
		_action = FlxDestroyUtil.destroy(_action);
		super.destroy();
	}

	public function resetAction():Void {
		_action = null;
	}

	public function getAction():Action {
		return _action;
	}
}
