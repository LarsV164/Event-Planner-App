using EventApp.OrganiserPortal.Models;
using EventApp.OrganiserPortal.Tests;
using FluentAssertions;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace EventApp.Organiser.Test
{
    public class EPT01_EPT04
    {
        [Fact]
        public void EPT01_GeldigeEvenementnaam_WordtGeaccepteerd()
        {
            // Arrange: Geef het evenement een naam.
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.EventName = "Testevenement";

            // Act: Valideer de voorbereide formulierinvoer.
            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            // Assert: Verwacht geldige invoer zonder fouten.
            isGeldig.Should().BeTrue();
            fouten.Should().BeEmpty();
        }

        [Fact]
        public void EPT02_LegeEvenementnaam_GeeftValidatiefout()
        {
            // Arrange: Laat de evenementnaam leeg.
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.EventName = string.Empty;

            // Act: Valideer de voorbereide formulierinvoer.
            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            // Assert: Verwacht één fout bij EventName met de verplichteveldmelding.
            isGeldig.Should().BeFalse();

            var fout = fouten.Should().ContainSingle().Which;
            fout.MemberNames.Should().Contain(nameof(CreateEventInputModel.EventName));
            fout.ErrorMessage.Should().Be("Naam van het evenement is verplicht.");
        }

        [Fact]
        public void EPT01_V2_GeldigeEvenementnaam_WordtGeaccepteerd()
        {
            // Arrange: Vul alleen de te testen evenementnaam in.
            CreateEventInputModel input = new CreateEventInputModel
            {
                EventName = "Testevenement"
            };

            // Act: Valideer uitsluitend EventName.
            (bool isGeldig, List<ValidationResult> fouten) =
                ValideerEvenementnaam(input);

            // Assert: Verwacht dat de naam geldig is en geen melding oplevert.
            isGeldig.Should().BeTrue();
            fouten.Should().BeEmpty();
        }

        [Fact]
        public void EPT02_V2_LegeEvenementnaam_GeeftVerplichteVeldmelding()
        {
            // Arrange: Maak een model met een lege evenementnaam.
            CreateEventInputModel input = new CreateEventInputModel
            {
                EventName = string.Empty
            };

            // Act: Valideer uitsluitend EventName.
            (bool isGeldig, List<ValidationResult> fouten) =
                ValideerEvenementnaam(input);

            // Assert: Verwacht precies één melding voor de ontbrekende naam.
            isGeldig.Should().BeFalse();

            ValidationResult fout = fouten.Should().ContainSingle().Which;
            fout.MemberNames.Should().Contain(nameof(CreateEventInputModel.EventName));
            fout.ErrorMessage.Should().Be("Naam van het evenement is verplicht.");
        }

        private static (bool IsGeldig, List<ValidationResult> Fouten)
            ValideerEvenementnaam(CreateEventInputModel input)
        {
            // Koppel de validatie aan EventName, zodat andere verplichte velden buiten deze test vallen.
            ValidationContext context = new ValidationContext(input)
            {
                MemberName = nameof(CreateEventInputModel.EventName)
            };

            List<ValidationResult> fouten = new List<ValidationResult>();

            bool isGeldig = Validator.TryValidateProperty(
                input.EventName, context, fouten);

            return (isGeldig, fouten);
        }

        [Fact]
        public void EPT03_EvenementnaamMetAlleenSpaties_GeeftValidatiefout()
        {
            // Arrange: Gebruik drie spaties als evenementnaam.
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.EventName = "   ";

            // Act: Valideer de voorbereide formulierinvoer.
            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            // Assert: Controleer dat alleen spaties dezelfde fout geven als een lege naam.
            isGeldig.Should().BeFalse();

            var fout = fouten.Should().ContainSingle().Which;
            fout.MemberNames.Should().Contain(nameof(CreateEventInputModel.EventName));
            fout.ErrorMessage.Should().Be("Naam van het evenement is verplicht.");
        }

        [Fact]
        public void EPT04_EvenementnaamMetSpatiesEnCijfers_WordtGeaccepteerd()
        {
            // Arrange: Gebruik een naam met woorden, spaties en cijfers.
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.EventName = "bier feest 2026";

            // Act: Valideer de voorbereide formulierinvoer.
            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            // Assert: Controleer dat spaties en cijfers in een naam zijn toegestaan.
            isGeldig.Should().BeTrue();
            fouten.Should().BeEmpty();
        }
    }
}
