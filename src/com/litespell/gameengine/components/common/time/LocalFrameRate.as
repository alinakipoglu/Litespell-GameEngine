package com.litespell.gameengine.components.common.time
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractComponent;
	import com.litespell.gameengine.systems.common.time.TimeInfo;
	import com.litespell.gameengine.systems.common.time.TimeSystem;
	
	use namespace LSGE_INTERNAL;
	
	public class LocalFrameRate extends AbstractComponent
	{
		public static const COMPONENT_NAME		:String = "localFrameRateComponent";
		
		public var currentFrame					:uint;
		public var localFrameRate				:uint;
		
		private var m_timeSystem				:TimeSystem;
		private var m_currentFrameDecimal		:Number;
		
		public function LocalFrameRate(_frameRate:uint = 0)
		{
			super(COMPONENT_NAME);
			
			m_requiresUpdate		= true;
			
			localFrameRate			= _frameRate;
			
			reset();
		}
		
		override public function postBuild():void
		{
			super.postBuild();
			
			reset();
		}
		
		override public function preBuild():void
		{
			super.preBuild();
			
			m_timeSystem			= ownerGame.getSystemByName(TimeSystem.SYSTEM_NAME) as TimeSystem;
		}	
		
		override public function reset():void
		{
			super.reset();
			
			currentFrame			= 0;
			m_currentFrameDecimal	= 0;
		}
		
		override public function update():void
		{
			super.update();
			
			m_currentFrameDecimal	+= localFrameRate / m_timeSystem.timeInfo.frameRate;
			currentFrame			= Math.floor(m_currentFrameDecimal);
		}
	}
}