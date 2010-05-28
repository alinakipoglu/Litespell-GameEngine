package com.litespell.gameengine.tamplates.games
{
	import com.litespell.gameengine.core.objects.Game;
	import com.litespell.gameengine.core.objects.interfaces.IGameDelegate;
	import com.litespell.gameengine.systems.common.keyboard.KeyboardSystem;
	import com.litespell.gameengine.systems.common.mouse.MouseSystem;
	import com.litespell.gameengine.systems.common.time.TimeSystem;
	import com.litespell.gameengine.systems.common.view.ViewSystem;
	import com.litespell.gameengine.systems.d2.physics.box2d.Box2DSystem;
	
	import flash.display.Stage;

	public class BasicGame extends Game
	{
		private var m_viewSystem		:ViewSystem;
		private var m_timeSystem		:TimeSystem;
		private var m_keyboardSystem	:KeyboardSystem;
		private var m_box2DSystem		:Box2DSystem;
		private var m_mouseSystem		:MouseSystem;
		
		public function BasicGame()
		{
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

		public function addViewSystem(_viewportWidth:Number = 800, _viewportHeight:Number = 600, _createLayersInOrder:Vector.<String> = null):void
		{
			m_viewSystem		= new ViewSystem(_viewportWidth, _viewportHeight);
			
			if(_createLayersInOrder)
			{
				var _layerCount	:uint	= _createLayersInOrder.length;
				
				for(var i:uint = 0; i < _layerCount; i++)
				{
					m_viewSystem.addViewportLayer(_createLayersInOrder[i], i);
				}
			}
			
			addSystem(m_viewSystem);
		}
		
		public function addTimeSystem():void
		{
			m_timeSystem		= new TimeSystem();

			addSystem(m_timeSystem);
		}

		public function addKeyboardSystem(_stage:Stage):void
		{
			m_keyboardSystem	= new KeyboardSystem(_stage);

			addSystem(m_keyboardSystem);
		}

		public function addBox2dSystem(_xGravity:Number=0, _yGravity:Number=9.81, _worldScale:Number=30):void
		{
			m_box2DSystem		= new Box2DSystem(_xGravity, _yGravity, _worldScale);

			addSystem(m_box2DSystem);
		}
		
		public function addMouseSystem():void
		{
			if(m_viewSystem)
			{
				m_mouseSystem	= new MouseSystem(m_viewSystem);
				
				addSystem(m_mouseSystem);
			}
		}
	}
}