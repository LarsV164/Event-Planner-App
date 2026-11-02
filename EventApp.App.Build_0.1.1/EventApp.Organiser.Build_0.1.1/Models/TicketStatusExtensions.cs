using System;
using System.Collections.Generic;
using System.Linq;

namespace EventApp.OrganiserPortal.Models
{
    // toegestane statusovergangen
    public static class TicketStatusExtensions
    {
        private static readonly IReadOnlyDictionary<TicketStatus, TicketStatus[]> AllowedTransitions =
            new Dictionary<TicketStatus, TicketStatus[]>
            {
                [TicketStatus.Created] = new[]
                {
                    TicketStatus.Available // publiceren
                },
                [TicketStatus.Available] = new[]
                {
                    TicketStatus.PendingPayment, // koop starten
                    TicketStatus.Cancelled,       // annuleren
                    TicketStatus.Expired          // event voorbij
                },
                [TicketStatus.PendingPayment] = new[]
                {
                    TicketStatus.Sold,      // betaling gelukt
                    TicketStatus.Available  // betaling mislukt
                },
                [TicketStatus.Sold] = new[]
                {
                    TicketStatus.ListedForResale, // doorverkopen
                    TicketStatus.Transferred,     // overdragen
                    TicketStatus.Used,            // qr gescand
                    TicketStatus.Refunded,        // refund goedgekeurd
                    TicketStatus.Cancelled,       // annuleren
                    TicketStatus.Expired          // event voorbij
                },
                [TicketStatus.ListedForResale] = new[]
                {
                    TicketStatus.Sold,      // opnieuw verkocht
                    TicketStatus.Cancelled, // annuleren
                    TicketStatus.Expired    // event voorbij
                },
                [TicketStatus.Transferred] = new[]
                {
                    TicketStatus.Sold // overdracht geaccepteerd
                },
                [TicketStatus.Used] = Array.Empty<TicketStatus>(),
                [TicketStatus.Refunded] = Array.Empty<TicketStatus>(),
                [TicketStatus.Cancelled] = Array.Empty<TicketStatus>(),
                [TicketStatus.Expired] = Array.Empty<TicketStatus>()
            };

        // mogelijke volgende statussen
        public static IReadOnlyCollection<TicketStatus> GetAllowedTransitions(this TicketStatus status)
        {
            return AllowedTransitions.TryGetValue(status, out var transitions)
                ? transitions
                : Array.Empty<TicketStatus>();
        }

        // controleer overgang
        public static bool CanTransitionTo(this TicketStatus current, TicketStatus next)
        {
            return current.GetAllowedTransitions().Contains(next);
        }

        // eindstatus check
        public static bool IsTerminal(this TicketStatus status)
        {
            return status.GetAllowedTransitions().Count == 0;
        }
    }
}
