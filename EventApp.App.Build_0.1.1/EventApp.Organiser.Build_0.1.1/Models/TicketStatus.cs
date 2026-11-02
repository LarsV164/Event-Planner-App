namespace EventApp.OrganiserPortal.Models
{
    // leven van een ticket
    public enum TicketStatus
    {
        Created,
        Available,
        PendingPayment,
        Sold,
        ListedForResale,
        Transferred,
        Used,
        Refunded,
        Cancelled,
        Expired
    }
}
