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
bestaande installatie. De bestaande voorbeeldgegevens zijn opgenomen.

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
INSERT [dbo].[account_bookmarks] ([account_id], [event_id], [created_at]) VALUES (10, 13, CAST(N'2026-03-31T11:00:17.5172067' AS DateTime2))
INSERT [dbo].[account_bookmarks] ([account_id], [event_id], [created_at]) VALUES (10, 15, CAST(N'2026-03-31T11:00:18.3871601' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[account_post_images] ON 

INSERT [dbo].[account_post_images] ([post_image_id], [post_id], [image_url], [display_order], [created_at], [is_deleted]) VALUES (1, 1, N'http://strangemindsdivision.com/wp-content/uploads/2026/03/Jan-Biggel-2022-scaled-1.jpg', 1, CAST(N'2026-03-30T17:48:49.0000000' AS DateTime2), 0)
SET IDENTITY_INSERT [dbo].[account_post_images] OFF
GO
SET IDENTITY_INSERT [dbo].[account_posts] ON 

INSERT [dbo].[account_posts] ([post_id], [account_id], [caption], [created_at], [updated_at], [is_deleted]) VALUES (1, 9, N'ewa strijder', CAST(N'2026-03-30T00:00:00.0000000' AS DateTime2), CAST(N'2026-03-30T00:00:00.0000000' AS DateTime2), 0)
SET IDENTITY_INSERT [dbo].[account_posts] OFF
GO
SET IDENTITY_INSERT [dbo].[accounts] ON 

INSERT [dbo].[accounts] ([account_id], [nickname], [first_name], [last_name], [email], [password_hash], [phone_number], [date_of_birth], [bio], [profile_picture_url], [karma], [events_reviewed_count], [created_at], [updated_at], [is_deleted]) VALUES (9, N'hazy', N'Duncan', N'Deliege', N'duncandeliege@outlook.com', N'AQAAAAIAAYagAAAAEDTZQL9hMC3Ed+aiuRXEcSwCltZUAoQnYyc7rgHoaTc6s+ggSmrmIPCmN1rfMUStwQ==', N'0611486613', CAST(N'2000-02-02' AS Date), N'Hallo dit is mijn bio!', N'/uploads/profiles/e4bdcb42bae544e69efa1e28b520d369.jpg', 69, 420, CAST(N'2026-03-25T16:46:29.4040476' AS DateTime2), CAST(N'2026-03-25T16:46:29.4040476' AS DateTime2), 0)
INSERT [dbo].[accounts] ([account_id], [nickname], [first_name], [last_name], [email], [password_hash], [phone_number], [date_of_birth], [bio], [profile_picture_url], [karma], [events_reviewed_count], [created_at], [updated_at], [is_deleted]) VALUES (10, N'NielsT', N'Nq', N'NT', N'emailnt@dd.nl', N'AQAAAAIAAYagAAAAEAfwW9x33Uf/MiSuDSz2U61i6ydJWCwtDQL7xPvIs1fhMX/h0QsRgqCZhOhzlKLdTg==', N'0673294143', CAST(N'2026-04-04' AS Date), NULL, NULL, 0, 0, CAST(N'2026-03-31T10:17:53.3760289' AS DateTime2), CAST(N'2026-03-31T10:17:53.3760289' AS DateTime2), 0)
INSERT [dbo].[accounts] ([account_id], [nickname], [first_name], [last_name], [email], [password_hash], [phone_number], [date_of_birth], [bio], [profile_picture_url], [karma], [events_reviewed_count], [created_at], [updated_at], [is_deleted]) VALUES (11, N'Crispy', N'Winston', N'Dang', N'winstondang77@gmail.com', N'AQAAAAIAAYagAAAAEOoF+zg6EAiEZTK4ZWm0eL16ZWvmIt5RxizZST/Tygn7j37Q0u6NONwWZpSHdSihfQ==', N'0685361827', CAST(N'2026-04-03' AS Date), NULL, N'/uploads/profiles/d6422d52014d4f348aee85179dfb1836.png', 0, 0, CAST(N'2026-03-31T10:18:20.7457406' AS DateTime2), CAST(N'2026-03-31T10:18:20.7457406' AS DateTime2), 0)
SET IDENTITY_INSERT [dbo].[accounts] OFF
GO

SET IDENTITY_INSERT [dbo].[event_categories] ON 

INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (1, N'Pop', N'music_note')
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (2, N'Festival', NULL)
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (3, N'Kunst', N'paint_brush')
INSERT [dbo].[event_categories] ([category_id], [category_name], [icon_name]) VALUES (4, N'Historie', N'hourglass')

SET IDENTITY_INSERT [dbo].[event_categories] OFF
GO
SET IDENTITY_INSERT [dbo].[event_event_categories] ON 


INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (1, 1, N'https://upload.wikimedia.org/wikipedia/commons/a/a1/Pinpop_2010.jpeg?utm_source=en.wikipedia.org&utm_campaign=index&utm_content=thumbnail_unscaled', N'Pinkpop 2026', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (2, 2, N'', N'Liquicity Amsterdam 2026', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (3, 3, N'', N'Liquicity Festival 2026', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (4, 4, N'', N'Ra:dius Festival - Koningsdag', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (5, 5, N'', N'Park City Live 2026', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (6, 6, N'', N'Four times Two', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (7, 7, N'', N'The Studio #10: Eline Kersten', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (8, 8, N'', N'Het Gerechtigheidspaneel', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (9, 9, N'', NULL, 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (10, 10, N'', N'Charles Quaedvlieg (1823-1874) Schilder van Roma Sparita', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (11, 11, N'', N'Groepstentoonstelling We Live Here Too', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (12, 12, N'', N'Marta & Slava - Tentoonstelling Hidden Messages', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (13, 13, N'', N'Aad de Haas - Kasteel Strijthagen', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (15, 15, N'/uploads/events/amsterdam-dance-event.jpg', N'Amsterdam Dance Event', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (16, 16, N'', N'Cultura Nova', 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (17, 17, N'', NULL, 1, 1)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (18, 19, N'', NULL, 1, 0)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (19, 20, N'', NULL, 1, 0)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (20, 21, N'', NULL, 1, 0)
INSERT [dbo].[event_images] ([event_image_id], [event_id], [image_url], [alt_text], [is_primary], [sort_order]) VALUES (21, 22, N'', NULL, 1, 0)
GO
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (1, N'Regulier', CAST(155.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (2, N'Weekend', CAST(305.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (3, N'Regulier', CAST(37.00 AS Decimal(10, 2)), 2)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (4, N'Regulier', CAST(80.00 AS Decimal(10, 2)), 3)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (5, N'Weekend', CAST(185.00 AS Decimal(10, 2)), 3)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (6, N'nvt', NULL, 4)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (7, N'Dagticket', CAST(74.00 AS Decimal(10, 2)), 5)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (8, N'Weekend', CAST(124.50 AS Decimal(10, 2)), 5)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (9, N'DagticketJongeren', CAST(57.50 AS Decimal(10, 2)), 5)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (10, N'DagticketKind', CAST(10.00 AS Decimal(10, 2)), 5)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (11, N'Jongeren', CAST(0.00 AS Decimal(10, 2)), 6)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (12, N'Studenten', CAST(11.00 AS Decimal(10, 2)), 6)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (13, N'Regulier', CAST(22.00 AS Decimal(10, 2)), 6)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (14, N'Regulier', CAST(17.50 AS Decimal(10, 2)), 7)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (15, N'Student', CAST(8.75 AS Decimal(10, 2)), 7)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (16, N'Jongeren', CAST(0.00 AS Decimal(10, 2)), 7)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (17, N'Regulier', CAST(12.00 AS Decimal(10, 2)), 8)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (18, N'Museumkaart', CAST(0.00 AS Decimal(10, 2)), 8)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (19, N'Donatie', CAST(2.50 AS Decimal(10, 2)), 9)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (20, N'Volwassene', CAST(8.00 AS Decimal(10, 2)), 10)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (21, N'Kind', CAST(4.00 AS Decimal(10, 2)), 10)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (22, N'Regulier', CAST(15.00 AS Decimal(10, 2)), 11)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (23, N'Museumkaart', CAST(0.00 AS Decimal(10, 2)), 11)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (24, N'Regulier', CAST(15.00 AS Decimal(10, 2)), 12)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (25, N'Museumkaart', CAST(0.00 AS Decimal(10, 2)), 12)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (26, N'Regulier', CAST(10.00 AS Decimal(10, 2)), 13)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (28, N'Regulier', CAST(15.00 AS Decimal(10, 2)), 15)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (29, N'Main stage', CAST(20.00 AS Decimal(10, 2)), 15)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (30, N'VIP', CAST(45.00 AS Decimal(10, 2)), 15)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (31, N'ADE Pro Pass', CAST(60.00 AS Decimal(10, 2)), 15)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (32, N'Dagticket', CAST(80.00 AS Decimal(10, 2)), 15)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (33, N'Workshops', CAST(95.00 AS Decimal(10, 2)), 15)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (34, N'nvt', CAST(2.50 AS Decimal(10, 2)), 16)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (35, N'nvt', CAST(0.00 AS Decimal(10, 2)), 17)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (36, N'Vrijdag Ticket', CAST(55.95 AS Decimal(10, 2)), 18)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (37, N'Zaterdag Ticket', CAST(90.95 AS Decimal(10, 2)), 18)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (38, N'Zondag Ticket', CAST(65.95 AS Decimal(10, 2)), 18)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (39, N'2-Day Weekend Ticket', CAST(118.45 AS Decimal(10, 2)), 18)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (40, N'2-Day Weekend Ticket (zat + zon)', CAST(128.45 AS Decimal(10, 2)), 18)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (41, N'Full Weekend Ticket | Vrijdag, Zaterdag & Zondag', CAST(153.95 AS Decimal(10, 2)), 18)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (42, N'Residence Camping incl. Full Weekend Ticket | Vrijdag, Zaterdag & Zondag', CAST(193.95 AS Decimal(10, 2)), 18)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (43, N'Gratis', CAST(0.00 AS Decimal(10, 2)), 19)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (44, N'Gratis', CAST(0.00 AS Decimal(10, 2)), 20)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (45, N'Volwassene', CAST(10.27 AS Decimal(10, 2)), 21)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (46, N'Superleuke ticket', CAST(150.27 AS Decimal(10, 2)), 21)
INSERT [dbo].[event_ticket_prices] ([event_ticket_price_id], [ticket_type], [price], [event_id]) VALUES (47, N'digitaal', CAST(70.00 AS Decimal(10, 2)), 22)
GO
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (1, N'Pinkpop 2026', 2, 1, 1, 1, 1, 1, 1, N'Pinkpop is het meest iconische festival van Nederland. Al meer dan vijf decennia biedt het festival een podium aan absolute wereldsterren én de legendes van morgen, van The Rolling Stones en Metallica tot Justin Bieber en Olivia Rodrigo. Wat Pinkpop uniek maakt, is de gemoedelijke sfeer waarin generaties samenkomen en verschillende muziekstijlen elkaar vinden.

Daarnaast zijn er verspreid over het terrein ook kleinere feestjes en verrassende programma’s waar bezoekers de hele dag door van kunnen genieten. Het is een roze bubbel waarin grootse optredens en spontane momenten samen een onvergetelijk weekend vormen.

De 55e editie van Pinkpop vindt plaats van vrijdag 19 tot en met zondag 21 juni 2026 op Megaland in Landgraaf.', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (2, N'Liquicity Amsterdam 2026', 1, 1, 0, 0, 1, 1, 2, N'We’re back… and better than ever! Liquicity is returning to Lofi Amsterdam for an unforgettable day experience filled with the best drum & bass music, friends and endless vibes ??', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (3, N'Liquicity Festival 2026', 2, 1, 0, 1, 1, 1, 3, N'Celebrating ten years of Liquicity Festival!
3 unforgettable days packed with drum & bass. Just 40km from Amsterdam.', 1, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (4, N'Ra:dius Festival - Koningsdag', 2, 1, 0, NULL, NULL, NULL, 4, N'We are Ra:dius Festival. An electronic music festival based in Maastricht, the Netherlands.

Born from a desire for innovative and exciting festivals that dare to make a connection between music and art. Rooted in Maastricht and shaped by a tight circle of local creatives.

We are bringing local and (inter)national artists to our city, providing our visitors with a mix of the known and the unknown. Not only following the beaten track but also creating space to explore and discover new music and artists.

With the raw and industrial Radium Terrain as our base, each edition we redefine our theme and reimagine the space around it. Making sure that no edition is the same and that there is always room for exploration. ', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (5, N'Park City Live 2026', 2, 1, 1, 0, 1, 1, 5, N'Alles komt samen op ParkCity Live. De beleving van muziek, het mysterie van kunst & cultuur, aandacht voor ‘young talents’ en de verrassing van het onverwachte in één dynamisch openluchtfestival.', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (6, N'Four times Two', 1, 1, 1, 1, 1, 1, 6, N'Deze tentoonstelling legt bijzondere verbindingen tussen hedendaagse kunst uit de Collectie Bonnefanten en nodigt je uit om dit ook te doen.

Kunstwerk Tajiri als vertrekpunt
Het vierknopenkunstwerk Four times Two (1967) van de Japans-Amerikaanse kunstenaar Shinkichi Tajiri (1923-2009) vormt de aanleiding en het vertrekpunt voor deze collectiepresentatie, die een halve eeuw bestrijkt.

Verbinding, eenheid, tegenstellingen
In deze tentoonstelling toont elke zaal werk van telkens vier kunstenaars: evenveel als er knopen in Four times Two zitten. De werken zijn heel divers wat betreft ontstaansperiode, onderwerp, thema of hoe ze eruitzien. 

De vraag is dan ook wat ze met elkaar gemeen hebben. Iedereen kijkt weer anders, legt andere verbanden, en kunst toont door de tijd andere en nieuwe perspectieven. 

De tentoonstelling is vooral een uitnodiging om zelf op zoek te gaan naar onderliggende ideeën, emoties, boodschappen of symboliek die deze kunst, over tijd en culturele verschillen heen, met elkaar en met jou verbindt. 

Met werk van onder andere: 
Francis Alÿs.
Paul Chan.
Peter Doig.
Mary Heilmann.
Thomas Hirschhorn.
Suchan Kinoshita.
Jos Kruit.
Charlotte Lagro.
Sol LeWitt.
Laura Owens.
Carol Rhodes.
Lydia Schouten.
Shinkichi Tajiri.
Sanne Vaassen.
Paloma Varga Weisz.', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (7, N'The Studio #10: Eline Kersten', 1, 1, 1, 1, 1, 1, 6, N'The Studio #10: Eline Kersten
Wanneer onze leefomgeving verandert of verdwijnt, wat betekent dat voor ons als mens? Eline Kersten onderzoekt deze vraag. Kersten heeft een bijzondere fascinatie voor veranderende landschappen. Haar werk belicht hoe klimaatverandering ons raakt, van smeltende gletsjers tot natuurbranden. Ze werkt daarbij vaak samen met klimaatwetenschappers, componisten en brandweerlieden.

Glazen tijdcapsules
In The Studio #10 toont ze handgeblazen glassculpturen gevuld met vloeistof: gesmolten gletsjerwater van meer dan honderdduizend jaar oud, opgeboord in Groenland en Antarctica. In samenwerking met gletsjerwetenschapper Michaela Mühl geeft Kersten zo een nieuwe, verbeeldende blik op verdwijnende gletsjers.

Vuur als kracht
Kersten onderzoekt ook natuurbranden en laat zien hoe vuur zowel vernietigt als creëert. In de zeefdrukserie All that remains (2025) gebruikt ze houtskool uit voormalige brandgebieden in België, Nederland en Zwitserland. In Life, by any other name (2025) brengt ze verkoold hout tot leven en toont ze de kracht van verwoesting én herstel.

Over de kunstenaar
Eline Kersten studeerde Fine Arts in Maastricht en Curating aan Goldsmiths, University of London. Ze maakt films, installaties, sculpturen, prints en kunstenaarsboeken. In 2025 ontving ze het Limburg Beeldende Kunst (LBK) Stipendium, inclusief een residentie aan de Jan van Eyck Academie en deze solopresentatie in Bonnefanten.', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (8, N'Het Gerechtigheidspaneel', 1, 1, 1, 1, 1, 1, 7, N'In de late middeleeuwen kregen rechtszalen vaak een schildering die rechters eraan herinnerde: spreek eerlijk recht. Het indrukwekkende Gerechtigheidspaneel (ca. 1475–1477), gemaakt door Jan van Brussel, hing ooit in de raadkamer van Maastricht. Bovenaan zie je het Laatste Oordeel: Christus als rechter op een gouden regenboog, omringd door engelen die de doden wekken. Daaronder een rechtszitting: een rijke en een arme man staan tegenover elkaar, terwijl een duivel de rechters probeert om te kopen. De aartsengel Michaël wijst streng naar de hel – een duidelijke waarschuwing voor wie zich laat verleiden.

Dit paneel is bijzonder: het is een van de oudste voorstellingen van een rechtszitting in West-Europa. Het hing waarschijnlijk eerst in het Dinghuis, het gerechtsgebouw van Maastricht, en later in het Stadhuis. De boodschap is tijdloos: wie recht spreekt, draagt een zware verantwoordelijkheid.', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (9, N'Lammetjesdagen Schaapskooi Mergelland', 2, 1, 1, 1, NULL, 0, 8, N'Tijdens de lammetjesdagen kunnen bezoekers de lammetjes bezoeken in de stallen van de schaapskooi. En natuurlijk kunnen de kinderen de lammetjes aaien & flesjes geven!
 
Op het terrein van de schaapskooi is nu een nieuwe “beleefroute” geopend. Tijdens een wandeling maken bezoekers op een interactieve manier kennis met de schapen, de herder en de herdershonden. Door de ogen van lammetje Sofie leren ze alles over het bijzondere werk van de schapen van Schaapskooi Mergelland.
 
De route biedt informatie voor zowel kinderen als volwassenen, waardoor het een leuk en leerzaam uitje is voor jong en oud!
 
De beleefroute is geopend van 31 januari tot en met 12 april, elke zaterdag, zondag en woensdagmiddag (woensdag 18 februari geopend van 11.00-17.00 uur). De entree bedraagt €7,50 voor volwassenen en €5,00 voor kinderen. Koffie en limonade zijn inbegrepen. Openingstijden: zaterdag en zondag van 11:00 tot 17:00 uur, woensdag van 13:00 tot 17:00 uur.', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (10, N'Charles Quaedvlieg (1823-1874) Schilder van Roma Sparita', 1, 1, 1, 1, 1, 1, 9, N'Museum Valkenburg presenteert de eerste tentoonstelling over het leven en werk van de in Nederland vrijwel onbekende schilder Charles Quaedvlieg.
Charles Quaedvlieg

Hoewel Charles Quaedvlieg (1823–1874) vergeten is in zijn geboortestreek Valkenburg, verwierf hij in de 19e eeuw in Rome grote bekendheid. Hij is daar nog steeds een bekend schilder. Charles werkte enige jaren voor Prinses Marianne van Oranje Nassau. Hij schilderde onder meer stadgezichten, genrestukken en het landleven in de omgeving Rome.
Tentoonstelling

Er worden ruim twintig schilderijen en tal van documenten getoond, uit particuliere Limburgse collecties en musea in binnen- en buitenland, die grotendeels nooit eerder te zien zijn geweest. De tentoonstelling weerspiegelt, door middel van een educatief onderdeel, ook de politieke en sociale veranderingen van zijn tijd, met nadruk op de Italiaanse eenwording. De kunstenaar wordt geplaatst in de context van de internationale kunstenaarsgemeenschap in Rome.', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (11, N'Groepstentoonstelling We Live Here Too', 1, 1, 1, 1, 1, 1, 10, N'We Live Here Too is een groepstentoonstelling waarin acht kunstenaars door de ogen van dieren naar de wereld kijken. Van ijsvogels tot microben, hun werken vertellen verhalen over landbouw, toerisme, energiewinning en bio-industrie.
Mens en dier

Buitenplaats Kasteel Wijlre opent op 31 augustus 2025 We Live Here Too: een nieuwe groepstentoonstelling die de relatie tussen mens en dier onderzoekt vanuit onverwachte perspectieven. Acht kunstenaars kijken door de ogen van de dieren die de buitenplaats bewonen en omringen, en verbeelden zo de wereld zoals die zich aan hen toont. Hun werken – variërend van video en installaties tot sculpturen en schilderijen – maken de invloed van ons handelen op dieren tastbaar.
De tentoonstelling

In We Live Here Too kijken acht kunstenaars door de ogen van de dieren die de buitenplaats bewonen en omringen. Van ijsvogels tot paarden, koeien en zilverreigers, tot insecten en zelfs microben. De kunstenaars zijn geïnteresseerd in hoe de dieren hun verhouding met de mens ervaren. Er vindt een perspectiefwisseling plaats: hoe gaan dieren om met de gewoonte van de mens om de natuur naar zijn hand te zetten? Hoe ervaren zij de druk op het landschap, veroorzaakt door de menselijke neiging tot consumptie en extractie? In hoeverre kan de stilte van de dieren als instemming worden geïnterpreteerd?

De tentoonstelling brengt videowerken, installaties, sculpturen, schilderijen en tekeningen samen – soms met letterlijk levend materiaal. We Live Here Too is een verhaal over Limburg, Nederland en de planeet anno nu. Een tentoonstelling over het landschap dat mensen delen met dieren en over de onmogelijke poging een dier volledig te vatten.
Kunstenaars

We Live Here Too is samengesteld door gastcurator Lieneke Hulshof (1993, Winterswijk), bekend om haar projecten in verschillende Nederlandse landschappen waarin de relatie tussen mens en natuur, traditie en verandering centraal staan. In de tentoonstelling is nieuw en recent werk te zien van Taqwa Ali (SD, 1997), Mounir Eddib (BE, 1995), Vibeke Mascini (NL, 1989), Stef Veldhuis (NL, 1992), Jori(k) Galama (NL, 1992), Bart Houwers (NL, 1997), Juul Kraijer (NL, 1970) en Janis Rafa (GR, 1984).', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (12, N'Marta & Slava - Tentoonstelling Hidden Messages', 1, 1, 1, 1, 1, 1, 10, N'Marta & Slava onderzoeken met hun werk hoe planten signalen uitzenden naar mensen en scheppen een fictieve wereld rond het Mandragora Instituut. Met schilderijen, tekeningen, sculpturen en installaties tonen ze hoe natuur en cultuur bondgenoten kunnen zijn in het denken over onze toekomst.
Marta & Slave

Buitenplaats Kasteel Wijlre toont vanaf 31 augustus 2025 Hidden Messages: een nieuwe tentoonstelling van het kunstenaarsduo Marta & Slava. In hun werk, op het snijvlak van realiteit en fictie, onderzoeken zij de verborgen interacties tussen natuur en mens. Met schilderijen, tekeningen, sculpturen en installaties schept het duo fictieve werelden, waarin speelse ironie samengaat met eruditie en een vleug melancholie.
Hidden Messages

Voor Hidden Messages creëert kunstenaarsduo Marta & Slava (voluit Marta Volkova & Slava Shevelenko) een samenhangende reeks nieuwe werken, van vazen en tekeningen tot sculpturen en architectonische schaalmodellen, die de geschiedenis van het mysterieuze, fictieve Mandragora Instituut tot leven brengen. Volgens Marta & Slava (1955 resp. 1953, St. Petersburg) onderzoekt dit mysterieuze instituut hoe planten signalen uitzenden naar mensen, geïnspireerd door recent wetenschappelijk onderzoek dat laat zien dat sommige planten en bloemen via het ultraviolette spectrum communiceren met insecten. In hun verbeelding reikt dit contact verder: naast insecten en ander meer-dan-menselijk leven, proberen planten ook in contact met de mensheid te komen.
Boodschappen

In een tijd waarin zowel cultuur als natuur onder druk staan, laat Hidden Messages zien hoe beide elkaar kunnen ondersteunen – en zelfs bondgenoten kunnen worden – in het werken aan een duurzame toekomst voor onze planeet. Wat zou er gebeuren als we de natuur écht zouden observeren en beluisteren? Welke verborgen boodschappen zouden we dan ontdekken?
Koetshuis

Het werk van het in Maastricht wonende en werkende kunstenaarsduo Marta & Slava is te zien in het Koetshuis, en in het bos van de buitenplaats. Het werk van Marta & Slava wordt gekenmerkt door een interesse in wereldgeschiedenis, politiek en wetenschap en is doortrokken van een onbestemde melancholie.', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (13, N'Aad de Haas - Kasteel Strijthagen', 1, 1, 1, 1, 1, 1, 11, N'Ontdek Aad de Haas (1920–1972) in Kasteel Strijthagen: werk uit Strijthagen en de Staatsmijnen-collectie, foto’s van het kasteel en intieme schilderijen.
Aad de Haas

Ontdek het werk en leven van Aad de Haas (1920–1972), die woonde en werkte op Kasteel Strijthagen in de Limburgse mijnstreek, waar de mijnen het dagelijks leven beïnvloedden. Dankzij de steun van onder anderen Bertus Aafjes en Antoon Duinkerken kon hij zich daar als kunstenaar vestigen, een periode van rust en waardering na eerdere tegenwerking door de Duitse bezetter, de Rooms-Katholieke Kerk en kunstcritici.
Strijthagen

De tentoonstelling toont zijn werk uit Strijthagen, de voormalige Staatsmijnen-collectie (nu onderdeel van de Aad de Haas-collectie van SCHUNCK), foto’s van het kasteel en artistieke verbeeldingen van Aad en zijn echtgenote, en enkele latere, intiemere schilderijen die een blik geven op zijn laatste levensjaren. Ter gelegenheid van zijn honderdste verjaardag bracht SCHUNCK in 2020 een nieuwe publicatie uit over zijn werk, persoon en tijdsgeest, verkrijgbaar in de museumshop.', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (15, N'Amsterdam Dance Event', 3, 1, NULL, 1, 1, 1, 13, N'Amsterdam Dance Event (ADE) is the most upfront, influential and educational gathering for electronic music and its industry. With its conference, festival and educational breeding ground, ADE is able to create not only the biggest yearly industry tent-pole moment, but also a solid foundation for future generations of electronic music professionals. The event exists of a total of more than 1,200 events in 300+ locations across its multidisciplinary program of five days and nights. With a record number of 600.000 visitors and 11.000 music professionals in 2025, during ADE Amsterdam truly breathes electronic music.

ADE is organised by the Amsterdam Dance Event Foundation, a not-for-profit organisation dedicated to nurturing electronic music, its culture and its industry worldwide. The organisation devotes itself to stimulating development, innovation and talent, gathering the global industry and laying a foundation for future generations.', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (16, N'Cultura Nova', 3, 1, 1, NULL, 1, 1, 14, N'Van 29 augustus t/m 7 september 2025 kleurde Cultura Nova Parkstad tien dagen lang met theater, circus, muziek, dans en beeldende kunst. Pleinen veranderden in podia, onverwachte plekken in magische speellocaties, en tienduizenden bezoekers uit de hele regio én ver daarbuiten lieten zich verrassen door een veelzijdig programma. 

De volgende editie vindt plaats van vrijdag 28 augustus t/m zondag 6 september 2026: zet het vast in je agenda!', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (17, N'Lichtstoet Heerlen', 2, 1, 0, NULL, NULL, NULL, 15, N'Lichtstoet Heerlen is een verlichte Carnavalsoptocht die jaarlijks op de Dinsdagavond van de Carnaval door het centrum van Heerlen trekt.

Deze stoet wordt jaarlijks georganiseerd door de Organisatie Lichtstoet Heerlen en trekt ieder jaar weer meer deelnemers en toeschouwers, een evenement dat dus ieder jaar weer groeit. In principe kan/mag iedereen deelnemen aan deze optocht grote wagens, kleine wagens, prinsenwagens, raadswagens, loopgroepen, sjpasskapellen, enz… maar omdat deze optocht in de avond door Heerlen-Centrum trekt is het vereist om uw wagen/groep voorzien te hebben van licht doormiddel van lichtslangen, goedgekeurde kerstverlichting voor buiten, enz… Laat uw fantasie maar in de vrije loop en maak er iets moois van, maar houdt de veiligheid natuurlijk wel op de eerste plaats.

De praalwagens en lichteffecten op Carnavalsdinsdag in Heerlen trekken jaarlijks 10.000 bezoekers. En dat terwijl er géén entree gevraagd wordt. Komt u gerust een keer kijken en ervaar het zelf! Jaarlijks zijn zo’n 55 groepen en wagens te zien. Nog 1 keer vele verlichte Carnavalswagens zien die verlicht door het centrum van Heerlen trekken voordat ze weer de stalling ingaan en/of afgebroken worden.

De komende editie vindt plaats op Dinsdag 17 februari 2026
.', NULL, 0)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (18, N'REBiRTH Festival 2026 · Journey Beyond Borders', 2, 1, 0, 0, 0, 0, 16, N'For nearly two decades, REBiRTH Festival has been the undisputed start of the festival season. It is where all harder styles fanatics come together once again after a long winter, as months of bottled-up energy finally erupt into a tidal wave of sound, sunlight and pure adrenaline.

Those who''ve experienced the kick off of the summer season know it’s more than a beginning; it’s a declaration. And in 2026, we take that momentum global. :earth_americas:

This year’s theme, Journey Beyond Borders, transforms REBiRTH into a musical world tour: no passport required!

From the grandeur of New York’s theatrical skyline to the neon-lit streets of Tokyo, and from the desert wind that whispers through Cairo''s hidden alleyways to the inferno that awaits in Shanghai''s dragon temple — you''ll set foot into a wild cityscape where every detail echoes the sound of our worldwide journey.

Across three unforgettable days, you can expect non-stop madness at the REBiRTH Residence campsite. Witness your favourite artists, explosive premieres, exclusive showcases and unexpected clashes, spread across our immersive indoor and outdoor areas. Each stage drops you into the heart of a different city, each one tuned to the heartbeat of a different sound.

REBiRTH Festival 2026 invites you on a Journey Beyond Borders. A journey where our love for harder styles music is the universal language and the key to unite us all.

See you all on April 10, 11 & 12!', NULL, 1)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (19, N'Verjaardag Maurice', 3, 0, 0, 0, 0, 0, 17, N'Maurice is jarig! Kom eens langs en eet een zakje friet.', 1, 1)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (20, N'Test Event', 2, 0, 0, 0, 0, 0, 18, N'Gekke man heeft sex afspraakje waar je naar mag komen loeren, check ff of je komt naar dit adres.', 1, 1)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (21, N'Camille''s superleuke event', 3, 1, 0, 1, 0, 1, 19, N'Camille''s superleuke event is superleuk', 1, 1)
INSERT [dbo].[events] ([event_id], [event_name], [indoors_outdoors], [has_standing_places], [has_sitting_places], [disabled_parking_available], [disabled_toilet_available], [wheelchair_accessible_toilet], [location_id], [description], [organiser_id], [canceled]) VALUES (22, N'kaasfeest', 1, 1, 1, 0, 1, 1, 20, N'kaas van de maan te zien plus rattaoloiie', 1, 0)
GO
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (18, CAST(-37.193696 AS Decimal(9, 6)), CAST(145.097810 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (17, CAST(-19.785083 AS Decimal(9, 6)), CAST(47.195539 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (13, CAST(4.893610 AS Decimal(9, 6)), CAST(52.372700 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (8, CAST(5.077484 AS Decimal(9, 6)), CAST(59.137300 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (10, CAST(5.083021 AS Decimal(9, 6)), CAST(58.917400 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (6, CAST(5.084254 AS Decimal(9, 6)), CAST(57.019000 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (7, CAST(5.084602 AS Decimal(9, 6)), CAST(57.011600 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (4, CAST(5.085629 AS Decimal(9, 6)), CAST(56.825800 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (9, CAST(5.086376 AS Decimal(9, 6)), CAST(58.321500 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (12, CAST(5.087023 AS Decimal(9, 6)), CAST(57.975600 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (5, CAST(5.087959 AS Decimal(9, 6)), CAST(59.825600 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (1, CAST(5.087990 AS Decimal(9, 6)), CAST(60.222500 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (14, CAST(5.088660 AS Decimal(9, 6)), CAST(59.728600 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (11, CAST(5.088783 AS Decimal(9, 6)), CAST(59.793300 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (2, CAST(5.239118 AS Decimal(9, 6)), CAST(48.242500 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (3, CAST(5.269329 AS Decimal(9, 6)), CAST(47.434000 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (15, CAST(5.973500 AS Decimal(9, 6)), CAST(50.887700 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (19, CAST(50.000000 AS Decimal(9, 6)), CAST(5.000000 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (20, CAST(51.221170 AS Decimal(9, 6)), CAST(4.398042 AS Decimal(9, 6)))
INSERT [dbo].[locations] ([location_id], [latitude], [longitude]) VALUES (16, CAST(51.613870 AS Decimal(9, 6)), CAST(5.216300 AS Decimal(9, 6)))
GO
SET IDENTITY_INSERT [dbo].[organiser_accounts] ON 

/** Insert a new organiser account with hashed password "TestAccount" **/
INSERT [dbo].[organiser_accounts] ([organiser_account_id], [contact_name], [email], [password_hash], [is_active], [created_at], [organiser_id]) VALUES (1, N'Test', N'test@example.com', N'AQAAAAIAAYagAAAAEJhGdcZ7YhsM2SQZIBDuz49D3midKLKSIv5aUdUrG/Bk/HZWIwdvTsCMkpE+j3bgtg==', 1, CAST(N'2026-04-13T11:49:22.5780383' AS DateTime2), 1)

SET IDENTITY_INSERT [dbo].[organiser_accounts] OFF
GO
INSERT [dbo].[organisers] ([organiser_id], [company_name], [is_active], [created_at]) VALUES (1, N'Strange Minds Division', 1, CAST(N'2026-04-07T12:05:59.4889372' AS DateTime2))
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