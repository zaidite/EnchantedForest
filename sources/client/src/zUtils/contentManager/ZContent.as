package zUtils.contentManager {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.LoaderInfo;
    import flash.display.MovieClip;
    import flash.media.Sound;

    //TODO добавить кеширование

    /**
     * Date   : 30.04.2014
     * Time   : 10:43
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    : Content manager. Wrapper for BulkLoader.
     * responsibility : Make and prepares content items - objects of ZContentItem. Loads the content and manages it.
     */
    public class ZContent {
        private var _contentItems:Object = {};

        private static var _instance:ZContent;

        private const NOT_READY:String = 'Content not ready.';
        private const NOTHING_TO_RETURN:String = 'Nothing to return. ';

        //*********************** CONSTRUCTOR ***********************
        public function ZContent(secure:PrivateClass) {
        }

        //***********************************************************

        private function _validateContentItem(content:ZContentItem):Boolean {
            if (content.state != ZContentItem.LOAD_COMPLETE) {
                trace('[ZContent] :', '_validateContentItem();  ', content.url, content.state);
                return false;
            }
            return true;
        }

        private function _getAllLoadersInfo():Vector.<LoaderInfo> {
            var loaders:Vector.<LoaderInfo> = new Vector.<LoaderInfo>();

            for each (var contentItem:ZContentItem in _contentItems) {

                if (contentItem.loaderInfo) {
                    loaders.push(contentItem.loaderInfo);
                }
            }
            return loaders;
        }

        /**
         * Create and return new ZContentItem
         * @param url - url for load.
         * @param callbackComplete - Callback will activate when load is end. In callback will transferred current ZContentItem.
         * @param callbackError - Callback will activate when loading error. In callback will transferred object ErrorEvent.
         * @return
         */
        public function makeContentItem(url:String, callbackComplete:Function = null, callbackError:Function = null):ZContentItem {
            if (!url || url == '') {
                trace('[ZContent] :', 'newContentItem();  Url missing...');
                return null;
            }

            var item:ZContentItem = new ZContentItem(url, callbackComplete, callbackError);
            _contentItems[url] = item;
            return item;
        }

        /**
         * Return object of ZContentItem.
         * @param url - url download address of content ZContentItem.
         * @return
         */
        public function getContentItem(url:String):ZContentItem {
            return _contentItems[url];
        }

        /**
         * Will remove object of ZContentItem.
         * @param url - url download address of content ZContentItem.
         */
        public function removeContentItem(url:String):void {
            var item:ZContentItem = _contentItems[url];

            if (item) {
                item.clear();
                delete _contentItems[url];
            }
        }

        /**
         * Make validation ready download and start load item.
         * @param contentItem
         */
        public function loadItem(contentItem:ZContentItem):void {

            if (!contentItem.isReadyToLoad()) {
                trace('[ZContent] :', 'loadItem();  ', 'ContentItem not ready to Load');
                return;
            }

            contentItem.startLoad();
        }

        /**
         * Clear of all data
         */
        public function clearData():void {
            _instance = null;

            for each (var item:ZContentItem in arguments) {
                item.clear();
                item = null;
            }
        }

        // --- GETTING DATA ------------------------------------ //

        /**
         * Searches for the specified MovieClip in all loaded libraries and return him.
         * @param targetLinkName - Assigned class of MovieClip in library.
         * @return
         */
        public function getMovieClipFromLibs(targetLinkName:String):MovieClip {
            var target:MovieClip;
            var loaders:Vector.<LoaderInfo> = _getAllLoadersInfo();

            target = ZContentFinder.getMovieClip(targetLinkName, loaders);

            return target;
        }

        /**
         * Searches for the specified Bitmap in all loaded libraries and return him.
         * @param targetLinkName - Assigned class of Bitmap in library.
         * @return
         */
        public function getBitmapFromLibs(targetLinkName:String):Bitmap {
            var target:Bitmap;
            var loaders:Vector.<LoaderInfo> = _getAllLoadersInfo();

            target = ZContentFinder.getBitmap(targetLinkName, loaders);

            return target;
        }

        /**
         * Searches for the specified Sound in all loaded libraries and return him.
         * @param targetLinkName - Assigned class of Sound in library.
         * @return
         */
        public function getSoundFromLibs(targetLinkName:String):Sound {
            var target:Sound;
            var loaders:Vector.<LoaderInfo> = _getAllLoadersInfo();

            target = ZContentFinder.getSound(targetLinkName, loaders);

            return target;
        }

        /**
         * Return MovieClip from loaded ZContentItem.
         * @param contentItem
         * @return
         */
        public function getMovieClipFrom(contentItem:ZContentItem):MovieClip {
            if (!_validateContentItem(contentItem)) {
                trace('[ZContent] :', 'getMovieClipFrom(); ', NOT_READY, contentItem.url);
            }

            var mc:MovieClip = contentItem.loader.getMovieClip(contentItem.url);

            if (!mc) {
                trace('[Content] :', 'getMovieClipFrom();  ', NOTHING_TO_RETURN, contentItem.url);
            }

            return mc;
        }

        /**
         * Will return BitmapData from loaded contentItem
         * @param contentItem
         * @return
         */
        public function getBitmapDataFrom(contentItem:ZContentItem):BitmapData {
            if (!_validateContentItem(contentItem)) {
                trace('[ZContent] :', 'getBitmapDataFrom(); ', NOT_READY, contentItem.url);
            }

            var bmd:BitmapData = contentItem.loader.getBitmapData(contentItem.url);

            if (!bmd) {
                trace('[Content] :', 'getBitmapDataFrom();  ', NOTHING_TO_RETURN, contentItem.url);
            }

            return bmd;
        }

        /**
         * Will return Bitmap from loaded contentItem
         * @param contentItem
         * @return
         */
        public function getBitmapFrom(contentItem:ZContentItem):Bitmap {

            if (!_validateContentItem(contentItem)) {
                trace('[ZContent] :', 'getBitmapFrom(); ', NOT_READY, contentItem.url);
            }

            var bitmap:Bitmap = contentItem.loader.getBitmap(contentItem.url);

            if (!bitmap) {
                trace('[Content] :', 'getBitmapFrom();  ', NOTHING_TO_RETURN, contentItem.url);
            }

            return bitmap;
        }

        /**
         * Will return Bitmap from loaded contentItem
         * @param contentItem
         * @return
         */
        public function getSoundFrom(contentItem:ZContentItem):Sound {

            if (!_validateContentItem(contentItem)) {
                trace('[ZContent] :', 'getSoundFrom(); ', NOT_READY, contentItem.url);
            }

            var sound:Sound = contentItem.loader.getSound(contentItem.url);

            if (!sound) {
                trace('[Content] :', 'getSoundFrom();  ', NOTHING_TO_RETURN, contentItem.url);
            }

            return sound;
        }

        /**
         * Will return getXMLFrom from loaded contentItem
         * @param contentItem
         * @return
         */
        public function getXMLFrom(contentItem:ZContentItem):XML {

            if (!_validateContentItem(contentItem)) {
                trace('[ZContent] :', 'getXML(); ', NOT_READY, contentItem.url);
            }

            var xml:XML = contentItem.loader.getXML(contentItem.url);

            if (!xml) {
                trace('[Content] :', 'getXML();  ', NOTHING_TO_RETURN, contentItem.url);
            }

            return xml;
        }

        /**
         * Will return Object from loaded contentItem
         * @param contentItem
         * @return
         */
        public function getDataFromJSONFrom(contentItem:ZContentItem):Object {

            if (!_validateContentItem(contentItem)) {
                trace('[ZContent] :', 'getDataFromJSON(); ', NOT_READY, contentItem.url);
            }

            var xml:XML = contentItem.loader.getXML(contentItem.url);
            var data:String = contentItem.loader.getText(contentItem.url);

            if (!xml) {
                trace('[Content] :', 'getDataFromJSON();  ', NOTHING_TO_RETURN, contentItem.url);
            }

            return JSON.parse(data);
        }

        /**
         * Will return String from loaded contentItem
         * @param contentItem
         * @return
         */
        public function getText(contentItem:ZContentItem):String {

            if (!_validateContentItem(contentItem)) {
                trace('[ZContent] :', 'getText(); ', NOT_READY, contentItem.url);
            }

            var data:String = contentItem.loader.getText(contentItem.url);

            if (!data) {
                trace('[Content] :', 'getText();  ', NOTHING_TO_RETURN, contentItem.url);
            }

            return data;
        }

        /**
         * Singleton item
         * @return
         */
        public static function manager():ZContent {
            if (!_instance) {
                ZContent._instance = new ZContent(new PrivateClass());
            }
            return _instance;
        }

    } //end class
}//end package

class PrivateClass {
    public function PrivateClass():void {}
}