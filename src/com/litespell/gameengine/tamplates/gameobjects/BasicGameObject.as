package com.litespell.gameengine.tamplates.gameobjects
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.GameObject;

	use namespace LSGE_INTERNAL;

	public class BasicGameObject extends GameObject
	{
		private static const GAME_OBJECT_NAME	:String		= "gameObject"
		private static var s_instanceCount		:uint		= 0;
		
		public function BasicGameObject(_name:String = null)
		{
			super(_name ? _name : GAME_OBJECT_NAME + "_" + s_instanceCount.toString());
			
			s_instanceCount++;
		}
	}
}