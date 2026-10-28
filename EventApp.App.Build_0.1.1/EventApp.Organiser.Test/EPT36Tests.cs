using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Claims;
using System.Threading.Tasks;
using EventApp.OrganiserPortal.Models;
using EventApp.OrganiserPortal.Pages.Portal;
using EventApp.OrganiserPortal.Repositories;
using FluentAssertions;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Configuration;
using Moq;
using Xunit;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT36Tests
    {
        [Fact]
        public async Task EPT36_GeenTickets_VoegtGratisTicketToe()
        {
            // Arrange: maak de dependencies.
            var repositoryMock =
                new Mock<IOrganiserRepository>(MockBehavior.Strict);

            var environmentMock = new Mock<IWebHostEnvironment>();
            var configurationMock = new Mock<IConfiguration>();

            var testMap = Path.Combine(
                Path.GetTempPath(),
                "EventApp-EPT36-" + Guid.NewGuid().ToString("N"));

            environmentMock
                .SetupGet(environment => environment.WebRootPath)
                .Returns(testMap);

            // Bewaar een kopie van de tickets die de repository ontvangt.
            List<(string TicketType, decimal Price)>? ontvangenTickets = null;

            repositoryMock
                .Setup(repository => repository.GetNextEventIdAsync())
                .ReturnsAsync(100);

            repositoryMock
                .Setup(repository => repository.CreateEventAsync(
                    1,
                    100,
                    It.IsAny<CreateEventInputModel>()))
                .Callback<int, int, CreateEventInputModel>(
                    (organiserId, eventId, input) =>
                    {
                        ontvangenTickets =
                            new List<(string TicketType, decimal Price)>();

                        foreach (var ticket in input.Tickets)
                        {
                            ontvangenTickets.Add(
                                (ticket.TicketType, ticket.Price));
                        }
                    })
                .Returns(Task.CompletedTask);

            repositoryMock
                .Setup(repository => repository.AddEventImagesAsync(
                    100,
                    It.Is<List<string>>(urls => urls.Count == 1)))
                .Returns(Task.CompletedTask);

            try
            {
                var pagina = new CreateModel(
                    repositoryMock.Object,
                    environmentMock.Object,
                    configurationMock.Object);

                var gebruiker = new ClaimsPrincipal(
                    new ClaimsIdentity(
                        new[]
                        {
                            new Claim(ClaimTypes.NameIdentifier, "1")
                        },
                        "Test"));

                pagina.PageContext = new PageContext
                {
                    HttpContext = new DefaultHttpContext
                    {
                        User = gebruiker
                    }
                };

                // Geldige invoer, maar alle tickets zijn verwijderd.
                pagina.Input = FormTestHelper.MaakGeldigeInvoer();
                pagina.Input.Tickets.Clear();

                // Kleine PNG zodat de uploadcontrole slaagt.
                var afbeeldingBytes = Convert.FromBase64String(
                    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwC" +
                    "AAAAC0lEQVR42mP8/x8AAwMCAO+a3ioAAAAASUVORK5CYII=");

                using var stream = new MemoryStream(afbeeldingBytes);

                pagina.Images.Add(new FormFile(
                    stream,
                    0,
                    stream.Length,
                    "Images",
                    "test.png")
                {
                    Headers = new HeaderDictionary(),
                    ContentType = "image/png"
                });

                // Act: probeer het evenement op te slaan.
                var resultaat = await pagina.OnPostAsync();

                // Assert: geen fouten en terug naar het dashboard.
                pagina.ModelState.IsValid.Should().BeTrue();

                resultaat.Should().BeOfType<RedirectToPageResult>()
                    .Which.PageName.Should().Be("/Portal/Dashboard");

                // De repository ontvangt precies één gratis ticket.
                ontvangenTickets.Should().NotBeNull();
                ontvangenTickets.Should().ContainSingle();

                var ontvangenTicket = ontvangenTickets![0];

                ontvangenTicket.TicketType.Should().Be("Gratis");
                ontvangenTicket.Price.Should().Be(0m);

                // Controleer de verwachte repositoryaanroepen.
                repositoryMock.Verify(
                    repository => repository.GetNextEventIdAsync(),
                    Times.Once);

                repositoryMock.Verify(
                    repository => repository.CreateEventAsync(
                        1,
                        100,
                        It.IsAny<CreateEventInputModel>()),
                    Times.Once);

                repositoryMock.Verify(
                    repository => repository.AddEventImagesAsync(
                        100,
                        It.Is<List<string>>(urls => urls.Count == 1)),
                    Times.Once);

                repositoryMock.VerifyNoOtherCalls();
            }
            finally
            {
                // Ruim uitsluitend de tijdelijke testmap op.
                if (Directory.Exists(testMap))
                {
                    Directory.Delete(testMap, recursive: true);
                }
            }
        }
    }
}