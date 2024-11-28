-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Nov 28, 2024 at 03:50 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mymemberlink_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_admins`
--

CREATE TABLE `tbl_admins` (
  `admin_id` int(3) NOT NULL,
  `admin_email` varchar(50) NOT NULL,
  `admin_pass` varchar(40) NOT NULL,
  `admin_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_admins`
--

INSERT INTO `tbl_admins` (`admin_id`, `admin_email`, `admin_pass`, `admin_datereg`) VALUES
(1, 'farhanrashid293@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '2024-10-02 12:05:23.000000'),
(3, 'farhanrashid@gmail.com', '5c6e90c430546a925be99c7d8a2ed6b2815e5d4c', '2024-11-01 00:30:36.194539'),
(5, 'hanifFaisal@gmail.com', 'acd2979d261fadf4f8f6216664dcc4b6fb5668d4', '2024-11-01 01:41:41.177037'),
(7, 'ilyas123@gmail.com', '2154bc00fd16440913b4d28bbe7dab65d5b8e233', '2024-11-01 02:03:50.651395'),
(9, '', 'da39a3ee5e6b4b0d3255bfef95601890afd80709', '2024-11-01 11:33:30.293078'),
(12, 'Hafiz@gmail.com', '8598a07b196c4c74dff74fc82807e3368c178922', '2024-11-12 22:26:39.615182');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_news`
--

CREATE TABLE `tbl_news` (
  `news_id` int(3) NOT NULL,
  `news_title` varchar(300) NOT NULL,
  `news_details` varchar(800) NOT NULL,
  `news_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_news`
--

INSERT INTO `tbl_news` (`news_id`, `news_title`, `news_details`, `news_date`) VALUES
(1, 'Manusia Sial', 'Sial sial sial', '2024-11-15 15:26:47'),
(2, 'Ultraman', 'Ultraman tiga', '2024-11-15 20:33:54'),
(3, 'Cerita', 'Cerita', '2024-11-27 11:10:15'),
(4, 'OTP Email Configuration', 'Configures numeric OTPs for email verification with a 4-digit length.', '2024-11-27 11:21:05'),
(5, 'Material Theme Setup', 'Implements Material Design 3 with light and dark color themes', '2024-11-27 11:21:24'),
(6, 'Flutter App Initialization', 'Initializes the Flutter app with SplashScreen as the entry point.', '2024-11-27 11:21:44'),
(7, 'Farhan', 'Tuan Muhammad fArhan ', '2024-11-27 21:59:29');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_phoneNum` varchar(20) NOT NULL,
  `user_pass` varchar(80) NOT NULL,
  `user_datereg` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_name`, `user_email`, `user_phoneNum`, `user_pass`, `user_datereg`) VALUES
(5, 'Tuan Muhammad Farhan Bin Tuan Rashid', 'farhanrashid293@gmail.com', '0197909367', 'b690085b39dcc8102bba4293a7bee38f74d2ef7c', '0000-00-00 00:00:00'),
(6, 'Ahamd Albab', 'albab123@gmail.com', '019999231', 'eb9df2325096e36c161e8fc4787b24f8b1995784', '0000-00-00 00:00:00'),
(15, 'FarhanRashid', 'farhanrashid292@gmail.com', '213231232', '1b9a1be971b6d3107b9e2a1e915cab68617c007c', '0000-00-00 00:00:00'),
(16, 'Ridhwan Amin', 'rid123@gmail.com', '0112132444', 'cd75a0ab7762a8db33a02d26f17d36a45a64abad', '0000-00-00 00:00:00'),
(17, 'Tuan Muhammad Farhan', 'farhanrashid111@gmail.com', '01212121212', 'c81ececf28f102eedeb0330c854432d3acdfa20a', '0000-00-00 00:00:00'),
(18, 'Ahmad Hafiz', 'hafiz123@gmail.com', '0112121213', '8598a07b196c4c74dff74fc82807e3368c178922', '0000-00-00 00:00:00'),
(19, 'Tuan Paan', 'Paan123@gmail.com', '019999999', '078970e4589d23eb257c88e375348e196dc59d1c', '0000-00-00 00:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_admins`
--
ALTER TABLE `tbl_admins`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `admin_email` (`admin_email`);

--
-- Indexes for table `tbl_news`
--
ALTER TABLE `tbl_news`
  ADD PRIMARY KEY (`news_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_admins`
--
ALTER TABLE `tbl_admins`
  MODIFY `admin_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tbl_news`
--
ALTER TABLE `tbl_news`
  MODIFY `news_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
