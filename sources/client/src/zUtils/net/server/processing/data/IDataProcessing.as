package zUtils.net.server.processing.data {
	import flash.utils.ByteArray;

	/**
	 * Date   :  02.03.14
	 * Time   :  19:04
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public interface IDataProcessing {

		function encode(data:Object):ByteArray;
		function encodeString(data:Object):String;
		function decode(data:Object):Object;
		function decodeString(string:String):Object;

	}
}
