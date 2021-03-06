package com.litespell.gameengine.components.common.view
{
	import com.litespell.gameengine.components.common.view.interfaces.IViewComponent;
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractComponent;
	import com.litespell.gameengine.core.objects.interfaces.ISystem;
	import com.litespell.gameengine.systems.common.view.ViewSystem;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	use namespace LSGE_INTERNAL;
	
	public class ViewComponent extends AbstractComponent implements IViewComponent
	{
		LSGE_INTERNAL var m_content				:DisplayObject;
		LSGE_INTERNAL var m_container			:Sprite; 
		LSGE_INTERNAL var m_layerName			:String;
		LSGE_INTERNAL var m_added				:Boolean;
		
		public function ViewComponent(_layerName:String, _customName:String = null)
		{
			super(_customName ? _customName : ViewComponentName.NAME);
			
			m_layerName		= _layerName;
			m_container		= new Sprite();
		}
		
		public function get container():Sprite
		{
			return m_container;
		}
		
		public function get content():DisplayObject
		{
			return m_content;
		}
		
		public function set content(_value:DisplayObject):void
		{
			if(m_content)
			{
				m_container.removeChild(m_content);
			}
			
			m_content	= _value;
			
			m_container.addChild(m_content);
		}
		
		override public function postBuild():void
		{
			super.postBuild();
			
			tryToAddSelfToViewSystem();
		}
		
		override public function onOwnerAdd():void
		{
			super.onOwnerAdd();
			
			tryToAddSelfToViewSystem();
		}
		
		override public function onOwnerRemove():void
		{
			super.onOwnerRemove();
			
			tryToRemoveSelfFromViewSystem();
		}
		
		override public function onSelfAdd():void
		{
			super.onSelfAdd();
			
			tryToAddSelfToViewSystem();
		}
		
		override public function onSelfRemove():void
		{
			super.onSelfRemove();
			
			tryToRemoveSelfFromViewSystem();
		}
		
		protected function tryToAddSelfToViewSystem():void
		{
			if(!m_added)
			{
				var _viewSystem	:ViewSystem	= getViewSystem();
				
				if(_viewSystem)
				{
					_viewSystem.addViewContent(m_container, m_layerName);
					
					m_added	= true;
				}
			}
		}
		
		protected function tryToRemoveSelfFromViewSystem():void
		{
			if(m_added)
			{
				var _viewSystem	:ViewSystem	= getViewSystem();
				
				if(_viewSystem)
				{
					_viewSystem.removeViewContent(m_container);
					
					m_added	= false;
				}
			}
		}
		
		private function getViewSystem():ViewSystem
		{
			if(ownerGame)
			{
				var _viewSystem	:ISystem	= ownerGame.getSystemByName(ViewSystem.SYSTEM_NAME);
				
				if(_viewSystem)
				{
					return ViewSystem(_viewSystem);
				}
			}
			
			return null;
		}
	}
}