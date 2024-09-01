/* Image Gallery Table */

CREATE TABLE image_gallery (
    image_gallery_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    image_gallery_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX image_galleryindex_image_gallery_id ON image_gallery(image_gallery_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Carousel Item Table */

CREATE TABLE image_gallery_item (
    image_gallery_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    image_gallery_id INT UNSIGNED NOT NULL,
    image_gallery_title VARCHAR(500) NOT NULL,
    image_gallery_image VARCHAR(500) NOT NULL,
    order_sequence INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (image_gallery_id) REFERENCES image_gallery(image_gallery_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX image_gallery_item_index_image_gallery_item_id ON image_gallery_item(image_gallery_item_id);
CREATE INDEX image_gallery_item_index_image_gallery_id ON image_gallery_item(image_gallery_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */