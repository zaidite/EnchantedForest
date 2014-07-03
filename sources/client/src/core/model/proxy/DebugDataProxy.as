package core.model.proxy {
    import com.junkbyte.console.Cc;

    import core.Core;

    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;

    /**
     * Date   : 03.07.2014
     * Time   : 10:33
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    :
     * responsibility :
     */
    public class DebugDataProxy extends Proxy implements IProxy {

        public static const NAME:String = 'DebugDataProxy';

        //*********************** CONSTRUCTOR ***********************
        public function DebugDataProxy() {
            super(NAME, {});

            Cc.addMenu('ShowData', _showData);

        }
        //***********************************************************

        private function _showData() : void
        {
            var gameDataProxy:GameDataProxy = Core.gameDataProxy;
            var playerDataProxy:PlayerDataProxy = Core.playerDataProxy;
        }


    } //end class
}//end package