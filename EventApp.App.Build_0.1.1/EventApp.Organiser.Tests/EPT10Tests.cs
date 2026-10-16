using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentAssertions;
using Xunit;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT10Tests
    {
        [Fact]
        public void EPT10_BeschrijvingOverMeerdereLijnen_WordtGeaccepteerd()
        {
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.Description = "Op podium 1 is Klaas.\n" +
                                "Op podium 2 is Piet.\n" +
                                "Op podium 3 is Jan!";
            var (isGeldig, fouten) = FormTestHelper.Valideer(input);
            isGeldig.Should().BeTrue();
            fouten.Should().BeEmpty();
        }
    }
}
