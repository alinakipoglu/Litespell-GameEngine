package com.litespell.gameengine.systems.d2.physics.box2d.utils
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;

	public class Box2DUtils
	{
		public static function processBodyContactRect(_body:b2Body, _result:Box2DContactSidesData):void
		{
			var m_contact			:b2ContactEdge	= _body.GetContactList();
			
			_result.reset();
			
			while(m_contact)
			{
				var manifold		:b2Manifold		= m_contact.contact.GetManifold();
				var contactNormal	:b2Vec2			= manifold.m_localPlaneNormal;
				
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
		
		public static function raycast(_world:b2World, _rayStart:b2Vec2, _rayEnd:b2Vec2):b2Body
		{
			var _result	:b2Body;
			
			function rayCastCallback(_fixture:b2Fixture, _point:b2Vec2, _normal:b2Vec2, _fraction:Number):Number
			{
				_result	= _fixture.GetBody();
				
				return _fraction;
			}
			
			_world.RayCast(rayCastCallback, _rayStart, _rayEnd);
			
			return _result;
		}
	}
}