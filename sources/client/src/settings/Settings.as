package settings {

    import constants.GameConstants;

    import flash.display.StageDisplayState;

    public class Settings {


        private static const PROPS:Vector.<String> = new <String>[
            'localMode',
            'rootLocation',
            'appURL',
            'staticURL',
            'dataURL',
            'dataFormat',
            'frontendURL',
            'loginServerURL',
            'playerID',
            'sid',
            'locale',
            'versionID',
            'startLevel',
            'backgroundColor',
            'reals_exchange_coins',
            'reals_exchange_currency',
            'platform',
            'workers_acceleration',
            'available_helpers',
            'placeholder_helper',
            'spawn_limit',
            'spawnAcceleration',
            'coins_asset',
            'reals_asset',
            'daily_quests_timeout',
            'buildings_wait_timer_boost',
            'ingamelog',
            'default_friend_clicks'
        ];

        /** */
        public static var rootLocation:String;

        /** */
        public static var appURL:String;

        /** */
        public static var frontendURL:String;

        /** Login server URL */
        public static var loginServerURL:String;

        /** Unique player identifier */
        public static var playerID:String;

        /** URL part */
        public static var assetsPrefix:String = 'assets/';

        /** application language code */
//        public static var locale:String = Translations.DEFAULT_LOCALE;

        /** version */
        public static var versionID:String;

        /** session id */
        public static var sid:String;

        /**  */
        public static var startLevel:String;

        /** allow debug information */
        public static var ingamelog:int;

        public static var localMode:Boolean;

        public static var platform:String;
        public static var workers_acceleration:Boolean;
        public static var available_helpers:Array;
        public static var placeholder_helper:String;
        public static var spawn_limit:Object;
        public static var spawnAcceleration:Number = 1;
        public static var coins_asset:String = "res_coins";
        public static var reals_asset:String = "res_crystals";
        public static var daily_quests_timeout:Number;
        public static var backgroundColor:uint = 0x000000;
        public static var buildings_wait_timer_boost:int;

        public static var params:Object = { };

        /** Turn ON/OFF payment bonuses module */
        public static var initial_payment_enabled:Boolean = false;

        /** Turn ON/OFF sales module */
        public static var enable_sales:Boolean = false;

        /** Add skip for money button in quest list window */
        public static var enable_quest_buy_button:Boolean = false;

        /** show not textual  */
        public static var enable_icons_in_tooltips:Boolean = false;

        /** Turn ON/OFF animation effects */
        public static var enable_animation:Boolean = false;

        /** Allow unlocking market items in for premium currency */
        public static var allow_unlock_market_items:Boolean = false;

        /** delay after which is allowed to send another same request to same friend */
        public static var friend_request_delay:int = 20000;
        /** milliseconds */

        /** quest start dialog sequence */
//        public static var quest_start:String = QuestData.QUEST_START_DIALOG;

        public static var enable_friends:Boolean;
        public static var default_friend_clicks:int;
        public static var friend_clicks_reward:Object;
        public static var friend_restore_hour:int;

        /** On/Off spirit cave timers */
        public static var show_spirit_cave_timers:Boolean = false;

        /** Show kill enemy for money dialog if user don't have mana for killing it by himself */
        public static var kill_enemy_for_money:Boolean = false;

        /** Kill enemy for money cost in res_crystal */
        public static var kill_enemy_cost:int = 2;
        /* res_crystal */

        /** Tutorial version. First and second tutorial are hardcoded in game. 3 -- recommended */
        public static var tutorial:int = 2;

        public static var daily_bonus:int = 5;

        /** Delay before hide friend panel */
        public static var friends_auto_hide_delay:int = 0;
        /* milliseconds*/

        public static var ga_game_key:String = GameConstants.GA_GAME_KEY;
        public static var ga_secret_key:String = GameConstants.GA_SECRET_KEY;

        //-------------------------------------------------------------------
        // Application settings pseudo resources
        //-------------------------------------------------------------------

        /** Show special tab in bundles */
        public static var allow_bundles:int = 1;
    }


}
