package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import zUtils.content.Content;

	import zUtils.service.ZParsing;

	/**
	 * Date   :  01.03.14
	 * Time   :  23:03
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	[SWF(pageTitle="Main", width="760", height="670", widthPercent="100", heightPercent="100", frameRate="120", backgroundColor="#209803")]
	public class Main extends Sprite {

		private var _flashVars : Object ;


		public function get flashVars():Object {
			return _flashVars;
		}

		public static const FLASH_VARS_URL:String = '../static/flashVars.json';
		public static const FLASH_VARS:String = 'flashVars';

		public function set flashVars(value:Object):void {
			_flashVars = value;
			trace('[Main] flashVars()', ZParsing.getString(_flashVars));

		}

		//*********************** CONSTRUCTOR ***********************
		public function Main() {
			if(stage && stage.stageWidth && stage.stageHeight) {
				_initData();
			} else {
				addEventListener(Event.ENTER_FRAME, _initData);
			}
		}
		//***********************************************************

		private function _initData(e:Event = null):void {
			if(!stage || !stage.stageWidth || !stage.stageHeight)return;
			removeEventListener(Event.ENTER_FRAME, _initData);

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			Content.manager().loadItem(FLASH_VARS, FLASH_VARS_URL, _flashVarsLoad, _loadError);
		}

		private function _loadError():void {
			trace('[Main] _loadError()', arguments);
		}

		private function _flashVarsLoad():void {
			_flashVars = Content.manager().getDataFromJSON(FLASH_VARS);
			trace('[Main] _flashVarsLoad()', ZParsing.getString(_flashVars));
		}



	} //end class
}//end package