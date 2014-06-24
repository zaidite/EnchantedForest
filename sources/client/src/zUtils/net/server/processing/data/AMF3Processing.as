package zUtils.net.server.processing.data {
    import flash.net.ObjectEncoding;
    import flash.utils.ByteArray;

    /**
     * Date   :  02.03.14
     * Time   :  19:15
     * author :  Vitaliy Snitko
     * mail   :  zaidite@gmail.com
     *
     * class description    :
     * class responsibility :
     */
    public class AMF3Processing implements IDataProcessing {

        public static const TYPE:String = 'amf3';

        //*********************** CONSTRUCTOR ***********************
        public function AMF3Processing() {
        }

        //***********************************************************

        public function encode(data:Object):ByteArray {
            var bytes:ByteArray = new ByteArray();
            bytes.writeObject(data);
            bytes.compress();
            return bytes;
        }

        public function decode(data:ByteArray):Object {
            data.uncompress();
            return data.readObject();
        }

        public function encodeString(data:Object):String {
            return encode(data).toString();
        }

        public function decodeString(string:String):Object {
            var bytes:ByteArray = new ByteArray();
            bytes.writeUTF(string);
            return decode(bytes);
        }

    } //end class
}//end package