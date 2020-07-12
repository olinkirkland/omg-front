package managers
{

    import flash.display.StageQuality;
    import flash.events.EventDispatcher;
    import flash.net.SharedObject;

    import signal.SignalManager;

    public final class SettingsManager extends EventDispatcher
    {
        private static var _instance: SettingsManager;
        private var configSharedObject: SharedObject;
        private var signalManager: SignalManager;

        public function SettingsManager()
        {
            if (_instance)
                throw new Error("Singleton; Use getInstance() instead");
            _instance = this;

            signalManager = SignalManager.getInstance();
            load();
        }

        public static function getInstance(): SettingsManager
        {
            if (!_instance)
                new SettingsManager();
            return _instance;
        }

        public function get settings(): Object
        {
            return configSharedObject.data;
        }

        public function load(): Object
        {
            configSharedObject = SharedObject.getLocal("omgforever-payload");
            if (configSharedObject.size == 0)
            {
                // Config doesn't exist so set all the default settings
                configSharedObject.data.highQuality = true;
                configSharedObject.data.highResolutionWallpapers = false;
                configSharedObject.data.rememberLogin = null;
                configSharedObject.flush();
            }

            // Apply quality
            signalManager.dispatch({setQuality: configSharedObject.data.highQuality ? StageQuality.BEST : StageQuality.LOW});

            return configSharedObject.data;
        }
    }
}