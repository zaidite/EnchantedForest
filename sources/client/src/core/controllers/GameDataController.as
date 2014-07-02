package core.controllers {
    import constants.GameNotifications;

    import core.Core;
    import core.model.proxy.GameDataProxy;
    import core.model.proxy.PlayerDataProxy;
    import core.model.proxy.StandaloneDataProxy;

    import managers.Iframe;

    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;

    /**
     * Date   :  02.03.14
     * Time   :  13:09
     * author :  Vitaliy Snitko
     * mail   :  zaidite@gmail.com
     *
     * class description    :
     * class responsibility :
     */
    public class GameDataController extends SimpleCommand {

        //*********************** CONSTRUCTOR ***********************
        public function GameDataController() {
        }

        //***********************************************************

        override public function execute(notification:INotification):void {
            super.execute(notification);

            var note:String = notification.getName();

            switch (note) {
                case GameNotifications.STARTUP:
                    var game:Game = notification.getBody() as Game;
                    Core.flashVarsProxy.validateFlashVars(game.stage.loaderInfo.parameters);
                    break;

                case GameNotifications.NEED_STANDALONE_DATA:
                    var standAloneProxy:StandaloneDataProxy = Core.facade.retrieveProxy(StandaloneDataProxy.NAME) as StandaloneDataProxy;
                    standAloneProxy.geStandaloneData();
                    break;

                case GameNotifications.GETTING_FLASH_VARS:
                    Core.gameFacade.initRequestCore(Core.flashVarsProxy.dataFormat, Core.flashVarsProxy.timeServerURL);
                    Iframe.manager.initSocialData();
                    Core.gameDataProxy.getGameData();
                    Core.playerDataProxy.getPlayerData();
                    //загрузка библиотек ассетов
                    break;
                case GameNotifications.GETTING_GAME_DATA:
                    _checkAllDataLoading();
                    break;
                case GameNotifications.GETTING_PLAYER_DATA:
                    _checkAllDataLoading();
                    break;
                case GameNotifications.GETTING_ASSETS_LIBS:
                    _checkAllDataLoading();
                    break;
            }
        }

        private function _checkAllDataLoading() : void
        {
            var gameDataProxy:GameDataProxy = Core.gameDataProxy;
            trace('[GameDataController] :', '_checkAllDataLoading();  - gameDataProxy.dataReceived ', gameDataProxy.dataReceived);
            if(!gameDataProxy.dataReceived) {
                return;
            }

            var playerDataProxy:PlayerDataProxy = Core.playerDataProxy;
            trace('[GameDataController] :', '_checkAllDataLoading();  - playerDataProxy.dataReceived ', playerDataProxy.dataReceived);
            if(!playerDataProxy.dataReceived) {
                return;
            }



        }


    } //end class
}//end package