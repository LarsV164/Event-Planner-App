using System.Data;
using Microsoft.Data.SqlClient;
using EventApp.OrganiserPortal.Models;
using EventApp.OrganiserPortal.Queries;

namespace EventApp.OrganiserPortal.Repositories
{
    public class SqlOrganiserRepository : IOrganiserRepository
    {
        private readonly string _connectionString;

        public SqlOrganiserRepository(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("db-eventapp")
                ?? throw new InvalidOperationException("Connection string 'db-eventapp' not found or unreachable.");
        }

        public async Task<OrganiserModel?> GetByEmailAsync(string email)
        {
            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            await using var command = new SqlCommand(OrganiserQueries.GetOrganiserByEmail, connection);
            command.Parameters.AddWithValue("@Email", email);

            await using var reader = await command.ExecuteReaderAsync();

            if (!await reader.ReadAsync())
            {
                return null;
            }

            return new OrganiserModel
            {
                OrganiserId = reader.GetInt32(reader.GetOrdinal("organiser_id")),
                CompanyName = reader.GetString(reader.GetOrdinal("company_name")),
                ContactName = reader.IsDBNull(reader.GetOrdinal("contact_name"))
                    ? null
                    : reader.GetString(reader.GetOrdinal("contact_name")),
                Email = reader.GetString(reader.GetOrdinal("email")),
                PasswordHash = reader.GetString(reader.GetOrdinal("password_hash")),
                IsActive = reader.GetBoolean(reader.GetOrdinal("is_active"))
            };
        }

        public async Task<List<OrganiserEventListItemModel>> GetEventsByOrganiserIdAsync(int organiserId)
        {
            var results = new List<OrganiserEventListItemModel>();

            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            await using var command = new SqlCommand(OrganiserQueries.GetEventsByOrganiserId, connection);
            command.Parameters.AddWithValue("@OrganiserId", organiserId);

            await using var reader = await command.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                results.Add(new OrganiserEventListItemModel
                {
                    EventId = reader.GetInt32(reader.GetOrdinal("event_id")),
                    EventName = reader.GetString(reader.GetOrdinal("event_name")),
                    IndoorsOutdoors = reader.IsDBNull(reader.GetOrdinal("indoors_outdoors"))
                        ? string.Empty
                        : IndoorsOutdoors.GetMessage(reader.GetInt32(reader.GetOrdinal("indoors_outdoors"))),
                    Description = reader.IsDBNull(reader.GetOrdinal("description"))
                        ? string.Empty
                        : reader.GetString(reader.GetOrdinal("description")),
                    ImageUrl = reader.IsDBNull(reader.GetOrdinal("image_url"))
                        ? string.Empty
                        : reader.GetString(reader.GetOrdinal("image_url")),
                    MinPrice = reader.IsDBNull(reader.GetOrdinal("min_price"))
                        ? null
                        : reader.GetDecimal(reader.GetOrdinal("min_price")),
                    CategoriesText = reader.IsDBNull(reader.GetOrdinal("categories_text"))
                        ? string.Empty
                        : reader.GetString(reader.GetOrdinal("categories_text")),
                    AccessibilityText = reader.IsDBNull(reader.GetOrdinal("accessibility_text"))
                        ? string.Empty
                        : reader.GetString(reader.GetOrdinal("accessibility_text")),
                    IsCanceled = !reader.IsDBNull(reader.GetOrdinal("canceled"))
                        && reader.GetBoolean(reader.GetOrdinal("canceled"))
                });
            }

            return results;
        }

        public async Task<int> GetNextEventIdAsync()
        {
            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            await using var command = new SqlCommand(OrganiserQueries.GetNextEventId, connection);
            var result = await command.ExecuteScalarAsync();
            return Convert.ToInt32(result);
        }

        public async Task CreateEventAsync(int organiserId, int eventId, CreateEventInputModel input)
        {
            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync();

            try
            {
                var locationId = await GetOrCreateLocationIdAsync(connection, transaction, input);

                await InsertEventAsync(connection, transaction, eventId, locationId, organiserId, input);
                await InsertEventDatesAsync(connection, transaction, eventId, input);
                await InsertTicketsAsync(connection, transaction, eventId, input);
                await InsertAccessibilityOptionsAsync(connection, transaction, eventId, input);
                await InsertCategoriesAsync(connection, transaction, eventId, input);

                await transaction.CommitAsync();
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task AddEventImagesAsync(int eventId, List<string> imageUrls)
        {
            if (imageUrls == null || imageUrls.Count == 0)
            {
                return;
            }

            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync();

            try
            {
                var nextEventImageId = await GetNextIdAsync(connection, transaction, OrganiserQueries.GetNextEventImageId);

                for (var i = 0; i < imageUrls.Count; i++)
                {
                    await using var command = new SqlCommand(OrganiserQueries.InsertEventImage, connection, transaction);
                    command.Parameters.AddWithValue("@EventImageId", nextEventImageId++);
                    command.Parameters.AddWithValue("@EventId", eventId);
                    command.Parameters.AddWithValue("@ImageUrl", imageUrls[i]);
                    command.Parameters.AddWithValue("@IsPrimary", i == 0);
                    command.Parameters.AddWithValue("@SortOrder", i);
                    await command.ExecuteNonQueryAsync();
                }

                await transaction.CommitAsync();
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task<CreateEventInputModel?> GetEventForEditAsync(int organiserId, int eventId)
        {
            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            await using var command = new SqlCommand(OrganiserQueries.GetEventForEdit, connection);
            command.Parameters.AddWithValue("@OrganiserId", organiserId);
            command.Parameters.AddWithValue("@EventId", eventId);

            await using var reader = await command.ExecuteReaderAsync();

            if (!await reader.ReadAsync())
            {
                return null;
            }

            return new CreateEventInputModel
            {
                EventName = reader.GetString(reader.GetOrdinal("event_name")),
                IndoorsOutdoors = reader.IsDBNull(reader.GetOrdinal("indoors_outdoors"))
                    ? null
                    : IndoorsOutdoors.GetMessage(reader.GetInt32(reader.GetOrdinal("indoors_outdoors"))),
                Description = reader.IsDBNull(reader.GetOrdinal("description"))
                    ? string.Empty
                    : reader.GetString(reader.GetOrdinal("description")),
                Latitude = reader.IsDBNull(reader.GetOrdinal("latitude"))
                    ? null
                    : reader.GetDecimal(reader.GetOrdinal("latitude")),
                Longitude = reader.IsDBNull(reader.GetOrdinal("longitude"))
                    ? null
                    : reader.GetDecimal(reader.GetOrdinal("longitude")),
                HasStandingPlaces = reader.IsDBNull(reader.GetOrdinal("has_standing_places"))
                    ? null
                    : reader.GetBoolean(reader.GetOrdinal("has_standing_places")),
                HasSittingPlaces = reader.IsDBNull(reader.GetOrdinal("has_sitting_places"))
                    ? null
                    : reader.GetBoolean(reader.GetOrdinal("has_sitting_places")),
                DisabledParkingAvailable = reader.IsDBNull(reader.GetOrdinal("disabled_parking_available"))
                    ? null
                    : reader.GetBoolean(reader.GetOrdinal("disabled_parking_available")),
                DisabledToiletAvailable = reader.IsDBNull(reader.GetOrdinal("disabled_toilet_available"))
                    ? null
                    : reader.GetBoolean(reader.GetOrdinal("disabled_toilet_available")),
                WheelchairAccessibleToilet = reader.IsDBNull(reader.GetOrdinal("wheelchair_accessible_toilet"))
                    ? null
                    : reader.GetBoolean(reader.GetOrdinal("wheelchair_accessible_toilet"))
            };
        }

        public async Task UpdateEventAsync(int organiserId, int eventId, CreateEventInputModel input)
        {
            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync();

            try
            {
                await using (var eventCommand = new SqlCommand(OrganiserQueries.UpdateEvent, connection, transaction))
                {
                    eventCommand.Parameters.AddWithValue("@OrganiserId", organiserId);
                    eventCommand.Parameters.AddWithValue("@EventId", eventId);
                    eventCommand.Parameters.AddWithValue("@EventName", input.EventName);
                    eventCommand.Parameters.AddWithValue("@IndoorsOutdoors", string.IsNullOrWhiteSpace(input.IndoorsOutdoors)
                        ? DBNull.Value
                        : IndoorsOutdoors.GetValue(input.IndoorsOutdoors));
                    eventCommand.Parameters.AddWithValue("@Description", string.IsNullOrWhiteSpace(input.Description) ? DBNull.Value : input.Description);
                    eventCommand.Parameters.AddWithValue("@HasStandingPlaces", (object?)input.HasStandingPlaces ?? DBNull.Value);
                    eventCommand.Parameters.AddWithValue("@HasSittingPlaces", (object?)input.HasSittingPlaces ?? DBNull.Value);
                    eventCommand.Parameters.AddWithValue("@DisabledParkingAvailable", (object?)input.DisabledParkingAvailable ?? DBNull.Value);
                    eventCommand.Parameters.AddWithValue("@DisabledToiletAvailable", (object?)input.DisabledToiletAvailable ?? DBNull.Value);
                    eventCommand.Parameters.AddWithValue("@WheelchairAccessibleToilet", (object?)input.WheelchairAccessibleToilet ?? DBNull.Value);

                    await eventCommand.ExecuteNonQueryAsync();
                }

                await using (var locationCommand = new SqlCommand(OrganiserQueries.UpdateEventLocation, connection, transaction))
                {
                    locationCommand.Parameters.AddWithValue("@OrganiserId", organiserId);
                    locationCommand.Parameters.AddWithValue("@EventId", eventId);

                    var latitudeParameter = locationCommand.Parameters.Add("@Latitude", SqlDbType.Decimal);
                    latitudeParameter.Precision = 9;
                    latitudeParameter.Scale = 6;
                    latitudeParameter.Value = input.Latitude.HasValue
                        ? Math.Round(input.Latitude.Value, 6)
                        : DBNull.Value;

                    var longitudeParameter = locationCommand.Parameters.Add("@Longitude", SqlDbType.Decimal);
                    longitudeParameter.Precision = 9;
                    longitudeParameter.Scale = 6;
                    longitudeParameter.Value = input.Longitude.HasValue
                        ? Math.Round(input.Longitude.Value, 6)
                        : DBNull.Value;

                    await locationCommand.ExecuteNonQueryAsync();
                }

                await transaction.CommitAsync();
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task CancelEventAsync(int organiserId, int eventId)
        {
            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            await using var command = new SqlCommand(OrganiserQueries.CancelEvent, connection);
            command.Parameters.AddWithValue("@OrganiserId", organiserId);
            command.Parameters.AddWithValue("@EventId", eventId);

            await command.ExecuteNonQueryAsync();
        }

        private static async Task<int> GetNextIdAsync(
            SqlConnection connection,
            SqlTransaction transaction,
            string sql)
        {
            await using var command = new SqlCommand(sql, connection, transaction);
            var result = await command.ExecuteScalarAsync();
            return Convert.ToInt32(result);
        }

        private static async Task<int> GetOrCreateLocationIdAsync(
            SqlConnection connection,
            SqlTransaction transaction,
            CreateEventInputModel input)
        {
            // dbo.locations has a unique index on (latitude, longitude) with IGNORE_DUP_KEY = ON.
            // A duplicate location insert is therefore silently skipped, which used to leave the
            // event pointing at a location_id that was never created (FK_events_location).
            var existingLocationId = await FindLocationIdAsync(
                connection,
                transaction,
                input.Latitude,
                input.Longitude);

            if (existingLocationId.HasValue)
            {
                return existingLocationId.Value;
            }

            for (var attempt = 0; attempt < 3; attempt++)
            {
                var candidateId = await GetNextIdAsync(connection, transaction, OrganiserQueries.GetNextLocationId);
                var rowsAffected = await InsertLocationAsync(connection, transaction, candidateId, input);

                if (rowsAffected > 0)
                {
                    return candidateId;
                }

                // The insert was ignored because of a duplicate key; reuse the existing row.
                existingLocationId = await FindLocationIdAsync(
                    connection,
                    transaction,
                    input.Latitude,
                    input.Longitude);

                if (existingLocationId.HasValue)
                {
                    return existingLocationId.Value;
                }
            }

            throw new InvalidOperationException("Kon geen locatie aanmaken voor het evenement.");
        }

        private static async Task<int?> FindLocationIdAsync(
            SqlConnection connection,
            SqlTransaction transaction,
            decimal? latitude,
            decimal? longitude)
        {
            await using var command = new SqlCommand(OrganiserQueries.FindLocationIdByCoordinates, connection, transaction);

            var latitudeParameter = command.Parameters.Add("@Latitude", SqlDbType.Decimal);
            latitudeParameter.Precision = 9;
            latitudeParameter.Scale = 6;
            latitudeParameter.Value = latitude.HasValue
                ? Math.Round(latitude.Value, 6)
                : DBNull.Value;

            var longitudeParameter = command.Parameters.Add("@Longitude", SqlDbType.Decimal);
            longitudeParameter.Precision = 9;
            longitudeParameter.Scale = 6;
            longitudeParameter.Value = longitude.HasValue
                ? Math.Round(longitude.Value, 6)
                : DBNull.Value;

            var result = await command.ExecuteScalarAsync();

            return result == null || result == DBNull.Value
                ? null
                : Convert.ToInt32(result);
        }

        private static async Task<int> InsertLocationAsync(
            SqlConnection connection,
            SqlTransaction transaction,
            int locationId,
            CreateEventInputModel input)
        {
            await using var command = new SqlCommand(OrganiserQueries.InsertLocation, connection, transaction);

            command.Parameters.AddWithValue("@LocationId", locationId);

            var latitudeParameter = command.Parameters.Add("@Latitude", SqlDbType.Decimal);
            latitudeParameter.Precision = 9;
            latitudeParameter.Scale = 6;
            latitudeParameter.Value = input.Latitude.HasValue
                ? Math.Round(input.Latitude.Value, 6)
                : DBNull.Value;

            var longitudeParameter = command.Parameters.Add("@Longitude", SqlDbType.Decimal);
            longitudeParameter.Precision = 9;
            longitudeParameter.Scale = 6;
            longitudeParameter.Value = input.Longitude.HasValue
                ? Math.Round(input.Longitude.Value, 6)
                : DBNull.Value;

            // Add address parameters
            command.Parameters.AddWithValue("@Street", string.IsNullOrWhiteSpace(input.Street) ? DBNull.Value : input.Street);
            command.Parameters.AddWithValue("@HouseNumber", (object?)input.HouseNumber ?? DBNull.Value);
            command.Parameters.AddWithValue("@HouseNumberAddition", string.IsNullOrWhiteSpace(input.HouseNumberAddition) ? DBNull.Value : input.HouseNumberAddition);
            command.Parameters.AddWithValue("@PostalCode", string.IsNullOrWhiteSpace(input.PostalCode) ? DBNull.Value : input.PostalCode);
            command.Parameters.AddWithValue("@City", string.IsNullOrWhiteSpace(input.City) ? DBNull.Value : input.City);

            return await command.ExecuteNonQueryAsync();
        }

        private static async Task InsertEventAsync(
            SqlConnection connection,
            SqlTransaction transaction,
            int eventId,
            int locationId,
            int organiserId,
            CreateEventInputModel input)
        {
            await using var command = new SqlCommand(OrganiserQueries.InsertEvent, connection, transaction);
            command.Parameters.AddWithValue("@EventId", eventId);
            command.Parameters.AddWithValue("@EventName", input.EventName);
            command.Parameters.AddWithValue("@IndoorsOutdoors", string.IsNullOrWhiteSpace(input.IndoorsOutdoors)
                ? DBNull.Value
                : IndoorsOutdoors.GetValue(input.IndoorsOutdoors));
            command.Parameters.AddWithValue("@HasStandingPlaces", (object?)input.HasStandingPlaces ?? DBNull.Value);
            command.Parameters.AddWithValue("@HasSittingPlaces", (object?)input.HasSittingPlaces ?? DBNull.Value);
            command.Parameters.AddWithValue("@DisabledParkingAvailable", (object?)input.DisabledParkingAvailable ?? DBNull.Value);
            command.Parameters.AddWithValue("@DisabledToiletAvailable", (object?)input.DisabledToiletAvailable ?? DBNull.Value);
            command.Parameters.AddWithValue("@WheelchairAccessibleToilet", (object?)input.WheelchairAccessibleToilet ?? DBNull.Value);
            command.Parameters.AddWithValue("@LocationId", locationId);
            command.Parameters.AddWithValue("@Description", string.IsNullOrWhiteSpace(input.Description) ? DBNull.Value : input.Description);
            command.Parameters.AddWithValue("@OrganiserId", organiserId);
            command.Parameters.AddWithValue("@ChildrenFriendly", (object?)input.ChildrenFriendly ?? DBNull.Value);
            await command.ExecuteNonQueryAsync();
        }

        private static async Task InsertEventDatesAsync(
            SqlConnection connection,
            SqlTransaction transaction,
            int eventId,
            CreateEventInputModel input)
        {
            await using var command = new SqlCommand(OrganiserQueries.InsertEventDates, connection, transaction);
            command.Parameters.AddWithValue("@EventId", eventId);
            command.Parameters.AddWithValue("@StartDate", (object?)input.StartDate?.Date ?? DBNull.Value);
            command.Parameters.AddWithValue("@EndDate", (object?)input.EndDate?.Date ?? DBNull.Value);
            command.Parameters.AddWithValue("@StartTime", (object?)input.StartTime ?? DBNull.Value);
            command.Parameters.AddWithValue("@EndTime", (object?)input.EndTime ?? DBNull.Value);
            await command.ExecuteNonQueryAsync();
        }

        private static async Task InsertTicketsAsync(
            SqlConnection connection,
            SqlTransaction transaction,
            int eventId,
            CreateEventInputModel input)
        {
            if (input.Tickets == null || input.Tickets.Count == 0)
            {
                return;
            }

            var nextTicketPriceId = await GetNextIdAsync(connection, transaction, OrganiserQueries.GetNextTicketPriceId);

            foreach (var ticket in input.Tickets)
            {
                await using var command = new SqlCommand(OrganiserQueries.InsertTicketPrice, connection, transaction);
                command.Parameters.AddWithValue("@EventTicketPriceId", nextTicketPriceId++);
                command.Parameters.AddWithValue("@TicketType", ticket.TicketType);

                var priceParameter = command.Parameters.Add("@Price", SqlDbType.Decimal);
                priceParameter.Precision = 10;
                priceParameter.Scale = 2;
                priceParameter.Value = Math.Round(ticket.Price, 2);

                command.Parameters.AddWithValue("@EventId", eventId);
                await command.ExecuteNonQueryAsync();
            }
        }

        private static async Task InsertAccessibilityOptionsAsync(
            SqlConnection connection,
            SqlTransaction transaction,
            int eventId,
            CreateEventInputModel input)
        {
            if (input.AccessibilityOptions == null || input.AccessibilityOptions.Count == 0)
            {
                return;
            }

            var nextAccessibilityId = await GetNextIdAsync(connection, transaction, OrganiserQueries.GetNextAccessibilityOptionId);

            foreach (var option in input.AccessibilityOptions.Where(x => !string.IsNullOrWhiteSpace(x)))
            {
                await using var command = new SqlCommand(OrganiserQueries.InsertAccessibilityOption, connection, transaction);
                command.Parameters.AddWithValue("@AccessibilityOptionId", nextAccessibilityId++);
                command.Parameters.AddWithValue("@Description", option.Trim());
                command.Parameters.AddWithValue("@EventId", eventId);
                await command.ExecuteNonQueryAsync();
            }
        }

        private static async Task InsertCategoriesAsync(
            SqlConnection connection,
            SqlTransaction transaction,
            int eventId,
            CreateEventInputModel input)
        {
            if (input.Categories == null || input.Categories.Count == 0)
            {
                return;
            }

            foreach (var categoryName in input.Categories.Where(x => !string.IsNullOrWhiteSpace(x)))
            {
                int categoryId;

                await using (var findCommand = new SqlCommand(OrganiserQueries.FindCategoryByName, connection, transaction))
                {
                    findCommand.Parameters.AddWithValue("@CategoryName", categoryName.Trim());
                    var existingId = await findCommand.ExecuteScalarAsync();

                    if (existingId != null)
                    {
                        categoryId = Convert.ToInt32(existingId);
                    }
                    else
                    {
                        await using var insertCategoryCommand = new SqlCommand(OrganiserQueries.InsertCategory, connection, transaction);
                        insertCategoryCommand.Parameters.AddWithValue("@CategoryName", categoryName.Trim());
                        categoryId = Convert.ToInt32(await insertCategoryCommand.ExecuteScalarAsync());
                    }
                }

                await using var linkCommand = new SqlCommand(OrganiserQueries.LinkEventCategory, connection, transaction);
                linkCommand.Parameters.AddWithValue("@CategoryId", categoryId);
                linkCommand.Parameters.AddWithValue("@EventId", eventId);
                await linkCommand.ExecuteNonQueryAsync();
            }
        }
    }
}