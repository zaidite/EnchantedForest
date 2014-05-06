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
	 * class responsibility :
	 */
	public class FlashVarsProxy extends Proxy implements IProxy {

        public function get valueObject():FlashVarsVO {return data as FlashVarsVO;}

		public function get dataFormat():String { return valueObject[FlashVarsVO.DATA_FORMAT];}
		public function get serverUrl():String { return valueObject[FlashVarsVO.LOGIN_SERVER_URL];}
		public function get playerID():String {return valueObject[FlashVarsVO.PLAYER_ID];}
		public function get sid():String {return valueObject[FlashVarsVO.SID];}

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
                valueObject.flashVars = flashVars;
                sendNotification(GameNotifications.GETTING_FLASH_VARS, valueObject.flashVars);
            }
		}


	} //end class
}//end package