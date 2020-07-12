package popups
{

    public class PopupFactory
    {
        public function PopupFactory()
        {
        }

        public static function makePopup(id: String): BasePopup
        {
            // Return a Popup
            switch (id)
            {
                case PopupTypes.LOGIN:
                    return new LoginPopup();
                    break;
                case PopupTypes.REGISTER:
                    return new RegisterPopup();
                    break;
                case PopupTypes.LOADING:
                    return new LoadingPopup();
                    break;
                case PopupTypes.PAPER:
                    return new PaperPopup();
                    break;
                case PopupTypes.SETTINGS:
                    return new SettingsPopup();
                    break;
                case PopupTypes.ERROR:
                    return new ErrorPopup();
                    break;
                case PopupTypes.VERIFY_EMAIL:
                    return new VerifyEmailPopup();
                    break;
                case PopupTypes.CHOOSE_NAME:
                    return new ChooseNamePopup();
                    break;
                default:
                    return null;
                    break;
            }
        }
    }
}
