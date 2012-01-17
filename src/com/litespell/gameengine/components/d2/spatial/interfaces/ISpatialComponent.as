package com.litespell.gameengine.components.d2.spatial.interfaces
{
	import flash.geom.Point;

	public interface ISpatialComponent
	{
		function get dimentions2d():Point;
		function set dimentions2d(value:Point):void;
		
		function get position2d():Point;
		function set position2d(value:Point):void;
		
		function get rotation2d():Number;
		function set rotation2d(value:Number):void;
	}
}