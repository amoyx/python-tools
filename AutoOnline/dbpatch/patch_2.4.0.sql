-- 必须按以下格式声明版本
-- ### VERSION: 2.4.0 ###--

-- ----------------------------
-- Table structure for p_logis_product_name
-- ----------------------------
SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for p_sys_config
-- ----------------------------
DROP TABLE IF EXISTS `p_sys_config`;
CREATE TABLE `p_sys_config` (
  `id` varchar(127) NOT NULL COMMENT 'key id',
  `description` varchar(255) NOT NULL COMMENT 'key的名称说明',
  `value` longtext COMMENT '配置值',
  `type` varchar(32) NOT NULL COMMENT '类型：html(html展示内容),image(图像),text(短文本),bool(单个单选类型),radio(布尔单选类型),select(下拉类型),checkbox(多选类型)',
  `default_value` longtext COMMENT '默认值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='配置信息表';

INSERT INTO `p_sys_config`(`id`, `description`, `value`, `type`, `default_value`) VALUES ('about.info',            '公司简介', '<p style=\"text-indent: 2em;\">晤曜电子商务（上海）有限公司于2014年9月注册在上海自贸区，公司致力于为跨境电商产业链上所有相关企业与消费者创造优质的合作和服务，提供涵盖进出口通关及国际物流平台解决方案、B2B2C跨境电商平台、个人零售O2O直营店解决方案、跨境支付结算等服务范畴。</p><p style=\"text-indent: 2em;\">公司股东包括“清华长三角研究院”下属创投基金公司、跨境电商领域十余年深度耕耘的创业人、曾就职于顶尖互联网公司的技术研发管理人等。</p><p style=\"text-indent: 2em;\">晤曜电子商务在行业内率先打造国内领先的跨境电商服务生态圈，让中国消费者足不出户、轻松、便捷地享受一站式全球购，实现引领中国消费全球化。截至目前，已经在日本、台湾、韩国、澳洲、成立子公司，搭建专业的跨境电商团队，全方位保障全球丰富的正品商品供应链和优质的境外服务能力。</p>', 'html', null);
INSERT INTO `p_sys_config`(`id`, `description`, `value`, `type`, `default_value`) VALUES ('about.culture.vision',  '愿景',    '<h3>愿景</h3><p>中国最好的跨境电商一站式综合服务平台</p>', 'html', null);
INSERT INTO `p_sys_config`(`id`, `description`, `value`, `type`, `default_value`) VALUES ('about.culture.mission', '使命',    '<h3>使命</h3><p>推进跨境电子商务规范化、便利化、自由化</p>', 'html', null);
INSERT INTO `p_sys_config`(`id`, `description`, `value`, `type`, `default_value`) VALUES ('about.culture.values',  '价值观',  '<h3>价值观</h3><p>诚信、创新、开放、共赢</p>', 'html', null);
INSERT INTO `p_sys_config`(`id`, `description`, `value`, `type`, `default_value`) VALUES ('about.contact_info',    '联系方式', '<p style=\"line-height: 1.5\"><font size=\"2\" face=\"宋体\" style=\"line-height: 1.5\">联系电话 （<span>TEL</span>）：<span>+86-21-35326807&nbsp;&nbsp;&nbsp;&nbsp;</span></font></p><p style=\"line-height: 1.5\"><font size=\"2\" face=\"宋体\" style=\"line-height: 1.5\">传真（<span>FAX</span>）：<span>+86-21-64176202</span></font></p><p style=\"line-height: 1.5\"><font size=\"2\" face=\"宋体\" style=\"line-height: 1.5\">商务合作：<span></span></font></p><p style=\"line-height: 1.5\"><font size=\"2\" face=\"宋体\" style=\"line-height: 1.5\"><span>51</span><span>跨境通：</span><span><a href=\"mailto:kjt@kolbuy.com\" target=\"_blank\" _href=\"mailto:kjt@kolbuy.com\"><span>kjt@kolbuy.com</span></a></span></font></p><p style=\"line-height: 1.5\"><font size=\"2\" face=\"宋体\" style=\"line-height: 1.5\"><span>51</span><span>代购：</span><span><span>&nbsp;</span></span><span><a href=\"mailto:51daigou@kolbuy.com\" target=\"_blank\" _href=\"mailto:51daigou@kolbuy.com\"><span>51daigou@kolbuy.com</span></a></span></font></p><p style=\"line-height: 1.5\"><font face=\"宋体\" size=\"2\" style=\"line-height: 1.5\"><span>库伴平台：</span><span><a href=\"mailto:platform@kolbuy.com\" target=\"_blank\" _href=\"mailto:platform@kolbuy.com\"><span>platform@kolbuy.com</span></a></span></font></p><p style=\"line-height: 1.5\"><font face=\"宋体\" size=\"2\" style=\"line-height: 1.5\">地址（<span>address</span>）：虹口区东大名路<span>879</span>号高阳商务中心高阳宾馆<span>5</span>楼（单步电梯进）</font></p><p><br></p>', 'html', null);
INSERT INTO `p_sys_config`(`id`, `description`, `value`, `type`, `default_value`) VALUES ('about.office_map',      '办公地图', '{"title":"","src_url":"http://www.kolbuy.com/images/map.jpg","link_url":"http://ditu.amap.com/search?query=%E4%B8%8A%E6%B5%B7%E5%AE%9E%E4%B8%9A%E9%9B%86%E5%9B%A2%E9%AB%98%E9%98%B3%E5%95%86%E5%8A%A1%E4%B8%AD%E5%BF%835&city=310000"}', 'image', null);
INSERT INTO `p_sys_config`(`id`, `description`, `value`, `type`, `default_value`) VALUES ('index.image_news',      '首页图片新闻',  '{"title":"一站式口岸服务平台“晤曜通”平台上线","src_url":"http://kolbuystatic.oss-cn-hangzhou.aliyuncs.com/sysadmin/20160517/52661463473188721.png","link_url":"http://www.kolbuy.com/news?action=Detail&articleId=4bfee35ef679411ba15432913d6d2f68"}', 'image', null);
