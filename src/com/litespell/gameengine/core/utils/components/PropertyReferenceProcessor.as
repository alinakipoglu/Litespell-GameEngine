package com.litespell.gameengine.core.utils.components
{
	import com.litespell.gameengine.core.objects.interfaces.IComponent;
	
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	public class PropertyReferenceProcessor
	{
		private static const META_DATA_NAME	:String		= "PropertyRef";
		private static const REF_KEY		:String		= "ref";
		
		private static var s_init			:Boolean	= initialize();
		private static var s_processByType	:Dictionary;
		private static var s_unvalidTypes	:Dictionary;
		
		public static function process(_component:IComponent):Vector.<PropertyReferenceData>
		{
			var _result						:Vector.<PropertyReferenceData>;
			var _class						:Class		= Object(_component).constructor as Class;
			
			if(s_unvalidTypes[_class])
			{
				return null;
			}
			
			var _variablesHasValidMetaData	:XMLList	= s_processByType[_class];
			
			if(!_variablesHasValidMetaData)
			{
				var _typeDescription 		:XML		= describeType(_class);
				_variablesHasValidMetaData				= _typeDescription..variable.(	metadata &&
																						metadata.@name.contains(META_DATA_NAME) &&
																						metadata.arg.@key.contains(REF_KEY));
				s_processByType[_class]					= _variablesHasValidMetaData;
			}
			
			
			var _propertyCount				:uint		= _variablesHasValidMetaData.length();
			
			if(_propertyCount)
			{
				_result									= new Vector.<PropertyReferenceData>();
				
				var _temporaryXML			:XML;
				var _propertyName			:String		= "";
				var _propertyRef			:String		= "";
				var _vectorAssigmentCount	:uint		= 0;
				
				for(var i:uint = 0; i < _propertyCount; i++)
				{
					_temporaryXML	= _variablesHasValidMetaData[i];
					_propertyName	= _temporaryXML.@name;
					_propertyRef	= _temporaryXML.metadata.(arg.@key.contains("ref")).arg.@value;
					
					PropertyReferenceMetaProcessor.processPathElements(_component, _propertyRef);
					
					if(!PropertyReferenceMetaProcessor.errorEncountered)
					{
						var _referance		:PropertyReferenceData	= new PropertyReferenceData(	_component,
																									_propertyName, 
																									PropertyReferenceMetaProcessor.component, 
																									PropertyReferenceMetaProcessor.propertyName);
						if(_referance.isValid)
						{
							_result[_vectorAssigmentCount]			= _referance;
							_vectorAssigmentCount++;
						}
					}
				}
				
				return _result;
				
			} else {
				s_unvalidTypes[_class]	= true;
				
				return null;
			}
			
			return null;
		}
		
		private static function initialize():Boolean
		{
			s_processByType		= new Dictionary();
			s_unvalidTypes		= new Dictionary();
			
			return true;
		}
	}
}