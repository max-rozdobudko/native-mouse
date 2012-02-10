package org.log5f.air.extensions
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	import org.log5f.air.extensions.events.NativeMouseEvent;
	
	[Event(name="nativeMouseMove", type="org.log5f.air.extensions.events.NativeMouseEvent")]
	[Event(name="nativeMouseDown", type="org.log5f.air.extensions.events.NativeMouseEvent")]
	[Event(name="nativeMouseUp", type="org.log5f.air.extensions.events.NativeMouseEvent")]
	
	public class NativeMouse extends EventDispatcher implements INativeMouse
	{
		//----------------------------------------------------------------------
		//
		//	Class cosntants
		//
		//----------------------------------------------------------------------
		
		/** @priate */
		private static const ID:String = "org.log5f.air.extensions.mouse.NativeMouse";
		
		//----------------------------------------------------------------------
		//
		//	Constructor
		//
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function NativeMouse()
		{
			super();
			
			this.context = ExtensionContext.createExtensionContext(ID, null);
		}
		
		//----------------------------------------------------------------------
		//
		//	Variables
		//
		//----------------------------------------------------------------------
		
		/** @private */
		private var context:ExtensionContext;
		
		//----------------------------------------------------------------------
		//
		//	Methods
		//
		//----------------------------------------------------------------------

		//-----------------------------------
		//	Methods: INativeMouse
		//-----------------------------------
		
		/** @inheritDoc */
		public function isSupported():Boolean
		{
			return this.context.call("isSupported") as Boolean;
		}
		
		/** @inheritDoc */
		public function captureMouse():Boolean
		{
			const result:Boolean = this.context.call("captureMouse") as Boolean;
			
			if (result)
			{
				this.context.addEventListener(StatusEvent.STATUS, statusHandler);
			}
			
			return result;
		}
		
		/** @inheritDoc */
		public function releaseMouse():Boolean
		{
			const result:Boolean = this.context.call("releaseMouse") as Boolean;
			
			this.context.removeEventListener(StatusEvent.STATUS, statusHandler);
			
			return result;
		}
		
		/** @inheritDoc */
		public function getMouseInfo():Object
		{
			var result:Object = {};
			
			this.context.call("getMouseInfo", result);
			
			return result;
		}
		
		//----------------------------------------------------------------------
		//
		//	Handlers
		//
		//----------------------------------------------------------------------

		/** @private */
		private function statusHandler(event:StatusEvent):void
		{
			var info:Object;
			
			switch (event.code)
			{
				case "Mouse.Down.LeftButton" :
					
					info = this.getMouseInfo();
					
					this.dispatchEvent(new NativeMouseEvent(
						NativeMouseEvent.NATIVE_MOUSE_DOWN, info.mouseX, info.mouseY));
					
					break;
				
				case "Mouse.Up.LeftButton" :
					
					info = this.getMouseInfo();
					
					this.dispatchEvent(new NativeMouseEvent(
						NativeMouseEvent.NATIVE_MOUSE_UP, info.mouseX, info.mouseY));
					
					break;
				
				case "Mouse.Move" :
					
					info = this.getMouseInfo();
					
					this.dispatchEvent(new NativeMouseEvent(
						NativeMouseEvent.NATIVE_MOUSE_MOVE, info.mouseX, info.mouseY));
					
					break;
			}
		}
	}
}