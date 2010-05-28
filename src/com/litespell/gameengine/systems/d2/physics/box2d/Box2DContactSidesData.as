package com.litespell.gameengine.systems.d2.physics.box2d
{

	public class Box2DContactSidesData
	{
		public var left:Boolean;
		public var right:Boolean;
		public var top:Boolean;
		public var bottom:Boolean;

		public function Box2DContactSidesData()
		{
		}

		public function reset():void
		{
			left		=false;
			right		=false;
			top			=false;
			bottom		=false;
		}
	}
}