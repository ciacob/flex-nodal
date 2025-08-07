package com.github.ciacob.flexnodal.utils {
    public class InstanceFactory {
        
        private var _clazz:Class;
        private var _initialize:Function;
        private var _purge:Function;
        private var _pool:Array = [];

        /**
         * @param clazz        The Class to create instances of.
         * @param initialize   Function(instance:*):void called whenever an instance is handed out.
         * @param purge        Function(instance:*):void called whenever an instance is returned.
         */
        public function InstanceFactory(clazz:Class, initialize:Function, purge:Function) {
            _clazz      = clazz;
            _initialize = initialize != null ? initialize : function(o:*):void {};
            _purge      = purge != null ? purge : function(o:*):void {};
        }

        /**
         * Gives an instance, creating one if necessary.
         */
        public function giveInstance():* {
            var obj:* = (_pool.length > 0) ? _pool.pop() : new _clazz();
            _initialize(obj);
            return obj;
        }

        /**
         * Takes an instance back and stores it in the pool.
         */
        public function takeInstance(obj:*):void {
            if (!(obj is _clazz)) {
                throw new ArgumentError("Object is not of expected type: " + _clazz);
            }
            _purge(obj);
            _pool.push(obj);
        }

        /**
         * Clears all pooled instances.
         */
        public function clear():void {
            _pool.length = 0;
        }
    }
}
