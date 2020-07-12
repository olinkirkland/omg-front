package {

    import com.hurlant.crypto.hash.SHA256;
    import com.hurlant.util.Hex;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.net.SharedObject;
    import flash.utils.ByteArray;

    import managers.SettingsManager;

    import mx.utils.UIDUtil;

    public class Service {
        // Version
        public static var VERSION:String;
        public static var VERSION_ID:String;

        // Server Address
        public static const ADDRESS:Object = {IP: "127.0.0.1", PORT: 43699};

        // Domain
        public static const DOMAIN:String = "http://www.omgforever.com/";

        // Items
        [Embed(source="/assets/items.json", mimeType="application/octet-stream")]
        public static const ITEMS_JSON:Class;
        public static var ITEMS:Object;

        // Splash
        [Embed(source="/assets/splash.json", mimeType="application/octet-stream")]
        public static const SPLASH_JSON:Class;

        public static function formatAssetURL(url:String):String {
            var settingsManager:SettingsManager = SettingsManager.getInstance();
            var wallpaperResolution:String = settingsManager.settings.highResolutionWallpapers ? "hr" : "sr";
            return DOMAIN + url.replace("%WALLPAPER_RESOLUTION%", wallpaperResolution);
        }


        public static function weightedRandom():Number {
            // Returns a random number that tends to fall closer toward .5 than 0 or 1
            var passes:int = 1 + (Math.random() * 9);

            var n:Number = 0;
            for (var i:int = 0; i < passes; i++) {
                n += Math.random() * (1 / passes);
            }

            return n;
        }

        public static function generateKey(numChunks:int = 4, chunkLength:int = 4):String {
            // Generate a random key in chunks of alphanumeric strings separated by hyphens
            var key:String = "";
            for (var i:int = 0; i < numChunks; i++) {
                key += randomString(chunkLength);
                if (i < numChunks - 1)
                    key += "-";
            }

            return key;
        }

        public static function hash(str:String, iterations:int = 1):String {
            var sha256:SHA256 = new SHA256();
            for (var i:int = 0; i < iterations; i++) {
                var src:ByteArray = Hex.toArray(str);
                var digest:ByteArray = sha256.hash(src);
                str = String(Hex.fromArray(digest))
            }
            return str;
        }

        public static function randomString(length:int = 10, dictionary:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"):String {
            var str:String = "";

            while (length > 0) {
                // Pick a random character from the dictionary
                str += dictionary.charAt(int(Math.random() * dictionary.length));
                length--;
            }

            return str;

        }

        public static function loremIpsum(minWordsPerSentence:int = 6, maxWordsPerSentence:int = 10, commaChance:Number = 10):String {
            // Dictionary of lorem ipsum words
            var dictionary:Array = ["ac", "accumsan", "ad", "adipiscing", "aliquam", "aliquet", "amet", "ante", "aptent", "at", "augue", "bibendum", "blandit", "class", "condimentum", "congue", "consectetur", "consequat", "conubia", "convallis", "cras", "curabitur", "dapibus", "diam", "dictum", "dignissim", "dolor", "donec", "dui", "duis", "eget", "eleifend", "elit", "enim", "erat", "eros", "est", "et", "etiam", "eu", "ex", "facilisis", "faucibus", "felis", "fermentum", "finibus", "fringilla", "fusce", "gravida", "hendrerit", "himenaeos", "id", "imperdiet", "in", "inceptos", "integer", "interdum", "ipsum", "justo", "lacinia", "lacus", "laoreet", "leo", "ligula", "litora", "lobortis", "lorem", "luctus", "maecenas", "magna", "malesuada", "massa", "mauris", "metus", "mi", "molestie", "morbi", "nam", "nec", "neque", "nibh", "nisl", "non", "nostra", "nulla", "nullam", "nunc", "orci", "ornare", "pellentesque", "per", "pharetra", "phasellus", "placerat", "porta", "posuere", "praesent", "pretium", "proin", "purus", "quam", "quis", "quisque", "rhoncus", "risus", "rutrum", "sagittis", "sapien", "scelerisque", "sed", "sem", "semper", "sit", "sociosqu", "sodales", "sollicitudin", "suscipit", "suspendisse", "taciti", "tempor", "tempus", "tincidunt", "torquent", "tortor", "turpis", "ullamcorper", "ultrices", "ultricies", "urna", "ut", "varius", "vehicula", "vel", "velit", "venenatis", "vestibulum", "vitae", "viverra"];

            // Pick sentence length
            var numWords:int = int(Math.random() * (maxWordsPerSentence - minWordsPerSentence)) + minWordsPerSentence;

            // Pick a random word
            var lastWord:String = dictionary[int(Math.random() * dictionary.length)];
            var word:String = lastWord;
            var wordIndex:int = 0;
            var sequentialCommas:int = 0;

            // This array will populate with words and separators (white space and punctuation)
            var sentence:Array = [];

            for (var i:int = 0; i < numWords; i++) {
                // Pick a word that's different than the last word that was picked
                word = lastWord;
                while (word == lastWord) {
                    word = dictionary[int(Math.random() * dictionary.length)];
                }

                // Start a new sentence
                if (wordIndex == 0) {
                    // Capitalize word
                    word = word.substring(0, 1).toUpperCase() + word.substring(1);
                } else {
                    // Pick separator
                    if (Math.random() * 100 < commaChance && sequentialCommas < 2) {
                        sequentialCommas++;
                        sentence.push(", ");
                    } else {
                        sequentialCommas = 0;
                        sentence.push(" ");
                    }
                }

                sentence.push(word);

                wordIndex++;
            }

            // Pick an ending
            var specialEndings:Array = ["?", "!", "..."];

            if (Math.random() > .1) {
                // Normal sentence ending
                sentence.push(".");
            } else {
                // Special sentence ending
                sentence.push(specialEndings[int(Math.random() * specialEndings.length)]);
            }

            sentence.push(" ");

            return sentence.join("");
        }

        public static function formatFileSize(bytes:Number, decimalSignificantUnits:Boolean = true, fixedDecimalLength:int = 2, fullWord:Boolean = false):String {
            var threshold:Number = decimalSignificantUnits ? 1000 : 1024;
            if (bytes < threshold) {
                // Ends here
                return bytes.toFixed(0) + " B";
            }

            var abbreviatedTraditionalUnits:Array = ["KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"];

            var abbreviatedDecimalUnits:Array = ["kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];

            var fullTraditionalUnits:Array = ["Kibibyte", "Mebibyte", "Gibibyte", "Tebibyte", "Pebibyte", "Exbibyte", "Zebibyte", "Yobibyte"];

            var fullDecimalUnits:Array = ["Kilobyte", "Megabyte", "Gigabyte", "Terabyte", "Petabyte", "Exabyte", "Zettabyte", "Yottabyte"];

            var units:Array = fullWord ? (decimalSignificantUnits ? fullDecimalUnits : fullTraditionalUnits) : (decimalSignificantUnits ? abbreviatedDecimalUnits : abbreviatedTraditionalUnits);
            var unitIndex:int = -1;

            do {
                bytes /= threshold;
                unitIndex++;
            } while (bytes >= threshold && unitIndex < units.length - 1);

            var plural:String = (fullWord && bytes == 1) ? "s" : "";

            return bytes.toFixed(2) + " " + units[unitIndex] + plural;
        }

        public static function eagerLoad():void {

        }
    }
}