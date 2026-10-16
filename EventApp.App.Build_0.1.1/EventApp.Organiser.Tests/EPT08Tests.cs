using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentAssertions;
using Xunit;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT08Tests
    {
        [Fact]
        public void EPT08_BeschrijvingGeldigeInvoer_WordtGeaccepteerd()
        {
            var input = MaakGeldigeInvoer();
            input.Description = "Een avond met livemuziek.";

            var (isGeldig, fouten) = Valideer(input);

            isGeldig.Should().BeTrue();
            fouten.Should().BeEmpty();
        }
    }
}
