package com.litespell.gameengine.systems.common.time
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	
	use namespace LSGE_INTERNAL;
	
	public class TimeInfo
	{
		LSGE_INTERNAL var m_gameTimeInFrames		:uint;
		LSGE_INTERNAL var m_gameTimeInMilliSeconds	:uint;
		LSGE_INTERNAL var m_delta					:Number;
		LSGE_INTERNAL var m_frameRate				:uint;
		
		public function TimeInfo()
		{
			init();
		}
		
		public function get frameRate():uint
		{
			return m_frameRate;
		}

		public function set frameRate(value:uint):void
		{
			m_frameRate = value;
		}

		public function get gameTimeInFrames():uint
		{
			return m_gameTimeInFrames;
		}
		
		public function set gameTimeInFrames(_value:uint):void
		{
			m_gameTimeInFrames			= _value;
		}
		
		public function get gameTimeInMilliSeconds():uint
		{
			return m_gameTimeInMilliSeconds;
		}
		
		public function set gameTimeInMilliSeconds(_value:uint):void
		{
			m_gameTimeInMilliSeconds	= _value;
		}
		
		public function get delta():Number
		{
			return m_delta;
		}
		
		public function set delta(_value:Number):void
		{
			m_delta						= _value;
		}
		
		private function init():void
		{
			m_gameTimeInFrames			= 0;
			m_gameTimeInMilliSeconds	= 0;
			m_delta						= 0;
			m_frameRate					= 0;
		}
	}
}