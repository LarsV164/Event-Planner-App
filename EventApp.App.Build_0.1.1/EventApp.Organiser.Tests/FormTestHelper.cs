using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using EventApp.OrganiserPortal.Models;

namespace EventApp.OrganiserPortal.Tests
{
    public static class FormTestHelper
    {
        public static CreateEventInputModel MaakGeldigeInvoer()
        {
            return new CreateEventInputModel
            {
                EventName = "Testevenement",
                IndoorsOutdoors = "Binnen",
                Description = "Een evenement voor automatische tests.",
                Address = "Teststraat 1, Heerlen",
                Latitude = 50.8882m,
                Longitude = 5.9795m,
                HasStandingPlaces = true,
                HasSittingPlaces = false,
                DisabledParkingAvailable = false,
                DisabledToiletAvailable = false,
                WheelchairAccessibleToilet = false,
                Tickets = new List<CreateTicketInputModel>
                {
                    new CreateTicketInputModel
                    {
                        TicketType = "Standaard",
                        Price = 10m
                    }
                }
            };
        }

        public static (bool IsGeldig, List<ValidationResult> Fouten) Valideer(
            CreateEventInputModel input)
        {
            var fouten = new List<ValidationResult>();
            var context = new ValidationContext(input);

            bool isGeldig = Validator.TryValidateObject(
                input,
                context,
                fouten,
                validateAllProperties: true);

            return (isGeldig, fouten);
        }
    }
}
