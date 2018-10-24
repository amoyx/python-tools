ALTER TABLE `p_logis_account`
ADD COLUMN `enable_stat` TINYINT NULL DEFAULT 0 AFTER `created_at`;
ALTER TABLE `p_logis_route`
ADD COLUMN `enable_stat` TINYINT NULL DEFAULT 0;
