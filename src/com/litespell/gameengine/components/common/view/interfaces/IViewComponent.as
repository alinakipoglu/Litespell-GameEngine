package com.litespell.gameengine.components.common.view.interfaces
{
	import com.litespell.gameengine.core.objects.interfaces.IComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;

	public interface IViewComponent extends IComponent
	{
		function get container():Sprite;
		
		function get position():Point;
		function get dimentions():Point;
		function get rotation():Number;

		function get content():DisplayObject;
		function set content(_value:DisplayObject):void;
	}
}