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
    public class EPT11_EPT14
    {
        [Fact]
        public void EPT11_AdresGeldigeInvoer_WordtGeaccepteerd()
        {
            // Arrange: Vul het adres en beide kaartcoördinaten in.
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.Address = "13, Welterlaan, Aarveld, Heerlerbaan, Heerlen, Limburg, Nederland, 6417 CE, Nederland";
            input.Latitude = 50.880608086731264m;
            input.Longitude = 5.977836887601211m;

            // Act: Valideer de voorbereide formulierinvoer.
            var (isGeldig, fouten) = FormTestHelper.Valideer(input);
            // Assert: Verwacht dat de volledige locatie geldig is.
            isGeldig.Should().BeTrue();
            fouten.Should().BeEmpty();
        }

        [Fact]
        public void EPT12_AdresLeeg_GeeftValidatiefout()
        {
            // Arrange: Maak alleen het adres leeg.
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.Address = string.Empty;

            // Act: Valideer de voorbereide formulierinvoer.
            var (isGeldig, fouten) = FormTestHelper.Valideer(input);
            // Assert: Verwacht alleen de melding dat het adres verplicht is.
            isGeldig.Should().BeFalse();

            var fout = fouten.Should().ContainSingle().Which;
            fout.MemberNames.Should().Contain(nameof(CreateEventInputModel.Address));
            fout.ErrorMessage.Should().Be("Adres is verplicht.");
        }

        [Fact]
        public void EPT13_AdresZonderLatitudeEnLongitude_GeeftValidatiefout()
        {
            // Arrange: Vul een adres in en laat beide coördinaten weg.
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.Address = "13, Welterlaan, Aarveld, Heerlerbaan, Heerlen, Limburg, Nederland, 6417 CE, Nederland";
            input.Latitude = null;
            input.Longitude = null;

            // Act: Valideer de voorbereide formulierinvoer.
            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            // Assert: Verwacht twee fouten en controleer de kaartmelding voor elke coördinaat.
            isGeldig.Should().BeFalse();
            fouten.Should().HaveCount(2);

            var latitudeFout = fouten.Should().ContainSingle(
                fout => fout.MemberNames.Contains(
                    nameof(CreateEventInputModel.Latitude))).Which;

            latitudeFout.ErrorMessage.Should().Be("Kies een locatie op de kaart.");

            var longitudeFout = fouten.Should().ContainSingle(
                fout => fout.MemberNames.Contains(
                    nameof(CreateEventInputModel.Longitude))).Which;

            longitudeFout.ErrorMessage.Should().Be("Kies een locatie op de kaart.");
        }

        [Fact]
        public void EPT14_AdresLatitudeZonderLongitude_GeeftValidatiefout()
        {
            // Arrange: Vul de breedtegraad in en laat de lengtegraad weg.
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.Address = "13, Welterlaan, Aarveld, Heerlerbaan, Heerlen, Limburg, Nederland, 6417 CE, Nederland";
            input.Latitude = 50.0321312m;
            input.Longitude = null;

            // Act: Valideer de voorbereide formulierinvoer.
            var (isGeldig, fouten) = FormTestHelper.Valideer(input);
            // Assert: Verwacht alleen een kaartmelding voor Longitude.
            isGeldig.Should().BeFalse();

            var fout = fouten.Should().ContainSingle().Which;
            fout.MemberNames.Should().Contain(nameof(CreateEventInputModel.Longitude));
            fout.ErrorMessage.Should().Be("Kies een locatie op de kaart.");
        }
    }
}
