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
using Microsoft.Extensions.Logging.Abstractions;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT36Tests
    {
        [Fact]
        public async Task EPT36_GeenTickets_VoegtGratisTicketToe()
        {
            // Arrange
            var repositoryMock =
                new Mock<IOrganiserRepository>(MockBehavior.Strict);

            repositoryMock
                .Setup(repository => repository.GetAllCategoriesAsync())
                .ReturnsAsync(
                    new List<(int CategoryId, string CategoryName)>
                    {
                        (1, "Muziek"),
                        (2, "Cultuur")
                    });

            var environmentMock = new Mock<IWebHostEnvironment>();
            var configurationMock = new Mock<IConfiguration>();

            var testMap = Path.Combine(
                Path.GetTempPath(),
                "EventApp-EPT36-" + Guid.NewGuid().ToString("N"));

            environmentMock
                .SetupGet(environment => environment.WebRootPath)
                .Returns(testMap);

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
                        // Kopieer de tickets op het moment van opslaan.
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
                    configurationMock.Object,
                    NullLogger<CreateModel>.Instance);

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

                pagina.Input = FormTestHelper.MaakGeldigeInvoer();
                pagina.Input.Tickets.Clear();

                // Voeg een kleine PNG toe voor de uploadcontrole.
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

                // Act
                var resultaat = await pagina.OnPostAsync();

                // Assert
                pagina.ModelState.IsValid.Should().BeTrue();

                resultaat.Should().BeOfType<RedirectToPageResult>()
                    .Which.PageName.Should().Be("/Portal/Dashboard");

                ontvangenTickets.Should().NotBeNull();
                ontvangenTickets.Should().ContainSingle();

                var ontvangenTicket = ontvangenTickets![0];

                ontvangenTicket.TicketType.Should().Be("Gratis");
                ontvangenTicket.Price.Should().Be(0m);

                repositoryMock.Verify(
                    repository => repository.GetAllCategoriesAsync(),
                    Times.AtLeastOnce);

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
                if (Directory.Exists(testMap))
                {
                    Directory.Delete(testMap, recursive: true);
                }
            }
        }
    }
}