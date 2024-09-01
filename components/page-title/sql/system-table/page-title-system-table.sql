/* Page Title Table */

CREATE TABLE page_title (
    page_title_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    page_title_name VARCHAR(100) NOT NULL,
    description VARCHAR(100) NOT NULL,
    block_style_id INT UNSIGNED NOT NULL,
    block_style_name VARCHAR(100) NOT NULL,
    page_title VARCHAR(500) NOT NULL,
    page_heading VARCHAR(500) NOT NULL,
    page_title_image VARCHAR(500) NOT NULL,
    publish_status VARCHAR(5) NOT NULL DEFAULT 'No',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX page_titleindex_page_title_id ON page_title(page_title_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */