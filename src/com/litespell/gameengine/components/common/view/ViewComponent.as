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
		public static const COMPONENT_NAME	:String = "viewComponent";
		
		[PropertyRef(ref = "spatialComponent.position2d")]
		public var positionRef				:Point;
		
		[PropertyRef(ref = "spatialComponent.dimentions2d")]
		public var dimentionsRef			:Point;
		
		[PropertyRef(ref = "spatialComponent.rotation2d")]
		public var rotationRef				:Number;

		LSGE_INTERNAL var m_content				:DisplayObject;
		LSGE_INTERNAL var m_container			:Sprite; 
		LSGE_INTERNAL var m_layerName			:String;
		LSGE_INTERNAL var m_added				:Boolean;
		
		public function ViewComponent(_layerName:String)
		{
			super(COMPONENT_NAME);
			
			m_layerName		= _layerName;
			m_container		= new Sprite();
		}
		
		public function get container():Sprite
		{
			return m_container;
		}
		
		public function get position():Point
		{
			return positionRef;
		}
		
		public function get dimentions():Point
		{
			return dimentionsRef;
		}
		
		public function get rotation():Number
		{
			return rotationRef;
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
			tryToRemoveSelfFromViewSystem();
		}
		
		private function tryToAddSelfToViewSystem():void
		{
			if(!m_added)
			{
				var _viewSystem	:ViewSystem	= getViewSystem();
				
				if(_viewSystem)
				{
					_viewSystem.addViewComponent(this, m_layerName);
					
					m_added	= true;
				}
			}
		}
		
		private function tryToRemoveSelfFromViewSystem():void
		{
			if(m_added)
			{
				var _viewSystem	:ViewSystem	= getViewSystem();
				
				if(_viewSystem)
				{
					_viewSystem.removeViewComponent(this);
					
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