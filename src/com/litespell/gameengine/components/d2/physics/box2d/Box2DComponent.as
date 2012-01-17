package com.litespell.gameengine.components.d2.physics.box2d
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	
	import com.alinakipoglu.utils.pathutils.CubicSplinePathElement;
	import com.alinakipoglu.utils.pathutils.LinePathElement;
	import com.alinakipoglu.utils.pathutils.PathSequence;
	import com.alinakipoglu.utils.pathutils.QuadraticSplinePathElement;
	import com.alinakipoglu.utils.pathutils.interfaces.IPathElement;
	import com.litespell.gameengine.components.d2.physics.box2d.interfaces.IBox2DComponent;
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.AbstractComponent;
	import com.litespell.gameengine.systems.d2.physics.box2d.Box2DSystem;
	import com.litespell.gameengine.systems.d2.physics.box2d.Box2DSystemDefaults;
	import com.litespell.gameengine.systems.d2.physics.box2d.intern.Box2DBodyInitializer;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	use namespace LSGE_INTERNAL;
	
	public class Box2DComponent extends AbstractComponent implements IBox2DComponent
	{
		LSGE_INTERNAL var m_bodyInitializer		:Box2DBodyInitializer;
		LSGE_INTERNAL var m_added				:Boolean;
		LSGE_INTERNAL var m_box2DSystem			:Box2DSystem;
		
		LSGE_INTERNAL var m_oldPosition			:b2Vec2;
		LSGE_INTERNAL var m_oldLinearVelocity	:b2Vec2;
		LSGE_INTERNAL var m_oldRotation			:Number;
		LSGE_INTERNAL var m_oldAngularVelocity	:Number;
		LSGE_INTERNAL var m_oldAngularDumping	:Number;
		
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
		
		LSGE_INTERNAL function createWithPathElementPoints(	_x					:Number,
															_y					:Number,
															_path				:IPathElement,
															_reverseDirection	:Boolean,
															_type				:uint, 
															_density			:Number		= 1,
															_friction			:Number		= 1,
															_restitution			:Number		= 1, 
															_isBullet			:Boolean	= false, 
															_isSensor			:Boolean	= false,
															_fixedRotation		:Boolean	= false,
															_categoryBits		:uint		= 0x0001,
															_maskBits			:uint		= 0xFFFF,
															_groupIndex			:uint		= 0):Box2DBodyInitializer
		{
			
			var _points			:Vector.<Point>		= new Vector.<Point>();
			var _pointCount		:uint;
			
			var _bound			:Rectangle			= new Rectangle();
			
			var _temporaryPoint	:Point				= new Point();
			var _vertices		:Vector.<b2Vec2>	= new Vector.<b2Vec2>();
			
			var	_worldScale		:Number				= Box2DSystemDefaults.WORLD_SCALE;	
			
			var _leftOffset		:Number				= 0;
			var _topOffset		:Number				= 0;
			
			var _halfWidth		:Number;
			var _halfHeight		:Number;
			
			var _vertex			:b2Vec2;
			
			if(_path is PathSequence)
			{
				pushPathSequencePoints(PathSequence(_path), _points);
			}
			
			if(_path is LinePathElement)
			{
				pushLinePathElementPoints(LinePathElement(_path), _points);
			}
			
			if(_path is CubicSplinePathElement)
			{
				pushCubicSplinePoints(CubicSplinePathElement(_path), _points);
			}
			
			if(_path is QuadraticSplinePathElement)
			{
				pushQuadraticSplinePoints(QuadraticSplinePathElement(_path), _points);
			}
			
			_pointCount						= _points.length;
			
			for(var i:uint = 0; i < _pointCount; i++)
			{
				_temporaryPoint				= _points[i];
				
				_vertices[i]				= new b2Vec2(_temporaryPoint.x, _temporaryPoint.y);
				
				if(i == 0)
				{
					_bound.left				= _temporaryPoint.x;
					_bound.right			= _temporaryPoint.x;
					
					_bound.top				= _temporaryPoint.y;
					_bound.bottom			= _temporaryPoint.y;
				} else {
					if(_temporaryPoint.x < _bound.left)
					{
						_bound.left			= _temporaryPoint.x;
					}
					
					if(_temporaryPoint.x > _bound.right)
					{
						_bound.right		= _temporaryPoint.x;
					}
					
					if(_temporaryPoint.y < _bound.top)
					{
						_bound.top			= _temporaryPoint.y;
					}
					
					if(_temporaryPoint.y > _bound.bottom)
					{
						_bound.bottom		= _temporaryPoint.y;
					}
				}
			}
			
			_leftOffset			= _bound.left * -1;
			_topOffset			= _bound.top * -1;
			
			_halfWidth			= _bound.width * 0.5;
			_halfHeight			= _bound.height * 0.5;
			
			if(_reverseDirection)
			{
				_vertices.reverse();
			}
			
			for(var j:uint = 0; j < _pointCount; j++)
			{
				_vertex			= _vertices[j];
				
				_vertex.x		= (_vertex.x - _halfWidth + _leftOffset) / _worldScale;
				_vertex.y		= (_vertex.y - _halfHeight + _topOffset) / _worldScale;
			}
			
			return createPolygon(_x, _y, _vertices, _type, _density, _friction, _restitution, _isBullet, _isSensor, _fixedRotation, _categoryBits, _maskBits, _groupIndex)
		}
		
		LSGE_INTERNAL function createWithPathElementApproximation(	_x					:Number,
																	_y					:Number,
																	_path				:IPathElement,
																	_steps				:uint,
																	_reverseDirection	:Boolean,
																	_type				:uint, 
																	_density			:Number		= 1,
																	_friction			:Number		= 1,
																	_restitution		:Number		= 1, 
																	_isBullet			:Boolean	= false, 
																	_isSensor			:Boolean	= false,
																	_fixedRotation		:Boolean	= false,
																	_categoryBits		:uint		= 0x0001,
																	_maskBits			:uint		= 0xFFFF,
																	_groupIndex			:uint		= 0):Box2DBodyInitializer
		{	
			var _bound			:Rectangle			= new Rectangle();
			
			var _temporaryPoint	:Point				= new Point();
			var _vertices		:Vector.<b2Vec2>	= new Vector.<b2Vec2>();
			
			var	_worldScale		:Number				= Box2DSystemDefaults.WORLD_SCALE;	
			
			var _leftOffset		:Number				= 0;
			var _topOffset		:Number				= 0;
			
			var _halfWidth		:Number;
			var _halfHeight		:Number;
			
			var _vertex			:b2Vec2;
			
			for(var i:uint = 0; i < _steps; i++)
			{
				_path.getDeltaPosition((1 / _steps) * i, _temporaryPoint);
				
				_vertices[i]				= new b2Vec2(_temporaryPoint.x, _temporaryPoint.y);
				
				if(i == 0)
				{
					_bound.left				= _temporaryPoint.x;
					_bound.right			= _temporaryPoint.x;
					
					_bound.top				= _temporaryPoint.y;
					_bound.bottom			= _temporaryPoint.y;
				} else {
					if(_temporaryPoint.x < _bound.left)
					{
						_bound.left			= _temporaryPoint.x;
					}
					
					if(_temporaryPoint.x > _bound.right)
					{
						_bound.right		= _temporaryPoint.x;
					}
					
					if(_temporaryPoint.y < _bound.top)
					{
						_bound.top			= _temporaryPoint.y;
					}
					
					if(_temporaryPoint.y > _bound.bottom)
					{
						_bound.bottom		= _temporaryPoint.y;
					}
				}
			}
			
			_leftOffset			= _bound.left * -1;
			_topOffset			= _bound.top * -1;
			
			_halfWidth			= _bound.width * 0.5;
			_halfHeight			= _bound.height * 0.5;
			
			if(_reverseDirection)
			{
				_vertices.reverse();
			}
			
			for(var j:uint = 0; j < _steps; j++)
			{
				_vertex			= _vertices[j];
				
				_vertex.x		= (_vertex.x - _halfWidth + _leftOffset) / _worldScale;
				_vertex.y		= (_vertex.y - _halfHeight + _topOffset) / _worldScale;
			}
			
			return createPolygon(_x, _y, _vertices, _type, _density, _friction, _restitution, _isBullet, _isSensor, _fixedRotation, _categoryBits, _maskBits, _groupIndex)
		}
		
		LSGE_INTERNAL function createCircleBodiesOnPathElement(	_x					:Number,
																_y					:Number,
																_path				:IPathElement,
																_steps				:uint,
																_reverseDirection	:Boolean,
																_circleRadius		:Number,
																_type				:uint, 
																_density			:Number		= 1,
																_friction			:Number		= 1,
																_restitution		:Number		= 1, 
																_isBullet			:Boolean	= false, 
																_isSensor			:Boolean	= false,
																_fixedRotation		:Boolean	= false,
																_categoryBits		:uint		= 0x0001,
																_maskBits			:uint		= 0xFFFF,
																_groupIndex			:uint		= 0):Box2DBodyInitializer
		{	
			var _bound			:Rectangle				= new Rectangle();
			
			var _temporaryPoint	:Point					= new Point();
			var _vertices		:Vector.<b2Vec2>		= new Vector.<b2Vec2>();
			var _fixtures		:Vector.<b2FixtureDef>	= new Vector.<b2FixtureDef>();
			
			var	_worldScale		:Number					= Box2DSystemDefaults.WORLD_SCALE;	
			
			var _leftOffset		:Number					= 0;
			var _topOffset		:Number					= 0;
			
			var _halfWidth		:Number;
			var _halfHeight		:Number;
			
			var _vertex			:b2Vec2;
			var _circle			:b2CircleShape;
			var _fixtureDef		:b2FixtureDef;
			
			for(var i:uint = 0; i < _steps; i++)
			{
				_path.getDeltaPosition((1 / _steps) * i, _temporaryPoint);
				
				_vertices[i]				= new b2Vec2(_temporaryPoint.x, _temporaryPoint.y);
				
				if(i == 0)
				{
					_bound.left				= _temporaryPoint.x;
					_bound.right			= _temporaryPoint.x;
					
					_bound.top				= _temporaryPoint.y;
					_bound.bottom			= _temporaryPoint.y;
				} else {
					if(_temporaryPoint.x < _bound.left)
					{
						_bound.left			= _temporaryPoint.x;
					}
					
					if(_temporaryPoint.x > _bound.right)
					{
						_bound.right		= _temporaryPoint.x;
					}
					
					if(_temporaryPoint.y < _bound.top)
					{
						_bound.top			= _temporaryPoint.y;
					}
					
					if(_temporaryPoint.y > _bound.bottom)
					{
						_bound.bottom		= _temporaryPoint.y;
					}
				}
			}
			
			_leftOffset			= _bound.left * -1;
			_topOffset			= _bound.top * -1;
			
			_halfWidth			= _bound.width * 0.5;
			_halfHeight			= _bound.height * 0.5;
			
			if(_reverseDirection)
			{
				_vertices.reverse();
			}
			
			for(var j:uint = 0; j < _steps; j++)
			{
				_vertex			= _vertices[j];
				
				_vertex.x		= (_vertex.x - _halfWidth + _leftOffset) / _worldScale;
				_vertex.y		= (_vertex.y - _halfHeight + _topOffset) / _worldScale;
				
				_circle			= new b2CircleShape(_circleRadius / _worldScale);
				_circle.SetLocalPosition(_vertex);
				
				_fixtures[j]	= createFixtureDef(_circle, _density, _friction, _restitution, _isSensor, _categoryBits, _maskBits, _groupIndex);
			}
			
			var _bodyDef			:b2BodyDef				= createBodyDef(_x, _y, _type, _isBullet, _fixedRotation);
			var _box2dInitializer	:Box2DBodyInitializer	= new Box2DBodyInitializer(_bodyDef, _fixtures, this);
			
			return _box2dInitializer;
		}
		
		LSGE_INTERNAL function createBox(	_x				:Number,
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
			var _box2dInitializer	:Box2DBodyInitializer	= new Box2DBodyInitializer(_bodyDef, Vector.<b2FixtureDef>([_fixtureDef]), this);
			
			_polygonShape.SetAsOrientedBox(_width * 0.5, _height * 0.5, new b2Vec2(), _rotation);
			
			return _box2dInitializer;
		}
		
		LSGE_INTERNAL function createCircle(	_x				:Number,
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
			var _box2dInitializer	:Box2DBodyInitializer	= new Box2DBodyInitializer(_bodyDef, Vector.<b2FixtureDef>([_fixtureDef]), this);

			return _box2dInitializer;
		}
		
		LSGE_INTERNAL function createPolygon(	_x				:Number,
												_y				:Number,
												_vertices		:Vector.<b2Vec2>,
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
			
			_polygonShape.SetAsVector(_vertices, _vertices.length);
			
			return _box2dInitializer;
		}
		
		LSGE_INTERNAL function createBodyDef(_x:Number, _y:Number, _type:uint, _isBullet:Boolean = false, _fixedRotation:Boolean = false):b2BodyDef
		{
			var _bodyDef		:b2BodyDef		= new b2BodyDef();
			
			_bodyDef.type						= _type;
			_bodyDef.bullet						= _isBullet;
			_bodyDef.fixedRotation				= _fixedRotation;
			
			_bodyDef.position.Set(_x, _y);
			
			return _bodyDef;
		}
		
		LSGE_INTERNAL function createFixtureDef(_shape:b2Shape, _density:Number = 1, _friction:Number = 1, _restitution:Number = 1, _isSensor:Boolean = false, _categoryBits:uint = 0x0001, _maskBits:uint = 0xFFFF, _groupIndex:uint = 0):b2FixtureDef
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
		
		protected function tryToAddSelfToBox2DSystem():void
		{
			if(!m_added && bodyInitializer)
			{
				var _box2DSystem	:Box2DSystem	= getBox2DSystem();
				
				if(_box2DSystem)
				{
					_box2DSystem.addBox2DBodyInitializer(bodyInitializer);
					
					m_added							= true;
					m_box2DSystem					= _box2DSystem;
					
					if(m_oldPosition)
					{
						var _body	:b2Body			= bodyInitializer.body;
						
						_body.SetPosition(m_oldPosition);
						_body.SetLinearVelocity(m_oldLinearVelocity);
						_body.SetAngle(m_oldRotation);
						_body.SetAngularVelocity(m_oldAngularVelocity);
					}
				}
			}
		}
		
		protected function tryToRemoveSelfFromBox2DSystem():void
		{
			if(m_added && bodyInitializer)
			{
				var _box2DSystem	:Box2DSystem	= getBox2DSystem();
				
				if(_box2DSystem)
				{
					var _body	:b2Body				= bodyInitializer.body;
					
					m_oldPosition					= _body.GetPosition();
					m_oldLinearVelocity				= _body.GetLinearVelocity();
					m_oldRotation					= _body.GetAngle();
					m_oldAngularVelocity			= _body.GetAngularVelocity();
					
					_box2DSystem.removeBox2DBodyInitializer(bodyInitializer);
					
					m_added							= false;
					m_box2DSystem					= null;
				}
			}
		}
		
		protected function getBox2DSystem():Box2DSystem
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
		
		private function pushLinePathElementPoints(_linePathElement:LinePathElement, _result:Vector.<Point>):void
		{
			if(_result.length > 0)
			{
				var _lastPoint	:Point	= _result[_result.length - 1];
				
				if(_lastPoint.x != _linePathElement.startPoint.x || _lastPoint.y != _linePathElement.startPoint.y)
				{
					_result[0]			= _linePathElement.startPoint;
				}
			} else {
				_result[0]				= _linePathElement.startPoint;
			}
			
			_result[_result.length]		= _linePathElement.endPoint;
		}
		
		private function pushCubicSplinePoints(_cubicSpline:CubicSplinePathElement, _result:Vector.<Point>):void
		{
			if(_result.length > 0)
			{
				var _lastPoint	:Point	= _result[_result.length - 1];
				
				if(_lastPoint.x != _cubicSpline.anchor1.x || _lastPoint.y != _cubicSpline.anchor1.y)
				{
					_result[0]	= _cubicSpline.anchor1;
				}
			} else {
				_result[0]		= _cubicSpline.anchor1;
			}
			
			_result[_result.length]	= _cubicSpline.anchor2;
		}
		
		private function pushQuadraticSplinePoints(_quadraticSpline:QuadraticSplinePathElement, _result:Vector.<Point>):void
		{
			if(_result.length > 0)
			{
				var _lastPoint	:Point	= _result[_result.length - 1];
				
				if(_lastPoint.x != _quadraticSpline.startPointPosition.x || _lastPoint.y != _quadraticSpline.startPointPosition.y)
				{
					_result[0]	= _quadraticSpline.startPointPosition;
				}
			} else {
				_result[0]		= _quadraticSpline.startPointPosition;
			}
			
			_result[_result.length]	= _quadraticSpline.controlPointPosition;
			_result[_result.length]	= _quadraticSpline.endPointPosition;
		}
		
		private function pushPathSequencePoints(_pathSequence:PathSequence, _result:Vector.<Point>):void
		{
			var _pathElements		:Array	= _pathSequence.paths;
			var _pathElementsLength	:uint	= _pathElements.length;
			
			for(var i:uint = 0; i < _pathElementsLength; i++)
			{
				if(_pathElements[i] is PathSequence)
				{
					pushPathSequencePoints(PathSequence(_pathElements[i]), _result);
					
					continue;
				}
				
				if(_pathElements[i] is LinePathElement)
				{
					pushLinePathElementPoints(LinePathElement(_pathElements[i]), _result);
					
					continue;
				}
				
				if(_pathElements[i] is CubicSplinePathElement)
				{
					pushCubicSplinePoints(CubicSplinePathElement(_pathElements[i]), _result);
					
					continue;
				}
				
				if(_pathElements[i] is QuadraticSplinePathElement)
				{
					pushQuadraticSplinePoints(QuadraticSplinePathElement(_pathElements[i]), _result);
					
					continue;
				}
			}
		}
	}
}