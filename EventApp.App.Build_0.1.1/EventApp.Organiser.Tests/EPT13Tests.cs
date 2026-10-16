using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EventApp.OrganiserPortal.Models;
using FluentAssertions;
using Xunit;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT13Tests
    {
        [Fact]
        public void EPT13_AdresZonderLatitudeEnLongitude_GeeftValidatiefout()
        {
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.Address = "13, Welterlaan, Aarveld, Heerlerbaan, Heerlen, Limburg, Nederland, 6417 CE, Nederland";
            input.Latitude = null;
            input.Longitude = null;

            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

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
    }
}
