package com.litespell.gameengine.systems.common.view.intern
{
	import flash.display.Sprite;

	public class LayerIndexData
	{
		public var index		:uint;
		public var layer		:Sprite;
		
		public function LayerIndexData(_index:uint, _layer:Sprite)
		{
			index		= _index;
			layer		= _layer;
		}
		
		public function toString():String
		{
			return index.toString();
		}
	}
}