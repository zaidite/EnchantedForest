package zUtils.net.server.processing.requests {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	import zUtils.net.server.IRequestProxy;
	import zUtils.net.server.processing.data.IDataProcessing;

	/**
	 * Date   :  02.03.14
	 * Time   :  19:40
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class UrlLoaderProcessing implements IRequestProcessing {

		private var _request:URLRequest;
		private var _method:String;
		private var _loader:URLLoader;
		private var _currentRequestProxy:IRequestProxy;
		private var _dataFormat:String;
		private var _dataProcessing : IDataProcessing ;

		private function get request():URLRequest {
			if(!_request) {
				_request = new URLRequest();
				_request.method = _method;
			}
			return _request;
		}

		private function get loader():URLLoader {
			if(!_loader) {
				_loader = new URLLoader();
				_loader.dataFormat = _dataFormat;
				_loader.addEventListener(Event.COMPLETE, _onLoadComplete);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoadFail);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
			}
			return _loader;
		}

		public static const TYPE : String = 'urlRequest';

		//*********************** CONSTRUCTOR ***********************
		public function UrlLoaderProcessing(dataProcessing:IDataProcessing) {
			_dataProcessing = dataProcessing;
			_method = URLRequestMethod.POST;
			_dataFormat = URLLoaderDataFormat.BINARY;
		}
		//***********************************************************

		public function start(proxy:IRequestProxy) {
			_currentRequestProxy = proxy;

			var request:URLRequest = request;
			request.url = _currentRequestProxy.url;

			if(_currentRequestProxy.params) {
				request.data = _processingParams(_currentRequestProxy.params);
			}

			loader.load(request);
		}


		public function clearData():void {
		}


		private function _processingParams(params:Object):Object {

			return null
		}


		private function _onSecurityError(event:SecurityErrorEvent):void {

		}
		private function _onLoadFail(event:IOErrorEvent):void {

		}
		private function _onLoadComplete(event:Event):void {

		}

	} //end class
}//end package