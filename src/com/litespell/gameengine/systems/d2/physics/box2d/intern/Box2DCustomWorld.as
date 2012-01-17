package com.litespell.gameengine.systems.d2.physics.box2d.intern
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	
	import flash.utils.Dictionary;
	
	use namespace LSGE_INTERNAL;
	
	public class Box2DCustomWorld extends b2World
	{
		public function Box2DCustomWorld(gravity:b2Vec2, doSleep:Boolean)
		{
			super(gravity, doSleep);
		}
		
		public function addBodyInitializer(_bodyInitializer:Box2DBodyInitializer):void
		{
			var _body				:b2Body	= CreateBody(_bodyInitializer.bodyDef);
			var _fixtureDefCount	:uint	= _bodyInitializer.fixtureDefs.length;
			
			var _fixtureDef			:b2FixtureDef;
			var _fixture			:b2Fixture;
			
			for(var i:uint = 0; i < _fixtureDefCount; i++)
			{
				_fixtureDef					= _bodyInitializer.fixtureDefs[i];
				_fixture					= _body.CreateFixture(_fixtureDef);
				
				_bodyInitializer.setFixture(_fixtureDef, _fixture);
			}
			
			_bodyInitializer.m_body			= _body;
			
			_body.SetFixedRotation(_bodyInitializer.m_bodyDef.fixedRotation);
			
			if(_bodyInitializer.userData)
			{
				_body.SetUserData(_bodyInitializer.userData);
			}
		}
		
		public function removeBodyInitializer(_bodyInitializer:Box2DBodyInitializer):void
		{
			DestroyBody(_bodyInitializer.body);
			
			_bodyInitializer.m_body						= null;
			_bodyInitializer.m_fixtureByFixtureDef		= new Dictionary();
		}
	}
}