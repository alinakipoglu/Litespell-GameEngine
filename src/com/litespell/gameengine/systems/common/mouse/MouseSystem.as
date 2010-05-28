package com.litespell.gameengine.systems.common.mouse
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractSystem;
	import com.litespell.gameengine.systems.common.view.ViewSystem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	use namespace LSGE_INTERNAL;
	
	public class MouseSystem extends AbstractSystem
	{
		public static const SYSTEM_NAME				:String 		= "MOUSE_SYSTEM";
		
		public var mouseDown						:Boolean;
		public var mousePos							:Point;
		public var wheelDelta						:Number;
		
		LSGE_INTERNAL var m_viewSystem				:ViewSystem;
		LSGE_INTERNAL var m_wheelDeltaClearFlag		:Boolean;
		
		public function MouseSystem(_viewSystem:ViewSystem)
		{
			super(SYSTEM_NAME);
			
			requiresUpdate		= true;
			
			m_viewSystem		= _viewSystem;
			
			mouseDown			= false;
			mousePos			= new Point();
			wheelDelta			= 0;
			
			m_viewSystem.viewport.addEventListener(MouseEvent.MOUSE_DOWN, handleViewportMouseDownEvent);
			m_viewSystem.viewport.addEventListener(MouseEvent.MOUSE_UP, handleViewportMouseUpEvent);
			m_viewSystem.viewport.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWhellEvent);
		}
		
		private function handleViewportMouseDownEvent(event:MouseEvent):void
		{
			mouseDown		= true;
		}
		
		private function handleViewportMouseUpEvent(event:MouseEvent):void
		{
			mouseDown		= false;
		}
		
		private function handleMouseWhellEvent(event:MouseEvent):void
		{
			wheelDelta		= event.delta;
		}
		
		override public function update():void
		{
			super.update();
			
			mousePos.x		= m_viewSystem.viewport.mouseX;
			mousePos.y		= m_viewSystem.viewport.mouseY;
			
			if(m_wheelDeltaClearFlag)
			{
				m_wheelDeltaClearFlag	= false;
				
				wheelDelta				= 0;
			}
			
			if(wheelDelta != 0)
			{
				m_wheelDeltaClearFlag	= true;
			}
		}
	}
}