ALTER TABLE `p_logis_route`
ADD COLUMN `estimated_days` INT NULL DEFAULT NULL AFTER `created_at`;

ALTER TABLE `p_logis_order`
ADD COLUMN `delivered_at` DATETIME NULL DEFAULT NULL COMMENT '包裹抵达收件人的时间' AFTER `created_at`;
