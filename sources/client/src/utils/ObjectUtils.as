/**
 * ObjectUtils
 * A small set of Object utilites
 *
 * @author        Ivan Filimonov
 * @version        0.2
 */

/*
 Licensed under the MIT License

 Copyright (c) 2009-2010 Ivan Filimonov

 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package utils {
    import flash.utils.Dictionary;

    public final class ObjectUtils {
        public static function get(obj:Object, key:*, def:* = null):* {
            if (!obj.hasOwnProperty(key)) {
                return def;
            }
            else {
                return obj[key];
            }
        }

        public static function pop(obj:Object, key:*, def:* = null):* {
            if (!obj.hasOwnProperty(key)) {
                return def;
            }
            else {
                var re:* = obj[key];
                delete obj[key];
                return re;
            }
        }

        public static function isNull(object:*):Boolean {
            return object === null || object === undefined;
        }

        public static function isSimple(object:*):Boolean {
            return object === null || object === undefined ||
                    object is Boolean || object is int || object is uint || object is Number ||
                    object is String || object is RegExp;
        }

        public static function isList(obj:*):Boolean {
            return obj is Array || obj is Vector;
        }

        public static function isEmpty(obj:*):Boolean {
            if (ObjectUtils.isSimple(obj)) {
                return true;
            }
            for (var i:* in obj) {
                return false;
            }
            return true;
        }

        public static function keys(obj:Object):Array {
            var re:Array = [];
            for (var i:* in obj) {
                re.push(i);
            }
            return re;
        }

        public static function values(obj:Object):Array {
            var re:Array = [];
            for each (var i:* in obj) {
                re.push(i);
            }
            return re;
        }

        public static function repr(obj:*, deep:Boolean = true):String {
            if (obj is String) {
                return "'" + obj + "'";
            }
            if (obj is Array) {
                return ArrayUtils.repr(obj as Array, deep);
            }
            if (isNull(obj)) {
                return 'null';
            }
            if (isSimple(obj)) {
                return obj.toString();
            }

            var pairs:Array = [];
            for (var i:* in obj) {
                var pair:String = i.toString() + ': ';
                if (deep) {
                    pair += repr(obj[i]);
                } else {
                    pair += obj[i];
                }
                pairs.push(pair);
            }
            if (pairs.length) {
                return '{' + pairs.join(', ') + '}';
            }
            return String(obj);
        }

        public static function typeOf(obj:Object):String {
            return typeof(obj);
        }

        private static var _keys:Array = [];

        public static function clear(obj:Object):void {
            if (ObjectUtils.isSimple(obj) || ObjectUtils.isEmpty(obj)) {
                return;
            }
            for (var i:* in obj) {
                ObjectUtils._keys.push(i);
            }
            for each (i in ObjectUtils._keys) {
                delete obj[i];
            }
            ObjectUtils._keys.length = 0;
        }

        public static function update(obj:Object, subject:Object, props:Object = null):Object {
            var i:*;
            if (!props) {
                for (i in subject) {
                    obj[i] = subject[i];
                }
            } else {
                for each (i in props) {
                    if (subject.hasOwnProperty(i)) {
                        obj[i] = subject[i];
                    }
                }
            }
            return obj;
        }

        public static function push(obj:Object, key:String, value:*):void {
            if (!obj[key]) {
                obj[key] = [];
            }
            obj[key].push(value);
        }

        public static function defaults(obj:Object, subject:Object):Object {
            var i:*;
            for (i in subject) {
                if (!obj.hasOwnProperty(i)) {
                    obj[i] = subject[i];
                }
            }
            return obj;
        }

        public static function clone(obj:*, deep:Boolean = false):* {
            if (!obj) return null;
            if (ObjectUtils.isSimple(obj)) {
                return obj;
            }
            var re:* = new obj.constructor();
            ObjectUtils.update(re, obj);
            if (deep) {
                var i:*;
                for (i in re) {
                    re[i] = clone(re[i], deep);
                }
            }
            return re;
        }

        public static function map(obj:Object, callback:Function):void {
            for (var i:* in obj) {
                ObjectUtils._keys.push(i);
            }
            for each (i in ObjectUtils._keys) {
                callback.call(obj, i);
            }
        }

        public static function objectPropCount(object:Object):uint {
            var count:uint = 0;
            for (var key:String in object) {
                if (object[key] != null) count++;
            }
            return count;
        }

        public static function merge(object:Object, subject:Object, keepNulls:Boolean = false):Object {
            for (var key:String in subject) {
                var subjectValue:* = subject[key];
                var objectValue:* = object[key];
                if (subjectValue === null) {
                    if (!keepNulls) {
                        delete object[key];
                    } else {
                        object[key] = null;
                    }
                    continue;
                }
                if (isSimple(subjectValue)) {
                    object[key] = subjectValue;
                } else if (isList(subjectValue)) {
                    object[key] = clone(subjectValue);
                } else if (isSimple(objectValue) || isList(objectValue)) {
                    object[key] = clone(subjectValue);
                } else if (isEmpty(subjectValue)) {
                    object[key] = subjectValue;
                } else {
                    merge(objectValue, subjectValue, keepNulls);
                }
            }
            return object;
        }

        /**
         * Create a new object with fields extracted from source objects.
         * @param object Source object
         * @param fields List of fields to extract
         * @return new Object
         */
        public static function pick(object:Object, ...fields):Object {
            var r:Object = {};
            for each (var field:String in fields) {
                r[field] = object[field];
            }
            return r;
        }

        private static var _hashTable:Dictionary = new Dictionary(true);

        public static function hash(object:Object):String {
            var re:String = _hashTable[object];
            if (!re) {
                re = StringUtils.uniqueID();
                _hashTable[object] = re;
            }
            return re;
        }

        public static function setDefault(object:Object, key:String, defaultValue:* = null):* {
            if (!object.hasOwnProperty(key)) {
                object[key] = defaultValue;
            }
            return object[key];
        }

    }
}
