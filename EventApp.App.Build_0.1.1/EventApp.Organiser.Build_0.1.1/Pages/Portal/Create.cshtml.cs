using EventApp.OrganiserPortal.Models;
using EventApp.OrganiserPortal.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Security.Claims;

namespace EventApp.OrganiserPortal.Pages.Portal
{
    [Authorize]
    public class CreateModel : PageModel
    {
        private static readonly string[] AllowedImageExtensions = [".jpg", ".jpeg", ".png", ".webp"];
        private const long MaxImageSizeBytes = 5 * 1024 * 1024;
        private const int MaxAttachmentCount = 5;
        private const long MaxAttachmentSizeBytes = 5 * 1024 * 1024;

        private static readonly Dictionary<string, string> AllowedAttachmentTypes = new()
        {
            [".pdf"] = "application/pdf",
            [".docx"] = "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            [".xlsx"] = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            [".txt"] = "text/plain",
            [".jpg"] = "image/jpeg",
            [".jpeg"] = "image/jpeg",
            [".png"] = "image/png",
            [".webp"] = "image/webp"
        };

        private readonly IOrganiserRepository _organiserRepository;
        private readonly IWebHostEnvironment _environment;
        private readonly IConfiguration _configuration;
        private readonly ILogger<CreateModel> _logger;

        public CreateModel(
            IOrganiserRepository organiserRepository,
            IWebHostEnvironment environment,
            IConfiguration configuration,
            ILogger<CreateModel> logger)
        {
            _organiserRepository = organiserRepository;
            _environment = environment;
            _configuration = configuration;
            _logger = logger;
        }

        [BindProperty]
        public CreateEventInputModel Input { get; set; } = new();

        [BindProperty]
        public List<IFormFile> Images { get; set; } = new();

        [BindProperty]
        public List<IFormFile> Attachments { get; set; } = new();

        public List<SelectListItem> TicketTypeOptions { get; set; } = new();

        private void LoadTicketTypes()
        {
            TicketTypeOptions = new List<SelectListItem>
            {
                new("Sta-Ticket", "Sta-Ticket"),
                new("Zit-Ticket", "Zit-Ticket"),
                new("Invalide-Ticket", "Invalide-Ticket"),
                new("VIP-Ticket", "VIP-Ticket")
            };
        }

        public void OnGet()
        {
            LoadTicketTypes();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            LoadTicketTypes();

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

            if (!Images.Any())
            {
                ModelState.AddModelError(nameof(Images), "Upload minimaal één afbeelding.");
            }

            // House number only required when NOT in map/no-address mode
            if (Input.NoAddressMode)
            {
                ModelState.Remove("Input.HouseNumber");
            }
            if (Attachments.Count > MaxAttachmentCount)
            {
                ModelState.AddModelError(nameof(Attachments),
                    "Voeg maximaal 5 bijlagen toe.");
            }

            foreach (var attachment in Attachments)
            {
                var fileName = Path.GetFileName(attachment.FileName.Replace('\\', '/'));
                var extension = Path.GetExtension(fileName).ToLowerInvariant();

                if (string.IsNullOrWhiteSpace(fileName) || fileName.Length > 255)
                {
                    ModelState.AddModelError(nameof(Attachments),
                        "Gebruik een bestandsnaam van maximaal 255 tekens.");
                }

                if (attachment.Length <= 0)
                {
                    ModelState.AddModelError(nameof(Attachments),
                        $"Bijlage '{fileName}' is leeg.");
                }
                else if (attachment.Length > MaxAttachmentSizeBytes)
                {
                    ModelState.AddModelError(nameof(Attachments),
                        $"Bijlage '{fileName}' is groter dan 5 MB.");
                }

                if (!AllowedAttachmentTypes.ContainsKey(extension))
                {
                    ModelState.AddModelError(nameof(Attachments),
                        "Gebruik voor bijlagen PDF, DOCX, XLSX, TXT, JPG, JPEG, PNG of WEBP.");
                }
            }

            if (!ModelState.IsValid)
            {
                return Page();
            }

            var organiserIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(organiserIdClaim, out var organiserId))
            {
                return Unauthorized();
            }

