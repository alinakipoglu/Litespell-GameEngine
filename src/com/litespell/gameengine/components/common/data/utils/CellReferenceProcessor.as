package com.litespell.gameengine.components.common.data.utils
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	public class CellReferenceProcessor
	{
		private static const META_DATA_NAME	:String		= "SpreadSheetRef";
		private static const REF_KEY		:String		= "ref";
		
		private static var s_init			:Boolean	= initialize();
		private static var s_processByType	:Dictionary;
		private static var s_unvalidTypes	:Dictionary;
		
		public static function processObject(_object:Object):Dictionary
		{
			var _result						:Dictionary;
			
			var _class						:Class		= Object(_object).constructor as Class;
			
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
				_result									= new Dictionary();
				
				var _temporaryXML			:XML;
				var _propertyName			:String		= "";
				var _cellRef				:String		= "";
				var _vectorAssigmentCount	:uint		= 0;
				
				for(var i:uint = 0; i < _propertyCount; i++)
				{
					_temporaryXML			= _variablesHasValidMetaData[i];
					_propertyName			= _temporaryXML.@name;
					_cellRef				= _temporaryXML.metadata.(arg.@key.contains("ref")).arg.@value;
					
					_result[_cellRef]		= _propertyName;
				}
				
				return _result;
				
			} else {
				s_unvalidTypes[_class]		= true;
				
				return null;
			}
			
			return _result;
		}
		
		private static function initialize():Boolean
		{
			s_processByType		= new Dictionary();
			s_unvalidTypes		= new Dictionary();
			
			return true;
		}
	}
}