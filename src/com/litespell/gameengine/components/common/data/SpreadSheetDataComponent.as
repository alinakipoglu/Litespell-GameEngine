package com.litespell.gameengine.components.common.data
{
	import com.litespell.gameengine.components.common.data.interfaces.IDataComponent;
	import com.litespell.gameengine.components.common.data.utils.CellReferenceProcessor;
	import com.litespell.gameengine.core.objects.AbstractComponent;
	
	import flash.utils.Dictionary;
	
	public class SpreadSheetDataComponent extends AbstractComponent implements IDataComponent
	{
		public function SpreadSheetDataComponent()
		{
			super(DataComponentName.NAME);
		}
		
		public function initWithSpreadSheetData(_data:XML):void
		{
			var _cellReferences	:Dictionary	= CellReferenceProcessor.processObject(this);
			var _xmlns			:Namespace	= new Namespace("_xmlns", "http://www.w3.org/2005/Atom");
			var _entries		:XMLList;
			var _propertyName	:String;
			var _propertyValue	:*;
			
			_data.addNamespace(_xmlns);
			
			_entries						= _data._xmlns::entry;
			
			for each(var _entry:XML in _entries)
			{
				_propertyName				= _cellReferences[_entry._xmlns::title.toString()];
				_propertyValue				= _entry._xmlns::content.toString();
				
				if(_propertyName && this.hasOwnProperty(_propertyName))
				{
					this[_propertyName]		= getVarialbeCast(_propertyValue);
				}
			}
		}
		
		protected function getVarialbeCast(_value:String):*
		{
			if(!isNaN(Number(_value)))
			{
				return Number(_value);
			} else if(_value.toLocaleLowerCase() == "true" || _value.toLocaleLowerCase() == "false"){
				return _value.toLocaleLowerCase() == "true";
			} else {
				return _value;
			}
		}
	}
}