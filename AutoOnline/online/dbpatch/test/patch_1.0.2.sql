--必须按以下格式声明版本
--### VERSION: 1.0.2 ###--

--本文件是patch tool 测试文件

-- ----------------------------
-- Table structure for ver_database
-- ----------------------------
DROP TABLE IF EXISTS `p_test`;
CREATE TABLE `p_test` (
  `name` varchar(10) null comment '测试名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='测试表';

-- ----------------------------
-- Records of ver_database
-- ----------------------------
INSERT INTO `p_test` VALUES ('HAHAHAHAHA');
