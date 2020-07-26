package managers
{
    public class User
    {
        public var id:String;
        public var email:String;

        public var name:String;

        public var aboutTitle:String;
        public var aboutBody:String;

        public var coins:int;
        public var experience:int;
        public var level:int;
        public var levelExperience:int;

        public var friendRequests:Array;
        public var friends:Array;

        public function User()
        {
        }

        public static function serialize(untypedUser:Object):User
        {
            var user:User        = new User();
            user.id              = untypedUser.id;
            user.email           = untypedUser.email;
            user.name            = untypedUser.name;
            user.aboutTitle      = untypedUser.aboutTitle;
            user.aboutBody       = untypedUser.aboutBody;
            user.coins           = untypedUser.coins;
            user.experience      = untypedUser.experience;
            user.level           = untypedUser.level;
            user.levelExperience = untypedUser.levelExperience;
            user.friends         = untypedUser.friends;
            user.friendRequests  = untypedUser.friendRequests;

            return user;
        }
    }
}
