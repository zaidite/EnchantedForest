package zUtils.service
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * Отображает текст в отдельном окне с кнопкой ОК.
	 * Имеется стек сообщений для отображения.
	 *
	 * Date: 08.09.12
	 * Time: 14:29
	 * @author zaidite
	 * @description
	 */
	public class Alert
	{
		private static var _background:Sprite;
		private static var _messageView:Sprite;
		private static var _stage:Stage;
		private static var _stack:Vector.<String> = new Vector.<String>();
		private static var _messageAction:Dictionary = new Dictionary();
		private static var _messageCount:uint = 0;
		private static var _currentAction : Function ;

		public static const NOT_VALID:String = 'not valid!';
		public static const SOMETHING_WRONG:String = 'Something wrong in ';
		public static const MISSING:String = 'Missing : ';
		public static const NOTHING_TO_RETURN:String = 'Nothing to return : ';
		public static const INPUT_PARAMETERS_ARE_NOT_CORRECT:String = 'Input parameters are not correct!';
		public static const INVALID_ACTION:String = 'Invalid action!!! \n';

		private static const INDENT:int = 10;


		//*********************** CONSTRUCTOR ***********************
		public function Alert() {}
		//***********************************************************

		private static function drawRoundRectangle(width:Number = 150, height:Number = 100, ellipseWidth:Number = 10, ellipseHeight:Number = 10, fillColor:uint = 0x848482, fillAlpha:Number = 1):Sprite
		{
			var holder:Sprite = new Sprite();
			var shape:Shape = new Shape();
			var gr:Graphics = shape.graphics;

			gr.lineStyle();
			gr.beginFill(fillColor, fillAlpha);
			gr.drawRoundRect(0, 0, width, height, ellipseWidth, ellipseHeight);
			gr.endFill();
			holder.addChild(shape);

			return holder;
		}

		private static function drawRectangle(width:Number = 150, height:Number = 100, fillColor:uint = 0x848482, fillAlpha:Number = 1):Sprite
		{
			var handler:Sprite = new Sprite();
			var shape:Shape = new Shape();
			var gr:Graphics = shape.graphics;

			gr.lineStyle();
			gr.beginFill(fillColor, fillAlpha);
			gr.drawRect(0, 0, width, height);
			gr.endFill();
			handler.addChild(shape);

			return handler;
		}

		private static function text_field(str:String, tFormat:TextFormat, select:Boolean = false):TextField
		{
			var tf:TextField = new TextField();
			tf.defaultTextFormat = tFormat;
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.text = str;
			tf.mouseEnabled = select;
			tf.x = 0;
			tf.y = 0;
			tf.selectable = select;

			if(tf.width > _stage.stageWidth - INDENT * 4)
			{
				tf.width = _stage.stageWidth - INDENT * 4;
				tf.wordWrap = true;
				tf.text = str;
			}

			return tf;
		}


		private static function make_button(btnWidth:Number, name:String):Sprite
		{
			var tFormat:TextFormat = new TextFormat('Verdana', 14, 0xFFFFFF);
			var textF:TextField = text_field(name, tFormat);
			var btn:Sprite = drawRoundRectangle(btnWidth, 30);
			btn.addChild(textF);
			btn.buttonMode = true;
			textF.x = (btn.width - textF.width) / 2;
			textF.y = (btn.height - textF.height) / 2;

			return btn;
		}

		private static function make_message(message:String):Sprite
		{
			var mesWidth:Number;
			var mesHeight:Number;
			var btnWidth:Number;
			var btnOk:Sprite;
			var holder:Sprite;

			var tFormat:TextFormat = new TextFormat('Verdana', 18, 0xFFFFFF);
			var messageTextField:TextField = text_field(message, tFormat, true);

			btnWidth = messageTextField.width < 100 ? messageTextField.width : 100;

			btnOk = make_button(btnWidth, 'OK');

			mesWidth = messageTextField.width + INDENT * 4;
			mesHeight = messageTextField.height + btnOk.height + INDENT * 3;

			holder = drawRoundRectangle(mesWidth, mesHeight, 10, 10, 0xFFCC00);
			holder.mouseEnabled = true;
			holder.mouseChildren = true;
			holder.name = 'holder';
			holder.addChild(messageTextField);
			messageTextField.x = INDENT * 2;
			messageTextField.y = INDENT;

			holder.addChild(btnOk);
			btnOk.x = (holder.width - btnOk.width) / 2;
			btnOk.y = messageTextField.height + INDENT * 2;

			btnOk.addEventListener(MouseEvent.CLICK, remove_message);
			return holder;
		}

		private static function check_stack():void
		{
			if(_messageView)return;
			if(!_stack.length)return;
			_currentAction = null;
			show_message(_stack.shift());
		}


		private static function show_message(message:String):void
		{
			_background = drawRectangle(_stage.stageWidth, _stage.stageHeight, 0x000000, .5);
			_background.mouseEnabled = true;
			_background.name = 'background';

			_messageView = make_message(message);
			_messageView.filters = [new DropShadowFilter(5, 45, 0, .5, 8, 8)];
			_messageView.x = (_background.width - _messageView.width) / 2;
			_messageView.y = (_background.height - _messageView.height) / 2;
			_messageView.mouseEnabled = true;
			_messageView.mouseChildren = true;
			_messageView.name = 'messageView';

			_stage.addChild(_background);
			_stage.addChild(_messageView);
			_currentAction = _messageAction[message];

		}


		private static function remove_message(event:MouseEvent):void
		{
			(event.currentTarget as Sprite).removeEventListener(MouseEvent.CLICK, remove_message);

			_stage.removeChild(_messageView);
			_stage.removeChild(_background);
			_messageView.filters = [];

			clear_handler(_messageView);
			clear_handler(_background);

			_messageView = null;
			_background = null;
			if(_currentAction != null)_currentAction();

			check_stack();
		}

		private static function clear_handler(handler:DisplayObjectContainer):void
		{
			if(!handler)return;
			if(handler.numChildren == 0)return;

			while(handler.numChildren > 0)
			{
				var clip:* = handler.getChildAt(0);
				handler.removeChild(clip);
				clip = null;
			}
		}

		/**
		 * Init stage to add alert message
		 * @param stage
		 */
		public static function init(stage:Stage):Boolean
		{
			if(!stage || !stage.stageWidth || !stage.stageHeight)throw new Error('Stage ' + NOT_VALID);
			_stage = stage;
			return true;
		}

		/**
		 * Show message on stage
		 * @param message
		 */
		public static function show(message:String):void
		{

			if(!_stage || !_stage.stageWidth || !_stage.stageHeight)throw new Error('Stage ' + NOT_VALID);

			if(!message || message == '')message = 'Message ' + NOT_VALID;

			if(Capabilities.isDebugger)
			{
				_messageCount++;
				var from:String = (new Error().getStackTrace().match(/at [^)]+\)/g)[1] as String).substr(3);
				message = message + '\n' + '-------------' + '\n' + _messageCount + '. Alert from : ' + from + '\n';
			}


			_stack.push(message);
			check_stack();
		}

		/**
		 * Show message on stage and make action on close message
		 * @param message
		 * @param action
		 */
		public static function showAndAction(message:String, action:Function):void
		{

			if(!_stage || !_stage.stageWidth || !_stage.stageHeight)throw new Error('Stage ' + NOT_VALID);

			if(!message || message == '')message = 'Message ' + NOT_VALID;

			if(Capabilities.isDebugger)
			{
				_messageCount++;
				var from:String = (new Error().getStackTrace().match(/at [^)]+\)/g)[1] as String).substr(3);
				message = message + '\n' + '-------------' + '\n' + _messageCount + '. Alert from : ' + from + '\n';
			}


			_stack.push(message);
			_messageAction[message] = action;
			check_stack();
		}

		/**
		 * Show message on stage
		 * @param message
		 */
		public static function somethingWrongIn(source:Object, message:String = null):void
		{

			if(!_stage || !_stage.stageWidth || !_stage.stageHeight)throw new Error('Stage ' + NOT_VALID);

			message = message ? SOMETHING_WRONG + source + '\n' + message : SOMETHING_WRONG + source + '\n';


			if(Capabilities.isDebugger)
			{
				_messageCount++;
				var from:String = (new Error().getStackTrace().match(/at [^)]+\)/g)[1] as String).substr(3);
				message = message + '\n' + '-------------' + '\n' + _messageCount + '. Alert from : ' + from + '\n';
			}

			_stack.push(message);
			check_stack();
		}

	} //end class
}//end package