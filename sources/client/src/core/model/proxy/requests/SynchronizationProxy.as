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
    public class SynchronizationProxy extends RequestProxy implements IRequestProxy {

        public static const NAME : String = 'Synchronization';

        //*********************** CONSTRUCTOR ***********************
        public function SynchronizationProxy(url:String) {
            super(NAME, url);
        }
        //***********************************************************

    } //end class
}//end package