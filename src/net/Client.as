package net
{

    import flash.events.*;
    import flash.net.*;

    import global.Util;

    import managers.SettingsManager;

    import signal.SignalEvent;
    import signal.SignalManager;

    /**
     * ...
     * @author Olin Kirkland
     */

    public class Client extends EventDispatcher
    {
        private var socket:Socket;
        public var connected:Boolean;
        private var settingsManager:SettingsManager;
        private var signalManager:SignalManager;
        public var isLoggedIn:Boolean = false;

        // id refers to the id of the currently logged in user
        public var id:String = "";

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
            if (payload.hasOwnProperty("action"))
            {
                var args:Object = payload.args;
                switch (payload.action)
                {
                    case "register":
                        register(args.email, args.password, args.betaKey);
                        break;
                    case "login":
                        login(args.email, args.password, args.remember);
                        break;
                    case "rawLogin":
                        rawLogin(args.email, args.password);
                        break;
                    case "resendVerifyCode":
                        resendVerifyCode(args.email);
                        break;
                    case "submitVerifyCode":
                        submitVerifyCode(args.email, args.verifyCode);
                        break;
                    case "submitName":
                        chooseName(args.name);
                        break;
                    case "logout":
                        logout();
                        break;
                    default:
                        trace("Unhandled Action: " + payload.action);
                        break;
                }
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
                rawLogin(settingsManager.settings.rememberLogin.email, settingsManager.settings.rememberLogin.password);
        }

        private function handleDisconnect(e:Event):void
        {
            connected = false;
            dispatchEvent(new Event(Event.CLOSE));

            // Try to reconnect
            connect();
        }

        public function register(email:String, password:String, betaKey:String):void
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
            var config:SharedObject   = SharedObject.getLocal("omgforever-payload");
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
                signalManager.dispatch(data);
                dispatchEvent(new MessageEvent(data));
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