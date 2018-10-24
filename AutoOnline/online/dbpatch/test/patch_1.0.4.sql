--必须按以下格式声明版本
--### VERSION: 1.0.4 ###--

--本文件是patch tool 测试文件


-- ----------------------------
-- Table structure for ver_database
-- ----------------------------
ALTER TABLE `p_test` ADD COLUMN `address`  varchar(300) NULL DEFAULT '福建省厦门市' COMMENT '地址' AFTER `name`;
INSERT INTO `p_test` (name, address) VALUES ('xta dg ', 'sb lh ');