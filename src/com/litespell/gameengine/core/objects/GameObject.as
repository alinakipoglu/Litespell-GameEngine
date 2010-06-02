package com.litespell.gameengine.core.objects
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.interfaces.IComponent;
	import com.litespell.gameengine.core.objects.interfaces.IGame;
	import com.litespell.gameengine.core.objects.interfaces.IGameObject;
	import com.litespell.gameengine.core.objects.interfaces.IWorld;
	import com.litespell.gameengine.core.utils.components.PropertyReferenceData;
	import com.litespell.gameengine.core.utils.components.PropertyReferenceProcessor;
	import com.litespell.gameengine.core.utils.components.UpdateSorter;
	
	import flash.utils.Dictionary;
	
	use namespace LSGE_INTERNAL;
	
	public class GameObject implements IGameObject
	{
		
		LSGE_INTERNAL var m_name								:String;
		LSGE_INTERNAL var m_ownerGame							:IGame;
		LSGE_INTERNAL var m_ownerWorld							:IWorld;
		LSGE_INTERNAL var m_components							:Vector.<IComponent>;
		LSGE_INTERNAL var m_sortedComponentsList				:Vector.<IComponent>;
		LSGE_INTERNAL var m_propertyReferenceDataByComponent	:Dictionary;
		LSGE_INTERNAL var m_componentByName						:Dictionary;
		
		public function GameObject(_name:String)
		{
			m_name		= _name;
			
			init();
		}
		
		public function get name():String
		{
			return m_name;
		}
		
		public function get ownerGame():IGame
		{
			return m_ownerGame;
		}
		
		public function get ownerWorld():IWorld
		{
			return m_ownerWorld;
		}
		
		public function set ownerWorld(_value:IWorld):void
		{
			m_ownerWorld	= _value;
		}
		
		public function addComponent(_value:IComponent):void
		{
			if(_value.ownerGameObject)
			{
				_value.ownerGameObject.removeComponent(_value);
			}
			
			if(m_components.indexOf(_value) == -1)
			{
				m_components[m_components.length]	= _value;
			}
			
			m_componentByName[_value.name]			= _value;
			_value.ownerGameObject					= this;
			
			_value.onSelfAdd();
		}
		
		public function removeComponent(_value:IComponent):void
		{
			var _componentIndex	:int	= m_components.indexOf(_value);
			
			if(_componentIndex != -1)
			{
				_value.onSelfRemove();
				
				m_components.splice(_componentIndex, 1);
				
				m_componentByName[_value.name]	= null;
				_value.ownerGameObject			= null;
			}
		}
		
		public function removeComponentByName(_value:String):void
		{
			var _component		:IComponent		= m_componentByName[_value];
			
			if(_component)
			{
				removeComponent(_component);
			}
		}
		
		public function getComponentByName(_value:String):IComponent
		{
			return m_componentByName[_value];
		}
		
		public function onSelfAdd():void
		{
			m_ownerGame	= m_ownerWorld.ownerGame;
			
			var _componentCount		:uint	= m_components.length;
			var _component			:IComponent;
			
			for(var i:uint = 0; i < _componentCount; i++)
			{
				_component	= m_components[i];
				
				_component.onOwnerAdd();
			}
		}
		
		public function onSelfRemove():void
		{
			var _componentCount		:uint	= m_components.length;
			var _component			:IComponent;
			
			for(var i:uint = 0; i < _componentCount; i++)
			{
				_component	= m_components[i];
				
				_component.onOwnerRemove();
			}
			
			m_ownerGame							= null;
		}
		
		public function build():void
		{
			var _componentCount			:uint	= m_components.length;
			var _component				:IComponent;
			
			var _propertyReferences		:Vector.<PropertyReferenceData>;
			var _propertyRefCount		:uint;
			var _propertyRef			:PropertyReferenceData;
			
			for(var i:uint; i < _componentCount; i++)
			{
				_component	= m_components[i];
				
				m_propertyReferenceDataByComponent[_component]	= PropertyReferenceProcessor.process(_component);
			}
			
			UpdateSorter.sort(m_components, m_propertyReferenceDataByComponent, m_sortedComponentsList);
			
			for(var j:uint = 0; j < _componentCount; j++)
			{
				_component				= m_sortedComponentsList[j];
				
				_component.preBuild();
				
				_propertyReferences		= m_propertyReferenceDataByComponent[_component]
				
				if(_propertyReferences)
				{
					_propertyRefCount	= _propertyReferences.length;
					
					for(var u:uint = 0; u < _propertyRefCount; u++)
					{
						_propertyRef	= _propertyReferences[u];
						
						_propertyRef.update();
					}
				}
					
				_component.postBuild();
			}
		}
		
		public function update():void
		{
			var _componentCount		:uint	= m_components.length;
			var _component			:IComponent;
			
			var _propertyRefDatas	:Vector.<PropertyReferenceData>;
			var _propertyRefCount	:uint;
			var _propertyRef		:PropertyReferenceData;
			
			for(var i:uint = 0; i < _componentCount; i++)
			{
				_component			= m_sortedComponentsList[i];
				_propertyRefDatas	= m_propertyReferenceDataByComponent[_component];
				
				if(_component.requiresUpdate)
				{
					if(_propertyRefDatas)
					{
						_propertyRefCount	= _propertyRefDatas.length;
						
						for(var j:uint = 0; j < _propertyRefCount; j++)
						{
							_propertyRef	= _propertyRefDatas[j];
							
							if(_propertyRef.requiresUpdate)
							{
								_propertyRef.update();
							}
						}
					}
					
					_component.update();
				}
			}
		}
		
		public function reset():void
		{
			var _componentCount		:uint	= m_components.length;
			var _component			:IComponent;
			
			for(var i:uint = 0; i < _componentCount; i++)
			{
				m_sortedComponentsList[i].reset();
			}
		}
		
		public function invalidate():void
		{
			m_ownerGame		= null;
			m_ownerWorld	= null;
			
			var _componentCount		:uint	= m_components.length;
			var _component			:IComponent;
			
			for(var i:uint = 0; i < _componentCount; i++)
			{
				_component	= m_sortedComponentsList[i];
				
				m_componentByName[_component.name]				= null;
				m_propertyReferenceDataByComponent[_component]	= null;
				
				_component.invalidate();
			}
			
			m_components.length				= 0;
			m_sortedComponentsList.length	= 0;
		}
		
		private function init():void
		{
			m_components						= new Vector.<IComponent>();
			m_sortedComponentsList				= new Vector.<IComponent>();
			m_componentByName					= new Dictionary();
			m_propertyReferenceDataByComponent	= new Dictionary();
		}
	}
}