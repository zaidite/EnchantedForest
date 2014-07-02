package zUtils.net.server.processing.requests {
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.system.ApplicationDomain;
    import flash.system.Capabilities;
    import flash.system.LoaderContext;
    import flash.system.Security;
    import flash.system.SecurityDomain;
    import flash.utils.Dictionary;

    import zUtils.net.server.IRequestProxy;
    import zUtils.net.server.processing.data.IDataProcessing;
    import zUtils.service.ZLogger;

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

        private var _method:String;
        private var _dataFormat:String;
        private var _dataProcessing:IDataProcessing;
        private var _processingComplete:Function;
        private var _processingError:Function;
        private var _activeRequests:Dictionary = new Dictionary();

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

            var request:URLRequest = new URLRequest();
            request.method = _method;
            request.data = proxy.params ? _dataProcessing.encode(proxy.params) : null;
            request.url = proxy.url;

            var loader:URLLoader = new URLLoader();
            loader.dataFormat = _dataFormat;
            loader.addEventListener(Event.COMPLETE, _onLoadComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoadFail);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);

            _activeRequests[loader] = proxy;
            loader.load(request);
        }

        private function _onSecurityError(event:SecurityErrorEvent):void {

            ZLogger.error('[UrlLoaderProcessing] :', '_onSecurityError();  ', arguments);

            var requestProxy:IRequestProxy = _activeRequests[event.target];
            if (_processingError != null) {
                _processingError(requestProxy, event.toString());
            }

            _clearLoader(event.target as URLLoader);
        }

        private function _onLoadFail(event:IOErrorEvent):void {

            ZLogger.error('[UrlLoaderProcessing] :', '_onLoadFail();', arguments);

            var requestProxy:IRequestProxy = _activeRequests[event.target];

            if (requestProxy.requestError != null) {
                requestProxy.requestError();
            }

            if (requestProxy.onError != null) {
                requestProxy.onError();
            }

            if (_processingError != null) {
                _processingError(requestProxy, event.toString());
            }

            _clearLoader(event.target as URLLoader);
        }

        private function _onLoadComplete(event:Event):void {
            var requestProxy:IRequestProxy = _activeRequests[event.target];
//            ZLogger.info('[UrlLoaderProcessing] :', '_onLoadComplete();', requestProxy.name);

            requestProxy.response = _dataProcessing.decode(event.target.data);
            requestProxy.onComplete();

            if (_processingComplete != null) {
                _processingComplete(requestProxy);
            }

            _clearLoader(event.target as URLLoader);
        }

        private function _clearLoader(loader:URLLoader):void {
            loader.removeEventListener(Event.COMPLETE, _onLoadComplete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, _onLoadFail);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
            loader = null;

            delete _activeRequests[loader];
        }

        public function clearData():void {
        }
    } //end class
}//end package