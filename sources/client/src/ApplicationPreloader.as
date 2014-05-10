/////////////////////////////////////////////////////////////////////////////
//
//  Enchanted Forest
//  WYSE (c) 2014
//  All rights reserved
//
/////////////////////////////////////////////////////////////////////////////

package
{
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    import flash.system.Capabilities;
    import flash.system.LoaderContext;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getDefinitionByName;

    /**
     * Application loader. This class embeded in first frame before all game
     * and display loadeing percent. It is first preporation before game
     * initialization starts.
     *
     * Loading progress divided to equal parts. Each part save self progress
     * from 0.0 to 1.0. Zero part is source code loading. Other parts progress
     * updated by application.
     *
     * Use <code>setProgress(partIndex, percent)</code> to update each part
     * progress.
     *
     * Enchanted Forest has follow loading pars.
     * 1. SWF loading progress
     * 2. Game data loading
     * 3. Player data loading
     * 4. Level rendering
     *
     * @author Alexey Kolonitsky <alexey@kolonitsky.org>
     */
    public class ApplicationPreloader extends MovieClip
    {
        public static const BACKGROUND_IMAGE_WIDTH:int = 760;
        public static const BACKGROUND_IMAGE_HEIGHT:int = 670;

        /**
         * Setting constant with total number of loaded parts
         */
        public static var PART_COUNT:uint = 4;


        //-----------------------------
        // Preloader errors
        //-----------------------------

        public static const ERROR_UNEXPECTED_PART_INDEX:String = "Out of the range. Part index can be great then 1 and less then " + PART_COUNT;
        public static const ERROR_LOADING_INTERMINATE:String = "User left page before game loaded.";

        /**
         * Easy way to update preloader progress from any application part.
         *
         * @param partIndex
         * @param value
         */
        public static function setProgress (partIndex:int, value:Number):void
        {
            if (partIndex < 1 || partIndex >= PART_COUNT)
            {
                trace(ERROR_UNEXPECTED_PART_INDEX);
                return;
            }

            _instance.showPercent(partIndex, value);
        }



        /**
         * Update value in splash screen's percent label
         */
        public function get totalLoadedPercent():Number
        {
            var result:Number = 0.0;
            for (var i:int = 0; i < PART_COUNT; i++)
                result += partPercent[i];

            result /= PART_COUNT;
            return result;
        }

        //-----------------------------
        // Constructor
        //-----------------------------

        public function ApplicationPreloader()
        {
            if (_instance != null)
                trace("WARNING: ApplicationPreloader created twice");

            _instance = this;

            stop();

            loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderInfo_ioErrorHandler);
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, errorHandler);

            background = new Sprite();
            addChild(background);

            _view = new PreloaderGFX();

            var format:TextFormat = _view.txt_progress.defaultTextFormat;
            format.font = "preloaderFont";
            format.size = 36;

            var tf:TextField = _view.txt_progress;
            tf.defaultTextFormat = format;
            tf.antiAliasType = AntiAliasType.ADVANCED;
            tf.embedFonts = true;
            tf.selectable = false;
            tf.wordWrap = false;
            addChild(_view);

            var params:Object = loaderInfo.parameters;
            var locale:String = "ru";
            if ("locale" in params)
                locale = params["locale"];

            var preloaderFileName:String = "preloader_ru.jpg";
            if ("preloader_image" in params)
                preloaderFileName = params.preloader_image + "_" + locale + ".jpg";

            firstLoading = false;
            if ("new_user" in params)
                firstLoading = params["new_user"] == "true";
            firstLoading = false;

            if (firstLoading)
            {
                PART_COUNT = 5;
                preloaderFileName = "preloader_comics_" + locale + ".swf";
                backgroundColor = 0x12192B;
            }

            var urlArray:Array = loaderInfo.url.split("/");
            urlArray.pop();
            urlArray.push("assets", "icons", preloaderFileName);

            var s:String = urlArray.join("/");

            var backgroundLoader:Loader = new Loader();
            backgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, backgroundLoader_completeHandler);
            backgroundLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            backgroundLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
            backgroundLoader.load(new URLRequest(s), new LoaderContext(true));

            partPercent = new Vector.<Number>(PART_COUNT, true);

            if (stage)
            {
                stage.scaleMode = "noScale";
                stage.align = "TL";
            }

            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }

        private var firstLoading:Boolean = false;



        //-------------------------------------------------------------------
        //
        //  Private
        //
        //-------------------------------------------------------------------

        [Embed(source="../assets/wg_umerki_cl.ttf",
            fontName = "preloaderFont",
            mimeType = "application/x-font",
            fontWeight="bold",
            fontStyle="normal",
            unicodeRange="U+0025,U+0030-U+0039,U+002E",
            advancedAntiAliasing="true",
            embedAsCFF="false")]
        private static var PreloaderFontClass:Class;

        private static var _instance:ApplicationPreloader;

        /** */
        private var backgroundColor:uint = 0x003333;

        /** */
        private var backgroundContent:DisplayObject;

        /** Reference to application */
        private var app:Object = null;

        /** Elapsed persent of each loading part */
        private var partPercent:Vector.<Number>;

        /** Complete loading indicator */
        private var isLoaded:Boolean = false;

        /** Graphics */
        private var _view:MovieClip;

        private var background:Sprite;

        /**
         * Show percent in preloader screen.
         *
         * @param partIndex
         * @param percent
         */
        private function showPercent(partIndex:int, percent:Number):void
        {
            if (partIndex < 0 || partIndex >= PART_COUNT)
                throw new RangeError(ERROR_UNEXPECTED_PART_INDEX);

            percent = percent > 0.93 ? 1.0 : percent;
            percent = percent <= 0 ? 0 : percent;
            partPercent[partIndex] = percent;

            var total:Number = totalLoadedPercent;

            if (background && stage)
            {
                background.graphics.beginFill(backgroundColor);
                background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            }

            if (_view && stage)
            {
                // background image size not measured. Because comics size can
                // be unpredictable.
                _view.x = (stage.stageWidth - BACKGROUND_IMAGE_WIDTH) >> 1;
                _view.y = (stage.stageHeight - BACKGROUND_IMAGE_HEIGHT) >> 1;
                _view.txt_progress.text = total <= 0.01 ? "" : Math.floor(total * 100) + "%";
            }

            if (total == 1.0) // Condition to finish loading
                showApplication();
            else if (total == 0.8 && firstLoading)
                showApplication();
        }

        private function loadingComplete():void
        {
            if (isLoaded)
                return;

            isLoaded = true;
            nextFrame();
            var mainClass:Class = getDefinitionByName("Game") as Class;
            if(mainClass)
            {
                app = new mainClass();
                app.visible = false;
//                app.flashVars = loaderInfo.parameters;
                app.loaderInfo.parameters = loaderInfo.parameters;

                stage.addChildAt(app as DisplayObject, 0);
            }
        }

        private function showApplication():void
        {
            if (!isLoaded)
                return;

            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

            if (backgroundContent is MovieClip)
            {
                (backgroundContent as MovieClip).gotoAndStop(2);

                var mc:MovieClip = (backgroundContent as MovieClip).getChildAt(0) as MovieClip;
                mc.addFrameScript(mc.totalFrames - 1, removePreloader);
                mc.addEventListener(Event.ENTER_FRAME, mc_enterFrameHandler);
                mc.play();
            }
            else
            {
                removePreloader();
            }
        }

        private function mc_enterFrameHandler(event:Event):void
        {
            var mc:MovieClip = event.currentTarget as MovieClip;
            showPercent(4, mc.currentFrame / mc.totalFrames);
        }

        private function removePreloader():void
        {
            if (backgroundContent is MovieClip)
            {
                var mc:MovieClip = (backgroundContent as MovieClip).getChildAt(0) as MovieClip;
                mc.addFrameScript(mc.totalFrames - 1, null);
                mc.stop();
            }

            // Hide preloader and show application
            if(_view.parent)
                removeChild(_view);

            if (background.parent)
                removeChild(background);

            app.visible = true;
        }


        //-------------------------------------------------------------------
        // Event handlers
        //-------------------------------------------------------------------

        private function enterFrameHandler(event:Event):void
        {
            if(framesLoaded == totalFrames)
                loadingComplete();

            var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
            showPercent(0, percent);
        }

        private function backgroundLoader_completeHandler(event:Event):void
        {
            var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
            var type:String = loaderInfo.contentType;
            backgroundContent = loaderInfo.content;

            switch (type)
            {
                case "application/x-shockwave-flash":
                    (backgroundContent as MovieClip).gotoAndStop(0);
                    var mc:MovieClip = (backgroundContent as MovieClip).getChildAt(0) as MovieClip;
                    mc.play();
                    backgroundColor = 0x12192B;
                    break;

                default:
                    backgroundColor = 0x003333;
                    break;
            }

            while (_view.image.numChildren)
                _view.image.removeChildAt(0);

            _view.image.addChild(backgroundContent);
        }

        private function addedToStageHandler(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            stage.scaleMode = "noScale";
            stage.align = "TL";
        }

        private function errorHandler(event:ErrorEvent):void
        {
            trace("ERROR: ApplicationPreloader:", event.toString());
        }

        private function loaderInfo_ioErrorHandler(event:IOErrorEvent):void
        {
            trace("ERROR:", ERROR_LOADING_INTERMINATE, this);
        }

    }
}
