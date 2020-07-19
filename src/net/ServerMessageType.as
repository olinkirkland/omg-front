package net
{
    public class ServerMessageType
    {
        /*
        Server -> Client
         */

        public static const REGISTER_SUCCESS:String          = "registerSuccess";
        public static const REGISTER_FAIL:String             = "registerFail";
        public static const LOGIN_SUCCESS:String             = "loginSuccess";
        public static const LOGIN_FAIL:String                = "loginFail";
        public static const LOGIN_INTERNAL:String            = "loginInternal";
        public static const USER_NOT_VERIFIED:String         = "userNotVerified";
        public static const USER_NOT_NAMED:String            = "userNotNamed";
        public static const SEND_VERIFY_EMAIL_SUCCESS:String = "sendVerifyEmailSuccess";
        public static const SEND_VERIFY_EMAIL_FAIL:String    = "sendVerifyEmailFail";
        public static const VERIFY_EMAIL_SUCCESS:String      = "verifyEmailSuccess";
        public static const VERIFY_EMAIL_FAIL:String         = "verifyEmailFail";
        public static const CHOOSE_NAME_SUCCESS:String       = "chooseNameSuccess";
        public static const LOGOUT_SUCCESS:String            = "logoutSuccess";
        public static const LOGOUT_FAIL:String               = "logoutFail";
        public static const USER_DATA:String                 = "userData";
    }
}
