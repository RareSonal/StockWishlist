USE [master]
GO
/****** Object:  Database [stockwishlist]    Script Date: 04-05-2025 01:45:55 ******/
CREATE DATABASE [stockwishlist]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'stockwishlist', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\stockwishlist.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'stockwishlist_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\stockwishlist_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [stockwishlist] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [stockwishlist].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [stockwishlist] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [stockwishlist] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [stockwishlist] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [stockwishlist] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [stockwishlist] SET ARITHABORT OFF 
GO
ALTER DATABASE [stockwishlist] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [stockwishlist] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [stockwishlist] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [stockwishlist] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [stockwishlist] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [stockwishlist] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [stockwishlist] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [stockwishlist] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [stockwishlist] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [stockwishlist] SET  DISABLE_BROKER 
GO
ALTER DATABASE [stockwishlist] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [stockwishlist] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [stockwishlist] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [stockwishlist] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [stockwishlist] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [stockwishlist] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [stockwishlist] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [stockwishlist] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [stockwishlist] SET  MULTI_USER 
GO
ALTER DATABASE [stockwishlist] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [stockwishlist] SET DB_CHAINING OFF 
GO
ALTER DATABASE [stockwishlist] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [stockwishlist] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [stockwishlist] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [stockwishlist] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [stockwishlist] SET QUERY_STORE = OFF
GO
USE [stockwishlist]
GO
/****** Object:  Table [dbo].[Stocks]    Script Date: 04-05-2025 01:45:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stocks](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[quantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 04-05-2025 01:45:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Wishlist]    Script Date: 04-05-2025 01:45:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wishlist](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[stock_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Stocks] ON 
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (1, N'Apple Inc.', 50)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (2, N'Microsoft Corporation', 219)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (3, N'Alphabet Inc. (Google)', 439)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (4, N'Amazon.com Inc.', 410)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (5, N'Tesla Inc.', 424)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (6, N'Meta Platforms Inc. (Facebook)', 138)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (7, N'NVIDIA Corporation', 330)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (8, N'Berkshire Hathaway Inc.', 486)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (9, N'Visa Inc.', 57)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (10, N'Johnson & Johnson', 37)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (11, N'UnitedHealth Group', 60)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (12, N'JPMorgan Chase & Co.', 173)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (13, N'Mastercard Inc.', 318)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (14, N'Procter & Gamble Co.', 35)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (15, N'Home Depot Inc.', 500)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (16, N'Pfizer Inc.', 338)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (17, N'Coca-Cola Company', 160)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (18, N'PepsiCo Inc.', 432)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (19, N'Adobe Inc.', 270)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (20, N'Netflix Inc.', 182)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (21, N'Exxon Mobil Corporation', 269)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (22, N'Walmart Inc.', 371)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (23, N'Walt Disney Company', 107)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (24, N'Salesforce Inc.', 166)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (25, N'Intel Corporation', 78)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (26, N'Cisco Systems Inc.', 18)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (27, N'Oracle Corporation', 204)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (28, N'Qualcomm Inc.', 16)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (29, N'AT&T Inc.', 289)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (30, N'Verizon Communications', 401)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (31, N'Chevron Corporation', 363)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (32, N'Boeing Company', 317)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (33, N'McDonald’s Corporation', 387)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (34, N'AbbVie Inc.', 184)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (35, N'IBM Corporation', 470)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (36, N'American Express', 453)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (37, N'3M Company', 102)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (38, N'Costco Wholesale', 163)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (39, N'Starbucks Corporation', 368)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (40, N'Nike Inc.', 44)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (41, N'Ford Motor Company', 367)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (42, N'General Motors', 409)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (43, N'Zoom Video Communications', 351)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (44, N'Snowflake Inc.', 165)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (45, N'Shopify Inc.', 139)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (46, N'Palantir Technologies', 19)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (47, N'Roku Inc.', 2)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (48, N'Uber Technologies', 222)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (49, N'Airbnb Inc.', 485)
GO
INSERT [dbo].[Stocks] ([id], [name], [quantity]) VALUES (50, N'Block Inc. (Square)', 28)
GO
SET IDENTITY_INSERT [dbo].[Stocks] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 
GO
INSERT [dbo].[Users] ([id]) VALUES (1)
GO
INSERT [dbo].[Users] ([id]) VALUES (2)
GO
INSERT [dbo].[Users] ([id]) VALUES (3)
GO
INSERT [dbo].[Users] ([id]) VALUES (4)
GO
INSERT [dbo].[Users] ([id]) VALUES (5)
GO
INSERT [dbo].[Users] ([id]) VALUES (6)
GO
INSERT [dbo].[Users] ([id]) VALUES (7)
GO
INSERT [dbo].[Users] ([id]) VALUES (8)
GO
INSERT [dbo].[Users] ([id]) VALUES (9)
GO
INSERT [dbo].[Users] ([id]) VALUES (10)
GO
INSERT [dbo].[Users] ([id]) VALUES (11)
GO
INSERT [dbo].[Users] ([id]) VALUES (12)
GO
INSERT [dbo].[Users] ([id]) VALUES (13)
GO
INSERT [dbo].[Users] ([id]) VALUES (14)
GO
INSERT [dbo].[Users] ([id]) VALUES (15)
GO
INSERT [dbo].[Users] ([id]) VALUES (16)
GO
INSERT [dbo].[Users] ([id]) VALUES (17)
GO
INSERT [dbo].[Users] ([id]) VALUES (18)
GO
INSERT [dbo].[Users] ([id]) VALUES (19)
GO
INSERT [dbo].[Users] ([id]) VALUES (20)
GO
INSERT [dbo].[Users] ([id]) VALUES (21)
GO
INSERT [dbo].[Users] ([id]) VALUES (22)
GO
INSERT [dbo].[Users] ([id]) VALUES (23)
GO
INSERT [dbo].[Users] ([id]) VALUES (24)
GO
INSERT [dbo].[Users] ([id]) VALUES (25)
GO
INSERT [dbo].[Users] ([id]) VALUES (26)
GO
INSERT [dbo].[Users] ([id]) VALUES (27)
GO
INSERT [dbo].[Users] ([id]) VALUES (28)
GO
INSERT [dbo].[Users] ([id]) VALUES (29)
GO
INSERT [dbo].[Users] ([id]) VALUES (30)
GO
INSERT [dbo].[Users] ([id]) VALUES (31)
GO
INSERT [dbo].[Users] ([id]) VALUES (32)
GO
INSERT [dbo].[Users] ([id]) VALUES (33)
GO
INSERT [dbo].[Users] ([id]) VALUES (34)
GO
INSERT [dbo].[Users] ([id]) VALUES (35)
GO
INSERT [dbo].[Users] ([id]) VALUES (36)
GO
INSERT [dbo].[Users] ([id]) VALUES (37)
GO
INSERT [dbo].[Users] ([id]) VALUES (38)
GO
INSERT [dbo].[Users] ([id]) VALUES (39)
GO
INSERT [dbo].[Users] ([id]) VALUES (40)
GO
INSERT [dbo].[Users] ([id]) VALUES (41)
GO
INSERT [dbo].[Users] ([id]) VALUES (42)
GO
INSERT [dbo].[Users] ([id]) VALUES (43)
GO
INSERT [dbo].[Users] ([id]) VALUES (44)
GO
INSERT [dbo].[Users] ([id]) VALUES (45)
GO
INSERT [dbo].[Users] ([id]) VALUES (46)
GO
INSERT [dbo].[Users] ([id]) VALUES (47)
GO
INSERT [dbo].[Users] ([id]) VALUES (48)
GO
INSERT [dbo].[Users] ([id]) VALUES (49)
GO
INSERT [dbo].[Users] ([id]) VALUES (50)
GO
INSERT [dbo].[Users] ([id]) VALUES (51)
GO
INSERT [dbo].[Users] ([id]) VALUES (52)
GO
INSERT [dbo].[Users] ([id]) VALUES (53)
GO
INSERT [dbo].[Users] ([id]) VALUES (54)
GO
INSERT [dbo].[Users] ([id]) VALUES (55)
GO
INSERT [dbo].[Users] ([id]) VALUES (56)
GO
INSERT [dbo].[Users] ([id]) VALUES (57)
GO
INSERT [dbo].[Users] ([id]) VALUES (58)
GO
INSERT [dbo].[Users] ([id]) VALUES (59)
GO
INSERT [dbo].[Users] ([id]) VALUES (60)
GO
INSERT [dbo].[Users] ([id]) VALUES (61)
GO
INSERT [dbo].[Users] ([id]) VALUES (62)
GO
INSERT [dbo].[Users] ([id]) VALUES (63)
GO
INSERT [dbo].[Users] ([id]) VALUES (64)
GO
INSERT [dbo].[Users] ([id]) VALUES (65)
GO
INSERT [dbo].[Users] ([id]) VALUES (66)
GO
INSERT [dbo].[Users] ([id]) VALUES (67)
GO
INSERT [dbo].[Users] ([id]) VALUES (68)
GO
INSERT [dbo].[Users] ([id]) VALUES (69)
GO
INSERT [dbo].[Users] ([id]) VALUES (70)
GO
INSERT [dbo].[Users] ([id]) VALUES (71)
GO
INSERT [dbo].[Users] ([id]) VALUES (72)
GO
INSERT [dbo].[Users] ([id]) VALUES (73)
GO
INSERT [dbo].[Users] ([id]) VALUES (74)
GO
INSERT [dbo].[Users] ([id]) VALUES (75)
GO
INSERT [dbo].[Users] ([id]) VALUES (76)
GO
INSERT [dbo].[Users] ([id]) VALUES (77)
GO
INSERT [dbo].[Users] ([id]) VALUES (78)
GO
INSERT [dbo].[Users] ([id]) VALUES (79)
GO
INSERT [dbo].[Users] ([id]) VALUES (80)
GO
INSERT [dbo].[Users] ([id]) VALUES (81)
GO
INSERT [dbo].[Users] ([id]) VALUES (82)
GO
INSERT [dbo].[Users] ([id]) VALUES (83)
GO
INSERT [dbo].[Users] ([id]) VALUES (84)
GO
INSERT [dbo].[Users] ([id]) VALUES (85)
GO
INSERT [dbo].[Users] ([id]) VALUES (86)
GO
INSERT [dbo].[Users] ([id]) VALUES (87)
GO
INSERT [dbo].[Users] ([id]) VALUES (88)
GO
INSERT [dbo].[Users] ([id]) VALUES (89)
GO
INSERT [dbo].[Users] ([id]) VALUES (90)
GO
INSERT [dbo].[Users] ([id]) VALUES (91)
GO
INSERT [dbo].[Users] ([id]) VALUES (92)
GO
INSERT [dbo].[Users] ([id]) VALUES (93)
GO
INSERT [dbo].[Users] ([id]) VALUES (94)
GO
INSERT [dbo].[Users] ([id]) VALUES (95)
GO
INSERT [dbo].[Users] ([id]) VALUES (96)
GO
INSERT [dbo].[Users] ([id]) VALUES (97)
GO
INSERT [dbo].[Users] ([id]) VALUES (98)
GO
INSERT [dbo].[Users] ([id]) VALUES (99)
GO
INSERT [dbo].[Users] ([id]) VALUES (100)
GO
INSERT [dbo].[Users] ([id]) VALUES (101)
GO
INSERT [dbo].[Users] ([id]) VALUES (102)
GO
INSERT [dbo].[Users] ([id]) VALUES (103)
GO
INSERT [dbo].[Users] ([id]) VALUES (104)
GO
INSERT [dbo].[Users] ([id]) VALUES (105)
GO
INSERT [dbo].[Users] ([id]) VALUES (106)
GO
INSERT [dbo].[Users] ([id]) VALUES (107)
GO
INSERT [dbo].[Users] ([id]) VALUES (108)
GO
INSERT [dbo].[Users] ([id]) VALUES (109)
GO
INSERT [dbo].[Users] ([id]) VALUES (110)
GO
INSERT [dbo].[Users] ([id]) VALUES (111)
GO
INSERT [dbo].[Users] ([id]) VALUES (112)
GO
INSERT [dbo].[Users] ([id]) VALUES (113)
GO
INSERT [dbo].[Users] ([id]) VALUES (114)
GO
INSERT [dbo].[Users] ([id]) VALUES (115)
GO
INSERT [dbo].[Users] ([id]) VALUES (116)
GO
INSERT [dbo].[Users] ([id]) VALUES (117)
GO
INSERT [dbo].[Users] ([id]) VALUES (118)
GO
INSERT [dbo].[Users] ([id]) VALUES (119)
GO
INSERT [dbo].[Users] ([id]) VALUES (120)
GO
INSERT [dbo].[Users] ([id]) VALUES (121)
GO
INSERT [dbo].[Users] ([id]) VALUES (122)
GO
INSERT [dbo].[Users] ([id]) VALUES (123)
GO
INSERT [dbo].[Users] ([id]) VALUES (124)
GO
INSERT [dbo].[Users] ([id]) VALUES (125)
GO
INSERT [dbo].[Users] ([id]) VALUES (126)
GO
INSERT [dbo].[Users] ([id]) VALUES (127)
GO
INSERT [dbo].[Users] ([id]) VALUES (128)
GO
INSERT [dbo].[Users] ([id]) VALUES (129)
GO
INSERT [dbo].[Users] ([id]) VALUES (130)
GO
INSERT [dbo].[Users] ([id]) VALUES (131)
GO
INSERT [dbo].[Users] ([id]) VALUES (132)
GO
INSERT [dbo].[Users] ([id]) VALUES (133)
GO
INSERT [dbo].[Users] ([id]) VALUES (134)
GO
INSERT [dbo].[Users] ([id]) VALUES (135)
GO
INSERT [dbo].[Users] ([id]) VALUES (136)
GO
INSERT [dbo].[Users] ([id]) VALUES (137)
GO
INSERT [dbo].[Users] ([id]) VALUES (138)
GO
INSERT [dbo].[Users] ([id]) VALUES (139)
GO
INSERT [dbo].[Users] ([id]) VALUES (140)
GO
INSERT [dbo].[Users] ([id]) VALUES (141)
GO
INSERT [dbo].[Users] ([id]) VALUES (142)
GO
INSERT [dbo].[Users] ([id]) VALUES (143)
GO
INSERT [dbo].[Users] ([id]) VALUES (144)
GO
INSERT [dbo].[Users] ([id]) VALUES (145)
GO
INSERT [dbo].[Users] ([id]) VALUES (146)
GO
INSERT [dbo].[Users] ([id]) VALUES (147)
GO
INSERT [dbo].[Users] ([id]) VALUES (148)
GO
INSERT [dbo].[Users] ([id]) VALUES (149)
GO
INSERT [dbo].[Users] ([id]) VALUES (150)
GO
INSERT [dbo].[Users] ([id]) VALUES (151)
GO
INSERT [dbo].[Users] ([id]) VALUES (152)
GO
INSERT [dbo].[Users] ([id]) VALUES (153)
GO
INSERT [dbo].[Users] ([id]) VALUES (154)
GO
INSERT [dbo].[Users] ([id]) VALUES (155)
GO
INSERT [dbo].[Users] ([id]) VALUES (156)
GO
INSERT [dbo].[Users] ([id]) VALUES (157)
GO
INSERT [dbo].[Users] ([id]) VALUES (158)
GO
INSERT [dbo].[Users] ([id]) VALUES (159)
GO
INSERT [dbo].[Users] ([id]) VALUES (160)
GO
INSERT [dbo].[Users] ([id]) VALUES (161)
GO
INSERT [dbo].[Users] ([id]) VALUES (162)
GO
INSERT [dbo].[Users] ([id]) VALUES (163)
GO
INSERT [dbo].[Users] ([id]) VALUES (164)
GO
INSERT [dbo].[Users] ([id]) VALUES (165)
GO
INSERT [dbo].[Users] ([id]) VALUES (166)
GO
INSERT [dbo].[Users] ([id]) VALUES (167)
GO
INSERT [dbo].[Users] ([id]) VALUES (168)
GO
INSERT [dbo].[Users] ([id]) VALUES (169)
GO
INSERT [dbo].[Users] ([id]) VALUES (170)
GO
INSERT [dbo].[Users] ([id]) VALUES (171)
GO
INSERT [dbo].[Users] ([id]) VALUES (172)
GO
INSERT [dbo].[Users] ([id]) VALUES (173)
GO
INSERT [dbo].[Users] ([id]) VALUES (174)
GO
INSERT [dbo].[Users] ([id]) VALUES (175)
GO
INSERT [dbo].[Users] ([id]) VALUES (176)
GO
INSERT [dbo].[Users] ([id]) VALUES (177)
GO
INSERT [dbo].[Users] ([id]) VALUES (178)
GO
INSERT [dbo].[Users] ([id]) VALUES (179)
GO
INSERT [dbo].[Users] ([id]) VALUES (180)
GO
INSERT [dbo].[Users] ([id]) VALUES (181)
GO
INSERT [dbo].[Users] ([id]) VALUES (182)
GO
INSERT [dbo].[Users] ([id]) VALUES (183)
GO
INSERT [dbo].[Users] ([id]) VALUES (184)
GO
INSERT [dbo].[Users] ([id]) VALUES (185)
GO
INSERT [dbo].[Users] ([id]) VALUES (186)
GO
INSERT [dbo].[Users] ([id]) VALUES (187)
GO
INSERT [dbo].[Users] ([id]) VALUES (188)
GO
INSERT [dbo].[Users] ([id]) VALUES (189)
GO
INSERT [dbo].[Users] ([id]) VALUES (190)
GO
INSERT [dbo].[Users] ([id]) VALUES (191)
GO
INSERT [dbo].[Users] ([id]) VALUES (192)
GO
INSERT [dbo].[Users] ([id]) VALUES (193)
GO
INSERT [dbo].[Users] ([id]) VALUES (194)
GO
INSERT [dbo].[Users] ([id]) VALUES (195)
GO
INSERT [dbo].[Users] ([id]) VALUES (196)
GO
INSERT [dbo].[Users] ([id]) VALUES (197)
GO
INSERT [dbo].[Users] ([id]) VALUES (198)
GO
INSERT [dbo].[Users] ([id]) VALUES (199)
GO
INSERT [dbo].[Users] ([id]) VALUES (200)
GO
INSERT [dbo].[Users] ([id]) VALUES (201)
GO
INSERT [dbo].[Users] ([id]) VALUES (202)
GO
INSERT [dbo].[Users] ([id]) VALUES (203)
GO
INSERT [dbo].[Users] ([id]) VALUES (204)
GO
INSERT [dbo].[Users] ([id]) VALUES (205)
GO
INSERT [dbo].[Users] ([id]) VALUES (206)
GO
INSERT [dbo].[Users] ([id]) VALUES (207)
GO
INSERT [dbo].[Users] ([id]) VALUES (208)
GO
INSERT [dbo].[Users] ([id]) VALUES (209)
GO
INSERT [dbo].[Users] ([id]) VALUES (210)
GO
INSERT [dbo].[Users] ([id]) VALUES (211)
GO
INSERT [dbo].[Users] ([id]) VALUES (212)
GO
INSERT [dbo].[Users] ([id]) VALUES (213)
GO
INSERT [dbo].[Users] ([id]) VALUES (214)
GO
INSERT [dbo].[Users] ([id]) VALUES (215)
GO
INSERT [dbo].[Users] ([id]) VALUES (216)
GO
INSERT [dbo].[Users] ([id]) VALUES (217)
GO
INSERT [dbo].[Users] ([id]) VALUES (218)
GO
INSERT [dbo].[Users] ([id]) VALUES (219)
GO
INSERT [dbo].[Users] ([id]) VALUES (220)
GO
INSERT [dbo].[Users] ([id]) VALUES (221)
GO
INSERT [dbo].[Users] ([id]) VALUES (222)
GO
INSERT [dbo].[Users] ([id]) VALUES (223)
GO
INSERT [dbo].[Users] ([id]) VALUES (224)
GO
INSERT [dbo].[Users] ([id]) VALUES (225)
GO
INSERT [dbo].[Users] ([id]) VALUES (226)
GO
INSERT [dbo].[Users] ([id]) VALUES (227)
GO
INSERT [dbo].[Users] ([id]) VALUES (228)
GO
INSERT [dbo].[Users] ([id]) VALUES (229)
GO
INSERT [dbo].[Users] ([id]) VALUES (230)
GO
INSERT [dbo].[Users] ([id]) VALUES (231)
GO
INSERT [dbo].[Users] ([id]) VALUES (232)
GO
INSERT [dbo].[Users] ([id]) VALUES (233)
GO
INSERT [dbo].[Users] ([id]) VALUES (234)
GO
INSERT [dbo].[Users] ([id]) VALUES (235)
GO
INSERT [dbo].[Users] ([id]) VALUES (236)
GO
INSERT [dbo].[Users] ([id]) VALUES (237)
GO
INSERT [dbo].[Users] ([id]) VALUES (238)
GO
INSERT [dbo].[Users] ([id]) VALUES (239)
GO
INSERT [dbo].[Users] ([id]) VALUES (240)
GO
INSERT [dbo].[Users] ([id]) VALUES (241)
GO
INSERT [dbo].[Users] ([id]) VALUES (242)
GO
INSERT [dbo].[Users] ([id]) VALUES (243)
GO
INSERT [dbo].[Users] ([id]) VALUES (244)
GO
INSERT [dbo].[Users] ([id]) VALUES (245)
GO
INSERT [dbo].[Users] ([id]) VALUES (246)
GO
INSERT [dbo].[Users] ([id]) VALUES (247)
GO
INSERT [dbo].[Users] ([id]) VALUES (248)
GO
INSERT [dbo].[Users] ([id]) VALUES (249)
GO
INSERT [dbo].[Users] ([id]) VALUES (250)
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET IDENTITY_INSERT [dbo].[Wishlist] ON 
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (1, 143, 9)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (2, 24, 49)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (3, 28, 36)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (4, 138, 1)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (5, 63, 6)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (6, 160, 44)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (7, 73, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (8, 6, 44)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (9, 135, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (10, 68, 50)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (11, 198, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (12, 100, 29)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (13, 24, 44)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (14, 167, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (15, 76, 36)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (16, 206, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (17, 147, 12)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (18, 28, 37)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (19, 196, 49)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (20, 166, 3)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (21, 166, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (22, 120, 36)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (23, 236, 46)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (24, 132, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (25, 179, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (26, 83, 18)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (27, 121, 47)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (28, 57, 34)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (29, 130, 35)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (30, 155, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (31, 33, 26)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (32, 15, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (33, 159, 40)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (34, 44, 44)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (35, 33, 34)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (36, 174, 8)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (37, 140, 2)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (38, 125, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (39, 40, 41)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (40, 58, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (41, 42, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (42, 154, 48)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (43, 77, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (44, 152, 9)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (45, 94, 9)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (46, 244, 35)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (47, 105, 15)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (48, 59, 15)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (49, 138, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (50, 54, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (51, 65, 8)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (52, 192, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (53, 213, 8)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (54, 221, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (55, 179, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (56, 74, 26)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (57, 178, 41)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (58, 199, 27)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (59, 209, 23)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (60, 60, 28)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (61, 213, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (62, 227, 50)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (63, 34, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (64, 98, 38)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (65, 113, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (66, 180, 29)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (67, 208, 22)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (68, 24, 34)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (69, 62, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (70, 2, 22)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (71, 34, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (72, 167, 38)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (73, 246, 37)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (74, 83, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (75, 135, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (76, 95, 38)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (77, 152, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (78, 119, 12)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (79, 141, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (80, 123, 10)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (81, 188, 46)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (82, 179, 44)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (83, 164, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (84, 145, 15)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (85, 111, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (86, 221, 3)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (87, 24, 23)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (88, 37, 43)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (89, 236, 6)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (90, 74, 41)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (91, 214, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (92, 114, 2)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (93, 174, 3)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (94, 132, 48)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (95, 199, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (96, 127, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (97, 75, 44)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (98, 13, 17)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (99, 89, 33)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (100, 35, 6)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (101, 77, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (102, 29, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (103, 4, 46)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (104, 78, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (105, 6, 48)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (106, 158, 8)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (107, 243, 27)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (108, 132, 40)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (109, 233, 35)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (110, 29, 17)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (111, 59, 35)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (112, 48, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (113, 91, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (114, 102, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (115, 212, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (116, 250, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (117, 153, 6)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (118, 215, 26)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (119, 100, 35)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (120, 205, 48)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (121, 34, 36)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (122, 105, 39)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (123, 98, 22)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (124, 60, 6)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (125, 205, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (126, 79, 26)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (127, 100, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (128, 242, 15)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (129, 138, 41)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (130, 215, 3)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (131, 54, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (132, 90, 44)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (133, 73, 38)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (134, 28, 35)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (135, 56, 49)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (136, 51, 17)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (137, 8, 41)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (138, 66, 41)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (139, 11, 40)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (140, 59, 33)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (141, 168, 18)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (142, 35, 37)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (143, 119, 35)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (144, 184, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (145, 149, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (146, 78, 13)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (147, 154, 39)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (148, 22, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (149, 12, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (150, 119, 23)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (151, 29, 8)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (152, 160, 29)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (153, 248, 15)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (154, 51, 29)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (155, 148, 38)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (156, 155, 9)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (157, 141, 1)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (158, 249, 32)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (159, 144, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (160, 164, 49)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (161, 141, 10)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (162, 103, 23)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (163, 235, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (164, 220, 15)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (165, 86, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (166, 13, 1)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (167, 247, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (168, 180, 40)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (169, 4, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (170, 52, 18)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (171, 189, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (172, 222, 15)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (173, 53, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (174, 161, 26)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (175, 238, 36)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (176, 148, 34)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (177, 143, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (178, 201, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (179, 219, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (180, 27, 1)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (181, 15, 46)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (182, 125, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (183, 140, 41)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (184, 99, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (185, 207, 17)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (186, 5, 47)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (187, 200, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (188, 12, 5)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (189, 243, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (190, 89, 10)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (191, 157, 22)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (192, 202, 50)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (193, 59, 40)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (194, 14, 36)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (195, 229, 32)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (196, 146, 8)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (197, 192, 13)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (198, 136, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (199, 237, 18)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (200, 17, 39)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (201, 222, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (202, 215, 37)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (203, 170, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (204, 149, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (205, 107, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (206, 100, 15)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (207, 14, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (208, 214, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (209, 71, 47)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (210, 32, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (211, 88, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (212, 196, 36)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (213, 28, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (214, 156, 9)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (215, 247, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (216, 51, 37)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (217, 79, 8)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (218, 57, 9)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (219, 218, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (220, 63, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (221, 66, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (222, 95, 43)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (223, 6, 17)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (224, 56, 43)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (225, 216, 36)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (226, 223, 36)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (227, 54, 5)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (228, 1, 10)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (229, 145, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (230, 173, 2)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (231, 157, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (232, 179, 3)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (233, 119, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (234, 145, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (235, 46, 13)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (236, 163, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (237, 223, 37)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (238, 52, 46)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (239, 217, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (240, 128, 46)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (241, 114, 5)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (242, 131, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (243, 58, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (244, 155, 18)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (245, 28, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (246, 109, 3)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (247, 154, 34)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (248, 48, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (249, 4, 43)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (250, 174, 46)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (251, 19, 27)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (252, 131, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (253, 11, 50)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (254, 101, 9)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (255, 85, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (256, 160, 1)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (257, 153, 46)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (258, 74, 23)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (259, 234, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (260, 12, 50)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (261, 207, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (262, 81, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (263, 20, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (264, 63, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (265, 54, 23)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (266, 135, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (267, 175, 37)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (268, 123, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (269, 14, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (270, 39, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (271, 41, 6)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (272, 24, 36)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (273, 162, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (274, 153, 5)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (275, 207, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (276, 47, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (277, 102, 29)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (278, 149, 28)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (279, 100, 40)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (280, 213, 46)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (281, 31, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (282, 128, 27)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (283, 204, 15)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (284, 52, 17)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (285, 153, 43)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (286, 80, 27)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (287, 199, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (288, 204, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (289, 174, 24)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (290, 86, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (291, 158, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (292, 7, 39)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (293, 116, 22)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (294, 5, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (295, 17, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (296, 31, 28)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (297, 46, 39)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (298, 81, 37)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (299, 209, 5)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (300, 132, 15)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (301, 54, 28)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (302, 168, 10)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (303, 123, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (304, 108, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (305, 145, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (306, 18, 36)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (307, 214, 50)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (308, 98, 50)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (309, 232, 40)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (310, 49, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (311, 240, 47)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (312, 113, 23)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (313, 137, 22)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (314, 88, 50)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (315, 23, 34)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (316, 75, 22)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (317, 56, 44)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (318, 82, 17)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (319, 143, 8)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (320, 182, 15)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (321, 29, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (322, 200, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (323, 25, 43)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (324, 143, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (325, 182, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (326, 174, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (327, 106, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (328, 191, 1)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (329, 199, 28)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (330, 233, 34)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (331, 9, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (332, 140, 18)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (333, 205, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (334, 201, 24)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (335, 121, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (336, 213, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (337, 126, 39)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (338, 86, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (339, 203, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (340, 133, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (341, 16, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (342, 219, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (343, 79, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (344, 159, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (345, 123, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (346, 12, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (347, 152, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (348, 247, 50)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (349, 229, 8)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (350, 136, 49)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (351, 236, 13)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (352, 142, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (353, 193, 28)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (354, 215, 50)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (355, 35, 35)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (356, 173, 26)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (357, 11, 40)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (358, 184, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (359, 209, 10)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (360, 35, 48)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (361, 72, 46)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (362, 78, 38)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (363, 98, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (364, 32, 43)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (365, 107, 18)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (366, 59, 15)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (367, 110, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (368, 47, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (369, 175, 34)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (370, 108, 23)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (371, 92, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (372, 62, 38)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (373, 20, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (374, 37, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (375, 207, 24)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (376, 198, 35)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (377, 91, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (378, 246, 5)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (379, 112, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (380, 82, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (381, 102, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (382, 244, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (383, 7, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (384, 250, 12)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (385, 189, 5)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (386, 159, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (387, 185, 38)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (388, 167, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (389, 216, 32)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (390, 203, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (391, 191, 47)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (392, 219, 5)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (393, 130, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (394, 21, 48)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (395, 82, 44)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (396, 1, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (397, 29, 25)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (398, 7, 28)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (399, 116, 46)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (400, 30, 28)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (401, 213, 32)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (402, 243, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (403, 67, 32)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (404, 211, 41)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (405, 34, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (406, 192, 47)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (407, 154, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (408, 204, 10)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (409, 34, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (410, 41, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (411, 214, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (412, 19, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (413, 194, 18)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (414, 43, 32)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (415, 218, 46)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (416, 120, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (417, 18, 10)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (418, 20, 5)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (419, 101, 13)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (420, 114, 3)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (421, 215, 24)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (422, 143, 12)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (423, 56, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (424, 34, 27)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (425, 180, 33)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (426, 27, 22)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (427, 13, 22)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (428, 192, 13)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (429, 24, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (430, 41, 41)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (431, 5, 18)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (432, 23, 26)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (433, 195, 24)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (434, 201, 48)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (435, 109, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (436, 179, 38)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (437, 122, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (438, 183, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (439, 153, 22)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (440, 238, 17)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (441, 150, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (442, 206, 41)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (443, 130, 49)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (444, 202, 17)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (445, 133, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (446, 155, 27)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (447, 212, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (448, 56, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (449, 156, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (450, 79, 17)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (451, 101, 49)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (452, 132, 50)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (453, 206, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (454, 51, 23)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (455, 48, 5)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (456, 158, 45)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (457, 84, 19)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (458, 136, 14)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (459, 223, 47)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (460, 35, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (461, 79, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (462, 60, 5)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (463, 10, 31)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (464, 114, 41)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (465, 111, 32)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (466, 103, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (467, 214, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (468, 121, 28)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (469, 210, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (470, 199, 42)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (471, 116, 30)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (472, 173, 10)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (473, 21, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (474, 120, 9)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (475, 55, 12)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (476, 39, 6)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (477, 10, 50)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (478, 195, 29)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (479, 109, 41)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (480, 60, 38)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (481, 110, 16)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (482, 61, 39)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (483, 34, 4)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (484, 129, 23)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (485, 103, 21)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (486, 120, 18)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (487, 123, 32)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (488, 197, 8)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (489, 41, 18)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (490, 68, 20)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (491, 34, 36)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (492, 73, 22)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (493, 43, 44)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (494, 157, 37)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (495, 44, 37)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (496, 56, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (497, 128, 40)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (498, 57, 47)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (499, 103, 2)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (500, 104, 5)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (501, 1, 28)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (502, 1, 28)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (503, 1, 28)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (504, 1, 24)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (505, 1, 24)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (506, 1, 7)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (507, 1, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (508, 1, 11)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (509, 1, 1)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (510, 1, 1)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (511, 1, 1)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (1501, 1, 18)
GO
INSERT [dbo].[Wishlist] ([id], [user_id], [stock_id]) VALUES (1502, 1, 13)
GO
SET IDENTITY_INSERT [dbo].[Wishlist] OFF
GO
ALTER TABLE [dbo].[Wishlist]  WITH CHECK ADD FOREIGN KEY([stock_id])
REFERENCES [dbo].[Stocks] ([id])
GO
USE [master]
GO
ALTER DATABASE [stockwishlist] SET  READ_WRITE 
GO
