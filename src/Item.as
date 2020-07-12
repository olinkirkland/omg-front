package
{


    public class Item
    {
        public var id: String;
        public var name: String;
        public var description: String;
        public var excludeFromInventory: Boolean;
        public var price: Number;
        public var value: Number;
        public var tags: Array;
        public var type: String;
        public var asset: Object;

        public function Item()
        {
        }

        public function fromObject(object: Object): void
        {
            for (var key: String in object)
            {
                if (this.hasOwnProperty(key))
                {
                    this[key] = object[key];
                }
            }
        }
    }
}
