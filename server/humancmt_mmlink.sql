-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 14, 2025 at 06:34 PM
-- Server version: 10.3.39-MariaDB-cll-lve
-- PHP Version: 8.1.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `humancmt_mmlink`
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
-- Table structure for table `tbl_cart`
--

CREATE TABLE `tbl_cart` (
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `user_id` int(11) NOT NULL,
  `added_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_cart`
--

INSERT INTO `tbl_cart` (`cart_id`, `product_id`, `quantity`, `price`, `user_id`, `added_date`) VALUES
(4, 5, 1, 50.00, 1, '2024-12-12 11:27:39'),
(6, 17, 3, 105.00, 1, '2024-12-12 17:40:01'),
(7, 16, 4, 112.00, 1, '2024-12-12 18:50:57'),
(8, 14, 3, 90.00, 1, '2024-12-12 18:55:22');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_events`
--

CREATE TABLE `tbl_events` (
  `event_id` int(5) NOT NULL,
  `event_title` varchar(300) NOT NULL,
  `event_description` varchar(2000) NOT NULL,
  `event_startdate` datetime(6) NOT NULL,
  `event_enddate` datetime(6) NOT NULL,
  `event_type` varchar(30) NOT NULL,
  `event_location` varchar(100) NOT NULL,
  `event_filename` varchar(20) NOT NULL,
  `event_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_events`
--

INSERT INTO `tbl_events` (`event_id`, `event_title`, `event_description`, `event_startdate`, `event_enddate`, `event_type`, `event_location`, `event_filename`, `event_date`) VALUES
(1, '', '', '0000-00-00 00:00:00.000000', '0000-00-00 00:00:00.000000', '', '', 'event-8scmi4r5b2.jpg', '2025-01-14 09:58:50.705871');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_memberships`
--

CREATE TABLE `tbl_memberships` (
  `membership_id` int(11) NOT NULL,
  `membership_name` varchar(100) NOT NULL,
  `membership_desc` text NOT NULL,
  `membership_price` decimal(10,2) NOT NULL,
  `membership_duration` int(11) NOT NULL,
  `membership_benefits` text NOT NULL,
  `membership_terms` text NOT NULL,
  `membership_date` datetime NOT NULL DEFAULT current_timestamp(),
  `membership_status` enum('active','inactive') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_memberships`
--

INSERT INTO `tbl_memberships` (`membership_id`, `membership_name`, `membership_desc`, `membership_price`, `membership_duration`, `membership_benefits`, `membership_terms`, `membership_date`, `membership_status`) VALUES
(1, 'Gold Membership', 'Access to all premium features', 99.99, 12, 'Priority support, Free shipping', 'Terms and conditions apply', '2025-01-08 12:38:41', 'active'),
(3, 'Silver Membership', 'Access to standard features', 49.99, 6, 'Standard support, Discounted shipping', 'Terms and conditions apply', '2025-01-08 12:39:26', 'active'),
(4, 'Student Membership', 'Access to all features at a discounted rate', 29.99, 12, 'Standard support, Discounted shipping', 'Must provide valid student ID', '2025-01-08 12:43:14', 'active'),
(6, 'Platinum Plan', 'Ultimate membership with all-inclusive benefits', 50.00, 1, 'All Gold Plan benefits, Free shipping on all orders, 30% discount on all items, Personalized assistance', 'Membership is non-transferable, No refunds for partial months, Benefits subject to change', '2025-01-14 16:49:15', 'active'),
(7, 'Family Plan', 'Membership for families with shared benefits', 40.00, 5, 'Access for up to 4 family members, All Silver Plan benefits, Family events and activities', 'Membership is non-transferable, No refunds for partial months, Benefits subject to change', '2025-01-14 16:49:47', 'active'),
(8, 'Senior Plan', 'Special membership for seniors', 7.00, 1, 'Access to standard features, Monthly newsletter, 20% discount on select items', 'Membership is non-transferable, No refunds for partial months, Valid ID required', '2025-01-14 16:50:15', 'active'),
(9, 'VIP Plan', 'Exclusive membership with top-tier benefits', 100.00, 2, 'All Platinum Plan benefits, VIP customer support, 40% discount on all items, Exclusive VIP events', 'Membership is non-transferable, No refunds for partial months, Benefits subject to change', '2025-01-14 16:50:54', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_news`
--

CREATE TABLE `tbl_news` (
  `news_id` int(3) NOT NULL,
  `news_title` varchar(300) NOT NULL,
  `news_details` varchar(800) NOT NULL,
  `news_date` datetime NOT NULL DEFAULT current_timestamp(),
  `is_edited` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_news`
--

INSERT INTO `tbl_news` (`news_id`, `news_title`, `news_details`, `news_date`, `is_edited`) VALUES
(4, 'OTP Email Configuration', 'Configures numeric OTPs for email verification with a 4-digit length.', '2024-11-27 11:21:05', 0),
(5, 'Material Theme Setup', 'Implements Material Design 3 with light and dark color themes', '2024-11-27 11:21:24', 0),
(7, 'Membership', 'Jangan lupakan dapatkan Ayam chicken', '2024-11-27 21:59:29', 0),
(8, 'Exclusive Member Perks', 'Unlock special discounts and offers exclusive to members! Enjoy curated deals tailored just for you.', '2024-11-29 18:34:32', 0),
(9, 'Track Your Achievements\0', 'Keep tabs on your milestones with our new progress tracker. Celebrate every step of your journey within the community.hihi', '2024-11-29 18:34:54', 0),
(10, 'Refer and Earn Rewards', 'Invite friends to join and earn points for every successful referral. Share the benefits and grow the community!', '2024-11-29 18:35:33', 0),
(11, 'Stay Connected With Notifications', 'Never miss out on updates, events, or offers. Get real-time notifications straight to your phone.', '2024-11-29 18:36:39', 0),
(12, 'Celebrate Special Moments Together', 'We\'ve added a personalized calendar to help you celebrate birthdays and anniversaries with fellow members!', '2024-11-29 18:37:00', 0),
(13, 'Member Spotlights', 'Introducing a feature that highlights exceptional members each month. Share your achievements and get recognized!', '2024-11-29 18:37:18', 0),
(14, 'Community Forums Now Live', 'Engage with other members in our new forums. Share ideas, ask questions, and build lasting connections.', '2024-11-29 18:37:45', 0),
(15, 'Priority Access to Events', 'Members now enjoy early access to exclusive events. Be the first to grab your spot in exciting opportunities.', '2024-11-29 18:38:00', 0),
(16, 'Personalized Recommendations', 'Discover events, products, and content curated just for you based on your interests and engagement.', '2024-11-29 18:38:20', 0),
(17, 'Member Achievement Badges', 'Earn badges for your activities and contributions. Show off your accomplishments to the community!', '2024-11-29 18:38:37', 0),
(18, 'Exclusive Access to New Features', 'Be the first to try out our latest features and tools, exclusively available to members before anyone else.', '2024-11-30 10:06:26', 0),
(19, 'Enhanced Profile Customization', 'Stand out in the community with advanced profile customization options. Add flair and personality to your member profile.', '2024-11-30 10:06:43', 0),
(20, 'Dynamic Event Calendar', 'Our updated event calendar lets you sync events with your personal schedule. Never miss an opportunity to engage!', '2024-11-30 10:07:28', 0),
(21, 'Rewards Program Dashboard', 'Track your rewards, points, and benefits in a single, easy-to-use dashboard designed for members.', '2024-11-30 10:11:29', 0),
(22, 'Quick Support for Members', 'Get priority support from our team for any issues or inquiries. Your membership guarantees faster responses.', '2024-11-30 10:11:45', 0),
(23, 'Invite-Only Events', 'Participate in exclusive, invite-only events designed to connect and inspire members.\n\n', '2024-11-30 10:12:06', 0),
(24, 'Content Library Access', 'Gain unlimited access to premium content, resources, and guides created just for our community members.', '2024-11-30 10:12:21', 0),
(25, 'Feedback and Voting System', 'Share your ideas and vote on future features or improvements. Help shape the community hehehehehehe', '2024-11-30 10:12:43', 1),
(26, 'Leaderboards for Active Members', 'Compete and rank on the leaderboard based on your participation, achievements, and contributions to the community.', '2024-11-30 10:12:58', 0),
(27, 'Monthly Member Challenges', 'Take part in fun, themed challenges every month and win exclusive rewards to enhance your experience here.', '2024-11-30 10:13:15', 0),
(28, 'Membership Plan 2.0', 'Membership plan very good good very good', '2024-12-03 10:34:09', 1),
(30, '', '', '2025-01-14 09:58:45', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_products`
--

CREATE TABLE `tbl_products` (
  `product_id` int(5) NOT NULL,
  `product_name` varchar(200) NOT NULL,
  `product_desc` varchar(2000) NOT NULL,
  `product_price` decimal(6,2) NOT NULL,
  `product_qty` int(5) NOT NULL,
  `product_status` varchar(10) NOT NULL,
  `product_filename` varchar(100) NOT NULL,
  `product_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_products`
--

INSERT INTO `tbl_products` (`product_id`, `product_name`, `product_desc`, `product_price`, `product_qty`, `product_status`, `product_filename`, `product_date`) VALUES
(1, 'Pen', 'Pen ini diprebuat dari kayu', 4.50, 30, '', 'product-w2gc3eegom.jpg', '2024-12-11 20:59:33.176727'),
(2, 'Mug', 'Mug Gais Beli Beli', 10.00, 20, '', 'product-zgyw9efre0.jpg', '2024-12-11 22:33:47.162831'),
(3, 'MyMemberLink Premium T-Shirt', 'A high-quality cotton t-shirt featuring the sleek MyMemberLink logo. Perfect for everyday wear to showcase your membership pride.\0', 25.00, 200, '', 'product-fr0xo5vyhe.jpg', '2024-12-12 05:07:34.529968'),
(4, 'MyMemberLink Premium Mug', 'Start your day with a hot beverage in this stylish ceramic mug adorned with the MyMemberLink emblem. Microwave and dishwasher safe.', 15.00, 200, '', 'product-e00qsg02h0.jpg', '2024-12-12 05:12:04.967769'),
(5, 'MyMemberLink Cozy Hoodie\0', ' A comfortable hoodie with the MyMemberLink logo printed on the front. Perfect for cooler days and casual outings.\0', 50.00, 200, '', 'product-haueycrk3u.jpg', '2024-12-12 05:20:15.309523'),
(6, 'MyMemberLink Premium T-Shirt', 'A high-quality cotton t-shirt featuring the sleek MyMemberLink logo. Perfect for everyday wear to showcase your membership pride.', 25.00, 20, '', 'product-6wyfz44x01.jpg', '2024-12-12 12:16:48.262226'),
(7, 'MyMemberLink Ceramic Mug', 'Start your day with a hot beverage in this stylish ceramic mug adorned with the MyMemberLink emblem. Microwave and dishwasher safe.', 15.00, 30, '', 'product-0jlxcxx2oq.jpg', '2024-12-12 12:18:19.033093'),
(8, 'MyMemberLink Eco-Friendly Tote Bag', 'Carry your essentials in this durable, eco-friendly tote bag featuring the MyMemberLink branding. Ideal for shopping or daily use.', 20.00, 45, '', 'product-jdl6nc5sti.jpg', '2024-12-12 12:24:24.580185'),
(9, 'MyMemberLink Executive Pen', 'A smooth-writing ballpoint pen engraved with the MyMemberLink logo. Comes with a comfortable grip and refillable ink.', 5.00, 100, '', 'product-vulvikhvmc.jpg', '2024-12-12 12:26:44.392584'),
(10, 'MyMemberLink Spiral Notebook', 'A 100-page lined notebook with a sturdy cover displaying the MyMemberLink design. Perfect for notes, sketches, or journaling.', 18.00, 100, '', 'product-tqf6chwg0g.jpg', '2024-12-12 12:30:20.581967'),
(11, 'MyMemberLink Membership Card Holder', 'Keep your membership card and other important cards organized in this sleek holder embossed with the MyMemberLink logo.', 12.00, 20, '', 'product-am17188pk9.jpg', '2024-12-12 12:30:56.698191'),
(12, 'MyMemberLink Branded Lanyard', 'A durable lanyard featuring the MyMemberLink colors and logo, perfect for holding ID badges, keys, or access cards.', 8.00, 150, '', 'product-qg8quicex5.jpg', '2024-12-12 12:31:26.980949'),
(13, 'MyMemberLink Insulated Water Bottle', 'A stainless steel, insulated water bottle that keeps your drinks hot or cold for hours. Features the MyMemberLink branding.', 22.00, 50, '', 'product-vbfi8tkb2x.jpg', '2024-12-12 12:31:52.113527'),
(14, 'MyMemberLink Baseball Cap', 'A stylish and adjustable cap embroidered with the MyMemberLink logo. Ideal for outdoor activities and casual wear.', 30.00, 150, '', 'product-piodmseyg8.jpg', '2024-12-12 12:32:28.828932'),
(15, 'MyMemberLink Mouse Pad', 'Enhance your workspace with this smooth-surface mouse pad showcasing the MyMemberLink design. Provides precise mouse control.', 20.00, 48, '', 'product-m6t0agv6i4.jpg', '2024-12-12 12:33:57.104288'),
(16, 'MyMemberLink Phone Case', 'Protect your smartphone with this sleek case featuring the MyMemberLink design. Available for multiple phone models.', 28.00, 130, '', 'product-3yiz48assi.jpg', '2024-12-12 12:35:50.340237'),
(17, 'MyMemberLink Compact Umbrella', 'Stay dry during unexpected showers with this compact umbrella featuring the MyMemberLink logo. Fits easily in your bag.', 35.00, 20, '', 'product-owwdcdbsn8.jpg', '2024-12-12 12:36:22.386997'),
(18, 'MyMemberLink Metal Keychain', 'A durable metal keychain engraved with the MyMemberLink emblem. A subtle accessory to keep your keys organized.', 7.00, 300, '', 'product-bwq4x7dd35.jpg', '2024-12-12 12:37:28.509977'),
(19, 'MyMemberLink Sticker Pack', 'A set of assorted stickers with various MyMemberLink logos and designs. Great for decorating laptops, notebooks, and more.', 5.00, 180, '', 'product-q1u8jygm3k.jpg', '2024-12-12 12:39:33.944541'),
(20, 'MyMemberLink Cozy Hoodie', ' A comfortable hoodie with the MyMemberLink logo printed on the front. Perfect for cooler days and casual outings.', 80.00, 20, '', 'product-fljfzlo6sv.jpg', '2024-12-12 12:40:10.590261'),
(21, 'Memberlink Meme Sticker', 'Memeberlink Meme is meme that can change the world', 2.00, 200, '', 'product-7rpjtksru8.jpg', '2024-12-12 18:54:04.019762'),
(22, 'memberlink sticker ', 'memberlink sticker tersohor', 3.00, 200, '', 'product-d5mjublxjd.jpg', '2024-12-12 19:01:00.171694'),
(23, '', '', 0.00, 0, '', 'product-arvsbrnilb.jpg', '2025-01-14 09:58:45.695743');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_purchases`
--

CREATE TABLE `tbl_purchases` (
  `purchase_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `membership_id` int(11) DEFAULT NULL,
  `receipt_id` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_status` enum('pending','success','failed') NOT NULL DEFAULT 'pending',
  `purchase_date` datetime NOT NULL DEFAULT current_timestamp(),
  `expiry_date` datetime DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT 'Billplz',
  `payment_provider` varchar(50) DEFAULT 'Online Banking',
  `transaction_id` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_purchases`
--

INSERT INTO `tbl_purchases` (`purchase_id`, `user_id`, `membership_id`, `receipt_id`, `amount`, `payment_status`, `purchase_date`, `expiry_date`, `payment_method`, `payment_provider`, `transaction_id`) VALUES
(1, 5, 4, 'wawbfbpl', 29.99, 'success', '2025-01-13 20:08:17', NULL, 'Billplz', 'Online Banking', NULL),
(2, 5, 1, 'klfpdkva', 99.99, 'success', '2025-01-14 00:26:35', NULL, 'Billplz', 'Online Banking', NULL),
(3, 5, 1, 'klfpdkva', 99.99, 'success', '2025-01-14 00:26:51', NULL, 'Billplz', 'Online Banking', NULL),
(4, 5, 1, 'zzrpm3lz', 99.99, 'success', '2025-01-14 00:42:10', NULL, 'Billplz', 'Online Banking', NULL),
(5, 5, 4, 'jf2gyqyj', 29.99, 'failed', '2025-01-14 00:47:13', NULL, 'Billplz', 'Online Banking', NULL),
(6, 5, 3, 'm4qgozo1', 49.99, 'success', '2025-01-14 07:02:50', NULL, 'Billplz', 'Online Banking', NULL),
(7, 5, 4, 'lsuoc0t5', 29.99, 'success', '2025-01-14 07:13:43', NULL, 'Billplz', 'Online Banking', NULL),
(9, 5, 1, 'RCP202501140748426658', 99.99, 'pending', '2025-01-14 15:48:42', NULL, 'Billplz', 'Online Banking', NULL),
(10, 5, 1, 'RCP202501140750274117', 99.99, 'pending', '2025-01-14 15:50:27', NULL, 'Billplz', 'Online Banking', NULL),
(13, 5, 4, 'vqnbi1z8', 29.99, 'success', '2025-01-14 16:35:10', NULL, 'Billplz', 'Online Banking', NULL),
(14, 5, 7, 'RCP202501140910116947', 40.00, 'pending', '2025-01-14 17:10:11', NULL, 'Billplz', 'Online Banking', NULL),
(15, 5, 7, 'nf3nmzsv', 40.00, 'success', '2025-01-14 17:10:31', NULL, 'Billplz', 'Online Banking', NULL),
(16, 5, 9, 'RCP202501140914087503', 100.00, 'pending', '2025-01-14 17:14:08', NULL, 'Billplz', 'Online Banking', NULL),
(17, 5, 9, 'vtu65qpq', 100.00, 'success', '2025-01-14 17:14:18', NULL, 'Billplz', 'Online Banking', NULL),
(18, 5, 3, 'RCP202501141005116503', 49.99, 'pending', '2025-01-14 18:05:11', NULL, 'Billplz', 'Online Banking', NULL),
(19, 5, 3, 'osvn0bp7', 49.99, 'failed', '2025-01-14 18:05:19', NULL, 'Billplz', 'Online Banking', NULL);

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
(5, 'Tuan Muhammad Farhan Bin Tuan Rashid', 'farhanrashid293@gmail.com', '0197909367', '5c6e90c430546a925be99c7d8a2ed6b2815e5d4c', '0000-00-00 00:00:00'),
(6, 'Ahamd Albab', 'albab123@gmail.com', '019999231', 'eb9df2325096e36c161e8fc4787b24f8b1995784', '0000-00-00 00:00:00'),
(15, 'FarhanRashid', 'farhanrashid292@gmail.com', '213231232', '1b9a1be971b6d3107b9e2a1e915cab68617c007c', '0000-00-00 00:00:00'),
(16, 'Ridhwan Amin', 'rid123@gmail.com', '0112132444', 'cd75a0ab7762a8db33a02d26f17d36a45a64abad', '0000-00-00 00:00:00'),
(17, 'Tuan Muhammad Farhan', 'farhanrashid111@gmail.com', '01212121212', 'c81ececf28f102eedeb0330c854432d3acdfa20a', '0000-00-00 00:00:00'),
(18, 'Ahmad Hafiz', 'hafiz123@gmail.com', '0112121213', '8598a07b196c4c74dff74fc82807e3368c178922', '0000-00-00 00:00:00'),
(19, 'Tuan Paan', 'Paan123@gmail.com', '019999999', '078970e4589d23eb257c88e375348e196dc59d1c', '0000-00-00 00:00:00'),
(20, 'paanSo', 'paan222@gmail.com', '0121212121', '078970e4589d23eb257c88e375348e196dc59d1c', '0000-00-00 00:00:00');

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
-- Indexes for table `tbl_cart`
--
ALTER TABLE `tbl_cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `tbl_events`
--
ALTER TABLE `tbl_events`
  ADD PRIMARY KEY (`event_id`);

--
-- Indexes for table `tbl_memberships`
--
ALTER TABLE `tbl_memberships`
  ADD PRIMARY KEY (`membership_id`);

--
-- Indexes for table `tbl_news`
--
ALTER TABLE `tbl_news`
  ADD PRIMARY KEY (`news_id`);

--
-- Indexes for table `tbl_products`
--
ALTER TABLE `tbl_products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `tbl_purchases`
--
ALTER TABLE `tbl_purchases`
  ADD PRIMARY KEY (`purchase_id`),
  ADD UNIQUE KEY `transaction_id` (`transaction_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `membership_id` (`membership_id`);

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
-- AUTO_INCREMENT for table `tbl_cart`
--
ALTER TABLE `tbl_cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tbl_events`
--
ALTER TABLE `tbl_events`
  MODIFY `event_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_memberships`
--
ALTER TABLE `tbl_memberships`
  MODIFY `membership_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tbl_news`
--
ALTER TABLE `tbl_news`
  MODIFY `news_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `tbl_products`
--
ALTER TABLE `tbl_products`
  MODIFY `product_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `tbl_purchases`
--
ALTER TABLE `tbl_purchases`
  MODIFY `purchase_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_cart`
--
ALTER TABLE `tbl_cart`
  ADD CONSTRAINT `tbl_cart_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `tbl_products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_purchases`
--
ALTER TABLE `tbl_purchases`
  ADD CONSTRAINT `tbl_purchases_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`),
  ADD CONSTRAINT `tbl_purchases_ibfk_2` FOREIGN KEY (`membership_id`) REFERENCES `tbl_memberships` (`membership_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
