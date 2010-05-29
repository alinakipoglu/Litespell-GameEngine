package com.litespell.gameengine.tamplates.games
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.Game;
	import com.litespell.gameengine.core.objects.interfaces.IGameDelegate;
	import com.litespell.gameengine.systems.common.keyboard.KeyboardSystem;
	import com.litespell.gameengine.systems.common.mouse.MouseSystem;
	import com.litespell.gameengine.systems.common.time.TimeSystem;
	import com.litespell.gameengine.systems.common.view.ViewSystem;
	import com.litespell.gameengine.systems.d2.physics.box2d.Box2DSystem;
	
	import flash.display.Stage;

	use namespace LSGE_INTERNAL;
	
	public class BasicGame extends Game
	{
		LSGE_INTERNAL var m_viewSystem		:ViewSystem;
		LSGE_INTERNAL var m_timeSystem		:TimeSystem;
		LSGE_INTERNAL var m_keyboardSystem	:KeyboardSystem;
		LSGE_INTERNAL var m_box2DSystem		:Box2DSystem;
		LSGE_INTERNAL var m_mouseSystem		:MouseSystem;
		
		LSGE_INTERNAL var m_stage			:Stage;
		LSGE_INTERNAL var m_viewportWidth	:Number;
		LSGE_INTERNAL var m_viewportHeight	:Number;
		
		public function BasicGame(_stage:Stage, _viewportWidth:Number = 800, _viewportHeight:Number = 600)
		{
			m_stage				= _stage;
			m_viewportWidth		= _viewportWidth;
			m_viewportHeight	= _viewportHeight;
			
			init();
		}

		public function get mouseSystem():MouseSystem
		{
			return m_mouseSystem;
		}

		public function get box2DSystem():Box2DSystem
		{
			return m_box2DSystem;
		}

		public function get keyboardSystem():KeyboardSystem
		{
			return m_keyboardSystem;
		}

		public function get timeSystem():TimeSystem
		{
			return m_timeSystem;
		}

		public function get viewSystem():ViewSystem
		{
			return m_viewSystem;
		}
		
		protected function init():void
		{
			m_viewSystem		= new ViewSystem(m_viewportWidth, m_viewportHeight);
			m_timeSystem		= new TimeSystem();
			m_keyboardSystem	= new KeyboardSystem(m_stage);
			m_mouseSystem		= new MouseSystem(m_viewSystem);
			m_box2DSystem		= new Box2DSystem();
			
			addSystem(m_viewSystem);
			addSystem(m_timeSystem);
			addSystem(m_keyboardSystem);
			addSystem(m_mouseSystem);
			addSystem(m_box2DSystem);
		}
	}
}