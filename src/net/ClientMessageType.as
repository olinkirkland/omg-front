package net
{
    public class ClientMessageType
    {
        /*
        Client -> Server
         */

        public static const REQUEST_USER_DATA:String  = "requestUserData";
        public static const UPDATE_USER_DATA:String   = "updateUserData";
        public static const REGISTER:String           = "register";
        public static const LOGIN:String              = "login";
        public static const LOGOUT:String             = "logout";
        public static const RESEND_VERIFY_CODE:String = "resendVerifyCode";
        public static const SUBMIT_VERIFY_CODE:String = "submitVerifyCode";
        public static const CHOOSE_NAME:String        = "chooseName";
        public static const CONFIRM_CONNECTION:String = "confirmConnection";
    }
}
