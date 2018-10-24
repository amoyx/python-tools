-- 必须按以下格式声明版本
-- ### VERSION: 1.4.0 ###--


Insert into p_access_role values ('30', 'Primary Accounts Manager', NOW(), NULL, 'Primary Accounts Manager');

CREATE TABLE `p_account_auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '申请单ID',
  `account_code` varchar(16) DEFAULT NULL COMMENT '企业代码生成规则：YYMMDDxxxxCC 前6位年月日，中间四位数字序号（以后可扩展为带字母），后两位是校验码',
  `account_type` int(11) DEFAULT NULL COMMENT '企业类型',
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
  `create_time` datetime DEFAULT NULL COMMENT '录入时间',
  `biz_lic_image` varchar(500) DEFAULT NULL COMMENT '营业执照网址',
  `invitation_code` varchar(16) DEFAULT NULL COMMENT '邀请码',
  `creator` varchar(64) DEFAULT NULL COMMENT '创建人员的login id',
  `auditor` varchar(64) DEFAULT NULL COMMENT '审核人员的login id',
  `audit_time` datetime default null comment '审核时间',
  `audit_state` smallint(6) DEFAULT NULL COMMENT '以 Account 类定义为准. 0 - 未上传, 1 - 等待审核, 2 - 审核通过, 3 - 审核拒绝',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB COMMENT='企业认证信息(认证申请表单)';


CREATE TABLE `p_merchant` (
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
	`primary_login_id` VARCHAR(50) NOT NULL COMMENT '商家主账号ID',
	`create_by` VARCHAR(50) NULL DEFAULT NULL,
	`create_date` DATETIME NULL DEFAULT NULL,
	`update_by` VARCHAR(50) NULL DEFAULT NULL,
	`update_date` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`)
)
COMMENT='商家'
ENGINE=InnoDB
AUTO_INCREMENT=2;


CREATE TABLE `p_merchant_oms` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`merchant_id` INT(11) NOT NULL COMMENT '商家ID',
	`api_url` VARCHAR(250) NULL DEFAULT NULL COMMENT '地址',
	`api_secret` VARCHAR(100) NULL DEFAULT NULL COMMENT '授权',
	`enable` BIT(1) NOT NULL DEFAULT b'1' COMMENT '是否启用',
	`description` TEXT NULL COMMENT '描述',
	`create_by` VARCHAR(50) NULL DEFAULT NULL,
	`create_date` DATETIME NULL DEFAULT NULL,
	`update_by` VARCHAR(50) NULL DEFAULT NULL,
	`update_date` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`)
)
COMMENT='商家Oms相关Api'
ENGINE=InnoDB
AUTO_INCREMENT=2;


