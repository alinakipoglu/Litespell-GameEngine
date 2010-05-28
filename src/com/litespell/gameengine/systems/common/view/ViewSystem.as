package com.litespell.gameengine.systems.common.view
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractSystem;
	
	import flash.display.DisplayObject;
	
	use namespace LSGE_INTERNAL;
	
	public class ViewSystem extends AbstractSystem
	{
		public static const SYSTEM_NAME				:String = "VIEW_SYSTEM";
		public static const DEFAULT_TOP_LAYER		:String	= "DEFAULT_TOP_LAYER";
		public static const DEFAULT_BOTTOM_LAYER	:String	= "DEFAULT_BOTTOM_LAYER";
		
		LSGE_INTERNAL var m_viewport				:Viewport;
		
		public function ViewSystem(_viewportWidth:Number, _viewportHeight:Number)
		{
			super(SYSTEM_NAME);
			
			m_viewport				= new Viewport(_viewportWidth, _viewportHeight);

			m_viewport.createLayer(DEFAULT_BOTTOM_LAYER, -1);
			m_viewport.createLayer(DEFAULT_TOP_LAYER, 999999999);
		}
		
		public function get viewport():Viewport
		{
			return m_viewport;
		}

		public function addViewportLayer(_name:String, _index:uint):void
		{
			if(!m_viewport.containsLayerWithName(_name))
			{
				m_viewport.createLayer(_name, _index);
			}
		}
		
		public function removeViewportLayerByName(_name:String):void
		{
			m_viewport.removeLayer(_name);
		}
		
		
		public function addViewContent(_content:DisplayObject, _layerName:String):void
		{
			if(m_viewport.containsLayerWithName(_layerName))
			{
				m_viewport.addChildToLayer(_content, _layerName);
			}
		}
		
		public function removeViewContent(_content:DisplayObject):void
		{
			m_viewport.removeChildFromLayer(_content);
		}
	}
}