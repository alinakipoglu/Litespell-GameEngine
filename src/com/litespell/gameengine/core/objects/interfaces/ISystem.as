package com.litespell.gameengine.core.objects.interfaces
{
	public interface ISystem
	{
		function get name():String;
		
		function get ownerGame():IGame;
		function set ownerGame(_value:IGame):void;
		
		function get requiresUpdate():Boolean;
		function set requiresUpdate(_value:Boolean):void;
		
		function onSelfAdd():void;
		function onSelfRemove():void;
		
		function update():void;
		function reset():void;
		function invalidate():void;
	}
}