package com.litespell.gameengine.systems.d2.physics.box2d
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractSystem;
	import com.litespell.gameengine.core.objects.interfaces.IGameObject;
	import com.litespell.gameengine.systems.common.time.TimeInfo;
	import com.litespell.gameengine.systems.common.time.TimeSystem;
	
	use namespace LSGE_INTERNAL;
	
	public class Box2DSystem extends AbstractSystem
	{
		public static const SYSTEM_NAME			:String = "BOX2D_SYSTEM";
		
		public var worldScale					:Number;
		public var world						:b2World;
		
		LSGE_INTERNAL var m_gravityVector		:b2Vec2;
		LSGE_INTERNAL var m_contactListener		:Box2DContactListener;
		LSGE_INTERNAL var m_timeInfo			:TimeInfo;
		LSGE_INTERNAL var m_contact				:b2ContactEdge;
		
		public function Box2DSystem(_xGravity:Number = 0, _yGravity:Number = 9.81, _worldScale:Number = 30)
		{
			super(SYSTEM_NAME);
			
			m_requiresUpdate		= true;
			
			m_gravityVector			= new b2Vec2(_xGravity, _yGravity);
			m_contactListener		= new Box2DContactListener();
			worldScale				= _worldScale;
			
			world					= new b2World(m_gravityVector, true);
			
			world.SetContactListener(m_contactListener);
		}
		
		public function isFixtureColliding(_fixture:b2Fixture):Boolean
		{
			return m_contactListener.contactFixtures[_fixture];
		}
		
		public function isShapeColliding(_shape:b2Shape):Boolean
		{
			return m_contactListener.contactShapes[_shape];
		}
		
		public function isBodyColliding(_body:b2Body):Boolean
		{
			return m_contactListener.contactBodies[_body];
		}
		
		public function getBodyContacts(_body:b2Body, _result:Vector.<b2Body>):void
		{
			var _bodyCount	:uint	= 0;
			
			_result.length			= 0;
			m_contact				= _body.GetContactList();
			
			while(m_contact)
			{
				var _bodyA	:b2Body	= m_contact.contact.GetFixtureA().GetBody();
				var _bodyB	:b2Body	= m_contact.contact.GetFixtureB().GetBody();
				
				if(_bodyA != _body)
				{
					if(_result.indexOf(_bodyA) == -1)
					{
						_result[_bodyCount]	 = _bodyA;
						_bodyCount++;
					}
				}
				
				if(_bodyB != _body)
				{
					if(_result.indexOf(_bodyB) == -1)
					{
						_result[_bodyCount]	 = _bodyB;
						_bodyCount++;
					}
				}
				
				m_contact			= m_contact.next;
			}
		}
		
		public function getBodyContactsAsNode(_body:b2Body, _result:Vector.<IGameObject>):void
		{
			var _gameObjectCount	:uint	= 0;
			m_contact						= _body.GetContactList();
			
			while(m_contact)
			{
				var _bodyA	:b2Body			= m_contact.contact.GetFixtureA().GetBody();
				var _bodyB	:b2Body			= m_contact.contact.GetFixtureB().GetBody();
				
				var _nodeA	:IGameObject	= _bodyA.GetUserData() as IGameObject;
				var _nodeB	:IGameObject	= _bodyB.GetUserData() as IGameObject;
				
				if(_bodyA != _body && _nodeA)
				{
					if(_result.indexOf(_nodeA) == -1)
					{
						_result[_gameObjectCount]	 = _nodeA;
						
						_gameObjectCount++;
					}
				}
				
				if(_bodyB != _body && _nodeB)
				{
					if(_result.indexOf(_nodeB) == -1)
					{
						_result[_gameObjectCount]	 = _nodeB;
						
						_gameObjectCount++;
					}
				}
				
				m_contact			= m_contact.next;
			}
		}
		
		public function getGameObjectAtPoint(_point:b2Vec2):IGameObject
		{
			var _pointSize		:Number		= 0.002;
			var _pointSizeHalf	:Number		= _pointSize * 0.5;
			var _aabb			:b2AABB		= new b2AABB();
			var _result			:IGameObject;
			
			_aabb.lowerBound.Set(_point.x - _pointSizeHalf, _point.y - _pointSizeHalf);
			_aabb.upperBound.Set(_point.x + _pointSizeHalf, _point.y + _pointSizeHalf);
			
			function aabbWorldQueryCallback(_fixture:b2Fixture):Boolean
			{
				var _shape		:b2Shape	= _fixture.GetShape();
				var _inside		:Boolean	= _shape.TestPoint(_fixture.GetBody().GetTransform(), _point);
				
				if (_inside)
				{
					_result					= _fixture.GetBody().GetUserData() as IGameObject;
					
					return false;
				}
				
				return true;
			}
			
			world.QueryAABB(aabbWorldQueryCallback, _aabb);
			
			return _result;
		}
		
		public function raycast(_rayStart:b2Vec2, _rayEnd:b2Vec2):IGameObject
		{
			var _result	:IGameObject;
			
			function rayCastCallback(_fixture:b2Fixture, _point:b2Vec2, _normal:b2Vec2, _fraction:Number):Number
			{
				_result	= _fixture.GetBody().GetUserData() as IGameObject;
				
				return _fraction;
			}
			
			world.RayCast(rayCastCallback, _rayStart, _rayEnd);
			
			return _result;
		}
		
		public function processBodyContactRect(_body:b2Body, _result:Box2DContactSidesData):void
		{
			m_contact				= _body.GetContactList();
			
			_result.reset();
			
			while(m_contact)
			{
				var manifold		:b2Manifold	= m_contact.contact.GetManifold();
				var contactNormal	:b2Vec2		= manifold.m_localPlaneNormal;
				
				if(contactNormal.y < 0.5)
				{
					_result.top		= true;
				}
				
				if(contactNormal.x > 0.5)
				{
					_result.right	= true;
				}
				
				if(contactNormal.y > 0.5)
				{
					_result.bottom	= true;
				}
				
				if(contactNormal.x < -0.5)
				{
					_result.left	= true;
				}
				
				m_contact			= m_contact.next;
			}
		}
		
		override public function update():void
		{
			super.update();
			
			var _timeSystem	:TimeSystem	= m_ownerGame.getSystemByName(TimeSystem.SYSTEM_NAME) as TimeSystem;
			var _timeInfo	:TimeInfo	= _timeSystem.timeInfo;
				
			world.Step(1 / _timeInfo.frameRate * _timeInfo.delta, 1, 10);
			world.ClearForces();
		}
	}
}