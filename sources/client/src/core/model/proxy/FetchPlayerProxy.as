package core.model.proxy {
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

		private const PARAM_SID : String = 'sid';
		private const PARAM_PLAYER_ID : String = 'player_id';
		private const PARAM_ACTION : String = 'action';
		private const PARAM_REF_CHANNEL : String = 'ref_channel';
		private const PARAM_REF_CODE : String = 'ref_code';


		public static const NAME : String = 'fetch_player';


		//*********************** CONSTRUCTOR ***********************
		public function FetchPlayerProxy(url:String, params:Object=null, onComplete:Function=null, onError:Function=null) {
			super(url, params, onComplete, onError);
			_name = NAME;
			_initData();
		}
		//***********************************************************

//{"player_id":"a95920e99e3779b","action":"fetch_player","ref_channel":{},"sid":"a2f3b4483f64304e03","ref_code":null}
		private function _initData():void {
			if(!_params) {
				_params = {};
				_params[PARAM_PLAYER_ID] = Core.flashVarsProxy.playerID;
				_params[PARAM_ACTION] = NAME;
				_params[PARAM_REF_CHANNEL] = {};
				_params[PARAM_SID] = Core.flashVarsProxy.sid;
				_params[PARAM_REF_CODE] = null;
			}
		}


		override protected function _onComplete():void {
			super._onComplete();
			Core.facade.sendNotification(GameNotifications.GETTING_FETCH_PLAYER);

			trace('[FetchPlayerProxy] _onComplete()', ZParsing.getString(_response));
		}
	} //end class
}//end package