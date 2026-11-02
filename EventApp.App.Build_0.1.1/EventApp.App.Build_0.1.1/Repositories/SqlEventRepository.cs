using Microsoft.Data.SqlClient;
using EventApp.Web.Models;
using EventApp.Web.Repositories.Events;

namespace EventApp.Web.Repositories
{
    public class SqlEventRepository : IEventRepository
    {
        private readonly string _connectionString;

        public SqlEventRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<List<EventCard>> GetAllEventsAsync()
        {
            var events = new List<EventCard>();

            // Haal evenementen en datumperiodes op.
            var sql = EventQueries.GetAllEvents + @"
SELECT event_id, start_date, end_date
FROM dbo.event_dates;";

            await using var connection =
                new SqlConnection(_connectionString);

            await connection.OpenAsync();

            await using var command =
                new SqlCommand(sql, connection);

            await using var reader =
                await command.ExecuteReaderAsync();

            // Eerste resultaat: de evenementen.
            while (await reader.ReadAsync())
            {
                var eventName =
                    reader["event_name"]?.ToString() ?? string.Empty;

                var categories =
                    reader["categories"]?.ToString()?.Split(", ").ToList()
                    ?? new List<string>();

                var accessibilityOptions = BuildAccessibilityOptions(
                    reader["disabled_parking_available"],
                    reader["disabled_toilet_available"],
                    reader["wheelchair_accessible_toilet"]);

                var eventCard = new EventCard
                {
                    EventId = reader.GetInt32(
                        reader.GetOrdinal("event_id")),

                    EventName = eventName,

                    Description = reader["description"] == DBNull.Value
                        ? string.Empty
                        : reader["description"]?.ToString() ?? string.Empty,

                    ImageUrl = reader["image_url"] == DBNull.Value
                        ? "/uploads/events/placeholder.jpg"
                        : reader["image_url"]?.ToString()
                            ?? "/uploads/events/placeholder.jpg",

                    MinPrice = reader.GetDecimal(
                        reader.GetOrdinal("min_price")),

                    RatingValue = GetRatingValue(eventName),

                    IsAdultsOnly = GetIsAdultsOnly(
                        eventName, categories),

                    Categories = categories,

                    AccessibilityOptions = accessibilityOptions,

                    AccessibilityText = string.Join(
                        ", ", accessibilityOptions)
                };

                events.Add(eventCard);
            }

            // Hiermee vinden we snel het evenement bij een ID.
            var eventsById = events.ToDictionary(e => e.EventId);

            // Tweede resultaat: de datumperiodes.
            await reader.NextResultAsync();

            while (await reader.ReadAsync())
            {
                int eventId = reader.GetInt32(0);

                if (eventsById.TryGetValue(eventId, out var eventCard))
                {
                    DateTime startDate = reader.GetDateTime(1);
                    DateTime endDate = reader.GetDateTime(2);

                    eventCard.Dates.Add((startDate, endDate));
                }
            }

            return events;
        }

        // Haal de opgeslagen evenementen op via hun ID's.
        public async Task<List<EventCard>> GetEventsByIdsAsync(
            IEnumerable<int> ids)
        {
            var idList = ids.ToList();

            if (idList.Count == 0)
            {
                return new List<EventCard>();
            }

            // Iedere ID krijgt een eigen SQL-parameter.
            var parameterNames = idList
                .Select((_, i) => $"@id{i}")
                .ToList();

            var inClause = string.Join(", ", parameterNames);
            var sql = EventQueries.GetEventsByIds(inClause);

            var events = new List<EventCard>();

            await using var connection =
                new SqlConnection(_connectionString);

            await connection.OpenAsync();

            await using var command =
                new SqlCommand(sql, connection);

            for (int i = 0; i < idList.Count; i++)
            {
                command.Parameters.AddWithValue(
                    $"@id{i}", idList[i]);
            }

            await using var reader =
                await command.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                var eventName =
                    reader["event_name"]?.ToString() ?? string.Empty;

                var categories =
                    reader["categories"]?.ToString()?.Split(", ").ToList()
                    ?? new List<string>();

                var accessibilityOptions = BuildAccessibilityOptions(
                    reader["disabled_parking_available"],
                    reader["disabled_toilet_available"],
                    reader["wheelchair_accessible_toilet"]);

                var eventCard = new EventCard
                {
                    EventId = reader.GetInt32(
                        reader.GetOrdinal("event_id")),

                    EventName = eventName,

                    Description = reader["description"] == DBNull.Value
                        ? string.Empty
                        : reader["description"]?.ToString() ?? string.Empty,

                    ImageUrl = reader["image_url"] == DBNull.Value
                        ? "/uploads/events/placeholder.jpg.svg"
                        : reader["image_url"]?.ToString()
                            ?? "/uploads/events/placeholder.jpg.svg",

                    MinPrice = reader.GetDecimal(
                        reader.GetOrdinal("min_price")),

                    RatingValue = GetRatingValue(eventName),

                    IsAdultsOnly = GetIsAdultsOnly(
                        eventName, categories),

                    Categories = categories,

                    AccessibilityOptions = accessibilityOptions,

                    AccessibilityText = string.Join(
                        ", ", accessibilityOptions)
                };

                events.Add(eventCard);
            }

            return events;
        }

        public async Task<List<string>> GetDistinctAccessibilityOptionsAsync()
        {
            var events = await GetAllEventsAsync();

            return events
                .SelectMany(e => e.AccessibilityOptions)
                .Where(option => !string.IsNullOrWhiteSpace(option))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .OrderBy(option => option)
                .ToList();
        }

        // Zet de toegankelijkheidsvelden van dbo.events om naar filteropties.
        private static List<string> BuildAccessibilityOptions(
            object disabledParkingValue,
            object disabledToiletValue,
            object wheelchairValue)
        {
            var options = new List<string>();

            if (disabledParkingValue is bool parking && parking)
            {
                options.Add("Invalidenparkeerplaats aanwezig");
            }

            if (disabledToiletValue is bool toilet && toilet)
            {
                options.Add("Invalidentoilet aanwezig");
            }

            if (wheelchairValue is bool wheelchair && wheelchair)
            {
                options.Add("Rolstoeltoegankelijk toilet");
            }

            return options;
        }

        // Bestaande voorbeeldlogica voor beoordelingen.
        private static int GetRatingValue(string eventName)
        {
            if (eventName.Contains(
                "Pinkpop", StringComparison.OrdinalIgnoreCase))
            {
                return 5;
            }

            if (eventName.Contains(
                    "Cultura Nova", StringComparison.OrdinalIgnoreCase) ||
                eventName.Contains(
                    "Liquicity", StringComparison.OrdinalIgnoreCase) ||
                eventName.Contains(
                    "Amsterdam Dance Event",
                    StringComparison.OrdinalIgnoreCase))
            {
                return 4;
            }

            return 3;
        }

        // Bestaande voorbeeldlogica voor 18+.
        private static bool GetIsAdultsOnly(
            string eventName,
            List<string> categories)
        {
            return categories.Contains("House")
                || categories.Contains("Techno")
                || categories.Contains("EDM")
                || categories.Contains("Trance")
                || categories.Contains("Drum & Bass")
                || categories.Contains("Hardstyle")
                || eventName.Contains(
                    "Liquicity", StringComparison.OrdinalIgnoreCase)
                || eventName.Contains(
                    "Amsterdam Dance Event",
                    StringComparison.OrdinalIgnoreCase);
        }
    }
}