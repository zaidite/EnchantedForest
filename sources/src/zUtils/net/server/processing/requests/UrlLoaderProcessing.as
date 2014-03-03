package zUtils.net.server.processing.requests {
	import flash.display.Loader;
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
		private var _dataProcessing:IDataProcessing;
		private var _processingComplete:Function;
		private var _processingError:Function;

		public static const TYPE:String = 'urlRequest';

		//*********************** CONSTRUCTOR ***********************
		public function UrlLoaderProcessing(dataProcessing:IDataProcessing, onComplete:Function, onError:Function) {
			_dataProcessing = dataProcessing;
			_method = URLRequestMethod.POST;
			_dataFormat = URLLoaderDataFormat.BINARY;
			_processingComplete = onComplete;
			_processingError = onError;
		}
		//***********************************************************

		public function start(proxy:IRequestProxy) {
			_currentRequestProxy = proxy;

			var request:URLRequest = _getRequest();
			request.url = _currentRequestProxy.url;

			if(_currentRequestProxy.params) {
				request.data = _processingParams(_currentRequestProxy.params);
			}

			var loader:URLLoader = _getLoader();
			loader.load(request);
		}


		public function clearData():void {
		}


		private function _processingParams(params:Object):Object {

			//кодирование параметров запроса
			return null
		}


		private function _getRequest():URLRequest {
			if(!_request) {
				_request = new URLRequest();
				_request.method = _method;
			}
			return _request;
		}

		private function _getLoader():URLLoader {
			if(!_loader) {
				_loader = new URLLoader();
				_loader.dataFormat = _dataFormat;
				_loader.addEventListener(Event.COMPLETE, _onLoadComplete);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoadFail);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
			}
			return _loader;
		}


		private function _onSecurityError(event:SecurityErrorEvent):void {
			if(_processingError != null) {
				_processingError(_currentRequestProxy, event.toString());
			}
		}
		private function _onLoadFail(event:IOErrorEvent):void {
			if(_processingError != null) {
				_processingError(_currentRequestProxy, event.toString());
			}

		}
		private function _onLoadComplete(event:Event):void {

			//декодирование данных ответа

			if(_processingComplete != null) {
				_processingComplete(_currentRequestProxy);
			}

		}

	} //end class
}//end package