/////////////////////////////////////////////////////////////////////////////
//
//  Enchanted Forest
//  WYSE (c) 2014
//  All rights reserved
//
/////////////////////////////////////////////////////////////////////////////

package {
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getDefinitionByName;

    /**
     * Application loader. It loaded in first frame before all game and show
     * 1. SWF loading progress
     * 2. Game data loading
     * 3. Player data loading
     * 4. Level rendering
     *
     * Application loading complete when all three phase completed. Each phase
     * completeness set it own flag isAnimationComplete, isLoaded,
     * isInitialized.
     *
     * Animation phase can be omitted if <code>waitingForInvestorLogo</code>
     * flag is false.
     *
     * @author Alexey Kolonitsky <alexey@kolonitsky.org>
     */
    public class MainPreloader extends MovieClip {
        [Embed(source="../assets/wg_umerki_cl.ttf",
                fontName="preloaderFont",
                mimeType="application/x-font",
                fontWeight="bold",
                fontStyle="normal",
                unicodeRange="U+0025,U+0030-U+0039,U+002E",
                advancedAntiAliasing="true",
                embedAsCFF="false")]
        private var PreloaderFontClass:Class;

        public static const PART_COUNT:uint = 2;

        //-----------------------------
        // Preloader errors
        //-----------------------------

        public static const ERROR_APP_LOADED:String = "Main class must have 'applicationLoaded' method invoked after loading complete";
        public static const ERROR_APP_STARTUP:String = "Main class must have 'startup' method. Startup method invoked when all AS3 code loaded, to start MVC initialization, loading of necessary assets and authenticate user.";
        public static const ERROR_UNEXPECTED_PART:String = "Out of the range. Part index can be > 0 and < " + PART_COUNT;
        public static const ERROR_LOADING_INTERMINATE:String = "User left page before game loaded.";

        public var setProgress:Function = function (value:Number):void {
            trace("INFO: Object setProgress ");
            showPercent(1, value);
        };

        //-----------------------------
        // Initialization parts
        //-----------------------------

        public static const INIT_APP_LOADED:int = 1;
        public static const INIT_STATIC_CONFIG:int = 2;
        public static const INIT_DYNAMIC_CONFIG:int = 3;
        public static const INIT_L10N_CONFIG:int = 4;
        public static const INIT_ASSETS:int = 5;
        public static const INIT_ATHENTICATED:int = 6;
        public static const INIT_ESTABLISH_CONNECTION:int = 7;
        public static const INIT_CITY_LOADED:int = 8;
        public static const INIT_BUILDING_MODELS_LOADED:int = 9;

        //-----------------------------
        // Constructor
        //-----------------------------

        public function MainPreloader() {
            MainPreloader._instance = this;
            stop();

            loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderInfo_ioErrorHandler);
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, loaderInfo_uncaughtErrorHandler);

            partPercent = new Vector.<Number>(PART_COUNT, true);

            _view = new PreloaderGFX();
            var tf:TextField = _view.txt_progress;

            var format:TextFormat = tf.defaultTextFormat;
            format.font = "preloaderFont";
            format.size = 36;

            tf.defaultTextFormat = format;
            tf.antiAliasType = AntiAliasType.ADVANCED;
            tf.embedFonts = true;
            tf.selectable = false;
            tf.wordWrap = false;
            addChild(_view);

            var params:Object = loaderInfo.parameters;

            var preloaderFileName:String = "preloader_patrick_en.png";
            if ("preloader_image" in params && "locale" in params)
                preloaderFileName = params.preloader_image + "_" + params.locale + ".jpg";

            var urlArray:Array = loaderInfo.url.split("/");
            urlArray.pop();
            urlArray.push("assets", "icons", preloaderFileName);

            var s:String = urlArray.join("/");

            var iconLoader:Loader = new Loader();
            iconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIconLFail);
            iconLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onIconLFail);
            iconLoader.load(new URLRequest(s), new LoaderContext(true));

            _view.image.addChild(iconLoader);

            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            showPercent(0, 0);
        }

        private function onIconLFail(event:IOErrorEvent):void {
            trace("ApplicationPreloader: " + event.toString());
        }

        private function addedToStageHandler(event:Event):void {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.showDefaultContextMenu = false;
            _view.x = (stage.stageWidth - _view.width) / 2;

        }

        /**
         * Show percent in preloader screen.
         *
         * @param partIndex
         * @param percent
         */
        public static function showPercent(partIndex:int, percent:Number):void {
            if (_view && _view.stage)
                _view.x = (_view.stage.stageWidth - _view.width) / 2;

            if (partIndex < 0 || partIndex >= PART_COUNT)
                throw new RangeError(ERROR_UNEXPECTED_PART);

            percent = percent > 0.93 ? 1.0 : percent;
            percent = percent <= 0 ? 0 : percent;
            partPercent[partIndex] = percent;
            updateDisplayPercent();
        }

        /**
         * Put error message on the preloader screen.
         * @param message
         */
        public function showErrorMessage(message:String):void {
            trace("WARNING: ApplicationPreloader showErrorMessage message = " + message);
        }

        //-------------------------------------------------------------------
        //
        //  Private
        //
        //-------------------------------------------------------------------

        /** Reference to application */
        private var app:Object = null;

        /** Elapsed persent of each loading part */
        private static var partPercent:Vector.<Number>;

        /** Complete loading indicator */
        private var isLoaded:Boolean = false;

        /** Complete init indicator */
        private var isInitialized:Boolean = false;

        private static var _view:MovieClip;

        private static var _instance:MainPreloader;

        private function loadingComplete():void {
            if (isLoaded)
                return;

            isLoaded = true;
            nextFrame();
            var mainClass:Class = getDefinitionByName("Main") as Class;
            if (mainClass) {
                app = new mainClass();
                app.visible = false;
                app.flashVars = loaderInfo.parameters;
                app.setProgress = setProgress;

                stage.addChildAt(app as DisplayObject, 0);
            }
        }

        private function initializeComplete():void {
            isInitialized = true;
            showApplication();
        }

        private function showApplication():void {
            if (!isLoaded)
                return;

            // Hide preloader and show application
            if (_view.parent) {
                removeChild(_view);
            }

            app.visible = true;
            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

            if ("applicationLoaded" in app)
                app.applicationLoaded(this);
            else
                trace(ERROR_APP_LOADED, this);
        }

        /**
         * Update value in splash screen's percent label
         */
        private static function updateDisplayPercent():void {
            var totalPercent:Number = 0.0;
            for (var i:int = 0; i < PART_COUNT; i++)
                totalPercent += partPercent[i];

            totalPercent /= PART_COUNT;

//            if (totalPercent == 1.0)
//            {
//                initializeComplete();
//            }
//            else
//            {
            var strPercent:String = totalPercent <= 0.01 ? "" : Math.floor(totalPercent * 100) + "%";
            _view.txt_progress.text = strPercent;
            //_view.mcProgress1.mcProgress2.gotoAndStop(int(totalPercent * 149));
//            }
            if (totalPercent == 1.0)
                _instance.showApplication();
        }

        //-------------------------------------------------------------------
        // Event handlers
        //-------------------------------------------------------------------

        private function enterFrameHandler(event:Event):void {
            if (framesLoaded == totalFrames)
                loadingComplete();

            var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
            showPercent(0, percent);
        }

        private function loaderInfo_ioErrorHandler(event:IOErrorEvent):void {
            trace(ERROR_LOADING_INTERMINATE, this);
        }

        private function loaderInfo_uncaughtErrorHandler(event:UncaughtErrorEvent):void {
            trace(event, this);
        }

    }
}
