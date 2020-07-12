package signal
{
	import flash.events.Event;


	public class SignalEvent extends Event
	{
		public var payload : Object;
		public static var SIGNAL : String = "signal";


		public function SignalEvent(payload : Object)
		{
			this.payload = payload;
			super(SignalEvent.SIGNAL);
		}
	}
}
