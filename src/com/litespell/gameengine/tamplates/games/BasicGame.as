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
		
		// add all default subsystems
		// add getter and setters
	}
}