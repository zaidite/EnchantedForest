package zUtils.content {
	import br.com.stimuli.loading.BulkLoader;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;

	import zUtils.service.Alert;

	/**
	 * Date: 30.08.12
	 * Time: 18:53
	 * @author zaidite
	 * @description
	 */
	public class Content extends EventDispatcher {
		private var _bulkLoader:BulkLoader;
		private var _callbackComplete:Function;
		private var _callbackError:Function;

		private static var _instance:Content;

		public static const LOAD_COMPLETE:String = 'load_complete';

		//*********************** CONSTRUCTOR ***********************
		public function Content(secure:PrivateClass) {
			_bulkLoader = new BulkLoader();
		}
		//***********************************************************

		private function onCompleteHandler(event:ProgressEvent):void {
			if(!_bulkLoader) {
				Alert.somethingWrongIn(this);
				return;
			}
			remove_listeners();
			dispatchEvent(new Event(LOAD_COMPLETE));
			if(_callbackComplete != null)_callbackComplete();
		}

		private function check_id(id:String):Boolean {
			if(!id || id == '') {
				Alert.somethingWrongIn(this, 'Need id!');
				return false;
			}
			return true;
		}

		private function onErrorHandler(event:ErrorEvent):void {
			remove_listeners();

			if(_callbackError != null)_callbackError(); else Alert.show(event.toString());
		}

		private function add_listeners():void {
			_bulkLoader.addEventListener(BulkLoader.COMPLETE, onCompleteHandler);
			_bulkLoader.addEventListener(BulkLoader.ERROR, onErrorHandler);

		}

		private function remove_listeners():void {
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onCompleteHandler);
			_bulkLoader.removeEventListener(BulkLoader.ERROR, onErrorHandler);
		}

		private function clear_data():void {
			_callbackComplete = null;
			_callbackError = null;
		}



		public function formContentDataForGroupLoaded(id:String, url:String):Object {
			if(!id || id == '' || !url || url == '') {
				Alert.somethingWrongIn(this);
				return null;
			}
			return {id: id, url: url};
		}

		/**
		 *
		 * @param content - [{id:.., url:..},..]
		 * @param callbackComplete
		 */
		public function loadGroup(content:Vector.<Object>, callbackComplete:Function = null,
								  callbackError:Function = null):void {
			if(!content || !content.length) {
				Alert.somethingWrongIn(this, 'Need content data');
				return;
			}

			remove_listeners();
			clear_data();

			_callbackComplete = callbackComplete;
			_callbackError = callbackError;

			var contentItem:Object;
			var contentUrl:String;
			var contentId:String;
			var len:int = content.length;
			for(var i:int = 0; i < len; i++) {
				if(content[i]) {
					contentItem = content[i];
					contentUrl = contentItem['url'];
					contentId = contentItem['id'];
					if(contentId && contentUrl && _bulkLoader)_bulkLoader.add(contentUrl, {id: contentId});
				}
			}

			add_listeners();
			_bulkLoader.start();

		}


		public function loadItem(id:String, url:String, callback:Function = null, callbackError:Function = null):void {
			if(!id || id == '' || !url || url == '' || !_bulkLoader) {
				Alert.somethingWrongIn(this);
				return;
			}

			remove_listeners();
			clear_data();

			_callbackComplete = callback;
			_callbackError = callbackError;


			_bulkLoader.add(url, {id: id});
			add_listeners();
			_bulkLoader.start();
		}

		public function clearData():void {
			remove_listeners();
			clear_data();
			_bulkLoader.clear();
			_bulkLoader = null;
			_instance = null;

		}

		public function getBitmapData(id:String):BitmapData {
			if(!check_id(id))return null;

			var bmd:BitmapData = _bulkLoader.getBitmapData(id);
			if(!bmd)Alert.somethingWrongIn(this, 'Nothing to return. ' + id);

			return bmd;
		}

		public function getBitmap(id:String):Bitmap {
			if(!check_id(id))return null;

			var bitmap:Bitmap = _bulkLoader.getBitmap(id);
			if(!bitmap)Alert.somethingWrongIn(this, 'Nothing to return. ' + id);

			return bitmap;
		}

		public function getXML(id:String):XML {
			if(!check_id(id))return null;

			var xml:XML = _bulkLoader.getXML(id);
			if(!xml)Alert.somethingWrongIn(this, 'Nothing to return. ' + id);

			return xml;
		}

		public function getDataFromJSON(id:String):Object {
			if(!check_id(id))return null;

			var data:String = _bulkLoader.getText(id);

			if(!data) {
				Alert.somethingWrongIn(this, 'Nothing to return. ' + id);
				return null;
			}

			return JSON.parse(data);
		}

		public function getText(id:String):String {
			if(!check_id(id))return null;

			var data:String = _bulkLoader.getText(id);
			if(!data) {
				Alert.somethingWrongIn(this, 'Nothing to return. ' + id);
				return null;
			}

			return data;
		}


		public static function manager():Content {
			if(!_instance) {
				Content._instance = new Content(new PrivateClass());
			}
			return _instance;
		}


	} //end class
}//end package

class PrivateClass {
	public function PrivateClass():void {}
}