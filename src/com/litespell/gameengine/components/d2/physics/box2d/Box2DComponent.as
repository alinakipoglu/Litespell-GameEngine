package com.litespell.gameengine.components.d2.physics.box2d
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	
	import com.litespell.gameengine.components.d2.physics.box2d.interfaces.IBox2DComponent;
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractComponent;
	import com.litespell.gameengine.systems.d2.physics.box2d.Box2DSystem;
	import com.litespell.gameengine.systems.d2.physics.box2d.intern.Box2DBodyInitializer;
	
	use namespace LSGE_INTERNAL;
	
	public class Box2DComponent extends AbstractComponent implements IBox2DComponent
	{
		LSGE_INTERNAL var m_bodyInitializer	:Box2DBodyInitializer;
		LSGE_INTERNAL var m_added			:Boolean;
		LSGE_INTERNAL var m_box2DSystem		:Box2DSystem;
		
		public function Box2DComponent(_customName:String = null)
		{
			super(_customName ? _customName : Box2DComponentName.NAME);
		}
		
		public function get bodyInitializer():Box2DBodyInitializer
		{
			return m_bodyInitializer;
		}

		override public function postBuild():void
		{
			super.postBuild();
			
			tryToAddSelfToBox2DSystem();
		}
		
		override public function onOwnerAdd():void
		{
			super.onOwnerAdd();
			
			tryToAddSelfToBox2DSystem();
		}
		
		override public function onOwnerRemove():void
		{
			super.onOwnerRemove();
			
			tryToRemoveSelfFromBox2DSystem();
		}
		
		override public function onSelfAdd():void
		{
			super.onSelfAdd();
			
			tryToAddSelfToBox2DSystem();
		}
		
		override public function onSelfRemove():void
		{
			super.onSelfRemove();
			
			tryToRemoveSelfFromBox2DSystem();
		}
		
		protected function createBox(	_x				:Number,
										_y				:Number,
										_width			:Number,
										_height			:Number,
										_rotation		:Number, 
										_type			:uint, 
										_density		:Number		= 1,
										_friction		:Number		= 1,
										_restitution	:Number		= 1, 
										_isBullet		:Boolean	= false, 
										_isSensor		:Boolean	= false,
										_fixedRotation	:Boolean	= false,
										_categoryBits	:uint		= 0x0001,
										_maskBits		:uint		= 0xFFFF,
										_groupIndex		:uint		= 0):Box2DBodyInitializer
		{
			var _polygonShape		:b2PolygonShape			= new b2PolygonShape();
			var _fixtureDef			:b2FixtureDef			= createFixtureDef(_polygonShape, _density, _friction, _restitution, _isSensor, _categoryBits, _maskBits, _groupIndex);
			var _bodyDef			:b2BodyDef				= createBodyDef(_x, _y, _type, _isBullet, _fixedRotation);
			var _box2dInitializer	:Box2DBodyInitializer	= new Box2DBodyInitializer(_bodyDef, Vector.<b2FixtureDef>([_fixtureDef]));
			
			_polygonShape.SetAsOrientedBox(_width * 0.5, _height * 0.5, new b2Vec2(), _rotation);
			
			return _box2dInitializer;
		}
		
		protected function createCircle(	_x				:Number,
											_y				:Number,
											_radius			:Number,
											_type			:uint, 
											_density		:Number		= 1,
											_friction		:Number		= 1,
											_restitution	:Number		= 1, 
											_isBullet		:Boolean	= false, 
											_isSensor		:Boolean	= false,
											_categoryBits	:uint		= 0x0001,
											_maskBits		:uint		= 0xFFFF,
											_groupIndex		:uint		= 0):Box2DBodyInitializer
		{
			var _polygonShape		:b2CircleShape			= new b2CircleShape(_radius);
			var _fixtureDef			:b2FixtureDef			= createFixtureDef(_polygonShape, _density, _friction, _restitution, _isSensor, _categoryBits, _maskBits, _groupIndex);
			var _bodyDef			:b2BodyDef				= createBodyDef(_x, _y, _type, _isBullet, false);
			var _box2dInitializer	:Box2DBodyInitializer	= new Box2DBodyInitializer(_bodyDef, Vector.<b2FixtureDef>([_fixtureDef]));
			
			return _box2dInitializer;
		}
		
		protected function createPolygon(	_x				:Number,
											_y				:Number,
											_vertexs		:Vector.<b2Vec2>,
											_type			:uint, 
											_density		:Number		= 1,
											_friction		:Number		= 1,
											_restitution	:Number		= 1, 
											_isBullet		:Boolean	= false, 
											_isSensor		:Boolean	= false,
											_fixedRotation	:Boolean	= false,
											_categoryBits	:uint		= 0x0001,
											_maskBits		:uint		= 0xFFFF,
											_groupIndex		:uint		= 0):Box2DBodyInitializer
		{
			var _polygonShape		:b2PolygonShape			= new b2PolygonShape();
			var _fixtureDef			:b2FixtureDef			= createFixtureDef(_polygonShape, _density, _friction, _restitution, _isSensor, _categoryBits, _maskBits, _groupIndex);
			var _bodyDef			:b2BodyDef				= createBodyDef(_x, _y, _type, _isBullet, _fixedRotation);
			var _box2dInitializer	:Box2DBodyInitializer	= new Box2DBodyInitializer(_bodyDef, Vector.<b2FixtureDef>([_fixtureDef]));
			
			_polygonShape.SetAsVector(_vertexs, _vertexs.length);
			
			return _box2dInitializer;
		}
		
		protected function createBodyDef(_x:Number, _y:Number, _type:uint, _isBullet:Boolean = false, _fixedRotation:Boolean = false):b2BodyDef
		{
			var _bodyDef		:b2BodyDef		= new b2BodyDef();
			
			_bodyDef.type						= _type;
			_bodyDef.bullet						= _isBullet;
			_bodyDef.fixedRotation				= _fixedRotation;
			
			_bodyDef.position.Set(_x, _y);
			
			return _bodyDef;
		}
		
		protected function createFixtureDef(_shape:b2Shape, _density:Number = 1, _friction:Number = 1, _restitution:Number = 1, _isSensor:Boolean = false, _categoryBits:uint = 0x0001, _maskBits:uint = 0xFFFF, _groupIndex:uint = 0):b2FixtureDef
		{
			var _fixtureDef		:b2FixtureDef	= new b2FixtureDef();
			
			_fixtureDef.shape					= _shape;
			
			_fixtureDef.filter.categoryBits		= _categoryBits;
			_fixtureDef.filter.maskBits			= _maskBits;
			_fixtureDef.filter.groupIndex		= _groupIndex;
			
			_fixtureDef.density					= _density;
			_fixtureDef.friction				= _friction;
			_fixtureDef.restitution				= _restitution;
			
			_fixtureDef.isSensor				= _isSensor;
			
			return _fixtureDef;
		}
		
		private function tryToAddSelfToBox2DSystem():void
		{
			if(!m_added && bodyInitializer)
			{
				var _box2DSystem	:Box2DSystem	= getBox2DSystem();
				
				if(_box2DSystem)
				{
					_box2DSystem.addBox2DBodyInitializer(bodyInitializer);
					
					m_added							= true;
					m_box2DSystem					= _box2DSystem;
				}
			}
		}
		
		private function tryToRemoveSelfFromBox2DSystem():void
		{
			if(m_added && bodyInitializer)
			{
				var _box2DSystem	:Box2DSystem	= getBox2DSystem();
				
				if(_box2DSystem)
				{
					_box2DSystem.removeBox2DBodyInitializer(bodyInitializer);
					
					m_added							= false;
					m_box2DSystem					= null;
				}
			}
		}
		
		private function getBox2DSystem():Box2DSystem
		{
			if(ownerGame)
			{
				var _box2DSystem	:Box2DSystem	= Box2DSystem(ownerGame.getSystemByName(Box2DSystem.SYSTEM_NAME));
				
				if(_box2DSystem)
				{
					return _box2DSystem
				}
			}
			
			return null;
		}
		
	}
}