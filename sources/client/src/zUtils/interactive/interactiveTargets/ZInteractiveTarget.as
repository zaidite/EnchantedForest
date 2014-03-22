package zUtils.interactive.interactiveTargets
{
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /**
     * Date: 30.05.12
     * Time: 10:02
     * @author zaidite
     * @description
     */

    public class ZInteractiveTarget extends Sprite
    {

        //- PRIVATE VAR ------------------------------------------

        /** Интерактивность объекта */
        private var _interactive:Boolean = true;

        /** Объект отображения */
        private var _target:DisplayObject;

        /** Метод, запускаемый объектом */
        private var _action:Function;

        /** Текущий объект события мышки */
        private var _targetMouseEvent:MouseEvent;

        private var _actionParams:Array;

        //- GETTERS  --------------------------------------------------

        /** Интерактивность объекта */
        public function get interactive():Boolean
        {return _interactive;}

        /** Метод, запускаемый объектом */
        public function get action():Function
        {return _action;}

        /** Объект отображения */
        public function get target():DisplayObject
        {return _target;}

        /** Возвращает объект события мышки */
        public function get targetMouseEvent():MouseEvent
        { return _targetMouseEvent;}

        /**
         * Возвращает массив переданных параметров, которые передаются при активации метода action
         */
        public function get actionParams():Array
        {return _actionParams;}

        //- SETTERS  --------------------------------------------------

        /**
         * Устанавливает массив с параметрами, которые будут переданы методу action при активации. Не более 10 параметров.
         * @param value
         */
        public function set actionParams(value:Array):void
        {_actionParams = value;}

        /** Интерактивность объекта */
        public function set interactive(value:Boolean):void
        {setInteractive(value);}

        /** Метод, запускаемый объектом */
        public function set action(value:Function):void
        {_action = value;}

        //*********************** CONSTRUCTOR ***********************
        /**
         * Интерактивный контейнер для переданного target.
         * Для target активируются прослушивания событий мышки.
         * @param target - DisplayObject который становится интерактивным.
         * @param action - ссылка на метод, который будет активирован при нажатии и отпускании мышки на таргете
         * @param actionParams - массив с параметрами, который будет передан в активированный метод action
         *
         */
        public function ZInteractiveTarget(target:DisplayObject, action:Function = null, actionParams:Array = null)
        {
            _target = target;
            _action = action;
            _actionParams = actionParams;
            initData();
        }

        //***********************************************************

        //- PRIVATE FUNCTION ---------------------------------------

        private function initData():void
        {
            if (_target is MovieClip)(_target as MovieClip).gotoAndStop(1);
            addChild(_target);
            interactive = true;
        }

        private function mOver(event:MouseEvent):void
        {
            _targetMouseEvent = event;
            _target.addEventListener(MouseEvent.MOUSE_OUT, mOut);
            _target.addEventListener(MouseEvent.MOUSE_DOWN, mDown);
            _target.addEventListener(MouseEvent.MOUSE_UP, mUp);
            _target.addEventListener(MouseEvent.MOUSE_MOVE, mMove);
            mouseOver();
        }

        private function mRollOver(event:MouseEvent):void
        {
            _targetMouseEvent = event;
            _target.addEventListener(MouseEvent.ROLL_OUT, mRollOut);
            mouseRollOver();
        }

        private function mRollOut(event:MouseEvent):void
        {
            _targetMouseEvent = event;
            _target.removeEventListener(MouseEvent.ROLL_OUT, mRollOut);
            mouseRollOut();
            _targetMouseEvent = null;
        }

        private function mMove(event:MouseEvent):void
        {
            _targetMouseEvent = event;
            mouseMove();
        }

        private function mUp(event:MouseEvent):void
        {
            _targetMouseEvent = event;
            mouseUp();
        }

        private function mDown(event:MouseEvent):void
        {
            _targetMouseEvent = event;
            mouseDown();
        }

        private function mOut(event:MouseEvent):void
        {
            _targetMouseEvent = event;
            _target.removeEventListener(MouseEvent.MOUSE_OUT, mOut);
            _target.removeEventListener(MouseEvent.MOUSE_DOWN, mDown);
            _target.removeEventListener(MouseEvent.MOUSE_UP, mUp);
            _target.removeEventListener(MouseEvent.MOUSE_MOVE, mMove);
            mouseOut();
            _targetMouseEvent = null;
        }

        private function removeListeners():void
        {
            _target.removeEventListener(MouseEvent.MOUSE_OVER, mOver);
            _target.removeEventListener(MouseEvent.MOUSE_OUT, mOut);
            _target.removeEventListener(MouseEvent.MOUSE_DOWN, mDown);
            _target.removeEventListener(MouseEvent.MOUSE_UP, mUp);
            _target.removeEventListener(MouseEvent.MOUSE_MOVE, mMove);
            _target.removeEventListener(MouseEvent.ROLL_OUT, mRollOut);
            _target.removeEventListener(MouseEvent.ROLL_OVER, mRollOver);
        }

        private function set_target_buttonMode(val:Boolean):void
        {
            if (_target is Sprite)(_target as Sprite).buttonMode = val;
            if (_target is MovieClip)(_target as MovieClip).buttonMode = val;
        }

        //- PUBLIC FUNCTION ------------------------------------------

        /**
         * Устанавливает события интерактивности объекта
         * @param val
         *
         */
        public function setInteractive(val:Boolean):void
        {
            _interactive = val;

            if (val)
            {
                _target.alpha = 1;
                set_target_buttonMode(true);
                _target.addEventListener(MouseEvent.MOUSE_OVER, mOver);

                _target.addEventListener(MouseEvent.MOUSE_OUT, mOut);
                _target.addEventListener(MouseEvent.MOUSE_DOWN, mDown);
                _target.addEventListener(MouseEvent.MOUSE_UP, mUp);
                _target.addEventListener(MouseEvent.MOUSE_MOVE, mMove);

                _target.addEventListener(MouseEvent.ROLL_OVER, mRollOver);
                _target.removeEventListener(MouseEvent.ROLL_OUT, mRollOut);
            }
            else
            {
                removeListeners();
                _target.alpha = .5;
                set_target_buttonMode(false);
                _targetMouseEvent = null;
            }
        }

        /**
         * Активирует метод переданный объекту.
         * При активации в метод передаются параметры которые были заданы через actionParams,
         * либо были переданы в конструктор при создании объекта.
         *
         */
        public function makeAction():void
        {
            if (_action != null)_action.apply(null, _actionParams);
        }

        /**
         * Метод активируется при событии мышки MOUSE_MOVE
         * Может быть переопределён в подклассе
         *
         */
        public function mouseMove():void
        {}

        /**
         * Метод активируется при событии мышки MOUSE_UP
         * Может быть переопределён в подклассе
         *
         */
        public function mouseUp():void
        {
            if (_target is MovieClip)(_target as MovieClip).gotoAndStop(2);

            if (_target is MovieClip)
                (_target as MovieClip).stopDrag();

            if (_target is Sprite)
                (_target as Sprite).stopDrag();

            makeAction();
        }

        /**
         * Метод активируется при событии мышки MOUSE_DOWN
         * Может быть переопределён в подклассе
         *
         */
        public function mouseDown():void
        {
            if (_target is MovieClip)
                (_target as MovieClip).gotoAndStop(3);

            if (_target is MovieClip)
                (_target as MovieClip).startDrag(false);

            if (_target is Sprite)
                (_target as Sprite).startDrag(false);
        }

        /**
         * Метод активируется при событии мышки MOUSE_OUT
         * Может быть переопределён в подклассе
         *
         */
        public function mouseOut():void
        {
            if (_target is MovieClip)(_target as MovieClip).gotoAndStop(1);
        }

        /**
         * Метод активируется при событии мышки MOUSE_OVER
         * Может быть переопределён в подклассе
         *
         */
        public function mouseOver():void
        {
            if (_target is MovieClip)(_target as MovieClip).gotoAndStop(2);
        }

        /**
         * Метод активируется при событии мышки ROLL_OVER
         * Может быть переопределён в подклассе
         *
         */
        public function mouseRollOver():void
        {}

        /**
         * Метод активируется при событии мышки ROLL_OUT
         * Может быть переопределён в подклассе
         *
         */
        public function mouseRollOut():void
        {}

        /** Очищаем данные объекта. Готовим объект к удалению */
        public function clear():void
        {
            removeListeners();
            _interactive = false;
            _action = null;
            _targetMouseEvent = null;

            if (_target)
            {
                removeChild(_target);
                _target = null;
            }
        }

    } //end class
} // end package
