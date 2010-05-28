package com.litespell.gameengine.components.d2.spatial
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractComponent;
	
	import flash.geom.Point;
	
	use namespace LSGE_INTERNAL;
	
	public class SpatialComponent extends AbstractComponent
	{
		public static const COMPONENT_NAME	:String = "spatialComponent";
		
		LSGE_INTERNAL var m_position2d		:Point;
		LSGE_INTERNAL var m_dimentions2d	:Point;
		LSGE_INTERNAL var m_rotation2d		:Number;
		
		public function SpatialComponent(_x:Number = 0, _y:Number = 0, _rotation:Number = 0, _width:Number = 0, _height:Number = 0)
		{
			super(COMPONENT_NAME);
			
			m_position2d		= new Point(_x, _y);
			m_dimentions2d		= new Point(_width, _height);
			
			m_rotation2d		= _rotation;
		}
		
		public function get dimentions2d():Point
		{
			return m_dimentions2d;
		}

		public function set dimentions2d(value:Point):void
		{
			m_dimentions2d = value;
		}

		public function get position2d():Point
		{
			return m_position2d;
		}
		
		public function set position2d(value:Point):void
		{
			m_position2d = value;
		}
		
		public function get rotation2d():Number
		{
			return m_rotation2d;
		}

		public function set rotation2d(value:Number):void
		{
			m_rotation2d = value;
		}

	}
}