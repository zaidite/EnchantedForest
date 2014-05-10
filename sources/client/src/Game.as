package {
    import core.GameFacade;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.system.Security;

    /**
     * Date   :  01.03.14
     * Time   :  23:03
     * author :  Vitaliy Snitko
     * mail   :  zaidite@gmail.com
     *
     * class description    :
     * class responsibility :
     */
    [Frame(factoryClass="ApplicationPreloader")]
    [SWF(pageTitle="Main", width="760", height="670", widthPercent="100", heightPercent="100", frameRate="120", backgroundColor="#209803")]
    public class Game extends Sprite {

        //*********************** CONSTRUCTOR ***********************
        public function Game() {

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

            Security.allowDomain('*');
            Security.allowInsecureDomain('*');

            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            GameFacade.instance().startup(this);

        }


        private function _sync():void {
           /* _requestTime = getTimer();
            var url:String = timesync_server + "/sync";
            var format:String = dataFormat;
            var params:Object = {'time': _requestTime};*/

//            var syncRequest:DataRequest = DataRequest.init(timesync_server + "/sync", dataFormat);
//            syncRequest.doneCallbackRegister(_syncCallback, true);
//            syncRequest.start({'time': _requestTime});
        }



    } //end class
}//end package