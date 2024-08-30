/* Footer Table */

CREATE TABLE footer (
    footer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    footer_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX footer_index_footer_id ON footer(footer_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */