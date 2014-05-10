package zUtils.contentManager {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.LoaderInfo;
    import flash.display.MovieClip;
    import flash.media.Sound;

    /**
     * Date   : 30.04.2014
     * Time   : 17:55
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    :
     * responsibility :
     */
    public class ZContentFinder {

        public static function getMovieClip(className:String, libsData:Vector.<LoaderInfo>):MovieClip {
            var target:MovieClip;
            var loaderInfo:LoaderInfo;
            var clipClass:Class;

            if (!_paramsIsValid(className, libsData)) {
                return null;
            }

            var len:int = libsData.length;
            for (var i:int = 0; i < len; i++) {

                loaderInfo = libsData[i];

                try {
                    clipClass = loaderInfo.applicationDomain.getDefinition(className) as Class;
                } catch (e:Error) {
                } finally {
                    if (clipClass) {
                        var objClass:* = new clipClass();
                        if (objClass is MovieClip) {
                            target = objClass;
                        }
                    }
                }
            }
            return target;
        }

        public static function getBitmap(className:String, libsData:Vector.<LoaderInfo>):Bitmap {

            var target:Bitmap;
            var loaderInfo:LoaderInfo;
            var clipClass:Class;

            if (!_paramsIsValid(className, libsData)) {
                return null;
            }

            var len:int = libsData.length;
            for (var i:int = 0; i < len; i++) {

                loaderInfo = libsData[i];

                try {
                    clipClass = loaderInfo.applicationDomain.getDefinition(className) as Class;
                } catch (e:Error) {
                } finally {
                    if (clipClass) {
                        var objClass:* = new clipClass();
                        if (objClass is BitmapData) {
                            target = new Bitmap(objClass as BitmapData);
                        }
                    }
                }
            }
            return target;
        }

        public static function getSound(className:String, libsData:Vector.<LoaderInfo>):Sound {
            var target:Sound;
            var loaderInfo:LoaderInfo;
            var clipClass:Class;

            if (!_paramsIsValid(className, libsData)) {
                return null;
            }

            var len:int = libsData.length;
            for (var i:int = 0; i < len; i++) {

                loaderInfo = libsData[i];

                try {
                    clipClass = loaderInfo.applicationDomain.getDefinition(className) as Class;
                } catch (e:Error) {
                } finally {
                    if (clipClass) {
                        var objClass:* = new clipClass();
                        if (objClass is Sound) {
                            target = objClass;
                        }
                    }
                }
            }
            return target;
        }

        private static function _paramsIsValid(className:String, libsData:Vector.<LoaderInfo>):Boolean {
            if (!className || className == '') {
                trace('[ZContentFinder] _paramsIsValid() : ClassName not valid.');
                return false;
            }

            if (!libsData || !libsData.length) {
                trace('[ZContentFinder] _paramsIsValid() : libsData not valid.');
                return false;
            }
            return true;
        }
    } //end class
}//end package