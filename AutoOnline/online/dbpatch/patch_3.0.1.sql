CREATE TABLE `p_logis_waybill_no` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `route_id` varchar(16) NOT NULL,
  `waybill_no` varchar(32) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `waybill_no_UNIQUE` (`waybill_no`)
) ENGINE=InnoDB AUTO_INCREMENT=3080 DEFAULT CHARSET=utf8;
