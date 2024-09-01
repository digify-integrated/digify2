/* Content Carousel Table */

CREATE TABLE content_carousel (
    content_carousel_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    content_carousel_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX content_carouselindex_content_carousel_id ON content_carousel(content_carousel_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Content Carousel Item Table */

CREATE TABLE content_carousel_item (
    content_carousel_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    content_carousel_id INT UNSIGNED NOT NULL,
    content_carousel_title VARCHAR(500) NOT NULL,
    content_carousel_heading VARCHAR(500) NOT NULL,
    content_carousel_paragraph LONGTEXT NOT NULL,
    call_to_action_button_1_text VARCHAR(100),
    call_to_action_button_1_link VARCHAR(500),
    call_to_action_button_2_text VARCHAR(100),
    call_to_action_button_2_link VARCHAR(500),
    content_carousel_image VARCHAR(500) NOT NULL,
    order_sequence INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (content_carousel_id) REFERENCES content_carousel(content_carousel_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX content_carousel_item_index_content_carousel_item_id ON content_carousel_item(content_carousel_item_id);
CREATE INDEX content_carousel_item_index_content_carousel_id ON content_carousel_item(content_carousel_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */