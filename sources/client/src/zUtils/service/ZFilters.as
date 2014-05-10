package zUtils.service {

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.getDefinitionByName;

	public class ZFilters extends Sprite {

		public static const BLUR:String = 'blur';
		public static const GRAY_SCALE:String = 'grayscale';
		public static const DROP_SHADOW:String = 'dropShadow';
		public static const GLOW:String = 'glow';

		public static function clearFilters(target:DisplayObject, filter:String = null):void {

			if(!target)return;

			if(!filter) {
				target.filters = [];
				return;
			}

			var filtersArr:Array = target.filters;

			var filtersName:Object = {};
			filtersName[GLOW] = 'flash.filters.GlowFilter';
			filtersName[GRAY_SCALE] = 'flash.filters.ColorMatrixFilter';
			filtersName[DROP_SHADOW] = 'flash.filters.DropShadowFilter';
			filtersName[BLUR] = 'flash.filters.BlurFilter';


			if(filtersName[filter]) {
				var filterClass:Class = getDefinitionByName(filtersName[filter]) as Class;
				var len:int = filtersArr.length;
				for(var i:int = 0; i < len; i++) {
					if(target.filters[i] as filterClass)filtersArr.splice(i, 1);
				}
			}

			target.filters = filtersArr;
		}


		/**
		 * Добавляет эффект падающей тени к объекту
		 * @param target:DisplayObject - Объект, к которому добавляется фильтр.
		 * @param blurX:Number = 8.0 - Степень размытия по горизонтали.
		 * @param blurY:Number = 8.0 - Степень размытия по вертикали.
		 * @param dist:int = 7.0 - Расстояние смещения для тени (в пикселах).
		 * @param angle:Number = 45 - Угол тени.
		 * @param alpha:Number = 1.0 - Значение альфа-прозрачности для цвета тени.
		 * @param color:uint = 0x000000 - Цвет тени.
		 * @param strangth:Number = .6 - Степень вдавливания или растискивания.
		 * @param hideObject:Boolean = false - Определяет, является ли объект скрытым.
		 * @param inner:Boolean = false - Определяет, является ли тень внутренней тенью.
		 * @param knock:Boolean = false - Применяет эффект выбивки (true), который фактически делает заливку объекта прозрачной и выявляет цвет фона документа.
		 * @param quality:int = 1 - Заданное число применений фильтра.
		 *
		 */
		public static function dropShadow(target:DisplayObject, blurX:Number = 8.0, blurY:Number = 8.0, dist:int = 7, angle:Number = 45, alpha:Number = 1, color:uint = 0x000000, strangth:Number = .6, hideObject:Boolean = false, inner:Boolean = false, knock:Boolean = false, quality:int = 1):void {
			if(!target)return;
			var filtersArr:Array = target.filters;
			var filter:DropShadowFilter = new DropShadowFilter();

			filter.distance = dist;
			filter.hideObject = hideObject;
			filter.inner = inner;
			filter.knockout = knock;
			filter.quality = quality;
			filter.blurX = blurX;
			filter.blurY = blurY;
			filter.strength = strangth;
			filter.angle = angle;
			filter.alpha = alpha;
			filter.color = color;

			filtersArr.push(filter);
			target.filters = filtersArr;
		}


		/**
		 * Добавляет эффект свечения к переданному объекту
		 * @param target:DisplayObject - Объект, к которому добавляется фильтр.
		 * @param blurX:Number = 6.0 - Степень размытия по горизонтали.
		 * @param blurY:Number = 6.0 - Степень размытия по вертикали.
		 * @param alpha:Number = 1.0 - Значение альфа-прозрачности цвета.
		 * @param color:uint = 0xFF0000 - Цвет свечения.
		 * @param strength:Number = 2 - Степень вдавливания или растискивания.
		 * @param quality:int = 3 - Заданное число применений фильтра.
		 * @param inner:Boolean = false - Определяет, является ли свечение внутренним свечением.
		 * @param knockout:Boolean = false - Определяет, применяется ли к объекту эффект выбивки.
		 *
		 */
		public static function glow(target:DisplayObject, blurX:Number = 6.0, blurY:Number = 6.0, alpha:Number = 1.0, color:uint = 0xFF0000, strength:Number = 2, quality:int = 3, inner:Boolean = false, knockout:Boolean = false):void {

			var filtersArr:Array = target.filters;
			var filter:GlowFilter = new GlowFilter();

			filter.color = color;
			filter.blurX = blurX;
			filter.blurY = blurY;
			filter.alpha = alpha;
			filter.strength = strength;
			filter.quality = quality;
			filter.inner = inner;
			filter.knockout = knockout;

			filtersArr.push(filter);
			target.filters = filtersArr;
		}


		/**
		 * Фильтр делающий переданный объект чёрно-белым
		 * @param target
		 * @param lumRed
		 * @param lumGreen
		 * @param lumBlue
		 *
		 */
		public static function grayscale(target:DisplayObject, lumRed:Number = .2127, lumGreen:Number = .7152, lumBlue:Number = .0722):void {

			var filtersArr:Array = target.filters;

			var matrArr:Array = [lumRed, lumGreen, lumBlue, 0, 0, lumRed, lumGreen, lumBlue, 0, 0, lumRed, lumGreen,
								 lumBlue, 0, 0, 0, 0, 0, 1, 0];

			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrArr);

			filtersArr.push(filter);
			target.filters = filtersArr;
		}


		/**
		 *
		 * @param target:DisplayObject - Объект для эффекта
		 * @param blurX - Степень размытия по горизонтали.
		 * @param blurY - Степень размытия по вертикали.
		 * @param quality:int - Число применений эффекта "Размытие".
		 *
		 */
		public static function blur(target:DisplayObject, blurX:Number = 3, blurY:Number = 3, quality:int = 1):void {
			if(!target)return;
			var filtersArr:Array = target.filters;

			var filter:BlurFilter = new BlurFilter(blurX, blurY, quality);
			filtersArr.push(filter);
			target.filters = filtersArr;
		}

	}//end class
}//end package
