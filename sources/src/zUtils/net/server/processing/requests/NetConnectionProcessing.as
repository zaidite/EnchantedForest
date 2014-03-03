package zUtils.net.server.processing.requests {
	import zUtils.net.server.IRequestProxy;
	import zUtils.net.server.processing.data.IDataProcessing;

	/**
	 * Date   :  02.03.14
	 * Time   :  19:43
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class NetConnectionProcessing implements IRequestProcessing {

		public static const TYPE:String = 'netConnection';

		//*********************** CONSTRUCTOR ***********************
		public function NetConnectionProcessing(dataProcessing:IDataProcessing, onComplete:Function, onError:Function) {
		}
		//***********************************************************

		public function start(proxy:IRequestProxy) {
		}


		public function clearData():void {
		}
	} //end class
}//end package