package com.litespell.gameengine.systems.d2.physics.box2d
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractSystem;
	import com.litespell.gameengine.systems.common.time.TimeInfo;
	import com.litespell.gameengine.systems.common.time.TimeSystem;
	import com.litespell.gameengine.systems.common.view.ViewSystem;
	import com.litespell.gameengine.systems.d2.physics.box2d.intern.Box2DBodyInitializer;
	import com.litespell.gameengine.systems.d2.physics.box2d.intern.Box2DCustomWorld;
	
	import flash.display.Sprite;
	
	use namespace LSGE_INTERNAL;
	
	public class Box2DSystem extends AbstractSystem
	{
		public static const SYSTEM_NAME			:String = "BOX2D_SYSTEM";
		
		public var world						:Box2DCustomWorld;
		
		LSGE_INTERNAL var m_gravityVector		:b2Vec2;
		LSGE_INTERNAL var m_timeInfo			:TimeInfo;
		LSGE_INTERNAL var m_contact				:b2ContactEdge;
		LSGE_INTERNAL var m_debug				:Boolean;
		LSGE_INTERNAL var m_debugSprite			:Sprite;
		LSGE_INTERNAL var m_box2dDebug			:b2DebugDraw;
		LSGE_INTERNAL var m_contactListener		:Box2DContactListener;
		
		public function Box2DSystem(_xGravity:Number = 0, _yGravity:Number = 9.81)
		{
			super(SYSTEM_NAME);
			
			m_requiresUpdate		= true;
			
			m_gravityVector			= new b2Vec2(_xGravity, _yGravity);
			
			world					= new Box2DCustomWorld(m_gravityVector, true);
			m_debugSprite			= new Sprite();
			m_box2dDebug			= new b2DebugDraw();
			
			m_contactListener		= new Box2DContactListener();
			
			m_box2dDebug.SetFlags(b2DebugDraw.e_shapeBit + b2DebugDraw.e_jointBit);
			m_box2dDebug.SetDrawScale(Box2DSystemDefaults.WORLD_SCALE);
			m_box2dDebug.SetSprite(m_debugSprite);
			m_box2dDebug.SetAlpha(0.5);
			
			m_debugSprite.alpha		= 0.5;
			
			m_box2dDebug.SetSprite(m_debugSprite);
			
			world.SetDebugDraw(m_box2dDebug);
			world.SetContactListener(m_contactListener);
		}
		
		public function get debug():Boolean
		{
			return m_debug;
		}

		public function set debug(value:Boolean):void
		{
			var _viewSystem	:ViewSystem	= m_ownerGame.getSystemByName(ViewSystem.SYSTEM_NAME) as ViewSystem;
			
			if(value && !m_debug)
			{
				_viewSystem.addViewContent(m_debugSprite, ViewSystem.DEFAULT_TOP_LAYER);
			} else {
				_viewSystem.removeViewContent(m_debugSprite);
			}
			
			m_debug = value;
		}

		public function addBox2DBodyInitializer(_bodyInitializer:Box2DBodyInitializer):void
		{
			world.addBodyInitializer(_bodyInitializer);
		}
		
		public function removeBox2DBodyInitializer(_bodyInitializer:Box2DBodyInitializer):void
		{
			world.removeBodyInitializer(_bodyInitializer);
		}
		
		public function getBodyColliding(_body:b2Body):Boolean
		{
			return m_contactListener.getBodyColliding(_body);
		}
		
		public function getBodyContactNormal(_body:b2Body):b2Vec2
		{
			return m_contactListener.getBodyContactNormal(_body);
		}
		
		public function getBodyContactPoint(_body:b2Body):b2Vec2
		{
			return m_contactListener.getBodyContactPoint(_body);
		}
		
		override public function update():void
		{
			super.update();
			
			var _timeSystem	:TimeSystem	= m_ownerGame.getSystemByName(TimeSystem.SYSTEM_NAME) as TimeSystem;
			var _timeInfo	:TimeInfo	= _timeSystem.timeInfo;
				
			world.Step(1 / _timeInfo.frameRate * _timeInfo.delta, 1, 10);
			world.ClearForces();
			
			if(m_debug)
			{
				world.DrawDebugData();
			}
		}
	}
}