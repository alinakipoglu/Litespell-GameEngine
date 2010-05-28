package com.litespell.gameengine.core.utils.components
{
	import com.litespell.gameengine.core.objects.interfaces.IComponent;
	
	import flash.utils.Dictionary;

	public class UpdateSorter
	{
		private static var s_initialize					:Boolean		= staticInitializer();
		
		private static var s_proccessFlagByComponent	:Dictionary;
		private static var s_addCount					:uint;
		
		public static function sort(_components:Vector.<IComponent>, _propertyReferenceDictionary:Dictionary, _result:Vector.<IComponent>):void
		{
			var _componentCount		:uint	= _components.length;
			
			for(var i:uint = 0; i < _componentCount; i++)
			{
				process(_components[i], _propertyReferenceDictionary, _result);
			}
			
			s_addCount						= 0;
			
			for(var j:uint = 0; j < _componentCount; j++)
			{
				s_proccessFlagByComponent[_components[j]]	= null;
			}
		}
		
		private static function process(_component:IComponent, _propertyReferenceDictionary:Dictionary,  _result:Vector.<IComponent>):void
		{
			var _propertyReferances		:Vector.<PropertyReferenceData>;
			var _propertyReferanceCount	:uint			= 0;
			var _referanceComponent			:IComponent;
			
			if(!s_proccessFlagByComponent[_component])
			{
				s_proccessFlagByComponent[_component]	= true;
				
				_propertyReferances						= _propertyReferenceDictionary[_component];
				
				if(_propertyReferances)
				{
					_propertyReferanceCount				= _propertyReferances.length;
					
					if(_propertyReferanceCount > 0)
					{
						for(var i:uint = 0; i < _propertyReferanceCount; i++)
						{
							_referanceComponent			= _propertyReferances[i].target;
							
							process(_referanceComponent, _propertyReferenceDictionary, _result);
						}
					}
				}
				
				_result[s_addCount]						= _component;
				s_addCount++;
			}
		}
		
		private static function staticInitializer():Boolean
		{
			s_proccessFlagByComponent	= new Dictionary();
			s_addCount					= 0;
			
			return true;
		}
	}
}