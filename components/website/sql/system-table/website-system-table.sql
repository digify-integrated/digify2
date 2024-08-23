/* Website Table */

CREATE TABLE website (
    website_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    website_name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    url VARCHAR(255) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX website_index_website_id ON website(website_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */