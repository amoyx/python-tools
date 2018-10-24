ALTER TABLE `p_vendor_order`
ADD COLUMN `send_type` TINYINT(1) NULL DEFAULT '0' COMMENT '寄件类型: 0 - 转运模式 forward; 1 - 直邮 direct mail ' ;
ALTER TABLE `p_vendor_order_item`
ADD COLUMN `sku` VARCHAR(16) NULL COMMENT '仓储单元ID' AFTER `created_at`;
