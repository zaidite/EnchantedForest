package zUtils.service {
	import flash.utils.getQualifiedClassName;

	public class ZParsing {

		// --- PUBLIC STATIC FUNCTION ------------------------------------ //
		public static function show(data:Object):void {
			var className:String = _getClassName(data);
			var header:String = 'SHOW [object ' + className + ']' + ' ' + _getIndent('-', 5);
			trace(header);

			for(var item:String in data) {
				_commonParsing(data[item], item, ' ', 1);
			}

			var end:String = 'END' + ' ' + _getIndent('-', header.length - 4);
			trace(end + '\n');
		}


		public static function getString(data:*):String {
			var str:Array = [];
			var className:String = _getClassName(data);
			var header:String = '\n' + 'SHOW [object ' + className + ']' + ' ' + _getIndent('-', 5);
			str.push(header);

			for(var item:* in data) {
				str.push(_formString(data[item], item, ' ', 1));
			}

			var end:String = 'END' + ' ' + _getIndent('-', header.length - 5);
			str.push(end + '\n');

			return str.join('\n');
		}

		// --- PRIVATE STATIC FUNCTION ------------------------------------ //
		private static function _formString(item:*, objName:*, indent:String, indentLength:int):String {
			var currentIndent:String = _getIndent(indent, indentLength);
			var str:Array = [];
			var header:String;

			if(item is String) {
				str.push(currentIndent + objName + " = " + "'" + item.toString() + "'");
			}
			else if(item is int || item is Number || item is Boolean) {
				str.push(currentIndent + objName + " = " + item.toString());
			}
			else if(item === null) {
				header = currentIndent + objName + " = " + 'null';
				str.push(header);
			}
			else if(item === undefined) {
				header = currentIndent + objName + " = " + 'undefined';
				str.push(header);
			}
			else {
				header = currentIndent + objName + " = " + '[object ' + _getClassName(item) + ']';
				str.push(header);

				indentLength = header.indexOf('o');

				for(var prop:String in item) {
					str.push(_formString(item[prop], prop, indent, indentLength));
				}
			}

			return str.join('\n');
		}

		private static function _commonParsing(item:*, objName:*, indent:String, indentLength:int):void {
			var currentIndent:String = _getIndent(indent, indentLength);
			var header:String;

			if(item is String) {
				trace(currentIndent + objName + " = " + "'" + item.toString() + "'");
			}
			else if(item is int || item is Number || item is Boolean) {
				trace(currentIndent + objName + " = " + item.toString());
			}
			else if(item == null) {
				header = currentIndent + objName + " = " + 'null';
				trace(header);
			}
			else if(item == undefined) {
				header = currentIndent + objName + " = " + 'undefined';
				trace(header);
			}
			else {
				header = currentIndent + objName + " = " + '[object ' + _getClassName(item) + ']';
				trace(header);

				indentLength = header.indexOf('o');

				for(var prop:String in item) {
					_commonParsing(item[prop], prop, indent, indentLength);
				}
			}
		}

		private static function _getClassName(target:Object):String {
			var className:String = getQualifiedClassName(target);
			var separatorPosition:int = className.lastIndexOf(':');
			var cutName:String = className.substr(separatorPosition + 1, className.length);
			return cutName;
		}

		private static function _getIndent(symbol:String, amount:int):String {
			var indent:String = '';
			for(var i:int = 0; i < amount; i++) {
				indent += symbol;
			}
			return indent;
		}

	}//end class
}//end package
