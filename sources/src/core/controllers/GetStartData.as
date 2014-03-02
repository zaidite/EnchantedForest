package core.controllers {
	import core.Core;
	import core.GameNotifications;
	import core.proxy.FlashVarsProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

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
			var body:Object = notification.getBody();

			switch(note) {
				case GameNotifications.STARTUP:
					Core.flashVarsProxy.getFlashVars();
					break;
				case GameNotifications.GETTING_FLASH_VARS:
					trace('[GetStartData] execute()', ZParsing.getString(body));

			}

		}
	} //end class
}//end package