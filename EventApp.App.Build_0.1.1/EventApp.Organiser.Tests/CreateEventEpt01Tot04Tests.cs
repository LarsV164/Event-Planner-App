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
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Configuration;
using Moq;
using Xunit;

namespace EventApp.OrganiserPortal.Tests
{
    public class CreateEventEpt01Tot04Tests
    {
        private const int OrganiserId = 1;
        private const int EventId = 123;

        [Fact]
        [Trait("Testsoort", "Component")]
        public async Task EPT01_GeldigeInvoer_RoeptAanmakenAanEnGaatNaarDashboard()
        {
            using var test = new TestOmgeving(metBestandsopslag: true);
            ValideerInvoer(test.Pagina);
            Assert.True(test.Pagina.ModelState.IsValid);

            var resultaat = await test.Pagina.OnPostAsync();

            var redirect = Assert.IsType<RedirectToPageResult>(resultaat);
            Assert.Equal("/Portal/Dashboard", redirect.PageName);
            Assert.True(test.Pagina.ModelState.IsValid);

            test.Repository.Verify(r => r.GetNextEventIdAsync(), Times.Once());
            test.Repository.Verify(r => r.CreateEventAsync(
                OrganiserId, EventId, test.Pagina.Input), Times.Once());
            test.Repository.Verify(r => r.AddEventImagesAsync(
                EventId, It.Is<List<string>>(urls => urls.Count == 1)), Times.Once());
            test.Repository.VerifyNoOtherCalls();
        }

        [Fact]
        [Trait("Testsoort", "Unit")]
        public async Task EPT02_NaamOntbreekt_GeeftFoutEnSlaatNietOp()
        {
            using var test = new TestOmgeving();
            test.Pagina.Input.EventName = string.Empty;
            ValideerInvoer(test.Pagina);

            var resultaat = await test.Pagina.OnPostAsync();

            ControleerAfwijzing(test, resultaat, "Input.EventName",
                "Naam van het evenement is verplicht.");
        }

        [Fact]
        [Trait("Testsoort", "Unit")]
        public async Task EPT03_NegatieveTicketprijs_GeeftFoutEnSlaatNietOp()
        {
            using var test = new TestOmgeving();
            test.Pagina.Input.Tickets[0].Price = -5m;
            ValideerInvoer(test.Pagina);

            var resultaat = await test.Pagina.OnPostAsync();

            ControleerAfwijzing(test, resultaat, "Input.Tickets[0].Price");
        }

        [Fact]
        [Trait("Testsoort", "Unit")]
        public async Task EPT04_TicketprijsBovenMaximum_GeeftFoutEnSlaatNietOp()
        {
            using var test = new TestOmgeving();
            test.Pagina.Input.Tickets[0].Price = 1000000m;
            ValideerInvoer(test.Pagina);

            var resultaat = await test.Pagina.OnPostAsync();

            ControleerAfwijzing(test, resultaat, "Input.Tickets[0].Price");
        }

        private static void ControleerAfwijzing(
            TestOmgeving test,
            IActionResult resultaat,
            string veld,
            string? verwachteMelding = null)
        {
            Assert.IsType<PageResult>(resultaat);
            Assert.False(test.Pagina.ModelState.IsValid);
            Assert.Equal(1, test.Pagina.ModelState.ErrorCount);
            Assert.True(test.Pagina.ModelState.ContainsKey(veld));

            var fout = Assert.Single(test.Pagina.ModelState[veld]!.Errors);
            Assert.False(string.IsNullOrWhiteSpace(fout.ErrorMessage));

            if (verwachteMelding != null)
            {
                Assert.Equal(verwachteMelding, fout.ErrorMessage);
            }

            test.Repository.VerifyNoOtherCalls();
        }

        private static void ValideerInvoer(CreateModel pagina)
        {
            VoegValidatiefoutenToe(pagina.Input, "Input", pagina);

            for (var i = 0; i < pagina.Input.Tickets.Count; i++)
            {
                VoegValidatiefoutenToe(
                    pagina.Input.Tickets[i], $"Input.Tickets[{i}]", pagina);
            }
        }

        private static void VoegValidatiefoutenToe(
            object model, string prefix, CreateModel pagina)
        {
            var fouten = new List<ValidationResult>();
            Validator.TryValidateObject(
                model, new ValidationContext(model), fouten, validateAllProperties: true);

            foreach (var fout in fouten)
            {
                foreach (var veld in fout.MemberNames.DefaultIfEmpty(string.Empty))
                {
                    var sleutel = string.IsNullOrEmpty(veld) ? prefix : $"{prefix}.{veld}";
                    pagina.ModelState.AddModelError(
                        sleutel, fout.ErrorMessage ?? "Ongeldige invoer.");
                }
            }
        }

        private sealed class TestOmgeving : IDisposable
        {
            private readonly MemoryStream _afbeelding;
            private readonly string? _tijdelijkeMap;

            public Mock<IOrganiserRepository> Repository { get; }
            public CreateModel Pagina { get; }

            public TestOmgeving(bool metBestandsopslag = false)
            {
                Repository = new Mock<IOrganiserRepository>(
                    metBestandsopslag ? MockBehavior.Loose : MockBehavior.Strict);
                var environment = new Mock<IWebHostEnvironment>(MockBehavior.Strict);

                if (metBestandsopslag)
                {
                    _tijdelijkeMap = Path.Combine(
                        Path.GetTempPath(), "EventAppTests", Guid.NewGuid().ToString("N"));
                    environment.SetupGet(e => e.WebRootPath).Returns(_tijdelijkeMap);
                    Repository.Setup(r => r.GetNextEventIdAsync()).ReturnsAsync(EventId);
                    Repository.SetReturnsDefault(Task.CompletedTask);
                }

                Pagina = new CreateModel(
                    Repository.Object, environment.Object, new ConfigurationBuilder().Build())
                {
                    Input = new CreateEventInputModel
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
                    },
                    Url = Mock.Of<IUrlHelper>(),
                    PageContext = new PageContext
                    {
                        HttpContext = new DefaultHttpContext
                        {
                            User = new ClaimsPrincipal(new ClaimsIdentity(
                                new[] { new Claim(ClaimTypes.NameIdentifier, OrganiserId.ToString()) },
                                "Test"))
                        }
                    }
                };

                _afbeelding = new MemoryStream(Convert.FromBase64String(
                    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGNgYGBgAAAABQABpfZFQAAAAABJRU5ErkJggg=="));

                Pagina.Images.Add(new FormFile(
                    _afbeelding, 0, _afbeelding.Length, "Images", "evenement.png")
                {
                    Headers = new HeaderDictionary(),
                    ContentType = "image/png"
                });
            }

            public void Dispose()
            {
                _afbeelding.Dispose();

                if (_tijdelijkeMap != null && Directory.Exists(_tijdelijkeMap))
                {
                    Directory.Delete(_tijdelijkeMap, recursive: true);
                }
            }
        }
    }
}
