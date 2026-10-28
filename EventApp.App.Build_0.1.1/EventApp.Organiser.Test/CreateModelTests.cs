using EventApp.OrganiserPortal.Interface;
using EventApp.OrganiserPortal.Pages.Portal;
using EventApp.OrganiserPortal.Services;
using FluentAssertions;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using EventApp.OrganiserPortal.Repositories;
using Microsoft.Extensions.Logging;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EventApp.Organiser.Test
{ // Laura unit test voor CreateModel.cs
    public class CreateModelTests
    {
        // moq en independecy injection
        [Fact]
        public void CreateModel_CanBeCreated()
        {
            // Arrange
            Mock<IOrganiserRepository> organiserRepository =
                new Mock<IOrganiserRepository>();

            Mock<IWebHostEnvironment> environment =
                new Mock<IWebHostEnvironment>();

            Mock<IConfiguration> configuration =
                new Mock<IConfiguration>();

            Mock<ILogger<CreateModel>> logger =
                new Mock<ILogger<CreateModel>>();

            // Act
            CreateModel model = new CreateModel(
                organiserRepository.Object,
                environment.Object,
                configuration.Object,
                logger.Object);

            // Assert
            model.Should().NotBeNull();
        }

        [Fact]
        public void OrganiserService_CanBeCreatedUsingDependencyInjection()
        {
            // Arrange
            ServiceCollection services = new ServiceCollection();

            IConfiguration configuration = new ConfigurationBuilder()
                .AddInMemoryCollection(new Dictionary<string, string?>
                {
            { "ConnectionStrings:db-eventapp", "test-connection-string" }
                })
                .Build();

            services.AddSingleton<IConfiguration>(configuration);
            services.AddScoped<IOrganiserRepository, SqlOrganiserRepository>();
            services.AddScoped<IOrganiserService, OrganiserService>();
            services.AddScoped<ILogger<CreateModel>, Logger<CreateModel>>();

            // Act
            using ServiceProvider serviceProvider = services.BuildServiceProvider();

            IOrganiserService service =
                serviceProvider.GetRequiredService<IOrganiserService>();

            // Assert
            service.Should().NotBeNull();
        }

    }
}
