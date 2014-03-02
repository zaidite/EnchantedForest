package zUtils.net.server {
	import flash.errors.IllegalOperationError;

	import zUtils.net.server.processing.data.AMF3Processing;
	import zUtils.net.server.processing.data.IDataProcessing;
	import zUtils.net.server.processing.data.JSONProcessing;
	import zUtils.net.server.processing.data.XJSONProcessing;
	import zUtils.net.server.processing.data.YAMLProcessing;
	import zUtils.net.server.processing.requests.IRequestProcessing;
	import zUtils.net.server.processing.requests.NetConnectionProcessing;
	import zUtils.net.server.processing.requests.UrlLoaderProcessing;

	/**
	 * Date   :  02.03.14
	 * Time   :  17:49
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class ZRequests {

		private var _defaultDataFormat:String;
		private var _defaultRequestType:String;
		private var _requestProcessing:IRequestProcessing;
		private var _dataProcessing:IDataProcessing;


		public function get defaultDataFormat():String {return _defaultDataFormat;}
		public function get defaultRequestType():String {return _defaultRequestType;}

		private static var _instance:ZRequests;

		//*********************** CONSTRUCTOR ***********************
		public function ZRequests(secure:PrivateClass) {

		}
		//***********************************************************

		public function init(requestType:String, dataFormat:String):void {
			if(!requestType) {
				throw IllegalOperationError('[ZRequests] init() : requestType is null. ');
			}

			if(!dataFormat) {
				throw IllegalOperationError('[ZRequests] init() : dataFormat is null. ');

			}
			_defaultRequestType = requestType;
			_defaultDataFormat = dataFormat;

			_dataProcessing = _getDataProcessing(_defaultDataFormat);
			_requestProcessing = _getRequestProcessing(_defaultRequestType, _dataProcessing);
		}


		public function registerProxy(proxy:IRequestProxy):void {

		}

		public function getProxy(name:String):IRequestProxy {
			return null;
		}

		public function requestStart(request:IRequestProxy):void {

		}


		private function _getRequestProcessing(requestType:String,
											   dataProcessing:IDataProcessing):IRequestProcessing {

			var processing:IRequestProcessing;

			switch(requestType) {
				case UrlLoaderProcessing.TYPE:
					processing = new UrlLoaderProcessing(dataProcessing);
					break;
				case NetConnectionProcessing.TYPE:
					processing = new NetConnectionProcessing(dataProcessing);
					break;
			}
			return processing;
		}

		private function _getDataProcessing(dataType:String):IDataProcessing {

			var processing:IDataProcessing;

			switch(dataType) {
				case AMF3Processing.TYPE:
					processing = new AMF3Processing();
					break;
				case JSONProcessing.TYPE:
					processing = new JSONProcessing();
					break;
				case XJSONProcessing.TYPE:
					processing = new XJSONProcessing();
					break;
				case YAMLProcessing.TYPE:
					processing = new YAMLProcessing();
					break;
			}

			return processing;
		}

		public static function manager():ZRequests {
			if(_instance == null) {
				ZRequests._instance = new ZRequests(new PrivateClass());
			}
			return _instance;
		}


	} //end class
}//end package

class PrivateClass {
	public function PrivateClass():void {}
}