CREATE TABLE IF NOT EXISTS `vehicles_gang` (
  `gang` varchar(50) DEFAULT NULL,
  `vehicle` longtext DEFAULT NULL,
  `tunerdata` longtext NOT NULL,
  `plate` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

