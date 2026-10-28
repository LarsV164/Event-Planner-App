using EventApp.OrganiserPortal.Models;
using FluentAssertions;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EventApp.Organiser.Test
{
    public class InvalideParkeerplaatsTest
    {
        // Laers

        // model invullen met alles behalve DisabledParkingAvailable
        private static CreateEventInputModel ValidEvent(Boolean? disabledParkingAvailable) => new()
        {
            EventName = "Test",
            Description = "Test",
            Street = "Teststraat",
            HouseNumber = 1,
            PostalCode = "1234AB",
            City = "TestPlaats",
            StartDate = new DateTime(2026, 12, 1),
            StartTime = new TimeSpan(20, 0, 0),
            EndDate = new DateTime(2026, 12, 1),
            EndTime = new TimeSpan(23, 0, 0),
            DisabledParkingAvailable = disabledParkingAvailable,
            DisabledToiletAvailable = true,
            WheelchairAccessibleToilet = true,
            ChildrenFriendly = true
        };
        private static List<ValidationResult> Validate(CreateEventInputModel model)
        {
            var results = new List<ValidationResult>();
            Validator.TryValidateObject(model, new ValidationContext(model), results, validateAllProperties: true);
            return results;
        }

        [Theory]
        [InlineData(true)]
        [InlineData(false)]
        public void EPT41_disabledParkingChosen_ShouldBeValid(bool choice)
        // zonder injection
        {
            // Arrange
            var model = ValidEvent(choice);
            model.DisabledParkingAvailable = choice;

            // Act
            var results = Validate(model);

            // Assert
            results.Should().BeEmpty();
            model.DisabledParkingAvailable.Should().Be(choice);
        }

        [Fact]
        public void EPT42_disabledParkingNotChosen_ShouldBeInvalid()
        // zonder injection
        {
            // Arrange
            var model = ValidEvent(null);
            model.DisabledParkingAvailable = null;

            // Act
            var results = Validate(model);

            // Assert
            results.Should().ContainSingle()
                .Which.MemberNames.Should().Contain(nameof(CreateEventInputModel.DisabledParkingAvailable));
        }
    }
}
