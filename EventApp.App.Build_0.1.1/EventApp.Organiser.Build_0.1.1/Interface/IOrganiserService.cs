using EventApp.OrganiserPortal.Models;

namespace EventApp.OrganiserPortal.Interface
{
    public interface IOrganiserService
    {
        Task<int> GetNextEventIdAsync();

        Task CreateEventAsync(
            int organiserId,
            int eventId,
            CreateEventInputModel input);

        Task AddEventImagesAsync(
            int eventId,
            List<string> imageUrls);
    }
}
