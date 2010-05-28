package com.litespell.gameengine.components.common.view.interfaces
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public interface IViewComponent
	{
		function get container():Sprite;
		
		function get content():DisplayObject;
		function set content(_value:DisplayObject):void
	}
}