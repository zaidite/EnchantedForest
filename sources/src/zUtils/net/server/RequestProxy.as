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
	public class RequestProxy {


		private var _url : String ;
		private var _params : Object ;
		private var _dataFormat : String ;
		private var _requestType : String ;
		private var _requestComplete : Function ;
		private var _requestError : Function ;

		private var _response : Object ;


		public function get url():String {return _url;}
		public function get params():Object {return _params;}
		public function get dataFormat():String {return _dataFormat;}
		public function get requestType():String {return _requestType;}
		public function get requestComplete():Function {return _requestComplete;}
		public function get requestError():Function {return _requestError;}
		public function get response():Object {return _response;}

		public function set dataFormat(value:String):void {_dataFormat = value;}
		public function set requestType(value:String):void {_requestType = value;}
		public function set response(value:Object):void {_response = value;}

		//*********************** CONSTRUCTOR ***********************
		public function RequestProxy(url:String, params:Object=null, onComplete:Function=null, onError:Function=null) {
			_url = url;
			_params = params;
			_requestComplete = onComplete;
			_requestError = onError;
		}
		//***********************************************************


	} //end class
}//end package