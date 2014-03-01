package zUtils.interactive.mouseManager {
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	import zUtils.service.ZLogger;

	/**
	 * Date   :  23.02.14
	 * Time   :  22:21
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class ZMouseManager {

		private var _currentContainer:DisplayObjectContainer;
		private var _currentMouseTarget:Object;


		public function get currentContainer():DisplayObjectContainer {
			return _currentContainer;
		}

		public function get currentMouseTarget():Object {
			return _currentMouseTarget;
		}

		private static var _instance:ZMouseManager;

		//*********************** CONSTRUCTOR ***********************
		public function ZMouseManager(secure:PrivateClass) {

		}
		//***********************************************************

		public function startListen(container:DisplayObjectContainer):void {

			if(_currentContainer) {
				_currentContainer.removeEventListener(MouseEvent.MOUSE_OVER, _mOver);
				_currentContainer.removeEventListener(MouseEvent.MOUSE_OUT, _mOut);
				_currentContainer.removeEventListener(MouseEvent.MOUSE_DOWN, _mDown);
				_currentContainer.removeEventListener(MouseEvent.MOUSE_UP, _mUp);
				_currentContainer.removeEventListener(MouseEvent.MOUSE_MOVE, _mMov);
			}

			_currentContainer = container;
			_currentContainer.addEventListener(MouseEvent.MOUSE_OVER, _mOver);
		}

		public function stopListen(container:DisplayObjectContainer):void {

			if(_currentContainer) {
				_currentContainer.removeEventListener(MouseEvent.MOUSE_OVER, _mOver);
				_currentContainer.removeEventListener(MouseEvent.MOUSE_OUT, _mOut);
				_currentContainer.removeEventListener(MouseEvent.MOUSE_DOWN, _mDown);
				_currentContainer.removeEventListener(MouseEvent.MOUSE_UP, _mUp);
				_currentContainer.removeEventListener(MouseEvent.MOUSE_MOVE, _mMov);
				_currentContainer = null;
			}

			if(_currentMouseTarget) {
				_currentMouseTarget.buttonMode = false;
				_currentMouseTarget = null;
			}
		}


		private function _mOver(event:MouseEvent):void {
			if(event.target is IZMouseTarget) {
				if(!event.target.interactive)return;
				_currentMouseTarget = event.target;
				_currentMouseTarget.addEventListener(MouseEvent.MOUSE_OUT, _mOut);
				_currentMouseTarget.addEventListener(MouseEvent.MOUSE_DOWN, _mDown);
				_currentMouseTarget.addEventListener(MouseEvent.MOUSE_UP, _mUp);
				_currentMouseTarget.addEventListener(MouseEvent.MOUSE_MOVE, _mMov);
				_currentMouseTarget.buttonMode = true;
				_currentMouseTarget.mouseOver();
			}
		}

		private function _mMov(event:MouseEvent):void {
			if(!_currentMouseTarget)return;
			_currentMouseTarget.mouseMove();
			event.updateAfterEvent();
		}

		private function _mOut(event:MouseEvent):void {
			if(!_currentMouseTarget)return;
			if(event.target is IZMouseTarget) {
				_currentMouseTarget = event.target;
				_currentMouseTarget.removeEventListener(MouseEvent.MOUSE_OUT, _mOut);
				_currentMouseTarget.removeEventListener(MouseEvent.MOUSE_DOWN, _mDown);
				_currentMouseTarget.removeEventListener(MouseEvent.MOUSE_UP, _mUp);
				_currentMouseTarget.removeEventListener(MouseEvent.MOUSE_MOVE, _mMov);
				_currentMouseTarget.buttonMode = false;
				_currentMouseTarget.mouseOut();
			}
		}

		private function _mDown(event:MouseEvent):void {
			if(!_currentMouseTarget)return;
			_currentMouseTarget.mouseDown();
		}

		private function _mUp(event:MouseEvent):void {
			if(!_currentMouseTarget)return;
			_currentMouseTarget.mouseUp();
		}


		public static function manager():ZMouseManager {
			if(_instance == null) {
				ZMouseManager._instance = new ZMouseManager(new PrivateClass());
			}
			return _instance;
		}


	} //end class
}//end package

class PrivateClass {
	public function PrivateClass():void {}
}