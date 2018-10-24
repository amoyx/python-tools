--### VERSION: 1.0.0 ###---
--本版是在patch工具使用之前的数据库完整结构

-- ----------------------------
-- Table structure for p_account
-- ----------------------------
DROP TABLE IF EXISTS `p_account`;
CREATE TABLE `p_account` (
  `login_id` varchar(30) NOT NULL COMMENT '登录名',
  `password` varchar(40) NOT NULL COMMENT '密码生成规则：6位前缀+密码明文+密码盐，然后进行MD5转换，其中前缀在系统配置文件中指定，全系统唯一，密码盐每个用户随机生成10位字符串',
  `code` char(12) NOT NULL COMMENT '生成规则：YYMMDDxxxxPP，前6位日期时间，中间四位数字（以后可扩展为字母），最后两位校验码（算法待定）',
  `name` varchar(200) DEFAULT NULL COMMENT '企业名称',
  `account_type` smallint(6) DEFAULT NULL COMMENT '账号类型，用二进制位掩码的方式来确定，目前已定：1（0001）：商家账号，2（0010）：展示中心账号，4（0100）：物流账号',
  `email` varchar(50) DEFAULT NULL COMMENT '电子邮件',
  `mail_activate_code` varchar(50) DEFAULT NULL COMMENT '邮件激活码',
  `mail_activated` smallint(6) DEFAULT NULL COMMENT '邮件激活状态',
  `mail_activate_code_expire` datetime DEFAULT NULL COMMENT '邮件激活码过期时间',
  `phone` varchar(20) DEFAULT NULL COMMENT '管理员手机号',
  `phone_activated` smallint(6) DEFAULT NULL COMMENT '手机激活状态',
  `pass_reset_code` varchar(50) DEFAULT NULL COMMENT '密码找回验证码',
  `pass_reset_code_expire` datetime DEFAULT NULL COMMENT '密码重置验证码过期时间',
  `state` smallint(6) DEFAULT NULL COMMENT '账号状态：0: 正常，1：已禁用',
  `manager_name` varchar(50) DEFAULT NULL COMMENT '管理员姓名',
  `company_info_check_state` smallint(6) DEFAULT NULL COMMENT '企业信息审核状态，0：未审核，1：已提交审核，2：审核已通过，3:审核未通过',
  `company_info_check_msg` varchar(500) DEFAULT NULL COMMENT '企业信息审核不通过原因',
  `right_change_time` datetime DEFAULT NULL COMMENT '记录该账号权限最后修改时间戳，系统根据该时间戳来确定自上次点击后权限是否被修改。值保存日期时间的长整型值',
  `reg_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '注册时间',
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='企业账号，商家在Portal系统中的主账号';


-- ----------------------------
-- Table structure for p_account_check_code
-- ----------------------------
DROP TABLE IF EXISTS `p_account_check_code`;
CREATE TABLE `p_account_check_code` (
  `login_id` varchar(30) NOT NULL COMMENT '登录名',
  `salt` varchar(30) DEFAULT NULL COMMENT '盐',
  `create_time` datetime DEFAULT NULL COMMENT '录入时间',
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用以保存企业账号密码加密盐，为了防止被第三方脱库时很容易找到密码加密盐而造成密码安全性降低，所以把密码盐提取到单独的表。';


-- ----------------------------
-- Table structure for p_account_sub
-- ----------------------------
DROP TABLE IF EXISTS `p_account_sub`;
CREATE TABLE `p_account_sub` (
  `login_id` varchar(60) NOT NULL COMMENT '子账号登录名构成：子账号唯一码@主账号登录名',
  `password` varchar(40) NOT NULL COMMENT '密码生成规则：6位前缀+密码明文+密码盐，然后进行MD5转换，其中前缀在系统配置文件中指定，全系统唯一，密码盐每个用户随机生成10位字符串',
  `primary_login_id` varchar(30) NOT NULL,
  `name` varchar(50) NOT NULL COMMENT '账号名称',
  `access_right` varchar(4000) DEFAULT NULL COMMENT '访问权限由长字符串构成， 形如: x.y.z...，第一位是主模块ID，后面依次是各级子模块，如果某一级子模块是星号(*)则表示具有该级所有子模块权限，子账号能授予的权限在主账号权限范围内。模块定义请参见表:  modules',
  `right_change_time` datetime DEFAULT NULL COMMENT '记录该账号权限最后修改时间戳，系统根据该时间戳来确定自上次点击后权限是否被修改。值保存日期时间的长整型值',
  `creator` int(11) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`login_id`,`password`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户子账号';

-- ----------------------------
-- Table structure for p_account_type_right
-- ----------------------------
DROP TABLE IF EXISTS `p_account_type_right`;
CREATE TABLE `p_account_type_right` (
  `account_type` int(11) DEFAULT NULL COMMENT '账号类型',
  `module_id` varchar(30) NOT NULL COMMENT '模块ID由英文单词或单词简写构成，以便于直观识别模块信息'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='账号类型权限对照';



-- ----------------------------
-- Table structure for p_admin_account
-- ----------------------------
DROP TABLE IF EXISTS `p_admin_account`;
CREATE TABLE `p_admin_account` (
  `id` varchar(45) NOT NULL,
  `username` varchar(50) NOT NULL COMMENT '登录名',
  `password` varchar(100) NOT NULL COMMENT '登录密码',
  `nickname` varchar(100) DEFAULT NULL,
  `status` varchar(10) NOT NULL COMMENT '状态。枚举值。NORMAL：正常；DISABLED：禁用。',
  `create_time` varchar(30) NOT NULL COMMENT 'UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  `last_login_time` varchar(30) NOT NULL COMMENT '最后登录时间.UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  `phone_number` varchar(30) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `birthday` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for p_application_form
-- ----------------------------
DROP TABLE IF EXISTS `p_application_form`;
CREATE TABLE `p_application_form` (
  `form_id` int(11) NOT NULL COMMENT '申请单ID',
  `company_code` int(12) DEFAULT NULL COMMENT '企业代码生成规则：\r\n            YYMMDDxxxxCC \r\n            前6位年月日，中间四位数字序号（以后可扩展为带字母），后两位是校验码',
  `company_name` varchar(200) DEFAULT NULL COMMENT '企业中文名称',
  `short_name` varchar(100) DEFAULT NULL COMMENT '企业简称',
  `biz_lic_code` varchar(20) DEFAULT NULL COMMENT '营业执照注册号',
  `org_code` varchar(20) DEFAULT NULL COMMENT '组织机构代码',
  `customs_code` varchar(20) DEFAULT NULL COMMENT '企业海关编码',
  `ciq_code` varchar(20) DEFAULT NULL COMMENT '企业国检编码',
  `legal_rep` varchar(50) DEFAULT NULL COMMENT '企业法人代表',
  `legal_rep_id` varchar(20) DEFAULT NULL COMMENT '法人代表身份证号',
  `biz_scope` varchar(500) DEFAULT NULL COMMENT '经营范围',
  `reg_address` varchar(500) DEFAULT NULL COMMENT '工商注册地址',
  `homepage` varchar(200) DEFAULT NULL COMMENT '企业网址',
  `customs_book_no` varchar(20) DEFAULT NULL COMMENT '海关账册号',
  `creator` int(11) DEFAULT NULL COMMENT '录入人ID',
  `create_time` datetime DEFAULT NULL COMMENT '录入时间',
  `state` smallint(6) DEFAULT NULL COMMENT '状态，0：未审核，1：已审核，2：审核未通过',
  PRIMARY KEY (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='企业认证信息(认证申请表单)。\r\n该信息不在Portal中保存，企业提交后即同步到CESP系统，CESP系统根';



-- ----------------------------
-- Table structure for p_company_code_seq
-- ----------------------------
DROP TABLE IF EXISTS `p_company_code_seq`;
CREATE TABLE `p_company_code_seq` (
  `seq_date` date NOT NULL,
  `seq` int(11) NOT NULL,
  PRIMARY KEY (`seq_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='企业唯一识别码中间四位序列号，每天重新编号';


-- ----------------------------
-- Table structure for p_guestbook
-- ----------------------------
DROP TABLE IF EXISTS `p_guestbook`;
CREATE TABLE `p_guestbook` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(300) DEFAULT NULL COMMENT '主题',
  `content` varchar(4000) NOT NULL COMMENT '内容',
  `email` varchar(255) DEFAULT NULL COMMENT '联系邮箱',
  `ip` varchar(20) DEFAULT NULL COMMENT '留言人IP地址',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '留言时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态，0：未处理，1：已处理',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='网站留言表';

-- ----------------------------
-- Table structure for p_login_log
-- ----------------------------
DROP TABLE IF EXISTS `p_login_log`;
CREATE TABLE `p_login_log` (
  `log_id` bigint(40) NOT NULL AUTO_INCREMENT COMMENT '日志主键，自动增长',
  `login_id` varchar(30) DEFAULT NULL COMMENT '登录名',
  `login_ip` varchar(20) DEFAULT NULL COMMENT '登录IP',
  `login_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '登录时间',
  `login_state` smallint(6) DEFAULT NULL COMMENT '0: 登录失败，1：登录成功',
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户登录的所有时间记录';


-- ----------------------------
-- Table structure for p_modules
-- ----------------------------
DROP TABLE IF EXISTS `p_modules`;
CREATE TABLE `p_modules` (
  `module_id` varchar(30) NOT NULL COMMENT '模块ID由英文单词或单词简写构成，以便于直观识别模块信息',
  `name` varchar(100) DEFAULT NULL COMMENT '模块名称',
  `top_module_id` int(11) DEFAULT NULL COMMENT '顶级模块ID，主要是为了便于查询，如果不加该属性而要判断该模块隶属于哪个顶级模块，必须从当前一直回溯到顶级才可以',
  `parent_module_id` int(11) DEFAULT NULL COMMENT '上级模块ID，对于顶级模块，则为0',
  PRIMARY KEY (`module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统模块';



-- ----------------------------
-- Table structure for p_news
-- ----------------------------
DROP TABLE IF EXISTS `p_news`;
CREATE TABLE `p_news` (
  `id` varchar(45) NOT NULL,
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '标题',
  `sticky` smallint(1) DEFAULT '0' COMMENT '是否置顶 0不置顶 1置顶',
  `source` varchar(100) DEFAULT '' COMMENT '文章来源',
  `source_type` smallint(1) DEFAULT '0' COMMENT '类型 0 站内新闻 1 站外新闻',
  `url` varchar(255) DEFAULT NULL,
  `html_content` longtext,
  `create_time` varchar(30) DEFAULT NULL COMMENT 'UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  `update_time` varchar(30) DEFAULT NULL COMMENT 'UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  `status` smallint(1) NOT NULL DEFAULT '1' COMMENT '是否启用 0未启用 1启用',
  `news_type` smallint(1) NOT NULL COMMENT '类型 0  平台公告 1政府资讯 2行业新闻',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `tag` varchar(50) DEFAULT NULL COMMENT '标签',
  `publish_date` varchar(30) DEFAULT NULL COMMENT 'UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- ----------------------------
-- Table structure for p_phone_check_code
-- ----------------------------
DROP TABLE IF EXISTS `p_phone_check_code`;
CREATE TABLE `p_phone_check_code` (
  `ID` int(11) NOT NULL COMMENT '验证码ID',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `check_code` varchar(10) DEFAULT NULL COMMENT '验证码',
  `expire` datetime DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户手机验证码';

-- ----------------------------
-- Records of p_phone_check_code
-- ----------------------------

-- ----------------------------
-- Table structure for p_pic_news
-- ----------------------------
DROP TABLE IF EXISTS `p_pic_news`;
CREATE TABLE `p_pic_news` (
  `id` varchar(45) NOT NULL,
  `seq` int(11) NOT NULL COMMENT '序号',
  `url` varchar(255) NOT NULL COMMENT '跳转链接',
  `img_large_url` varchar(255) NOT NULL COMMENT '大图链接',
  `img_middle_url` varchar(255) NOT NULL COMMENT '中图链接',
  `img_small_url` varchar(255) NOT NULL COMMENT '小图链接',
  `update_time` varchar(30) NOT NULL COMMENT '更新时间,UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  `create_time` varchar(30) NOT NULL COMMENT '创建时间,UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  `status` smallint(1) NOT NULL COMMENT '状态 0禁用 1启用',
  `type` smallint(1) NOT NULL COMMENT '类型 0  平台公告 1政府资讯 2行业新闻',
  `title` varchar(255) NOT NULL COMMENT '标题',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for p_slide
-- ----------------------------
DROP TABLE IF EXISTS `p_slide`;
CREATE TABLE `p_slide` (
  `id` varchar(45) NOT NULL,
  `seq` int(11) NOT NULL COMMENT '序号',
  `url` varchar(255) NOT NULL COMMENT '跳转链接',
  `img_large_url` varchar(255) NOT NULL COMMENT '大图链接',
  `img_middle_url` varchar(255) NOT NULL COMMENT '中图链接',
  `img_small_url` varchar(255) NOT NULL COMMENT '小图链接',
  `update_time` varchar(30) NOT NULL COMMENT '更新时间,UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  `create_time` varchar(30) NOT NULL COMMENT '创建时间,UTC时间，ISO8601格式，例如：2099-01-02T04:05:06.716Z',
  `status` smallint(1) NOT NULL COMMENT '状态 0禁用 1启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


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
-- Table structure for tb_kjt_file
-- ----------------------------
DROP TABLE IF EXISTS `tb_kjt_file`;
CREATE TABLE `tb_kjt_file` (
  `ID` varchar(36) NOT NULL COMMENT '主键',
  `FILE_NAME` varchar(255) NOT NULL COMMENT '文件名',
  `ENTRY_DATE` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '录入时间',
  `FILE_PATH` varchar(255) NOT NULL COMMENT '文件在服务器路径',
  `ORIGINAL_FILE_NAME` varchar(255) NOT NULL COMMENT '原文件名',
  `FILE_SIZE` bigint(20) DEFAULT NULL COMMENT '文件大小',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文件存储表';


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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='密码重置申请验证码表';


-- ----------------------------
-- Table structure for `p_position_recruitment`
-- ----------------------------
DROP TABLE IF EXISTS `p_position_recruitment`;
CREATE TABLE `p_position_recruitment` (
  `id` varchar(45) NOT NULL COMMENT '主键',
  `position` varchar(255) NOT NULL COMMENT '职位',
  `position_type` smallint(3) NOT NULL COMMENT '职位类型',
  `work_place` varchar(255) NOT NULL COMMENT '工作地点',
  `rec_num` varchar(10) NOT NULL COMMENT '招聘人数',
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