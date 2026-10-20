using EventApp.OrganiserPortal.Models;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace EventApp.OrganiserPortal.Services
{
    public class TicketValidationService : ITicketValidationService
    {
        public bool IsValid(CreateTicketInputModel ticket)
        {
            ValidationContext context = new ValidationContext(ticket);
            List<ValidationResult> results = new List<ValidationResult>();

            return Validator.TryValidateObject(
                ticket,
                context,
                results,
                validateAllProperties: true);
        }
    }
}