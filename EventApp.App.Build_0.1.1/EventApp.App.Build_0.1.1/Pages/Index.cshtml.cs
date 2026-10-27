using Microsoft.AspNetCore.Mvc.RazorPages;
using EventApp.Web.Models;
using EventApp.Web.Repositories;

namespace EventApp.Web.Pages
{

    // Deze Class bevat de logica voor de homepagina
    // Razor Pages deelt de pagina in:
    // - .cshtml voor de html zelf
    // - .cshtml.cs voor de C# logica
    public class IndexModel : PageModel
    {
        // Deze variabele slaat de repository op zodat we die later kunnen gebruiken
        private readonly IEventRepository _eventRepository;

        // Deze eigenschap bewaart alle event cards voor de pagina
        // De pagina kan dit lezen en weergeven
        public List<EventCard> Events { get; set; } = new();

        // Alle beschikbare categorieën
        public List<string> AllCategories { get; set; } = new();

        // Geselecteerde filterwaarden
        public decimal MinPrice { get; set; } = 0;
        public decimal MaxPrice { get; set; } = 2200;
        public int MinRating { get; set; } = 0;
        public bool AdultsOnly { get; set; } = false;

        public List<string> SelectedCategories { get; set; } = new();
        public List<string> SelectedAccessibility { get; set; } = new();

        // De constructor runt wanneer de pagina model is aangemaakt
        // ASP.NET injecteert IEventRepository automatisch als Program.cs correct is ingesteld
        public IndexModel(IEventRepository eventRepository)
        {
            _eventRepository = eventRepository;
        }

        // OnGetAssync runt wanneer iemand de homepagina opent met een normale GET request
        // Dit is waar we de events laden van de database
        public async Task OnGetAsync(
            decimal minPrice = 0,
            decimal maxPrice = 2200,
            List<string>? categories = null,
            List<string>? accessibility = null,
            int minRating = 0,
            bool adultsOnly = false)
        {
            // Bewaar de geselecteerde filters
            AdultsOnly = adultsOnly;

            // Controleer de prijsgrenzen
            if (minPrice > maxPrice)
            {
                (minPrice, maxPrice) = (maxPrice, minPrice);
            }

            MinPrice = Math.Max(0, minPrice);
            MaxPrice = Math.Max(MinPrice, maxPrice);
            MinRating = Math.Clamp(minRating, 0, 5);

            // Bewaar de geselecteerde filters
            SelectedCategories = categories ?? new List<string>();
            SelectedAccessibility = accessibility ?? new List<string>();

            // Haal alle evenementen op
            var allEvents = await _eventRepository.GetAllEventsAsync();

            // Haal automatisch alle unieke categorieën op
            AllCategories = allEvents
                .SelectMany(e => e.Categories)
                .Where(c => !string.IsNullOrWhiteSpace(c))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .OrderBy(c => c)
                .ToList();

            // Filter de evenementen
            Events = allEvents
                // Filter op prijs
                .Where(e =>
                    e.MinPrice >= MinPrice &&
                    e.MinPrice <= MaxPrice)

                // Filter op leeftijd
                .Where(e => !AdultsOnly || e.IsAdultsOnly)


                // Filter op beoordeling
                .Where(e =>
                    MinRating == 0 ||
                    e.RatingValue >= MinRating)

                // Filter op categorie
                .Where(e =>
                    SelectedCategories.Count == 0 ||
                    e.Categories.Any(category =>
                        SelectedCategories.Contains(
                            category,
                            StringComparer.OrdinalIgnoreCase)))

                // Filter op toegankelijkheid
                .Where(e =>
                    SelectedAccessibility.Count == 0 ||
                    SelectedAccessibility.All(option =>
                        e.AccessibilityText.Contains(
                            option,
                            StringComparison.OrdinalIgnoreCase)))

                .ToList();


        }
    }
}