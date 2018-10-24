ALTER TABLE `p_vendor_order`
CHANGE COLUMN `status` `status` INT(11) NOT NULL DEFAULT 100 COMMENT '状态-1为删除的订单。';

INSERT INTO p_sys_currency_code (currency_code, currency_name) VALUES ('SAR', '沙特里亚尔');

CREATE TABLE `p_depot_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(127) DEFAULT NULL COMMENT '货站名称，一般和主帐号的名称保持一致即可',
  `login_id` varchar(31) NOT NULL COMMENT '主帐号登录ID',
  `batch_prefix` varchar(10) NOT NULL COMMENT '批次前缀',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `created_by` varchar(31) NOT NULL COMMENT '创建记录的运营人员登录ID',
  `disabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '帐号是否禁用。不推荐删除帐号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_id_UNIQUE` (`login_id`),
  UNIQUE KEY `batch_prefix_UNIQUE` (`batch_prefix`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `p_depot_batch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `depot_id` int(11) NOT NULL,
  `route_id` varchar(16) NOT NULL COMMENT '批次所属线路',
  `batch_no` varchar(31) NOT NULL COMMENT '一般为 prefix + yymmdd + auto increment index. 如 TYO16092301,TYO16092302',
  `created_at` datetime NOT NULL,
  `created_by` varchar(31) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `batch_no_UNIQUE` (`batch_no`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `p_depot_batch_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `batch_id` int(11) NOT NULL COMMENT '批次号',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态。0-新建，1–运单添加／删除，-1: 已删除, 100: 已移交',
  `note` varchar(127) DEFAULT NULL COMMENT '备注',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `updated_by` varchar(31) DEFAULT NULL COMMENT '更新者login_id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `p_depot_batch_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `batch_id` int(11) NOT NULL,
  `order_no` varchar(16) NOT NULL COMMENT '指向 p_vendor_order',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(31) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_no_UNIQUE` (`order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `p_depot_route` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `depot_id` int(11) NOT NULL,
  `route_id` varchar(31) NOT NULL,
  `created_at` datetime NOT NULL,
  `created_by` varchar(31) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_depotId_routeId` (`depot_id`,`route_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `p_depot_waybill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `depot_id` int(11) NOT NULL,
  `route_id` varchar(31) NOT NULL,
  `waybill_no` varchar(31) NOT NULL,
  `order_no` varchar(31) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `assigned_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_waybillNo` (`waybill_no`),
  UNIQUE KEY `idx_orderNo` (`order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

