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
    public class InvalideToiletTest
    {
        public class CreateEventInputModelTests
        {
            private readonly IEventValidationService _eventValidationService;

            public CreateEventInputModelTests()
            {
                ServiceCollection services = new ServiceCollection();

                services.AddScoped<IEventValidationService, EventValidationService>();

                ServiceProvider serviceProvider = services.BuildServiceProvider();

                _eventValidationService =
                    serviceProvider.GetRequiredService<IEventValidationService>();
            }

            // Lars

            private static CreateEventInputModel ValidEvent(bool? disabledToiletAvailable) => new()
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
                DisabledToiletAvailable = disabledToiletAvailable,
                WheelchairAccessibleToilet = true,
                ChildrenFriendly = true
            };

            [Theory]
            [InlineData(true)]
            [InlineData(false)]
            public void EPT43_disabledToiletChosen_ShouldBeValid(bool choice)
            // zonder injection
            {
                // Arrange
                var model = ValidEvent(choice);
                model.DisabledToiletAvailable = choice;

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
                model.DisabledToiletAvailable.Should().Be(choice);
            }

            [Fact]
            public void EPT44_disabledToiletNotChosen_ShouldBeInvalid()
            // met injection
            {
                // Arrange
                var model = ValidEvent(null);
                model.DisabledToiletAvailable = null;

                // Act
                bool isValid = _eventValidationService.IsValid(model);

                // Assert
                isValid.Should().BeFalse();
            }
        }
    }
}
