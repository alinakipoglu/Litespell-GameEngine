package com.litespell.gameengine.core.objects
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.interfaces.IComponent;
	import com.litespell.gameengine.core.objects.interfaces.IGame;
	import com.litespell.gameengine.core.objects.interfaces.IGameObject;
	import com.litespell.gameengine.core.objects.interfaces.IWorld;
	
	use namespace LSGE_INTERNAL;
	
	public class AbstractComponent implements IComponent
	{
		LSGE_INTERNAL var m_name			:String;
		LSGE_INTERNAL var m_ownerWorld		:IWorld;
		LSGE_INTERNAL var m_ownerGame		:IGame;
		LSGE_INTERNAL var m_ownerGameObject	:IGameObject;
		LSGE_INTERNAL var m_requiresUpdate	:Boolean;
		
		public function AbstractComponent(_name:String)
		{
			m_name		= _name;
		}
		
		public function get name():String
		{
			return m_name;
		}
		
		public function get self():IComponent
		{
			return this;
		}
		
		public function get ownerWorld():IWorld
		{
			return m_ownerWorld;
		}
		
		public function get ownerGame():IGame
		{
			return m_ownerGame;
		}
		
		public function get ownerGameObject():IGameObject
		{
			return m_ownerGameObject;
		}
		
		public function set ownerGameObject(_value:IGameObject):void
		{
			m_ownerGameObject	= _value;
		}
		
		public function get requiresUpdate():Boolean
		{
			return m_requiresUpdate;
		}
		
		public function set requiresUpdate(_value:Boolean):void
		{
			m_requiresUpdate	= _value;
		}
		
		public function preBuild():void
		{
			// Override this function.
		}
		
		public function postBuild():void
		{
			// Override this function.
		}
		
		public function onOwnerAdd():void
		{
			updateOwners();
		}
		
		public function onOwnerRemove():void
		{
		}
		
		public function onSelfAdd():void
		{
			updateOwners();
		}
		
		public function onSelfRemove():void
		{
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
			m_ownerWorld		= null;
			m_ownerGame			= null;
			m_ownerGameObject	= null;
		}
		
		private function updateOwners():void
		{
			m_ownerWorld	= m_ownerGameObject.ownerWorld;
			m_ownerGame		= m_ownerGameObject.ownerGame;
		}
	}
}