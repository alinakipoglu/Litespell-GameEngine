package com.litespell.gameengine.core.objects.interfaces
{
	public interface IGame
	{
		function get world():IWorld;
		function set world(_value:IWorld):void;
		
		function get gameDelegate():IGameDelegate;
		function set gameDelegate(_value:IGameDelegate):void;
		
		function get frameRate():uint;
		function set frameRate(_value:uint):void;
		
		function addSystem(_value:ISystem):void;
		
		function removeSystem(_value:ISystem):void;
		function removeSystemByName(_value:String):void;
		
		function getSystemByName(_value:String):ISystem;
		
		function start():void;
		function pause():void;
		function reset():void;
		function invalidate():void;
	}
}