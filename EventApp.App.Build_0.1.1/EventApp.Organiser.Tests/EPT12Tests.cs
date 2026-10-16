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
    public class EPT12Tests
    {
        [Fact]
        public void EPT12_AdresLeeg_GeeftValidatiefout()
        {
            var input = FormTestHelper.MaakGeldigeInvoer();
            input.Address = string.Empty;

            var (isGeldig, fouten) = FormTestHelper.Valideer(input);
            isGeldig.Should().BeFalse();

            var fout = fouten.Should().ContainSingle().Which;
            fout.MemberNames.Should().Contain(nameof(CreateEventInputModel.Address));
            fout.ErrorMessage.Should().Be("Adres is verplicht.");
        }
    }
}
