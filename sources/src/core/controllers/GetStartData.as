package core.controllers {
	import core.Core;
	import core.GameFacade;
	import core.GameNotifications;
	import core.proxy.FlashVarsProxy;
	import core.proxy.requests.FetchPlayerProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	import zUtils.net.server.IRequestProxy;

	import zUtils.net.server.ZRequests;

	import zUtils.service.ZParsing;

	/**
	 * Date   :  02.03.14
	 * Time   :  13:09
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public class GetStartData extends SimpleCommand {

		//*********************** CONSTRUCTOR ***********************
		public function GetStartData() {
		}
		//***********************************************************

		override public function execute(notification:INotification):void {
			super.execute(notification);

			var note:String = notification.getName();

			switch(note) {
				case GameNotifications.STARTUP:
					Core.flashVarsProxy.getFlashVars();
					break;
				case GameNotifications.GETTING_FLASH_VARS:
					GameFacade.instance().initCore();
					var fetchPlayer:IRequestProxy = ZRequests.manager().getProxy(FetchPlayerProxy.NAME);
						ZRequests.manager().requestStart(fetchPlayer);
					break;
			}
		}


	} //end class
}//end package