package signal
{

    import flash.events.EventDispatcher;


    public class SignalManager extends EventDispatcher
    {
        private static var _instance: SignalManager;


        public function SignalManager()
        {
            if (_instance)
                throw new Error("Singleton; Use getInstance() instead");
            _instance = this;
        }


        public function dispatch(payload: Object): void
        {
            // Dispatch
            if (payload)
            {
                dispatchEvent(new SignalEvent(payload));
            }
            else
            {
                trace("Payload cannot be null")
            }
        }


        public static function getInstance(): SignalManager
        {
            if (!_instance)
            {
                new SignalManager();
            }
            return _instance;
        }
    }
}
