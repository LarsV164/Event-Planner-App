using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using EventApp.OrganiserPortal.Interface;
using EventApp.OrganiserPortal.Models;
using Microsoft.Extensions.Logging;

namespace EventApp.OrganiserPortal.Services
{
    public class LoggingOrganiserService : IOrganiserService
    {
        private readonly IOrganiserService _organiserService;
        private readonly ILogger<LoggingOrganiserService> _logger;

        // Ontvang de onderliggende service en logger via de constructor.
        public LoggingOrganiserService(
            IOrganiserService organiserService,
            ILogger<LoggingOrganiserService> logger)
        {
            _organiserService = organiserService;
            _logger = logger;
        }

        public Task<int> GetNextEventIdAsync()
        {
            // Vraag het volgende evenementnummer op via de onderliggende service.
            return _organiserService.GetNextEventIdAsync();
        }

        public async Task CreateEventAsync(
            int organiserId,
            int eventId,
            CreateEventInputModel input)
        {
            try
            {
                // Wacht tot de onderliggende service klaar is met opslaan.
                await _organiserService.CreateEventAsync(
                    organiserId,
                    eventId,
                    input);
            }
            catch (Exception exception)
            {
                // Log de uitzondering met het evenementnummer en de organisator.
                _logger.LogError(
                    exception,
                    "Opslaan van evenementgegevens voor evenement {EventId} door organisator {OrganiserId} is mislukt.",
                    eventId,
                    organiserId);

                // Geef de oorspronkelijke uitzondering door aan de aanroeper.
                throw;
            }

            // Schrijf de succesmelding pas nadat het opslaan is gelukt.
            _logger.LogInformation(
                "Evenementgegevens opgeslagen voor evenement {EventId} door organisator {OrganiserId}.",
                eventId,
                organiserId);
        }

        public Task AddEventImagesAsync(
            int eventId,
            List<string> imageUrls)
        {
            // Geef de afbeeldingen door aan de onderliggende service.
            return _organiserService.AddEventImagesAsync(
                eventId,
                imageUrls);
        }
    }
}