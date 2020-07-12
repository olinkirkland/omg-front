package managers
{


    public class LanguageManager
    {
        [Embed(source="/assets/languages/english.json", mimeType='application/octet-stream')]
        private static const EN: Class;
        private static const en: String = new EN();

        [Embed(source="/assets/languages/spanish.json", mimeType='application/octet-stream')]
        private static const ES: Class;
        private static const es: String = new ES();

        [Embed(source="/assets/languages/german.json", mimeType='application/octet-stream')]
        private static const DE: Class;
        private static const de: String = new DE();

        [Embed(source="/assets/languages/french.json", mimeType='application/octet-stream')]
        private static const FR: Class;
        private static const fr: String = new FR();

        private static var language: Object;
        private static var defaultLanguage: String = "en";

        public function LanguageManager()
        {
        }

        public static function loadLanguage(): void
        {
            language = JSON.parse(LanguageManager[defaultLanguage]);
        }

        public static function getText(id: String): String
        {
            if (!language)
                loadLanguage();

            // Returns the value of id if it exists and returns the id if a value cannot be found
            return (language.hasOwnProperty(id)) ? language[id] : "[" + id + "]";
        }
    }
}
