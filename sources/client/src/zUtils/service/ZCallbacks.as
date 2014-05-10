package zUtils.service {
    /**
     * Date   :  03.11.13
     * Time   :  23:52
     * author :  Vitaliy Snitko
     * mail   :  zaidite@gmail.com
     *
     * class description    : Is a collection of callbacks. Can replace events.
     * class responsibility : Register callbacks. Running all callbacks.
     */
    public class ZCallbacks {
        // --- PRIVATE VAR ------------------------------------ //
        private var _callbacks:Object = {};

        //*********************** CONSTRUCTOR ***********************
        public function ZCallbacks() {
        }

        //***********************************************************

        // --- PRIVATE FUNCTION ------------------------------- //

        private function removeCallbacks(callbacks:Vector.<Item>):void {
            var hash:String;
            var len:int = callbacks.length;
            for(var i:int = 0; i < len; i++) {
                hash = callbacks[i].hash;
                callbacks[i].clear();
                delete _callbacks[hash];
            }
        }

        // --- PUBLIC FUNCTION -------------------------------- //

        /**
         * Add callback to stack
         * @param callback
         * @param once
         * @param args
         * @return - callback hash
         */
        public function addCallback(callback:Function, once:Boolean = false, ...args):String {
            var item:Item = new Item(callback, once, args as Array);
            _callbacks[item.hash] = item;
            return item.hash;
        }

        /**
         * Activation all callbacks
         */
        public function resolve():void {
            var onceItems:Vector.<Item> = new Vector.<Item>();

            for each (var item:Item in _callbacks) {
                item.callback.apply(this, item.params);

                if(item.once)onceItems.push(item);
            }

            removeCallbacks(onceItems);
        }

        /**
         * Set or change callbacks params
         * @param callbackId
         * @param args
         */
        public function setParamForCallback(callbackId:String, ...args):void {
            if(!_callbacks[callbackId]) {
                throw new Error('[ZCallbacks] setParamForCallback() : Error !!! Callback missing !!!');
            }

            var callback:Item = _callbacks[callbackId];
            callback.params = args as Array;
        }

        /**
         * Remove all callbacks
         */
        public function clearCallbacks():void {
            var onceItems:Vector.<Item> = new Vector.<Item>();

            for each (var item:Item in _callbacks) {
                if(item.once)onceItems.push(item.hash);
            }

            removeCallbacks(onceItems);
        }

        /**
         * Remove all data before remove object
         */
        public function clear():void {
            var onceItems:Vector.<Item> = new Vector.<Item>();

            for each (var item:Item in _callbacks) {
                if(item.once)onceItems.push(item.hash);
            }

            removeCallbacks(onceItems);

            _callbacks = null;
        }

    } //end class
}//end package

class Item {
    // --- PUBLIC VAR ------------------------------------ //
    public var callback:Function;
    public var params:Array;
    public var hash:String;
    public var once:Boolean;

    //*********************** CONSTRUCTOR ***********************
    public function Item(callback:Function, once:Boolean, params:Array = null) {
        this.callback = callback;
        this.params = params;
        this.once = once;
        hash = getHash();
    }

    //***********************************************************

    // --- PRIVATE FUNCTION ------------------------------------ //
    private function getHash(hashLength:int = 10):String {
        var symbols:String = '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
        var symbolsLength:int = symbols.length;
        var hash:String = '';
        var rand:int;

        for(var i:int = 0; i < hashLength; i++) {
            rand = Math.floor(Math.random() * (symbolsLength - 1)) + 1;
            hash += symbols.charAt(rand);
        }
        return hash;
    }

    // --- PUBLIC FUNCTION ------------------------------------ //
    public function clear():void {
        callback = null;
        params = null;
        hash = null;
        once = false;
    }
}