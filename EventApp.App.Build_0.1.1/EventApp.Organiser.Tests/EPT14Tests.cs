using EventApp.OrganiserPortal.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentAssertions;
using Xunit;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT14Tests
    {
        [Fact]
        public void EPT14_AdresLatitudeZonderLongitude_GeeftValidatiefout()
        {
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.Address = "13, Welterlaan, Aarveld, Heerlerbaan, Heerlen, Limburg, Nederland, 6417 CE, Nederland";
            input.Latitude = 50.0321312m;
            input.Longitude = null;

            var (isGeldig, fouten) = FormTestHelper.Valideer(input);
            isGeldig.Should().BeFalse();

            var fout = fouten.Should().ContainSingle().Which;
            fout.MemberNames.Should().Contain(nameof(CreateEventInputModel.Longitude));
            fout.ErrorMessage.Should().Be("Kies een locatie op de kaart.");
        }
    }
}
