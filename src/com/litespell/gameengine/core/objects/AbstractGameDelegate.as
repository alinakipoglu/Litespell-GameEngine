package com.litespell.gameengine.core.objects
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.interfaces.IComponent;
	import com.litespell.gameengine.core.objects.interfaces.IGame;
	import com.litespell.gameengine.core.objects.interfaces.IGameDelegate;
	
	use namespace LSGE_INTERNAL;
	
	public class AbstractGameDelegate implements IGameDelegate
	{
		LSGE_INTERNAL var m_ownerGame		:IGame;
		
		public function AbstractGameDelegate()
		{
		}
		
		public function get ownerGame():IGame
		{
			return m_ownerGame;
		}
		
		public function set ownerGame(_value:IGame):void
		{
			m_ownerGame	= _value;
		}
		
		public function onGameStart():void
		{
			// Override this function.
		}
		
		public function onGameReset():void
		{
			// Override this function.
		}
		
		public function onGamePause():void
		{
			// Override this function.
		}
		
		public function onGamePreUpdate():void
		{
			// Override this function.
		}
		
		public function onGamePostUpdate():void
		{
			// Override this function.
		}
		
		public function onComponentNotifiesMessage(_message:String, _component:IComponent, _data:*=null):void
		{
			// Override this function.
		}
	}
}