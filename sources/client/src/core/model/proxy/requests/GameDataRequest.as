package core.model.proxy.requests {
    import core.Core;

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
    public class GameDataRequest extends RequestProxy implements IRequestProxy {

        public static const NAME:String = 'GameDataRequest';
        public static const PATH : String = '/static/data/';
        public static const DATA_NAME : String = 'data.';


        //*********************** CONSTRUCTOR ***********************
        public function GameDataRequest() {
            super(NAME, url);
        }

        //***********************************************************

        public function initRequestData():void {

            var gameDataURL:String = Core.flashVarsProxy.loginServerUrl;
            var path:String = PATH + DATA_NAME + Core.flashVarsProxy.localisation;

            _url = gameDataURL + path;
        }

    } //end class
}//end package