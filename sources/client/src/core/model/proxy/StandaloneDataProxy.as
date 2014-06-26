package core.model.proxy {
    import core.Core;
    import core.GameFacade;
    import core.model.proxy.requests.SynchronizationProxy;
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

    import utils.Median;

    import zUtils.net.server.IRequestProxy;
    import zUtils.net.server.ZRequests;

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

        private var _requestTime:Number;

        private static const DELTA_THRESHOLD:Number = 1000;

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

            _initRequests();
            _getDeltaTime();
        }

        private function _initRequests():void {
            var defaultDataFormat:String = valueObject.jsOptions.settings['DATA_FORMAT'];
            var syncServerURL:String = valueObject.jsOptions.servers['timesync_server'];
            GameFacade.instance().initRequests(defaultDataFormat, syncServerURL);
        }

        private function _getDeltaTime():void {
            var syncProxy:IRequestProxy = ZRequests.manager().getProxy(SynchronizationProxy.NAME);
            _requestTime = getTimer();
            syncProxy.params = {'time': _requestTime };
            syncProxy.requestComplete = _formFlashVars;
            ZRequests.manager().requestStart(syncProxy);
        }

        private function _formFlashVars():void {
            var delta:Number = _calculationDeltaTime();
            var flashVars:Object = _standaloneDataToFlashVars(delta);
            Core.flashVarsProxy.validateFlashVars(flashVars);
        }

        private function _calculationDeltaTime():Number {

            var syncProxy:IRequestProxy = ZRequests.manager().getProxy(SynchronizationProxy.NAME);

            var responseTime:Number = getTimer();
            var serverTime:Number = syncProxy.response['time'];
            var duration:Number = responseTime - _requestTime;
            var currentDelta:Number = serverTime - _requestTime - duration / 2;

            var delta:Number;
            var deltaMedian:Median =  new Median();

            if (Math.abs(currentDelta - delta) > DELTA_THRESHOLD) {
                deltaMedian.reset();
                deltaMedian.add(currentDelta);
                delta = currentDelta;
            }
            else {
                deltaMedian.add(currentDelta);
                delta = deltaMedian.median;
            }

            return delta
        }

        private function _standaloneDataToFlashVars(delta:Number):Object {

            var str:String = "sid=" + valueObject.jsOptions.player.sid
                    + "&appURL=http://my.mail.ru/apps/618399"
                    + "&playerID=" + GameSettings.uid
                    + "&delta=" + delta
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
            return flashVars;
        }

    } //end class
}//end package