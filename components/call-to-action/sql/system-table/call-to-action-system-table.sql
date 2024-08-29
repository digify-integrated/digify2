/* Call To Action Table */

CREATE TABLE call_to_action (
    call_to_action_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    call_to_action_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    call_to_action_header VARCHAR(500) NOT NULL,
    call_to_action_body LONGTEXT NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX call_to_action_index_call_to_action_id ON call_to_action(call_to_action_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */