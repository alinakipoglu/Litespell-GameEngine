package com.litespell.gameengine.systems.d2.physics.box2d
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactResult;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	
	import flash.utils.Dictionary;
	
	public class Box2DContactListener extends b2ContactListener
	{
		public var contactFixtures		:Dictionary;
		public var contactShapes		:Dictionary;
		public var contactBodies		:Dictionary;
		
		public function Box2DContactListener()
		{
			contactFixtures							= new Dictionary();
			contactShapes							= new Dictionary();
			contactBodies							= new Dictionary();
		}
		
		override public virtual function BeginContact(contact:b2Contact):void
		{
			var _fixtureA	:b2Fixture				= contact.GetFixtureA();
			var _fixtureB	:b2Fixture				= contact.GetFixtureB();
			
			var _shapeA		:b2Shape				= _fixtureA.GetShape();
			var _shapeB		:b2Shape				= _fixtureB.GetShape();
			
			var _bodyA		:b2Body					= _fixtureA.GetBody();
			var _bodyB		:b2Body					= _fixtureB.GetBody();
			
			contactFixtures[_fixtureA]				= true;
			contactFixtures[_fixtureB]				= true;
			
			contactShapes[_shapeA]					= true;
			contactShapes[_shapeB]					= true;
			
			contactBodies[_bodyA]					= true;
			contactBodies[_bodyB]					= true;
		}	
		
		override public virtual function EndContact(contact:b2Contact):void
		{
			var _fixtureA	:b2Fixture				= contact.GetFixtureA();
			var _fixtureB	:b2Fixture				= contact.GetFixtureB();
			
			var _shapeA		:b2Shape				= _fixtureA.GetShape();
			var _shapeB		:b2Shape				= _fixtureB.GetShape();
			
			var _bodyA		:b2Body					= _fixtureA.GetBody();
			var _bodyB		:b2Body					= _fixtureB.GetBody();
			
			contactFixtures[_fixtureA]				= false;
			contactFixtures[_fixtureB]				= false;
			
			contactShapes[_shapeA]					= false;
			contactShapes[_shapeB]					= false;
			
			contactBodies[_bodyA]					= false;
			contactBodies[_bodyB]					= false;
		}
		
		override public virtual function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
		}
		
		override public virtual function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
		{
		}
	}
}