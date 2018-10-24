
CREATE VIEW p_view_logis_delivery AS
    SELECT
        `orders`.`route_no` AS `route_no`,
        `orders`.`order_no` AS `order_no`,
        `orders`.`created_at` AS `created_at`,
        `orders`.`logis_id` AS `orig_logis_id`,
        `ordersLog`.`logis_id` AS `prev_logis_id`,
        MAX(`ordersLog`.`created_at`) AS `delivered_at`,
        `ordersLog`.`status` AS `status`
    FROM
        (`p_logis_order` `orders`
        LEFT JOIN `p_logis_order_log` `ordersLog` ON ((`orders`.`order_no` = `ordersLog`.`order_no`)))
    WHERE
        ((`ordersLog`.`status` = 'DELIVERED')
            OR ISNULL(`ordersLog`.`order_no`))
    GROUP BY `ordersLog`.`order_no`;



ALTER TABLE `p_logis_order`
ADD INDEX `idx_created_at` (`created_at` ASC);

ALTER TABLE `p_logis_order_log`
ADD INDEX `idx_order_no` (`order_no` ASC),
ADD INDEX `idx_created_at` (`created_at` ASC),
ADD INDEX `idx_status` (`status` ASC);

ALTER TABLE `p_logis_order`
ADD INDEX `idx_post_date` (`post_date` ASC);

ALTER TABLE `p_logis_order`
ADD INDEX `idx_logis_id` (`logis_id` ASC);
