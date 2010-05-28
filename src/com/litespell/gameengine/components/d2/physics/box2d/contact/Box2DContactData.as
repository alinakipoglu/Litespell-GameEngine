package com.litespell.gameengine.components.d2.physics.box2d.contact
{
	import com.litespell.gameengine.core.objects.interfaces.IGameObject;

	public class Box2DContactData
	{
		public var contactGameObject		:IGameObject;
		public var receivingGameObject		:IGameObject;
		
		public function Box2DContactData()
		{
		}
		
		public function toString():String
		{
			return "Contact Node : " + contactGameObject + " Receiving node : " + receivingGameObject; 
		}
	}
}