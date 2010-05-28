package com.litespell.gameengine.core.objects.interfaces
{
	public interface IComponent
	{
		function get name():String;
		function get self():IComponent;
		function get ownerWorld():IWorld;
		function get ownerGame():IGame;
		
		function get ownerGameObject():IGameObject;
		function set ownerGameObject(_value:IGameObject):void;

		function get requiresUpdate():Boolean;
		function set requiresUpdate(_value:Boolean):void;
		
		function onOwnerAdd():void;
		function onOwnerRemove():void;
		
		function onSelfAdd():void;
		function onSelfRemove():void;
		
		function preBuild():void;
		function postBuild():void;
		
		function update():void;
		function reset():void;
		function invalidate():void;
	}
}