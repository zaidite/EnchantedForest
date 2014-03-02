package core.proxy {
	import core.GameNotifications;

	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	import zUtils.content.Content;
	import zUtils.service.ZParsing;

	/**
	 * Date   :  02.03.14
	 * Time   :  13:05
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class FlashVarsProxy extends Proxy implements IProxy {


		private var _flashVars:Object;

		public function get flashVars():Object {
			return _flashVars;
		}

		public static const FLASH_VARS_URL:String = '../static/flashVars.json';
		public static const FLASH_VARS:String = 'flashVars';

		public static const NAME : String = 'FlashVarsProxy';


		//*********************** CONSTRUCTOR ***********************
		public function FlashVarsProxy() {
			super(NAME);
		}
		//***********************************************************

		public function getFlashVars():void {

			Content.manager().loadItem(FLASH_VARS, FLASH_VARS_URL, _flashVarsLoad, _loadError);
		}

		private function _loadError():void {
			trace('[Main] _loadError()', arguments);
		}

		private function _flashVarsLoad():void {
			_flashVars = Content.manager().getDataFromJSON(FLASH_VARS);
			sendNotification(GameNotifications.GETTING_FLASH_VARS, _flashVars);
		}

	} //end class
}//end package