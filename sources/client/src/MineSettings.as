package {

    /**
     * Date   : 16.12.13
     * Time   : 13:59
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    :
     * responsibility :
     */
    public class MineSettings {

        // --- PRIVATE STATIC CONSTANT -------------------------------- //
        public static const VK_LOGIN:String = '//efvk-000.wysegames.com';
        public static const VK_GAME:String = '//efvk-006.wysegames.com';
        public static const VK_TIME:String = '//efvk-010.wysegames.com';
        public static const VK_FRONTEND:String = '//efvk-006.wysegames.com';

        /* private static const OK_LOGIN:String = '//efok-000.wysegames.com';
         private static const OK_GAME:String = '//efok-006.wysegames.com';
         private static const OK_TIME:String = '//efok-010.wysegames.com';
         private static const OK_FRONTEND:String = '//efok-006.wysegames.com';*/

        public static const MM_LOGIN:String = 'http://qamt-001.wysegames.com';
        public static const MM_GAME:String = 'http://qamt-002.wysegames.com';
        public static const MM_TIME:String = 'http://qamt-005.wysegames.com';
        public static const MM_FRONTEND:String = 'http://qamt-002.wysegames.com';

        public static const FB_LOGIN:String = 'https://stmt-006.wysegames.com';
        public static const FB_GAME:String = 'http://stmt-008.wysegames.com';
        public static const FB_TIME:String = 'http://stmt-010.wysegames.com';
        public static const FB_FRONTEND:String = "http://stmt-008.wysegames.com";

        public static const BACKDOOR_LOGIN:String = 'http://qamt-000.wysegames.com';
        public static const BACKDOOR_GAME:String = 'http://qamt-003.wysegames.com';
        public static const BACKDOOR_TIME:String = 'http://qamt-005.wysegames.com';
        public static const BACKDOOR_FRONTEND:String = 'http://qamt-003.wysegames.com';

        public static const PORT:String = ':8070';
        public static const PLAY_USER:String = '/play?user_id=';
        public static const SYNC:String = '/sync';
        public static const PATH:String = '/static/assets/';

        public static const CURRENT_USER:Object = {vk: USER_ID_VK, mm: USER_ID_MM, dev: USER_ID_BACKDOOR};

        public static const USER_ID_VK:String = '44e0fc9eeaf401b';
        public static const USER_ID_FB:String = 'bfb863ac7fb3b91';
        public static const USER_ID_MM:String = 'a95920e99e3779b';
        public static const USER_ID_BACKDOOR:String = '9b6254841e37a1b';

        // --- PUBLIC STATIC CONSTANT ------------------------------------ //
        public static const PLATFORM_VK:String = 'vk';
        public static const PLATFORM_MM_DEV:String = 'mail.ru';
        public static const PLATFORM_BACKDOOR:String = 'backdoor';
        public static const PLATFORM_OK:String = 'ok';
        public static const PLATFORM_FB:String = 'fb';
        public static const PLATFORM_SIXWAVES_FB:String = 'sixwaves_fb';
        public static const PLATFORM_PHOTO_COUNTRY:String = 'fs';

        public static const VITALIY:Object = {vk: USER_ID_VK, mm: USER_ID_MM, dev: USER_ID_BACKDOOR, fb: USER_ID_FB};
        public static const PLATFORM:String = PLATFORM_MM_DEV;

        //*********************** CONSTRUCTOR ***********************

        public function MineSettings() {
        }

        //***********************************************************

        // --- PUBLIC STATIC FUNCTION ------------------------------------ //
        public static function getServerURL():String {
            switch (PLATFORM) {
                case PLATFORM_MM_DEV:
                    return MM_GAME + PORT + PLAY_USER + getUserID();

            }
            return null;
        }

        public static function getAssetsURL():String {
            switch (PLATFORM) {
                case PLATFORM_MM_DEV:
                    return MM_LOGIN + PATH;
            }
            return null;
        }

        public static function getSyncServerURL():String {
            switch (PLATFORM) {
                case PLATFORM_MM_DEV:
                    return MM_TIME + SYNC;

            }
            return null;
        }

        public static function getUserID():String {
            switch (PLATFORM) {
                case PLATFORM_BACKDOOR:
                    return USER_ID_BACKDOOR;
                case PLATFORM_VK:
                    return USER_ID_VK;
                case PLATFORM_MM_DEV:
                    return USER_ID_MM;
            }
            return null;

        }

       /* public static function currentUserIs(ids:Object):Boolean {

            if (!Settings.params) {
                throw new Error('[GameSettings] currentUserIs() : Error : Settings params = null !!!');
            }

            var playerId:String = Settings.params['playerID'];

            for each (var id:String in ids) {
                if (id == playerId) {
                    return true;
                }
            }

            return false;
        }

        public static function socialIsFaceBook():Boolean {
            if (*//*Settings.platform == GameSettings.PLATFORM_MM_DEV ||*//*
                Settings.platform == MineSettings.PLATFORM_FB ||
                Settings.platform == MineSettings.PLATFORM_SIXWAVES_FB) {
                return true;
            }
            return false;
        }*/

    }
}//end package
