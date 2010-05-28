package com.litespell.gameengine.components.d2.physics.box2d.contact
{
	import Box2D.Dynamics.b2Body;
	
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractComponent;
	import com.litespell.gameengine.core.objects.interfaces.IGame;
	import com.litespell.gameengine.core.objects.interfaces.IGameObject;
	import com.litespell.gameengine.systems.d2.physics.box2d.Box2DSystem;
	
	use namespace LSGE_INTERNAL;
	
	public class Box2DContactNotifier extends AbstractComponent
	{
		public static const COMPONENT_NAME	:String = "box2dNotifierComponent";
		public static const MESSAGE			:String = "SpotReceivedContact";
		
		[PropertyRef(ref = "box2dComponent.body")]
		public var body						:b2Body;
		
		private var m_contactData			:Box2DContactData;
		private var m_contacs				:Vector.<IGameObject>;
		private var m_box2DSystem			:Box2DSystem;
		
		public function Box2DContactNotifier()
		{
			super(COMPONENT_NAME);
			
			m_requiresUpdate	= true;
			m_contactData		= new Box2DContactData();
			m_contacs			= new Vector.<IGameObject>();
		}
		
		override public function preBuild():void
		{
			super.preBuild();
			
			m_box2DSystem		= ownerGame.getSystemByName(Box2DSystem.SYSTEM_NAME) as Box2DSystem;
		}
		
		override public function update():void
		{
			super.update();
			
			if(m_box2DSystem.isBodyColliding(body))
			{
				m_box2DSystem.getBodyContactsAsNode(body, m_contacs);
				
				m_contactData.receivingGameObject	= ownerGameObject;
				m_contactData.contactGameObject		= m_contacs[0];
				
				ownerGame.gameDelegate.onComponentNotifiesMessage(MESSAGE, this, m_contactData);
			}
		}
	}
}