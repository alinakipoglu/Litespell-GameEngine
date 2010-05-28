package com.litespell.gameengine.core.objects
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.interfaces.IGame;
	import com.litespell.gameengine.core.objects.interfaces.IGameObject;
	import com.litespell.gameengine.core.objects.interfaces.IWorld;
	
	import flash.utils.Dictionary;
	
	use namespace LSGE_INTERNAL;
	
	public class World implements IWorld
	{
		LSGE_INTERNAL var m_ownerGame							:IGame;
		LSGE_INTERNAL var m_gameObjects							:Vector.<IGameObject>;
		LSGE_INTERNAL var m_gameObjectByName					:Dictionary;
		LSGE_INTERNAL var m_removedGameObjectCountDuringUpdate	:uint;
		LSGE_INTERNAL var m_updating							:Boolean;
		
		public function World()
		{
			init();
		}
		
		public function get ownerGame():IGame
		{
			return m_ownerGame;
		}
		
		public function set ownerGame(_value:IGame):void
		{
			m_ownerGame		= _value;
		}
		
		public function addGameObject(_value:IGameObject):void
		{
			if(_value.ownerWorld)
			{
				_value.ownerWorld.removeGameObject(_value);
			}
			
			if(m_gameObjects.indexOf(_value) == -1)
			{
				m_gameObjects[m_gameObjects.length]	= _value;
			}
			
			m_gameObjectByName[_value.name]			= _value;
			_value.ownerWorld						= this;
			
			_value.onSelfAdd();
		}
		
		public function removeGameObject(_value:IGameObject):void
		{
			var _gameObjectIndex		:int	= m_gameObjects.indexOf(_value);
			
			if(_gameObjectIndex != -1)
			{
				_value.onSelfRemove();
				
				m_gameObjects.splice(_gameObjectIndex, 1);
				
				m_gameObjectByName[_value.name]	= null;
				_value.ownerWorld				= null;
				
				if(m_updating)
				{
					m_removedGameObjectCountDuringUpdate++;
				}
			}
		}
		
		public function removeGameObjectByName(_value:String):void
		{
			var _gameObject		:IGameObject	= m_gameObjectByName[_value];
			
			if(_gameObject)
			{
				removeGameObject(_gameObject);
			}
		}
		
		public function getGameObjectByName(_value:String):IGameObject
		{
			return m_gameObjectByName[_value];
		}
		
		public function build():void
		{
			var _gameObjectCount	:uint	= m_gameObjects.length;
			
			for(var i:uint = 0; i < _gameObjectCount; i++)
			{
				m_gameObjects[i].build();
			}
		}
		
		public function update():void
		{
			m_updating								= true;
			
			var _gameObjectCount	:uint	= m_gameObjects.length;
			
			for(var i:uint = 0; i < _gameObjectCount; i++)
			{
				m_gameObjects[i - m_removedGameObjectCountDuringUpdate].update();
			}
			
			m_removedGameObjectCountDuringUpdate	= 0;
			m_updating								= false;
		}
		
		public function reset():void
		{
			var _gameObjectCount	:uint	= m_gameObjects.length;
			
			for(var i:uint = 0; i < _gameObjectCount; i++)
			{
				m_gameObjects[i].reset();
			}
		}
		
		public function invalidate():void
		{
			var _gameObjectCount	:uint	= m_gameObjects.length;
			
			for(var i:uint = 0; i < _gameObjectCount; i++)
			{
				m_gameObjects[i].invalidate();
				
				m_gameObjectByName[m_gameObjects[i].name]	= null;
			}
			
			m_gameObjects.length	= 0;
		}
		
		private function init():void
		{
			m_gameObjects		= new Vector.<IGameObject>();
			m_gameObjectByName	= new Dictionary();
		}
	}
}