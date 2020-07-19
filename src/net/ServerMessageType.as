package net
{
    public class ServerMessageType
    {
        /*
        Server -> Client
         */

        public static var REGISTER_SUCCESS:String          = "registerSuccess";
        public static var REGISTER_FAIL:String             = "registerFail";
        public static var LOGIN_SUCCESS:String             = "loginSuccess";
        public static var LOGIN_FAIL:String                = "loginFail";
        public static var USER_NOT_VERIFIED:String         = "userNotVerified";
        public static var USER_NOT_NAMED:String            = "userNotNamed";
        public static var SEND_VERIFY_EMAIL_SUCCESS:String = "sendVerifyEmailSuccess";
        public static var SEND_VERIFY_EMAIL_FAIL:String    = "sendVerifyEmailFail";
        public static var VERIFY_EMAIL_SUCCESS:String      = "verifyEmailSuccess";
        public static var VERIFY_EMAIL_FAIL:String         = "verifyEmailFail";
        public static var CHOOSE_NAME_SUCCESS:String       = "chooseNameSuccess";
    }
}
