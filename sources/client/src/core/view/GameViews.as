package core.view {
	import flash.display.Sprite;

	/**
	 * Date   :  02.03.14
	 * Time   :  12:32
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class GameViews extends Sprite {

		private var _level : Sprite ;
		private var _hud : Sprite ;
		private var _windows : Sprite ;


		//*********************** CONSTRUCTOR ***********************
		public function GameViews() {
			_initData();
		}
		//***********************************************************

		private function _initData():void {

			_level = new Sprite();
			addChild(_level);

			_hud = new Sprite();
			addChild(_hud);

			_windows = new Sprite();
			addChild(_windows);
		}

	} //end class
}//end package