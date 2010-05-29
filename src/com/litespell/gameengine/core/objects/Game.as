package com.litespell.gameengine.core.objects
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.core.objects.interfaces.IGame;
	import com.litespell.gameengine.core.objects.interfaces.IGameDelegate;
	import com.litespell.gameengine.core.objects.interfaces.ISystem;
	import com.litespell.gameengine.core.objects.interfaces.IWorld;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	use namespace LSGE_INTERNAL;
	
	public class Game implements IGame
	{
		public static const DEFAULT_FRAMERATE	:uint = 30;
		
		LSGE_INTERNAL var m_world				:IWorld;
		LSGE_INTERNAL var m_gameDelegate		:IGameDelegate;
		LSGE_INTERNAL var m_frameRate			:uint;
		LSGE_INTERNAL var m_systems				:Vector.<ISystem>;
		LSGE_INTERNAL var m_systemByName		:Dictionary;
		LSGE_INTERNAL var m_timer				:Timer;
		
		public function Game()
		{
			init();
		}
		
		public function get world():IWorld
		{
			return m_world;
		}
		
		public function set world(_value:IWorld):void
		{
			if(m_world)
			{
				m_world.ownerGame	= null;	
			}
			
			m_world					= _value;
			_value.ownerGame		= this;
		}
		
		public function get gameDelegate():IGameDelegate
		{
			return m_gameDelegate;
		}
		
		public function set gameDelegate(_value:IGameDelegate):void
		{
			if(m_gameDelegate)
			{
				m_gameDelegate.ownerGame= null;	
			}
			
			m_gameDelegate				= _value;
			m_gameDelegate.ownerGame	= this;
		}
		
		public function get frameRate():uint
		{
			return m_frameRate;
		}
		
		public function set frameRate(_value:uint):void
		{
			m_frameRate		= _value;
			m_timer.delay	= 1000 / _value;
		}
		
		public function addSystem(_value:ISystem):void
		{
			if(_value.ownerGame)
			{
				_value.ownerGame.removeSystem(_value);
			}
			
			if(m_systems.indexOf(_value) == -1)
			{
				m_systems[m_systems.length]			= _value;
			}
			
			m_systemByName[_value.name]				= _value;
			_value.ownerGame						= this;
			
			_value.onSelfAdd();
		}
		
		public function removeSystem(_value:ISystem):void
		{
			var _systemIndex			:int	= m_systems.indexOf(_value);
			
			if(_systemIndex != -1)
			{
				_value.onSelfRemove();
				
				m_systems.splice(_systemIndex, 1);
				
				m_systemByName[_value.name]		= null;
				_value.ownerGame				= null;
			}
		}
		
		public function removeSystemByName(_value:String):void
		{
			var _system		:ISystem			= m_systemByName[_value];
			
			if(_system)
			{
				removeSystem(_system);
			}
		}
		
		public function getSystemByName(_value:String):ISystem
		{
			return m_systemByName[_value];
		}
		
		public function start():void
		{
			if(m_world)
			{
				if(m_gameDelegate)
				{
					m_gameDelegate.onGameStart();
				}
				
				m_world.build();
				
				var _systemCount	:uint	= m_systems.length;
				
				for(var i:uint = 0; i < _systemCount; i++)
				{
					m_systems[i].update();
				}
				
				m_world.update();
				
				m_timer.start();
			}
		}
		
		public function pause():void
		{
			if(m_gameDelegate)
			{
				m_gameDelegate.onGamePause();
			}
			
			m_timer.stop();
		}
		
		public function reset():void
		{
			var _systemCount	:uint	= m_systems.length;
			
			for(var i:uint = 0; i < _systemCount; i++)
			{
				m_systems[i].reset();
			}
			
			m_world.reset();
			
			if(m_gameDelegate)
			{
				m_gameDelegate.onGameReset();
			}
		}
		
		public function invalidate():void
		{
			m_world.invalidate();
			
			var _systemCount	:uint	= m_systems.length;
			var _system			:ISystem;
			
			for(var i:uint = 0; i < _systemCount; i++)
			{
				_system							= m_systemByName[i];
				m_systemByName[_system.name]	= null;
				
				_system.invalidate();
			}
			
			m_systems.length		= 0;
			m_gameDelegate			= null;
			m_world					= null;
		}
		
		private function init():void
		{
			m_world					= new World();
			m_frameRate				= DEFAULT_FRAMERATE;
			m_systems				= new Vector.<ISystem>();
			m_systemByName			= new Dictionary();
			
			m_timer					= new Timer(1000 / m_frameRate);
			
			m_world.ownerGame		= this;
			
			m_timer.addEventListener(TimerEvent.TIMER, handleTimerUpdateEvent);
		}
		
		private function handleTimerUpdateEvent(event:TimerEvent):void
		{
			if(m_gameDelegate)
			{
				m_gameDelegate.onGamePreUpdate();
			}
			
			var _systemCount	:uint	= m_systems.length;
			var _system			:ISystem;
			
			for(var i:uint = 0; i < _systemCount; i++)
			{
				_system					= m_systems[i];
				
				if(_system.requiresUpdate)
				{
					_system.update();
				}
			}
			
			m_world.update();
			
			if(m_gameDelegate)
			{
				m_gameDelegate.onGamePostUpdate();
			}
		}
	}
}