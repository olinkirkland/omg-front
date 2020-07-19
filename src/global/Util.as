package global
{

    import com.hurlant.crypto.hash.SHA256;
    import com.hurlant.util.Hex;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.net.SharedObject;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;

    import managers.SettingsManager;

    import mx.utils.UIDUtil;

    public class Util
    {
        // Version
        public static var VERSION:String;
        public static var VERSION_ID:String;

        // Assets
        public static var LOCAL_STORAGE_PATH:String = "";

        // Server Address
        public static const ADDRESS:Object = {IP: "127.0.0.1", PORT: 43699};

        public static function local(url:String):String
        {
            return LOCAL_STORAGE_PATH + url;
        }

        public static function hash(str:String, iterations:int = 1):String
        {
            var sha256:SHA256 = new SHA256();
            for (var i:int = 0; i < iterations; i++)
            {
                var src:ByteArray    = Hex.toArray(str);
                var digest:ByteArray = sha256.hash(src);
                str                  = String(Hex.fromArray(digest))
            }
            return str;
        }

        public static function formatAssetURL(url:String):String
        {
            var settingsManager:SettingsManager = SettingsManager.getInstance();
            var wallpaperResolution:String      = settingsManager.settings.highResolutionWallpapers ? "hr" : "sr";
            return url.replace("%WALLPAPER_RESOLUTION%", wallpaperResolution);
        }

        public static function formatFileSize(bytes:Number, decimalSignificantUnits:Boolean = true, fixedDecimalLength:int = 2, fullWord:Boolean = false):String
        {
            var threshold:Number = decimalSignificantUnits ? 1000 : 1024;
            if (bytes < threshold)
            {
                // Ends here
                return bytes.toFixed(0) + " B";
            }

            var abbreviatedTraditionalUnits:Array = ["KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"];

            var abbreviatedDecimalUnits:Array = ["kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];

            var fullTraditionalUnits:Array = ["Kibibyte", "Mebibyte", "Gibibyte", "Tebibyte", "Pebibyte", "Exbibyte", "Zebibyte", "Yobibyte"];

            var fullDecimalUnits:Array = ["Kilobyte", "Megabyte", "Gigabyte", "Terabyte", "Petabyte", "Exabyte", "Zettabyte", "Yottabyte"];

            var units:Array   = fullWord ? (decimalSignificantUnits ? fullDecimalUnits : fullTraditionalUnits) : (decimalSignificantUnits ? abbreviatedDecimalUnits : abbreviatedTraditionalUnits);
            var unitIndex:int = -1;

            do
            {
                bytes /= threshold;
                unitIndex++;
            } while (bytes >= threshold && unitIndex < units.length - 1);

            var plural:String = (fullWord && bytes == 1) ? "s" : "";

            return bytes.toFixed(2) + " " + units[unitIndex] + plural;
        }
    }
}