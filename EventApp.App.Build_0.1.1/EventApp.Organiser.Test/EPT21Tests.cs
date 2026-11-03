using System;
using System.Collections.Generic;
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
using Microsoft.Extensions.Logging.Abstractions;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT21Tests
    {
        [Fact]
        public async Task EPT21_PdfAlsAfbeelding_WordtAfgewezen()
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
                "EventApp-EPT21-" + Guid.NewGuid().ToString("N"));

            environmentMock
                .SetupGet(environment => environment.WebRootPath)
                .Returns(testMap);

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

                // Een kleine, niet-lege upload met PDF-extensie.
                var inhoud = Encoding.UTF8.GetBytes(
                    "%PDF-1.4\nTestbestand voor EPT21");

                using var stream = new MemoryStream(inhoud);

                pagina.Images.Add(new FormFile(
                    stream,
                    0,
                    stream.Length,
                    "Images",
                    "testbestand.pdf")
                {
                    Headers = new HeaderDictionary(),
                    ContentType = "application/pdf"
                });

                // Act
                var resultaat = await pagina.OnPostAsync();

                // Assert
                resultaat.Should().BeOfType<PageResult>();
                pagina.ModelState.IsValid.Should().BeFalse();

                var foutmeldingen = pagina.ModelState.Values
                    .SelectMany(waarde => waarde.Errors)
                    .Select(fout => fout.ErrorMessage);

                foutmeldingen.Should().Contain(
                    "Afbeelding 1 moet jpg, jpeg, png of webp zijn.");

                // Categorieën ophalen mag; opslagaanroepen niet.
                repositoryMock.Verify(
                    repository => repository.GetAllCategoriesAsync(),
                    Times.AtLeastOnce);

                repositoryMock.VerifyNoOtherCalls();

                // Het afgewezen bestand mag niet op schijf staan.
                if (Directory.Exists(testMap))
                {
                    Directory.GetFiles(
                        testMap,
                        "*",
                        SearchOption.AllDirectories)
                        .Should().BeEmpty();
                }
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