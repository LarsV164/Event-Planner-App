using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentAssertions;
using Xunit;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT05Tests
    {
        [Theory]
        [InlineData("Binnen")]
        [InlineData("Buiten")]
        [InlineData("Beide")]
        public void EPT05_BinnenBuitenOfBeide_WordtGeaccepteerd(string keuze)
        {
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.IndoorsOutdoors = keuze;

            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            isGeldig.Should().BeTrue();
            fouten.Should().BeEmpty();
        }
    }
}
