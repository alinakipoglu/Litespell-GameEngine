package com.litespell.gameengine.components.common.view
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	use namespace LSGE_INTERNAL;
	
	public class ViewComponentClipPlayer extends ViewComponent
	{
		public static const TYPE_PLAY_AND_STOP		:uint	= 1;
		public static const TYPE_LOOP				:uint	= 2;
		
		[PropertyRef(ref = "timeComponent.currentFrame")]
		public var currentFrame						:uint;
		
		LSGE_INTERNAL var m_clipsByKey				:Dictionary;
		LSGE_INTERNAL var m_typeByKey				:Dictionary;
		LSGE_INTERNAL var m_currentKey				:String;
		LSGE_INTERNAL var m_clipStartFrame			:uint;
		
		public function ViewComponentClipPlayer(_layerName:String, _customName:String=null)
		{
			super(_layerName, _customName);
			
			m_clipsByKey		= new Dictionary();
			m_typeByKey			= new Dictionary();
		}
		
		public function addClip(_clip:DisplayObject, _key:String, _type:uint = 1):void
		{
			m_clipsByKey[_key]	= _clip;
			m_typeByKey[_key]	= _type;
		}
		
		public function removeClip(_key:String):void
		{
			m_clipsByKey[_key]	= null;
			m_typeByKey[_key]	= null;
		}
		
		public function setCurrentClip(_key:String):void
		{
			if(m_currentKey != _key)
			{
				var _clip				:DisplayObject	= m_clipsByKey[_key];
				var _clipAsMovieClip	:MovieClip		= _clip as MovieClip;
				
				if(_clipAsMovieClip && _clipAsMovieClip.totalFrames > 1)
				{
					m_requiresUpdate			= true;
					
					_clipAsMovieClip.gotoAndStop(1);
					
				} else {
					m_requiresUpdate			= false;
				}
				
				m_currentKey		= _key;
				content				= _clip;
				m_clipStartFrame	= currentFrame;
			}
		}
		
		public function getClip(_key:String):DisplayObject
		{
			return m_clipsByKey[_key];
		}
		
		override public function update():void
		{
			var _currentClip	:MovieClip	= m_clipsByKey[m_currentKey];
			var _currentType	:uint		= m_typeByKey[m_currentKey];
			
			if(_currentClip.currentFrame != _currentClip.totalFrames)
			{
				_currentClip.gotoAndStop(currentFrame - m_clipStartFrame);
			} else {
				if(_currentType == TYPE_LOOP)
				{
					m_clipStartFrame		= currentFrame;
					
					_currentClip.gotoAndStop(1);
				}
				
				if(_currentType == TYPE_PLAY_AND_STOP)
				{
					m_requiresUpdate		= false;
					
					_currentClip.gotoAndStop(_currentClip.totalFrames);
				}
			}
		}
	}
}