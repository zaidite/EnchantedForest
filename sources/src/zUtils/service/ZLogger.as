package zUtils.service {

	import com.demonsters.debugger.MonsterDebugger;
	import com.junkbyte.console.Cc;

	import flash.display.Stage;
	import flash.geom.Rectangle;

	/**
	 * Date   :  19.02.14
	 * Time   :  00:03
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class ZLogger {

		private static var _methodsInfo:Vector.<Function> = new <Function>[];
		private static var _methodsWarning:Vector.<Function> = new <Function>[];
		private static var _methodsError:Vector.<Function> = new <Function>[];
		private static var _actions:Object = {};


		private static var _instance:ZLogger;

		private static const SEPARATOR:String = ', ';
		private static const LABEL_INFO:String = 'INFO';
		private static const LABEL_WARNING:String = 'WARNING';
		private static const LABEL_ERROR:String = 'ERROR';

		//*********************** CONSTRUCTOR ***********************
		public function ZLogger(secure:PrivateClass) {
			_actions[LABEL_INFO] = _methodsInfo;
			_actions[LABEL_WARNING] = _methodsWarning;
			_actions[LABEL_ERROR] = _methodsError;
		}

		//***********************************************************

		public function tracing():void {
			_initActions(_showInTrace);
		}


		public function console(stage:Stage, password:String, view:Rectangle = null):void {

			if(!stage) {
				trace('[ZLogger] : console() : Stage is null.');
				return;
			}

			var viewRect:Rectangle = view ? view : new Rectangle(0, 0, stage.stageWidth, stage.stageHeight / 3);

			Cc.startOnStage(stage, password);
			Cc.config.style.big();
			Cc.width = viewRect.width;
			Cc.height = viewRect.height;
			Cc.x = viewRect.x;
			Cc.y = viewRect.y;
			Cc.config.tracing = false;
			Cc.remoting = false;
			Cc.commandLine = true;
			Cc.visible = false;

			_initActions(_infoConsole);
		}

		public function monsterDebugger(stage:Stage):void {
			if(!stage) {
				trace('[ZLogger] : monsterDebugger() : Stage is null.');
				return;
			}

			MonsterDebugger.initialize(stage);
			_initActions(_infoMonsterDebugger);
		}


		private function _infoConsole(source:*, label:String, ...args):void {
			switch(label) {
				case LABEL_INFO:
					Cc.info(source, _message(args));
					break;
				case LABEL_WARNING:
					Cc.warn(source, _message(args));
					break;
				case LABEL_ERROR:
					Cc.error(source, _message(args));
					break;
			}
		}

		private function _infoMonsterDebugger(source:*, label:String, ...args):void {

			switch(label) {
				case LABEL_INFO:
					MonsterDebugger.trace(source, _message(args), null, label);
					break;
				case LABEL_WARNING:
					MonsterDebugger.trace(source, _message(args), null, label, 0xB22222);
					break;
				case LABEL_ERROR:
					MonsterDebugger.trace(source, _message(args), null, label, 0xFF0000);
					break;
			}
		}

		private function _showInTrace(source:*, label:String, ...args):void {
			switch(label) {
				case LABEL_INFO:
					trace(source, _message(args));
					break;
				case LABEL_WARNING:
					trace(label, source, _message(args));
					break;
				case LABEL_ERROR:
					trace(label, source, _message(args));
					break;
			}
		}

		private function _message(args:Array):String {
			return args ? args.join(SEPARATOR) : '';
		}

		private function _initActions(action:Function):void {
			for each (var actionSet:Vector.<Function> in _actions) {
				actionSet.push(action);
			}
		}


		public static function info(source:*, ...arg):void {
			_formMessage(source, LABEL_INFO, arg);
		}

		public static function warning(source:*, ...arg):void {
			_formMessage(source, LABEL_WARNING, arg);
		}

		public static function error(source:*, ...arg):void {
			_formMessage(source, LABEL_ERROR, arg);
		}

		public static function init():ZLogger {
			if(_instance == null) {
				ZLogger._instance = new ZLogger(new PrivateClass());
			}
			return _instance;
		}


		private static function _formMessage(source:*, label:String, arg:Array):void {

			var actions:Vector.<Function> = _actions[label];

			var action:Function;
			var len:int = actions.length;
			for(var i:int = 0; i < len; i++) {
				if(actions[i]) {
					action = actions[i];
					action(source, label, arg);
				}
			}
		}

	} //end class
}//end package

class PrivateClass {
	public function PrivateClass():void {}
}