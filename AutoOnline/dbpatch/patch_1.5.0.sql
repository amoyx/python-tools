-- 必须按以下格式声明版本
-- ### VERSION: 1.5.0 ###--

ALTER TABLE `p_logis_segment`
ADD COLUMN `alloc_no` TINYINT(1) NULL DEFAULT '0' COMMENT '是否分配新单号' AFTER `order_readable`;

ALTER TABLE `p_logis_transfer`
ADD UNIQUE INDEX `UNIQUE_logisId_orderNo` (`logis_id` ASC, `order_no` ASC);

INSERT INTO `p_access_role` VALUES ('21', 'Merchant Operator', NOW(), NULL, 'Merchant Operator');
INSERT INTO `p_access_role` VALUES ('31', 'Platform Logistics Manager', NOW(), NULL, 'Platform Logistics Manager');

-- ----------------------------
-- Table structure for p_sys_province
-- 省
-- ----------------------------
ALTER TABLE `p_sys_province`
CHANGE COLUMN `provinceId` `province_id`  varchar(6) NULL DEFAULT NULL COMMENT '省ID' AFTER `id`,
CHANGE COLUMN `provinceName` `province_name`  varchar(40) NULL DEFAULT NULL COMMENT '省名称' AFTER `province_id`,
CHANGE COLUMN `countryId` `country_id`  varchar(40) NULL DEFAULT NULL COMMENT '省名称' AFTER `province_name`
;

-- ----------------------------
-- Table structure for p_sys_municipality
-- 市
-- ----------------------------
ALTER TABLE `p_sys_municipality`
CHANGE COLUMN `municipalityId` `municipality_id`  varchar(6) NULL DEFAULT NULL COMMENT '市ID' AFTER `id`,
CHANGE COLUMN `municipalityName` `municipality_name`  varchar(50) NULL DEFAULT NULL COMMENT '名称' AFTER `municipality_id`,
CHANGE COLUMN `provinceId` `province_id`  varchar(6) NULL DEFAULT NULL COMMENT '所属省' AFTER `municipality_name`
;

-- ----------------------------
-- Table structure for p_sys_district
-- 区/县
-- ----------------------------
ALTER TABLE `p_sys_district`
CHANGE COLUMN `countyID` `district_id`  varchar(50) NULL DEFAULT NULL COMMENT '区/县ID' AFTER `id`,
CHANGE COLUMN `countyName` `district_name`  varchar(60) NULL DEFAULT NULL COMMENT '区/县名称' AFTER `district_id`,
CHANGE COLUMN `municipalityId` `municipality_id`  varchar(6) NULL DEFAULT NULL COMMENT '所属市ID' AFTER `district_name`
;


-- ----------------------------
-- Table structure for p_sys_currency_code
-- ----------------------------
CREATE TABLE `p_sys_currency_code` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `currency_code` varchar(3) NOT NULL COMMENT '货币代码',
  `currency_name` varchar(255) NOT NULL COMMENT '货币名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 COMMENT='国际货币名称代码对照表';

-- ----------------------------
-- Records of p_sys_currency_code
-- ----------------------------

INSERT INTO `p_sys_currency_code` VALUES ('1', 'RMB', '人民币');
INSERT INTO `p_sys_currency_code` VALUES ('2', 'ATS', '奥地利先令');
INSERT INTO `p_sys_currency_code` VALUES ('3', 'AUD', '澳大利亚元');
INSERT INTO `p_sys_currency_code` VALUES ('4', 'BEF', '比利时法郎');
INSERT INTO `p_sys_currency_code` VALUES ('5', 'CAD', '加拿大元');
INSERT INTO `p_sys_currency_code` VALUES ('6', 'CHF', '瑞士法郎');
INSERT INTO `p_sys_currency_code` VALUES ('7', 'DEM', '德国马克');
INSERT INTO `p_sys_currency_code` VALUES ('8', 'ESP', '西班牙比塞塔');
INSERT INTO `p_sys_currency_code` VALUES ('9', 'EUR', '欧元');
INSERT INTO `p_sys_currency_code` VALUES ('10', 'FIM', '芬兰马克');
INSERT INTO `p_sys_currency_code` VALUES ('11', 'FRF', '法国法郎');
INSERT INTO `p_sys_currency_code` VALUES ('12', 'GBP', '英镑');
INSERT INTO `p_sys_currency_code` VALUES ('13', 'HKD', '港币');
INSERT INTO `p_sys_currency_code` VALUES ('14', 'IDR', '印尼盾');
INSERT INTO `p_sys_currency_code` VALUES ('15', 'IEP', '爱尔兰镑');
INSERT INTO `p_sys_currency_code` VALUES ('16', 'ITL', '意大利里拉');
INSERT INTO `p_sys_currency_code` VALUES ('17', 'JPY', '日元');
INSERT INTO `p_sys_currency_code` VALUES ('18', 'KRW', '韩国元');
INSERT INTO `p_sys_currency_code` VALUES ('19', 'LUF', '卢森堡法郎');
INSERT INTO `p_sys_currency_code` VALUES ('20', 'MYR', '马来西亚林吉特');
INSERT INTO `p_sys_currency_code` VALUES ('21', 'NLG', '荷兰盾');
INSERT INTO `p_sys_currency_code` VALUES ('22', 'NZD', '新西兰元');
INSERT INTO `p_sys_currency_code` VALUES ('23', 'PHP', '菲律宾比索');
INSERT INTO `p_sys_currency_code` VALUES ('24', 'PTE', '葡萄牙埃斯库多');
INSERT INTO `p_sys_currency_code` VALUES ('25', 'SGD', '新加坡元');
INSERT INTO `p_sys_currency_code` VALUES ('26', 'SUR', '俄罗斯卢布');
INSERT INTO `p_sys_currency_code` VALUES ('27', 'THB', '泰国铢');
INSERT INTO `p_sys_currency_code` VALUES ('28', 'USD', '美元');
INSERT INTO `p_sys_currency_code` VALUES ('29', 'RMB', '人民币');
INSERT INTO `p_sys_currency_code` VALUES ('30', 'ATS', '奥地利先令');
INSERT INTO `p_sys_currency_code` VALUES ('31', 'AUD', '澳大利亚元');
INSERT INTO `p_sys_currency_code` VALUES ('32', 'BEF', '比利时法郎');
INSERT INTO `p_sys_currency_code` VALUES ('33', 'CAD', '加拿大元');
INSERT INTO `p_sys_currency_code` VALUES ('34', 'CHF', '瑞士法郎');
INSERT INTO `p_sys_currency_code` VALUES ('35', 'DEM', '德国马克');
INSERT INTO `p_sys_currency_code` VALUES ('36', 'ESP', '西班牙比塞塔');
INSERT INTO `p_sys_currency_code` VALUES ('37', 'EUR', '欧元');
INSERT INTO `p_sys_currency_code` VALUES ('38', 'FIM', '芬兰马克');
INSERT INTO `p_sys_currency_code` VALUES ('39', 'FRF', '法国法郎');
INSERT INTO `p_sys_currency_code` VALUES ('40', 'GBP', '英镑');
INSERT INTO `p_sys_currency_code` VALUES ('41', 'HKD', '港币');
INSERT INTO `p_sys_currency_code` VALUES ('42', 'IDR', '印尼盾');
INSERT INTO `p_sys_currency_code` VALUES ('43', 'IEP', '爱尔兰镑');
INSERT INTO `p_sys_currency_code` VALUES ('44', 'ITL', '意大利里拉');
INSERT INTO `p_sys_currency_code` VALUES ('45', 'JPY', '日元');
INSERT INTO `p_sys_currency_code` VALUES ('46', 'KRW', '韩国元');
INSERT INTO `p_sys_currency_code` VALUES ('47', 'LUF', '卢森堡法郎');
INSERT INTO `p_sys_currency_code` VALUES ('48', 'MYR', '马来西亚林吉特');
INSERT INTO `p_sys_currency_code` VALUES ('49', 'NLG', '荷兰盾');
INSERT INTO `p_sys_currency_code` VALUES ('50', 'NZD', '新西兰元');
INSERT INTO `p_sys_currency_code` VALUES ('51', 'PHP', '菲律宾比索');
INSERT INTO `p_sys_currency_code` VALUES ('52', 'PTE', '葡萄牙埃斯库多');
INSERT INTO `p_sys_currency_code` VALUES ('53', 'SGD', '新加坡元');
INSERT INTO `p_sys_currency_code` VALUES ('54', 'SUR', '俄罗斯卢布');
INSERT INTO `p_sys_currency_code` VALUES ('55', 'THB', '泰国铢');
INSERT INTO `p_sys_currency_code` VALUES ('56', 'USD', '美元');
INSERT INTO `p_sys_currency_code` VALUES ('57', 'TWD', '新台币');
INSERT INTO `p_sys_currency_code` VALUES ('58', 'MOP', '澳门元');
INSERT INTO `p_sys_currency_code` VALUES ('59', 'INR', '印度卢比');
INSERT INTO `p_sys_currency_code` VALUES ('60', 'IDR', '印尼卢比');
INSERT INTO `p_sys_currency_code` VALUES ('61', 'DKK', '丹麦克朗');
INSERT INTO `p_sys_currency_code` VALUES ('62', 'AED', '阿联酋迪拉姆');
INSERT INTO `p_sys_currency_code` VALUES ('63', 'BRL', '巴西里亚尔');
INSERT INTO `p_sys_currency_code` VALUES ('64', 'MYR', '林吉特');
INSERT INTO `p_sys_currency_code` VALUES ('65', 'NOK', '挪威克朗');
INSERT INTO `p_sys_currency_code` VALUES ('66', 'SEK', '瑞典克朗');
INSERT INTO `p_sys_currency_code` VALUES ('67', 'RUB', '卢布');
INSERT INTO `p_sys_currency_code` VALUES ('68', 'ZAR', '南非兰特');



