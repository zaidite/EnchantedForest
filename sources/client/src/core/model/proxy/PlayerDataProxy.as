package core.model.proxy {
    import constants.GameNotifications;

    import core.model.proxy.requests.GameDataRequest;
    import core.model.proxy.requests.PlayerDataRequest;
    import core.model.valueObjects.GameDataVO;
    import core.model.valueObjects.PlayerDataVO;

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
     * description    : Получает, хранит и управляет данными игрока.
     * responsibility :
     */
    public class PlayerDataProxy extends Proxy implements IProxy {

        public function get dataReceived():Boolean {return Boolean(_valueObject.data);}

        private function get _valueObject():PlayerDataVO {return data as PlayerDataVO;}

        public static const NAME:String = 'PlayerDataProxy';

        //*********************** CONSTRUCTOR ***********************
        public function PlayerDataProxy() {
            super(NAME, new PlayerDataVO());
        }

        //***********************************************************

        private function _savePlayerData():void {

            var request:PlayerDataRequest = ZRequests.manager().getProxy(PlayerDataRequest.NAME) as PlayerDataRequest;
            _valueObject.data = request.response;
            sendNotification(GameNotifications.GETTING_PLAYER_DATA);
        }

        public function getPlayerData():void {

            if(dataReceived) {
                throw new IllegalOperationError('[PlayerDataProxy] getPlayerData() : playerData is already. ');
            }

            var request:PlayerDataRequest = ZRequests.manager().getProxy(PlayerDataRequest.NAME) as PlayerDataRequest;
            request.initRequestData();

            request.requestComplete = _savePlayerData;
            ZRequests.manager().requestStart(request);
        }



    } //end class
}//end package