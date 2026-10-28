using System;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using EventApp.OrganiserPortal.Pages.Portal;
using EventApp.OrganiserPortal.Repositories;
using FluentAssertions;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Configuration;
using Moq;
using Xunit;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT21Tests
    {
        [Fact]
        public async Task EPT21_PdfAlsAfbeelding_WordtAfgewezen()
        {
            // Arrange: maak de dependencies.
            var repositoryMock =
                new Mock<IOrganiserRepository>(MockBehavior.Strict);

            var environmentMock = new Mock<IWebHostEnvironment>();
            var configurationMock = new Mock<IConfiguration>();

            // De paginacode maakt vóór de bestandscontrole een map aan.
            // Gebruik daarvoor een unieke tijdelijke testmap.
            var testMap = Path.Combine(
                Path.GetTempPath(),
                "EventApp-EPT21-" + Guid.NewGuid().ToString("N"));

            environmentMock
                .SetupGet(environment => environment.WebRootPath)
                .Returns(testMap);

            try
            {
                var pagina = new CreateModel(
                    repositoryMock.Object,
                    environmentMock.Object,
                    configurationMock.Object);

                // Simuleer een ingelogde organisator.
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

                // Simuleer een kleine, niet-lege PDF-upload.
                var inhoud = Encoding.UTF8.GetBytes(
                    "%PDF-1.4\nTestbestand voor EPT21");

                using var stream = new MemoryStream(inhoud);

                var bestand = new FormFile(
                    stream,
                    0,
                    stream.Length,
                    "Images",
                    "testbestand.pdf")
                {
                    Headers = new HeaderDictionary(),
                    ContentType = "application/pdf"
                };

                pagina.Images.Add(bestand);

                // Act: probeer het evenement op te slaan.
                var resultaat = await pagina.OnPostAsync();

                // Assert: het formulier wordt opnieuw getoond.
                resultaat.Should().BeOfType<PageResult>();

                pagina.ModelState.IsValid.Should().BeFalse();

                var foutmeldingen = pagina.ModelState.Values
                    .SelectMany(waarde => waarde.Errors)
                    .Select(fout => fout.ErrorMessage);

                foutmeldingen.Should().Contain(
                    "Afbeelding 1 moet jpg, jpeg, png of webp zijn.");

                // Er mag niets naar de repository worden gestuurd.
                repositoryMock.VerifyNoOtherCalls();

                // Het afgewezen bestand mag niet zijn opgeslagen.
                Directory.GetFiles(
                    testMap,
                    "*",
                    SearchOption.AllDirectories)
                    .Should().BeEmpty();
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