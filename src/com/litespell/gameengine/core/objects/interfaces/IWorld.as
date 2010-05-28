package com.litespell.gameengine.core.objects.interfaces
{
	public interface IWorld
	{
		function get ownerGame():IGame;
		function set ownerGame(_value:IGame):void;
		
		function addGameObject(_value:IGameObject):void;
		
		function removeGameObject(_value:IGameObject):void;
		function removeGameObjectByName(_value:String):void;
		
		function getGameObjectByName(_value:String):IGameObject;
		
		function build():void;
		function update():void;
		function reset():void;
		function invalidate():void;
	}
}