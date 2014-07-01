package core.model.proxy.requests {
    import core.Core;
    import core.model.proxy.FlashVarsProxy;

    import managers.Iframe;

    import zUtils.net.server.IRequestProxy;
    import zUtils.net.server.RequestProxy;

    /**
     * Date   : 12.05.2014
     * Time   : 14:23
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    :
     * responsibility :
     */
    public class PlayerDataRequest extends RequestProxy implements IRequestProxy {

        public static const NAME:String = 'PlayerDataRequest';
        public static const FETCH_PLAYER:String = 'fetch_player';

        //*********************** CONSTRUCTOR ***********************
        public function PlayerDataRequest() {
            super(NAME, url);
        }

        //***********************************************************

        public function initRequestData():void {

            var flashVarsProxy:FlashVarsProxy = Core.flashVarsProxy;
            _url = flashVarsProxy.frontendURL;

            params = {
                "action": FETCH_PLAYER,
                "player_id": flashVarsProxy.playerID,
                "sid": flashVarsProxy.sid,
                "ref_code": Iframe.manager.ref_code,
                "ref_channel": Iframe.manager.ref_channel
            }

        }

    } //end class
}//end package