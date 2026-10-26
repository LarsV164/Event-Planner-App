using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace EventApp.OrganiserPortal.Models
{
    public class CreateEventInputModel
    {
        [Required(ErrorMessage = "Naam van het evenement is verplicht.")]
        public string EventName { get; set; } = string.Empty;

        [RegularExpression("Binnen|Buiten|Beide", ErrorMessage = "Kies Binnen, Buiten of Beide.")]
        public string? IndoorsOutdoors { get; set; }

        [Required(ErrorMessage = "Beschrijving is verplicht.")]
        public string Description { get; set; } = string.Empty;

        public string? Address { get; set; }

        public decimal? Latitude { get; set; }

        public decimal? Longitude { get; set; }

        public bool? HasStandingPlaces { get; set; }

        public bool? HasSittingPlaces { get; set; }

        [Required(ErrorMessage = "Geef aan of er invalidenparkeerplaatsen zijn.")]
        public bool? DisabledParkingAvailable { get; set; }

        [Required(ErrorMessage = "Geef aan of er een invalidentoilet is.")]
        public bool? DisabledToiletAvailable { get; set; }

        [Required(ErrorMessage = "Geef aan of het toilet rolstoeltoegankelijk is.")]
        public bool? WheelchairAccessibleToilet { get; set; }

        public List<CreateTicketInputModel> Tickets { get; set; } = new();
        public List<string> Categories { get; set; } = new();
        public List<string> AccessibilityOptions { get; set; } = new();
        public List<ImageCropPositionInputModel> ImageCropPositions { get; set; } = new();

        //NIEUWE DINGEN TOEGEVOED
        [Display(Name = "Straat*")]
        [Required(ErrorMessage = "Straatnaam is verplicht.")]
        public string Street { get; set; } = "";

        [Required(ErrorMessage = "Huisnummer is verplicht.")]
        [Display(Name = "Huisnummer*")]
        [Range(1, int.MaxValue, ErrorMessage = "Huisnummer is verplicht")]
        public int? HouseNumber { get; set; }

        [Display(Name = "Toevoeging")]
        public string? HouseNumberAddition { get; set; }

        [Display(Name = "Postcode*")]
        [Required(ErrorMessage = "Postcode is verplicht.")]
        [RegularExpression(@"^[1-9][0-9]{3}\s?[A-Za-z]{2}$", ErrorMessage = "Ongeldige postcode")]
        public string PostalCode { get; set; } = "";

        [Display(Name = "Plaats*")]
        [Required(ErrorMessage = "Plaats is verplicht.")]
        public string City { get; set; } = "";

        [Display(Name = "Startdatum*")]
        [Required(ErrorMessage = "Startdatum is verplicht.")]
        public DateTime? StartDate { get; set; }

        [Display(Name = "Starttijd*")]
        [Required(ErrorMessage = "Starttijd is verplicht.")]
        public TimeSpan? StartTime { get; set; }

        [Display(Name = "Einddatum*")]
        [Required(ErrorMessage = "Einddatum is verplicht.")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "Eindtijd*")]
        [Required(ErrorMessage = "Eindtijd is verplicht.")]
        public TimeSpan? EndTime { get; set; }

        [Display(Name = "Geschikt voor kinderen*")]
        [Required(ErrorMessage = "Geef aan of het geschikt is voor kinderen")]
        public bool? ChildrenFriendly { get; set; }

        [Display(Name = "Telefoonnummer")]
        [Phone(ErrorMessage = "Vul een geldig telefoonnummer in.")]
        [StringLength(30, ErrorMessage = "Gebruik maximaal 30 tekens voor het telefoonnummer.")]
        public string? ContactPhone { get; set; }

        [Display(Name = "E-mailadres")]
        [EmailAddress(ErrorMessage = "Vul een geldig e-mailadres in.")]
        [StringLength(254, ErrorMessage = "Gebruik maximaal 254 tekens voor het e-mailadres.")]
        public string? ContactEmail { get; set; }

        [Display(Name = "Website")]
        [Url(ErrorMessage = "Vul een geldig websiteadres in, bijvoorbeeld https://www.voorbeeld.nl.")]
        [StringLength(2048, ErrorMessage = "Het websiteadres is te lang.")]
        public string? WebsiteUrl { get; set; }
    }
}