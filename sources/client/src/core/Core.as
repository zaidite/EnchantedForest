package core {
    import core.model.proxy.FlashVarsProxy;

    import org.puremvc.as3.interfaces.IFacade;
    import org.puremvc.as3.patterns.facade.Facade;

    /**
     * Date   :  02.03.14
     * Time   :  13:37
     * author :  Vitaliy Snitko
     * mail   :  zaidite@gmail.com
     *
     * class description    :
     * class responsibility :
     */
    public class Core {

        private static var _gameFacade:GameFacade;

        public static function get facade():IFacade {return Facade.getInstance();}

        public static function get flashVarsProxy():FlashVarsProxy {return facade.retrieveProxy(FlashVarsProxy.NAME) as FlashVarsProxy;}

        public static function get gameFacade():GameFacade {return _gameFacade;}

        public static function set gameFacade(gameFacade:GameFacade):void {
            if (!_gameFacade) {
                _gameFacade = gameFacade;
            }
        }
    } //end class
}//end package