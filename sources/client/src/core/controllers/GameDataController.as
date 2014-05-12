package core.controllers {
    import core.Core;
    import core.GameFacade;

    import constants.GameNotifications;

    import core.model.proxy.FlashVarsProxy;
    import core.model.proxy.requests.FetchPlayerProxy;
    import core.model.proxy.StandaloneDataProxy;
    import core.model.proxy.requests.SynchronizationProxy;

    import flash.utils.getTimer;

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
                    Core.flashVarsProxy.validateFlashVars(game.stage.loaderInfo.parameters);
                    break;

                case GameNotifications.NEED_STANDALONE_DATA:
                    var standAloneProxy:StandaloneDataProxy = Core.facade.retrieveProxy(StandaloneDataProxy.NAME) as StandaloneDataProxy;
                    standAloneProxy.geStandaloneData();
                    break;

                case GameNotifications.GETTING_FLASH_VARS:
                    GameFacade.instance().initRequests();
                    var syncProxy:IRequestProxy = ZRequests.manager().getProxy(SynchronizationProxy.NAME);
                    syncProxy.params = {'time': getTimer()};
                    syncProxy.requestComplete = _syncComplete;
                    ZRequests.manager().requestStart(syncProxy);
                    break;
            }
        }

        private function _syncComplete():void {
            var syncProxy:IRequestProxy = ZRequests.manager().getProxy(SynchronizationProxy.NAME);
            trace('[GameDataController] :', '_syncComplete();  ', ZParsing.getString(syncProxy.response));
        }

    } //end class
}//end package