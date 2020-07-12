package managers {

    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.BulkProgressEvent;

    import flash.display.Bitmap;

    import flash.events.Event;
    import flash.events.EventDispatcher;

    public final class AssetManager extends EventDispatcher {
        [Embed(source="/assets/icons/settings.png")]
        public static const ICON_SETTINGS:Class;


        private static var _instance:AssetManager;
        private var bulkLoader:BulkLoader;
        public var assets:Object;

        public function AssetManager() {
            if (_instance)
                throw new Error("Singleton; Use getInstance() instead");
            _instance = this;

            if (!assets)
                assets = {};
        }

        public static function getInstance():AssetManager {
            if (!_instance)
                new AssetManager();
            return _instance;
        }

        public function add(key:String, data:*):void {
            assets[key] = data;
        }

        public function get(key:String):* {
            return assets.hasOwnProperty(key) ? assets[key] : null;
        }

        public function load():void {
            // Populate the ITEMS object
            Service.ITEMS = {};
            var items:Object = JSON.parse(new Service.ITEMS_JSON());
            var assetQueue:Array = [];

            for (var key:String in items) {
                var item:Item = new Item();
                item.fromObject(items[key]);
                item.id = key;

                Service.ITEMS[key] = item;

                if (item.asset)
                    assetQueue.push(item);
            }

            // Download the assets
            if (bulkLoader)
                removeEventListeners();
            else
                bulkLoader = new BulkLoader();

            bulkLoader.addEventListener(BulkLoader.PROGRESS, onLoadProgress);
            bulkLoader.addEventListener(BulkLoader.COMPLETE, onLoadComplete);

            for each (var assetItem:Object in assetQueue)
                bulkLoader.add(Service.formatAssetURL(assetItem.asset.url) + "?" + Service.VERSION, {id: assetItem.id});

            bulkLoader.start();
        }

        private function removeEventListeners():void {
            bulkLoader.removeEventListener(BulkLoader.PROGRESS, onLoadProgress);
            bulkLoader.removeEventListener(BulkLoader.COMPLETE, onLoadComplete);
        }

        private function onLoadProgress(event:BulkProgressEvent):void {
            dispatchEvent(event);
        }

        private function onLoadComplete(event:BulkProgressEvent):void {
            dispatchEvent(event);
        }
    }
}
