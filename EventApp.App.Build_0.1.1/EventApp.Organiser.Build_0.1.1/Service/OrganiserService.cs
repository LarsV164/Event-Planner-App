using EventApp.OrganiserPortal.Interface;
using EventApp.OrganiserPortal.Models;
using EventApp.OrganiserPortal.Repositories;

namespace EventApp.OrganiserPortal.Services
{
    public class OrganiserService : IOrganiserService
    {
        private readonly IOrganiserRepository _organiserRepository;

        public OrganiserService(
            IOrganiserRepository organiserRepository)
        {
            _organiserRepository = organiserRepository;
        }

        public Task<int> GetNextEventIdAsync()
        {
            return _organiserRepository.GetNextEventIdAsync();
        }

        public Task CreateEventAsync(
            int organiserId,
            int eventId,
            CreateEventInputModel input)
        {
            return _organiserRepository.CreateEventAsync(
                organiserId,
                eventId,
                input);
        }

        public Task AddEventImagesAsync(
            int eventId,
            List<string> imageUrls)
        {
            return _organiserRepository.AddEventImagesAsync(
                eventId,
                imageUrls);
        }
    }
}