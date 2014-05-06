package core.controllers {
    import core.Core;
    import core.GameFacade;
    import constants.GameNotifications;
    import core.model.proxy.FlashVarsProxy;
    import core.model.proxy.FetchPlayerProxy;
    import core.model.proxy.StandaloneDataProxy;

    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;

    import zUtils.net.server.IRequestProxy;

    import zUtils.net.server.ZRequests;

    import zUtils.service.ZParsing;

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
                    Core.flashVarsProxy.validateFlashVars(game.loaderInfo.parameters);
                    break;

                case GameNotifications.NEED_STANDALONE_DATA:
                    var standAloneProxy:StandaloneDataProxy = Core.facade.retrieveProxy(StandaloneDataProxy.NAME) as StandaloneDataProxy;
                    standAloneProxy.geStandaloneData();
                    break;

                case GameNotifications.GETTING_FLASH_VARS:
//                    GameFacade.instance().initCore();
//                    var fetchPlayer:IRequestProxy = ZRequests.manager().getProxy(FetchPlayerProxy.NAME);
//                    ZRequests.manager().requestStart(fetchPlayer);
                        //TODO Синхронизация времени с сервером
                    break;
            }
        }

    } //end class
}//end package