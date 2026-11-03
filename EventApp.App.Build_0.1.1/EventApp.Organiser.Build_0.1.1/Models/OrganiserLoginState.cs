namespace EventApp.OrganiserPortal.Models
{
    public enum OrganiserLoginState
    {
        LoginForm,
        Authenticating,
        LoginError,
        AccountInactive,
        LoggedIn,
        LoggedOut,
        SessionExpired,
        PasswordRecovery,
        ResetLinkSent
    }
}
