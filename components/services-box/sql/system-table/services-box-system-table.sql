/* Services Box Table */

CREATE TABLE services_box (
    services_box_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    services_box_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX services_boxindex_services_box_id ON services_box(services_box_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Services Box Item Table */

CREATE TABLE services_box_item (
    services_box_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    services_box_id INT UNSIGNED NOT NULL,
    services_box_title VARCHAR(500) NOT NULL,
    services_box_heading VARCHAR(500) NOT NULL,
    services_box_paragraph LONGTEXT NOT NULL,
    call_to_action_button_text VARCHAR(100),
    call_to_action_button_link VARCHAR(500),
    services_box_image VARCHAR(500) NOT NULL,
    order_sequence INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (services_box_id) REFERENCES services_box(services_box_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX services_box_item_index_services_box_item_id ON services_box_item(services_box_item_id);
CREATE INDEX services_box_item_index_services_box_id ON services_box_item(services_box_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */