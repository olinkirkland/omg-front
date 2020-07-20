package popups
{

    public class PopupFactory
    {
        public function PopupFactory()
        {
        }

        public static function makePopup(id:String):BasePopup
        {
            // Return a Popup
            switch (id)
            {
                case PopupType.LOGIN:
                    return new LoginPopup();
                    break;
                case PopupType.REGISTER:
                    return new RegisterPopup();
                    break;
                case PopupType.LOADING:
                    return new LoadingPopup();
                    break;
                case PopupType.PAPER:
                    return new PaperPopup();
                    break;
                case PopupType.SETTINGS:
                    return new SettingsPopup();
                    break;
                case PopupType.ERROR:
                    return new ErrorPopup();
                    break;
                case PopupType.VERIFY_EMAIL:
                    return new VerifyEmailPopup();
                    break;
                case PopupType.CHOOSE_NAME:
                    return new ChooseNamePopup();
                    break;
                case PopupType.INPUT_TEXT:
                    return new InputTextPopup();
                    break;
                default:
                    return null;
                    break;
            }
        }
    }
}
