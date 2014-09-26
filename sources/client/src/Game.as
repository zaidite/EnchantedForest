package {
    import core.GameFacade;
    import core.GameStarling;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.display3D.Context3DRenderMode;
    import flash.events.Event;
    import flash.system.Security;

    import starling.core.Starling;

    import zUtils.service.ZLogger;

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

        public static var instance:Game;
        private var _starling:Starling;

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

            instance = this;
            _initLogger();

            Security.allowDomain('*');
            Security.allowInsecureDomain('*');

            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            _initStarling();
        }

        private function _initStarling():void {
            _starling = new Starling(GameStarling, stage, null, null, Context3DRenderMode.AUTO);
            _starling.simulateMultitouch = true;
            _starling.antiAliasing = 2;
            _starling.showStats = false;
            _starling.start();
        }

        private function _initLogger():void {
            ZLogger.init.tracing();
            ZLogger.init.console(stage, '`');
        }

    } //end class
}//end package