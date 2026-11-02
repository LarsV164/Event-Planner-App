namespace EventApp.OrganiserPortal.Models
{
    public class EventAttachmentInputModel
    {
        public string FileName { get; set; } = string.Empty;
        public string ContentType { get; set; } = string.Empty;
        public byte[] FileContent { get; set; } = Array.Empty<byte>();
    }
}
