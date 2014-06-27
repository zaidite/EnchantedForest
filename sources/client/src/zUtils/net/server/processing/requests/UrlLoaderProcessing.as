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
		private var _currentProxy:IRequestProxy;
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

		public function start(proxy:IRequestProxy):void {
			_currentProxy = proxy;
            _currentProxy.response = null;

			var request:URLRequest = _getRequest();
			request.url = _currentProxy.url;

			if(_currentProxy.params) {
				request.data = _dataProcessing.encode(_currentProxy.params);
			}

			var loader:URLLoader = _getLoader();
			loader.addEventListener(Event.COMPLETE, _onLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoadFail);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
			loader.load(request);
		}


		public function clearData():void {
            //TODO realization
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

            //TODO add Logging

			if(_processingError != null) {
				_processingError(_currentProxy, event.toString());
			}
			_currentProxy = null;
		}
		private function _onLoadFail(event:IOErrorEvent):void {

            //TODO add Logging

            _currentProxy.requestError();
            _currentProxy.onError();

			if(_processingError != null) {
				_processingError(_currentProxy, event.toString());
			}
			_currentProxy = null;
		}
		private function _onLoadComplete(event:Event):void {

            //TODO add Logging

            _currentProxy.response = _dataProcessing.decode(event.target.data);
            _currentProxy.onComplete();

			if(_processingComplete != null) {
				_processingComplete(_currentProxy);
			}
			_currentProxy = null;

		}

	} //end class
}//end package