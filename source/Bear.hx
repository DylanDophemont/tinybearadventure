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
			var dir = -1;

			while (!rightDir) {
				dir = _getNewDirection();
				rightDir = _checkMove(dir);
			}

			switch (dir) {
				case 0: moveUp();
				case 1: moveDown();
				case 2: moveLeft();
				case 3: moveRight();
			}
		}
	}

	private function _getNewDirection():Int {
		return FlxRandom.intRanged(0, 3);
	}

	private function _checkMove(i:Int):Bool {
		var r = cast(FlxG.state, PlayState).getTileGrid().getBoundry();

		var mx:Float = 0;
		var my:Float = 0;

		switch (i) {
			case 0:
				mx = x;
				my = y - LevelTile.F_SIZE;
			case 1:
				mx = x;
				my = y + LevelTile.F_SIZE;
			case 2:
				mx = x - LevelTile.F_SIZE;
				my = y;
			case 3:
				mx = x + LevelTile.F_SIZE;
				my = y;

		}

		return r.containsFlxPoint(new FlxPoint(mx+F_SIZE, my+F_SIZE));
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
