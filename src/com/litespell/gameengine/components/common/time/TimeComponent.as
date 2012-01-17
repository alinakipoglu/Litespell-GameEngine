package com.litespell.gameengine.components.common.time
{
	import com.litespell.gameengine.components.common.time.interfaces.ITimeComponent;
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractComponent;
	import com.litespell.gameengine.systems.common.time.TimeSystem;
	
	use namespace LSGE_INTERNAL
	
	public class TimeComponent extends AbstractComponent implements ITimeComponent
	{
		LSGE_INTERNAL var m_currentFrame			:uint;
		
		public function TimeComponent(_customName:String = null)
		{
			super(_customName ? _customName : TimeComponentName.NAME);
			
			m_requiresUpdate		= true;
			m_currentFrame			= 0;
			
			reset();
		}
		
		public function get currentFrame():uint
		{
			return m_currentFrame;
		}
		
		override public function update():void
		{
			super.update();
			
			m_currentFrame++;
		}
		
		override public function reset():void
		{
			super.reset();
			
			m_currentFrame		= 0;
		}
	}
}