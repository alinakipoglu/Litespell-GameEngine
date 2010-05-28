package com.litespell.gameengine.utils
{
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flash.display.Stage;

	public class KeyboardUtil {
		
		private static var stage			:Stage;
		private static var keyDictionary	:Dictionary;
		
		public static function init(_stage:Stage):void
		{
			stage 				= _stage;
			keyDictionary		= new Dictionary();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
		}
		
		public static function keyIsDown(_keyCode:uint):Boolean
		{
			return keyDictionary[_keyCode];
		}

		private static function handleKeyUp(event : KeyboardEvent):void
		{
			keyDictionary[event.keyCode]	= null;
		}

		private static function handleKeyDown(event : KeyboardEvent):void
		{
			keyDictionary[event.keyCode]	= true;
		}
	}
}
