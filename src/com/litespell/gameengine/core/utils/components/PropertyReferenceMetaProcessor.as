package com.litespell.gameengine.core.utils.components
{
	import com.litespell.gameengine.core.objects.interfaces.IComponent;

	public class PropertyReferenceMetaProcessor
	{
		public static const REG_EX_PATTERN			:RegExp		= /\w+\.\w+/;
		
		public static var component					:IComponent;
		public static var propertyName				:String;
		public static var errorEncountered			:Boolean;
		
		public static function processPathElements(_component:IComponent, _path:String):void
		{
			component			= null;
			propertyName		= null;
			errorEncountered	= false;
			
			if(REG_EX_PATTERN.test(_path))
			{
				var _split		:Array		= _path.split(".");
				
				component					= _component.ownerGameObject.getComponentByName(_split[0]);
				propertyName				= _split[1];
				
				if(component && !Object(component).hasOwnProperty(propertyName))
				{
					errorEncountered		= true;
				}
			}
		}
	}
}