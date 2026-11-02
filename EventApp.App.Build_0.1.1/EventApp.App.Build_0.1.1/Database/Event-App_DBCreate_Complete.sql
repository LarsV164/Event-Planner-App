/*
EventApp - volledig aanmaakscript inclusief Extra's

EERSTE INSTALLATIE IN SQL SERVER MANAGEMENT STUDIO (SSMS)
1. Verbind met de SQL Server die de app gebruikt, bijvoorbeeld
   (localdb)\mssqllocaldb.
2. Maak via Databases > New Database een LEGE database aan, bijvoorbeeld
   db-eventapp. Dit script maakt de tabellen aan, niet de database zelf.
3. Open dit bestand en selecteer die lege database in de database-dropdown
   boven het queryvenster. Gebruik geen systeemdatabase zoals master.
4. Voer het hele script eenmalig uit met F5 / Execute.
5. Controleer Messages op fouten. Laat de connection string van de app naar
   dezelfde server en database verwijzen (ook in appsettings.Development.json).

Dit is een aanmaakscript voor een lege database, geen update voor een
bestaande installatie. Onderaan staat een volledige, fictieve seedset met
demo-accounts, organisatoren, locaties, evenementen, tickets, categorieen en
sociale posts. Zie het SEEDDATA-blok voor de inloggegevens en het verwijderen
van de demodata.

Extra's:
- events.contact_phone, contact_email en website_url zijn optioneel (NULL).
- event_attachments bevat meerdere bijlagen per evenement, inclusief de
  bestandsinhoud (varbinary(max)). uploaded_at wordt automatisch in UTC gezet.
*/


