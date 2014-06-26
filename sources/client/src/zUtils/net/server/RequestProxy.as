package zUtils.net.server {
    import zUtils.service.ZParsing;

    /**
     * Date   :  02.03.14
     * Time   :  17:54
     * author :  Vitaliy Snitko
     * mail   :  zaidite@gmail.com
     *
     * class description    :
     * class responsibility :
     */
    public class RequestProxy implements IRequestProxy {

        protected var _params:Object;
        protected var _url:String;
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

        public function set params(value:Object):void {_params = value;}

        public function set requestComplete(value:Function):void {_requestComplete = value;}

        public function set requestError(value:Function):void {_requestError = value;}

//*********************** CONSTRUCTOR ***********************
        public function RequestProxy(name:String, url:String) {
            _name = name;
            _url = url;
        }

        //***********************************************************

        public function onComplete():void {
            if (_response) {
                trace('[RequestProxy] :', 'onComplete();  ', name, ZParsing.getString(_response));
            } else {
                trace('[RequestProxy] :', '_onComplete(); response is NULL. ', name);
            }

            if (_requestComplete != null) {
                _requestComplete();
            }

        }

        public function onError():void {
            if (_requestError != null) {
                _requestError();
            }
            trace('[RequestProxy] :', 'onError();  ');
        }

        public function clearData():void {
            _params = null;
            _url = null;
            _dataFormat = null;
            _requestType = null;
            _requestComplete = null;
            _requestError = null;
            _name = null;
            _response = null;
        }

    } //end class
}//end package