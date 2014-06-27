package settings {
    import constants.GameConstants;

    import flash.system.Capabilities;

    /**
     * Date   : 16.12.13
     * Time   : 13:59
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    :
     * responsibility :
     */
    public class GameSettingsOld {

        //-----------------------------
        // Backend URL
        //-----------------------------

        public static const MM_GAME:String = 'http://qamt-002.wysegames.com';
        public static const BACKDOOR_GAME:String = 'http://qamt-003.wysegames.com:8070';
        public static const CUSTOM_BRANCH_GAME:String = 'http://custombranch01-001.ef.qa.wysegames.com';

        public static const PORT:String = ':8070';

        //-----------------------------
        // User ID
        //-----------------------------

        private static var _USER_ID_MM:String = '9b6254841e37a1b';
        private static var _USER_ID_VK:String = '44e0fc9eeaf401b';
        private static var _USER_ID_FB:String = 'bfb863ac7fb3b91';
        private static var _USER_ID_BACKDOOR:String = '9b6254841e37a1b';
        private static var _USER_ID_CUSTOMBRANCH:String = '27885dc6f9cd57fea9';

        public static function get USER_ID_MM():String{return _USER_ID_MM;}
        public static function get USER_ID_VK():String{return _USER_ID_VK;}
        public static function get USER_ID_FB():String{return _USER_ID_FB;}
        public static function get USER_ID_BACKDOOR():String{return _USER_ID_BACKDOOR;}
        public static function get USER_ID_CUSTOMBRANCH():String{return _USER_ID_CUSTOMBRANCH;}

        CONFIG::USERS
        {
            // in Idea add missing definitions to : project structure -> build configuration -> compiler options -> conditional definitions
            _USER_ID_MM = CONFIG::USER_ID_MM;
            _USER_ID_VK = CONFIG::USER_ID_VK;
            _USER_ID_FB = CONFIG::USER_ID_FB;
            _USER_ID_BACKDOOR = CONFIG::USER_ID_BACKDOOR;
            _USER_ID_CUSTOMBRANCH = CONFIG::USER_ID_CUSTOMBRANCH;
        }

        public static const VITALIY:Object = {vk: USER_ID_VK, mm: USER_ID_MM, dev: USER_ID_BACKDOOR, fb: USER_ID_FB};

        public static const PLATFORM:String = GameConstants.PLATFORM_MM;

        public static function get standalone():Boolean
        {
            var playerType:String = Capabilities.playerType;
            return playerType == "StandAlone";
        }


        public static function get backendURL():String {
            switch (PLATFORM) {
                case GameConstants.PLATFORM_MM:
                    return MM_GAME + PORT;
                case GameConstants.PLATFORM_BACKDOOR:
                    return BACKDOOR_GAME + PORT;
                case GameConstants.PLATFORM_CUSTOMBRANCH:
                    return CUSTOM_BRANCH_GAME;
            }
            return null;
        }

        public static function get uid():String {
            switch (PLATFORM) {
                case GameConstants.PLATFORM_BACKDOOR:
                    return USER_ID_BACKDOOR;
                case GameConstants.PLATFORM_VK:
                    return USER_ID_VK;
                case GameConstants.PLATFORM_MM:
                    return USER_ID_MM;
                case GameConstants.PLATFORM_CUSTOMBRANCH:
                    return USER_ID_CUSTOMBRANCH;
            }
            return null;

        }

        public static function currentUserIs(ids:Object):Boolean {

            for each (var id:String in ids) {
                if (id == uid) {
                    return true;
                }
            }

            return false;
        }



    }
}
