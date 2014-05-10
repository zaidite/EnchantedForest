package core.model.proxy {
    import core.Core;
    import core.model.valueObjects.StandaloneDataVO;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.utils.getTimer;

    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;

    import settings.GameSettings;

    /**
     * Date   : 06.05.2014
     * Time   : 15:20
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    :
     * responsibility :
     */
    public class StandaloneDataProxy extends Proxy implements IProxy {

        public function get valueObject():StandaloneDataVO {return data as StandaloneDataVO;}

        public static const NAME:String = 'StandaloneDataProxy';

        //*********************** CONSTRUCTOR ***********************
        public function StandaloneDataProxy() {
            super(NAME, new StandaloneDataVO());
        }

        //***********************************************************

        public function geStandaloneData():void {
            var request:URLRequest = new URLRequest(GameSettings.backendURL + '/play?user_id=' + GameSettings.uid);
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, _loaderCompleteHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, _loaderIoErrorHandler);
            loader.load(request);
        }

        private function _loaderIoErrorHandler(event:IOErrorEvent):void {
            trace(this, "loader_ioErrorHandler", event);
        }

        private function _loaderCompleteHandler(event:Event):void {
            const optionsLineStart:String = "Cherry.options = ";
            var loader:URLLoader = event.currentTarget as URLLoader;
            var str:String = String(loader.data);

            var startIndex:int = str.indexOf(optionsLineStart);
            if (startIndex == -1) {
                trace("WARNING: Cherry.options not found in HTML-file. Game loading stopped.");
                return;
            }

            startIndex += optionsLineStart.length;
            var endIndex:int = str.indexOf("\n", startIndex);

            var strOptions:String = str.slice(startIndex, endIndex - 1);
            valueObject.jsOptions = JSON.parse(strOptions);

            _standaloneDataToFlashVars();
        }

        private function _standaloneDataToFlashVars():void {

            var str:String = "sid=" + valueObject.jsOptions.player.sid
                    + "&appURL=http://my.mail.ru/apps/618399"
                    + "&playerID=" + GameSettings.uid
                    + "&delta=" + 0//_delta
                    + "&applicationTime=" + getTimer().toFixed(0)
                    + "&rootLocation=./"
                    + "&loginServerURL=" + valueObject.jsOptions.servers.login_server
                    + "&gameServerURL=" + valueObject.jsOptions.servers.game_server
                    + "&timeServerURL=" + valueObject.jsOptions.servers.timesync_server
                    + "&frontendURL=" + valueObject.jsOptions.servers.game_server
                    + "&locale=ru"
                    + "&dataFormat=json"
                    + "&platform=mail.ru"
                    + "&developmentMode=true"
                    + "&backgroundColor=0"
                    + "&ingamelog=" + valueObject.jsOptions.flash_settings.ingamelog
                    + "&enable_friends=" + valueObject.jsOptions.flash_settings.enable_friends
                    + "&coins_asset=res_coins"
                    + "&reals_asset=res_crystals"
                    + "&default_friend_clicks=5"
                    + "&main_swf_url=/static/game.swf"
                    + "&spirits_free_wait_time=172800000"
                    + "&enable_animation=true"
                    + "&startLevel=loc_Briar"
                    + "&quest_start=dialog_helper"
                    + "&buildings_wait_timer_boost=1"
                    + "&enable_sales=true"
                    + "&kill_enemy_for_money=true"
                    + "&daily_quests_timeout=86400000"
                    + "&tutorial=3"
                    + "&enable_quest_buy_button=true"
                    + '&friend_restore_hour=' + valueObject.jsOptions.flash_settings.friend_restore_hour
                    + '&initial_payment_enabled=true';

            var flashVars:Object = new URLVariables(str);
            Core.flashVarsProxy.validateFlashVars(flashVars);
        }

    } //end class
}//end package