using EventApp.OrganiserPortal.Models;
using Microsoft.AspNetCore.Mvc;

namespace EventApp.OrganiserPortal.Services
//laura interface voor Ticket.Test
{
    public interface ITicketValidationService
    {
        bool IsValid(CreateTicketInputModel ticket);
    }
}
