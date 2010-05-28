package com.litespell.gameengine.components.common.view
{
	import com.litespell.gameengine.core.objects.AbstractComponent;
	
	public class ViewDirection extends AbstractComponent
	{
		public static const NORMAL			:int	= 1;
		public static const FLIPPED			:int	= -1;
		
		public static const COMPONENT_NAME	:String = "viewDirection";
		
		public var viewDirection			:int;
		
		public function ViewDirection()
		{
			super(COMPONENT_NAME);
			
			viewDirection	= NORMAL;
		}
	}
}