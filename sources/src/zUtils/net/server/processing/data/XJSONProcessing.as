package zUtils.net.server.processing.data {
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	/**
	 * Date   :  02.03.14
	 * Time   :  19:24
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class XJSONProcessing implements IDataProcessing {

		private var _prepared:Boolean = false;
		private var _encoder:Function;
		private var _decoder:Function;

		public static const TYPE:String = 'xjson';

		//*********************** CONSTRUCTOR ***********************
		public function XJSONProcessing() {
		}
		//***********************************************************

		private function _prepare():void {
			try {
				var _builtIn:Class = getDefinitionByName('JSON') as Class;
				_encoder = _builtIn['stringify'];
				_decoder = _builtIn['parse'];
			} catch(e:ReferenceError) {
				var _coreLib:Class = getDefinitionByName('com.adobe.serialization.json.JSON') as Class;
				_encoder = _coreLib['encode'];
				_decoder = _coreLib['decode'];
			}
			_prepared = true;
		}

		public function encode(data:Object):ByteArray {
			var str:String = encodeString(data);
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(str);
			bytes.compress();
			return bytes;
		}

		public function decode(data:Object):Object {
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(data);
			bytes.uncompress();
			return decodeString(bytes.toString());
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