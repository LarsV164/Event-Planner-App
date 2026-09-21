// EPT11 - Locatie ontbreekt.
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using EventApp.OrganiserPortal.Models;
using EventApp.OrganiserPortal.Pages.Portal;
using EventApp.OrganiserPortal.Repositories;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Configuration;
using Moq;
using Xunit;

namespace EventApp.Organiserportal.Tests
{
    public class CreateEventEpt11Tests
    {
        [Fact]
        public void EPT11_ZonderLocatie_GeeftValidatiefouten()
        {
            // ARRANGE: alle overige verplichte invoer is ingevuld.
            var input = MaakInvoerZonderLocatie();
            var fouten = new List<ValidationResult>();
            var context = new ValidationContext(input);

            // ACT: voer de bestaande validatieregels van het model uit.
            bool isGeldig = Validator.TryValidateObject(
                input, context, fouten, validateAllProperties: true);

            // ASSERT: precies de drie locatievelden moeten fouten geven.
            Assert.False(isGeldig);
            Assert.Equal(3, fouten.Count);

            Assert.Contains(fouten, fout =>
                fout.MemberNames.Contains(nameof(CreateEventInputModel.Address)) &&
                fout.ErrorMessage == "Adres is verplicht.");

            Assert.Contains(fouten, fout =>
                fout.MemberNames.Contains(nameof(CreateEventInputModel.Latitude)) &&
                fout.ErrorMessage == "Kies een locatie op de kaart.");

            Assert.Contains(fouten, fout =>
                fout.MemberNames.Contains(nameof(CreateEventInputModel.Longitude)) &&
                fout.ErrorMessage == "Kies een locatie op de kaart.");
        }

        [Fact]
        public async Task EPT11_ZonderLocatie_KeertTerugNaarFormulierEnSlaatNietOp()
        {
            // ARRANGE: gebruik vervangers voor de externe afhankelijkheden.
            // Een Strict-mock weigert iedere niet-ingestelde aanroep.
            var repository = new Mock<IOrganiserRepository>(MockBehavior.Strict);
            var environment = new Mock<IWebHostEnvironment>(MockBehavior.Strict);
            var configuration = new ConfigurationBuilder().Build();

            var pagina = new CreateModel(
                repository.Object, environment.Object, configuration)
            {
                Input = MaakInvoerZonderLocatie(),
                PageContext = new PageContext
                {
                    HttpContext = new DefaultHttpContext
                    {
                        User = new ClaimsPrincipal(new ClaimsIdentity(
                            new[] { new Claim(ClaimTypes.NameIdentifier, "1") },
                            "Test"))
                    }
                }
            };

            // De applicatie verplicht een afbeelding. Voeg daarom een kleine
            // geldige PNG in het geheugen toe, zodat alleen de locatie ontbreekt.
            byte[] afbeelding = Convert.FromBase64String(
                "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGNgYGBgAAAABQABpfZFQAAAAABJRU5ErkJggg==");
            using var stream = new MemoryStream(afbeelding);
            pagina.Images.Add(new FormFile(
                stream, 0, stream.Length, "Images", "test.png")
            {
                Headers = new HeaderDictionary(),
                ContentType = "image/png"
            });

            // Bij een echte webaanvraag vult ASP.NET Core ModelState.
            // Een directe methodeaanroep in een unit test doet dat niet.
            // Daarom nemen we de echte validatiefouten van het inputmodel over.
            var fouten = new List<ValidationResult>();
            Validator.TryValidateObject(
                pagina.Input,
                new ValidationContext(pagina.Input),
                fouten,
                validateAllProperties: true);

            foreach (var fout in fouten)
            {
                foreach (var veld in fout.MemberNames)
                {
                    pagina.ModelState.AddModelError(
                        $"Input.{veld}", fout.ErrorMessage ?? "Ongeldige invoer.");
                }
            }

            // ACT: voer de methode achter 'Evenement opslaan' uit.
            var resultaat = await pagina.OnPostAsync();

            // ASSERT: het formulier komt terug met uitsluitend locatiefouten.
            Assert.IsType<PageResult>(resultaat);
            Assert.False(pagina.ModelState.IsValid);
            Assert.Equal(3, pagina.ModelState.ErrorCount);

            Assert.Contains(pagina.ModelState["Input.Address"]!.Errors,
                fout => fout.ErrorMessage == "Adres is verplicht.");
            Assert.Contains(pagina.ModelState["Input.Latitude"]!.Errors,
                fout => fout.ErrorMessage == "Kies een locatie op de kaart.");
            Assert.Contains(pagina.ModelState["Input.Longitude"]!.Errors,
                fout => fout.ErrorMessage == "Kies een locatie op de kaart.");

            // Er zijn geen andere repository-aanroepen geverifieerd.
            // Dit controleert dus dat er helemaal geen aanroepen zijn geweest,
            // ook niet naar CreateEventAsync of AddEventImagesAsync.
            repository.VerifyNoOtherCalls();
        }

        private static CreateEventInputModel MaakInvoerZonderLocatie()
        {
            return new CreateEventInputModel
            {
                EventName = "Testevenement EPT11",
                IndoorsOutdoors = "Binnen",
                Description = "Een evenement om ontbrekende locatie te testen.",
                Address = string.Empty,
                Latitude = null,
                Longitude = null,
                HasStandingPlaces = true,
                HasSittingPlaces = false,
                DisabledParkingAvailable = false,
                DisabledToiletAvailable = false,
                WheelchairAccessibleToilet = false,
                Tickets = new List<CreateTicketInputModel>
                {
                    new CreateTicketInputModel { TicketType = "Gratis", Price = 0 }
                }
            };
        }
    }
}
