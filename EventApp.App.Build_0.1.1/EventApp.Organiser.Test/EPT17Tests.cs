using System.Linq;
using System.Security.Claims;
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
    public class EPT17Tests
    {
        [Fact]
        public async Task EPT17_ZonderAfbeelding_WordtNietOpgeslagen()
        {
            // Arrange: maak nepversies van de dependencies.
            var repositoryMock =
                new Mock<IOrganiserRepository>(MockBehavior.Strict);

            var environmentMock = new Mock<IWebHostEnvironment>();
            var configurationMock = new Mock<IConfiguration>();

            // Geef de dependencies via de constructor mee.
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

            // Geldige formuliergegevens, maar geen afbeelding.
            pagina.Input = FormTestHelper.MaakGeldigeInvoer();
            pagina.Images.Clear();

            // Act: probeer het evenement op te slaan.
            var resultaat = await pagina.OnPostAsync();

            // Assert: het formulier wordt opnieuw getoond.
            resultaat.Should().BeOfType<PageResult>();

            pagina.ModelState.IsValid.Should().BeFalse();

            // Controleer de specifieke foutmelding.
            var foutmeldingen = pagina.ModelState.Values
                .SelectMany(waarde => waarde.Errors)
                .Select(fout => fout.ErrorMessage);

            foutmeldingen.Should().Contain(
                "Upload minimaal één afbeelding.");

            // Er mag geen enkele repositorymethode zijn aangeroepen.
            repositoryMock.VerifyNoOtherCalls();
        }
    }
}