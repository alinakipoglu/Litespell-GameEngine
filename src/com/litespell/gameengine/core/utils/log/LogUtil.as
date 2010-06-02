package com.litespell.gameengine.core.utils.log
{
	import com.litespell.gameengine.core.utils.log.interfaces.ILogger;

	public class LogUtil
	{
		public static const DEFAULT_LOGGER		:ILogger	= new ConsoleLogger();
		
		private static var s_currentLogger		:ILogger	= DEFAULT_LOGGER;
		private static var s_verbose			:Boolean	= true;
		private static var s_errors				:Boolean	= true;
		
		public static function get errors():Boolean
		{
			return s_errors;
		}

		public static function set errors(value:Boolean):void
		{
			s_errors = value;
		}

		public static function get verbose():Boolean
		{
			return s_verbose;
		}

		public static function set verbose(value:Boolean):void
		{
			s_verbose = value;
		}

		public static function logMessage(_messageText:String, _messageOwner:Object):void
		{
			if(s_verbose)
			{
				s_currentLogger.logMessage(_messageText, _messageOwner);
			}
		}
		
		public static function logError(_error:String, _errorOwner:Object):void
		{
			if(s_errors)
			{
				s_currentLogger.logError(_error, _errorOwner);
			}
		}
		
		public static function useLogger(_logger:ILogger):void
		{
			s_currentLogger		= _logger;
		}
	}
}