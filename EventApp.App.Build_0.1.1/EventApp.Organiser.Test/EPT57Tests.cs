using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit.Abstractions;
using EventApp.OrganiserPortal.Interface;
using EventApp.OrganiserPortal.Models;
using EventApp.OrganiserPortal.Repositories;
using EventApp.OrganiserPortal.Services;
using EventApp.OrganiserPortal.Tests;
using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Moq;

namespace EventApp.Organiser.Test
{
    public class EPT57Tests
    {
        private readonly ITestOutputHelper _output;

        public EPT57Tests(ITestOutputHelper output)
        {
            _output = output;
        }

        [Fact]
        public async Task EPT57_GeldigeInvoer_WordtDoorgegevenEnGelogd()
        {
            // Arrange: bereid geldige invoer voor en vervang de repository en logger door mocks.
            int organiserId = 1;
            int eventId = 57;
            CreateEventInputModel input = FormTestHelper.MaakGeldigeInvoer();

            Mock<IOrganiserRepository> repositoryMock =
                new Mock<IOrganiserRepository>();

            Mock<ILogger<LoggingOrganiserService>> loggerMock =
                new Mock<ILogger<LoggingOrganiserService>>();

            repositoryMock
                .Setup(repository => repository.CreateEventAsync(
                    organiserId, eventId, input))
                .Returns(Task.CompletedTask);

            // Registreer de services zodat de test dezelfde aanroep via IOrganiserService kan doen.
            ServiceCollection services = new ServiceCollection();

            services.AddSingleton<IOrganiserRepository>(repositoryMock.Object);
            services.AddSingleton<ILogger<LoggingOrganiserService>>(loggerMock.Object);
            services.AddScoped<OrganiserService>();

            services.AddScoped<IOrganiserService>(provider =>
                new LoggingOrganiserService(
                    provider.GetRequiredService<OrganiserService>(),
                    provider.GetRequiredService<ILogger<LoggingOrganiserService>>()));

            using ServiceProvider serviceProvider = services.BuildServiceProvider();
            using IServiceScope scope = serviceProvider.CreateScope();

            IOrganiserService service =
                scope.ServiceProvider.GetRequiredService<IOrganiserService>();

            // Act: leg de opslagactie vast. NotThrowAsync voert deze hieronder uit.
            Func<Task> opslaan =
                () => service.CreateEventAsync(organiserId, eventId, input);

            // Assert: voer de actie uit en controleer dat er geen uitzondering optreedt.
            await opslaan.Should().NotThrowAsync();

            // Controleer dat precies deze invoer één keer aan de repository is doorgegeven.
            repositoryMock.Verify(
                repository => repository.CreateEventAsync(
                    organiserId, eventId, input),
                Times.Once());

            repositoryMock.VerifyNoOtherCalls();

            // Zoek de enige logaanroep en lees het niveau en de melding uit.
            Moq.IInvocation logAanroep = loggerMock.Invocations.Should()
                .ContainSingle(aanroep => aanroep.Method.Name == nameof(ILogger.Log))
                .Which;

            LogLevel niveau = logAanroep.Arguments[0].Should().BeOfType<LogLevel>().Which;
            string melding = logAanroep.Arguments[2]?.ToString() ?? string.Empty;

            // Toon de ontvangen melding in de xUnit-testuitvoer.
            _output.WriteLine($"{niveau}: {melding}");

            niveau.Should().Be(LogLevel.Information);
            melding.Should().Be(
                "Evenementgegevens opgeslagen voor evenement 57 door organisator 1.");
        }
    }
}
