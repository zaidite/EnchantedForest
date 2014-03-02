package core {
	import core.controllers.GetStartData;
	import core.proxy.FlashVarsProxy;
	import core.view.GameViews;

	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;

	/**
	 * Date   :  02.03.14
	 * Time   :  12:33
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class GameFacade extends Facade implements IFacade {

		private var _main:Main;
		private var _gameViews : GameViews ;

		private static var _instance:GameFacade;


		//*********************** CONSTRUCTOR ***********************
		public function GameFacade(secure:PrivateClass) {

		}
		//***********************************************************


		public function startup(app:Main):void {
			_main = app;

			_gameViews = new GameViews();
			_main.addChild(_gameViews);

			sendNotification(GameNotifications.STARTUP, app);
		}

		override protected function initializeView():void {
			super.initializeView();
		}

		override protected function initializeModel():void {
			super.initializeModel();

			registerProxy(new FlashVarsProxy());
		}

		override protected function initializeController():void {
			super.initializeController();
			registerCommand(GameNotifications.STARTUP, GetStartData);
			registerCommand(GameNotifications.GETTING_FLASH_VARS, GetStartData);
		}


		public static function instance():GameFacade {
			if(_instance == null) {
				GameFacade._instance = new GameFacade(new PrivateClass());
			}
			return _instance;
		}


	} //end class
}//end package

class PrivateClass {
	public function PrivateClass():void {}
}