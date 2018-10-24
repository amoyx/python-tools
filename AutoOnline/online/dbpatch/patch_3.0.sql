
CREATE TABLE `p_buyer_id` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) DEFAULT NULL COMMENT '买家手机号',
  `name` varchar(64) DEFAULT NULL COMMENT '买家姓名 对应身份证姓名',
  `id_num` varchar(36) DEFAULT NULL COMMENT '买家身份证号',
  `id_front_image` varchar(500) DEFAULT NULL COMMENT '买家身份证正面，例子： /id-photo/2016/08/23/3cae51f1-68d8-11e6-86f4-00163e002bca.jpg',
  `id_back_image` varchar(500) DEFAULT NULL COMMENT '买家身份证反面, 例子：/id-photo/2016/08/23/3cae51f1-68d8-11e6-86f4-00163e002bcb.png',
  `state` smallint(6) DEFAULT '0' COMMENT '审核状态 0-待审核 1-审核通过 101-审核失败',
  `created_at` datetime DEFAULT NULL COMMENT '上传时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;


CREATE TABLE `p_product_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `level` smallint(1) DEFAULT '1',
  `parent_id` int(11) DEFAULT '0' COMMENT '外键：所属的一级分类',
  `name` varchar(55) DEFAULT NULL COMMENT '商品中文名',
  `name_en` varchar(55) DEFAULT NULL COMMENT '商品英文名',
  `unit_name` varchar(55) DEFAULT NULL COMMENT '商品单位',
  `tax_num` int(11) DEFAULT NULL COMMENT '商品税号',
  `tax_rate` float DEFAULT NULL COMMENT '商品税率',
  `comments` varchar(55) DEFAULT NULL COMMENT '描述',
  `price_after_tax` float DEFAULT NULL COMMENT '完税价格',
  `tax_up_price` float DEFAULT NULL COMMENT '税率范围内商品最高价格',
  `tax_low_price` float DEFAULT NULL COMMENT '税率范围内商品最低价格',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=348 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `p_vendor_order` (
  `order_no` varchar(16) NOT NULL COMMENT '本网站单号',
  `route_no` varchar(16) NOT NULL COMMENT '路线号\n',
  `vendor_id` varchar(64) NOT NULL,
  `created_by` varchar(64) NOT NULL COMMENT '''创建者登录ID''',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total_weight` float DEFAULT NULL COMMENT '用户提供总重(KG)',
  `actual_total_weight` float DEFAULT NULL COMMENT '实际称重（用以计费）\n',
  `insured_amount` float DEFAULT NULL COMMENT '''保险金额(CNY)''',
  `oversea_logis_no` varchar(32) DEFAULT NULL,
  `note` varchar(127) DEFAULT NULL,
  `channel` varchar(127) DEFAULT NULL,
  `channel_order_no` varchar(32) DEFAULT NULL,
  `recipient_name` varchar(127) NOT NULL,
  `recipient_province` varchar(127) NOT NULL,
  `recipient_city` varchar(127) NOT NULL,
  `recipient_district` varchar(127) NOT NULL,
  `recipient_addr` varchar(127) NOT NULL,
  `recipient_phone` varchar(32) NOT NULL,
  `recipient_id` varchar(64) DEFAULT NULL,
  `sender_name` varchar(127) DEFAULT NULL,
  `sender_phone` varchar(32) DEFAULT NULL,
  `sender_addr` varchar(127) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '状态-1为删除的订单。',
  `recipient_id_detail` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_no`),
  KEY `idx_routeNo` (`route_no`),
  KEY `idx_vendorId` (`vendor_id`),
  KEY `idx_createdAt` (`created_at`),
  KEY `idx_status` (`status`),
  KEY `idx_channelOrderNo` (`channel_order_no`),
  KEY `idx_name_phone` (`recipient_name`,`recipient_phone`),
  KEY `idx_overseaLogisNo` (`oversea_logis_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `p_vendor_order_item` (
  `order_no` varchar(16) NOT NULL,
  `index` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `name` varchar(127) NOT NULL,
  `brand` varchar(127) NOT NULL,
  `spec` varchar(127) DEFAULT NULL,
  `count` int(11) NOT NULL,
  `price` float NOT NULL,
  `currency` varchar(8) DEFAULT 'CNY',
  `weight` float DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `idx_orderNo_index` (`order_no`,`index`),
  KEY `fk_categoryId_idx` (`category_id`),
  CONSTRAINT `fk_categoryId` FOREIGN KEY (`category_id`) REFERENCES `p_product_category` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `p_vendor_order_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` varchar(16) NOT NULL,
  `status` int(11) NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` varchar(64) DEFAULT NULL,
  `note` text,
  PRIMARY KEY (`id`),
  KEY `id_updatedAt` (`updated_at`),
  KEY `id_orderNo` (`order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


ALTER TABLE `p_access_role`
CHANGE COLUMN `created_at` `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间' ;
ALTER TABLE `p_logis_route`
ADD COLUMN `type` tinyint(1) DEFAULT NULL COMMENT '线路类型：0/NULL - 物流线路； 1 - 海外货站线路';
ALTER TABLE `p_logis_route`
ADD COLUMN  `require_id` tinyint(1) DEFAULT '0' COMMENT '0: 不需要；1: 需要身份证号；2: 需要身份证号以及照片;';

ALTER TABLE `p_logis_route`
ADD COLUMN  `waybill_no_prefix` varchar(8) DEFAULT '';
ALTER TABLE `p_logis_route`
ADD COLUMN  `waybill_no_suffix` varchar(8) DEFAULT '';

INSERT INTO `p_access_role` VALUES
  ('40', 'Vendor Account', NULL, NULL, 'Vendor Account'),
  ('41', 'Platform Waybill Manager', NULL, NULL, 'Platform Waybill Manager');

update p_account set company_info_check_state = 0 where company_info_check_state is null;
ALTER TABLE `p_account`
CHANGE COLUMN `company_info_check_state` `company_info_check_state` SMALLINT(6) NOT NULL DEFAULT 0 COMMENT '企业信息审核状态，0：未审核，1：已提交审核，2：审核已通过，3:审核未通过' ;

-- ----------------------------
-- Records of p_product_category
-- ----------------------------
INSERT INTO `p_product_category` VALUES ('1', '1', '0', '彩妆护理', 'Cosmetics/Skin Care', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('2', '1', '0', '车载/旅游/户外', 'Vehicle Equipments/Travel/Outdoor', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('3', '1', '0', '宠物用品/居家用品', 'Pet/Home Supplies', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('4', '1', '0', '厨房用品', 'Kitchen supplies', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('5', '1', '0', '服饰家纺', 'Clothing/Home Textiles', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('6', '1', '0', '家用护理品/小电器', 'Household/Small Electrical Appliances', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('7', '1', '0', '母婴用品', 'Maternal and Baby products', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('8', '1', '0', '清洁护理', 'Cleaning & Skin Care Products', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('9', '1', '0', '手表/眼镜/配饰', 'Watch/Glasses/Accessories', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('10', '1', '0', '数码影音', 'Digital Audio Products', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('11', '1', '0', '箱包/鞋靴', 'Luggage,Bag/Shoes', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('12', '1', '0', '烟酒茶饮', 'Tabacco/Alcohol/Tea/Beverage', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('13', '1', '0', '营养保健/食品', 'Nutrition, Health Care & Groceries', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('14', '1', '0', '运动/教育', 'Sports/Education', '', null, null, '', null, null, null);
INSERT INTO `p_product_category` VALUES ('15', '2', '10', '按键手机', 'Key Cellphone', '台', '11030121', '0.15', '型号', '1000', '2000', '500');
INSERT INTO `p_product_category` VALUES ('16', '2', '10', '触屏手机', 'Touch Screen Cellphone', '台', '11030122', '0.15', '型号', null, null, null);
INSERT INTO `p_product_category` VALUES ('17', '2', '10', '手机配件', 'Phone Accessories', '件', '11030150', '0.15', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('18', '2', '10', 'Mac', 'Mac', '台', '19010310', '0.15', '型号', '3000', '4000', '1000');
INSERT INTO `p_product_category` VALUES ('19', '2', '10', 'iPhone', 'iPhone', '台', '11030122', '0.15', '型号/内存', null, null, null);
INSERT INTO `p_product_category` VALUES ('20', '2', '10', 'iPad', 'iPad', '台', '19010320', '0.15', '型号/内存', null, null, null);
INSERT INTO `p_product_category` VALUES ('21', '2', '10', 'iPod', 'iPod', '台', '18010500', '0.3', '', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('22', '2', '10', 'iPhone配件', 'Iphone Accessories', '件', '11030150', '0.15', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('23', '2', '10', 'iPad配件', 'Ipad Accessories', '个', '19010490', '0.15', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('24', '2', '10', '数码相机', 'Digital Camera', '台', '17010110', '0.15', '', '2000', '4000', '1000');
INSERT INTO `p_product_category` VALUES ('25', '2', '10', '单电/微单相机', 'Single Camera/Single Lens Reflex Camera', '台', '17010110', '0.15', '品牌型号', '2000', '4000', '1000');
INSERT INTO `p_product_category` VALUES ('26', '2', '10', '单反相机', 'SLR Camera', '台', '17010121', '0.15', '品牌型号', '5000', '10000', '2500');
INSERT INTO `p_product_category` VALUES ('27', '2', '10', '便携摄像机', 'Camcorder', '台', '17020100', '0.15', '品牌', '4000', '8000', '2000');
INSERT INTO `p_product_category` VALUES ('28', '2', '10', '单反镜头', 'SLR Lens', '个', '17010122', '0.15', '品牌', '2000', '4000', '1000');
INSERT INTO `p_product_category` VALUES ('29', '2', '10', '其他相机镜头', 'Other Camera Lens', '件', '17039900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('30', '2', '10', '滤镜', 'Filter', '件', '17039900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('31', '2', '10', '闪光灯', 'Flash', '个', '17030200', '0.15', '', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('32', '2', '10', '支架', 'Camera Bracket', '个', '17030300', '0.15', '', '300', '600', '150');
INSERT INTO `p_product_category` VALUES ('33', '2', '10', '单反配件', 'SLR Accessories', '件', '17039900', '0.15', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('34', '2', '10', '数码配件', 'Digital Accessories', '件', '27000000', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('35', '2', '10', 'MP3', 'MP3 Player', '台', '18010400', '0.3', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('36', '2', '10', 'MP4', 'MP4 Player', '台', '18010500', '0.3', '', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('37', '2', '10', '耳机/耳麦/蓝牙耳机', 'Earphones/Headset/Bluetooth Earphone', '件', '11030150', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('38', '2', '10', '电脑/手机外设音箱', 'Computer/Mobile Speakers', '个', '19020300', '0.15', '', '50', '100', '25');
INSERT INTO `p_product_category` VALUES ('39', '2', '10', 'VCD/DVD播放机', 'VCD/DVD Player', '台', '18020400', '0.3', '', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('40', '2', '10', '功放', 'Amplifier', '台', '18020500', '0.3', '', '1000', '2000', '500');
INSERT INTO `p_product_category` VALUES ('41', '2', '10', '电子书', 'E-book', '台', '22010300', '0.15', '', '800', '1600', '400');
INSERT INTO `p_product_category` VALUES ('42', '2', '10', '录音笔', 'Digital Voice Recorder', '台', '18010100', '0.3', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('43', '2', '10', '麦克风', 'Microphone', '件', '18029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('44', '2', '10', '数码相框', 'Digital Photo Frame', '台', '17030500', '0.15', '', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('45', '2', '10', '唱片光盘', 'Compact Disk', '张', '18030400', '0.3', '', '30', '60', '15');
INSERT INTO `p_product_category` VALUES ('46', '2', '10', '笔记本', 'Laptop', '台', '19010310', '0.15', '品牌型号', '2000', '4000', '1000');
INSERT INTO `p_product_category` VALUES ('47', '2', '10', '平板电脑', 'Tablet', '台', '19010320', '0.15', '品牌型号', null, null, null);
INSERT INTO `p_product_category` VALUES ('48', '2', '10', '平板电脑配件', 'Tablet Accessories', '个', '19010490', '0.15', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('49', '2', '10', '台式机', 'Desktop Computer', '台', '19010100', '0.15', '', '2000', '4000', '1000');
INSERT INTO `p_product_category` VALUES ('50', '2', '10', '电脑配件', 'Computer Components', '个', '19010490', '0.15', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('51', '2', '10', '电脑外设', 'Computer Peripherals', '台', '19029900', '0.15', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('52', '2', '10', '路由器', 'Router', '台', '19029900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('53', '2', '10', '移动硬盘', 'Portable Hard Drive', '个', '19020911', '0.15', '容量', '300', '600', '150');
INSERT INTO `p_product_category` VALUES ('54', '2', '10', 'U盘', 'U Disk', '个', '19020920', '0.15', '内存容量', '50', '100', '25');
INSERT INTO `p_product_category` VALUES ('55', '2', '10', '游戏/软件光盘', 'Game/Software Discs', '张', '11030221', '0.15', '', '60', '120', '30');
INSERT INTO `p_product_category` VALUES ('56', '2', '10', '游戏机', 'Game Console', '台', '11030210', '0.15', '品牌型号', '1000', '2000', '500');
INSERT INTO `p_product_category` VALUES ('57', '2', '10', '游戏机手柄', 'Gamepad', '个', '11030222', '0.15', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('58', '2', '10', '音箱', 'Sound Box', '个', '18020600', '0.3', '', '1000', '2000', '500');
INSERT INTO `p_product_category` VALUES ('59', '2', '10', '其他数码产品', 'Other Digital Products', '个', '18000000', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('60', '2', '6', '家用空气清新器', 'Air Freshener', '台', '11031600', '0.3', '品牌型号', '1000', '2000', '500');
INSERT INTO `p_product_category` VALUES ('61', '2', '6', '家用扫地机', 'Household Sweeper', '台', '11031700', '0.3', '品牌型号', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('63', '2', '6', '电吹风', 'Hair Dryer', '个', '11021120', '0.3', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('64', '2', '6', '电动牙刷', 'Electric Toothbrush', '个', '11021140', '0.3', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('65', '2', '6', '美容器具', 'Beauty Appliance', '台', '10039900', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('66', '2', '6', '理发器', 'Barber', '台', '11021190', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('67', '2', '6', '美发器', 'Hair Waver', '台', '11021190', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('68', '2', '6', '洗脸刷', 'Face Cleaning Brush', '台', '10039900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('69', '2', '6', '鼻毛修剪器', 'Nose Hair Trimmer', '台', '11021190', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('70', '2', '6', '电动洗鼻器', 'Electric Nose Washing Apparatus', '台', '11021190', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('71', '2', '6', '电动洗牙器', 'Electric Tooth Cleaner', '台', '11021190', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('72', '2', '6', '按摩器', 'Massager', '件', '10029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('73', '2', '6', '血压计', 'Hemomanometer', '个', '10010500', '0.3', '', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('74', '2', '6', '血糖仪', 'Blood Glucose Meter', '个', '10010100', '0.3', '', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('75', '2', '6', '血糖试纸', 'Blood Glucose Test Strips', '张', '10010200', '0.3', '', '5', '10', '2.5');
INSERT INTO `p_product_category` VALUES ('76', '2', '6', '体温计/耳温计', 'Thermometer/Ear Thermometer', '个', '10010300', '0.3', '', '200', null, null);
INSERT INTO `p_product_category` VALUES ('77', '2', '6', '紫外线消毒棒', 'Uv Disinfection Stick', '件', '11020100', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('78', '2', '6', '计步器/脂肪检测仪', 'Pedometer/Fat Detector', '件', '10019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('79', '2', '6', '其他家用小电器', 'Other Small Household Appliance', '件', '11039990', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('80', '2', '4', '烹饪铲勺', 'Cooking Shovel and Spoon', '件', '11010200', '0.3', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('81', '2', '4', '烹饪锅具', 'Cookware', '件', '11010200', '0.3', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('82', '2', '4', '碗/盆/碟/刀叉', 'Bowl/Plate/Saucer/Knives and Forks', '个', '11010100', '0.3', '', '20', '40', '10');
INSERT INTO `p_product_category` VALUES ('83', '2', '4', '刀具/剪刀/磨刀器', 'Knives/Scissors/Knife Sharpener', '件', '11019910', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('84', '2', '4', '家用餐具/宝宝餐具', 'Tableware/Baby Tableware', '个', '11010100', '0.3', '', '20', '40', '10');
INSERT INTO `p_product_category` VALUES ('85', '2', '4', '调味盒', 'Seasoning Box', '件', '11019910', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('86', '2', '4', '开瓶器/削皮器', 'Bottle Opener/Vegetable Peeler', '件', '11019910', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('87', '2', '4', '制冰格/冰棒模', 'Ice Grid/Popsicle Grid', '件', '11019910', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('88', '2', '4', '打蛋器/蛋模', 'Eggbeater/Egg Molds', '件', '11019910', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('89', '2', '4', '净水器（含过滤芯）', 'Filter Purifier', '个', '11010400', '0.3', '', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('90', '2', '4', '净水器过滤芯', 'Filter Element', '个', '11010500', '0.3', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('91', '2', '4', '冰淇淋机（插电）', 'Electric Ice Cream Makers', '台', '11019990', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('92', '2', '4', '雪糕机（不插电）', 'Ice Cream Mold', '件', '11019910', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('93', '2', '4', '家用电饭煲', 'Household Electric Cooker', '个', '11011100', '0.3', '', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('94', '2', '4', '家用微波炉', 'Household Microwave Oven', '台', '11011200', '0.3', '', '600', '1200', '300');
INSERT INTO `p_product_category` VALUES ('95', '2', '4', '家用电磁炉', 'Household Electromagnetic Oven', '台', '11011300', '0.3', '', '800', '1600', '400');
INSERT INTO `p_product_category` VALUES ('96', '2', '4', '家用抽油烟机', 'Household Smoke Exhaust Ventilator', '台', '11011400', '0.3', '', '1000', '2000', '500');
INSERT INTO `p_product_category` VALUES ('97', '2', '4', '家用洗碗机', 'Household Dish Washers', '台', '11011500', '0.3', '', '1500', '3000', '750');
INSERT INTO `p_product_category` VALUES ('98', '2', '4', '家用电动榨汁机', 'Household Juicer', '台', '11011600', '0.3', '品牌,型号', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('99', '2', '4', '家用咖啡机', 'Household Coffee Maker', '台', '11011700', '0.3', '', '4000', '8000', '2000');
INSERT INTO `p_product_category` VALUES ('100', '2', '5', '上衣', 'Coat', '件', '4010100', '0.3', '', '300', '600', '150');
INSERT INTO `p_product_category` VALUES ('101', '2', '5', '西装', 'Suit', '件', '4010100', '0.3', '', '300', '600', '150');
INSERT INTO `p_product_category` VALUES ('102', '2', '5', '马甲', 'Waistcoat', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('103', '2', '5', '披肩/披风', 'Wraps/Mantle', '件', '4020200', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('104', '2', '5', '羽绒服', 'Down Jacket', '件', '4010100', '0.3', '', '300', '600', '150');
INSERT INTO `p_product_category` VALUES ('105', '2', '5', '外裤', 'Trousers', '件', '4010200', '0.3', '', '300', '400', '100');
INSERT INTO `p_product_category` VALUES ('106', '2', '5', 'T恤/Polo', 'T-Shirt/Polo Shirt', '件', '4010400', '0.3', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('107', '2', '5', '卫衣', 'Hoodie', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('108', '2', '5', '卫裤', 'Sweat Pants', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('109', '2', '5', '衬衫/T恤衫', 'Shirt/T-shirt', '件', '4010400', '0.3', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('110', '2', '5', '毛衣/针织衫', 'Sweater/Knitwear', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('111', '2', '5', '吊带衫', 'Braces Skirt', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('112', '2', '5', '裙子', 'Dress', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('113', '2', '5', '短裤', 'Shorts', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('114', '2', '5', '文胸/内衣裤', 'Bra/Underclothes', '件', '4010300', '0.3', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('115', '2', '5', '睡衣/睡裤/睡裙', 'Pajamas/Pyjama Trousers/Night Skirt', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('116', '2', '5', '孕妇装', 'Maternity Dress', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('117', '2', '5', '婴儿服饰/童装', 'Baby/Kid\'s Clothes', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('118', '2', '5', '袜子', 'Sock/Stocking', '双', '4029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('119', '2', '5', '皮带（真皮）', 'Belt(Leather)', '条', '5020200', '0.3', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('120', '2', '5', '腰带（非皮质）', 'Belt(Non-Leather)', '条', '4020400', '0.3', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('121', '2', '5', '帽子', 'Headgear', '顶', '4020100', '0.3', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('122', '2', '5', '围巾/头巾', 'Scarf/Kerchief', '条', '4020200', '0.3', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('123', '2', '5', '手套', 'Glove', '双', '4020500', '0.3', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('124', '2', '5', '领带', 'Tie', '条', '4020300', '0.3', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('125', '2', '5', '袖扣', 'Sleeve Button', '对', '4029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('126', '2', '5', '毛毯、被子、睡袋', 'Blanket/Quilt/sleeping bag', '条', '4030100', '0.3', '', '400', '200', '50');
INSERT INTO `p_product_category` VALUES ('127', '2', '5', '枕头、毛巾被', 'Pillow/Towel', '个', '4030200', '0.3', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('128', '2', '5', '床上纺织用品', 'Textile Beddings', '个', '4039900', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('129', '2', '1', '面霜', 'Face Cream', '个', '9020230', '0.3', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('130', '2', '1', '眼霜', 'Eye Cream', '个', '9020220', '0.3', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('131', '2', '1', '防晒/隔离霜', 'Sun Cream', '个', '9020250', '0.3', '', '150', '300', '75');
INSERT INTO `p_product_category` VALUES ('132', '2', '1', '洗面奶/洁面霜', 'Facial Cleanser', '支', '9020110', '0.3', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('133', '2', '1', '身体乳', 'Body Lotion', '个', '9020230', '0.3', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('134', '2', '1', '精华液', 'Essence', '支', '9020240', '0.3', '', '300', '600', '150');
INSERT INTO `p_product_category` VALUES ('135', '2', '1', '护手霜', 'Hand Lotion', '支', '9020280', '0.3', '', '50', '100', '25');
INSERT INTO `p_product_category` VALUES ('136', '2', '1', '粉底/遮瑕膏', 'Foundation Make-Up/Concealer', '个', '9010510', '0.6', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('137', '2', '1', '香水', 'Perfume', '个', '9010110', '0.6', '', '300', '600', '150');
INSERT INTO `p_product_category` VALUES ('138', '2', '1', '爽肤水', 'Toner', '个', '9020210', '0.3', '', '150', '300', '75');
INSERT INTO `p_product_category` VALUES ('139', '2', '1', '指甲油', 'Nail Polish', '个', '9010420', '0.6', '', '20', '40', '10');
INSERT INTO `p_product_category` VALUES ('140', '2', '1', '润唇膏（保湿）', 'Lip Balm', '支', '9020270', '0.3', '', '20', '40', '10');
INSERT INTO `p_product_category` VALUES ('141', '2', '1', '唇膏唇彩（着色）', 'Lip Gloss', '支', '9010210', '0.6', '', '150', '300', '75');
INSERT INTO `p_product_category` VALUES ('142', '2', '1', '面膜', 'Mask', '个', '9020260', '0.3', '', '20', '40', '10');
INSERT INTO `p_product_category` VALUES ('143', '2', '1', '腮红', 'Cheek Powder', '个', '9010540', '0.6', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('144', '2', '1', '眼影/眼线', 'Eyeliner', '个', '9010340', '0.6', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('145', '2', '1', '眉笔', 'Eyebrow Pencil', '个', '9010330', '0.6', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('146', '2', '1', '睫毛膏', 'Mascara', '个', '9010310', '0.6', '', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('147', '2', '1', '卸妆水/卸妆油', 'Cleansing Water/Oil', '支', '9020120', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('148', '2', '1', '染发/造型', 'Hair Dyes/Wax', '个', '9020390', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('149', '2', '1', '按摩精油', 'Massage Oil', '个', '9020290', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('150', '2', '1', '纤体露', 'Slimming Cream', '个', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('151', '2', '1', '脱毛膏', 'Depilatory Cream', '个', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('152', '2', '1', '化妆品套装', 'Cosmetic Kit', '个', '9029900', '0.3', '内件具体品名与数量', null, null, null);
INSERT INTO `p_product_category` VALUES ('153', '2', '1', '化妆刷/面扑/卸妆棉', 'Cosmetic Brush/Powder Puff/Cleansing Cotton', '个', '9020190', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('154', '2', '8', '洗发露', 'Shampoo', '件', '9020310', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('155', '2', '8', '护发素', 'Hair Conditioner', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('156', '2', '8', '沐浴乳', 'Body Wash', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('157', '2', '8', '剃须泡', 'Shaving Cream', '瓶', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('158', '2', '8', '磨砂/浴盐', 'Scrub Cream/ Bath Salt', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('159', '2', '8', '香皂', 'Soap', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('160', '2', '8', '脱毛膏', 'Depilatory Cream', '个', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('161', '2', '8', '牙膏/牙粉', 'Tooth Paste/Powder', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('162', '2', '8', '牙刷', 'Tooth Brush', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('163', '2', '8', '牙线', 'Dental Floss', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('164', '2', '8', '漱口水', 'Mouthwash', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('165', '2', '8', '卫生护垫', 'Tampons', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('166', '2', '8', '女性护理液', 'Feminine Hygiene Wash', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('167', '2', '8', '验孕试纸/验孕棒', 'Pregnancy Test Kit', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('168', '2', '8', '护理套装', 'Skin Care Kit', '件', '9029900', '0.3', '内件具体品名与数量', null, null, null);
INSERT INTO `p_product_category` VALUES ('169', '2', '8', '驱蚊膏/驱蚊液', 'Repellent Liquid/Cream', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('170', '2', '8', '洗手液/消毒液', 'Sanitizer/Disinfectant', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('171', '2', '8', '香薰精油', 'Essential Oil', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('172', '2', '8', '口罩', 'Respirator', '件', '10039900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('173', '2', '11', '钱包/卡包/零钱包', 'Wallet/Purse/Zero Wallet', '个', '6010300', '0.3', '品牌、材质、型号', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('174', '2', '11', '手拿包', 'Clutch', '个', '6010200', '0.3', '品牌、材质、型号', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('175', '2', '11', '单肩包', 'Single-shoulder Bag', '个', '6010200', '0.3', '品牌、材质、型号', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('176', '2', '11', '双肩包', 'Backpack', '个', '6010200', '0.3', '品牌、材质、型号', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('177', '2', '11', '手提包', 'Hand Bag', '个', '6010200', '0.3', '品牌、材质、型号', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('178', '2', '11', '电脑数码包', 'Laptop Bag', '件', '6019900', '0.3', '品牌、材质、型号', null, null, null);
INSERT INTO `p_product_category` VALUES ('179', '2', '11', '拉杆箱', 'Luggage', '个', '6010100', '0.3', '品牌、材质、型号', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('180', '2', '11', '腰包', 'Waist Bag', '个', '6010200', '0.3', '品牌、材质、型号', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('181', '2', '11', '儿童书包', 'Schoolbag', '个', '6010200', '0.3', '品牌、材质、型号', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('182', '2', '11', '化妆包', 'Cosmetic Bag', '件', '6019900', '0.3', '品牌、材质、型号', null, null, null);
INSERT INTO `p_product_category` VALUES ('183', '2', '11', '休闲鞋', 'Casual Shoes', '双', '6029900', '0.3', '品牌，材质', null, null, null);
INSERT INTO `p_product_category` VALUES ('184', '2', '11', '运动鞋', 'Sneaker', '双', '6020300', '0.3', '品牌，材质', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('185', '2', '11', '单鞋', 'Canvas Shoes', '双', '6029900', '0.3', '品牌，材质', null, null, null);
INSERT INTO `p_product_category` VALUES ('186', '2', '11', '真皮皮鞋', 'Leather Shoes', '双', '6020100', '0.3', '品牌', '300', '600', '150');
INSERT INTO `p_product_category` VALUES ('187', '2', '11', '凉鞋/拖鞋', 'Sandal/Slippers', '双', '6029900', '0.3', '品牌，材质', null, null, null);
INSERT INTO `p_product_category` VALUES ('188', '2', '11', '靴子', 'Boots', '双', '6020200', '0.3', '品牌，材质', '400', '800', '200');
INSERT INTO `p_product_category` VALUES ('189', '2', '11', '童鞋', 'Kid\'s Shoes', '双', '6029900', '0.3', '品牌，材质', null, null, null);
INSERT INTO `p_product_category` VALUES ('190', '2', '9', '石英表', 'Quartz Watch', '块', '7010210', '0.3', '品牌，型号', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('191', '2', '9', '电子表', 'Electronic Watch', '块', '7010210', '0.3', '品牌，型号', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('192', '2', '9', '机械表', 'Mechanical Watch', '块', '7010220', '0.3', '品牌，型号', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('193', '2', '9', '高档手表(10000元以上)', 'Luxury Watch(Values Over RMB 10,000)', '块', '7010100', '0.6', '品牌，型号', null, null, null);
INSERT INTO `p_product_category` VALUES ('194', '2', '9', '儿童手表', 'Kid\'s Swatch', '块', '7010290', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('195', '2', '9', '闹钟', 'Alarm Clock', '台', '7020100', '0.3', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('196', '2', '9', '太阳镜', 'Sunglasses', '件', '27000000', '0.3', '品牌和型号', null, null, null);
INSERT INTO `p_product_category` VALUES ('197', '2', '9', '眼镜框', 'Glasses Frame', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('198', '2', '9', '游泳眼镜', 'Swimming Goggles', '件', '25990000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('199', '2', '9', '项链', 'Necklace', '件', '8010000', '0.15', '材质', null, null, null);
INSERT INTO `p_product_category` VALUES ('200', '2', '9', '吊坠', 'Pendant', '件', '8010000', '0.15', '品牌、材质', null, null, null);
INSERT INTO `p_product_category` VALUES ('201', '2', '9', '手链/手镯', 'Bracelets/Bangles', '件', '8010000', '0.15', '品牌、材质', null, null, null);
INSERT INTO `p_product_category` VALUES ('202', '2', '9', '戒指', 'Ring', '件', '8010000', '0.15', '品牌、材质', null, null, null);
INSERT INTO `p_product_category` VALUES ('203', '2', '9', '发饰', 'Hair Accessory', '件', '8010000', '0.15', '品牌、材质', null, null, null);
INSERT INTO `p_product_category` VALUES ('204', '2', '9', '耳环/耳钉', 'Ear Drop/Ring', '件', '8010000', '0.15', '品牌、材质', null, null, null);
INSERT INTO `p_product_category` VALUES ('205', '2', '9', '钥匙扣', 'Key Chain', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('206', '2', '13', '维生素', 'Vitamin', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('207', '2', '13', '蛋白粉', 'Albumen Powder', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('208', '2', '13', '鱼油', 'Fish Oil', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('209', '2', '13', '减肥保健品', 'Diet Health Product', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('210', '2', '13', '蜂胶', 'Propolis', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('211', '2', '13', '天然保健品', 'Natural Health Food', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('212', '2', '13', '辅酶', 'Coenzyme', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('214', '2', '13', '米粉', 'Rice Powder', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('215', '2', '13', '果泥/菜泥', 'Puree', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('216', '2', '13', '饼干/泡芙', 'Biscuits/Puff', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('217', '2', '13', '辅食', 'Solid Food', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('218', '2', '13', '饼干糕点', 'Biscuits/Pastry', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('219', '2', '13', '麦片', 'Cereal', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('220', '2', '13', '干果/蜜饯', 'Dried Fruit/Preserved Fruit', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('221', '2', '13', '糖果/巧克力', 'Candy/Chocolate', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('222', '2', '13', '零食', 'Snack Food', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('223', '2', '13', '调味品', 'Seasoning', '件', '1010800', '0.15', '具体品名', '200', null, null);
INSERT INTO `p_product_category` VALUES ('224', '2', '13', '蜂蜜', 'Honey', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('225', '2', '13', '西洋参（片、块）', 'American Ginseng(slice/piece)', '件', '1010400', '0.15', '重量', '1500', null, null);
INSERT INTO `p_product_category` VALUES ('226', '2', '13', '西洋参（粉末）保健品', 'American Ginseng Powder Product', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('227', '2', '12', '咖啡/冲调', 'Coffee/Drink Powder', '包', '1020200', '0.15', '重量', '200', null, null);
INSERT INTO `p_product_category` VALUES ('228', '2', '12', '茶叶', 'Tea', '包', '1020100', '0.15', '重量', '200', null, null);
INSERT INTO `p_product_category` VALUES ('229', '2', '12', '葡萄酒', 'Wine', '瓶', '2020200', '0.6', '度数、容量、品牌、年份', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('230', '2', '12', '白兰地', 'Brandy', '瓶', '2040000', '0.6', '度数、容量、品牌、年份', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('231', '2', '12', '威士忌', 'Whiskey', '瓶', '2050000', '0.6', '度数、容量、品牌、年份', '300', '600', '150');
INSERT INTO `p_product_category` VALUES ('232', '2', '12', '伏特加', 'Vodka', '瓶', '2060000', '0.6', '度数、容量、品牌、年份', '100', '200', '50');
INSERT INTO `p_product_category` VALUES ('233', '2', '12', '白酒', 'White Wine', '瓶', '2070000', '0.6', '度数、容量、品牌、年份', '300', '600', '150');
INSERT INTO `p_product_category` VALUES ('234', '2', '12', '饮料', 'Beverage', '瓶', '1029900', '0.15', '具体品名', null, null, null);
INSERT INTO `p_product_category` VALUES ('235', '2', '12', '卷烟', 'Cigarette', '支', '3010000', '0.6', '', '0.5', '1', '0.25');
INSERT INTO `p_product_category` VALUES ('236', '2', '12', '雪茄', 'Cigar', '支', '3020000', '0.6', '', '10', '20', '5');
INSERT INTO `p_product_category` VALUES ('237', '2', '7', '奶瓶/奶嘴', 'Milk Bottle/Pacifier', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('238', '2', '7', '婴儿喂食碗勺', 'Feeding Bowl and Spoon for Baby', '个', '11010100', '0.3', '', '20', '40', '10');
INSERT INTO `p_product_category` VALUES ('239', '2', '7', '婴儿辅食碾磨器', 'Milk Storage Bag', '件', '27000000', '0.3', '品牌、电动/手动', null, null, null);
INSERT INTO `p_product_category` VALUES ('240', '2', '7', '溢乳垫/储奶袋', 'Spill Prevention Breast Pad/', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('241', '2', '7', '吸奶器', 'Breast Pump', '件', '27000000', '0.3', '电动/手动,品牌,型号', null, null, null);
INSERT INTO `p_product_category` VALUES ('242', '2', '7', '婴儿牙胶', 'Baby Teether', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('243', '2', '7', '纸尿裤', 'Baby Diaper', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('244', '2', '7', '婴儿洗发沐浴露', 'Baby Shampoo', '件', '9020190', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('245', '2', '7', '湿疹药膏', 'Eczema Ointment', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('246', '2', '7', '乳头霜', 'Nipple Cream', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('247', '2', '7', '妊娠纹按摩膏', 'Stretch Marks Massage Cream', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('248', '2', '7', '母婴消毒用品', 'Maternal and Child Disinfection Supplies', '件', '11019910', '0.3', '具体品名', null, null, null);
INSERT INTO `p_product_category` VALUES ('249', '2', '7', '婴儿服饰', 'Baby Clothes', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('250', '2', '7', '婴儿推车/童车', 'Baby Stroller/Bassinet', '辆', '26030000', '0.3', '品牌型号', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('251', '2', '7', '婴儿背带', 'Baby Straps', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('252', '2', '7', '儿童安全座椅', 'Child Safety Seat', '件', '27000000', '0.3', '品牌型号', null, null, null);
INSERT INTO `p_product_category` VALUES ('253', '2', '7', '婴儿床/摇篮', 'Infanette/Cradle', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('254', '2', '7', '婴儿玩具', 'Baby Toy', '件', '22029900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('255', '2', '7', '儿童玩具', 'Toy for Children', '件', '22029900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('256', '2', '7', '医药护理品', 'Medical Care', '件', '9029900', '0.3', '品名及用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('257', '2', '7', '孕妇内衣', 'Pregnant Women Underwear', '件', '4010300', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('258', '2', '7', '防辐射服', 'Radiation-proof Clothes', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('260', '2', '7', '疤痕贴', 'Scar Plaster', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('261', '2', '7', '止痒药膏', 'Antipruritic Ointment', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('262', '2', '7', '祛疤药膏', 'Scar Ointment', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('263', '2', '7', '紫草膏', 'Res-Q Ointment', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('264', '2', '7', '万用软膏（药膏）', 'All Better Balm(Ointment)', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('265', '2', '7', '爽身粉', 'Talcum Powder', '件', '9029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('266', '2', '2', '儿童安全座椅', 'Child Safety Seat', '件', '27000000', '0.3', '品牌型号', null, null, null);
INSERT INTO `p_product_category` VALUES ('267', '2', '2', '车载电话', 'Car Telephone', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('268', '2', '2', '导航仪', 'Navigator', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('269', '2', '2', '车载逃生锤', 'Vehicle Escape Hammer', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('270', '2', '2', '其他车载用品', 'Other Vehicle Supplies', '件', '27000000', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('271', '2', '2', '车载维修工具', 'Car Maintenance Tools', '件', '27000000', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('272', '2', '2', '车蜡', 'Car Wax', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('273', '2', '2', '冲锋衣', 'Water-proof Coats', '件', '4010100', '0.3', '', '300', '600', '150');
INSERT INTO `p_product_category` VALUES ('274', '2', '2', '冲锋裤', 'Water-proof Trousers', '件', '4010200', '0.3', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('275', '2', '2', '户外鞋靴', 'Outdoor Footwear', '双', '6020300', '0.3', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('276', '2', '2', '帐篷', 'Tent', '件', '25990000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('277', '2', '2', '睡袋', 'Sleeping Bag', '个', '4030100', '0.3', '', '400', '800', '200');
INSERT INTO `p_product_category` VALUES ('278', '2', '2', '防潮垫', 'Moisture-proof Pad', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('279', '2', '2', '望远镜', 'Telescope', '件', '25990000', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('280', '2', '2', '户外工具', 'Outdoor Tools', '件', '25990000', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('281', '2', '2', '瑞士军刀', 'Swiss Army Knife', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('282', '2', '2', '户外仪表', 'Outdoor Instrument', '件', '27000000', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('283', '2', '2', '户外照明', 'Outdoor Lighting Equipment', '件', '27000000', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('284', '2', '2', 'ZIPPO打火机（无油）', 'ZIPPO Lighter(Oil Free)', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('285', '2', '2', '野餐炊具', 'Picnic Cookware', '件', '25990000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('286', '2', '14', '游泳眼镜', 'Swimming Glasses', '件', '25029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('287', '2', '14', '鱼竿/渔具', 'Fishing Rod/Gear', '件', '25029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('288', '2', '14', '泳衣', 'Swimming Suit', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('289', '2', '14', '滑雪板', 'Ski', '件', '25029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('290', '2', '14', '滑冰鞋', 'Ice Skates', '件', '25029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('291', '2', '14', '健身器械', 'Fitness Equipment', '件', '25029900', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('292', '2', '14', '自行车', 'Bicycle', '辆', '26010000', '0.3', '', '500', '1000', '250');
INSERT INTO `p_product_category` VALUES ('293', '2', '14', '自行车配件', 'Bicycle Parts', '件', '26040000', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('294', '2', '14', '头盔', 'Helmet', '件', '25029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('295', '2', '14', '计步器/心率器', 'Pedometer/Heart Rate Monitor', '件', '25029900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('296', '2', '14', '运动腕带', 'Sports Wristband', '件', '25029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('297', '2', '14', '护膝/护肘', 'Kneecap/Elbow Pad', '件', '25029900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('298', '2', '14', '高尔夫球杆', 'Brassie', '根', '25010100', '0.6', '', '1000', '2000', '500');
INSERT INTO `p_product_category` VALUES ('299', '2', '14', '其他运动器具', 'Other Sports Instrument', '件', '25029900', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('300', '2', '14', '乐器', 'Musical Instrument', '件', '24000000', '0.15', '功能', null, null, null);
INSERT INTO `p_product_category` VALUES ('301', '2', '14', '教科书籍', 'Reference Book/Text Book', '本', '20000000', '0.15', '种类', null, null, null);
INSERT INTO `p_product_category` VALUES ('302', '2', '14', '教育用录像带', 'Educational Videotape', '盘', '21030000', '0.15', '', '50', '100', '25');
INSERT INTO `p_product_category` VALUES ('303', '2', '14', '教育用电影片', 'Educational Movie', '盘', '21030000', '0.15', '', '50', '100', '25');
INSERT INTO `p_product_category` VALUES ('304', '2', '14', '教育用幻灯片', 'Educational Slide', '片', '21010000', '0.15', '', '10', '20', '5');
INSERT INTO `p_product_category` VALUES ('305', '2', '14', '笔', 'Pen', '支', '22010400', '0.15', '', '50', '100', '25');
INSERT INTO `p_product_category` VALUES ('306', '2', '3', '收纳用品', 'Storage Products', '件', '11039910', '0.15', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('307', '2', '3', '雨伞雨具', 'Umbrella and Rain Gear', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('308', '2', '3', '皮革清洁剂', 'Leather Cleaner', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('309', '2', '3', '卫浴五金', 'Bathroom Hardware', '件', '11020100', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('310', '2', '3', '成人用品', 'Adult Products', '件', '27000000', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('311', '2', '3', '家装软饰', 'Home Soft Decoration', '件', '11039910', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('312', '2', '3', '磨牙棒', 'Teether', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('313', '2', '3', '喂药器', 'Oral Medicine Syringe', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('314', '2', '3', '洗耳粉', 'Ear Cleaning Powder', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('315', '2', '3', '宠物沐浴露', 'Pet Shampoo/Body Wash', '件', '9020190', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('316', '2', '3', '宠物辅食', 'Pet Solid Food', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('317', '2', '3', '宠物美容用品', 'Pet Grooming Products', '件', '27000000', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('318', '2', '3', '宠物服饰', 'Pet Clothing', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('319', '2', '3', '宠物牵引绳/训练绳', 'Pet Collars, Tags & Leashes', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('320', '2', '13', '钙片', 'Calcium Tablets', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('321', '2', '13', '牛初乳', 'Colostrum', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('322', '2', '13', 'DHA', 'Docosahexaenoic Acid/Omega 3', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('323', '2', '5', '其他衣着', 'Other clothes', '件', '4019900', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('324', '2', '3', '其他物品', 'Other items', '件', '27000000', '0.3', '具体名称与用途', null, null, null);
INSERT INTO `p_product_category` VALUES ('325', '2', '6', '手动剃毛器', 'Manual Shaving Device', '个', '27000000', '0.3', '品牌型号', null, null, null);
INSERT INTO `p_product_category` VALUES ('326', '2', '6', '电动脱毛器', 'Electric Hair Removal Device', '个', '11021190', '0.3', '品牌型号', null, null, null);
INSERT INTO `p_product_category` VALUES ('327', '2', '4', '水壶/水杯', 'Kettle/Cup', '个', '11010100', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('328', '2', '7', '托腹带', 'Girdle', '个', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('329', '2', '10', '便携蓝牙音响(IHOME)', 'Portable Bluetooth Stereo', '件', '18039900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('330', '2', '5', '皮上衣', 'Leather Jacket', '件', '5010300', '0.3', '品牌', null, null, null);
INSERT INTO `p_product_category` VALUES ('331', '2', '8', '眼药水', 'Eye Drops', '瓶', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('332', '2', '8', '足贴', 'Foot Patch', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('333', '2', '8', '肩贴', 'Shoulder Patch', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('334', '2', '13', '婴儿奶粉', 'infant milk powder', '件', '1010700', '0.15', '重量(g)', null, null, null);
INSERT INTO `p_product_category` VALUES ('335', '2', '13', '成人奶粉', 'adult milk powder', '件', '1010700', '0.15', '重量(g)', null, null, null);
INSERT INTO `p_product_category` VALUES ('336', '2', '6', '电动剃须刀', 'Electric Shaver', '个', '11021130', '0.3', '品牌型号', '200', null, null);
INSERT INTO `p_product_category` VALUES ('337', '2', '7', '塑身衣', 'Corset', '件', '4019900', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('338', '2', '13', '咖啡豆', 'Coffee Bean', '件', '1020200', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('339', '2', '13', '可可粉', 'Cocoa Powder', '件', '1019900', '0.15', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('340', '2', '3', '创可贴', 'Band Aid', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('341', '2', '3', '洗菜粉', 'Vegetable Washing Powder', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('342', '2', '8', '眼罩', 'Eye Patch', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('343', '2', '6', '手动剃须刀', 'Manual Razor', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('344', '2', '3', '洗洁精', 'Detergent', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('345', '2', '3', '洗衣粉/洗衣液', 'Washing Powder/Laundry Detergent', '件', '27000000', '0.3', '', null, null, null);
INSERT INTO `p_product_category` VALUES ('346', '2', '1', 'BB霜', 'Blemish Balm', '个', '9010510', '0.6', '', '200', '400', '100');
INSERT INTO `p_product_category` VALUES ('347', '2', '1', '提亮液/高光膏', 'Bright liquid / high gloss paste', '个', '9010600', '0.6', '', '200', '400', '100');
