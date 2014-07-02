package managers {
    import core.Core;
    import core.model.proxy.StandaloneDataProxy;

    import flash.external.ExternalInterface;
    import flash.system.Capabilities;

    /**
     * Date   : 01.07.2014
     * Time   : 18:28
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    :
     * responsibility :
     */
    public class Iframe {

        public var ref_code:String;
        public var ref_channel:Object;

        private static var _instance:Iframe;

        private static const EXTERNAL_METHOD:String = 'Cherry.application.game.';

        //*********************** CONSTRUCTOR ***********************
        public function Iframe(secure:PrivateClass) {

        }

        //***********************************************************

        private function _callExternal(method:String, ...args):Object {
            if (ExternalInterface.available) {
                var method:String = EXTERNAL_METHOD + method;
                args.unshift(method);
                return ExternalInterface.call.apply(null, args);
            }
            return null;
        }

        public function initSocialData():void {

            var data:Object;
            var standaloneDataProxy:StandaloneDataProxy = Core.facade.retrieveProxy(StandaloneDataProxy.NAME) as StandaloneDataProxy;
            if (Capabilities.playerType == "StandAlone")
                data = {player: standaloneDataProxy.player, firends: standaloneDataProxy.friends};
            else
                data = _callExternal('getSocialData');

            //TIP: To see user data uncomment line below
            //trace("getSocialData: " + utils.formatJSON(JSON.stringify(data)));

//            this._profile = new SocialProfile(data['player']);
//            this.facade.registerProxy(this._profile);

//            this._friends = new FriendsInGameCollection(data['friends']);
//            this.facade.registerProxy(this._friends);

//            _allFriends = new AllFriendsCollection(data['all_friends']);
//            facade.registerProxy(_allFriends);

            ref_code = data['ref_code'];
            ref_channel = data['ref_channel'];

        }

        public static function get manager():Iframe {
            if (!_instance) {
                Iframe._instance = new Iframe(new PrivateClass());
            }
            return _instance;
        }

    } //end class
}//end package

class PrivateClass {
    public function PrivateClass():void {}
}