package zUtils.net.server {
	/**
	 * Date   :  02.03.14
	 * Time   :  17:57
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public interface IRequestProxy {

		function get url():String
		function get params():Object
		function get dataFormat():String
		function get requestType():String
		function get requestComplete():Function
		function get requestError():Function
		function get response():Object

		function set dataFormat(value:String):void
		function set requestType(value:String):void
		function set response(value:Object):void


	}
}
