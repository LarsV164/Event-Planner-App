using EventApp.OrganiserPortal.Models;

namespace EventApp.OrganiserPortal.Services
{
    // Laura interface voor Event.Test
    public interface IEventValidationService
    {
        bool IsValid(CreateEventInputModel model);
        List<System.ComponentModel.DataAnnotations.ValidationResult> Validate(CreateEventInputModel model);
    }
}
