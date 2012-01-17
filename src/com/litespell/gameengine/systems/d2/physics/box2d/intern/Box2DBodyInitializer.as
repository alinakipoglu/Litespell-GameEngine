package com.litespell.gameengine.systems.d2.physics.box2d.intern
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	
	import flash.utils.Dictionary;
	
	use namespace LSGE_INTERNAL;
	
	public class Box2DBodyInitializer
	{
		LSGE_INTERNAL var m_bodyDef				:b2BodyDef;
		LSGE_INTERNAL var m_fixtureDefs			:Vector.<b2FixtureDef>;
		LSGE_INTERNAL var m_body				:b2Body;
		LSGE_INTERNAL var m_fixtureByFixtureDef	:Dictionary;
		LSGE_INTERNAL var m_userData			:*;
		
		public function Box2DBodyInitializer(_bodyDef:b2BodyDef, _fixtureDefs:Vector.<b2FixtureDef>, _userData:* = null)
		{
			m_bodyDef				= _bodyDef;
			m_fixtureDefs			= _fixtureDefs;
			m_userData				= _userData;
			m_fixtureByFixtureDef	= new Dictionary();
		}

		public function get userData():*
		{
			return m_userData;
		}

		public function get bodyDef():b2BodyDef
		{
			return m_bodyDef;
		}
		
		public function get fixtureDefs():Vector.<b2FixtureDef>
		{
			return m_fixtureDefs;
		}
		
		public function get body():b2Body
		{
			return m_body;
		}

		public function getFixture(_fixtureDef:b2FixtureDef):b2Fixture
		{
			return m_fixtureByFixtureDef[_fixtureDef];
		}
		
		LSGE_INTERNAL function setFixture(_fixtureDef:b2FixtureDef, _fixture:b2Fixture):void
		{
			m_fixtureByFixtureDef[_fixtureDef]	= _fixture;
		}
	}
}