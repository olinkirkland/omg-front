package net
{
    public class ClientMessageType
    {
        /*
        Client -> Server
         */

        public static var REQUEST_USER_DATA:String  = "requestUserData";
        public static var REGISTER:String           = "register";
        public static var LOGIN:String              = "login";
        public static var LOGOUT:String             = "logout";
        public static var RESEND_VERIFY_CODE:String = "resendVerifyCode";
        public static var SUBMIT_VERIFY_CODE:String = "submitVerifyCode";
        public static var CHOOSE_NAME:String        = "chooseName";
        public static var CONFIRM_CONNECTION:String = "confirmConnection";
    }
}
