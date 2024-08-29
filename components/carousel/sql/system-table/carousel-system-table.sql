/* Carousel Table */

CREATE TABLE carousel (
    carousel_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    carousel_name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX carousel_index_carousel_id ON carousel(carousel_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Carousel Image Table */

CREATE TABLE carousel_image (
    carousel_image_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    carousel_id INT UNSIGNED NOT NULL,
    carousel_image VARCHAR(500) NOT NULL,
    order_sequence INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (carousel_id) REFERENCES carousel(carousel_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX carousel_image_index_carousel_image_id ON carousel_image(carousel_image_id);
CREATE INDEX carousel_image_index_carousel_id ON carousel_image(carousel_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */