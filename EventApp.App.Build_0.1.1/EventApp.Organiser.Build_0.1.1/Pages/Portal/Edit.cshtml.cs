using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using EventApp.OrganiserPortal.Models;
using EventApp.OrganiserPortal.Repositories;

namespace EventApp.OrganiserPortal.Pages.Portal
{
    [Authorize]
    public class EditModel : PageModel
    {
        private readonly IOrganiserRepository _organiserRepository;

        public EditModel(IOrganiserRepository organiserRepository)
        {
            _organiserRepository = organiserRepository;
        }

        [BindProperty]
        public CreateEventInputModel Input { get; set; } = new();

        [BindProperty(SupportsGet = true)]
        public int Id { get; set; }

        public List<(int CategoryId, string CategoryName)> AvailableCategories { get; set; } = new();

        public async Task<IActionResult> OnGetAsync()
        {
            var organiserIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(organiserIdValue, out var organiserId))
            {
                return Unauthorized();
            }

            var eventData = await _organiserRepository.GetEventForEditAsync(organiserId, Id);
            if (eventData == null)
            {
                return NotFound();
            }

            Input = eventData;
            AvailableCategories = await _organiserRepository.GetAllCategoriesAsync();
            return Page();
        }

        public async Task<IActionResult> OnPostAddCategoryAsync(string categoryName)
        {
            var trimmedName = categoryName?.Trim();

            if (string.IsNullOrWhiteSpace(trimmedName))
            {
                return BadRequest(new { message = "Vul een categorienaam in." });
            }

            if (trimmedName.Length > 100)
            {
                return BadRequest(new { message = "Gebruik maximaal 100 tekens voor een categorie." });
            }

            try
            {
                var category = await _organiserRepository.GetOrCreateCategoryAsync(trimmedName);
                return new JsonResult(new { categoryId = category.CategoryId, categoryName = category.CategoryName });
            }
            catch (Exception)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "De categorie kon niet worden opgeslagen." });
            }
        }

        public async Task<IActionResult> OnPostAsync()
        {
            var organiserIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(organiserIdValue, out var organiserId))
            {
                return Unauthorized();
            }

            AvailableCategories = await _organiserRepository.GetAllCategoriesAsync();

            if (Input.Tickets == null)
            {
                Input.Tickets = new();
            }

            Input.Tickets = Input.Tickets
                .Where(x => !string.IsNullOrWhiteSpace(x.TicketType))
                .ToList();

            if (!Input.Tickets.Any())
            {
                Input.Tickets.Add(new CreateTicketInputModel
                {
                    TicketType = "Gratis",
                    Price = 0
                });
            }

            if (!ModelState.IsValid)
            {
                return Page();
            }

            await _organiserRepository.UpdateEventAsync(organiserId, Id, Input);
            return RedirectToPage("/Portal/Dashboard");
        }

        public async Task<IActionResult> OnPostCancelAsync()
        {
            var organiserIdValue = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(organiserIdValue, out var organiserId))
            {
                return Unauthorized();
            }

            await _organiserRepository.CancelEventAsync(organiserId, Id);
            return RedirectToPage("/Portal/Dashboard");
        }
    }
}