package {
	import flash.display.Sprite;
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
	public class Main extends Sprite {


		//*********************** CONSTRUCTOR ***********************
		public function Main() {
			super();
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
		}


	} //end class
}//end package