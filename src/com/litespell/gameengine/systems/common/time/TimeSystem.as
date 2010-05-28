package com.litespell.gameengine.systems.common.time
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractSystem;
	import com.litespell.gameengine.core.objects.interfaces.IGame;
	
	import flash.utils.getTimer;
	
	use namespace LSGE_INTERNAL
	
	public class TimeSystem extends AbstractSystem
	{
		public static const SYSTEM_NAME			:String = "TIME_SYSTEM";
		
		public var timeInfo						:TimeInfo;
		
		LSGE_INTERNAL var m_initialMilliSeconds	:uint;
		LSGE_INTERNAL var m_currentCPUTime		:uint;
		LSGE_INTERNAL var m_deltaStart			:uint;
		
		public function TimeSystem()
		{
			super(SYSTEM_NAME);
			
			init();
		}
		
		override public function reset():void
		{
			m_initialMilliSeconds				= getTimer();
			m_deltaStart						= m_initialMilliSeconds;
		}
		
		override public function onSelfAdd():void
		{
			reset();
		}
		
		override public function update():void
		{
			super.update();
			
			m_currentCPUTime					= getTimer();
			
			timeInfo.frameRate					= ownerGame.frameRate;
			timeInfo.delta						= (m_currentCPUTime - m_deltaStart) / (1000 / ownerGame.frameRate)
			timeInfo.gameTimeInMilliSeconds		= m_currentCPUTime - m_initialMilliSeconds;
			timeInfo.gameTimeInFrames			= timeInfo.gameTimeInMilliSeconds / ownerGame.frameRate;
			
			m_deltaStart						= m_currentCPUTime;
		}
		
		private function init():void
		{
			m_requiresUpdate					= true;
			timeInfo							= new TimeInfo();
		}
	}
}