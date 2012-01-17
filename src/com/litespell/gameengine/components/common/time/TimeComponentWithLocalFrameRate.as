package com.litespell.gameengine.components.common.time
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.systems.common.time.TimeSystem;

	use namespace LSGE_INTERNAL;
	
	public class TimeComponentWithLocalFrameRate extends TimeComponent
	{
		LSGE_INTERNAL var m_localFrameRate			:uint;
		LSGE_INTERNAL var m_currentFrameDecimal		:Number;
		LSGE_INTERNAL var m_timeSystem				:TimeSystem;
		
		public function TimeComponentWithLocalFrameRate(_frameRate:uint, _customName:String = null)
		{
			super(_customName);
			
			m_localFrameRate		= _frameRate;
		}
		
		public function get localFrameRate():uint
		{
			return m_localFrameRate;
		}
		
		public function set localFrameRate(value:uint):void
		{
			m_localFrameRate = value;
		}
		
		override public function postBuild():void
		{
			super.postBuild();
			
			setTimeSystem();
		}
		
		override public function onOwnerAdd():void
		{
			super.onOwnerAdd();
			
			setTimeSystem();
		}
		
		override public function onOwnerRemove():void
		{
			super.onOwnerRemove();
			
			m_timeSystem			= null;
		}
		
		override public function onSelfAdd():void
		{
			super.onSelfAdd();
			
			setTimeSystem();
		}
		
		override public function onSelfRemove():void
		{
			super.onSelfRemove();
			
			m_timeSystem			= null;
		}
		
		override public function update():void
		{
			super.update();
			
			m_currentFrameDecimal	+= m_localFrameRate / m_timeSystem.timeInfo.frameRate;
			m_currentFrame			= Math.floor(m_currentFrameDecimal);
		}
		
		override public function reset():void
		{
			super.reset();
			
			m_currentFrame			= 0;
			m_currentFrameDecimal	= 0;
		}
		
		private function setTimeSystem():void
		{
			if(!m_timeSystem)
			{
				m_timeSystem		= getTimeSystem();
			}
		}
		
		private function getTimeSystem():TimeSystem
		{
			if(ownerGame)
			{
				var _timeSystem	:TimeSystem	= TimeSystem(ownerGame.getSystemByName(TimeSystem.SYSTEM_NAME));
				
				if(_timeSystem)
				{
					return _timeSystem
				}
			}
			
			return null;
		}
	}
}