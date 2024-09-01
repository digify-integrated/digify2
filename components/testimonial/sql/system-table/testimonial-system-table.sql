/* Testimonial Table */

CREATE TABLE testimonial (
    testimonial_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    testimonial_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX testimonialindex_testimonial_id ON testimonial(testimonial_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Testimonial Item Table */

CREATE TABLE testimonial_item (
    testimonial_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    testimonial_id INT UNSIGNED NOT NULL,
    testimonial_client VARCHAR(500) NOT NULL,
    testimonial_title VARCHAR(500) NOT NULL,
    testimonial_paragraph LONGTEXT NOT NULL,
    rating FLOAT,
    testimonial_image VARCHAR(500) NOT NULL,
    order_sequence INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (testimonial_id) REFERENCES testimonial(testimonial_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX testimonial_item_index_testimonial_item_id ON testimonial_item(testimonial_item_id);
CREATE INDEX testimonial_item_index_testimonial_id ON testimonial_item(testimonial_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */