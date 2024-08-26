/* Block Style Table */

CREATE TABLE block_style (
    block_style_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    block_type_id INT UNSIGNED NOT NULL,
    block_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX block_style_index_block_style_id ON block_style(block_style_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Block Container Table */

CREATE TABLE block_container (
    block_container_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_container LONGTEXT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (block_style_id) REFERENCES block_style(block_style_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX block_container_index_block_container_id ON block_container(block_container_id);
CREATE INDEX block_container_index_block_style_id ON block_container(block_style_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Block Item Table */

CREATE TABLE block_item (
    block_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_item LONGTEXT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (block_style_id) REFERENCES block_style(block_style_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX block_item_index_block_item_id ON block_item(block_item_id);
CREATE INDEX block_item_index_block_style_id ON block_item(block_style_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */