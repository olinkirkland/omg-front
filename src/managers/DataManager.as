package managers
{

    import flash.events.EventDispatcher;

    import net.ClientMessageType;
    import net.ServerMessageType;

    import signal.SignalEvent;
    import signal.SignalManager;

    public final class DataManager extends EventDispatcher
    {
        private static var _instance:DataManager;
        private var requestCallbacks:Object = {};
        private var signalManager:SignalManager;

        public var users:Object;

        public function DataManager()
        {
            if (_instance)
                throw new Error("Singleton; Use getInstance() instead");
            _instance = this;

            signalManager = SignalManager.getInstance();
            signalManager.addEventListener(SignalEvent.SIGNAL, handleSignal);

            users = {};
        }

        public function requestUser(id:String, callback:Function):void
        {
            if (!requestCallbacks[id])
                requestCallbacks[id] = [];
            requestCallbacks[id].push(callback);
            signalManager.dispatch(ClientMessageType.REQUEST_USER_DATA, id);
        }

        private function handleSignal(signalEvent:SignalEvent):void
        {
            // Handle global Signals
            var payload:Object = signalEvent.payload;

            if (signalEvent.action == ServerMessageType.USER_DATA && signalEvent.payload)
            {
                var user:User     = User.serialize(payload);
                users[payload.id] = user;
                if (requestCallbacks[payload.id])
                {
                    for each (var callback:Function in requestCallbacks[payload.id])
                        callback.apply(null, [user]);
                    delete requestCallbacks[payload.id];
                }
            }
        }

        public static function getInstance():DataManager
        {
            if (!_instance)
                new DataManager();
            return _instance;
        }
    }
}