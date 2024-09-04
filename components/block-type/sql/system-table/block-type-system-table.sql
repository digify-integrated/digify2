/* Block Type Table */

CREATE TABLE block_type (
    block_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    block_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX block_type_index_block_type_id ON block_type(block_type_id);

INSERT INTO block_type (block_type_id, block_type_name, last_log_by) VALUES
(1, 'Accordion', 1),
(2, 'Call To Action', 1),
(3, 'Carousel', 1),
(4, 'Client', 1),
(5, 'Contact Form', 1),
(6, 'Content Carousel', 1),
(7, 'Footer', 1),
(8, 'Header', 1),
(9, 'Image Gallery', 1),
(10, 'Page Title', 1),
(11, 'Pricing Table', 1),
(12, 'Process Step', 1),
(13, 'Services Box', 1),
(14, 'Slider', 1),
(15, 'Testimonial', 1),
(16, 'Sections', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */