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
    public class EPT03Tests
    {
        [Fact]
        public void EPT03_EvenementnaamMetAlleenSpaties_GeeftValidatiefout()
        {
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.EventName = "   ";

            var (isGeldig, fouten) = FormTestHelper.Valideer(input);

            isGeldig.Should().BeFalse();

            var fout = fouten.Should().ContainSingle().Which;
            fout.MemberNames.Should().Contain(nameof(CreateEventInputModel.EventName));
            fout.ErrorMessage.Should().Be("Naam van het evenement is verplicht.");
        }
    }
}
