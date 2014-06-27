package core.model.proxy {
    import constants.GameNotifications;
    import core.model.valueObjects.FlashVarsVO;

    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;

    import zUtils.service.ZObjects;

    /**
	 * Date   :  02.03.14
	 * Time   :  13:05
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility : принимает, валидирует и хранит флешварсы
	 */
	public class FlashVarsProxy extends Proxy implements IProxy {

        private function get _valueObject():FlashVarsVO {return data as FlashVarsVO;}

		public function get dataFormat():String { return _valueObject.flashVars[FlashVarsVO.DATA_FORMAT];}
		public function get loginServerUrl():String { return _valueObject.flashVars[FlashVarsVO.LOGIN_SERVER_URL];}
		public function get timeServerURL():String { return _valueObject.flashVars[FlashVarsVO.TIME_SERVER_URL];}
		public function get gameServerURL():String { return _valueObject.flashVars[FlashVarsVO.GAME_SERVER_URL];}
		public function get playerID():String {return _valueObject.flashVars[FlashVarsVO.PLAYER_ID];}
		public function get sid():String {return _valueObject.flashVars[FlashVarsVO.SID];}

		public static const NAME:String = 'FlashVarsProxy';

		//*********************** CONSTRUCTOR ***********************
		public function FlashVarsProxy() {
			super(NAME, new FlashVarsVO());
		}
		//***********************************************************

		public function validateFlashVars(flashVars:Object):void {

            var parametersMissing:Boolean;

            if(!flashVars || ZObjects.isEmpty(flashVars)) {
                parametersMissing = true;
            }

            if(parametersMissing) {
                sendNotification(GameNotifications.NEED_STANDALONE_DATA);
            }
            else{
                _valueObject.flashVars = flashVars;
                sendNotification(GameNotifications.GETTING_FLASH_VARS, _valueObject.flashVars);
            }
		}


	} //end class
}//end package