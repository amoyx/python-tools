
CREATE TABLE `p_account_config` (
  `login_id` varchar(45) NOT NULL COMMENT '帐户登录id',
  `config_key` varchar(127) NOT NULL COMMENT '配置项. 英文ID',
  `config_value` longtext COMMENT '配置的值',
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`login_id`,`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `p_logis_segment`
ADD COLUMN `should_notify` TINYINT(1) NULL DEFAULT '0' COMMENT '有新订单是否发通知' AFTER `alloc_no`;

CREATE TABLE `p_sys_message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL COMMENT '消息类型：0- ‘msg’ 站内消息, 1 - ‘logis.email’物流Email, 2 - ‘logis.sms’物流短信, ',
  `sent_at` datetime NOT NULL COMMENT '发送时间',
  `sender` varchar(127) NOT NULL COMMENT '发送者login_id，如果为系统自动发送，此处为 `DAEMON’',
  `recipient` varchar(127) NOT NULL COMMENT '接受方, 物流通知为logis_id, 站内消息为login_id，如果物流运营为 LOGIS_ADMIN',
  `content` longtext COMMENT '信息内容，为JSON字符串。结构自定',
  `status` tinyint(1) DEFAULT '0' COMMENT '消息状态: 0 - 未读,  1 - 已读',
  PRIMARY KEY (`id`),
  KEY `idx_type` (`type`),
  KEY `idx_sentAt` (`sent_at`),
  KEY `idx_sender` (`sender`),
  KEY `idx_reci` (`recipient`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `p_sys_config` (`id`, `description`, `value`, `type`, `default_value`) VALUES ('key.slide.one', '1', '{\"title\":\"1\",\"link_url\":\"\",\"src_url\":\"http:\\/\\/kolbuystatic.oss-cn-hangzhou.aliyuncs.com\\/sysadmin\\/20160518\\/64081463540570599.jpg\"}', 'image', NULL);
INSERT INTO `p_sys_config` (`id`, `description`, `value`, `type`, `default_value`) VALUES ('key.slide.three', '3', '{\"title\":\"2\",\"link_url\":\"\",\"src_url\":\"http:\\/\\/oss-cn-hangzhou.aliyuncs.com\\/kjtstatic\\/portal-dev\\/2016\\/06\\/03\\/c0fd8a2cd58e7b296fe15fa8f2ad7f63.jpg\"}', 'image', NULL);
INSERT INTO `p_sys_config` (`id`, `description`, `value`, `type`, `default_value`) VALUES ('key.slide.two', '2', '{\"title\":\"\",\"link_url\":\"1\",\"src_url\":\"http:\\/\\/oss-cn-hangzhou.aliyuncs.com\\/kjtstatic\\/portal-dev\\/2016\\/06\\/03\\/1f7bb2148b65cdae1e0df3c62a22b972.jpg\"}', 'image', NULL);



