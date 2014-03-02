package {
	import core.GameFacade;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

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

			GameFacade.instance().startup(this);
		}



	} //end class
}//end package