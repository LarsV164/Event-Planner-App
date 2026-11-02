using System.Collections.Generic;
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
using Microsoft.Extensions.Logging.Abstractions;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT17Tests
    {
        [Fact]
        public async Task EPT17_ZonderAfbeelding_WordtNietOpgeslagen()
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
            pagina.Images.Clear();

            // Act
            var resultaat = await pagina.OnPostAsync();

            // Assert
            resultaat.Should().BeOfType<PageResult>();
            pagina.ModelState.IsValid.Should().BeFalse();

            var foutmeldingen = pagina.ModelState.Values
                .SelectMany(waarde => waarde.Errors)
                .Select(fout => fout.ErrorMessage);

            foutmeldingen.Should().Contain(
                "Upload minimaal één afbeelding.");

            // Categorieën ophalen mag; opslagaanroepen niet.
            repositoryMock.Verify(
                repository => repository.GetAllCategoriesAsync(),
                Times.AtLeastOnce);

            repositoryMock.VerifyNoOtherCalls();
        }
    }
}