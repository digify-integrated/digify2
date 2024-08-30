/* Client Table */

CREATE TABLE client (
    client_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    client_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX client_index_client_id ON client(client_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Client Item Table */

CREATE TABLE client_item (
    client_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    client_id INT UNSIGNED NOT NULL,
    client_logo VARCHAR(500) NOT NULL,
    client_url VARCHAR(500),
    order_sequence INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (client_id) REFERENCES client(client_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX client_item_index_client_item_id ON client_item(client_item_id);
CREATE INDEX client_item_index_client_id ON client_item(client_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */