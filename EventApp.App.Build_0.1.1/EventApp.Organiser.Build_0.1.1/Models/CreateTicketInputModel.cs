using System.ComponentModel.DataAnnotations;

namespace EventApp.OrganiserPortal.Models
{
    public class CreateTicketInputModel
    {
        [Required(ErrorMessage = "Vul een ticketnaam in of kies een suggestie.")]
        [StringLength(100, ErrorMessage = "Gebruik maximaal 100 tekens voor de ticketnaam.")]
        public string TicketType { get; set; } = string.Empty;

        [Range(typeof(decimal), "0", "999999")]
        public decimal Price { get; set; }

        [Display(Name = "Aantal beschikbaar")]
        [Required(ErrorMessage = "Vul het aantal beschikbare tickets in.")]
        [Range(1, int.MaxValue, ErrorMessage = "Vul een heel aantal van minimaal 1 in.")]
        public int? Quantity { get; set; }
    }
}