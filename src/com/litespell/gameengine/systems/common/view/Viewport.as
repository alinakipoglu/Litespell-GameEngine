package com.litespell.gameengine.systems.common.view
{
	import com.litespell.gameengine.core.namespaces.LSGE_INTERNAL;
	import com.litespell.gameengine.systems.common.view.intern.LayerIndexData;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	use namespace LSGE_INTERNAL;
	
	public class Viewport extends Sprite
	{
		LSGE_INTERNAL var m_mainContainer			:Sprite;
		LSGE_INTERNAL var m_maskRect				:Shape;
		LSGE_INTERNAL var m_debugRect				:Shape;
		
		LSGE_INTERNAL var m_localWidth				:Number;
		LSGE_INTERNAL var m_localHeight				:Number;
		
		LSGE_INTERNAL var m_layerIndexDatas			:Array;
		LSGE_INTERNAL var m_layerIndexDataByLayer	:Dictionary;
		LSGE_INTERNAL var m_layerByName				:Dictionary;
		
		public function Viewport(_width:Number = 800, _height:Number = 600)
		{
			m_localWidth			= _width;
			m_localHeight			= _height;
			
			m_mainContainer			= new Sprite();
			m_maskRect				= new Shape();
			m_debugRect				= new Shape();
			
			m_layerIndexDatas		= [];
			m_layerIndexDataByLayer	= new Dictionary();
			m_layerByName			= new Dictionary();
			
			m_mainContainer.mask	= m_maskRect;
			
			m_debugRect.visible		= false;
			m_debugRect.blendMode	= BlendMode.DIFFERENCE;
			
			drawMaskRect();
			drawDebugRect();
			
			addChild(m_maskRect);
			addChild(m_debugRect);
			addChild(m_mainContainer);
		}
		
		public function set debug(_value:Boolean):void
		{
			m_debugRect.visible	= true;
		}
		
		public function get debug():Boolean
		{
			return m_debugRect.visible;
		}
		
		public function createLayer(_name:String, _index:int):void
		{
			var _layerSprite	:Sprite						= new Sprite();
			var _layerIndexData	:LayerIndexData				= new LayerIndexData(_index, _layerSprite);
			
			m_layerByName[_name]							= _layerSprite;
			m_layerIndexDataByLayer[_layerSprite]			= _layerIndexData;
			m_layerIndexDatas[m_layerIndexDatas.length]		= _layerIndexData;
			
			m_mainContainer.addChild(_layerSprite);
			
			m_layerIndexDatas.sortOn("index", Array.NUMERIC);
			
			var _layerCount		:uint						= m_mainContainer.numChildren;
			
			for(var i:uint = 0; i < _layerCount; i++)
			{
				m_mainContainer.setChildIndex(m_layerIndexDatas[i].layer, i);
			}
		}
		
		public function removeLayer(_name:String):void
		{
			var _layerSprite	:Sprite	= m_layerByName[_name];
			
			if(_layerSprite)
			{
				m_layerIndexDatas.splice(m_layerIndexDatas.indexOf(m_layerIndexDataByLayer[_layerSprite]), 1);
				m_mainContainer.removeChild(_layerSprite);
				
				m_layerByName[_name]					= null;
				m_layerIndexDataByLayer[_layerSprite]	= null;
			}
		}
		
		public function containsLayerWithName(_name:String):Boolean
		{
			return m_layerByName[_name];
		}
		
		public function addChildToLayer(_child:DisplayObject, _layerName:String):void
		{
			var _layerSprite	:Sprite	= m_layerByName[_layerName];
			
			if(_layerSprite)
			{
				_layerSprite.addChild(_child);
			}
		}
		
		public function removeChildFromLayer(_child:DisplayObject):void
		{
			var _layerSprite	:DisplayObjectContainer	= _child.parent;
			
			if(_layerSprite && _layerSprite.parent && m_mainContainer.contains(_layerSprite))
			{
				_layerSprite.removeChild(_child);
			}
		}
		
		public function getLayerByName(_layerName:String):Sprite
		{
			return m_layerByName[_layerName];
		}
		
		override public function get width():Number
		{
			return m_localWidth;
		}
		
		override public function get height():Number
		{
			return m_localHeight;
		}
		
		override public function set width(value:Number):void
		{
			m_localWidth	= value;
			
			updateDimentions();
		}
		
		override public function set height(value:Number):void
		{
			m_localHeight	= value;
			
			updateDimentions();
		}
		
		private function drawMaskRect():void
		{
			m_maskRect.graphics.beginFill(0xFF0000, 1);
			m_maskRect.graphics.drawRect(0, 0, m_localWidth, m_localHeight);
			m_maskRect.graphics.endFill();
		}
		
		private function updateDimentions():void
		{
			m_maskRect.width	= m_localWidth;
			m_maskRect.height	= m_localHeight;
			
			m_debugRect.width	= m_localWidth;
			m_debugRect.height	= m_localHeight;
		}
		
		private function drawDebugRect():void
		{
			m_debugRect.graphics.beginFill(0xBBBBBB, 0.1);
			m_debugRect.graphics.drawRect(0, 0, m_localWidth, m_localHeight);
			m_debugRect.graphics.endFill();
		}
	}
}