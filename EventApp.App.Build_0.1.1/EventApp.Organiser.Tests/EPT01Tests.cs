using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentAssertions;
using Xunit;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT01Tests
    {
        [Fact]
        public void EPT01_GeldigeEvenementnaam_WordtGeaccepteerd()
        {
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.EventName = "Testevenement";

            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            isGeldig.Should().BeTrue();
            fouten.Should().BeEmpty();
        }
    }
}
