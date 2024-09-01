/* Process Step Table */

CREATE TABLE process_step (
    process_step_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    process_step_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX process_stepindex_process_step_id ON process_step(process_step_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Process Step Item Table */

CREATE TABLE process_step_item (
    process_step_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    process_step_id INT UNSIGNED NOT NULL,
    process_step_title VARCHAR(500) NOT NULL,
    process_step_heading VARCHAR(500) NOT NULL,
    process_step_link  VARCHAR(500),
    process_step_image VARCHAR(500) NOT NULL,
    order_sequence INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (process_step_id) REFERENCES process_step(process_step_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX process_step_item_index_process_step_item_id ON process_step_item(process_step_item_id);
CREATE INDEX process_step_item_index_process_step_id ON process_step_item(process_step_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */