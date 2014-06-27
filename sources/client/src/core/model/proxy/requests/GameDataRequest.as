package core.model.proxy.requests {
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

        public static const NAME : String = 'GameDataRequest';

        //*********************** CONSTRUCTOR ***********************
        public function GameDataRequest() {
            super(NAME, url);
            _init();
        }

        //***********************************************************

        private function _init():void {



        }

    } //end class
}//end package