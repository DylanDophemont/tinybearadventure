package;

import haxe.Log;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxRandom;
import flixel.effects.particles.FlxEmitter;
import flixel.system.FlxSound;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _bg: FlxSprite;
	private var _tileDrag: TileDrag;
	private var _tileGrid: TileGrid;
	private var _hotbar: Hotbar;
	private var _bear: Bear;

	private var _lives: Lives;
	private var _coinsText: GameText;


	private var _fight: FightAction;
	private var _eat: EatAction;

	private var _impactSound: FlxSound;
	private var _coinsSound: FlxSound;

	private var _dustParticles: FlxEmitter;

	public static var tilePlaced:Bool = false;

	public static var actionHandled:Bool = true;

	private var _gameOverText: GameText;

	private var _moves: Int = 0;
	private var _coins: Int = 0;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

//		this.bgColor = 0xffcfb89c;
		this.bgColor = 0xff11080c;

		FlxG.mouse.load(AssetPaths.cursor__png, 6, Std.int(-4*FlxG.camera.zoom), Std.int(-4*FlxG.camera.zoom));

		_bg = new FlxSprite(Main.gameWidth/2-96/2, Main.gameHeight/2-96/2-3).loadGraphic(AssetPaths.background__png, false);
		this.add(_bg);

		_tileGrid = new TileGrid(LevelTile.F_SIZE, Std.int(Main.gameHeight-LevelTile.F_SIZE*Main.GRID_SIZE*1.5));
		this.add(_tileGrid);

		_hotbar = new Hotbar(Std.int(Main.gameWidth/2-Button.F_SIZE*Main.NUM_BUTTONS/2-Button.F_SIZE), Main.gameHeight - Button.F_SIZE*1.5);
		this.add(_hotbar);

		_coinsText = new GameText(LevelTile.F_SIZE/3, LevelTile.F_SIZE/2, "C:0", Button.F_SIZE*Main.NUM_BUTTONS-LevelTile.F_SIZE);
		this.add(_coinsText);

		_lives = new Lives(Main.gameWidth, LevelTile.F_SIZE/3);
		this.add(_lives);

		_tileDrag = new TileDrag();
		this.add(_tileDrag);

		_bear = new Bear(_tileGrid.getStartTile());
		this.add(_bear);

		_dustParticles = new FlxEmitter();
		_dustParticles.gravity = 10;
		_dustParticles.makeParticles(AssetPaths.dust__png, 15, 0, 16, true);
		_dustParticles.setSize(LevelTile.F_SIZE, LevelTile.F_SIZE);
		_dustParticles.setRotation(0, 0);
		_dustParticles.setXSpeed(-3, 3);
		_dustParticles.setYSpeed(-15, 3);
		FlxG.state.add(_dustParticles);

		_fight = new FightAction();
		this.add(_fight);

		_eat = new EatAction();
		this.add(_eat);


		_gameOverText = new GameText(LevelTile.F_SIZE, Main.gameHeight/2-LevelTile.F_SIZE*2, "");
		this.add(_gameOverText);

		_impactSound = FlxG.sound.load(AssetPaths.impact__wav);
		_coinsSound = FlxG.sound.load(AssetPaths.coins__wav);
	}

	public function emitDust(x, y):Void {
		_dustParticles.setPosition(x, y);
		_dustParticles.start(true, 1.5);
	}

	public function getBear():Bear {
		return _bear;
	}

	public function getEat():EatAction {
		return _eat;
	}

	public function getFight():FightAction {
		return _fight;
	}

	public function getLives():Lives {
		return _lives;
	}

	public function getTileGrid():TileGrid {
		return _tileGrid;
	}

	public function getTileDrag():TileDrag {
		return _tileDrag;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		_bear = FlxDestroyUtil.destroy(_bear);
		_hotbar = FlxDestroyUtil.destroy(_hotbar);
		_tileGrid = FlxDestroyUtil.destroy(_tileGrid);
		_tileDrag = FlxDestroyUtil.destroy(_tileDrag);
		_coinsText = FlxDestroyUtil.destroy(_coinsText);
		_lives = FlxDestroyUtil.destroy(_lives);
		_fight = FlxDestroyUtil.destroy(_fight);
		_eat = FlxDestroyUtil.destroy(_eat);
		_impactSound = FlxDestroyUtil.destroy(_impactSound);
		_coinsSound = FlxDestroyUtil.destroy(_coinsSound);
		_dustParticles = FlxDestroyUtil.destroy(_dustParticles);
		_gameOverText = FlxDestroyUtil.destroy(_gameOverText);
	}

	private function _dragTouchTile(d:TileDrag, t:LevelTile):Void {
		if (FlxG.mouse.justReleased) {
			t.setId(d.getId());
		}
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		if (_lives.getNumLives() != 0) {
			FlxG.overlap(_tileDrag, _tileGrid, _dragTouchTile);

			_hotbar.forEach(function(b:Button):Void {
				if (b.isEnabled() && FlxMath.distanceToMouse(b) < Button.F_SIZE/2 && FlxG.mouse.justPressed) {
					_tileDrag.setButton(b);
					if (!_tileDrag.alive) {
						_tileDrag.reset(FlxG.mouse.screenX, FlxG.mouse.screenY);
					}
				}
			});

			if (tilePlaced && _bear.isDone) {
				tilePlaced = false;
				_moves++;
				_impactSound.play(true);
				_bear.move();
				_tileDrag.getButton().setId(0);
				actionHandled = false;
				_tileDrag.setButton(null);
			}

			if (_bear.isDone && !actionHandled) {
				actionHandled = true;

				var a = _bear.getAction();
				if (a != null && a.type == Action.TYPE_EAT) {
					_lives.gainLife();
				}
				if (a != null && a.type == Action.TYPE_FIGHT) {
					_findNewTiles();
					if (FlxRandom.chanceRoll(75)) {
						_coins += FlxRandom.intRanged(1, 5);
						_coinsText.text = "C:"+_coins;
						_coinsSound.play(true);
					}
				}

				if (_numberButtonsWithId(2) > 1 && _numberTilesWithId(2) == Main.GRID_SIZE*Main.GRID_SIZE) {
					_hotbar.members[0].setId(3);
				}

// TODO: Stuck at
// -------------------------------------------------
// If all tiles are for example mountains
// and 1 button is mountain or all buttons mountain

				if (_numberButtonsWithId(0) == Main.NUM_BUTTONS) {
					if (_numberTilesWithId(2) == Main.GRID_SIZE*Main.GRID_SIZE) {
						_hotbar.members[0].setId(3);
					} else if (_numberTilesWithId(3) == Main.GRID_SIZE*Main.GRID_SIZE) {
						_hotbar.members[0].setId(2);
					} else if (_numberTilesWithId(4) == Main.GRID_SIZE*Main.GRID_SIZE-1) {
						_hotbar.members[0].setId(FlxRandom.intRanged(2, 3));
					} else {
						_hotbar.members[0].setId(FlxRandom.intRanged(2, 4));
					}
				}

				_bear.resetAction();
			}
		} else {
			_gameOverText.text = "Game\nOver";
			FlxG.camera.fade(0xffdf6a4e, 5, true, _resetState);
		}

	}

	private function _resetState():Void {
		FlxG.resetState();
	}

	private function _numberTilesWithId(id:Int):Int {
		var n = 0;
		_tileGrid.forEach(function(t:LevelTile) {
			if (t.getId() == id) n++;
		});

		return n;
	}

	private function _numberButtonsWithId(id:Int):Int {
		var n = 0;
		_hotbar.forEach(function(b:Button) {
			if (b.getId() == id) n++;
		});

		return n;
	}

	private function _findNewTiles():Void {
		_hotbar.forEach(function(b:Button) {
			if (!b.isEnabled()) b.setId(FlxRandom.intRanged(2, 4));
		});
	}
}
