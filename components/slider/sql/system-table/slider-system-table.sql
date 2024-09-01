/* Slider Table */

CREATE TABLE slider (
    slider_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    slider_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX sliderindex_slider_id ON slider(slider_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Slider Item Table */

CREATE TABLE slider_item (
    slider_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    slider_id INT UNSIGNED NOT NULL,
    slider_title VARCHAR(500) NOT NULL,
    slider_heading VARCHAR(500) NOT NULL,
    slider_paragraph LONGTEXT NOT NULL,
    call_to_action_button_1_text VARCHAR(100),
    call_to_action_button_1_link VARCHAR(500),
    call_to_action_button_2_text VARCHAR(100),
    call_to_action_button_2_link VARCHAR(500),
    slider_image VARCHAR(500) NOT NULL,
    order_sequence INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (slider_id) REFERENCES slider(slider_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX slider_item_index_slider_item_id ON slider_item(slider_item_id);
CREATE INDEX slider_item_index_slider_id ON slider_item(slider_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */