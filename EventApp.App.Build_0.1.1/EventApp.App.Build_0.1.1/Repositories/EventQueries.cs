namespace EventApp.Web.Repositories.Events
{
    public static class EventQueries
    {
        public const string GetAllEvents = @"
SELECT
    e.event_id,
    e.event_name,
    e.description,
    COALESCE(img.image_url, '/images/events/placeholder.jpg') AS image_url,
    COALESCE(price.min_price, CAST(0 AS DECIMAL(10,2))) AS min_price,
    COALESCE(cat.categories, '') AS categories,
    e.has_standing_places,
    e.has_sitting_places,
    e.disabled_parking_available,
    e.disabled_toilet_available,
    e.wheelchair_accessible_toilet
FROM dbo.events e
OUTER APPLY
(
    SELECT TOP 1 ei.image_url
    FROM dbo.event_images ei
    WHERE ei.event_id = e.event_id
    ORDER BY
        ei.is_primary DESC,
        ei.sort_order ASC,
        ei.event_image_id ASC
) img
OUTER APPLY
(
    SELECT MIN(tp.price) AS min_price
    FROM dbo.event_ticket_prices tp
    WHERE tp.event_id = e.event_id
) price
OUTER APPLY
(
    SELECT STRING_AGG(ec.category_name, ', ') AS categories
    FROM
    (
        SELECT TRY_CONVERT(int, LTRIM(RTRIM(parts.value))) AS category_id
        FROM STRING_SPLIT(ISNULL(e.category_ids, ''), ',') parts

        UNION

        SELECT eec.category_id
        FROM dbo.event_event_categories eec
        WHERE eec.event_id = e.event_id
    ) ids
    INNER JOIN dbo.event_categories ec
        ON ec.category_id = ids.category_id
) cat
WHERE ISNULL(e.canceled, 0) = 0
ORDER BY e.event_name;";

        // Dezelfde query als GetAllEvents, maar gefilterd op een dynamische lijst van event ID's.
        // De {parameterList} placeholder wordt vervangen door iets als '@id0, @id1, @id2'
        // zodat de query geparametriseerd en veilig blijft (geen SQL injection).
        public static string GetEventsByIds(string parameterList) => $@"
SELECT
    e.event_id,
    e.event_name,
    e.description,
    COALESCE(img.image_url, '/images/events/placeholder.jpg') AS image_url,
    COALESCE(price.min_price, CAST(0 AS DECIMAL(10,2))) AS min_price,
    COALESCE(cat.categories, '') AS categories,
    e.has_standing_places,
    e.has_sitting_places,
    e.disabled_parking_available,
    e.disabled_toilet_available,
    e.wheelchair_accessible_toilet
FROM dbo.events e
OUTER APPLY
(
    SELECT TOP 1 ei.image_url
    FROM dbo.event_images ei
    WHERE ei.event_id = e.event_id
    ORDER BY
        ei.is_primary DESC,
        ei.sort_order ASC,
        ei.event_image_id ASC
) img
OUTER APPLY
(
    SELECT MIN(tp.price) AS min_price
    FROM dbo.event_ticket_prices tp
    WHERE tp.event_id = e.event_id
) price
OUTER APPLY
(
    SELECT STRING_AGG(ec.category_name, ', ') AS categories
    FROM
    (
        SELECT TRY_CONVERT(int, LTRIM(RTRIM(parts.value))) AS category_id
        FROM STRING_SPLIT(ISNULL(e.category_ids, ''), ',') parts

        UNION

        SELECT eec.category_id
        FROM dbo.event_event_categories eec
        WHERE eec.event_id = e.event_id
    ) ids
    INNER JOIN dbo.event_categories ec
        ON ec.category_id = ids.category_id
) cat
WHERE e.event_id IN ({parameterList})
  AND ISNULL(e.canceled, 0) = 0
ORDER BY e.event_name;";

        public const string GetDistinctAccessibilityOptions = @"
SELECT N'Invalidenparkeerplaats aanwezig' AS description
WHERE EXISTS (SELECT 1 FROM dbo.events e WHERE ISNULL(e.canceled,0)=0 AND e.disabled_parking_available = 1)
UNION
SELECT N'Invalidentoilet aanwezig'
WHERE EXISTS (SELECT 1 FROM dbo.events e WHERE ISNULL(e.canceled,0)=0 AND e.disabled_toilet_available = 1)
UNION
SELECT N'Rolstoeltoegankelijk toilet'
WHERE EXISTS (SELECT 1 FROM dbo.events e WHERE ISNULL(e.canceled,0)=0 AND e.wheelchair_accessible_toilet = 1)
ORDER BY description;";
    }
}