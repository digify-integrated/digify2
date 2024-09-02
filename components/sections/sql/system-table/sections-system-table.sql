/* Sections Table */

CREATE TABLE sections (
    sections_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    sections_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX sections_index_sections_id ON sections(sections_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */