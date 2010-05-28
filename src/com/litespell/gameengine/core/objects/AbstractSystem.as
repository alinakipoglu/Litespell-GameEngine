package com.litespell.gameengine.core.objects
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.interfaces.IGame;
	import com.litespell.gameengine.core.objects.interfaces.ISystem;
	
	use namespace LSGE_INTERNAL;
	
	public class AbstractSystem implements ISystem
	{
		LSGE_INTERNAL var m_name				:String;
		LSGE_INTERNAL var m_ownerGame			:IGame;
		LSGE_INTERNAL var m_requiresUpdate		:Boolean;
		
		public function AbstractSystem(_name:String)
		{
			m_name		= _name;
		}
		
		public function get name():String
		{
			return m_name;
		}
		
		public function get ownerGame():IGame
		{
			return m_ownerGame;
		}
		
		public function set ownerGame(_value:IGame):void
		{
			m_ownerGame	= _value;
		}
		
		public function get requiresUpdate():Boolean
		{
			return m_requiresUpdate;
		}
		
		public function set requiresUpdate(_value:Boolean):void
		{
			m_requiresUpdate	= _value;
		}
		
		public function onSelfAdd():void
		{
			// Override this function.
		}
		
		public function onSelfRemove():void
		{
			// Override this function.
		}
		
		public function update():void
		{
			// Override this function.
		}
		
		public function reset():void
		{
			// Override this function.
		}
		
		public function invalidate():void
		{
			// Override this function.
		}
	}
}