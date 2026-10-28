using EventApp.OrganiserPortal.Models;
using EventApp.OrganiserPortal.Services;
using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using System.ComponentModel.DataAnnotations;
using System.Net.Sockets;
using Xunit;

namespace EventApp.Organiser.Test

{
    public class TicketTest
    {
        
        public class CreateTicketInputModelTests
        {
            private readonly ITicketValidationService _ticketValidationService;

            public CreateTicketInputModelTests()
            {
                ServiceCollection services = new ServiceCollection();

                services.AddScoped<ITicketValidationService, TicketValidationService>();

                ServiceProvider serviceProvider = services.BuildServiceProvider();

                _ticketValidationService =
                    serviceProvider.GetRequiredService<ITicketValidationService>();
            }

            //classname_methodname_action name confention
            // Laura 
            [Fact]
            public void ETP27_priceWithDecimalValue_ShouldBeValid()
            // zonder injection 
            {
                // Arrange
                CreateTicketInputModel ticket = new CreateTicketInputModel
                {
                    TicketType = "VIP-Ticket",
                    Price = 10.50m,
                    Quantity = 10
                };

                ValidationContext context = new ValidationContext(ticket);
                List<ValidationResult> results = new List<ValidationResult>();

                // Act
                bool isValid = Validator.TryValidateObject(
                    ticket,
                    context,
                    results,
                    validateAllProperties: true);

                // Assert
                isValid.Should().BeTrue();
            }

            [Fact]
            public void ETP28_priceWithZeroValue_ShouldBeValid()
            // zonder injection
            {
                // Arrange
                CreateTicketInputModel ticket = new CreateTicketInputModel
                {
                    TicketType = "VIP-Ticket",
                    Price = 0,
                    Quantity = 10
                };

                ValidationContext context = new ValidationContext(ticket);
                List<ValidationResult> results = new List<ValidationResult>();

                // Act
                bool isValid = Validator.TryValidateObject(
                    ticket,
                    context,
                    results,
                    validateAllProperties: true);

                // Assert
                isValid.Should().BeTrue();
            }

            //met injection 
            [Fact]
            public void ETP29a_priceWithNegativeValue_ShouldBeInvalid()
            {
                //Arrange
                CreateTicketInputModel ticket = new CreateTicketInputModel
                {
                    TicketType = "VIP-Ticket",
                    Price = -5,
                    Quantity = 10
                };

                //Act
                bool isValid = _ticketValidationService.ChecksIsValid(ticket);

                //Assert
                isValid.Should().BeFalse();
            }

            [Fact]
            public void ETP29b_priceWithNegativeDecimalValue_ShouldBeInvalid()
            //met injection 
            {
                //Arrange
                CreateTicketInputModel ticket = new CreateTicketInputModel
                {
                    TicketType = "VIP-Ticket",
                    Price = -0.01m,
                    Quantity = 10
                };

                //Act
                bool isValid = _ticketValidationService.ChecksIsValid(ticket);

                //Assert
                isValid.Should().BeFalse();
            }

            //{
            //    // Arrange
            //    CreateTicketInputModel ticket = new CreateTicketInputModel
            //    {
            //        TicketType = "VIP-Ticket",
            //        Price = -0.01m,
            //        Quantity = 10
            //    };

            //    ValidationContext context = new ValidationContext(ticket);
            //    List<ValidationResult> results = new List<ValidationResult>();

            //    // Act
            //    bool isValid = Validator.TryValidateObject(
            //        ticket,
            //        context,
            //        results,
            //        validateAllProperties: true);

            //    // Assert
            //    isValid.Should().BeFalse();
            //}
         

            [Fact]
            public void ETP30_priceWithMaximumValue_ShouldBeValid()
            // moq gebruiken 
            {
                // Arrange
                CreateTicketInputModel ticket = new CreateTicketInputModel
                {
                    TicketType = "VIP-Ticket",
                    Price = 999999,
                    Quantity = 10
                };

                Mock<ITicketValidationService> mockValidationService =
                    new Mock<ITicketValidationService>();

                mockValidationService
                    .Setup(service => service.ChecksIsValid(ticket))
                    .Returns(true);

                // Act
                bool isValid = mockValidationService.Object.ChecksIsValid(ticket);

                // Assert
                isValid.Should().BeTrue();
            }

            [Fact]
            public void ETP31_priceWithAboveMaximumValue_ShouldBeInvalid()
            {
                // Arrange
                CreateTicketInputModel ticket = new CreateTicketInputModel
                {
                    TicketType = "VIP-Ticket",
                    Price = 1000000,
                    Quantity = 10
                };

                Mock<ITicketValidationService> mockValidationService =
                    new Mock<ITicketValidationService>();

                mockValidationService
                    .Setup(service => service.ChecksIsValid(ticket))
                    .Returns(false);

                // Act
                bool isValid = mockValidationService.Object.ChecksIsValid(ticket);

                // Assert
                isValid.Should().BeFalse();

            }

            //    [Fact]
            //    public async Task ETP34_AddTicket_ShouldSaveTicket_WhenTicketIsValid()
            //    {
            //        // Arrange
            //        CreateTicketInputModel ticket = new CreateTicketInputModel
            //        {
            //            TicketType = "VIP-Ticket",
            //            Price = 50m,
            //            Quantity = 10
            //        };

            //        // Act
            //        bool result = await _ticketService.AddTicketAsync(ticket);

            //        // Assert
            //        result.Should().BeTrue();

            //        CreateTicketInputModel? savedTicket = await _context.Tickets
            //            .FirstOrDefaultAsync(t => t.TicketType == "VIP-Ticket");

            //        savedTicket.Should().NotBeNull();
            //        savedTicket!.TicketType.Should().Be("VIP-Ticket");
            //        savedTicket.Price.Should().Be(50m);
            //        savedTicket.Quantity.Should().Be(10);
            //    }
        }
    }
}