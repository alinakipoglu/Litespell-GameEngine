package com.litespell.gameengine.core.objects.interfaces
{
	public interface IGameObject
	{
		function get name():String;
		function get ownerGame():IGame;
		
		function get ownerWorld():IWorld;
		function set ownerWorld(_value:IWorld):void;
		
		function get builded():Boolean;
		
		function addComponent(_value:IComponent):void;
		
		function removeComponent(_value:IComponent):void;
		function removeComponentByName(_value:String):void;
		
		function getComponentByName(_value:String):IComponent;
		
		function onSelfAdd():void;
		function onSelfRemove():void;
		
		function build():void;
		function update():void;
		function reset():void;
		function invalidate():void;
	}
}