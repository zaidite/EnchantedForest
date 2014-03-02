package zUtils.net.server.processing.requests {
	import zUtils.net.server.IRequestProxy;

	/**
	 * Date   :  02.03.14
	 * Time   :  19:04
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public interface IRequestProcessing {

		function start(proxy:IRequestProxy);
		function clearData():void;

	}
}
