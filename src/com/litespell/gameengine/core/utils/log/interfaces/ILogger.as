package com.litespell.gameengine.core.utils.log.interfaces
{
	public interface ILogger
	{
		function logMessage(_messageText:String, _messageOwner:Object):void;
		function logError(_error:String, _errorOwner:Object):void;
	}
}