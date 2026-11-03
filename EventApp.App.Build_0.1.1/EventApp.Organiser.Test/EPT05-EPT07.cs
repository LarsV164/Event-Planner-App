using EventApp.OrganiserPortal.Models;
using EventApp.OrganiserPortal.Tests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using FluentAssertions;

namespace EventApp.Organiser.Test
{
    public class EPT05_EPT07
    {
        // xUnit voert deze test één keer uit per InlineData-waarde.
        [Theory]
        [InlineData("Binnen")]
        [InlineData("Buiten")]
        [InlineData("Beide")]
        public void EPT05_BinnenBuitenOfBeide_WordtGeaccepteerd(string keuze)
        {
            // Arrange: Gebruik de keuze uit deze InlineData-rij.
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.IndoorsOutdoors = keuze;

            // Act: Valideer de voorbereide formulierinvoer.
            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            // Assert: Verwacht dat deze keuze geen validatiefout geeft.
            isGeldig.Should().BeTrue();
            fouten.Should().BeEmpty();
        }

        [Fact]
        public void EPT06_BinnenBuitenOfBeideOntbreekt_GeeftValidatiefout()
        {
            // Arrange: Laat de keuze voor binnen of buiten leeg.
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.IndoorsOutdoors = string.Empty;

            // Act: Valideer de voorbereide formulierinvoer.
            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            // Assert: Controleer het veld en de melding voor de ontbrekende keuze.
            isGeldig.Should().BeFalse();

            var fout = fouten.Should().ContainSingle().Which;
            fout.MemberNames.Should().Contain(
                nameof(CreateEventInputModel.IndoorsOutdoors));
            fout.ErrorMessage.Should().Be("Kies Binnen, Buiten of Beide.");
        }

        [Fact]
        public void EPT07_OnbekendeBinnenBuitenKeuze_GeeftValidatiefout()
        {
            // Arrange: Vul de onbekende keuze ‘Onbekend’ in.
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.IndoorsOutdoors = "Onbekend";

            // Act: Valideer de voorbereide formulierinvoer.
            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            // Assert: Controleer het veld en de melding voor de onbekende keuze.
            isGeldig.Should().BeFalse();

            var fout = fouten.Should().ContainSingle().Which;
            fout.MemberNames.Should().Contain(
                nameof(CreateEventInputModel.IndoorsOutdoors));
            fout.ErrorMessage.Should().Be("Kies Binnen, Buiten of Beide.");
        }
    }
}

