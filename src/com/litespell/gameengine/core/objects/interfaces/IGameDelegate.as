package com.litespell.gameengine.core.objects.interfaces
{
	public interface IGameDelegate
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