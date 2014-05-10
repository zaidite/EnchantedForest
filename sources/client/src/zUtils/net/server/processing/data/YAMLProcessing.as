package zUtils.net.server.processing.data {
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	/**
	 * Date   :  02.03.14
	 * Time   :  19:22
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class YAMLProcessing implements IDataProcessing {

		private static var _prepared:Boolean = false;
		private static var _encoder:Function;
		private static var _decoder:Function;

		public static const TYPE:String = 'yaml';

		//*********************** CONSTRUCTOR ***********************
		public function YAMLProcessing() {
		}
		//***********************************************************

		private static function _prepare():void {
			var _lib:Class = getDefinitionByName('org.as3yaml.YAML') as Class;
			_encoder = _lib['encode'];
			_decoder = _lib['decode'];
			_prepared = true;
		}

		public function encode(data:Object):ByteArray {
			var str:String = encodeString(data);
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(str);
			return bytes;
		}

		public function decode(data:Object):Object {
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(data);
			var str:String = bytes.toString();
			return decodeString(str);
		}


		public function encodeString(data:Object):String {
			if(!_prepared) {
				_prepare();
			}
			return _encoder(data);
		}

		public function decodeString(string:String):Object {
			if(!_prepared) {
				_prepare();
			}
			return _decoder(string);
		}
	} //end class
}//end package