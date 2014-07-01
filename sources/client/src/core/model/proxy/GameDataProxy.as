package core.model.proxy {
    import constants.GameNotifications;

    import core.Core;
    import core.GameFacade;
    import core.model.proxy.requests.GameDataRequest;
    import core.model.proxy.requests.SynchronizationRequest;
    import core.model.valueObjects.GameDataVO;
    import core.model.valueObjects.StandaloneDataVO;

    import flash.errors.IllegalOperationError;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.utils.getTimer;

    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;

    import settings.GameSettingsOld;

    import utils.Median;

    import zUtils.net.server.IRequestProxy;
    import zUtils.net.server.ZRequests;

    /**
     * Date   : 06.05.2014
     * Time   : 15:20
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    : При загрузке клиента в standAlone режиме получает и формирует данные эмулирующие флешварсы при загрузке в браузере.
     * responsibility :
     */
    public class GameDataProxy extends Proxy implements IProxy {

        public function get dataReceived():Boolean {return Boolean(_valueObject.gameData);}

        private function get _valueObject():GameDataVO {return data as GameDataVO;}

        public static const NAME:String = 'GameDataProxy';

        //*********************** CONSTRUCTOR ***********************
        public function GameDataProxy() {
            super(NAME, new GameDataVO());
        }

        //***********************************************************

        private function _saveGameData():void {

            var request:GameDataRequest = ZRequests.manager().getProxy(GameDataRequest.NAME) as GameDataRequest;
            _valueObject.gameData = request.response;
            sendNotification(GameNotifications.GETTING_GAME_DATA);
        }

        public function getGameData():void {

            if(_valueObject.gameData) {
                throw new IllegalOperationError('[GameDataProxy] getGameData() : gameData is already. ');
            }

            var request:GameDataRequest = ZRequests.manager().getProxy(GameDataRequest.NAME) as GameDataRequest;
            request.initRequestData();

            request.requestComplete = _saveGameData;
            ZRequests.manager().requestStart(request);
        }



    } //end class
}//end package