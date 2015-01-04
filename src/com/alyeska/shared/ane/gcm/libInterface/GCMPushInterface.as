/*
 * Copyright 2014 Bree Alyeska.
 *
 * This file is part of GCM Library, developed in conjunction with and distributed with iHAART.
 *
 * gcmLibrary and iHAART are free software: you can redistribute it and/or modify it under the terms of the
 * GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * gcmLibrary and iHAART are distributed in the hope that they will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with gcmLibrary and iHAART. If not, see
 * <http://www.gnu.org/licenses/>.
 */

package com.alyeska.shared.ane.gcm.libInterface
{
	import com.alyeska.shared.ane.gcm.libInterface.events.GCMEvent;

	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class GCMPushInterface extends EventDispatcher
	{

		private var _context:ExtensionContext;

		static public const REGISTERED:String = "registered";
		static public const UNREGISTERED:String = "unregistered";
		static public const MESSAGE:String = "message";
		static public const FOREGROUND_MESSAGE:String = "foregroundMessage";
		static public const ERROR:String = "error";
		static public const RECOVERABLE_ERROR:String = "recoverableError";

		static public const UNREGISTERED_INFO:String = "Device successfully unregistered.";
		static public const REGISTERED_INFO:String = "Device registration successful.";
		static public const NOT_REGISTERED_INFO:String = "Device is not currently registered.";
		static public const NO_REGID:String = "NONE";
		static public const NO_WAITING_MESSAGES:String = "false";

		static public const TITLE_PARAM:String = "title";
		static public const ALERT_PARAM:String = "alert";
		static public const TYPE_PARAM:String = "type";
		static public const ID_PARAM:String = "id";
		static public const PAYLOAD_SEPARATOR:String = ",";
		static public const PARAMETER_SEPARATOR:String = "~~~";

		private var _isRegistered:Boolean;
		private var _registrationID:String;

		public function GCMPushInterface()
		{
			super();

			// First parameter is native extension package id defined in extension.xml, second parameter is behavior
//			_context = ExtensionContext.createExtensionContext("com.alyeska.shared.ane.gcm.libInterface", "");
			_context = ExtensionContext.createExtensionContext("com.alyeska.shared.ane.gcm.GCMPush", "");
			if (!_context)
			{
				throw new Error("Volume native extension is not supported on this platform.");
			}

			_context.addEventListener(StatusEvent.STATUS, handleStatus);
		}

//		mapped
		public function register(senderID:String):String
		{
			return String (_context.call("register", senderID));
		}

//		mapped
		public function checkRegistered(senderID:String):Boolean
		{
			var response:String = String(_context.call("checkRegistered", senderID));
			var pArray:Array = response.split(",");

			if (pArray[1] == "true") {
				var registrationID:String = getRegIDFromString(pArray[0]);
				setStatusRegistered(registrationID);
				dispatchEvent(new GCMEvent(GCMEvent.IS_REGISTERED, registrationID, false, false));
				return true;
			}
			else {
				setStatusNotRegistered();
				dispatchEvent(new GCMEvent(GCMEvent.NOT_REGISTERED, GCMPushInterface.NOT_REGISTERED_INFO, false, false));
				return false;
			}
		}

//		mapped
		public function unregister():String
		{
			return String (_context.call("unregister"));
		}

//		mapped
		public function checkPendingPayload():String
		{
			return String (_context.call("checkPendingPayload"));
		}

		private function setStatusNotRegistered():void
		{
				_registrationID = NO_REGID;
				_isRegistered = false;
		}

		private function setStatusRegistered(registrationID:String):void
		{
			_registrationID = registrationID;
			_isRegistered = true;
		}

		private function getRegIDFromString(stringIn:String):String  ///This is hack to deal with old code that sends responses in silly format
		{
			if (stringIn.indexOf("registrationID:") == -1)
			{
				return stringIn.substr(stringIn.indexOf(":") + 1);
			}
			else {
				return "";
			}
		}

		private function handleStatus(e:StatusEvent):void
		{

			var regID:String = getRegIDFromString(e.level);
			if (regID.length > 0)
			{
				setStatusRegistered(regID);
			}
			else
			{
				setStatusNotRegistered();
			}

			switch (e.code)
			{
				case REGISTERED :
					dispatchEvent(new GCMEvent(GCMEvent.REGISTERED, regID, false, false));
					break;
				case UNREGISTERED :
					dispatchEvent(new GCMEvent(GCMEvent.UNREGISTERED, e.level, false, false));
					break;
				case MESSAGE :
					dispatchEvent(new GCMEvent(GCMEvent.MESSAGE, e.level, false, false));
					break;
				case FOREGROUND_MESSAGE :
					dispatchEvent(new GCMEvent(GCMEvent.FOREGROUND_MESSAGE, e.level, false, false));
					break;
				case RECOVERABLE_ERROR :
					dispatchEvent(new GCMEvent(GCMEvent.RECOVERABLE_ERROR, e.level, false, false));
					break;
				default :
					dispatchEvent(new GCMEvent(GCMEvent.ERROR, e.level, false, false));
					// statements
					break;
			}
		}

		public function dispose():void
		{
			_context.dispose();
		}

		private function init():void
		{
			_context.call("init");
		}

		public function get isRegistered():Boolean
		{
			return _isRegistered;
		}

		public function get registrationID():String
		{
			return _registrationID;
		}
	}
}
