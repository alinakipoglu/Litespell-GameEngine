package com.litespell.gameengine.systems.common.view
{
	import com.litespell.gameengine.components.common.view.ViewComponent;
	import com.litespell.gameengine.components.common.view.interfaces.IViewComponent;
	import com.litespell.gameengine.core.objects.AbstractSystem;
	
	public class ViewSystem extends AbstractSystem
	{
		public static const SYSTEM_NAME			:String = "VIEW_SYSTEM";
		public static const DEFAULT_TOP_LAYER	:String	= "DEFAULT_TOP_LAYER";
		
		private var m_viewport					:Viewport;
		private var m_viewComponents			:Vector.<IViewComponent>;
		
		
		public function ViewSystem(_viewportWidth:Number, _viewportHeight:Number)
		{
			super(SYSTEM_NAME);
			
			requiresUpdate			= true;
			
			m_viewport				= new Viewport(_viewportWidth, _viewportHeight);
			m_viewComponents		= new Vector.<IViewComponent>();
			
			addViewportLayer(DEFAULT_TOP_LAYER, 999999999);
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
		
		public function addViewComponent(_viewComponent:IViewComponent, _layerName:String):void
		{
			if(m_viewport.containsLayerWithName(_layerName))
			{
				m_viewport.addChildToLayer(_viewComponent.container, _layerName);
				
				m_viewComponents[m_viewComponents.length]	= _viewComponent;
			}
		}
		
		public function removeViewportLayerByName(_name:String):void
		{
			m_viewport.removeLayer(_name);
		}
		
		public function removeViewComponent(_viewComponent:IViewComponent):void
		{
			m_viewport.removeChildFromLayer(_viewComponent.container);
			
			var _viewComponentIndex	:uint	= m_viewComponents.indexOf(_viewComponent);
			
			if(_viewComponentIndex != -1)
			{
				m_viewComponents.splice(_viewComponentIndex, 1);
			}
		}
		
		override public function update():void
		{
			var _viewComponentsCount	:uint		= m_viewComponents.length;
			var _viewComponent			:IViewComponent;
			
			for(var i:uint = 0; i < _viewComponentsCount; i++)
			{
				_viewComponent						= m_viewComponents[i]; 
				_viewComponent.container.x			= _viewComponent.position.x;
				_viewComponent.container.y			= _viewComponent.position.y;
				_viewComponent.container.rotation	= _viewComponent.rotation;
			}
		}
	}
}