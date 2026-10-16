using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentAssertions;
using Xunit;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT11Tests
    {
        [Fact]
        public void EPT11_AdresGeldigeInvoer_WordtGeaccepteerd()
        {
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.Address = "13, Welterlaan, Aarveld, Heerlerbaan, Heerlen, Limburg, Nederland, 6417 CE, Nederland";
            input.Latitude = 50.880608086731264m;
            input.Longitude = 5.977836887601211m;

            var (isGeldig, fouten) = FormTestHelper.Valideer(input);
            isGeldig.Should().BeTrue();
            fouten.Should().BeEmpty();
        }
    }
}
