/* Menu Group Table */

CREATE TABLE menu_group (
    menu_group_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    menu_group_name VARCHAR(100) NOT NULL,
    order_sequence TINYINT(10) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX menu_group_index_menu_group_id ON menu_group(menu_group_id);

INSERT INTO menu_group (menu_group_name, order_sequence, last_log_by) VALUES ('Technical', '999', '1');
INSERT INTO menu_group (menu_group_name, order_sequence, last_log_by) VALUES ('Administration', '100', '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */