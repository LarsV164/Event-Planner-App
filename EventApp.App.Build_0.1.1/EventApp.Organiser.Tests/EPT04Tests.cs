using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentAssertions;
using Xunit;

namespace EventApp.OrganiserPortal.Tests
{
    public class EPT04Tests
    {
        [Fact]
        public void EPT04_EvenementnaamMetSpatiesEnCijfers_WordtGeaccepteerd()
        {
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.EventName = "bier feest 2026";

            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            isGeldig.Should().BeTrue();
            fouten.Should().BeEmpty();
        }
    }
}
