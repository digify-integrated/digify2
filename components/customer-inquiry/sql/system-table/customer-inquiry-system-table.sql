/* Customer Inquiry Table */

CREATE TABLE customer_inquiry (
    customer_inquiry_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    customer_inquiry_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX customer_inquiryindex_customer_inquiry_id ON customer_inquiry(customer_inquiry_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Customer Inquiry Item Table */

CREATE TABLE customer_inquiry_item (
    customer_inquiry_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    customer_inquiry_id INT UNSIGNED NOT NULL,
    customer_inquiry_title VARCHAR(500) NOT NULL,
    customer_inquiry_heading VARCHAR(500) NOT NULL,
    customer_inquiry_paragraph LONGTEXT NOT NULL,
    call_to_action_button_text VARCHAR(100),
    call_to_action_button_link VARCHAR(500),
    customer_inquiry_image VARCHAR(500) NOT NULL,
    order_sequence INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (customer_inquiry_id) REFERENCES customer_inquiry(customer_inquiry_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX customer_inquiry_item_index_customer_inquiry_item_id ON customer_inquiry_item(customer_inquiry_item_id);
CREATE INDEX customer_inquiry_item_index_customer_inquiry_id ON customer_inquiry_item(customer_inquiry_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */