package com.litespell.gameengine.components.d2.physics.box2d
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractComponent;
	import com.litespell.gameengine.systems.d2.physics.box2d.Box2DSystem;
	
	import flash.geom.Point;
	
	use namespace LSGE_INTERNAL;
	
	public class Box2DComponent extends AbstractComponent
	{
		public static const COMPONENT_NAME	:String = "box2dComponent";
		
		[PropertyRef(ref = "spatialComponent.position2d")]
		public var position					:Point;
		
		[PropertyRef(ref = "spatialComponent.dimentions2d")]
		public var dimentions				:Point;
		
		[PropertyRef(ref = "spatialComponent.rotation2d")]
		public var rotation					:Number;
		
		public var body						:b2Body;
		
		LSGE_INTERNAL var m_bodyType		:uint;
		LSGE_INTERNAL var m_density			:Number;
		LSGE_INTERNAL var m_friction		:Number;
		LSGE_INTERNAL var m_restitution		:Number;
		LSGE_INTERNAL var m_fixedRotation	:Boolean;
		LSGE_INTERNAL var m_isBullet		:Boolean;
		LSGE_INTERNAL var m_isSensor		:Boolean;
		LSGE_INTERNAL var m_group			:uint;
		
		LSGE_INTERNAL var m_box2DSystem	:Box2DSystem;
		
		public function Box2DComponent(_bodyType:uint = 0, _density:Number = 1, _friction:Number = 1, _restitution:Number = 1, _fixedRotation:Boolean = false, _isBullet:Boolean = false, _isSensor:Boolean = false, _group:uint = 0)
		{
			super(COMPONENT_NAME);
			
			m_bodyType					= _bodyType;
			m_density					= _density;
			m_friction					= _friction;
			m_restitution				= _restitution;
			m_fixedRotation				= _fixedRotation;
			m_isBullet					= _isBullet;
			m_isSensor					= _isSensor;
			m_group						= _group;
		}
		
		override public function postBuild():void
		{
			super.postBuild();
			
			m_box2DSystem								= ownerGame.getSystemByName(Box2DSystem.SYSTEM_NAME) as Box2DSystem;
			
			var _bodyDef			:b2BodyDef			= new b2BodyDef();
			var _polyShape			:b2PolygonShape		= new b2PolygonShape();
			var _fixture			:b2Fixture;
			
			var _halfWidth			:Number				= dimentions.x * 0.5;
			var _halfHeight			:Number				= dimentions.y * 0.5;
			
			_bodyDef.type								= m_bodyType;
			
			_bodyDef.position.Set((position.x + _halfWidth) / m_box2DSystem.worldScale, (position.y + _halfHeight) / m_box2DSystem.worldScale);
			_polyShape.SetAsBox(_halfWidth / m_box2DSystem.worldScale, _halfHeight / m_box2DSystem.worldScale);
			
			body										= m_box2DSystem.world.CreateBody(_bodyDef);
			_fixture									= body.CreateFixture2(_polyShape);
			
			_fixture.SetDensity(m_density);
			_fixture.SetFriction(m_friction);
			_fixture.SetRestitution(m_restitution);
			_fixture.SetSensor(m_isSensor);
			
			body.SetBullet(m_isBullet);
			body.SetFixedRotation(m_fixedRotation);
			body.SetUserData(ownerGameObject);
		}
		
		override public function invalidate():void
		{
			super.invalidate();
			
			m_box2DSystem.world.DestroyBody(body);
		}
	}
}