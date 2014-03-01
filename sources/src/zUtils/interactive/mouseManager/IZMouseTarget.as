package zUtils.interactive.mouseManager {
	import flash.display.DisplayObject;

	/**
	 * Date   :  23.02.14
	 * Time   :  22:22
	 * author :  Vitaliy Snitko
	 * mail   :  zaidite@gmail.com
	 *
	 * class description    :
	 * class responsibility :
	 */
	public interface IZMouseTarget {

		function get target():DisplayObject;
		function get action():Function;
		function get actionParams():Array;
		function get interactive():Boolean;

		function set action(value:Function):void;
		function set actionParams(value:Array):void;
		function set interactive(value:Boolean):void;

		function mouseOver():void;
		function mouseOut():void;
		function mouseMove():void;
		function mouseDown():void;
		function mouseUp():void;
		function actionStart():void;
		function clearData():void;

	}
}
