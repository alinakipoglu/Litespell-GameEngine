package com.litespell.gameengine.systems.common.keyboard
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractSystem;
	import com.litespell.gameengine.utils.KeyboardUtil;
	
	import flash.display.Stage;
	
	use namespace LSGE_INTERNAL;
	
	public class KeyboardSystem extends AbstractSystem
	{
		public static const SYSTEM_NAME			:String = "KEYBOARD_SYSTEM";
		
		LSGE_INTERNAL var m_stage				:Stage;
		
		public var disabeled					:Boolean;
		
		public function KeyboardSystem(_stage:Stage)
		{
			super(SYSTEM_NAME);
			
			m_stage	= _stage;
			
			KeyboardUtil.init(m_stage);
		}
		
		public function keyIsDown(_keyCode:uint):Boolean
		{
			if(disabeled)
			{
				return false;
			}
			
			return KeyboardUtil.keyIsDown(_keyCode);
		}
	}
}