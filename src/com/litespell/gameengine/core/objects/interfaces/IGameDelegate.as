package com.litespell.gameengine.core.objects.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IGameDelegate extends IEventDispatcher
	{
		function get ownerGame():IGame;
		function set ownerGame(_value:IGame):void;
		
		function onGameStart():void;
		function onGameReset():void;
		function onGamePause():void;
		
		function onGamePreUpdate():void;
		function onGamePostUpdate():void;
		
		function onComponentNotifiesMessage(_message:String, _component:IComponent, _data:* = null):void;
	}
}