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

            // Haal evenementen, datumperiodes en toegankelijkheidsopties op.
            var sql = EventQueries.GetAllEvents + @"

SELECT event_id, start_date, end_date
FROM dbo.event_dates;

SELECT event_id, description
FROM dbo.event_accessibility_options;";

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

                    AccessibilityText =
                        reader["accessibility_text"] == DBNull.Value
                            ? string.Empty
                            : reader["accessibility_text"]?.ToString()
                                ?? string.Empty
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

            // Derde resultaat: de toegankelijkheidsopties.
            await reader.NextResultAsync();

            while (await reader.ReadAsync())
            {
                int eventId = reader.GetInt32(0);

                if (!reader.IsDBNull(1) &&
                    eventsById.TryGetValue(eventId, out var eventCard))
                {
                    string option = reader.GetString(1).Trim();

                    if (!string.IsNullOrWhiteSpace(option))
                    {
                        eventCard.AccessibilityOptions.Add(option);
                    }
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

                    AccessibilityText =
                        reader["accessibility_text"] == DBNull.Value
                            ? string.Empty
                            : reader["accessibility_text"]?.ToString()
                                ?? string.Empty
                };

                events.Add(eventCard);
            }

            return events;
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