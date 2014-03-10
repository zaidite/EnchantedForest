package zUtils.net.server {

	/**
	 * Date   :  02.03.14
	 * Time   :  17:54
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class RequestProxy implements IRequestProxy{


		protected var _url:String;
		protected var _params:Object;
		protected var _dataFormat:String;
		protected var _requestType:String;
		protected var _requestComplete:Function;
		protected var _requestError:Function;
		protected var _name:String;

		protected var _response:Object;


		public function get url():String {return _url;}
		public function get params():Object {return _params;}
		public function get dataFormat():String {return _dataFormat;}
		public function get requestType():String {return _requestType;}
		public function get requestComplete():Function {return _requestComplete;}
		public function get requestError():Function {return _requestError;}
		public function get response():Object {return _response;}
		public function get name():String {return _name;}

		public function set dataFormat(value:String):void {_dataFormat = value;}
		public function set requestType(value:String):void {_requestType = value;}
		public function set response(value:Object):void {_response = value;}

		public static const NAME : String = 'RequestProxy';


		//*********************** CONSTRUCTOR ***********************
		public function RequestProxy(url:String, params:Object = null, onComplete:Function = null,
									 onError:Function = null) {
			_name = NAME;
			_url = url;
			_params = params;
			_requestComplete = onComplete != null ? onComplete : _onComplete;
			_requestError = onError != null ? onError : _onError;
		}
		//***********************************************************

		protected function _onComplete():void {

		}

		protected function _onError():void {

		}

	} //end class
}//end package