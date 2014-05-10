package core {
    import constants.GameNotifications;

    import core.controllers.GameDataController;
    import core.model.proxy.FlashVarsProxy;
    import core.model.proxy.StandaloneDataProxy;
    import core.model.proxy.FetchPlayerProxy;
    import core.model.valueObjects.FlashVarsVO;
    import core.view.GameViews;

    import org.puremvc.as3.interfaces.IFacade;
    import org.puremvc.as3.patterns.facade.Facade;

    import zUtils.net.server.ZRequests;
    import zUtils.net.server.processing.requests.UrlLoaderProcessing;
    import zUtils.service.ZParsing;

    /**
     * Date   :  02.03.14
     * Time   :  12:33
     * author :  Vitaliy Snitko
     * mail   :  zaidite@gmail.com
     *
     * class description    :
     * class responsibility :
     */
    public class GameFacade extends Facade implements IFacade {

        private var _main:Game;
        private var _gameViews:GameViews;

        private static var _instance:GameFacade;

        //*********************** CONSTRUCTOR ***********************
        public function GameFacade(secure:PrivateClass) {

        }

        //***********************************************************

        //init 1
        override protected function initializeModel():void {
            super.initializeModel();
            registerProxy(new StandaloneDataProxy());
            registerProxy(new FlashVarsProxy());
        }

        //init 2
        override protected function initializeController():void {
            super.initializeController();
            registerCommand(GameNotifications.STARTUP, GameDataController);
            registerCommand(GameNotifications.NEED_STANDALONE_DATA, GameDataController);
            registerCommand(GameNotifications.GETTING_FLASH_VARS, GameDataController);
        }

        //init 3
        override protected function initializeView():void {
            super.initializeView();
            _gameViews = new GameViews();
            _main.addChild(_gameViews);
        }

        //init 4
        public function startup(game:Game):void {
            _main = game;
            sendNotification(GameNotifications.STARTUP, game);
        }



        public static function instance():GameFacade {
            if (_instance == null) {
                GameFacade._instance = new GameFacade(new PrivateClass());
            }
            return _instance;
        }

    } //end class
}//end package

class PrivateClass {
    public function PrivateClass():void {}
}