CREATE TABLE [dbo].[account_bookmarks](
	[account_id] [int] NOT NULL,
	[event_id] [int] NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[account_id] ASC,
	[event_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[account_external_logins](
	[external_login_id] [int] IDENTITY(1,1) NOT NULL,
	[account_id] [int] NOT NULL,
	[provider] [varchar](50) NOT NULL,
	[provider_user_id] [varchar](255) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[external_login_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[account_follows]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[account_follows](
	[follower_account_id] [int] NOT NULL,
	[following_account_id] [int] NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[follower_account_id] ASC,
	[following_account_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[account_post_images]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[account_post_images](
	[post_image_id] [int] IDENTITY(1,1) NOT NULL,
	[post_id] [int] NOT NULL,
	[image_url] [nvarchar](1000) NOT NULL,
	[display_order] [int] NOT NULL,
	[created_at] [datetime2](0) NOT NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_account_post_images] PRIMARY KEY CLUSTERED 
(
	[post_image_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[account_post_likes]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[account_post_likes](
	[account_post_like_id] [int] IDENTITY(1,1) NOT NULL,
	[post_id] [int] NOT NULL,
	[account_id] [int] NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[account_post_like_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[account_posts]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[account_posts](
	[post_id] [int] IDENTITY(1,1) NOT NULL,
	[account_id] [int] NOT NULL,
	[caption] [nvarchar](2000) NULL,
	[created_at] [datetime2](0) NOT NULL,
	[updated_at] [datetime2](0) NULL,
	[is_deleted] [bit] NOT NULL,
 CONSTRAINT [PK_account_posts] PRIMARY KEY CLUSTERED 
(
	[post_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[accounts]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[accounts](
	[account_id] [int] IDENTITY(1,1) NOT NULL,
	[nickname] [varchar](50) NOT NULL,
	[first_name] [varchar](100) NULL,
	[last_name] [varchar](100) NULL,
	[email] [varchar](255) NOT NULL,
	[password_hash] [varchar](255) NULL,
	[phone_number] [varchar](30) NULL,
	[date_of_birth] [date] NULL,
	[bio] [varchar](500) NULL,
	[profile_picture_url] [varchar](2048) NULL,
	[karma] [int] NOT NULL,
	[events_reviewed_count] [int] NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
	[updated_at] [datetime2](7) NOT NULL,
	[is_deleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[account_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[comment_likes]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[comment_likes](
	[comment_id] [int] NOT NULL,
	[account_id] [int] NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[comment_id] ASC,
	[account_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[event_accessibility_options]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[event_accessibility_options](
	[accessibility_option_id] [int] NOT NULL,
	[description] [varchar](255) NOT NULL,
	[event_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[accessibility_option_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[event_categories]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[event_categories](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_name] [varchar](100) NOT NULL,
	[icon_name] [varchar](100) NULL,
 CONSTRAINT [PK_categories] PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[event_dates]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[event_dates](
	[event_dates_id] [int] IDENTITY(1,1) NOT NULL,
	[start_date] [date] NOT NULL,
	[end_date] [date] NOT NULL,
	[start_time] [time] NULL,
	[end_time] [time] NULL,
	[event_id] [int] NOT NULL,
 CONSTRAINT [PK_event_dates] PRIMARY KEY CLUSTERED 
(
	[event_dates_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[event_event_categories]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[event_event_categories](
	[event_category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_id] [int] NOT NULL,
	[event_id] [int] NOT NULL,
 CONSTRAINT [PK__event_ca__5798ECFFC388D5A6] PRIMARY KEY CLUSTERED 
(
	[event_category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[event_images]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[event_images](
	[event_image_id] [int] NOT NULL,
	[event_id] [int] NOT NULL,
	[image_url] [varchar](2048) NOT NULL,
	[alt_text] [varchar](255) NULL,
	[is_primary] [bit] NOT NULL,
	[sort_order] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[event_image_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[event_ticket_prices]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[event_ticket_prices](
	[event_ticket_price_id] [int] NOT NULL,
	[ticket_type] [varchar](100) NOT NULL,
	[price] [decimal](10, 2) NULL,
	[event_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[event_ticket_price_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[events]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[events](
	[event_id] [int] NOT NULL,
	[event_name] [varchar](255) NOT NULL,
	[indoors_outdoors] [int] NULL,
	[has_standing_places] [bit] NULL,
	[has_sitting_places] [bit] NULL,
	[disabled_parking_available] [bit] NULL,
	[disabled_toilet_available] [bit] NULL,
	[wheelchair_accessible_toilet] [bit] NULL,
	[category_ids] [nvarchar](max) NULL,
	[location_id] [int] NOT NULL,
	[description] [nvarchar](max) NULL,
	[organiser_id] [int] NULL,
	[children_friendly] [bit] NULL,
	[canceled] [bit] NOT NULL,
	-- Optionele contactgegevens en website bij het evenement.
	[contact_phone] [nvarchar](30) NULL,
	[contact_email] [nvarchar](254) NULL,
	[website_url] [nvarchar](2048) NULL,


 CONSTRAINT [PK__events__2370F727284E5A79] PRIMARY KEY CLUSTERED 
(
	[event_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object: Table [dbo].[event_attachments] - optionele bijlagen ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[event_attachments](
	[attachment_id] [int] IDENTITY(1,1) NOT NULL,
	[event_id] [int] NOT NULL,
	[file_name] [nvarchar](255) NOT NULL,
	[content_type] [nvarchar](255) NOT NULL,
	[file_content] [varbinary](max) NOT NULL,
	[uploaded_at] [datetime2](7) NOT NULL
		CONSTRAINT [DF_event_attachments_uploaded_at] DEFAULT (SYSUTCDATETIME()),
	CONSTRAINT [PK_event_attachments] PRIMARY KEY CLUSTERED ([attachment_id]),
	CONSTRAINT [FK_event_attachments_events] FOREIGN KEY ([event_id])
		REFERENCES [dbo].[events] ([event_id])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_event_attachments_event_id]
	ON [dbo].[event_attachments] ([event_id]);
GO
/****** Object:  Table [dbo].[locations]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[locations](
	[location_id] [int] NOT NULL,
	[latitude] [decimal](9, 6) NULL,
	[longitude] [decimal](9, 6) NULL,
	[street] [nvarchar](255) NULL,
	[house_number] [int] NULL,
	[house_number_addition] [nvarchar](50) NULL,
	[postal_code] [nvarchar](10) NULL,
	[city] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[organiser_accounts]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[organiser_accounts](
	[organiser_account_id] [int] IDENTITY(1,1) NOT NULL,
	[contact_name] [nvarchar](200) NULL,
	[email] [nvarchar](255) NOT NULL,
	[password_hash] [nvarchar](500) NOT NULL,
	[is_active] [bit] NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
	[organiser_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[organiser_account_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[organisers]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[organisers](
	[organiser_id] [int] NOT NULL,
	[company_name] [nvarchar](255) NOT NULL,
	[is_active] [bit] NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[organiser_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[post_comments]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[post_comments](
	[comment_id] [int] IDENTITY(1,1) NOT NULL,
	[post_id] [int] NOT NULL,
	[account_id] [int] NOT NULL,
	[parent_comment_id] [int] NULL,
	[comment_text] [varchar](1000) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[post_images]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[post_images](
	[post_image_id] [int] IDENTITY(1,1) NOT NULL,
	[post_id] [int] NOT NULL,
	[image_url] [varchar](2048) NOT NULL,
	[sort_order] [int] NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[post_image_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[post_likes]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[post_likes](
	[post_id] [int] NOT NULL,
	[account_id] [int] NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[post_id] ASC,
	[account_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[post_tags]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[post_tags](
	[post_id] [int] NOT NULL,
	[tagged_account_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[post_id] ASC,
	[tagged_account_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[posts]    Script Date: 15/04/2026 14:10:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[posts](
	[post_id] [int] IDENTITY(1,1) NOT NULL,
	[creator_account_id] [int] NOT NULL,
	[event_id] [int] NULL,
	[description] [varchar](1000) NULL,
	[created_at] [datetime2](7) NOT NULL,
	[updated_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[post_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/* ============================================================================
   SEEDDATA
   ----------------------------------------------------------------------------
   Alle onderstaande gegevens zijn fictieve demodata. De datums liggen in de
   toekomst (peildatum: 2 november 2026), zodat de app direct bruikbare
   evenementen toont. De data is consistent opgebouwd:
   - 12 demo-accounts en 6 organisatoren;
   - 13 locaties met volledige adressen en coordinaten;
   - 22 categorieen;
   - 17 evenementen met datums, afbeeldingen, tickets en toegankelijkheid;
   - bookmarks, follows, posts, reacties en likes voor de sociale onderdelen.

   DEMO-INLOGGEGEGEVENS
   Organisatorportaal: test@example.com / TestAccount
   Alle demo-accounts en organisatoraccounts gebruiken het wachtwoord
   "TestAccount". Vervang deze gegevens voordat de app in productie gaat.

   Wilt u zonder demodata starten? Verwijder dan dit volledige blok vanaf
   "SEEDDATA" tot en met de laatste INSERT en het bijbehorende GO-statement.
   ============================================================================ */

/* ----------------------------------------------------------------------------
   1. Accounts
   ---------------------------------------------------------------------------- */
DECLARE @DemoPasswordHash varchar(255) =
    N'AQAAAAIAAYagAAAAEJhGdcZ7YhsM2SQZIBDuz49D3midKLKSIv5aUdUrG/Bk/HZWIwdvTsCMkpE+j3bgtg==';

SET IDENTITY_INSERT [dbo].[accounts] ON;

INSERT [dbo].[accounts]
    ([account_id], [nickname], [first_name], [last_name], [email], [password_hash],
     [phone_number], [date_of_birth], [bio], [profile_picture_url], [karma],
     [events_reviewed_count], [created_at], [updated_at], [is_deleted])
VALUES
    (1, N'sanne_c', N'Sanne', N'de Vries', N'sanne.devries@example.com', @DemoPasswordHash,
     N'0612345678', CAST(N'1998-04-12' AS date), N'Liefhebber van popconcerten en festivals.',
     N'/images/icons/img_profileplaceholder.png', 124, 18,
     CAST(N'2025-01-15T10:00:00' AS datetime2), CAST(N'2026-10-28T18:30:00' AS datetime2), 0),
    (2, N'maxfestival', N'Max', N'Jansen', N'max.jansen@example.com', @DemoPasswordHash,
     N'0623456789', CAST(N'1995-09-23' AS date), N'Festivalganger en amateurfotograaf.',
     N'/images/icons/img_profileplaceholder.png', 210, 34,
     CAST(N'2025-02-20T11:15:00' AS datetime2), CAST(N'2026-10-29T09:15:00' AS datetime2), 0),
    (3, N'lottekunst', N'Lotte', N'Bakker', N'lotte.bakker@example.com', @DemoPasswordHash,
     N'0634567890', CAST(N'2000-01-30' AS date), N'Museumliefhebber en kunststudent.',
     N'/images/icons/img_profileplaceholder.png', 87, 11,
     CAST(N'2025-03-10T09:30:00' AS datetime2), CAST(N'2026-10-30T14:45:00' AS datetime2), 0),
    (4, N'daan_dnb', N'Daan', N'Visser', N'daan.visser@example.com', @DemoPasswordHash,
     N'0645678901', CAST(N'1993-07-08' AS date), N'Drum & bass, techno en alles wat daartussen zit.',
     N'/images/icons/img_profileplaceholder.png', 305, 52,
     CAST(N'2025-04-05T19:00:00' AS datetime2), CAST(N'2026-10-31T02:10:00' AS datetime2), 0),
    (5, N'emmafood', N'Emma', N'Smit', N'emma.smit@example.com', @DemoPasswordHash,
     N'0656789012', CAST(N'1997-11-17' AS date), N'Foodfestivals en lokale markten.',
     N'/images/icons/img_profileplaceholder.png', 64, 9,
     CAST(N'2025-05-12T12:00:00' AS datetime2), CAST(N'2026-11-01T12:00:00' AS datetime2), 0),
    (6, N'noah_theater', N'Noah', N'Meijer', N'noah.meijer@example.com', @DemoPasswordHash,
     N'0667890123', CAST(N'1991-03-05' AS date), N'Theater, cabaret en film.',
     N'/images/icons/img_profileplaceholder.png', 156, 27,
     CAST(N'2025-06-18T15:45:00' AS datetime2), CAST(N'2026-11-01T16:20:00' AS datetime2), 0),
    (7, N'julia_family', N'Julia', N'Mulder', N'julia.mulder@example.com', @DemoPasswordHash,
     N'0678901234', CAST(N'1988-06-21' AS date), N'Op stap met het hele gezin.',
     N'/images/icons/img_profileplaceholder.png', 42, 6,
     CAST(N'2025-07-22T08:20:00' AS datetime2), CAST(N'2026-11-02T08:05:00' AS datetime2), 0),
    (8, N'bram_rock', N'Bram', N'de Boer', N'bram.deboer@example.com', @DemoPasswordHash,
     N'0689012345', CAST(N'1994-12-02' AS date), N'Rock, metal en livemuziek.',
     N'/images/icons/img_profileplaceholder.png', 98, 15,
     CAST(N'2025-08-30T20:10:00' AS datetime2), CAST(N'2026-11-02T09:40:00' AS datetime2), 0),
    (9, N'nina_classic', N'Nina', N'Bos', N'nina.bos@example.com', @DemoPasswordHash,
     N'0690123456', CAST(N'1985-08-14' AS date), N'Klassieke muziek en opera.',
     N'/images/icons/img_profileplaceholder.png', 73, 12,
     CAST(N'2025-09-14T14:30:00' AS datetime2), CAST(N'2026-10-20T10:00:00' AS datetime2), 0),
    (10, N'tim_museum', N'Tim', N'Hofman', N'tim.hofman@example.com', @DemoPasswordHash,
     N'0611223344', CAST(N'1990-05-27' AS date), N'Geschiedenis en musea.',
     N'/images/icons/img_profileplaceholder.png', 51, 8,
     CAST(N'2025-10-01T11:00:00' AS datetime2), CAST(N'2026-10-29T11:15:00' AS datetime2), 0),
    (11, N'lisa_dance', N'Lisa', N'van Dijk', N'lisa.vandijk@example.com', @DemoPasswordHash,
     N'0622334455', CAST(N'1999-02-09' AS date), N'Dansen en uitgaan.',
     N'/images/icons/img_profileplaceholder.png', 188, 31,
     CAST(N'2025-11-11T21:00:00' AS datetime2), CAST(N'2026-10-30T19:00:00' AS datetime2), 0),
    (12, N'sem_local', N'Sem', N'Peters', N'sem.peters@example.com', @DemoPasswordHash,
     N'0633445566', CAST(N'1996-10-03' AS date), N'Lokaal nieuws en evenementen.',
     N'/images/icons/img_profileplaceholder.png', 27, 4,
     CAST(N'2025-12-05T16:00:00' AS datetime2), CAST(N'2026-11-02T09:40:00' AS datetime2), 0);

SET IDENTITY_INSERT [dbo].[accounts] OFF;
GO

/* ----------------------------------------------------------------------------
   2. Externe logins
   ---------------------------------------------------------------------------- */
INSERT [dbo].[account_external_logins]
    ([account_id], [provider], [provider_user_id], [created_at])
VALUES
    (1, N'Google', N'google-demo-1001', CAST(N'2025-01-16T09:00:00' AS datetime2)),
    (4, N'Spotify', N'spotify-demo-1004', CAST(N'2025-04-06T10:00:00' AS datetime2));
GO

/* ----------------------------------------------------------------------------
   3. Organisaties en organisatoraccounts
   ---------------------------------------------------------------------------- */
INSERT [dbo].[organisers]
    ([organiser_id], [company_name], [is_active], [created_at])
VALUES
    (1, N'Strange Minds Division', 1, CAST(N'2025-01-10T09:00:00' AS datetime2)),
    (2, N'Maastricht Live', 1, CAST(N'2025-02-11T09:00:00' AS datetime2)),
    (3, N'Parkstad Events', 1, CAST(N'2025-03-12T09:00:00' AS datetime2)),
    (4, N'Randstad Concerts', 1, CAST(N'2025-04-13T09:00:00' AS datetime2)),
    (5, N'Brabant Cultureel', 1, CAST(N'2025-05-14T09:00:00' AS datetime2)),
    (6, N'Noordelijk Podium', 1, CAST(N'2025-06-15T09:00:00' AS datetime2));
GO

DECLARE @DemoOrganiserPasswordHash varchar(500) =
    N'AQAAAAIAAYagAAAAEJhGdcZ7YhsM2SQZIBDuz49D3midKLKSIv5aUdUrG/Bk/HZWIwdvTsCMkpE+j3bgtg==';

SET IDENTITY_INSERT [dbo].[organiser_accounts] ON;

INSERT [dbo].[organiser_accounts]
    ([organiser_account_id], [contact_name], [email], [password_hash], [is_active],
     [created_at], [organiser_id])
VALUES
    (1, N'Test Account', N'test@example.com', @DemoOrganiserPasswordHash, 1,
     CAST(N'2025-01-10T09:15:00' AS datetime2), 1),
    (2, N'Sophie Hermans', N'maastricht@example.com', @DemoOrganiserPasswordHash, 1,
     CAST(N'2025-02-11T09:15:00' AS datetime2), 2),
    (3, N'Ruud Willems', N'parkstad@example.com', @DemoOrganiserPasswordHash, 1,
     CAST(N'2025-03-12T09:15:00' AS datetime2), 3),
    (4, N'Fleur de Groot', N'randstad@example.com', @DemoOrganiserPasswordHash, 1,
     CAST(N'2025-04-13T09:15:00' AS datetime2), 4),
    (5, N'Koen van Loon', N'brabant@example.com', @DemoOrganiserPasswordHash, 1,
     CAST(N'2025-05-14T09:15:00' AS datetime2), 5),
    (6, N'Marit Dijkstra', N'noord@example.com', @DemoOrganiserPasswordHash, 1,
     CAST(N'2025-06-15T09:15:00' AS datetime2), 6);

SET IDENTITY_INSERT [dbo].[organiser_accounts] OFF;
GO

/* ----------------------------------------------------------------------------
   4. Locaties
   ---------------------------------------------------------------------------- */
INSERT [dbo].[locations]
    ([location_id], [latitude], [longitude], [street], [house_number],
     [house_number_addition], [postal_code], [city])
VALUES
    (1, CAST(50.887700 AS decimal(9,6)), CAST(5.973500 AS decimal(9,6)),
     N'Hofstraat', 1, NULL, N'6372 XH', N'Landgraaf'),
    (2, CAST(52.398600 AS decimal(9,6)), CAST(4.850600 AS decimal(9,6)),
     N'Rhoneweg', 6, NULL, N'1043 AH', N'Amsterdam'),
    (3, CAST(50.842500 AS decimal(9,6)), CAST(5.702200 AS decimal(9,6)),
     N'Avenue Ceramique', 250, NULL, N'6221 KX', N'Maastricht'),
    (4, CAST(52.356100 AS decimal(9,6)), CAST(4.880700 AS decimal(9,6)),
     N'Concertgebouwplein', 10, NULL, N'1071 LN', N'Amsterdam'),
    (5, CAST(52.265800 AS decimal(9,6)), CAST(6.793100 AS decimal(9,6)),
     N'Buitenhof', 1, NULL, N'7551 EZ', N'Hengelo'),
    (6, CAST(50.888700 AS decimal(9,6)), CAST(5.978500 AS decimal(9,6)),
     N'Burgemeester van Grunsvenplein', 2, NULL, N'6411 AS', N'Heerlen'),
    (7, CAST(50.889500 AS decimal(9,6)), CAST(5.979900 AS decimal(9,6)),
     N'Bongerd', 1, NULL, N'6411 JM', N'Heerlen'),
    (8, CAST(50.834300 AS decimal(9,6)), CAST(5.895000 AS decimal(9,6)),
     N'Kasteel Wijlreweg', 1, NULL, N'6321 PK', N'Wijlre'),
    (9, CAST(51.588600 AS decimal(9,6)), CAST(4.779700 AS decimal(9,6)),
     N'Claudius Prinsenlaan', 10, NULL, N'4811 DJ', N'Breda'),
    (10, CAST(53.198600 AS decimal(9,6)), CAST(6.563100 AS decimal(9,6)),
     N'Leonard Springerlaan', 2, NULL, N'9727 KB', N'Groningen'),
    (11, CAST(51.902500 AS decimal(9,6)), CAST(4.486900 AS decimal(9,6)),
     N'Maashaven Zuidzijde', 1, NULL, N'3081 AE', N'Rotterdam'),
    (12, CAST(50.865600 AS decimal(9,6)), CAST(5.831000 AS decimal(9,6)),
     N'Grotestraat', 3, NULL, N'6301 CV', N'Valkenburg'),
    (13, CAST(50.814500 AS decimal(9,6)), CAST(5.890500 AS decimal(9,6)),
     N'Kerkstraat', 1, NULL, N'6271 BL', N'Gulpen');
GO

/* ----------------------------------------------------------------------------
   5. Categorieen
   ---------------------------------------------------------------------------- */
SET IDENTITY_INSERT [dbo].[event_categories] ON;

INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (1, N'Pop', N'music_note');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (2, N'Festival', N'celebration');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (3, N'Kunst', N'palette');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (4, N'Historie', N'history_edu');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (5, N'Rock', N'headphones');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (6, N'Dance', N'nightlife');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (7, N'House', N'speaker');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (8, N'Techno', N'graphic_eq');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (9, N'EDM', N'equalizer');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (10, N'Trance', N'waves');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (11, N'Drum & Bass', N'album');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (12, N'Hardstyle', N'bolt');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (13, N'Theater', N'theater_comedy');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (14, N'Film', N'movie');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (15, N'Museum', N'museum');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (16, N'Food', N'restaurant');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (17, N'Markt', N'storefront');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (18, N'Familie', N'family_restroom');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (19, N'Klassiek', N'piano');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (20, N'Cabaret', N'mic');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (21, N'Sport', N'sports_soccer');
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (22, N'Natuur', N'park');

SET IDENTITY_INSERT [dbo].[event_categories] OFF;
GO

/* ----------------------------------------------------------------------------
   6. Evenementen
   ---------------------------------------------------------------------------- */
INSERT [dbo].[events]
    ([event_id], [event_name], [indoors_outdoors], [has_standing_places],
     [has_sitting_places], [disabled_parking_available], [disabled_toilet_available],
     [wheelchair_accessible_toilet], [category_ids], [location_id], [description],
     [organiser_id], [children_friendly], [canceled], [contact_phone],
     [contact_email], [website_url])
VALUES
    (1, N'Winterlicht Festival 2026', 2, 1, 1, 1, 1, 1, NULL, 1,
     N'Winterlicht Festival is het sfeervolle startsein van de feestdagen in Parkstad. Drie dagen lang komen muziek, lichtkunst en winterkost samen op het terrein van Megaland. Bezoekers kunnen genieten van optredens op twee podia, een overdekte foodhal en een markt met lokale makers. Kinderen hebben hun eigen programma met verhalen, knutselen en een kleine kermis. Het festival is goed bereikbaar met de trein; er rijdt een gratis shuttle vanaf station Landgraaf.',
     1, 1, 0, N'045 123 45 67', N'info@winterlicht.example.com',
     N'https://www.winterlicht.example.com'),
    (2, N'Kerstmarkt Valkenburg', 3, 1, 0, 1, 1, 1, NULL, 12,
     N'De kerstmarkt in Valkenburg is een van de bekendste van Nederland. In de grotten en op de pleinen vindt u kraampjes met cadeaus, winterkleding en streekproducten. Proef warme chocolademelk, wafels en gluhwein terwijl straatmuzikanten voor sfeer zorgen. De markt is dagelijks geopend en ook goed te bezoeken met kinderen.',
     2, 1, 0, N'043 601 23 45', N'info@kerstmarktvalkenburg.example.com',
     N'https://www.kerstmarktvalkenburg.example.com'),
    (3, N'Club Nacht: Neon Edition', 1, 1, 0, 0, 1, 1, NULL, 2,
     N'Club Nacht: Neon Edition is een nacht vol house, techno en EDM. Verwacht een indrukwekkende lichtshow, vier internationale dj''s en een dansvloer die tot in de vroege ochtend gevuld blijft. De zaal is ingericht met zitplekken op het balkon en voldoende garderobe. Leeftijd: 18 jaar en ouder.',
     4, 0, 0, N'020 123 45 67', N'tickets@clubnacht.example.com',
     N'https://www.clubnacht.example.com'),
    (4, N'Museum Nacht Maastricht', 1, 1, 1, 0, 1, 1, NULL, 3,
     N'Tijdens Museum Nacht Maastricht openen musea hun deuren na zonsondergang. Ontdek de vaste collectie en tijdelijke tentoonstellingen met een gids, volg een korte lezing of geniet van live muziek in de foyer. Het programma is geschikt voor volwassenen en kinderen vanaf 8 jaar. Een combinatieticket geeft toegang tot alle deelnemende musea.',
     2, 1, 0, N'043 321 45 67', N'info@museumnachtmaastricht.example.com',
     N'https://www.museumnachtmaastricht.example.com'),
    (5, N'Voorjaarsconcert Philharmonie Zuid', 1, 0, 1, 1, 1, 1, NULL, 4,
     N'Het Philharmonie Zuid opent het voorjaar met een concert vol romantische klassiekers. Op het programma staan werken van Brahms en Dvorak, uitgevoerd door een voltallig symfonieorkest. Voorafgaand aan het concert is er een gratis inleiding in de foyer. Het Concertgebouw is rolstoeltoegankelijk en er zijn gereserveerde plaatsen voor slechtzienden.',
     4, 1, 0, N'020 456 78 90', N'tickets@philharmoniezuid.example.com',
     N'https://www.philharmoniezuid.example.com'),
    (6, N'Hardstyle Legends 2027', 2, 1, 0, 1, 1, 1, NULL, 5,
     N'Hardstyle Legends 2027 brengt de grootste namen uit de hardstyle scene samen op een openluchtterrein. Twee dagen lang zijn er meerdere podia, een foodcourt en een camping voor weekendbezoekers. Verwacht spectaculaire laser- en vuurshows. Het evenement is alleen toegankelijk voor bezoekers van 18 jaar en ouder.',
     1, 0, 0, N'074 123 45 67', N'info@hardstylelegends.example.com',
     N'https://www.hardstylelegends.example.com'),
    (7, N'Kinderfilm Festijn', 1, 0, 1, 1, 1, 1, NULL, 6,
     N'Kinderfilm Festijn is een driedaags filmfeest voor het hele gezin. Er draaien recente familiefilms, klassiekers en korte films van jonge makers. Tussen de voorstellingen door kunnen kinderen deelnemen aan workshops stop-motion en tekenen. Alle zalen zijn rolstoeltoegankelijk en er zijn prikkelarme voorstellingen.',
     3, 1, 0, N'045 567 89 01', N'info@kinderfilmfestijn.example.com',
     N'https://www.kinderfilmfestijn.example.com'),
    (8, N'Food Truck Festival Parkstad', 2, 1, 1, 1, 1, 1, NULL, 7,
     N'Food Truck Festival Parkstad verzamelt meer dan twintig foodtrucks op een groot terrein in Heerlen. Van streetfood en burgers tot vegan gerechten en zoetigheden: er is voor ieder wat wils. Live muziek en kinderanimatie maken er een compleet dagje uit van. De toegang is gratis; betalen doet u per gerecht bij de trucks.',
     3, 1, 0, N'045 678 90 12', N'info@foodtruckparkstad.example.com',
     N'https://www.foodtruckparkstad.example.com'),
    (9, N'Theater op Locatie: De Storm', 1, 0, 1, 0, 1, 1, NULL, 6,
     N'Theater op Locatie speelt De Storm, een indringende voorstelling over een familie die na een zware storm haar huis moet herstellen. De voorstelling combineert tekst, livemuziek en beeld. Na afloop is er een nagesprek met de cast. Let op: de voorstelling bevat flitsende beelden en is geschikt vanaf 12 jaar.',
     3, 0, 0, N'045 789 01 23', N'theater@parkstadtheater.example.com',
     N'https://www.parkstadtheater.example.com'),
    (10, N'Bassline: Drum & Bass Night', 1, 1, 0, 0, 1, 1, NULL, 2,
     N'Bassline is de maandelijkse drum & bass nacht van Lofi Amsterdam. Tijdens deze editie staan drie uur lang lokale en internationale dj''s achter de decks. De nadruk ligt op liquid, jungle en neurofunk. Er is een rookvrije dansvloer en voldoende zitgelegenheid buiten de danszaal.',
     4, 0, 0, N'020 234 56 78', N'info@bassline.example.com',
     N'https://www.bassline.example.com'),
    (11, N'Kunstroute Limburg', 2, 1, 1, 1, 0, 1, NULL, 8,
     N'Kunstroute Limburg voert langs ateliers, galeries en bijzondere buitenlocaties in en rond Wijlre. Ontmoet kunstenaars, bekijk nieuwe werken en doe mee aan korte workshops. De route is te voet en met de fiets te volgen; bij het startpunt is een gratis plattegrond verkrijgbaar. Kinderen kunnen onder begeleiding deelnemen.',
     2, 1, 0, N'043 345 67 89', N'info@kunstroutelimburg.example.com',
     N'https://www.kunstroutelimburg.example.com'),
    (12, N'Zomerpop Breda 2027', 2, 1, 1, 1, 1, 1, NULL, 9,
     N'Zomerpop Breda is het grootste zomerfestival van Brabant. Drie dagen lang staan pop, rock en singer-songwriter op het programma, met zowel bekende namen als lokaal talent. Er is een kinderplein, een foodmarkt en een lounge met schaduw. Het festival is goed bereikbaar met de trein vanaf station Breda.',
     5, 1, 0, N'076 456 78 90', N'info@zomerpopbreda.example.com',
     N'https://www.zomerpopbreda.example.com'),
    (13, N'Noorderlicht Winterfair', 1, 1, 1, 1, 1, 1, NULL, 10,
     N'Noorderlicht Winterfair is een overdekte wintermarkt in Martiniplaza Groningen. Zoek je een uniek cadeau, dan vind je het bij een van de tientallen kramen met ambachtelijke producten. Er zijn workshops, een winterterras en een speciaal kinderprogramma. De fair is rolstoeltoegankelijk en er is een prikkelarme ochtend op zaterdag.',
     6, 1, 0, N'050 567 89 01', N'info@noorderlichtfair.example.com',
     N'https://www.noorderlichtfair.example.com'),
    (14, N'Techno Warehouse', 1, 1, 0, 0, 1, 1, NULL, 11,
     N'Techno Warehouse is een after van formaat in de Maassilo Rotterdam. Drie zalen, zes dj''s en een geluidssysteem dat je tot in je botten voelt. De line-up richt zich op hypnotische techno en house. Het evenement is alleen toegankelijk voor bezoekers van 18 jaar en ouder. Er zijn lockers en een chill area.',
     4, 0, 0, N'010 678 90 12', N'info@technowarehouse.example.com',
     N'https://www.technowarehouse.example.com'),
    (15, N'Cabaret & Komedie Avond', 1, 0, 1, 1, 1, 1, NULL, 6,
     N'Cabaret & Komedie Avond biedt een avond vol nieuwe sketches, scherpe conferences en muzikale intermezzo''s. Drie cabaretiers proberen hun nieuwste materiaal uit in een intieme theaterzaal. Geschikt voor volwassenen; de voorstelling bevat satire en sterke taal. Na afloop is er een borrel in de foyer.',
     3, 0, 0, N'045 890 12 34', N'info@cabaretkomedie.example.com',
     N'https://www.cabaretkomedie.example.com'),
    (16, N'Parkstad City Run', 2, 1, 1, 1, 1, 1, NULL, 7,
     N'De Parkstad City Run is er voor iedereen: van beginnende hardlopers tot ervaren atleten. Kies uit 5 kilometer, 10 kilometer of de kids run van 1 kilometer. Het parcours loopt door het centrum van Heerlen en finisht op het Burgemeester van Grunsvenplein. Er zijn drinkposten, kleedkamers en een feestelijke finish.',
     3, 1, 0, N'045 901 23 45', N'sport@parkstadcityrun.example.com',
     N'https://www.parkstadcityrun.example.com'),
    (17, N'Natuurwandeling Mergelland', 2, 1, 1, 1, 0, 1, NULL, 13,
     N'Tijdens de natuurwandeling bij Schaapskooi Mergelland ontdekt u het Heuvelland op zijn mooist. Een gids vertelt over de schapen, het landschap en de geschiedenis van de streek. De route is ongeveer 5 kilometer en geschikt voor kinderen vanaf 6 jaar. Stevige schoenen zijn aan te raden; honden zijn niet toegestaan.',
     2, 1, 0, N'043 012 34 56', N'info@natuurwandeling.example.com',
     N'https://www.natuurwandeling.example.com');
GO

/* ----------------------------------------------------------------------------
   7. Evenementdatums
   ---------------------------------------------------------------------------- */
INSERT [dbo].[event_dates]
    ([start_date], [end_date], [start_time], [end_time], [event_id])
VALUES
    (CAST(N'2026-12-11' AS date), CAST(N'2026-12-13' AS date), CAST(N'16:00:00' AS time), CAST(N'23:30:00' AS time), 1),
    (CAST(N'2026-12-05' AS date), CAST(N'2027-01-03' AS date), CAST(N'11:00:00' AS time), CAST(N'20:00:00' AS time), 2),
    (CAST(N'2026-11-21' AS date), CAST(N'2026-11-21' AS date), CAST(N'22:00:00' AS time), CAST(N'05:00:00' AS time), 3),
    (CAST(N'2026-11-28' AS date), CAST(N'2026-11-28' AS date), CAST(N'19:00:00' AS time), CAST(N'01:00:00' AS time), 4),
    (CAST(N'2027-02-14' AS date), CAST(N'2027-02-14' AS date), CAST(N'20:00:00' AS time), CAST(N'22:30:00' AS time), 5),
    (CAST(N'2027-04-10' AS date), CAST(N'2027-04-11' AS date), CAST(N'12:00:00' AS time), CAST(N'23:59:00' AS time), 6),
    (CAST(N'2027-02-20' AS date), CAST(N'2027-02-22' AS date), CAST(N'10:00:00' AS time), CAST(N'17:00:00' AS time), 7),
    (CAST(N'2027-05-08' AS date), CAST(N'2027-05-10' AS date), CAST(N'12:00:00' AS time), CAST(N'22:00:00' AS time), 8),
    (CAST(N'2027-03-06' AS date), CAST(N'2027-03-07' AS date), CAST(N'20:15:00' AS time), CAST(N'22:00:00' AS time), 9),
    (CAST(N'2027-01-23' AS date), CAST(N'2027-01-23' AS date), CAST(N'23:00:00' AS time), CAST(N'05:00:00' AS time), 10),
    (CAST(N'2027-06-05' AS date), CAST(N'2027-06-06' AS date), CAST(N'11:00:00' AS time), CAST(N'17:00:00' AS time), 11),
    (CAST(N'2027-07-02' AS date), CAST(N'2027-07-04' AS date), CAST(N'14:00:00' AS time), CAST(N'23:00:00' AS time), 12),
    (CAST(N'2027-01-16' AS date), CAST(N'2027-01-17' AS date), CAST(N'10:00:00' AS time), CAST(N'18:00:00' AS time), 13),
    (CAST(N'2027-03-20' AS date), CAST(N'2027-03-20' AS date), CAST(N'22:00:00' AS time), CAST(N'06:00:00' AS time), 14),
    (CAST(N'2027-01-30' AS date), CAST(N'2027-01-30' AS date), CAST(N'20:00:00' AS time), CAST(N'22:15:00' AS time), 15),
    (CAST(N'2027-04-18' AS date), CAST(N'2027-04-18' AS date), CAST(N'09:30:00' AS time), CAST(N'13:00:00' AS time), 16),
    (CAST(N'2027-05-23' AS date), CAST(N'2027-05-23' AS date), CAST(N'10:00:00' AS time), CAST(N'13:00:00' AS time), 17);
GO

/* ----------------------------------------------------------------------------
   8. Evenementafbeeldingen
   ---------------------------------------------------------------------------- */
INSERT [dbo].[event_images]
    ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order])
VALUES
    (1, 1, N'/images/events/placeholder.jpg', N'Winterlicht Festival met verlichte podia', 1, 1),
    (2, 2, N'/images/events/placeholder.jpg', N'Kerstmarkt in Valkenburg', 1, 1),
    (3, 3, N'/uploads/events/amsterdam-dance-event.jpg', N'Club Nacht Neon Edition', 1, 1),
    (4, 4, N'/images/events/placeholder.jpg', N'Museum Nacht Maastricht', 1, 1),
    (5, 5, N'/images/events/placeholder.jpg', N'Voorjaarsconcert Philharmonie Zuid', 1, 1),
    (6, 6, N'/images/events/placeholder.jpg', N'Hardstyle Legends festivalterrein', 1, 1),
    (7, 7, N'/images/events/placeholder.jpg', N'Kinderfilm Festijn', 1, 1),
    (8, 8, N'/images/events/placeholder.jpg', N'Food Truck Festival Parkstad', 1, 1),
    (9, 9, N'/images/events/placeholder.jpg', N'Theater op Locatie De Storm', 1, 1),
    (10, 10, N'/uploads/events/amsterdam-dance-event.jpg', N'Bassline Drum & Bass Night', 1, 1),
    (11, 11, N'/images/events/placeholder.jpg', N'Kunstroute Limburg', 1, 1),
    (12, 12, N'/images/events/placeholder.jpg', N'Zomerpop Breda', 1, 1),
    (13, 13, N'/images/events/placeholder.jpg', N'Noorderlicht Winterfair', 1, 1),
    (14, 14, N'/uploads/events/amsterdam-dance-event.jpg', N'Techno Warehouse Maassilo', 1, 1),
    (15, 15, N'/images/events/placeholder.jpg', N'Cabaret & Komedie Avond', 1, 1),
    (16, 16, N'/images/events/placeholder.jpg', N'Parkstad City Run', 1, 1),
    (17, 17, N'/images/events/placeholder.jpg', N'Natuurwandeling Mergelland', 1, 1);
GO

/* ----------------------------------------------------------------------------
   9. Ticketprijzen
   ---------------------------------------------------------------------------- */
INSERT [dbo].[event_ticket_prices]
    ([event_ticket_price_id], [ticket_type], [price], [event_id])
VALUES
    (1, N'Regulier', CAST(39.50 AS decimal(10,2)), 1),
    (2, N'Weekend', CAST(89.50 AS decimal(10,2)), 1),
    (3, N'Kind', CAST(19.50 AS decimal(10,2)), 1),
    (4, N'Toegang', CAST(0.00 AS decimal(10,2)), 2),
    (5, N'Regulier', CAST(22.50 AS decimal(10,2)), 3),
    (6, N'VIP', CAST(39.50 AS decimal(10,2)), 3),
    (7, N'Regulier', CAST(12.50 AS decimal(10,2)), 4),
    (8, N'Student', CAST(7.50 AS decimal(10,2)), 4),
    (9, N'Kind', CAST(0.00 AS decimal(10,2)), 4),
    (10, N'Balkon', CAST(29.00 AS decimal(10,2)), 5),
    (11, N'Midden', CAST(45.00 AS decimal(10,2)), 5),
    (12, N'Premium', CAST(62.50 AS decimal(10,2)), 5),
    (13, N'Dagticket', CAST(59.00 AS decimal(10,2)), 6),
    (14, N'Weekend', CAST(109.00 AS decimal(10,2)), 6),
    (15, N'VIP', CAST(159.00 AS decimal(10,2)), 6),
    (16, N'Kinderen', CAST(7.50 AS decimal(10,2)), 7),
    (17, N'Volwassenen', CAST(9.50 AS decimal(10,2)), 7),
    (18, N'CJP', CAST(8.00 AS decimal(10,2)), 7),
    (19, N'Toegang', CAST(0.00 AS decimal(10,2)), 8),
    (20, N'Proeverijpas', CAST(17.50 AS decimal(10,2)), 8),
    (21, N'Regulier', CAST(24.50 AS decimal(10,2)), 9),
    (22, N'Student', CAST(19.50 AS decimal(10,2)), 9),
    (23, N'Regulier', CAST(27.50 AS decimal(10,2)), 10),
    (24, N'Early bird', CAST(22.50 AS decimal(10,2)), 10),
    (25, N'Toegang', CAST(0.00 AS decimal(10,2)), 11),
    (26, N'Catalogus', CAST(7.50 AS decimal(10,2)), 11),
    (27, N'Dagticket', CAST(49.50 AS decimal(10,2)), 12),
    (28, N'Weekend', CAST(89.50 AS decimal(10,2)), 12),
    (29, N'VIP', CAST(139.50 AS decimal(10,2)), 12),
    (30, N'Toegang', CAST(0.00 AS decimal(10,2)), 13),
    (31, N'Workshop', CAST(12.50 AS decimal(10,2)), 13),
    (32, N'Early bird', CAST(29.50 AS decimal(10,2)), 14),
    (33, N'Regulier', CAST(34.00 AS decimal(10,2)), 14),
    (34, N'VIP', CAST(54.00 AS decimal(10,2)), 14),
    (35, N'Regulier', CAST(21.00 AS decimal(10,2)), 15),
    (36, N'Student', CAST(17.50 AS decimal(10,2)), 15),
    (37, N'5 kilometer', CAST(12.50 AS decimal(10,2)), 16),
    (38, N'10 kilometer', CAST(17.50 AS decimal(10,2)), 16),
    (39, N'Kids run', CAST(5.00 AS decimal(10,2)), 16),
    (40, N'Toegang', CAST(0.00 AS decimal(10,2)), 17),
    (41, N'Gids', CAST(7.50 AS decimal(10,2)), 17);
GO

/* ----------------------------------------------------------------------------
   10. Toegankelijkheidsopties per evenement
   ---------------------------------------------------------------------------- */
INSERT [dbo].[event_accessibility_options]
    ([accessibility_option_id], [description], [event_id])
VALUES
    (1, N'Rolstoeltoegankelijke ingang', 1),
    (2, N'Prikkelarme ruimte', 1),
    (3, N'Gereserveerde invalidenparkeerplaatsen', 1),
    (4, N'Rolstoeltoegankelijke route', 2),
    (5, N'Audiotour beschikbaar', 2),
    (6, N'Rolstoeltoegankelijke dansvloer', 3),
    (7, N'Gendervrije toiletten', 3),
    (8, N'Audiotour beschikbaar', 4),
    (9, N'Rolstoeltoegankelijk', 4),
    (10, N'Gereserveerde plaatsen voor slechtzienden', 5),
    (11, N'Rolstoelplaatsen beschikbaar', 5),
    (12, N'Rolstoeltoegankelijk terrein', 6),
    (13, N'Gereserveerde invalidenparkeerplaatsen', 6),
    (14, N'Prikkelarme voorstellingen', 7),
    (15, N'Rolstoeltoegankelijk', 7),
    (16, N'Rolstoeltoegankelijk terrein', 8),
    (17, N'Prikkelarme ruimte', 8),
    (18, N'Rolstoelplaatsen beschikbaar', 9),
    (19, N'Audiodescriptie op aanvraag', 9),
    (20, N'Rolstoeltoegankelijke dansvloer', 10),
    (21, N'Rolstoeltoegankelijke route', 11),
    (22, N'Prikkelarme tijdsblokken', 11),
    (23, N'Rolstoeltoegankelijk terrein', 12),
    (24, N'Gereserveerde invalidenparkeerplaatsen', 12),
    (25, N'Rolstoeltoegankelijk', 13),
    (26, N'Prikkelarme ochtend', 13),
    (27, N'Rolstoeltoegankelijke dansvloer', 14),
    (28, N'Gendervrije toiletten', 14),
    (29, N'Rolstoelplaatsen beschikbaar', 15),
    (30, N'Audiodescriptie op aanvraag', 15),
    (31, N'Rolstoeltoegankelijk parcours', 16),
    (32, N'Drinkposten onderweg', 16),
    (33, N'Rolstoeltoegankelijke route', 17),
    (34, N'Prikkelarme tijdsblokken', 17);
GO

/* ----------------------------------------------------------------------------
   11. Koppeling evenementen en categorieen
   ---------------------------------------------------------------------------- */
INSERT [dbo].[event_event_categories] ([category_id], [event_id])
VALUES
    (1, 1), (2, 1), (16, 1), (18, 1),
    (2, 2), (16, 2), (17, 2), (18, 2),
    (6, 3), (7, 3), (8, 3), (9, 3),
    (3, 4), (4, 4), (15, 4),
    (3, 5), (19, 5),
    (2, 6), (6, 6), (12, 6),
    (14, 7), (18, 7),
    (2, 8), (16, 8), (18, 8),
    (3, 9), (13, 9),
    (6, 10), (8, 10), (11, 10),
    (3, 11), (4, 11), (17, 11),
    (1, 12), (2, 12), (5, 12),
    (16, 13), (17, 13), (18, 13),
    (6, 14), (7, 14), (8, 14), (9, 14),
    (13, 15), (20, 15),
    (18, 16), (21, 16),
    (4, 17), (18, 17), (22, 17);
GO

/* ----------------------------------------------------------------------------
   12. Bijlagen bij evenementen (kleine tekstbestanden)
   ---------------------------------------------------------------------------- */
INSERT [dbo].[event_attachments]
    ([event_id], [file_name], [content_type], [file_content], [uploaded_at])
VALUES
    (1, N'praktische-informatie.txt', N'text/plain',
     CAST('Openingstijden: vrijdag 16:00-23:30, zaterdag 12:00-23:30, zondag 12:00-22:00. Gratis shuttle vanaf station Landgraaf.' AS varbinary(max)),
     CAST(N'2026-11-01T10:00:00' AS datetime2)),
    (6, N'reisdocument.txt', N'text/plain',
     CAST('Het terrein is bereikbaar met de trein en shuttlebus. Camping opent om 10:00. Laatste toegang tot het festivalterrein is 22:30.' AS varbinary(max)),
     CAST(N'2026-11-01T10:05:00' AS datetime2));
GO

/* ----------------------------------------------------------------------------
   13. Bookmarks
   ---------------------------------------------------------------------------- */
INSERT [dbo].[account_bookmarks] ([account_id], [event_id], [created_at])
VALUES
    (1, 1, CAST(N'2026-10-20T18:00:00' AS datetime2)),
    (1, 11, CAST(N'2026-10-21T09:30:00' AS datetime2)),
    (1, 15, CAST(N'2026-10-22T20:15:00' AS datetime2)),
    (2, 1, CAST(N'2026-10-20T18:05:00' AS datetime2)),
    (2, 6, CAST(N'2026-10-23T12:00:00' AS datetime2)),
    (2, 12, CAST(N'2026-10-24T14:30:00' AS datetime2)),
    (3, 4, CAST(N'2026-10-21T10:00:00' AS datetime2)),
    (3, 11, CAST(N'2026-10-25T11:15:00' AS datetime2)),
    (3, 17, CAST(N'2026-10-26T16:00:00' AS datetime2)),
    (4, 3, CAST(N'2026-10-22T22:00:00' AS datetime2)),
    (4, 10, CAST(N'2026-10-25T23:30:00' AS datetime2)),
    (4, 14, CAST(N'2026-10-27T19:45:00' AS datetime2)),
    (5, 2, CAST(N'2026-10-24T10:00:00' AS datetime2)),
    (5, 8, CAST(N'2026-10-26T12:30:00' AS datetime2)),
    (5, 13, CAST(N'2026-10-28T09:00:00' AS datetime2)),
    (6, 5, CAST(N'2026-10-22T20:00:00' AS datetime2)),
    (6, 7, CAST(N'2026-10-24T15:00:00' AS datetime2)),
    (6, 9, CAST(N'2026-10-27T18:30:00' AS datetime2)),
    (6, 15, CAST(N'2026-10-29T21:00:00' AS datetime2)),
    (7, 7, CAST(N'2026-10-25T09:00:00' AS datetime2)),
    (7, 8, CAST(N'2026-10-27T10:30:00' AS datetime2)),
    (7, 13, CAST(N'2026-10-29T11:00:00' AS datetime2)),
    (7, 17, CAST(N'2026-10-30T13:00:00' AS datetime2)),
    (8, 6, CAST(N'2026-10-24T16:00:00' AS datetime2)),
    (8, 12, CAST(N'2026-10-28T17:30:00' AS datetime2)),
    (9, 4, CAST(N'2026-10-23T10:00:00' AS datetime2)),
    (9, 5, CAST(N'2026-10-26T20:00:00' AS datetime2)),
    (10, 4, CAST(N'2026-10-24T11:00:00' AS datetime2)),
    (10, 11, CAST(N'2026-10-27T12:00:00' AS datetime2)),
    (10, 17, CAST(N'2026-10-30T14:00:00' AS datetime2)),
    (11, 3, CAST(N'2026-10-25T21:00:00' AS datetime2)),
    (11, 6, CAST(N'2026-10-27T22:30:00' AS datetime2)),
    (11, 10, CAST(N'2026-10-29T23:00:00' AS datetime2)),
    (11, 14, CAST(N'2026-10-31T00:30:00' AS datetime2)),
    (12, 1, CAST(N'2026-10-26T08:00:00' AS datetime2)),
    (12, 2, CAST(N'2026-10-28T09:15:00' AS datetime2)),
    (12, 8, CAST(N'2026-10-30T10:30:00' AS datetime2)),
    (12, 16, CAST(N'2026-11-01T11:45:00' AS datetime2));
GO

/* ----------------------------------------------------------------------------
   14. Volgen van accounts
   ---------------------------------------------------------------------------- */
INSERT [dbo].[account_follows]
    ([follower_account_id], [following_account_id], [created_at])
VALUES
    (1, 2, CAST(N'2025-02-01T10:00:00' AS datetime2)),
    (1, 3, CAST(N'2025-03-01T10:00:00' AS datetime2)),
    (1, 5, CAST(N'2025-05-01T10:00:00' AS datetime2)),
    (2, 1, CAST(N'2025-02-02T11:00:00' AS datetime2)),
    (2, 4, CAST(N'2025-04-02T11:00:00' AS datetime2)),
    (3, 1, CAST(N'2025-03-03T12:00:00' AS datetime2)),
    (3, 10, CAST(N'2025-10-03T12:00:00' AS datetime2)),
    (4, 2, CAST(N'2025-04-04T13:00:00' AS datetime2)),
    (4, 11, CAST(N'2025-11-04T13:00:00' AS datetime2)),
    (5, 1, CAST(N'2025-05-05T14:00:00' AS datetime2)),
    (5, 7, CAST(N'2025-07-05T14:00:00' AS datetime2)),
    (6, 5, CAST(N'2025-06-06T15:00:00' AS datetime2)),
    (6, 3, CAST(N'2025-03-06T15:00:00' AS datetime2)),
    (7, 5, CAST(N'2025-07-07T16:00:00' AS datetime2)),
    (7, 6, CAST(N'2025-06-07T16:00:00' AS datetime2)),
    (8, 2, CAST(N'2025-08-08T17:00:00' AS datetime2)),
    (8, 6, CAST(N'2025-06-08T17:00:00' AS datetime2)),
    (9, 3, CAST(N'2025-09-09T18:00:00' AS datetime2)),
    (9, 4, CAST(N'2025-04-09T18:00:00' AS datetime2)),
    (10, 3, CAST(N'2025-10-10T19:00:00' AS datetime2)),
    (10, 11, CAST(N'2025-11-10T19:00:00' AS datetime2)),
    (11, 4, CAST(N'2025-11-11T20:00:00' AS datetime2)),
    (11, 6, CAST(N'2025-06-11T20:00:00' AS datetime2)),
    (12, 1, CAST(N'2025-12-12T21:00:00' AS datetime2)),
    (12, 2, CAST(N'2025-12-02T21:00:00' AS datetime2));
GO

/* ----------------------------------------------------------------------------
   15. Accountposts (sociale feed)
   ---------------------------------------------------------------------------- */
SET IDENTITY_INSERT [dbo].[account_posts] ON;

INSERT [dbo].[account_posts]
    ([post_id], [account_id], [caption], [created_at], [updated_at], [is_deleted])
VALUES
    (1, 1, N'Winterlicht Festival staat in mijn agenda! Wie gaat er mee?',
     CAST(N'2026-10-28T18:30:00' AS datetime2), CAST(N'2026-10-28T18:30:00' AS datetime2), 0),
    (2, 2, N'Vanavond foto''s uitzoeken van het laatste festival.',
     CAST(N'2026-10-29T09:15:00' AS datetime2), CAST(N'2026-10-29T09:15:00' AS datetime2), 0),
    (3, 3, N'Nieuwe tentoonstelling in het Bonnefanten geopend.',
     CAST(N'2026-10-30T14:45:00' AS datetime2), CAST(N'2026-10-30T14:45:00' AS datetime2), 0),
    (4, 4, N'Bassline was weer geniaal. Volgende editie ben ik er zeker bij.',
     CAST(N'2026-10-31T02:10:00' AS datetime2), CAST(N'2026-10-31T02:10:00' AS datetime2), 0),
    (5, 5, N'Food Truck Festival Parkstad: de vegan taco was top.',
     CAST(N'2026-11-01T12:00:00' AS datetime2), CAST(N'2026-11-01T12:00:00' AS datetime2), 0),
    (6, 6, N'Theatertip: De Storm. Nog kaarten voor zondag.',
     CAST(N'2026-11-01T16:20:00' AS datetime2), CAST(N'2026-11-01T16:20:00' AS datetime2), 0),
    (7, 7, N'Leuke kinderfilmmiddag gepland met de kinderen.',
     CAST(N'2026-11-02T08:05:00' AS datetime2), CAST(N'2026-11-02T08:05:00' AS datetime2), 0),
    (8, 8, N'Zomerpop Breda line-up is bekend!',
     CAST(N'2026-11-02T09:40:00' AS datetime2), CAST(N'2026-11-02T09:40:00' AS datetime2), 0),
    (9, 9, N'Oude post die niet meer zichtbaar hoeft te zijn.',
     CAST(N'2026-10-15T11:00:00' AS datetime2), CAST(N'2026-10-15T11:00:00' AS datetime2), 1);

SET IDENTITY_INSERT [dbo].[account_posts] OFF;
GO

SET IDENTITY_INSERT [dbo].[account_post_images] ON;

INSERT [dbo].[account_post_images]
    ([post_image_id], [post_id], [image_url], [display_order], [created_at], [is_deleted])
VALUES
    (1, 1, N'/images/events/placeholder.jpg', 1, CAST(N'2026-10-28T18:30:00' AS datetime2), 0),
    (2, 3, N'/images/events/placeholder.jpg', 1, CAST(N'2026-10-30T14:45:00' AS datetime2), 0),
    (3, 5, N'/images/events/placeholder.jpg', 1, CAST(N'2026-11-01T12:00:00' AS datetime2), 0),
    (4, 8, N'/images/events/placeholder.jpg', 1, CAST(N'2026-11-02T09:40:00' AS datetime2), 0);

SET IDENTITY_INSERT [dbo].[account_post_images] OFF;
GO

INSERT [dbo].[account_post_likes] ([post_id], [account_id], [created_at])
VALUES
    (1, 2, CAST(N'2026-10-28T19:00:00' AS datetime2)),
    (1, 3, CAST(N'2026-10-28T19:10:00' AS datetime2)),
    (1, 4, CAST(N'2026-10-28T19:20:00' AS datetime2)),
    (1, 5, CAST(N'2026-10-28T19:30:00' AS datetime2)),
    (2, 1, CAST(N'2026-10-29T10:00:00' AS datetime2)),
    (2, 4, CAST(N'2026-10-29T10:15:00' AS datetime2)),
    (3, 1, CAST(N'2026-10-30T15:00:00' AS datetime2)),
    (3, 6, CAST(N'2026-10-30T15:10:00' AS datetime2)),
    (3, 10, CAST(N'2026-10-30T15:20:00' AS datetime2)),
    (4, 2, CAST(N'2026-10-31T08:00:00' AS datetime2)),
    (4, 11, CAST(N'2026-10-31T08:15:00' AS datetime2)),
    (5, 1, CAST(N'2026-11-01T13:00:00' AS datetime2)),
    (5, 7, CAST(N'2026-11-01T13:15:00' AS datetime2)),
    (5, 12, CAST(N'2026-11-01T13:30:00' AS datetime2)),
    (6, 3, CAST(N'2026-11-01T17:00:00' AS datetime2)),
    (6, 9, CAST(N'2026-11-01T17:15:00' AS datetime2)),
    (7, 5, CAST(N'2026-11-02T08:30:00' AS datetime2)),
    (7, 7, CAST(N'2026-11-02T08:45:00' AS datetime2)),
    (8, 1, CAST(N'2026-11-02T10:00:00' AS datetime2)),
    (8, 2, CAST(N'2026-11-02T10:10:00' AS datetime2)),
    (8, 11, CAST(N'2026-11-02T10:20:00' AS datetime2)),
    (8, 12, CAST(N'2026-11-02T10:30:00' AS datetime2));
GO

/* ----------------------------------------------------------------------------
   16. Posts (algemene posts met eventkoppeling)
   ---------------------------------------------------------------------------- */
SET IDENTITY_INSERT [dbo].[posts] ON;

INSERT [dbo].[posts]
    ([post_id], [creator_account_id], [event_id], [description], [created_at], [updated_at])
VALUES
    (1, 1, 1, N'Wie heeft er tips voor vervoer naar Winterlicht Festival?',
     CAST(N'2026-10-27T12:00:00' AS datetime2), CAST(N'2026-10-27T12:00:00' AS datetime2)),
    (2, 2, 6, N'Hardstyle Legends: welke dag gaan jullie?',
     CAST(N'2026-10-28T15:30:00' AS datetime2), CAST(N'2026-10-28T15:30:00' AS datetime2)),
    (3, 3, 4, N'Museum Nacht Maastricht is een aanrader.',
     CAST(N'2026-10-29T10:00:00' AS datetime2), CAST(N'2026-10-29T10:00:00' AS datetime2)),
    (4, 4, 10, N'Bassline: Drum & Bass Night, early bird tickets zijn live.',
     CAST(N'2026-10-30T18:45:00' AS datetime2), CAST(N'2026-10-30T18:45:00' AS datetime2)),
    (5, 5, 8, N'Food Truck Festival: laat je favoriete truck weten!',
     CAST(N'2026-10-31T09:20:00' AS datetime2), CAST(N'2026-10-31T09:20:00' AS datetime2)),
    (6, 7, 7, N'Kinderfilm Festijn: tips voor de jongste bezoekers.',
     CAST(N'2026-11-01T14:10:00' AS datetime2), CAST(N'2026-11-01T14:10:00' AS datetime2));

SET IDENTITY_INSERT [dbo].[posts] OFF;
GO

INSERT [dbo].[post_images] ([post_id], [image_url], [sort_order], [created_at])
VALUES
    (1, N'/images/events/placeholder.jpg', 1, CAST(N'2026-10-27T12:00:00' AS datetime2)),
    (3, N'/images/events/placeholder.jpg', 1, CAST(N'2026-10-29T10:00:00' AS datetime2)),
    (4, N'/images/events/placeholder.jpg', 1, CAST(N'2026-10-30T18:45:00' AS datetime2)),
    (6, N'/images/events/placeholder.jpg', 1, CAST(N'2026-11-01T14:10:00' AS datetime2));
GO

INSERT [dbo].[post_likes] ([post_id], [account_id], [created_at])
VALUES
    (1, 2, CAST(N'2026-10-27T12:15:00' AS datetime2)),
    (1, 3, CAST(N'2026-10-27T12:30:00' AS datetime2)),
    (2, 4, CAST(N'2026-10-28T16:00:00' AS datetime2)),
    (2, 8, CAST(N'2026-10-28T16:15:00' AS datetime2)),
    (3, 1, CAST(N'2026-10-29T10:30:00' AS datetime2)),
    (3, 6, CAST(N'2026-10-29T10:45:00' AS datetime2)),
    (3, 10, CAST(N'2026-10-29T11:00:00' AS datetime2)),
    (4, 2, CAST(N'2026-10-30T19:00:00' AS datetime2)),
    (4, 11, CAST(N'2026-10-30T19:15:00' AS datetime2)),
    (5, 1, CAST(N'2026-10-31T10:00:00' AS datetime2)),
    (5, 7, CAST(N'2026-10-31T10:15:00' AS datetime2)),
    (6, 5, CAST(N'2026-11-01T15:00:00' AS datetime2)),
    (6, 7, CAST(N'2026-11-01T15:15:00' AS datetime2));
GO

INSERT [dbo].[post_tags] ([post_id], [tagged_account_id])
VALUES
    (1, 2),
    (1, 3),
    (2, 8),
    (2, 11),
    (3, 10),
    (4, 11),
    (5, 7),
    (6, 5);
GO

/* ----------------------------------------------------------------------------
   17. Reacties en commentlikes
   ---------------------------------------------------------------------------- */
SET IDENTITY_INSERT [dbo].[post_comments] ON;

INSERT [dbo].[post_comments]
    ([comment_id], [post_id], [account_id], [parent_comment_id], [comment_text], [created_at])
VALUES
    (1, 1, 2, NULL, N'Wij nemen de trein naar Heerlen en dan de shuttle.',
     CAST(N'2026-10-27T12:30:00' AS datetime2)),
    (2, 1, 1, 1, N'Top, dank voor de tip!',
     CAST(N'2026-10-27T13:00:00' AS datetime2)),
    (3, 2, 8, NULL, N'Zaterdag! Zin in.',
     CAST(N'2026-10-28T16:00:00' AS datetime2)),
    (4, 3, 10, NULL, N'Ik ga ook, vooral voor de historie-afdeling.',
     CAST(N'2026-10-29T11:15:00' AS datetime2)),
    (5, 4, 11, NULL, N'Early bird is al bijna weg.',
     CAST(N'2026-10-30T19:00:00' AS datetime2)),
    (6, 5, 7, NULL, N'Neem de kinderen mee, die vinden de ijsjeskar geweldig.',
     CAST(N'2026-10-31T10:00:00' AS datetime2)),
    (7, 6, 5, NULL, N'Mooie tip, wij gaan zondag.',
     CAST(N'2026-11-01T15:00:00' AS datetime2)),
    (8, 3, 3, 4, N'De historie-afdeling is dit jaar extra groot.',
     CAST(N'2026-10-29T12:00:00' AS datetime2));

SET IDENTITY_INSERT [dbo].[post_comments] OFF;
GO

INSERT [dbo].[comment_likes] ([comment_id], [account_id], [created_at])
VALUES
    (1, 1, CAST(N'2026-10-27T12:45:00' AS datetime2)),
    (1, 3, CAST(N'2026-10-27T13:00:00' AS datetime2)),
    (2, 2, CAST(N'2026-10-27T13:15:00' AS datetime2)),
    (3, 2, CAST(N'2026-10-28T16:30:00' AS datetime2)),
    (3, 4, CAST(N'2026-10-28T16:45:00' AS datetime2)),
    (4, 3, CAST(N'2026-10-29T11:30:00' AS datetime2)),
    (4, 6, CAST(N'2026-10-29T11:45:00' AS datetime2)),
    (5, 4, CAST(N'2026-10-30T19:15:00' AS datetime2)),
    (5, 8, CAST(N'2026-10-30T19:30:00' AS datetime2)),
    (6, 5, CAST(N'2026-10-31T10:30:00' AS datetime2)),
    (7, 6, CAST(N'2026-11-01T15:15:00' AS datetime2)),
    (8, 10, CAST(N'2026-10-29T12:15:00' AS datetime2));
GO

SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_account_external_logins_provider_user]    Script Date: 15/04/2026 14:10:45 ******/
ALTER TABLE [dbo].[account_external_logins] ADD  CONSTRAINT [UQ_account_external_logins_provider_user] UNIQUE NONCLUSTERED 
(
	[provider] ASC,
	[provider_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_account_post_images_post_id_is_deleted_display_order]    Script Date: 15/04/2026 14:10:45 ******/
CREATE NONCLUSTERED INDEX [IX_account_post_images_post_id_is_deleted_display_order] ON [dbo].[account_post_images]
(
	[post_id] ASC,
	[is_deleted] ASC,
	[display_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_account_post_likes]    Script Date: 15/04/2026 14:10:45 ******/
ALTER TABLE [dbo].[account_post_likes] ADD  CONSTRAINT [UQ_account_post_likes] UNIQUE NONCLUSTERED 
(
	[post_id] ASC,
	[account_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_account_posts_account_id_is_deleted_created_at]    Script Date: 15/04/2026 14:10:45 ******/
CREATE NONCLUSTERED INDEX [IX_account_posts_account_id_is_deleted_created_at] ON [dbo].[account_posts]
(
	[account_id] ASC,
	[is_deleted] ASC,
	[created_at] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__accounts__5CF1C59B6330B5B4]    Script Date: 15/04/2026 14:10:45 ******/
ALTER TABLE [dbo].[accounts] ADD UNIQUE NONCLUSTERED 
(
	[nickname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__accounts__AB6E61646E7A7751]    Script Date: 15/04/2026 14:10:45 ******/
ALTER TABLE [dbo].[accounts] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_event_image_primary]    Script Date: 15/04/2026 14:10:45 ******/
ALTER TABLE [dbo].[event_images] ADD  CONSTRAINT [UQ_event_image_primary] UNIQUE NONCLUSTERED 
(
	[event_id] ASC,
	[is_primary] ASC,
	[sort_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_locations_lat_lon]    Script Date: 15/04/2026 14:10:45 ******/
ALTER TABLE [dbo].[locations] ADD  CONSTRAINT [UQ_locations_lat_lon] UNIQUE NONCLUSTERED 
(
	[latitude] ASC,
	[longitude] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__organise__AB6E61645D2F4FC6]    Script Date: 15/04/2026 14:10:45 ******/
ALTER TABLE [dbo].[organiser_accounts] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[account_bookmarks] ADD  CONSTRAINT [DF_account_bookmarks_created_at]  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[account_external_logins] ADD  CONSTRAINT [DF_account_external_logins_created_at]  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[account_follows] ADD  CONSTRAINT [DF_account_follows_created_at]  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[account_post_images] ADD  CONSTRAINT [DF_account_post_images_display_order]  DEFAULT ((1)) FOR [display_order]
GO
ALTER TABLE [dbo].[account_post_images] ADD  CONSTRAINT [DF_account_post_images_created_at]  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[account_post_images] ADD  CONSTRAINT [DF_account_post_images_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[account_post_likes] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[account_posts] ADD  CONSTRAINT [DF_account_posts_created_at]  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[account_posts] ADD  CONSTRAINT [DF_account_posts_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[accounts] ADD  CONSTRAINT [DF_accounts_karma]  DEFAULT ((0)) FOR [karma]
GO
ALTER TABLE [dbo].[accounts] ADD  CONSTRAINT [DF_accounts_events_reviewed_count]  DEFAULT ((0)) FOR [events_reviewed_count]
GO
ALTER TABLE [dbo].[accounts] ADD  CONSTRAINT [DF_accounts_created_at]  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[accounts] ADD  CONSTRAINT [DF_accounts_updated_at]  DEFAULT (sysutcdatetime()) FOR [updated_at]
GO
ALTER TABLE [dbo].[accounts] ADD  CONSTRAINT [DF_accounts_is_deleted]  DEFAULT ((0)) FOR [is_deleted]
GO
ALTER TABLE [dbo].[comment_likes] ADD  CONSTRAINT [DF_comment_likes_created_at]  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[event_images] ADD  CONSTRAINT [DF_event_images_is_primary]  DEFAULT ((1)) FOR [is_primary]
GO
ALTER TABLE [dbo].[event_images] ADD  CONSTRAINT [DF_event_images_sort_order]  DEFAULT ((1)) FOR [sort_order]
GO
ALTER TABLE [dbo].[events] ADD  CONSTRAINT [DF_events_canceled]  DEFAULT ((0)) FOR [canceled]
GO
ALTER TABLE [dbo].[organiser_accounts] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[organiser_accounts] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[organisers] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[organisers] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[post_comments] ADD  CONSTRAINT [DF_post_comments_created_at]  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[post_images] ADD  CONSTRAINT [DF_post_images_sort_order]  DEFAULT ((1)) FOR [sort_order]
GO
ALTER TABLE [dbo].[post_images] ADD  CONSTRAINT [DF_post_images_created_at]  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[post_likes] ADD  CONSTRAINT [DF_post_likes_created_at]  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[posts] ADD  CONSTRAINT [DF_posts_created_at]  DEFAULT (sysutcdatetime()) FOR [created_at]
GO
ALTER TABLE [dbo].[posts] ADD  CONSTRAINT [DF_posts_updated_at]  DEFAULT (sysutcdatetime()) FOR [updated_at]
GO
ALTER TABLE [dbo].[account_bookmarks]  WITH CHECK ADD  CONSTRAINT [FK_account_bookmarks_account] FOREIGN KEY([account_id])
REFERENCES [dbo].[accounts] ([account_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[account_bookmarks] CHECK CONSTRAINT [FK_account_bookmarks_account]
GO
ALTER TABLE [dbo].[account_bookmarks]  WITH CHECK ADD  CONSTRAINT [FK_account_bookmarks_event] FOREIGN KEY([event_id])
REFERENCES [dbo].[events] ([event_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[account_bookmarks] CHECK CONSTRAINT [FK_account_bookmarks_event]
GO
ALTER TABLE [dbo].[account_external_logins]  WITH CHECK ADD  CONSTRAINT [FK_account_external_logins_account] FOREIGN KEY([account_id])
REFERENCES [dbo].[accounts] ([account_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[account_external_logins] CHECK CONSTRAINT [FK_account_external_logins_account]
GO
ALTER TABLE [dbo].[account_follows]  WITH CHECK ADD  CONSTRAINT [FK_account_follows_follower] FOREIGN KEY([follower_account_id])
REFERENCES [dbo].[accounts] ([account_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[account_follows] CHECK CONSTRAINT [FK_account_follows_follower]
GO
ALTER TABLE [dbo].[account_follows]  WITH CHECK ADD  CONSTRAINT [FK_account_follows_following] FOREIGN KEY([following_account_id])
REFERENCES [dbo].[accounts] ([account_id])
GO
ALTER TABLE [dbo].[account_follows] CHECK CONSTRAINT [FK_account_follows_following]
GO
ALTER TABLE [dbo].[account_post_images]  WITH CHECK ADD  CONSTRAINT [FK_account_post_images_account_posts] FOREIGN KEY([post_id])
REFERENCES [dbo].[account_posts] ([post_id])
GO
ALTER TABLE [dbo].[account_post_images] CHECK CONSTRAINT [FK_account_post_images_account_posts]
GO
ALTER TABLE [dbo].[account_post_likes]  WITH CHECK ADD  CONSTRAINT [FK_account_post_likes_account] FOREIGN KEY([account_id])
REFERENCES [dbo].[accounts] ([account_id])
GO
ALTER TABLE [dbo].[account_post_likes] CHECK CONSTRAINT [FK_account_post_likes_account]
GO
ALTER TABLE [dbo].[account_post_likes]  WITH CHECK ADD  CONSTRAINT [FK_account_post_likes_post] FOREIGN KEY([post_id])
REFERENCES [dbo].[account_posts] ([post_id])
GO
ALTER TABLE [dbo].[account_post_likes] CHECK CONSTRAINT [FK_account_post_likes_post]
GO
ALTER TABLE [dbo].[account_posts]  WITH CHECK ADD  CONSTRAINT [FK_account_posts_accounts] FOREIGN KEY([account_id])
REFERENCES [dbo].[accounts] ([account_id])
GO
ALTER TABLE [dbo].[account_posts] CHECK CONSTRAINT [FK_account_posts_accounts]
GO
ALTER TABLE [dbo].[comment_likes]  WITH CHECK ADD  CONSTRAINT [FK_comment_likes_account] FOREIGN KEY([account_id])
REFERENCES [dbo].[accounts] ([account_id])
GO
ALTER TABLE [dbo].[comment_likes] CHECK CONSTRAINT [FK_comment_likes_account]
GO
ALTER TABLE [dbo].[comment_likes]  WITH CHECK ADD  CONSTRAINT [FK_comment_likes_comment] FOREIGN KEY([comment_id])
REFERENCES [dbo].[post_comments] ([comment_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[comment_likes] CHECK CONSTRAINT [FK_comment_likes_comment]
GO
ALTER TABLE [dbo].[event_accessibility_options]  WITH CHECK ADD  CONSTRAINT [FK_accessibility_event] FOREIGN KEY([event_id])
REFERENCES [dbo].[events] ([event_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[event_accessibility_options] CHECK CONSTRAINT [FK_accessibility_event]
GO
ALTER TABLE [dbo].[event_categories]  WITH CHECK ADD  CONSTRAINT [FK_event_categories_event_categories] FOREIGN KEY([category_id])
REFERENCES [dbo].[event_categories] ([category_id])
GO
ALTER TABLE [dbo].[event_categories] CHECK CONSTRAINT [FK_event_categories_event_categories]
GO
ALTER TABLE [dbo].[event_dates]  WITH CHECK ADD  CONSTRAINT [FK_event_dates_events] FOREIGN KEY([event_id])
REFERENCES [dbo].[events] ([event_id])
GO
ALTER TABLE [dbo].[event_dates] CHECK CONSTRAINT [FK_event_dates_events]
GO
ALTER TABLE [dbo].[event_event_categories]  WITH CHECK ADD  CONSTRAINT [FK_category_event] FOREIGN KEY([event_id])
REFERENCES [dbo].[events] ([event_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[event_event_categories] CHECK CONSTRAINT [FK_category_event]
GO
ALTER TABLE [dbo].[event_event_categories]  WITH CHECK ADD  CONSTRAINT [FK_event_event_categories_event_categories] FOREIGN KEY([category_id])
REFERENCES [dbo].[event_categories] ([category_id])
GO
ALTER TABLE [dbo].[event_event_categories] CHECK CONSTRAINT [FK_event_event_categories_event_categories]
GO
ALTER TABLE [dbo].[event_images]  WITH CHECK ADD  CONSTRAINT [FK_event_image_event] FOREIGN KEY([event_id])
REFERENCES [dbo].[events] ([event_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[event_images] CHECK CONSTRAINT [FK_event_image_event]
GO
ALTER TABLE [dbo].[event_ticket_prices]  WITH CHECK ADD  CONSTRAINT [FK_ticket_event] FOREIGN KEY([event_id])
REFERENCES [dbo].[events] ([event_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[event_ticket_prices] CHECK CONSTRAINT [FK_ticket_event]
GO
ALTER TABLE [dbo].[events]  WITH CHECK ADD  CONSTRAINT [FK_events_location] FOREIGN KEY([location_id])
REFERENCES [dbo].[locations] ([location_id])
GO
ALTER TABLE [dbo].[events] CHECK CONSTRAINT [FK_events_location]
GO
ALTER TABLE [dbo].[events]  WITH CHECK ADD  CONSTRAINT [FK_events_organisers] FOREIGN KEY([organiser_id])
REFERENCES [dbo].[organiser_accounts] ([organiser_account_id])
GO
ALTER TABLE [dbo].[events] CHECK CONSTRAINT [FK_events_organisers]
GO
ALTER TABLE [dbo].[organiser_accounts]  WITH CHECK ADD  CONSTRAINT [FK_organiser_accounts_organisers] FOREIGN KEY([organiser_id])
REFERENCES [dbo].[organisers] ([organiser_id])
GO
ALTER TABLE [dbo].[organiser_accounts] CHECK CONSTRAINT [FK_organiser_accounts_organisers]
GO
ALTER TABLE [dbo].[post_comments]  WITH CHECK ADD  CONSTRAINT [FK_post_comments_account] FOREIGN KEY([account_id])
REFERENCES [dbo].[accounts] ([account_id])
GO
ALTER TABLE [dbo].[post_comments] CHECK CONSTRAINT [FK_post_comments_account]
GO
ALTER TABLE [dbo].[post_comments]  WITH CHECK ADD  CONSTRAINT [FK_post_comments_parent] FOREIGN KEY([parent_comment_id])
REFERENCES [dbo].[post_comments] ([comment_id])
GO
ALTER TABLE [dbo].[post_comments] CHECK CONSTRAINT [FK_post_comments_parent]
GO
ALTER TABLE [dbo].[post_comments]  WITH CHECK ADD  CONSTRAINT [FK_post_comments_post] FOREIGN KEY([post_id])
REFERENCES [dbo].[posts] ([post_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[post_comments] CHECK CONSTRAINT [FK_post_comments_post]
GO
ALTER TABLE [dbo].[post_images]  WITH CHECK ADD  CONSTRAINT [FK_post_images_post] FOREIGN KEY([post_id])
REFERENCES [dbo].[posts] ([post_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[post_images] CHECK CONSTRAINT [FK_post_images_post]
GO
ALTER TABLE [dbo].[post_likes]  WITH CHECK ADD  CONSTRAINT [FK_post_likes_account] FOREIGN KEY([account_id])
REFERENCES [dbo].[accounts] ([account_id])
GO
ALTER TABLE [dbo].[post_likes] CHECK CONSTRAINT [FK_post_likes_account]
GO
ALTER TABLE [dbo].[post_likes]  WITH CHECK ADD  CONSTRAINT [FK_post_likes_post] FOREIGN KEY([post_id])
REFERENCES [dbo].[posts] ([post_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[post_likes] CHECK CONSTRAINT [FK_post_likes_post]
GO
ALTER TABLE [dbo].[post_tags]  WITH CHECK ADD  CONSTRAINT [FK_post_tags_account] FOREIGN KEY([tagged_account_id])
REFERENCES [dbo].[accounts] ([account_id])
GO
ALTER TABLE [dbo].[post_tags] CHECK CONSTRAINT [FK_post_tags_account]
GO
ALTER TABLE [dbo].[post_tags]  WITH CHECK ADD  CONSTRAINT [FK_post_tags_post] FOREIGN KEY([post_id])
REFERENCES [dbo].[posts] ([post_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[post_tags] CHECK CONSTRAINT [FK_post_tags_post]
GO
ALTER TABLE [dbo].[posts]  WITH CHECK ADD  CONSTRAINT [FK_posts_creator] FOREIGN KEY([creator_account_id])
REFERENCES [dbo].[accounts] ([account_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[posts] CHECK CONSTRAINT [FK_posts_creator]
GO
ALTER TABLE [dbo].[posts]  WITH CHECK ADD  CONSTRAINT [FK_posts_event] FOREIGN KEY([event_id])
REFERENCES [dbo].[events] ([event_id])
GO
ALTER TABLE [dbo].[posts] CHECK CONSTRAINT [FK_posts_event]
GO
ALTER TABLE [dbo].[account_follows]  WITH CHECK ADD  CONSTRAINT [CHK_account_follows_not_self] CHECK  (([follower_account_id]<>[following_account_id]))
GO
ALTER TABLE [dbo].[account_follows] CHECK CONSTRAINT [CHK_account_follows_not_self]
GO
ALTER TABLE [dbo].[events]  WITH CHECK ADD  CONSTRAINT [CK_events_indoors_outdoors] CHECK  (([indoors_outdoors]=(1) OR [indoors_outdoors]=(2) OR [indoors_outdoors]=(3)))
GO
ALTER TABLE [dbo].[events] CHECK CONSTRAINT [CK_events_indoors_outdoors]
GO