package {
    import core.GameFacade;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.system.Capabilities;
    import flash.utils.getTimer;

    /**
     * Date   :  01.03.14
     * Time   :  23:03
     * author :  Vitaliy Snitko
     * mail   :  zaidite@gmail.com
     *
     * class description    :
     * class responsibility :
     */
    [Frame(factoryClass="MainPreloader")]
    [SWF(pageTitle="Main", width="760", height="670", widthPercent="100", heightPercent="100", frameRate="120", backgroundColor="#209803")]
    public class Main extends Sprite {

        private var sid:String = "";
        private var _requestTime:Number;
        public var setProgress:Function;
        public var flashVars:Object;

        public static var jsOptions:Object;

        //*********************** CONSTRUCTOR ***********************
        public function Main() {

            var playerType:String = Capabilities.playerType;
            if (playerType == "StandAlone") {
                var request:URLRequest = new URLRequest(MineSettings.getServerURL());
                var loader:URLLoader = new URLLoader();
                loader.addEventListener(Event.COMPLETE, _loader_completeHandler);
                loader.addEventListener(IOErrorEvent.IO_ERROR, _loader_ioErrorHandler);
                loader.load(request);
            }

            if (stage && stage.stageWidth && stage.stageHeight) {
                _initData();
            } else {
                addEventListener(Event.ENTER_FRAME, _initData);
            }
        }

        //***********************************************************

        private function _initData(e:Event = null):void {
            if (!stage || !stage.stageWidth || !stage.stageHeight)return;
            removeEventListener(Event.ENTER_FRAME, _initData);

            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            GameFacade.instance().startup(this);
        }

        private function _loader_ioErrorHandler(event:IOErrorEvent):void {
            trace(this, "loader_ioErrorHandler", event);
        }

        private function _loader_completeHandler(event:Event):void {
            var loader:URLLoader = event.currentTarget as URLLoader;
            var str:String = String(loader.data);
            var lines:Array = str.split("\n");
            for each (var line:String in lines) {
                var index:int = line.indexOf("Cherry.options = ");
                if (index == 0) {
                    var strOptions:String = line.slice(17, line.length - 1);
                    jsOptions = JSON.parse(strOptions);
                    sid = jsOptions.player.sid;
                    jsOptions.servers.timesync_server;
                    _sync();
                    return;
                }
            }
        }

        private function _sync():void {
            // TODO:
            _requestTime = getTimer();
//            var syncRequest:DataRequest = DataRequest.init(GameSettings.getSyncServerURL(), dataFormat);
//            syncRequest.doneCallbackRegister(_syncCallback, true);
//            syncRequest.start({'time': _requestTime});
        }

    } //end class
}//end package