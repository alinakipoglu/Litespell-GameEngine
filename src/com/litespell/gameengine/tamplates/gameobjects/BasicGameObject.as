package com.litespell.gameengine.tamplates.gameobjects
{
	import com.litespell.gameengine.components.common.view.ViewComponent;
	import com.litespell.gameengine.components.common.view.interfaces.IViewComponent;
	import com.litespell.gameengine.components.d2.physics.box2d.Box2DComponent;
	import com.litespell.gameengine.components.d2.physics.box2d.Box2DMapper;
	import com.litespell.gameengine.components.d2.spatial.SpatialComponent;
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.GameObject;
	import com.litespell.gameengine.systems.common.view.ViewSystem;
	
	import flash.display.DisplayObject;

	use namespace LSGE_INTERNAL;

	public class BasicGameObject extends GameObject
	{
		LSGE_INTERNAL var m_viewComponent		:IViewComponent;
		LSGE_INTERNAL var m_spatialComponent	:SpatialComponent;
		LSGE_INTERNAL var m_box2dComponent		:Box2DComponent;
		LSGE_INTERNAL var m_box2dMapperComponent:Box2DMapper;

		public function BasicGameObject(_name:String)
		{
			super(_name);
		}

		public function get box2dMapperComponent():Box2DMapper
		{
			return m_box2dMapperComponent;
		}

		public function get box2dComponent():Box2DComponent
		{
			return m_box2dComponent;
		}

		public function get spatialComponent():SpatialComponent
		{
			return m_spatialComponent;
		}

		public function get viewComponent():IViewComponent
		{
			return m_viewComponent;
		}

		public function addViewComponent(_viewContent:DisplayObject, _layerName:String = "DEFAULT_TOP_LAYER"):void
		{
			m_viewComponent			= new ViewComponent(_layerName);
			m_viewComponent.content	= _viewContent;

			addComponent(m_viewComponent);
		}

		public function addSpatialComponent(_x:Number=0, _y:Number=0, _rotation:Number=0, _width:Number=0, _height:Number=0):void
		{
			m_spatialComponent		= new SpatialComponent(_x, _y, _rotation, _width, _height);

			addComponent(m_spatialComponent);
		}

		public function addBox2DComponent(_bodyType:uint=0, _density:Number=1, _friction:Number=1, _restitution:Number=1, _fixedRotation:Boolean=false, _isBullet:Boolean=false, _isSensor:Boolean=false, _group:uint=0):void
		{
			m_box2dComponent		= new Box2DComponent(_bodyType, _density, _friction, _restitution, _fixedRotation, _isBullet, _isSensor, _group);

			addComponent(m_box2dComponent);
		}

		public function addBox2DMapperComponent():void
		{
			m_box2dMapperComponent	= new Box2DMapper();

			addComponent(m_box2dMapperComponent);
		}
	}
}