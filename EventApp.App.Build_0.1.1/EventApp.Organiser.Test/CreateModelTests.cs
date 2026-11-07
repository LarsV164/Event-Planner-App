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
            // moq gebruiken voor de dependencies 

            //opslaan of ophalen
            Mock<IOrganiserRepository> organiserRepository =
                new Mock<IOrganiserRepository>();
            // informatie 
            Mock<IWebHostEnvironment> environment =
                new Mock<IWebHostEnvironment>();
            // configuratie
            Mock<IConfiguration> configuration =
                new Mock<IConfiguration>();
            // logger 
            Mock<ILogger<CreateModel>> logger =
                new Mock<ILogger<CreateModel>>();

            // Act aanmaken met de moqs handmatige injection 
            CreateModel model = new CreateModel(
                organiserRepository.Object,
                environment.Object,
                configuration.Object,
                logger.Object);

            // Assert controlleer of het is aangemaakt
            model.Should().NotBeNull();
        }

        // vorige test zonder moq proberen en neppe db connecstring gebruiken 
        [Fact]
        public void OrganiserService_CanBeCreated()

        {
            // Arrange
            // registeren van de dependencies in de service collection
            ServiceCollection services = new ServiceCollection();

            // test connectie string aanmaken,
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

        // test proberen met echte database 
        [Fact]
        public void OrganiserService_Intergration_CanBeCreated()
        {
            // ARRANGE
            // Maak een ServiceCollection aan.
            ServiceCollection services = new ServiceCollection();


            IConfiguration configuration = new ConfigurationBuilder()

                // laden waar de connection string staat hierdoor kan de applicatie de juiste
                // connectie string gebruiken voor de database.
                // dit heb ik gedaan omdat sercret in appsettings.json staat
                .AddJsonFile("appsettings.json", optional: true)
                .AddEnvironmentVariables()
                .Build();

            // We registreren de configuratie voor Dependency Injection.
            services.AddSingleton<IConfiguration>(configuration);

            // registeer de repository.
            services.AddScoped<IOrganiserRepository, SqlOrganiserRepository>();

            // registeer de service.
            services.AddScoped<IOrganiserService, OrganiserService>();

            // registeer logging.
            services.AddLogging();

            // ACT
            // serviceprovider aanmaken voor de implentatie bij de interfaces.
            using ServiceProvider serviceProvider = services.BuildServiceProvider();

            //vraag de service op bij de serviceprovider
            IOrganiserService service = serviceProvider.GetRequiredService<IOrganiserService>();

            // ASSERT
            // controleren of het is aangemaakt
            service.Should().NotBeNull();
        }

    }
}