-- ----------------------------
-- Table structure for p_sys_exchange_rate
-- ----------------------------
CREATE TABLE `p_sys_exchange_rate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `currency_code` varchar(255) DEFAULT NULL COMMENT '货币代码',
  `currency_name` varchar(255) NOT NULL COMMENT '货币中文名称',
  `convert_price` decimal(10,2) NOT NULL COMMENT '折算价',
  `source` varchar(255) DEFAULT NULL COMMENT '来源',
  `publish_time` datetime NOT NULL COMMENT '发布时间',
  `acquire_time` datetime NOT NULL COMMENT '获得时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=76  COMMENT='实时汇率表';


-- ----------------------------
-- Records of p_sys_exchange_rate
-- ----------------------------
INSERT INTO `p_sys_exchange_rate` VALUES ('1', 'AED', '阿联酋迪拉姆', '177.37', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('2', 'AUD', '澳大利亚元', '486.29', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('3', 'BRL', '巴西里亚尔', '172.94', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('4', 'CAD', '加拿大元', '488.11', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('5', 'CHF', '瑞士法郎', '659.87', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('6', 'DKK', '丹麦克朗', '96.99', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('7', 'EUR', '欧元', '723.31', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('8', 'GBP', '英镑', '921.81', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('9', 'HKD', '港币', '83.99', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('10', 'IDR', '印尼卢比', '0.05', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('11', 'INR', '印度卢比', '9.67', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('12', 'JPY', '日元', '5.76', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('13', 'KRW', '韩国元', '0.55', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('14', 'MOP', '澳门元', '81.46', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('15', 'MYR', '林吉特', '158.13', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('16', 'NOK', '挪威克朗', '76.10', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('17', 'NZD', '新西兰元', '430.62', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('18', 'PHP', '菲律宾比索', '13.89', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('19', 'RUB', '卢布', '9.19', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('20', 'SEK', '瑞典克朗', '78.20', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('21', 'SGD', '新加坡元', '471.79', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('22', 'THB', '泰国铢', '18.56', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('23', 'TWD', '新台币', '19.83', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('24', 'USD', '美元', '651.72', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('25', 'ZAR', '南非兰特', '40.80', 'www.boc.cn', '2016-03-16 11:29:39', '2016-03-16 11:43:29');
INSERT INTO `p_sys_exchange_rate` VALUES ('76', 'AED', '阿联酋迪拉姆', '177.35', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('77', 'AUD', '澳大利亚元', '490.52', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('78', 'BRL', '巴西里亚尔', '176.95', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('79', 'CAD', '加拿大元', '492.51', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('80', 'CHF', '瑞士法郎', '668.06', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('81', 'DKK', '丹麦克朗', '97.53', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('82', 'EUR', '欧元', '727.85', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('83', 'GBP', '英镑', '921.75', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('84', 'HKD', '港币', '84.05', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('85', 'IDR', '印尼卢比', '0.05', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('86', 'INR', '印度卢比', '9.74', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('87', 'JPY', '日元', '5.77', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('88', 'KRW', '韩国元', '0.56', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('89', 'MOP', '澳门元', '81.58', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('90', 'MYR', '林吉特', '162.19', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('91', 'NOK', '挪威克朗', '76.70', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('92', 'NZD', '新西兰元', '438.63', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('93', 'PHP', '菲律宾比索', '14.04', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('94', 'RUB', '卢布', '9.46', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('95', 'SEK', '瑞典克朗', '78.42', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('96', 'SGD', '新加坡元', '475.73', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('97', 'THB', '泰国铢', '18.44', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('98', 'TWD', '新台币', '20.00', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('99', 'USD', '美元', '652.23', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('100', 'ZAR', '南非兰特', '42.12', 'www.boc.cn', '2016-03-25 14:14:03', '2016-03-25 14:41:01');
INSERT INTO `p_sys_exchange_rate` VALUES ('101', 'AED', '阿联酋迪拉姆', '177.35', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('102', 'AUD', '澳大利亚元', '490.52', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('103', 'BRL', '巴西里亚尔', '176.95', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('104', 'CAD', '加拿大元', '492.51', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('105', 'CHF', '瑞士法郎', '668.06', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('106', 'DKK', '丹麦克朗', '97.53', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('107', 'EUR', '欧元', '727.85', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('108', 'GBP', '英镑', '921.75', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('109', 'HKD', '港币', '84.05', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('110', 'IDR', '印尼卢比', '0.05', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('111', 'INR', '印度卢比', '9.74', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('112', 'JPY', '日元', '5.77', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('113', 'KRW', '韩国元', '0.56', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('114', 'MOP', '澳门元', '81.58', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('115', 'MYR', '林吉特', '162.19', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('116', 'NOK', '挪威克朗', '76.70', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('117', 'NZD', '新西兰元', '438.63', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('118', 'PHP', '菲律宾比索', '14.04', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('119', 'RUB', '卢布', '9.46', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('120', 'SEK', '瑞典克朗', '78.42', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('121', 'SGD', '新加坡元', '475.73', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('122', 'THB', '泰国铢', '18.44', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('123', 'TWD', '新台币', '20.00', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('124', 'USD', '美元', '652.23', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('125', 'ZAR', '南非兰特', '42.12', 'www.boc.cn', '2016-03-25 14:43:21', '2016-03-25 14:44:27');
INSERT INTO `p_sys_exchange_rate` VALUES ('126', 'AED', '阿联酋迪拉姆', '177.35', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('127', 'AUD', '澳大利亚元', '490.52', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('128', 'BRL', '巴西里亚尔', '176.95', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('129', 'CAD', '加拿大元', '492.51', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('130', 'CHF', '瑞士法郎', '668.06', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('131', 'DKK', '丹麦克朗', '97.53', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('132', 'EUR', '欧元', '727.85', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('133', 'GBP', '英镑', '921.75', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('134', 'HKD', '港币', '84.05', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('135', 'IDR', '印尼卢比', '0.05', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('136', 'INR', '印度卢比', '9.74', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('137', 'JPY', '日元', '5.77', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('138', 'KRW', '韩国元', '0.56', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('139', 'MOP', '澳门元', '81.58', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('140', 'MYR', '林吉特', '162.19', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('141', 'NOK', '挪威克朗', '76.70', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('142', 'NZD', '新西兰元', '438.63', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('143', 'PHP', '菲律宾比索', '14.04', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('144', 'RUB', '卢布', '9.46', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('145', 'SEK', '瑞典克朗', '78.42', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('146', 'SGD', '新加坡元', '475.73', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('147', 'THB', '泰国铢', '18.44', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('148', 'TWD', '新台币', '20.00', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('149', 'USD', '美元', '652.23', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('150', 'ZAR', '南非兰特', '42.12', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:26');
INSERT INTO `p_sys_exchange_rate` VALUES ('151', 'AED', '阿联酋迪拉姆', '177.35', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('152', 'AUD', '澳大利亚元', '490.52', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('153', 'BRL', '巴西里亚尔', '176.95', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('154', 'CAD', '加拿大元', '492.51', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('155', 'CHF', '瑞士法郎', '668.06', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('156', 'DKK', '丹麦克朗', '97.53', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('157', 'EUR', '欧元', '727.85', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('158', 'GBP', '英镑', '921.75', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('159', 'HKD', '港币', '84.05', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('160', 'IDR', '印尼卢比', '0.05', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('161', 'INR', '印度卢比', '9.74', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('162', 'JPY', '日元', '5.77', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('163', 'KRW', '韩国元', '0.56', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('164', 'MOP', '澳门元', '81.58', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('165', 'MYR', '林吉特', '162.19', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('166', 'NOK', '挪威克朗', '76.70', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('167', 'NZD', '新西兰元', '438.63', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('168', 'PHP', '菲律宾比索', '14.04', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('169', 'RUB', '卢布', '9.46', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('170', 'SEK', '瑞典克朗', '78.42', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('171', 'SGD', '新加坡元', '475.73', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('172', 'THB', '泰国铢', '18.44', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('173', 'TWD', '新台币', '20.00', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('174', 'USD', '美元', '652.23', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('175', 'ZAR', '南非兰特', '42.12', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:06:52');
INSERT INTO `p_sys_exchange_rate` VALUES ('176', 'AED', '阿联酋迪拉姆', '177.35', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('177', 'AUD', '澳大利亚元', '490.52', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('178', 'BRL', '巴西里亚尔', '176.95', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('179', 'CAD', '加拿大元', '492.51', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('180', 'CHF', '瑞士法郎', '668.06', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('181', 'DKK', '丹麦克朗', '97.53', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('182', 'EUR', '欧元', '727.85', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('183', 'GBP', '英镑', '921.75', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('184', 'HKD', '港币', '84.05', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('185', 'IDR', '印尼卢比', '0.05', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('186', 'INR', '印度卢比', '9.74', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('187', 'JPY', '日元', '5.77', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('188', 'KRW', '韩国元', '0.56', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('189', 'MOP', '澳门元', '81.58', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('190', 'MYR', '林吉特', '162.19', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('191', 'NOK', '挪威克朗', '76.70', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('192', 'NZD', '新西兰元', '438.63', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('193', 'PHP', '菲律宾比索', '14.04', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('194', 'RUB', '卢布', '9.46', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('195', 'SEK', '瑞典克朗', '78.42', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('196', 'SGD', '新加坡元', '475.73', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('197', 'THB', '泰国铢', '18.44', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('198', 'TWD', '新台币', '20.00', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('199', 'USD', '美元', '652.23', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('200', 'ZAR', '南非兰特', '42.12', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:07:53');
INSERT INTO `p_sys_exchange_rate` VALUES ('201', 'AED', '阿联酋迪拉姆', '177.35', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('202', 'AUD', '澳大利亚元', '490.52', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('203', 'BRL', '巴西里亚尔', '176.95', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('204', 'CAD', '加拿大元', '492.51', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('205', 'CHF', '瑞士法郎', '668.06', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('206', 'DKK', '丹麦克朗', '97.53', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('207', 'EUR', '欧元', '727.85', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('208', 'GBP', '英镑', '921.75', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('209', 'HKD', '港币', '84.05', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('210', 'IDR', '印尼卢比', '0.05', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('211', 'INR', '印度卢比', '9.74', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('212', 'JPY', '日元', '5.77', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('213', 'KRW', '韩国元', '0.56', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('214', 'MOP', '澳门元', '81.58', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('215', 'MYR', '林吉特', '162.19', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('216', 'NOK', '挪威克朗', '76.70', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('217', 'NZD', '新西兰元', '438.63', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('218', 'PHP', '菲律宾比索', '14.04', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('219', 'RUB', '卢布', '9.46', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('220', 'SEK', '瑞典克朗', '78.42', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('221', 'SGD', '新加坡元', '475.73', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('222', 'THB', '泰国铢', '18.44', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('223', 'TWD', '新台币', '20.00', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('224', 'USD', '美元', '652.23', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');
INSERT INTO `p_sys_exchange_rate` VALUES ('225', 'ZAR', '南非兰特', '42.12', 'www.boc.cn', '2016-03-25 16:03:49', '2016-03-25 16:08:04');

-- ----------------------------
-- Table structure for p_sys_zipcode
-- ----------------------------
CREATE TABLE `p_sys_zipcode` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `area_code` varchar(255) NOT NULL COMMENT '行政区代码',
  `area_name` varchar(255) NOT NULL COMMENT '行政区名称',
  `zip_code` varchar(6) NOT NULL COMMENT '邮政编码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=338 COMMENT='城市邮政编码对照表';

-- ----------------------------
-- Records of p_sys_zipcode
-- ----------------------------
INSERT INTO `p_sys_zipcode` VALUES ('1', '110000', '北京市', '100000');
INSERT INTO `p_sys_zipcode` VALUES ('2', '310000', '上海市', '200000');
INSERT INTO `p_sys_zipcode` VALUES ('3', '120000', '天津市', '300000');
INSERT INTO `p_sys_zipcode` VALUES ('4', '500000', '重庆市', '404100');
INSERT INTO `p_sys_zipcode` VALUES ('5', '340200', '芜湖市', '241000');
INSERT INTO `p_sys_zipcode` VALUES ('6', '340300', '蚌埠市', '233000');
INSERT INTO `p_sys_zipcode` VALUES ('7', '340400', '淮南市', '232000');
INSERT INTO `p_sys_zipcode` VALUES ('8', '340500', '马鞍山市', '243000');
INSERT INTO `p_sys_zipcode` VALUES ('9', '340600', '淮北市', '235000');
INSERT INTO `p_sys_zipcode` VALUES ('10', '340700', '铜陵市', '244000');
INSERT INTO `p_sys_zipcode` VALUES ('11', '340800', '安庆市', '246000');
INSERT INTO `p_sys_zipcode` VALUES ('12', '341000', '黄山市', '242700');
INSERT INTO `p_sys_zipcode` VALUES ('13', '341100', '滁州市', '239000');
INSERT INTO `p_sys_zipcode` VALUES ('14', '341200', '阜阳市', '236000');
INSERT INTO `p_sys_zipcode` VALUES ('15', '341300', '宿州市', '234000');
INSERT INTO `p_sys_zipcode` VALUES ('16', '341400', '巢湖市', '238000');
INSERT INTO `p_sys_zipcode` VALUES ('17', '341500', '六安市', '237000');
INSERT INTO `p_sys_zipcode` VALUES ('18', '341600', '亳州市', '236000');
INSERT INTO `p_sys_zipcode` VALUES ('19', '341700', '池州市', '247100');
INSERT INTO `p_sys_zipcode` VALUES ('20', '341800', '宣城市', '242000');
INSERT INTO `p_sys_zipcode` VALUES ('21', '350100', '福州市', '350000');
INSERT INTO `p_sys_zipcode` VALUES ('22', '350200', '厦门市', '361000');
INSERT INTO `p_sys_zipcode` VALUES ('23', '350300', '莆田市', '351100');
INSERT INTO `p_sys_zipcode` VALUES ('24', '350400', '三明市', '365000');
INSERT INTO `p_sys_zipcode` VALUES ('25', '350500', '泉州市', '362000');
INSERT INTO `p_sys_zipcode` VALUES ('26', '350600', '漳州市', '363000');
INSERT INTO `p_sys_zipcode` VALUES ('27', '350700', '南平市', '353000');
INSERT INTO `p_sys_zipcode` VALUES ('28', '350800', '龙岩市', '364000');
INSERT INTO `p_sys_zipcode` VALUES ('29', '350900', '宁德市', '352000');
INSERT INTO `p_sys_zipcode` VALUES ('30', '620100', '兰州市', '730000');
INSERT INTO `p_sys_zipcode` VALUES ('31', '620200', '嘉峪关市', '735100');
INSERT INTO `p_sys_zipcode` VALUES ('32', '620300', '金昌市', '737100');
INSERT INTO `p_sys_zipcode` VALUES ('33', '620400', '白银市', '730900');
INSERT INTO `p_sys_zipcode` VALUES ('34', '620500', '天水市', '741000');
INSERT INTO `p_sys_zipcode` VALUES ('35', '620600', '武威市', '733000');
INSERT INTO `p_sys_zipcode` VALUES ('36', '620700', '张掖市', '734000');
INSERT INTO `p_sys_zipcode` VALUES ('37', '620800', '平凉市', '744000');
INSERT INTO `p_sys_zipcode` VALUES ('38', '620900', '酒泉市', '735000');
INSERT INTO `p_sys_zipcode` VALUES ('39', '621000', '庆阳市', '745000');
INSERT INTO `p_sys_zipcode` VALUES ('40', '621100', '定西市', '743000');
INSERT INTO `p_sys_zipcode` VALUES ('41', '621200', '陇南市', '742500');
INSERT INTO `p_sys_zipcode` VALUES ('42', '', '临夏市', '731100');
INSERT INTO `p_sys_zipcode` VALUES ('43', '', '甘南市', '747000');
INSERT INTO `p_sys_zipcode` VALUES ('44', '440100', '广州市', '510000');
INSERT INTO `p_sys_zipcode` VALUES ('45', '440200', '韶关市', '512000');
INSERT INTO `p_sys_zipcode` VALUES ('46', '440300', '深圳市', '518000');
INSERT INTO `p_sys_zipcode` VALUES ('47', '440400', '珠海市', '519000');
INSERT INTO `p_sys_zipcode` VALUES ('48', '440500', '汕头市', '515000');
INSERT INTO `p_sys_zipcode` VALUES ('49', '440600', '佛山市', '528000');
INSERT INTO `p_sys_zipcode` VALUES ('50', '440700', '江门市', '529000');
INSERT INTO `p_sys_zipcode` VALUES ('51', '440800', '湛江市', '524000');
INSERT INTO `p_sys_zipcode` VALUES ('52', '440900', '茂名市', '525000');
INSERT INTO `p_sys_zipcode` VALUES ('53', '441200', '肇庆市', '526000');
INSERT INTO `p_sys_zipcode` VALUES ('54', '441300', '惠州市', '516000');
INSERT INTO `p_sys_zipcode` VALUES ('55', '441400', '梅州市', '514000');
INSERT INTO `p_sys_zipcode` VALUES ('56', '441500', '汕尾市', '516600');
INSERT INTO `p_sys_zipcode` VALUES ('57', '441600', '河源市', '517000');
INSERT INTO `p_sys_zipcode` VALUES ('58', '441700', '阳江市', '529500');
INSERT INTO `p_sys_zipcode` VALUES ('59', '441800', '清远市', '511500');
INSERT INTO `p_sys_zipcode` VALUES ('60', '441900', '东莞市', '523000');
INSERT INTO `p_sys_zipcode` VALUES ('61', '442000', '中山市', '528400');
INSERT INTO `p_sys_zipcode` VALUES ('62', '445100', '潮州市', '521000');
INSERT INTO `p_sys_zipcode` VALUES ('63', '445200', '揭阳市', '522000');
INSERT INTO `p_sys_zipcode` VALUES ('64', '445300', '云浮市', '527300');
INSERT INTO `p_sys_zipcode` VALUES ('65', '450100', '南宁市', '530000');
INSERT INTO `p_sys_zipcode` VALUES ('66', '450200', '柳州市', '545000');
INSERT INTO `p_sys_zipcode` VALUES ('67', '450300', '桂林市', '541000');
INSERT INTO `p_sys_zipcode` VALUES ('68', '450400', '梧州市', '543000');
INSERT INTO `p_sys_zipcode` VALUES ('69', '450500', '北海市', '536000');
INSERT INTO `p_sys_zipcode` VALUES ('70', '450600', '防城港市', '538000');
INSERT INTO `p_sys_zipcode` VALUES ('71', '450700', '钦州市', '535000');
INSERT INTO `p_sys_zipcode` VALUES ('72', '450800', '贵港市', '537000');
INSERT INTO `p_sys_zipcode` VALUES ('73', '450900', '玉林市', '537000');
INSERT INTO `p_sys_zipcode` VALUES ('74', '451000', '百色市', '533000');
INSERT INTO `p_sys_zipcode` VALUES ('75', '451100', '贺州市', '542800');
INSERT INTO `p_sys_zipcode` VALUES ('76', '451200', '河池市', '547000');
INSERT INTO `p_sys_zipcode` VALUES ('77', '451300', '来宾市', '546100');
INSERT INTO `p_sys_zipcode` VALUES ('78', '451400', '崇左市', '532200');
INSERT INTO `p_sys_zipcode` VALUES ('79', '520100', '贵阳市', '550000');
INSERT INTO `p_sys_zipcode` VALUES ('80', '520200', '六盘水市', '553000');
INSERT INTO `p_sys_zipcode` VALUES ('81', '520300', '遵义市', '563000');
INSERT INTO `p_sys_zipcode` VALUES ('82', '520400', '安顺市', '561000');
INSERT INTO `p_sys_zipcode` VALUES ('83', '522200', '铜仁地区', '554300');
INSERT INTO `p_sys_zipcode` VALUES ('84', '522300', '黔西南布依族苗族自治州', '562400');
INSERT INTO `p_sys_zipcode` VALUES ('85', '522400', '毕节地区', '551700');
INSERT INTO `p_sys_zipcode` VALUES ('86', '522600', '黔东南苗族侗族自治州', '556000');
INSERT INTO `p_sys_zipcode` VALUES ('87', '522700', '黔南布依族苗族自治州', '558000');
INSERT INTO `p_sys_zipcode` VALUES ('88', '460100', '海口市', '570100');
INSERT INTO `p_sys_zipcode` VALUES ('89', '460200', '三亚市', '572000');
INSERT INTO `p_sys_zipcode` VALUES ('90', '130100', '石家庄市', '050000');
INSERT INTO `p_sys_zipcode` VALUES ('91', '130200', '唐山市', '063000');
INSERT INTO `p_sys_zipcode` VALUES ('92', '130300', '秦皇岛市', '066000');
INSERT INTO `p_sys_zipcode` VALUES ('93', '130400', '邯郸市', '056000');
INSERT INTO `p_sys_zipcode` VALUES ('94', '130500', '邢台市', '054000');
INSERT INTO `p_sys_zipcode` VALUES ('95', '130600', '保定市', '071000');
INSERT INTO `p_sys_zipcode` VALUES ('96', '130700', '张家口市', '075000');
INSERT INTO `p_sys_zipcode` VALUES ('97', '130800', '承德市', '067000');
INSERT INTO `p_sys_zipcode` VALUES ('98', '130900', '沧州市', '061000');
INSERT INTO `p_sys_zipcode` VALUES ('99', '131000', '廊坊市', '065000');
INSERT INTO `p_sys_zipcode` VALUES ('100', '131100', '衡水市', '053000');
INSERT INTO `p_sys_zipcode` VALUES ('101', '230100', '哈尔滨市', '150000');
INSERT INTO `p_sys_zipcode` VALUES ('102', '230200', '齐齐哈尔市', '161000');
INSERT INTO `p_sys_zipcode` VALUES ('103', '230300', '鸡西市', '158100');
INSERT INTO `p_sys_zipcode` VALUES ('104', '230400', '鹤岗市', '154100');
INSERT INTO `p_sys_zipcode` VALUES ('105', '230500', '双鸭山市', '155100');
INSERT INTO `p_sys_zipcode` VALUES ('106', '230600', '大庆市', '163000');
INSERT INTO `p_sys_zipcode` VALUES ('107', '230700', '伊春市', '153000');
INSERT INTO `p_sys_zipcode` VALUES ('108', '230800', '佳木斯市', '154000');
INSERT INTO `p_sys_zipcode` VALUES ('109', '230900', '七台河市', '154600');
INSERT INTO `p_sys_zipcode` VALUES ('110', '231000', '牡丹江市', '157000');
INSERT INTO `p_sys_zipcode` VALUES ('111', '231100', '黑河市', '164300');
INSERT INTO `p_sys_zipcode` VALUES ('112', '231200', '绥化市', '152000');
INSERT INTO `p_sys_zipcode` VALUES ('113', '410100', '郑州市', '450000');
INSERT INTO `p_sys_zipcode` VALUES ('114', '410200', '开封市', '475000');
INSERT INTO `p_sys_zipcode` VALUES ('115', '410300', '洛阳市', '471000');
INSERT INTO `p_sys_zipcode` VALUES ('116', '410400', '平顶山市', '467000');
INSERT INTO `p_sys_zipcode` VALUES ('117', '410500', '安阳市', '455000');
INSERT INTO `p_sys_zipcode` VALUES ('118', '410600', '鹤壁市', '458000');
INSERT INTO `p_sys_zipcode` VALUES ('119', '410700', '新乡市', '453000');
INSERT INTO `p_sys_zipcode` VALUES ('120', '410800', '焦作市', '454150');
INSERT INTO `p_sys_zipcode` VALUES ('121', '410900', '濮阳市', '457000');
INSERT INTO `p_sys_zipcode` VALUES ('122', '411000', '许昌市', '461000');
INSERT INTO `p_sys_zipcode` VALUES ('123', '411100', '漯河市', '462000');
INSERT INTO `p_sys_zipcode` VALUES ('124', '411200', '三门峡市', '472000');
INSERT INTO `p_sys_zipcode` VALUES ('125', '411300', '南阳市', '473000');
INSERT INTO `p_sys_zipcode` VALUES ('126', '411400', '商丘市', '476000');
INSERT INTO `p_sys_zipcode` VALUES ('127', '411500', '信阳市', '464000');
INSERT INTO `p_sys_zipcode` VALUES ('128', '411600', '周口市', '466000');
INSERT INTO `p_sys_zipcode` VALUES ('129', '411700', '驻马店市', '463000');
INSERT INTO `p_sys_zipcode` VALUES ('130', '420100', '武汉市', '430000');
INSERT INTO `p_sys_zipcode` VALUES ('131', '420200', '黄石市', '435000');
INSERT INTO `p_sys_zipcode` VALUES ('132', '420300', '十堰市', '442000');
INSERT INTO `p_sys_zipcode` VALUES ('133', '420500', '宜昌市', '443000');
INSERT INTO `p_sys_zipcode` VALUES ('134', '', '襄阳市', '441000');
INSERT INTO `p_sys_zipcode` VALUES ('135', '420700', '鄂州市', '436000');
INSERT INTO `p_sys_zipcode` VALUES ('136', '420800', '荆门市', '448000');
INSERT INTO `p_sys_zipcode` VALUES ('137', '420900', '孝感市', '432000');
INSERT INTO `p_sys_zipcode` VALUES ('138', '421000', '荆州市', '434000');
INSERT INTO `p_sys_zipcode` VALUES ('139', '421100', '黄冈市', '438000');
INSERT INTO `p_sys_zipcode` VALUES ('140', '421200', '咸宁市', '437000');
INSERT INTO `p_sys_zipcode` VALUES ('141', '421300', '随州市', '441300');
INSERT INTO `p_sys_zipcode` VALUES ('142', '422800', '恩施土家族苗族自治州', '445000');
INSERT INTO `p_sys_zipcode` VALUES ('143', '430100', '长沙市', '410000');
INSERT INTO `p_sys_zipcode` VALUES ('144', '430200', '株洲市', '412000');
INSERT INTO `p_sys_zipcode` VALUES ('145', '430300', '湘潭市', '411100');
INSERT INTO `p_sys_zipcode` VALUES ('146', '430400', '衡阳市', '421000');
INSERT INTO `p_sys_zipcode` VALUES ('147', '430500', '邵阳市', '422000');
INSERT INTO `p_sys_zipcode` VALUES ('148', '430600', '岳阳市', '414000');
INSERT INTO `p_sys_zipcode` VALUES ('149', '430700', '常德市', '415000');
INSERT INTO `p_sys_zipcode` VALUES ('150', '', '津市', '415400');
INSERT INTO `p_sys_zipcode` VALUES ('151', '430800', '张家界市', '427000');
INSERT INTO `p_sys_zipcode` VALUES ('152', '430900', '益阳市', '413000');
INSERT INTO `p_sys_zipcode` VALUES ('153', '431000', '郴州市', '423000');
INSERT INTO `p_sys_zipcode` VALUES ('154', '', '资兴', '423400');
INSERT INTO `p_sys_zipcode` VALUES ('155', '431100', '永州市', '425000');
INSERT INTO `p_sys_zipcode` VALUES ('156', '431200', '怀化市', '418000');
INSERT INTO `p_sys_zipcode` VALUES ('157', '431300', '娄底市', '417000');
INSERT INTO `p_sys_zipcode` VALUES ('158', '433100', '湘西土家族苗族自治州', '416000');
INSERT INTO `p_sys_zipcode` VALUES ('159', '320100', '南京市', '210000');
INSERT INTO `p_sys_zipcode` VALUES ('160', '320200', '无锡市', '214000');
INSERT INTO `p_sys_zipcode` VALUES ('161', '320300', '徐州市', '221000');
INSERT INTO `p_sys_zipcode` VALUES ('162', '320400', '常州市', '213000');
INSERT INTO `p_sys_zipcode` VALUES ('163', '320500', '苏州市', '215000');
INSERT INTO `p_sys_zipcode` VALUES ('164', '320600', '南通市', '226000');
INSERT INTO `p_sys_zipcode` VALUES ('165', '320700', '连云港市', '222000');
INSERT INTO `p_sys_zipcode` VALUES ('166', '320800', '淮安市', '223001');
INSERT INTO `p_sys_zipcode` VALUES ('167', '320900', '盐城市', '224000');
INSERT INTO `p_sys_zipcode` VALUES ('168', '321000', '扬州市', '225000');
INSERT INTO `p_sys_zipcode` VALUES ('169', '321100', '镇江市', '212000');
INSERT INTO `p_sys_zipcode` VALUES ('170', '321200', '泰州市', '225300');
INSERT INTO `p_sys_zipcode` VALUES ('171', '321300', '宿迁市', '223800');
INSERT INTO `p_sys_zipcode` VALUES ('172', '360100', '南昌市', '330000');
INSERT INTO `p_sys_zipcode` VALUES ('173', '360200', '景德镇市', '333000');
INSERT INTO `p_sys_zipcode` VALUES ('174', '360300', '萍乡市', '337000');
INSERT INTO `p_sys_zipcode` VALUES ('175', '360400', '九江市', '332000');
INSERT INTO `p_sys_zipcode` VALUES ('176', '360500', '新余市', '338000');
INSERT INTO `p_sys_zipcode` VALUES ('177', '360600', '鹰潭市', '335000');
INSERT INTO `p_sys_zipcode` VALUES ('178', '360700', '赣州市', '341000');
INSERT INTO `p_sys_zipcode` VALUES ('179', '360800', '吉安市', '343000');
INSERT INTO `p_sys_zipcode` VALUES ('180', '360900', '宜春市', '336000');
INSERT INTO `p_sys_zipcode` VALUES ('181', '361000', '抚州市', '344000');
INSERT INTO `p_sys_zipcode` VALUES ('182', '361100', '上饶市', '334000');
INSERT INTO `p_sys_zipcode` VALUES ('183', '220100', '长春市', '130000');
INSERT INTO `p_sys_zipcode` VALUES ('184', '220200', '吉林市', '132000');
INSERT INTO `p_sys_zipcode` VALUES ('185', '220300', '四平市', '136000');
INSERT INTO `p_sys_zipcode` VALUES ('186', '220400', '辽源市', '136200');
INSERT INTO `p_sys_zipcode` VALUES ('187', '220500', '通化市', '134000');
INSERT INTO `p_sys_zipcode` VALUES ('188', '220600', '白山市', '134300');
INSERT INTO `p_sys_zipcode` VALUES ('189', '220700', '松原市', '138000');
INSERT INTO `p_sys_zipcode` VALUES ('190', '220800', '白城市', '137000');
INSERT INTO `p_sys_zipcode` VALUES ('191', '222400', '延边朝鲜族自治州', '133000');
INSERT INTO `p_sys_zipcode` VALUES ('192', '210100', '沈阳市', '110000');
INSERT INTO `p_sys_zipcode` VALUES ('193', '210200', '大连市', '116000');
INSERT INTO `p_sys_zipcode` VALUES ('194', '210300', '鞍山市', '114000');
INSERT INTO `p_sys_zipcode` VALUES ('195', '210400', '抚顺市', '113000');
INSERT INTO `p_sys_zipcode` VALUES ('196', '210500', '本溪市', '117000');
INSERT INTO `p_sys_zipcode` VALUES ('197', '210600', '丹东市', '118000');
INSERT INTO `p_sys_zipcode` VALUES ('198', '210700', '锦州市', '121000');
INSERT INTO `p_sys_zipcode` VALUES ('199', '210800', '营口市', '115000');
INSERT INTO `p_sys_zipcode` VALUES ('200', '210900', '阜新市', '123000');
INSERT INTO `p_sys_zipcode` VALUES ('201', '211000', '辽阳市', '111000');
INSERT INTO `p_sys_zipcode` VALUES ('202', '211100', '盘锦市', '124000');
INSERT INTO `p_sys_zipcode` VALUES ('203', '211200', '铁岭市', '112000');
INSERT INTO `p_sys_zipcode` VALUES ('204', '211300', '朝阳市', '122000');
INSERT INTO `p_sys_zipcode` VALUES ('205', '211400', '葫芦岛市', '125000');
INSERT INTO `p_sys_zipcode` VALUES ('206', '150100', '呼和浩特市', '010000');
INSERT INTO `p_sys_zipcode` VALUES ('207', '150200', '包头市', '014000');
INSERT INTO `p_sys_zipcode` VALUES ('208', '150300', '乌海市', '016000');
INSERT INTO `p_sys_zipcode` VALUES ('209', '150400', '赤峰市', '024000');
INSERT INTO `p_sys_zipcode` VALUES ('210', '150500', '通辽市', '028000');
INSERT INTO `p_sys_zipcode` VALUES ('211', '150600', '鄂尔多斯市', '');
INSERT INTO `p_sys_zipcode` VALUES ('212', '150700', '呼伦贝尔市', '021000');
INSERT INTO `p_sys_zipcode` VALUES ('213', '150800', '巴彦淖尔市', '015000');
INSERT INTO `p_sys_zipcode` VALUES ('214', '150900', '乌兰察布市', '');
INSERT INTO `p_sys_zipcode` VALUES ('215', '152200', '兴安盟', '137400');
INSERT INTO `p_sys_zipcode` VALUES ('216', '152500', '锡林郭勒盟', '026000');
INSERT INTO `p_sys_zipcode` VALUES ('217', '152900', '阿拉善盟', '750306');
INSERT INTO `p_sys_zipcode` VALUES ('218', '640100', '银川市', '750000');
INSERT INTO `p_sys_zipcode` VALUES ('219', '640200', '石嘴山市', '753000');
INSERT INTO `p_sys_zipcode` VALUES ('220', '640300', '吴忠市', '751100');
INSERT INTO `p_sys_zipcode` VALUES ('221', '640400', '固原市', '756000');
INSERT INTO `p_sys_zipcode` VALUES ('222', '640500', '中卫市', '755000');
INSERT INTO `p_sys_zipcode` VALUES ('223', '630100', '西宁市', '810000');
INSERT INTO `p_sys_zipcode` VALUES ('224', '632100', '海东地区', '814000');
INSERT INTO `p_sys_zipcode` VALUES ('225', '632200', '海北藏族自治州', '812200');
INSERT INTO `p_sys_zipcode` VALUES ('226', '632300', '黄南藏族自治州', '811300');
INSERT INTO `p_sys_zipcode` VALUES ('227', '632500', '海南藏族自治州', '813000');
INSERT INTO `p_sys_zipcode` VALUES ('228', '632600', '果洛藏族自治州', '814000');
INSERT INTO `p_sys_zipcode` VALUES ('229', '632700', '玉树藏族自治州', '815000');
INSERT INTO `p_sys_zipcode` VALUES ('230', '632800', '海西蒙古族藏族自治州', '817000');
INSERT INTO `p_sys_zipcode` VALUES ('231', '370100', '济南市', '250000');
INSERT INTO `p_sys_zipcode` VALUES ('232', '370200', '青岛市', '266000');
INSERT INTO `p_sys_zipcode` VALUES ('233', '370300', '淄博市', '255000');
INSERT INTO `p_sys_zipcode` VALUES ('234', '370400', '枣庄市', '277000');
INSERT INTO `p_sys_zipcode` VALUES ('235', '370500', '东营市', '257000');
INSERT INTO `p_sys_zipcode` VALUES ('236', '370600', '烟台市', '264000');
INSERT INTO `p_sys_zipcode` VALUES ('237', '370700', '潍坊市', '261000');
INSERT INTO `p_sys_zipcode` VALUES ('238', '370800', '济宁市', '272000');
INSERT INTO `p_sys_zipcode` VALUES ('239', '370900', '泰安市', '271000');
INSERT INTO `p_sys_zipcode` VALUES ('240', '371000', '威海市', '264200');
INSERT INTO `p_sys_zipcode` VALUES ('241', '371100', '日照市', '276800');
INSERT INTO `p_sys_zipcode` VALUES ('242', '371200', '莱芜市', '271100');
INSERT INTO `p_sys_zipcode` VALUES ('243', '371300', '临沂市', '276000');
INSERT INTO `p_sys_zipcode` VALUES ('244', '371400', '德州市', '253000');
INSERT INTO `p_sys_zipcode` VALUES ('245', '371500', '聊城市', '252000');
INSERT INTO `p_sys_zipcode` VALUES ('246', '371600', '滨州市', '256600');
INSERT INTO `p_sys_zipcode` VALUES ('247', '', '菏泽市', '274000');
INSERT INTO `p_sys_zipcode` VALUES ('248', '610100', '西安市', '710000');
INSERT INTO `p_sys_zipcode` VALUES ('249', '610200', '铜川市', '727000');
INSERT INTO `p_sys_zipcode` VALUES ('250', '610300', '宝鸡市', '721000');
INSERT INTO `p_sys_zipcode` VALUES ('251', '610400', '咸阳市', '712000');
INSERT INTO `p_sys_zipcode` VALUES ('252', '610500', '渭南市', '714000');
INSERT INTO `p_sys_zipcode` VALUES ('253', '610600', '延安市', '716000');
INSERT INTO `p_sys_zipcode` VALUES ('254', '610700', '汉中市', '723000');
INSERT INTO `p_sys_zipcode` VALUES ('255', '610800', '榆林市', '719000');
INSERT INTO `p_sys_zipcode` VALUES ('256', '610900', '安康市', '725000');
INSERT INTO `p_sys_zipcode` VALUES ('257', '611000', '商洛市', '726000');
INSERT INTO `p_sys_zipcode` VALUES ('258', '140100', '太原市', '030000');
INSERT INTO `p_sys_zipcode` VALUES ('259', '140200', '大同市', '037000');
INSERT INTO `p_sys_zipcode` VALUES ('260', '140300', '阳泉市', '045000');
INSERT INTO `p_sys_zipcode` VALUES ('261', '140400', '长治市', '046000');
INSERT INTO `p_sys_zipcode` VALUES ('262', '140500', '晋城市', '048000');
INSERT INTO `p_sys_zipcode` VALUES ('263', '140600', '朔州市', '036000');
INSERT INTO `p_sys_zipcode` VALUES ('264', '140700', '晋中市', '030600');
INSERT INTO `p_sys_zipcode` VALUES ('265', '140800', '运城市', '044000');
INSERT INTO `p_sys_zipcode` VALUES ('266', '140900', '忻州市', '034000');
INSERT INTO `p_sys_zipcode` VALUES ('267', '141000', '临汾市', '041000');
INSERT INTO `p_sys_zipcode` VALUES ('268', '141100', '吕梁市', '033000');
INSERT INTO `p_sys_zipcode` VALUES ('269', '510100', '成都市', '610000');
INSERT INTO `p_sys_zipcode` VALUES ('270', '510300', '自贡市', '643000');
INSERT INTO `p_sys_zipcode` VALUES ('271', '510400', '攀枝花市', '617000');
INSERT INTO `p_sys_zipcode` VALUES ('272', '510500', '泸州市', '646000');
INSERT INTO `p_sys_zipcode` VALUES ('273', '510600', '德阳市', '618000');
INSERT INTO `p_sys_zipcode` VALUES ('274', '510700', '绵阳市', '621000');
INSERT INTO `p_sys_zipcode` VALUES ('275', '510800', '广元市', '628000');
INSERT INTO `p_sys_zipcode` VALUES ('276', '510900', '遂宁市', '629000');
INSERT INTO `p_sys_zipcode` VALUES ('277', '511000', '内江市', '641000');
INSERT INTO `p_sys_zipcode` VALUES ('278', '511100', '乐山市', '614000');
INSERT INTO `p_sys_zipcode` VALUES ('279', '511300', '南充市', '637000');
INSERT INTO `p_sys_zipcode` VALUES ('280', '511400', '眉山市', '620000');
INSERT INTO `p_sys_zipcode` VALUES ('281', '511500', '宜宾市', '644000');
INSERT INTO `p_sys_zipcode` VALUES ('282', '511600', '广安市', '638500');
INSERT INTO `p_sys_zipcode` VALUES ('283', '511700', '达州市', '635000');
INSERT INTO `p_sys_zipcode` VALUES ('284', '511800', '雅安市', '625000');
INSERT INTO `p_sys_zipcode` VALUES ('285', '511900', '巴中市', '636600');
INSERT INTO `p_sys_zipcode` VALUES ('286', '512000', '资阳市', '641300');
INSERT INTO `p_sys_zipcode` VALUES ('287', '513200', '阿坝藏族羌族自治州', '624000');
INSERT INTO `p_sys_zipcode` VALUES ('288', '513300', '甘孜藏族自治州', '626000');
INSERT INTO `p_sys_zipcode` VALUES ('289', '513400', '凉山彝族自治州', '615000');
INSERT INTO `p_sys_zipcode` VALUES ('290', '650100', '乌鲁木齐市', '830000');
INSERT INTO `p_sys_zipcode` VALUES ('291', '650200', '克拉玛依市', '834000');
INSERT INTO `p_sys_zipcode` VALUES ('292', '652100', '吐鲁番地区', '838000');
INSERT INTO `p_sys_zipcode` VALUES ('293', '652200', '哈密地区', '839000');
INSERT INTO `p_sys_zipcode` VALUES ('294', '652300', '昌吉回族自治州', '831100');
INSERT INTO `p_sys_zipcode` VALUES ('295', '', '博乐市', '833400');
INSERT INTO `p_sys_zipcode` VALUES ('296', '', '库尔勒市', '841000');
INSERT INTO `p_sys_zipcode` VALUES ('297', '652900', '阿克苏地区', '843000');
INSERT INTO `p_sys_zipcode` VALUES ('298', '', '阿图什市', '845350');
INSERT INTO `p_sys_zipcode` VALUES ('299', '653100', '喀什地区', '844000');
INSERT INTO `p_sys_zipcode` VALUES ('300', '653200', '和田地区', '848000');
INSERT INTO `p_sys_zipcode` VALUES ('301', '654000', '伊犁哈萨克自治州', '835000');
INSERT INTO `p_sys_zipcode` VALUES ('302', '654200', '塔城地区', '834700');
INSERT INTO `p_sys_zipcode` VALUES ('303', '654300', '阿勒泰地区', '');
INSERT INTO `p_sys_zipcode` VALUES ('304', '540100', '拉萨市', '850000');
INSERT INTO `p_sys_zipcode` VALUES ('305', '542100', '昌都地区', '854000');
INSERT INTO `p_sys_zipcode` VALUES ('306', '542200', '山南地区', '856000');
INSERT INTO `p_sys_zipcode` VALUES ('307', '542300', '日喀则地区', '857000');
INSERT INTO `p_sys_zipcode` VALUES ('308', '542400', '那曲地区', '852000');
INSERT INTO `p_sys_zipcode` VALUES ('309', '542500', '阿里地区', '859000');
INSERT INTO `p_sys_zipcode` VALUES ('310', '542600', '林芝地区', '860000');
INSERT INTO `p_sys_zipcode` VALUES ('311', '530100', '昆明市', '650000');
INSERT INTO `p_sys_zipcode` VALUES ('312', '530300', '曲靖市', '655000');
INSERT INTO `p_sys_zipcode` VALUES ('313', '530400', '玉溪市', '653100');
INSERT INTO `p_sys_zipcode` VALUES ('314', '530500', '保山市', '678000');
INSERT INTO `p_sys_zipcode` VALUES ('315', '530600', '昭通市', '657000');
INSERT INTO `p_sys_zipcode` VALUES ('316', '530700', '丽江市', '674100');
INSERT INTO `p_sys_zipcode` VALUES ('317', '', '普洱市', '665000');
INSERT INTO `p_sys_zipcode` VALUES ('318', '530900', '临沧市', '677000');
INSERT INTO `p_sys_zipcode` VALUES ('319', '532300', '楚雄彝族自治州', '675000');
INSERT INTO `p_sys_zipcode` VALUES ('320', '532500', '红河哈尼族彝族自治州', '661400');
INSERT INTO `p_sys_zipcode` VALUES ('321', '532600', '文山壮族苗族自治州', '663000');
INSERT INTO `p_sys_zipcode` VALUES ('322', '532800', '西双版纳傣族自治州', '666100');
INSERT INTO `p_sys_zipcode` VALUES ('323', '532900', '大理白族自治州', '671000');
INSERT INTO `p_sys_zipcode` VALUES ('324', '533100', '德宏傣族景颇族自治州', '678400');
INSERT INTO `p_sys_zipcode` VALUES ('325', '533300', '怒江傈僳族自治州', '673100');
INSERT INTO `p_sys_zipcode` VALUES ('326', '533400', '迪庆藏族自治州', '674400');
INSERT INTO `p_sys_zipcode` VALUES ('327', '330100', '杭州市', '310000');
INSERT INTO `p_sys_zipcode` VALUES ('328', '330200', '宁波市', '315000');
INSERT INTO `p_sys_zipcode` VALUES ('329', '330300', '温州市', '325000');
INSERT INTO `p_sys_zipcode` VALUES ('330', '330400', '嘉兴市', '314000');
INSERT INTO `p_sys_zipcode` VALUES ('331', '330500', '湖州市', '313000');
INSERT INTO `p_sys_zipcode` VALUES ('332', '330600', '绍兴市', '312000');
INSERT INTO `p_sys_zipcode` VALUES ('333', '330700', '金华市', '321000');
INSERT INTO `p_sys_zipcode` VALUES ('334', '330800', '衢州市', '324000');
INSERT INTO `p_sys_zipcode` VALUES ('335', '330900', '舟山市', '316000');
INSERT INTO `p_sys_zipcode` VALUES ('336', '331000', '台州市', '318000');
INSERT INTO `p_sys_zipcode` VALUES ('337', '331100', '丽水市', '323000');

-- ----------------------------
-- Table structure for p_sys_api
-- ----------------------------
CREATE TABLE `p_sys_api` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`account_code` VARCHAR(50) NULL DEFAULT NULL COMMENT '主账号Code',
	`key` VARCHAR(50) NULL DEFAULT NULL COMMENT 'key',
	`secret` VARCHAR(50) NULL DEFAULT NULL COMMENT 'scret',
	`type` INT(11) NOT NULL DEFAULT '2' COMMENT '类型：正式账号1，测试账号2',
	`enable` BIT(1) NOT NULL DEFAULT b'1' COMMENT '是否启用',
	`expiry_date` DATETIME NULL DEFAULT NULL COMMENT '过期时间',
	`description` VARCHAR(50) NULL DEFAULT NULL COMMENT '描述',
	`create_by` VARCHAR(50) NULL DEFAULT NULL,
	`create_date` DATETIME NULL DEFAULT NULL,
	`update_by` VARCHAR(50) NULL DEFAULT NULL,
	`update_date` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `key` (`key`)
)
COMMENT='开放Api'
ENGINE=InnoDB
AUTO_INCREMENT=46;


