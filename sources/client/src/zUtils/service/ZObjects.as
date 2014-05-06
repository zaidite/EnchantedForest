package zUtils.service {

    /**
     * Date   : 12.03.14
     * Time   : 13:59
     * author : Vitaliy Snitko
     * mail   : zaidite@gmail.com
     *
     * description    :
     * responsibility :
     */
    public class ZObjects {

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
                    object[key] = cloneData(subjectValue);
                } else if (isSimple(objectValue) || isList(objectValue)) {
                    object[key] = cloneData(subjectValue);
                } else if (isEmpty(subjectValue)) {
                    object[key] = subjectValue;
                } else {
                    merge(objectValue, subjectValue, keepNulls);
                }
            }
            return object;
        }

        public static function cloneData(obj:*, deep:Boolean = false):* {
            if (!obj) return null;
            if (isSimple(obj)) {
                return obj;
            }
            var re:* = new obj.constructor();
            updateData(re, obj);
            if (deep) {
                var i:*;
                for (i in re) {
                    re[i] = cloneData(re[i], deep);
                }
            }
            return re;
        }

        public static function isEmpty(obj:*):Boolean {
            if (isSimple(obj)) {
                return true;
            }
            for (var i:* in obj) {
                return false;
            }
            return true;
        }

        public static function updateData(obj:Object, subject:Object, props:Object = null):Object {
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

        public static function isSimple(object:*):Boolean {
            return object === null || object === undefined ||
                    object is Boolean || object is int || object is uint || object is Number ||
                    object is String || object is RegExp;
        }

        public static function isList(obj:*):Boolean {
            return obj is Array || obj is Vector;
        }

    } //end class
}//end package