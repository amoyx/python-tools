ALTER TABLE `p_depot_route`
ADD UNIQUE INDEX `uniq_routeId` (`route_id` ASC);

ALTER TABLE `p_depot_route`
DROP INDEX `uniq_depotId_routeId` ;

ALTER TABLE `p_depot_route`
ADD INDEX `idx_depotId` (`depot_id` ASC);

ALTER TABLE `p_depot_waybill`
ADD COLUMN  `waybill_info` mediumtext COMMENT '面单打印信息。一般由快递公司提供。';
