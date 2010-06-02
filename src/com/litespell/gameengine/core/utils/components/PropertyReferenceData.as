package com.litespell.gameengine.core.utils.components
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.interfaces.IComponent;
	
	use namespace LSGE_INTERNAL;
	
	public class PropertyReferenceData
	{
		LSGE_INTERNAL var m_owner					:IComponent;
		LSGE_INTERNAL var m_ownerProperty			:String;
		LSGE_INTERNAL var m_target					:IComponent;
		LSGE_INTERNAL var m_targetProperty			:String;
		LSGE_INTERNAL var m_requiresUpdate			:Boolean;
		LSGE_INTERNAL var m_initialUpdateApplied	:Boolean;
		
		public function PropertyReferenceData(_owner:IComponent, _ownerProperty:String, _target:IComponent, _targetProperty:String)
		{
			m_owner						= _owner;
			m_ownerProperty				= _ownerProperty;
			m_target					= _target;
			m_targetProperty			= _targetProperty;
			
			m_requiresUpdate			= isPropertyPrimitiveType();
		}
		
		public function get owner():IComponent
		{
			return m_owner;
		}
		
		public function get ownerProperty():String
		{
			return m_ownerProperty;
		}
		
		public function get target():IComponent
		{
			return m_target;
		}
		
		public function get targetProperty():String
		{
			return m_targetProperty;
		}
		
		public function get isValid():Boolean
		{
			return getOwnerValid() || getTargetValid();
		}
		
		public function get requiresUpdate():Boolean
		{
			if(!m_initialUpdateApplied)
			{
				m_initialUpdateApplied	= true;
				return true;
			}
			
			return m_requiresUpdate;
		}
		
		public function update():void
		{
			m_owner[m_ownerProperty] = m_target[m_targetProperty];
		}
		
		private function isPropertyPrimitiveType():Boolean
		{
			var _resolvedValue	:*	= m_owner[m_ownerProperty];
			
			if(_resolvedValue is Number || _resolvedValue is String || _resolvedValue is Boolean)
			{
				return true;
			}
			
			if(!_resolvedValue)
			{
				return true;
			}
			
			return false;
		}
		
		private function getOwnerValid():Boolean
		{
			return getObjectValid(m_owner, m_ownerProperty);
		}
		
		private function getTargetValid():Boolean
		{
			return getObjectValid(m_target, m_targetProperty);
		}
		
		private function getObjectValid(_object:Object, _property:String):Boolean
		{
			if(_object)
			{
				if(_object.hasOwnProperty(_property))
				{
					return true;
				}
			}
			
			return false;
		}
	}
}