            // Use wwwroot/uploads for uploaded images - works on any machine
            var uploadsRoot = Path.Combine(_environment.WebRootPath, "uploads");

            var cacheRoot = Path.Combine(
                uploadsRoot,
                "events",
                organiserId.ToString(),
                "cache");

            Directory.CreateDirectory(cacheRoot);

            var cachedFiles = new List<(string TempPath, string FileName)>();

            try
            {
                Input.AttachmentsToSave.Clear();

                foreach (var attachment in Attachments)
                {
                    var fileName = Path.GetFileName(attachment.FileName.Replace('\\', '/'));
                    var extension = Path.GetExtension(fileName).ToLowerInvariant();

                    using var stream = new MemoryStream();
                    await attachment.CopyToAsync(stream);

                    Input.AttachmentsToSave.Add(new EventAttachmentInputModel
                    {
                        FileName = fileName,
                        ContentType = AllowedAttachmentTypes[extension],
                        FileContent = stream.ToArray()
                    });
                }
                for (var i = 0; i < Images.Count; i++)
                {
                    var image = Images[i];

                    if (image.Length <= 0)
                    {
                        ModelState.AddModelError(string.Empty, $"Afbeelding {i + 1} is leeg.");
                        return Page();
                    }

                    if (image.Length > MaxImageSizeBytes)
                    {
                        ModelState.AddModelError(string.Empty, $"Afbeelding {i + 1} is groter dan 5 MB.");
                        return Page();
                    }

                    var extension = Path.GetExtension(image.FileName).ToLowerInvariant();
                    if (!AllowedImageExtensions.Contains(extension))
                    {
                        ModelState.AddModelError(string.Empty, $"Afbeelding {i + 1} moet jpg, jpeg, png of webp zijn.");
                        return Page();
                    }

                    var fileName = $"{Guid.NewGuid():N}{extension}";
                    var tempPath = Path.Combine(cacheRoot, fileName);

                    await using (var stream = System.IO.File.Create(tempPath))
                    {
                        await image.CopyToAsync(stream);
                    }

                    cachedFiles.Add((tempPath, fileName));
                }

                var eventId = await _organiserRepository.GetNextEventIdAsync();
                await _organiserRepository.CreateEventAsync(organiserId, eventId, Input);

                var finalRoot = Path.Combine(
                    uploadsRoot,
                    "events",
                    organiserId.ToString(),
                    eventId.ToString(),
                    "uploads");

                Directory.CreateDirectory(finalRoot);

                var finalImageUrls = new List<string>();

                foreach (var cachedFile in cachedFiles)
                {
                    var finalPath = Path.Combine(finalRoot, cachedFile.FileName);

                    if (System.IO.File.Exists(finalPath))
                    {
                        System.IO.File.Delete(finalPath);
                    }

                    System.IO.File.Move(cachedFile.TempPath, finalPath);

                    finalImageUrls.Add($"/uploads/events/{organiserId}/{eventId}/uploads/{cachedFile.FileName}");
                }

                await _organiserRepository.AddEventImagesAsync(eventId, finalImageUrls);

                _logger.LogInformation(
                    "Evenement {EventId} is succesvol aangemaakt.",
                    eventId);

                return RedirectToPage("/Portal/Dashboard");
            }
            catch (Exception ex)
            {
                foreach (var cachedFile in cachedFiles)
                {
                    if (System.IO.File.Exists(cachedFile.TempPath))
                    {
                        System.IO.File.Delete(cachedFile.TempPath);
                    }
                }

                ModelState.AddModelError(string.Empty, $"Het evenement kon niet opgeslagen worden. {ex.Message}");
                return Page();
            }
        }
    }
}