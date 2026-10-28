using Microsoft.AspNetCore.Mvc.RazorPages;
using EventApp.Web.Models;
using EventApp.Web.Repositories;

namespace EventApp.Web.Pages
{
    public class IndexModel : PageModel
    {
        private readonly IEventRepository _eventRepository;

        public List<EventCard> Events { get; set; } = new();

        public List<string> AllCategories { get; set; } = new();
        public List<string> AllAccessibility { get; set; } = new();

        public List<string> SelectedCategories { get; set; } = new();
        public List<string> SelectedAccessibility { get; set; } = new();

        public DateTime? EventDate { get; set; }

        public decimal MinPrice { get; set; } = 0;
        public decimal MaxPrice { get; set; } = 2200;
        public int MinRating { get; set; } = 0;
        public bool AdultsOnly { get; set; } = false;

        public IndexModel(IEventRepository eventRepository)
        {
            _eventRepository = eventRepository;
        }

        public async Task OnGetAsync(
            decimal minPrice = 0,
            decimal maxPrice = 2200,
            List<string>? categories = null,
            List<string>? accessibility = null,
            int minRating = 0,
            bool adultsOnly = false,
            DateTime? eventDate = null)
        {
            // Bewaar de gekozen filters.
            AdultsOnly = adultsOnly;
            EventDate = eventDate?.Date;

            SelectedCategories = categories ?? new List<string>();
            SelectedAccessibility = accessibility ?? new List<string>();

            // Controleer de prijsgrenzen.
            if (minPrice > maxPrice)
            {
                (minPrice, maxPrice) = (maxPrice, minPrice);
            }

            MinPrice = Math.Max(0, minPrice);
            MaxPrice = Math.Max(MinPrice, maxPrice);
            MinRating = Math.Clamp(minRating, 0, 5);

            var allEvents = await _eventRepository.GetAllEventsAsync();

            // Bouw de opties op uit alle evenementen.
            // Zo verdwijnen opties niet wanneer je een filter toepast.
            AllCategories = allEvents
                .SelectMany(e => e.Categories)
                .Where(c => !string.IsNullOrWhiteSpace(c))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .OrderBy(c => c)
                .ToList();

            AllAccessibility = allEvents
                .SelectMany(e => e.AccessibilityOptions)
                .Where(option => !string.IsNullOrWhiteSpace(option))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .OrderBy(option => option)
                .ToList();

            Events = allEvents
                // Prijs.
                .Where(e =>
                    e.MinPrice >= MinPrice &&
                    e.MinPrice <= MaxPrice)

                // Leeftijd.
                .Where(e =>
                    !AdultsOnly || e.IsAdultsOnly)

                // Beoordeling.
                .Where(e =>
                    MinRating == 0 ||
                    e.RatingValue >= MinRating)

                // Minstens één gekozen categorie moet overeenkomen.
                .Where(e =>
                    SelectedCategories.Count == 0 ||
                    e.Categories.Any(category =>
                        SelectedCategories.Contains(
                            category,
                            StringComparer.OrdinalIgnoreCase)))

                // Alle gekozen toegankelijkheidsopties moeten aanwezig zijn.
                .Where(e =>
                    SelectedAccessibility.All(option =>
                        e.AccessibilityOptions.Contains(
                            option,
                            StringComparer.OrdinalIgnoreCase)))

                // De gekozen datum valt binnen een evenementperiode.
                // De begin- en einddatum tellen ook mee.
                .Where(e =>
                    !EventDate.HasValue ||
                    e.Dates.Any(period =>
                        period.Start.Date <= EventDate.Value &&
                        period.End.Date >= EventDate.Value))

                .ToList();
        }
    }
}