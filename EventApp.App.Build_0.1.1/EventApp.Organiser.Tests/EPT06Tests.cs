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
    public class EPT06Tests
    {
        [Fact]
        public void EPT06_BinnenBuitenOfBeideOntbreekt_GeeftValidatiefout()
        {
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.IndoorsOutdoors = string.Empty;

            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            isGeldig.Should().BeFalse();

            var fout = fouten.Should().ContainSingle().Which;
            fout.MemberNames.Should().Contain(
                nameof(CreateEventInputModel.IndoorsOutdoors));
            fout.ErrorMessage.Should().Be("Kies Binnen, Buiten of Beide.");
        }
    }
}
