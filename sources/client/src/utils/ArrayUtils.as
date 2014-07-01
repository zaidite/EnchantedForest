package utils {
    public final class ArrayUtils {

        /**
         * Add one array to another. Like Array.concat, but without generating new array instances.
         *
         * @param arr1
         * @param arr2
         * @return arr1
         */
        public static function add (arr1:Array, arr2:Array):Array {
            for each (var i:* in arr2) {
                arr1.push(i);
            }
            return arr1;
        }

        /**
         * Append something to arr and return arr. Similar to Array.push, but returns array. Useful for chaining.
         *
         * @param arr
         * @param args Values to append to arr.
         * @return arr
         */
        public static function append (arr:Array, ...args):Array {
            return add(arr, args);
        }

        /**
         * Finds the place for the new element in sorted array using binary
         * search algorithm.
         *
         * @param array - Array or vector where to find.
         * @param func - Sort function
         * @param el - element to find a place for.
         * @return index where el should be placed.
         */
        public static function search (array:*, func:Function, el:*):int {
            var length:int = array.length;
            if (length == 0) {
                return 0;
            }

            var cmp:int = func.call(null, el, array[length - 1]);
            if (cmp > 0) {
                return length;
            }

            var i:int = 0;
            var j:int = length;
            while (i + 1 < j) {
                var middle:int = int(i + (j - i) / 2);
                cmp = func.call(null, el, array[middle]);
                if (cmp < 0) {
                    j = middle;
                }
                else {
                    i = middle;
                }
            }
            if (func.call(null, el, array[i]) < 0) {
                return i;
            }
            return j;
        }


        /**
         * Apply callback to each element in the iterable. Iterable can be array vector or dynamic object.
         * Callback can be Function or String. If callback is String, then
         * method will try to find field in the array element and call it.
         *
         * @param iterable
         * @param callback Function or method name.
         * @param thisArg
         * @param args
         * @return new Array instance containing results for each callback.
         */
        public static function map (iterable:*, callback:*, thisArg:* = null, ...args):Array {
            var re:Array = [];
            var v:*;
            if (callback is Function) {
                for each (v in iterable) {
                    re.push(callback.apply(thisArg, add([v], args)));
                }
            } else if (callback is String) {
                for each (v in iterable) {
                    re.push((v[callback] as Function).apply(thisArg, args));
                }
            } else {
                return ArrayUtils.add(re, iterable);
            }
            return re;
        }

        /**
         * Apply callback to each element in the iterable. Iterable can be array vector or dynamic object.
         * Callback can be Function or String. If callback is String, then
         * method will try to find field in the array element and call it.
         *
         * @param iterable
         * @param callback Function or method name.
         * @param thisArg
         * @param args
         */
        public static function forEach (iterable:*, callback:*, thisArg:* = null, ...args):void {
            var v:*;
            if (callback is Function) {
                for each (v in iterable) {
                    callback.apply(thisArg, add([v], args));
                }
            } else if (callback is String) {
                for each (v in iterable) {
                    (v[callback] as Function).apply(thisArg, args);
                }
            }
        }


        /**
         * Filter array elements with callback. Callback can be Function or String.
         *
         * @param array
         * @param callback
         * @param thisArg
         * @param args
         * @return
         */
        public static function filter (array:Array, callback:*, thisArg:* = null, ...args):Array {
            var re:Array = [];
            for each (var v:* in array) {
                var filtered:*;
                if (callback is String) {
                    filtered = (v[callback] as Function).apply(thisArg || v, args);
                } else {
                    var argsArray:Array = [v].concat(args);
                    filtered = (callback as Function).apply(thisArg, argsArray);
                }
                if (filtered) {
                    re.push(v);
                }
            }
            return re;
        }

        /**
         * Check if value exists in array.
         *
         * @param array
         * @param value
         * @return true if value is found.
         */
        public static function isExists (array:Array, value:*):Boolean {
            return array.indexOf(value) != -1;
        }

        /**
         * Checks, if there is element, or element with defined property in array.
         *
         * @param array Array or Vector
         * @param value
         * @param propName
         * @return
         */
        public static function checkEntry (array:*, value:*, propName:String = null):Boolean {
            var tempLen:int = array.length;
            if (!tempLen) {
                return false;
            }

            for (var i:int = 0; i < tempLen; i++) {
                if (propName === null) {
                    if (array[i] == value) {
                        return true;
                    }
                } else {
                    if (array[i] && array[i][propName] == value) {
                        return true;
                    }
                }
            }
            return false;
        }


        /**
         * Fisher–Yates shuffle.
         *
         * @param array array to shuffle
         * @param returnCopy if false will shuffle input array, otherwise will shuffle copy.
         * @return
         */
        public static function shuffle (array:Array, returnCopy:Boolean = false):Array {
            if (!array) {
                return null;
            }
            var res:Array = returnCopy ? array.concat() : array;
            var len:int = array.length - 1;
            var index:int;
            var temp:Object;

            for (var i:int = len; i > 0; i--) {
                index = int(Math.random() * (i + 1));
                if (i == index) {
                    continue;
                }
                temp = res[index];
                res[index] = res[i];
                res[i] = temp;
            }

            return res;
        }


        public static function getRandomEntries (source:Array, entriesCount:int = 10, removeFromSource:Boolean = false):Array {
            if (!source || !source.length) {
                return [];
            }
            if (source.length == 1) {
                return source.concat();
            }
            if (source.length < entriesCount) {
                entriesCount = source.length;
            }

            var tempArr:Array = [];
            var tempValue:*;
            var tempIndex:int;

            while (tempArr.length < entriesCount) {
                tempIndex = Math.random() * source.length;
                tempValue = source[tempIndex];
                if (!ArrayUtils.isExists(tempArr, tempValue)) {
                    tempArr.push(tempValue);
                    if (removeFromSource) {
                        source.splice(tempIndex, 1);
                    }
                }
            }
            return tempArr;
        }


        public static function getRandomEntry (array:Array, removeFromSource:Boolean = false):* {
            if (!array.length) {
                return null;
            }
            var index:int = Math.random() * array.length;
            var value:* = array[index];
            if (removeFromSource) {
                array.splice(index, 1);
            }
            return value;
        }


        public static function getEntriesByProperty (array:*, propName:String, propValue:*, removeFromSource:Boolean = false):Array {
            var temp:Array = [];
            for (var i:int = array.length - 1; i >= 0; i--) {
                if (array[i] != null && array[i].hasOwnProperty(propName) && array[i][propName] == propValue) {
                    temp.push(array[i]);
                    if (removeFromSource) {
                        array.splice(i, 1);
                    }
                }
            }
            return temp;
        }


        public static function getEntryByProperty (array:*, propName:String, propValue:*, removeFromSource:Boolean = false):* {
            for (var i:int = array.length - 1; i >= 0; i--) {
                if (array[i] != null && array[i].hasOwnProperty(propName) && array[i][propName] == propValue) {
                    if (removeFromSource) {
                        return array.splice(i, 1)[0];
                    }
                    return array[i];
                }
            }
            return null;
        }

        /**
         *
         *
         * @param array Target Array or Vector.
         * @param value Value to remove.
         * @return Is value was removed or not.
         */
        public static function removeEntry (array:*, value:*):Boolean {
            var len:int = array.length;
            for (var i:int = 0; i < len; i++) {
                if (array[i] == value) {
                    array.splice(i, 1);
                    return true;
                }
            }
            return false;
        }

        /**
         * Return true if all values in both arrays are equal.
         *
         * @param first
         * @param second
         * @return
         */
        public static function equals (first:Array, second:Array):Boolean {
            if (first == second) {
                return true;
            } else {
                var len:int = first.length;
                for (var i:int = 0; i < len; i++) {
                    if (first[i] !== second[i]) {
                        return false;
                    }
                }
                return true;
            }
        }

        /**
         * Sort array on entry, with function or just sort and return it.
         */
        public static function sort (array:Array, ...args):Array {
            var firstArg:* = args[0];
            if (firstArg is String || firstArg is Array) {
                array.sortOn.apply(null, args);
            } else {
                array.sort.apply(null, args);
            }
            return array;
        }

        /**
         * Map FunctionUtils.field function to all values in the array.
         * @param array
         * @param field Field name
         * @return new Array with field value.
         */
        /*public static function pluck (array:Array, field:String):Array {
            return map(array, FunctionUtils.partial(FunctionUtils.field, field));
        }*/

        private static function _convertToString (obj:Object, deep:Boolean):String {
            return obj.toString();
        }


        public static function repr (arr:Array, deep:Boolean = false):String {
            var mapper:*;
            var mapped:Array;
            if (deep) {
                mapped = ArrayUtils.map(arr, ObjectUtils.repr, null, true);
            } else {
                mapped = ArrayUtils.map(arr, 'toString');
            }
            return '[' + mapped.join(', ') + ']';
        }
    }
}