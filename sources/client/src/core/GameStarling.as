package core {
import starling.display.Sprite;
import starling.events.Event;

/**
     * Date   : 03.07.2014
     * Time   : 10:23
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    :
     * responsibility :
     */
    public class GameStarling extends Sprite {

        public static var instance:GameStarling;

        //*********************** CONSTRUCTOR ***********************
        public function GameStarling() {
            super();
            if (stage && stage.stageWidth && stage.stageHeight)_initData();
            else addEventListener(Event.ENTER_FRAME, _initData);
        }

        //***********************************************************

        private function _initData(e:Event = null):void {
            if (!stage || !stage.stageWidth || !stage.stageHeight)return;
            removeEventListener(Event.ENTER_FRAME, _initData);

            instance = this;
            GameFacade.instance().startup();
        }

    } //end class
}//end package