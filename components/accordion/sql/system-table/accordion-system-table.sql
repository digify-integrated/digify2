/* Accordion Table */

CREATE TABLE accordion (
    accordion_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    accordion_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX accordion_index_accordion_id ON accordion(accordion_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Accordion Item Table */

CREATE TABLE accordion_item (
    accordion_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    accordion_id INT UNSIGNED NOT NULL,
    accordion_header VARCHAR(500) NOT NULL,
    accordion_body LONGTEXT NOT NULL,
    order_sequence INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (accordion_id) REFERENCES accordion(accordion_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX accordion_item_index_accordion_item_id ON accordion_item(accordion_item_id);
CREATE INDEX accordion_item_index_accordion_id ON accordion_item(accordion_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */