package utils {

    /**
     * Date   : 01.07.2014
     * Time   : 12:42
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    :
     * responsibility :
     */
    public class Localization {

        private var _data : Object ;
        private var _locale:String = LOCALE_DEFAULT;


        public function get locale():String {return _locale;}

        private static var _instance:Localization;

        public static const LOCALE_EN:String = "en";
        public static const LOCALE_RU:String = "ru";
        public static const LOCALE_DE:String = "de";
        public static const LOCALE_PT:String = 'pt';
        public static const LOCALE_ES:String = 'es';
        public static const LOCALE_JP:String = 'jp';
        public static const LOCALE_PL:String = 'pl';
        public static const LOCALE_DEFAULT:String = LOCALE_RU;

        //*********************** CONSTRUCTOR ***********************
        public function Localization(secure:PrivateClass) {

        }

        //***********************************************************

        private function _getLocalizationData(id:String):Object {
            if (_data && id in _data)
                return _data[id];

            return null;
        }

        public function init(data:Object) : void
        {
        	_data = data;
        }


        public function getString(id:String):String {
            if (id == null || id == "") {
                return "***";
            }

            var entity:Object = _getLocalizationData(id);
            var locale:String = _locale;
            var result:String = id;

            if (entity && locale in entity)
                result = entity[locale];

            return result;
        }

        public static function manager():Localization {
            if (!_instance) {
                Localization._instance = new Localization(new PrivateClass());
            }
            return _instance;
        }

    } //end class
}//end package

class PrivateClass {
    public function PrivateClass():void {}
}