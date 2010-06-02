package com.litespell.gameengine.systems.d2.physics.box2d
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	
	import flash.utils.Dictionary;
	
	public class Box2DContactListener extends b2ContactListener
	{
		private var m_contactFixtures		:Dictionary;
		private var m_contactBodies			:Dictionary;
		private var m_normalDataByBody		:Dictionary;
		private var m_contactPointByBody	:Dictionary;
		
		public function Box2DContactListener()
		{
			m_contactFixtures		= new Dictionary();
			m_contactBodies			= new Dictionary();
			m_normalDataByBody		= new Dictionary();
			m_contactPointByBody	= new Dictionary();
		}
		
		override public virtual function BeginContact(_contact:b2Contact):void
		{
			var _nextContact	:b2Contact									= _contact;
			
			while(_nextContact)
			{
				m_contactFixtures[_nextContact.GetFixtureA()]				= true;
				m_contactFixtures[_nextContact.GetFixtureB()]				= true;
				
				m_contactBodies[_nextContact.GetFixtureA().GetBody()]		= true;
				m_contactBodies[_nextContact.GetFixtureB().GetBody()]		= true;
				
				m_normalDataByBody[_nextContact.GetFixtureA().GetBody()]	= _nextContact.GetManifold().m_localPlaneNormal;
				m_contactPointByBody[_nextContact.GetFixtureA().GetBody()]	= _nextContact.GetManifold().m_localPoint;
				
				_nextContact												= _nextContact.GetNext();
			}
		}
		
		override public virtual function EndContact(_contact:b2Contact):void
		{
			var _nextContact	:b2Contact								= _contact;
			
			while(_nextContact)
			{
				m_contactFixtures[_nextContact.GetFixtureA()]				= null;
				m_contactFixtures[_nextContact.GetFixtureB()]				= null;
				
				m_contactBodies[_nextContact.GetFixtureA().GetBody()]		= null;
				m_contactBodies[_nextContact.GetFixtureB().GetBody()]		= null;
				
				m_normalDataByBody[_nextContact.GetFixtureA().GetBody()]	= null;
				m_contactPointByBody[_nextContact.GetFixtureA().GetBody()]	= null;
				
				_nextContact												= _nextContact.GetNext();
			}
		}
		
		public function getBodyColliding(_body:b2Body):Boolean
		{
			return m_contactBodies[_body];
		}
		
		public function getBodyContactNormal(_body:b2Body):b2Vec2
		{
			return m_normalDataByBody[_body];
		}
		
		public function getBodyContactPoint(_body:b2Body):b2Vec2
		{
			return m_contactPointByBody[_body];
		}
	}
}