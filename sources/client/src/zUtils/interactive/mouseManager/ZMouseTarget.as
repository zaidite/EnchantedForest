package zUtils.interactive.mouseManager {
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * Date   :  23.02.14
	 * Time   :  22:23
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class ZMouseTarget extends Sprite implements IZMouseTarget {

		private var _target:DisplayObject;
		private var _action:Function;
		private var _actionParams:Array;
		private var _interactive:Boolean = true;

		public function get target():DisplayObject {return _target;}

		public function get action():Function {return _action;}

		public function get actionParams():Array {return _actionParams;}

		public function get interactive():Boolean {return _interactive;}

		public function set action(value:Function):void {_action = value;}

		public function set actionParams(value:Array):void {_actionParams = value}

		public function set interactive(value:Boolean):void {_setInteractive(value);}


		//*********************** CONSTRUCTOR ***********************
		public function ZMouseTarget(target:DisplayObject, action:Function, actionParams:Array) {
			_target = target;
			_action = action;
			_actionParams = actionParams;

			mouseChildren = false;
			cacheAsBitmap = true;
			addChild(_target);
		}

		//***********************************************************

		private function _setInteractive(value:Boolean):void {
			_interactive = value;
			if(_interactive) {
				_target.alpha = 1;
				_target['buttonMode'] = true;
			}
			else{
				_target.alpha = .5;
				_target['buttonMode'] = false;
			}
		}

		public function mouseOver():void {
			if(!_interactive)return;
			trace(this, 'mouseOver()', _target.name);
		}

		public function mouseOut():void {
			if(!_interactive)return;
			trace(this, 'mouseOut()', _target.name);
		}

		public function mouseMove():void {
			if(!_interactive)return;
			trace(this, 'mouseMove()', _target.name);
		}

		public function mouseDown():void {
			if(!_interactive)return;
			trace(this, 'mouseDown()', _target.name);
		}

		public function mouseUp():void {
			if(!_interactive)return;
			trace(this, 'mouseUp()', _target.name);
			actionStart();
		}

		public function actionStart():void {
			if (_action != null)_action.apply(null, _actionParams);
		}

		public function clearData():void {
			removeChild(_target);
			_target = null;
			_action = null;
			_actionParams = null;
			_interactive = false;
		}
	} //end class
}//end package