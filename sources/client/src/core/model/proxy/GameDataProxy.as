package core.model.proxy {
    import constants.GameNotifications;

    import core.model.proxy.requests.GameDataRequest;
    import core.model.valueObjects.GameDataVO;

    import flash.errors.IllegalOperationError;

    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;

    import zUtils.net.server.ZRequests;

    /**
     * Date   : 06.05.2014
     * Time   : 15:20
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    : Получает, хранит и управляет данными игры.
     * responsibility :
     */
    public class GameDataProxy extends Proxy implements IProxy {

        public function get dataReceived():Boolean {return Boolean(_valueObject.data);}

        private function get _valueObject():GameDataVO {return data as GameDataVO;}

        public static const NAME:String = 'GameDataProxy';

        //*********************** CONSTRUCTOR ***********************
        public function GameDataProxy() {
            super(NAME, new GameDataVO());
        }

        //***********************************************************

        private function _saveGameData():void {

            var request:GameDataRequest = ZRequests.manager().getProxy(GameDataRequest.NAME) as GameDataRequest;
            _valueObject.data = request.response;
            sendNotification(GameNotifications.GETTING_GAME_DATA);
        }

        public function getGameData():void {

            if(dataReceived) {
                throw new IllegalOperationError('[GameDataProxy] getGameData() : gameData is already. ');
            }

            var request:GameDataRequest = ZRequests.manager().getProxy(GameDataRequest.NAME) as GameDataRequest;
            request.initRequestData();

            request.requestComplete = _saveGameData;
            ZRequests.manager().requestStart(request);
        }



    } //end class
}//end package