package core {
    import constants.GameNotifications;

    import core.controllers.GameDataController;
    import core.model.proxy.DebugDataProxy;
    import core.model.proxy.FlashVarsProxy;
    import core.model.proxy.GameDataProxy;
    import core.model.proxy.PlayerDataProxy;
    import core.model.proxy.StandaloneDataProxy;
    import core.model.proxy.requests.GameDataRequest;
    import core.model.proxy.requests.PlayerDataRequest;
    import core.model.proxy.requests.SynchronizationRequest;
    import core.view.GameViews;

    import org.puremvc.as3.interfaces.IFacade;
    import org.puremvc.as3.patterns.facade.Facade;

    import zUtils.net.server.ZRequests;
    import zUtils.net.server.processing.requests.UrlLoaderProcessing;

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

        private var _gameViews:GameViews;

        private static var _instance:GameFacade;

        //*********************** CONSTRUCTOR ***********************
        public function GameFacade(secure:PrivateClass) {

        }

        //***********************************************************

        //init 1
        override protected function initializeModel():void {
            super.initializeModel();
            registerProxy(new DebugDataProxy());
            registerProxy(new StandaloneDataProxy());
            registerProxy(new FlashVarsProxy());
            registerProxy(new GameDataProxy());
            registerProxy(new PlayerDataProxy());
        }

        //init 2
        override protected function initializeController():void {
            super.initializeController();
            registerCommand(GameNotifications.STARTUP, GameDataController);
            registerCommand(GameNotifications.NEED_STANDALONE_DATA, GameDataController);
            registerCommand(GameNotifications.GETTING_FLASH_VARS, GameDataController);
            registerCommand(GameNotifications.GETTING_GAME_DATA, GameDataController);
            registerCommand(GameNotifications.GETTING_PLAYER_DATA, GameDataController);
            registerCommand(GameNotifications.GETTING_ASSETS_LIBS, GameDataController);
        }

        //init 3
        override protected function initializeView():void {
            super.initializeView();
            _gameViews = new GameViews();
			GameStarling.instance.addChild(_gameViews);
        }

        //init 4
        public function startup():void {
            Core.gameFacade = this;
            sendNotification(GameNotifications.STARTUP, Game.instance);
        }

        public function initRequestCore(dataFormat:String, timeServerUrl:String):void {
        	ZRequests.manager().init(UrlLoaderProcessing.TYPE, dataFormat);

            ZRequests.manager().registerProxy(new SynchronizationRequest(timeServerUrl + "/sync"));
            ZRequests.manager().registerProxy(new GameDataRequest());
            ZRequests.manager().registerProxy(new PlayerDataRequest());
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