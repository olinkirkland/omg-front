package net
{

    import flash.events.*;

    public class MessageEvent extends Event
    {
        public static var DATA:String = "messageEventData";

        public var message:Message;

        public function MessageEvent(message:Message):void
        {
            super(MessageEvent.DATA);
            this.message = message;
        }
    }
}