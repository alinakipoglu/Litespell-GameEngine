package com.litespell.gameengine.components.d2.physics.box2d.interfaces
{
	import com.litespell.gameengine.systems.d2.physics.box2d.intern.Box2DBodyInitializer;

	public interface IBox2DComponent
	{
		function get bodyInitializer():Box2DBodyInitializer;
	}
}