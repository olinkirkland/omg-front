package managers
{

    import flash.events.Event;
    import flash.events.EventDispatcher;

    import signal.SignalEvent;
    import signal.SignalManager;

    public final class DataManager extends EventDispatcher
    {
        private static var _instance: DataManager;
        private var signalManager: SignalManager;

        public static const DATA_UPDATE: String = "dataUpdate";

        public var data: Object;

        public function DataManager()
        {
            if (_instance)
                throw new Error("Singleton; Use getInstance() instead");
            _instance = this;

            signalManager = SignalManager.getInstance();
            signalManager.addEventListener(SignalEvent.SIGNAL, handleSignal);

            data = {};
        }

        private function handleSignal(signalEvent: SignalEvent): void
        {
            // Handle global Signals
            var payload: Object = signalEvent.payload;

            if (payload.hasOwnProperty("requestReturn"))
            {
                data[payload.requestReturn.id] = payload.requestReturn.data;
                dispatchEvent(new Event(DataManager.DATA_UPDATE));
            }
        }

        public static function getInstance(): DataManager
        {
            if (!_instance)
                new DataManager();
            return _instance;
        }
    }
}