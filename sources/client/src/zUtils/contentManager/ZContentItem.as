package zUtils.contentManager {
    import br.com.stimuli.loading.BulkLoader;

    import flash.display.LoaderInfo;
    import flash.events.ErrorEvent;
    import flash.events.ProgressEvent;

    /**
     * Date   : 30.04.2014
     * Time   : 10:43
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    : Item of one content loader with BulkLoader.
     * responsibility : Make and prepares content item. Load content.
     */
    public class ZContentItem {

        private var _url:String;
        private var _callbackComplete:Function;
        private var _callbackError:Function;
        private var _loader:BulkLoader;
        private var _state:String;

		/**
		 * Return object of LoaderInfo.
		 */
		public function get loaderInfo():LoaderInfo {
			if(!_loader) {
				return null;
			}
			if(_loader.items && loader.items.length){
				return _loader.items[0]['loader'].contentLoaderInfo;
			}

			return null;
		}
		/**
         * url - url for load. This url need to use for get downloaded content.
         */
        public function get url():String {return _url;}

        /**
         * Callback will activate when load is end. In callback will transferred current ZContentItem.
         */
        public function get callbackComplete():Function {return _callbackComplete;}

        /**
         * Callback will activate when loading error. In callback will transferred object ErrorEvent.
         */
        public function get callbackError():Function {return _callbackError;}

        /**
         * Current BulkLoader
         */
        public function get loader():BulkLoader {return _loader;}

        /**
         * Current state. One of LOAD_IN_PROGRESS / LOAD_COMPLETE / LOAD_ERROR / EXPECTED_LOADING
         */
        public function get state():String {return _state;}

        public function set url(value:String):void {_url = value;}

        public function set callbackComplete(value:Function):void {_callbackComplete = value;}

        public function set callbackError(value:Function):void {_callbackError = value;}

        public static const LOAD_IN_PROGRESS:String = 'stateLoadInProgress';
        public static const LOAD_COMPLETE:String = 'stateLoadComplete';
        public static const LOAD_ERROR:String = 'stateLoadError';
        public static const EXPECTED_LOADING:String = 'expected_loading';

        //*********************** CONSTRUCTOR ***********************
        /**
         * Make new ZContentItem
         * @param url - url for load. This url need to use for get downloaded content.
         * @param callbackComplete - callback will activate when load is end. In callback will transferred current ZContentItem.
         * @param callbackError - callback will activate when loading error. In callback will transferred object ErrorEvent.
         */
        public function ZContentItem(url:String, callbackComplete:Function = null, callbackError:Function = null) {
            _url = url;
            _callbackComplete = callbackComplete;
            _callbackError = callbackError;
            _state = EXPECTED_LOADING;
        }

        //***********************************************************

        /**
         * Start loaded content
         */
        public function startLoad():void {

            if (!isReadyToLoad()) {
                return;
            }

            _loader = new BulkLoader(_url);

            _loader.addEventListener(BulkLoader.COMPLETE, onCompleteHandler);
            _loader.addEventListener(BulkLoader.ERROR, onErrorHandler);

            _state = LOAD_IN_PROGRESS;
            _loader.add(_url, {id: _url});
            _loader.start();
        }

        public function isReadyToLoad():Boolean {
            if (!_url || _url == '') {
                return false;
            }
            if (_state == LOAD_COMPLETE) {
                trace('[ZContentItem] :', 'isReadyToLoad();  ', _url + ' was load.');
                return false;
            }
            if (_state == LOAD_IN_PROGRESS) {
                trace('[ZContentItem] :', 'isReadyToLoad();  ', _url + ' now loaded.');
                return false;
            }
            return true;
        }

        /**
         * Clear data before remove item
         */
        public function clear():void {
            _removeListeners();
            _url = null;
            _callbackComplete = null;
            _callbackError = null;
            _state = null;
            _loader.clear();
            _loader = null;
        }

        private function onCompleteHandler(event:ProgressEvent):void {

            _removeListeners();
            _state = LOAD_COMPLETE;

            if (_callbackComplete != null)_callbackComplete(this);
        }

        private function onErrorHandler(event:ErrorEvent):void {
            _removeListeners();
            _state = LOAD_ERROR;

            if (_callbackError != null)_callbackError(event);
            else trace('[Content] :', 'onErrorHandler();  ', event.toString());
        }

        private function _removeListeners():void {
            _loader.removeEventListener(BulkLoader.COMPLETE, onCompleteHandler);
            _loader.removeEventListener(BulkLoader.ERROR, onErrorHandler);
        }

    } //end class
}//end package