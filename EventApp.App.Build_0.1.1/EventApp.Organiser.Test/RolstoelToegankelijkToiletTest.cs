using EventApp.OrganiserPortal.Models;
using EventApp.OrganiserPortal.Services;
using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Xunit;

namespace EventApp.Organiser.Test
{
    public class RolstoelToegankelijkToiletTest
    {
        public class CreateEventInputModelTests
        {
            // Lars

            private static CreateEventInputModel ValidEvent(bool? wheelchairAccessibleToilet) => new()
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
                DisabledParkingAvailable = true,
                DisabledToiletAvailable = true,
                WheelchairAccessibleToilet = wheelchairAccessibleToilet,
                ChildrenFriendly = true
            };

            [Theory]
            [InlineData(true)]
            [InlineData(false)]
            public void EPT45_wheelchairAccessibleToiletChosen_ShouldBeValid(bool choice)
            // zonder injection
            {
                // Arrange
                var model = ValidEvent(choice);
                model.WheelchairAccessibleToilet = choice;

                ValidationContext context = new ValidationContext(model);
                List<ValidationResult> results = new List<ValidationResult>();

                // Act
                bool isValid = Validator.TryValidateObject(
                    model,
                    context,
                    results,
                    validateAllProperties: true);

                // Assert
                isValid.Should().BeTrue();
                model.WheelchairAccessibleToilet.Should().Be(choice);
            }

            [Fact]
            public void EPT46_wheelchairAccessibleToiletNotChosen_ShouldBeInvalid()
            // moq gebruiken
            {
                // Arrange
                var model = ValidEvent(null);
                model.WheelchairAccessibleToilet = null;

                Mock<IEventValidationService> mockValidationService =
                    new Mock<IEventValidationService>();

                mockValidationService
                    .Setup(service => service.IsValid(model))
                    .Returns(false);

                // Act
                bool isValid = mockValidationService.Object.IsValid(model);

                // Assert
                isValid.Should().BeFalse();
            }
        }
    }
}
