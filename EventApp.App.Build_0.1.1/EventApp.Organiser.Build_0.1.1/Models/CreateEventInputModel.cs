using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace EventApp.OrganiserPortal.Models
{
    public enum evenStatus 
    {
        Draft,
        Soldout,
        Postponed,
        TicketSaleStarted,
        TicketSaleEnded,
        EventStarted,
        EventEnded
    }
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
        [Required, Display(Name = "Straat")]
        public string Street { get; set; } = "";

        [Required(ErrorMessage = "Huisnummer is verplicht")]
        [Display(Name = "Huisnummer")]
        [Range(1, int.MaxValue, ErrorMessage = "Voer een geldig huisnummer in")]
        public int? HouseNumber { get; set; }

        [Display(Name = "Toevoeging")]
        public string? HouseNumberAddition { get; set; }

        [Required, Display(Name = "Postcode")]
        [RegularExpression(@"^[1-9][0-9]{3}\s?[A-Za-z]{2}$", ErrorMessage = "Ongeldige postcode")]
        public string PostalCode { get; set; } = "";

        [Required, Display(Name = "Plaats")]
        public string City { get; set; } = "";

        [Required(ErrorMessage = "Startdatum is verplicht.")]
        [Display(Name = "Startdatum")]
        public DateTime? StartDate { get; set; }

        [Required(ErrorMessage = "Starttijd is verplicht.")]
        [Display(Name = "Starttijd")]
        public TimeSpan? StartTime { get; set; }

        [Required(ErrorMessage = "Einddatum is verplicht.")]
        [Display(Name = "Einddatum")]
        public DateTime? EndDate { get; set; }

        [Required(ErrorMessage = "Eindtijd is verplicht.")]
        [Display(Name = "Eindtijd")]
        public TimeSpan? EndTime { get; set; }

        [Required(ErrorMessage = "Geef aan of het geschikt is voor kinderen")]
        [Display(Name = "Geschikt voor kinderen")]
        public bool? ChildrenFriendly { get; set; }

        // enum voor eventstatus
        public evenStatus EventStatus { get; set; } 
    }
}