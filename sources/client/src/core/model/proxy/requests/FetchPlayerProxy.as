package core.model.proxy.requests {
    import core.model.proxy.*;
	import core.Core;
	import constants.GameNotifications;

	import zUtils.net.server.IRequestProxy;
	import zUtils.net.server.RequestProxy;
	import zUtils.service.ZParsing;
	import zUtils.service.ZUtils;

	/**
	 * Date   :  08.03.14
	 * Time   :  17:28
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class FetchPlayerProxy extends RequestProxy implements IRequestProxy {

		/*private const PARAM_SID : String = 'sid';
		private const PARAM_PLAYER_ID : String = 'player_id';
		private const PARAM_ACTION : String = 'action';
		private const PARAM_REF_CHANNEL : String = 'ref_channel';
		private const PARAM_REF_CODE : String = 'ref_code';
*/

		public static const NAME : String = 'fetch_player';


		//*********************** CONSTRUCTOR ***********************
		public function FetchPlayerProxy(url:String) {
			super(NAME, url);
//			_initData();
		}
		//***********************************************************

		/*private function _initData():void {
			if(!_params) {
				_params = {};
				_params[PARAM_PLAYER_ID] = Core.flashVarsProxy.playerID;
				_params[PARAM_ACTION] = NAME;
				_params[PARAM_REF_CHANNEL] = {};
				_params[PARAM_SID] = Core.flashVarsProxy.sid;
				_params[PARAM_REF_CODE] = null;
			}
		}*/


		override protected function onComplete():void {
			trace('[FetchPlayerProxy] _onComplete()', ZParsing.getString(_response));
			super.onComplete();
			Core.facade.sendNotification(GameNotifications.GETTING_FETCH_PLAYER);

		}
	} //end class
}//end package