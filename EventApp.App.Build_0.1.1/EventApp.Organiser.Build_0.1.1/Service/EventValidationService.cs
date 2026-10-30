using EventApp.OrganiserPortal.Models;
using System.ComponentModel.DataAnnotations;

namespace EventApp.OrganiserPortal.Services
{
    public class EventValidationService : IEventValidationService
    {
        public bool IsValid(CreateEventInputModel model)
        {
            var results = Validate(model);
            return results.Count == 0;
        }

        public List<ValidationResult> Validate(CreateEventInputModel model)
        {
            var results = new List<ValidationResult>();
            Validator.TryValidateObject(model, new ValidationContext(model), results, validateAllProperties: true);
            return results;
        }
    }
}
