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

package com.alyeska.shared.ane.gcm.libInterface.events
{

	import com.alyeska.shared.ane.gcm.libInterface.GCMPushInterface;

	import flash.events.Event;

	public class GCMEvent extends Event
	{

		public var deviceRegistrationID:String;
		public var message:String;
		public var isRegistered:Boolean;
		public var errorCode:String;
		public var statusCode:String;

		static public const REGISTERED:String = "GCMEvent.REGISTERED";
		static public const NOT_REGISTERED:String = "GCMEvent.NOT_REGISTERED";
		static public const IS_REGISTERED:String = "GCMEvent.IS_REGISTERED";
		static public const UNREGISTERED:String = "GCMEvent.UNREGISTERED";
		static public const MESSAGE:String = "GCMEvent.MESSAGE";
		static public const FOREGROUND_MESSAGE:String = "GCMEvent.FOREGROUND_MESSAGE";
		static public const ERROR:String = "GCMEvent.ERROR";
		static public const RECOVERABLE_ERROR:String = "GCMEvent.RECOVERABLE_ERROR";


		/**
		 * Constructor.
		 *
		 * @param type Event type.
		 * @param message The message returned from jar.
		 * @param bubbles Whether or not the event bubbles.
		 * @param cancelable Whether or not the event is cancelable.
		 */
		public function GCMEvent(type:String, message:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);

			switch (type)
			{
				case REGISTERED :
					this.deviceRegistrationID = message;
					this.message = GCMPushInterface.REGISTERED_INFO;
					this.isRegistered = true;
					break;
				case NOT_REGISTERED :
					this.deviceRegistrationID = GCMPushInterface.NO_REGID;
					this.message = "false";
					this.isRegistered = false;
					break;
				case IS_REGISTERED :
					this.deviceRegistrationID = message;
					this.message = "true";
					this.isRegistered = true;
					break;
				case UNREGISTERED :
					this.deviceRegistrationID = GCMPushInterface.NO_REGID;
					this.message = GCMPushInterface.UNREGISTERED_INFO;
					this.isRegistered = false;
					break;
				case MESSAGE :
					this.message = message;
					this.isRegistered = true;
					break;
				case FOREGROUND_MESSAGE :
					this.message = message;
					this.isRegistered = true;
					break;
				case RECOVERABLE_ERROR :
					this.errorCode = message;
					break;
				default :
					break;
			}
		}
	}
}
