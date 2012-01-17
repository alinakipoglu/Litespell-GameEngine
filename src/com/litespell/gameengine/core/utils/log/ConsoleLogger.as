package com.litespell.gameengine.core.utils.log
{
	import com.litespell.gameengine.core.LiteSpell_GameEngine;
	import com.litespell.gameengine.core.utils.log.interfaces.ILogger;

	public class ConsoleLogger implements ILogger
	{
		public static const SEPERATOR	:String		= "::";
		
		public function ConsoleLogger()
		{
		}
		
		public function logMessage(_messageText:String, _messageOwner:Object):void
		{
			trace(	LiteSpell_GameEngine.ENGINE +
					SEPERATOR +
					LiteSpell_GameEngine.VERSION +
					SEPERATOR +
					LiteSpell_GameEngine.BUILD + 
					SEPERATOR + SEPERATOR + " " + 
					_messageOwner +
					SEPERATOR + 
					_messageText);
		}
		
		public function logError(_error:String, _errorOwner:Object):void
		{
			trace(	LiteSpell_GameEngine.ENGINE +
					SEPERATOR +
					LiteSpell_GameEngine.VERSION +
					SEPERATOR +
					LiteSpell_GameEngine.BUILD + 
					SEPERATOR + SEPERATOR + " " + 
					_errorOwner +
					SEPERATOR + 
					_error);
		}
	}
}