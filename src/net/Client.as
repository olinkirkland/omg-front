package net
{

    import flash.events.*;
    import flash.net.*;
    import flash.utils.setTimeout;

    import global.Util;

    import managers.LanguageManager;

    import managers.SettingsManager;

    import popups.PopupType;

    import signal.SignalEvent;
    import signal.SignalManager;
    import signal.SignalType;

    /**
     * ...
     * @author Olin Kirkland
     */

    public class Client extends EventDispatcher
    {
        private var socket:Socket;
        private var settingsManager:SettingsManager;
        private var signalManager:SignalManager;

        public var connected:Boolean;
        public var isLoggedIn:Boolean = false;

        // id refers to the id of the currently logged in user
        public static var id:String = "";

        public function Client():void
        {
            connected = false;

            // Signal Manager
            signalManager = SignalManager.getInstance();
            signalManager.addEventListener(SignalEvent.SIGNAL, handleSignal);

            // Settings Manager
            settingsManager = SettingsManager.getInstance();
        }

        public function handleSignal(signalEvent:SignalEvent):void
        {
            // Handle global Signals
            var payload:Object = signalEvent.payload;

            // Client action
            switch (signalEvent.action)
            {
                case ClientMessageType.REGISTER:
                    register(payload.email, payload.password);
                    break;
                case ServerMessageType.REGISTER_SUCCESS:
                    rawLogin(payload.email, payload.password);
                    break;
                case ClientMessageType.LOGIN:
                    login(payload.email, payload.password, payload.remember);
                    break;
                case ServerMessageType.LOGIN_SUCCESS:
                    isLoggedIn = true;
                    id         = payload as String;
                    break;
                case ServerMessageType.LOGIN_FAIL:
                    // Erase the rememberLogin
                    var config:SharedObject   = SharedObject.getLocal("omgforever-data");
                    config.data.rememberLogin = null;
                    config.flush();
                    break;
                case SignalType.RAW_LOGIN:
                    rawLogin(payload.email, payload.password);
                    break;
                case ClientMessageType.RESEND_VERIFY_CODE:
                    resendVerifyCode(payload as String);
                    break;
                case ClientMessageType.SUBMIT_VERIFY_CODE:
                    submitVerifyCode(payload.email, payload.verifyCode);
                    break;
                case ClientMessageType.CHOOSE_NAME:
                    chooseName(payload as String);
                    break;
                case ServerMessageType.CHOOSE_NAME_SUCCESS:
                    isLoggedIn = true;
                    id         = payload as String;
                    break;
                case ServerMessageType.LOGOUT_SUCCESS:
                    isLoggedIn = false;
                    id         = null;
                    break;
                case ClientMessageType.LOGOUT:
                    logout();
                    break;
                case ClientMessageType.REQUEST_USER_DATA:
                    send(new Message(signalEvent.action, payload));
                    break;
                case ClientMessageType.UPDATE_USER_DATA:
                    send(new Message(signalEvent.action, payload));
                    break;
                default:
                    break;
            }
        }

        public function create():void
        {
            // Create the socket
            socket = new Socket();

            // Ten second timeout
            socket.timeout = 10 * 1000;
            socket.addEventListener(Event.CONNECT, handleConnect);
            socket.addEventListener(Event.CLOSE, handleDisconnect);
            socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
            socket.addEventListener(IOErrorEvent.IO_ERROR, handleError);
            socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);

            connect();
        }

        public function connect():void
        {
            connected = false;
            socket.connect(Util.ADDRESS.IP, Util.ADDRESS.PORT);
        }

        private function handleConnect(e:Event):void
        {
            connected = true;
            dispatchEvent(new Event(Event.CONNECT));

            send(new Message(ClientMessageType.CONFIRM_CONNECTION));

            if (settingsManager.settings.rememberLogin)
            {
                setTimeout(function ():void
                {
                    rawLogin(settingsManager.settings.rememberLogin.email, settingsManager.settings.rememberLogin.password);
                }, 200);
            }
        }

        private function handleDisconnect(e:Event):void
        {
            connected = false;
            dispatchEvent(new Event(Event.CLOSE));

            // Try to reconnect
            connect();
        }

        public function register(email:String, password:String):void
        {
            // Register
            var salt:String = Util.hash(email, 10);
            password        = Util.hash(password + salt, 2000);
            send(new Message(ClientMessageType.REGISTER, {email: email, password: password}));
        }

        public function login(email:String, password:String, remember:Boolean = false):void
        {
            // Login
            var salt:String = Util.hash(email, 10);
            rawLogin(email, Util.hash(password + salt, 2000), remember);
        }

        public function rawLogin(email:String, password:String, remember:Boolean = false):void
        {
            // Raw login
            if (remember)
                SettingsManager.getInstance().settings.rememberLogin = {email: email, password: password};
            send(new Message(ClientMessageType.LOGIN, {email: email, password: password}));
        }

        public function resendVerifyCode(email:String):void
        {
            // Verify resend
            send(new Message(ClientMessageType.RESEND_VERIFY_CODE, {email: email}));
        }

        public function submitVerifyCode(email:String, verifyCode:String):void
        {
            // Verify
            send(new Message(ClientMessageType.SUBMIT_VERIFY_CODE, {email: email, verifyCode: verifyCode}));
        }

        public function chooseName(name:String):void
        {
            // Choose name
            send(new Message(ClientMessageType.CHOOSE_NAME, {name: name}));
        }

        public function logout():void
        {
            // Logout
            var config:SharedObject   = SharedObject.getLocal("omgforever-data");
            config.data.rememberLogin = null;
            config.flush();

            send(new Message(ClientMessageType.LOGOUT));
        }

        public function handleError(e:Event):void
        {
            // Couldn't connect to server, retrying
            connect();
        }

        private function socketDataHandler(e:ProgressEvent):void
        {
            try
            {
                var data:Object = socket.readObject();

                trace("[received] " + JSON.stringify(data));

                signalManager.dispatch(data.type, data.data);
                dispatchEvent(new MessageEvent(Message.serialize(data)));
            } catch (error:Error)
            {
                // Not an object
                // Ignore it
            }
        }


        public function send(m:Message):void
        {
            try
            {
                // Try to send an object to the socket
                trace("[send] " + JSON.stringify(m));
                socket.writeObject(m);
                socket.flush();
            } catch (error:Error)
            {
                // There's no connection, or there was a problem with the connection
                trace("An error was encountered when trying to send the message\n" + JSON.stringify(m));
            }
        }
    }
}