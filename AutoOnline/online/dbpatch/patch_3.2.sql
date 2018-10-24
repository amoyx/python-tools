

INSERT INTO `p_access_role` (`id`, `title`, `created_at`, `created_by`, `description`) VALUES ('50', '退税商家', '2016-09-14', 'DBA', '退税商家');
INSERT INTO `p_access_role` (`id`, `title`, `created_at`, `created_by`, `description`) VALUES ('51', '退税运营人员', '2016-09-14', 'DBA', '退税运营人员');

CREATE TABLE `p_tax_refund_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '退税申请单号',
  `owner` varchar(32) NOT NULL COMMENT '退税申请人的主帐号login id',
  `channel` varchar(32) NOT NULL COMMENT '销售渠道（电商）\n',
  `channel_order_no` varchar(32) NOT NULL COMMENT '销售渠道订单号',
  `recipient_name` varchar(32) NOT NULL COMMENT '收件人姓名',
  `recipient_province` varchar(64) NOT NULL COMMENT '收件人省份',
  `recipient_city` varchar(64) NOT NULL COMMENT '收件人城市',
  `recipient_district` varchar(64) NOT NULL COMMENT '收件人地区',
  `recipient_addr` varchar(127) NOT NULL COMMENT '收件人地址',
  `recipient_phone` varchar(32) NOT NULL COMMENT '收件人手机号',
  `purchase_country` varchar(64) NOT NULL COMMENT '采购国家',
  `purchase_channel` varchar(32) NOT NULL COMMENT '采购渠道',
  `purchase_channel_order_no` varchar(32) NOT NULL COMMENT '采购渠道订单号',
  `purchase_date` datetime NOT NULL COMMENT '采购时间',
  `purchase_logis` varchar(32) NOT NULL COMMENT '采购物流商',
  `purchase_logis_no` varchar(32) NOT NULL COMMENT '采购物流单号',
  `purchase_send_date` datetime NOT NULL COMMENT '采购配送时间',
  `purchase_record_image` varchar(127) DEFAULT NULL COMMENT '采购凭证图片',
  `intl_logis` varchar(32) NOT NULL COMMENT '国际物流商',
  `intl_logis_no` varchar(32) NOT NULL COMMENT '国际物流单号',
  `intl_send_date` datetime NOT NULL COMMENT '配送时间',
  `intl_waybill_image` varchar(127) DEFAULT NULL COMMENT '国际物流底单\n',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态： －1:删除；0-刚刚上传',
  `refund_amount` float NOT NULL COMMENT '退税金额',
  `total_value` float NOT NULL COMMENT '采购总价',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` varchar(32) DEFAULT NULL COMMENT '上传人的登录ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

CREATE TABLE `p_tax_refund_order_item` (
  `order_id` int(11) NOT NULL COMMENT '退税申请单号\n',
  `index` varchar(127) NOT NULL COMMENT '商品序号',
  `name` varchar(127) NOT NULL COMMENT '销售商品名',
  `purchase_name` varchar(127) NOT NULL COMMENT '采购商品名',
  `price` float NOT NULL COMMENT '销售价格\n',
  `purchase_price` float NOT NULL COMMENT '采购价',
  `count` int(11) NOT NULL COMMENT '数量',
  UNIQUE KEY `idx_OrderId_Index` (`order_id`,`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `p_tax_refund_order_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` varchar(64) DEFAULT NULL,
  `note` text,
  PRIMARY KEY (`id`),
  KEY `id_updatedAt` (`updated_at`),
  KEY `id_orderId` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8;
