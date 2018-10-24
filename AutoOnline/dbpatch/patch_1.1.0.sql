--必须按以下格式声明版本
--### VERSION: 1.1.0 ###--


-- ----------------------------
-- Table structure for `p_help_center_type`
-- ----------------------------
DROP TABLE IF EXISTS `p_help_center_type`;
CREATE TABLE `p_help_center_type` (
  `id` varchar(40) NOT NULL DEFAULT '',
  `name` varchar(100) NOT NULL COMMENT '类别名称',
  `seq` int(11) NOT NULL COMMENT '排序值',
  `status` smallint(1) NOT NULL COMMENT '状态.0禁用 1启用',
  `create_time` varchar(30) NOT NULL COMMENT '创建时间,UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  `update_time` varchar(30) NOT NULL COMMENT '更新时间,UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of p_help_center_type
-- ----------------------------


-- ----------------------------
-- Table structure for `p_help_center_content`
-- ----------------------------
DROP TABLE IF EXISTS `p_help_center_content`;
CREATE TABLE `p_help_center_content` (
  `id` varchar(40) NOT NULL,
  `title` varchar(200) NOT NULL COMMENT '标题',
  `html_content` longtext COMMENT '内容,富文本',
  `help_center_type_id` varchar(40) NOT NULL COMMENT '帮助中心类别id,引用p_help_center_type',
  `seq` int(11) NOT NULL COMMENT '排序值',
  `create_time` varchar(30) NOT NULL COMMENT '创建时间,UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  `update_time` varchar(30) NOT NULL COMMENT '更新时间,UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  `status` smallint(1) NOT NULL COMMENT '状态.0禁用 1启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of p_help_center_content
-- ----------------------------

-- ----------------------------
-- Table structure for p_account_reset_pwd
-- ----------------------------
DROP TABLE IF EXISTS `p_account_reset_pwd`;
CREATE TABLE `p_account_reset_pwd` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `login_id` varchar(60) CHARACTER SET utf8 NOT NULL COMMENT '登录账号',
  `mail_code` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '邮件验证码',
  `mail_code_expire` datetime DEFAULT NULL COMMENT '邮件验证码过期时间',
  `mail_code_status` tinyint(1) DEFAULT '0' COMMENT '邮件验证码状态, 0: 未验证，1：已验证',
  `phone` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '用户手机号码',
  `phone_code` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '手机验证码',
  `phone_code_expire` datetime DEFAULT NULL COMMENT '手机验证码过期时间',
  `phone_code_status` tinyint(1) DEFAULT '0' COMMENT '手机验证码状态, 0: 未验证，1：已验证',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='密码重置申请验证码表';


-- ----------------------------
-- Table structure for `p_position_recruitment`
-- ----------------------------
DROP TABLE IF EXISTS `p_position_recruitment`;
CREATE TABLE `p_position_recruitment` (
  `id` varchar(45) NOT NULL COMMENT '主键',
  `position` varchar(255) NOT NULL COMMENT '职位',
  `position_type` smallint(3) NOT NULL COMMENT '职位类型',
  `work_place` varchar(255) NOT NULL COMMENT '工作地点',
  `rec_num` smallint(5) NOT NULL COMMENT '招聘人数',
  `work_res` text NOT NULL COMMENT '工作职责',
  `work_need` text NOT NULL COMMENT '要求',
  `publish_date` varchar(30) NOT NULL COMMENT '录入时间',
  `update_date` varchar(30) DEFAULT NULL COMMENT '更新时间',
  `state` smallint(1) NOT NULL DEFAULT '0' COMMENT '使用状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for `p_biz_center`
-- ----------------------------
DROP TABLE IF EXISTS `p_biz_center`;
CREATE TABLE `p_biz_center` (
  `id` varchar(45) NOT NULL,
  `biz_name` varchar(50) NOT NULL,
  `sort` smallint(3) NOT NULL,
  `biz_parent` varchar(45) DEFAULT NULL,
  `biz_link` varchar(255) DEFAULT NULL,
  `update_date` varchar(30) NOT NULL DEFAULT '',
  `state` smallint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;