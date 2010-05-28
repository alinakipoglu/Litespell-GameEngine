package com.litespell.gameengine.components.d2.physics.box2d
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import com.litespell.gameengine.components.d2.spatial.SpatialComponent;
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractComponent;
	import com.litespell.gameengine.systems.d2.physics.box2d.Box2DSystem;
	
	use namespace LSGE_INTERNAL;
	
	public class Box2DMapper extends AbstractComponent
	{
		public static const COMPONENT_NAME	:String = "box2dMapperComponent";
		
		[PropertyRef(ref = "spatialComponent.self")]
		public var spatialComponent			:SpatialComponent;
		
		[PropertyRef(ref = "box2dComponent.body")]
		public var box2dBody				:b2Body;
		
		private var m_box2DSystem			:Box2DSystem;
		
		public function Box2DMapper()
		{
			super(COMPONENT_NAME);
			
			m_requiresUpdate	= true;
		}
		
		override public function preBuild():void
		{
			super.preBuild();
			
			m_box2DSystem					= ownerGame.getSystemByName(Box2DSystem.SYSTEM_NAME) as Box2DSystem;
		}
		
		override public function update():void
		{
			super.update();
			
			var box2Dposition:b2Vec2		= box2dBody.GetPosition();
			
			spatialComponent.position2d.x	= (box2Dposition.x - (spatialComponent.dimentions2d.x * 0.5) / m_box2DSystem.worldScale) * m_box2DSystem.worldScale;
			spatialComponent.position2d.y	= (box2Dposition.y - (spatialComponent.dimentions2d.y * 0.5) / m_box2DSystem.worldScale) * m_box2DSystem.worldScale
			spatialComponent.rotation2d		= (box2dBody.GetAngle() / Math.PI) * 180;
		}
	}
}