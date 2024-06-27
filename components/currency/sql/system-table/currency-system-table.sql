/* Currency Table */

CREATE TABLE currency (
    currency_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    currency_name VARCHAR(100) NOT NULL,
    currency_code VARCHAR(10) NOT NULL,
    currency_symbol VARCHAR(10) NOT NULL,
    exchange_rate DOUBLE NOT NULL DEFAULT 0,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX currency_index_currency_id ON currency(currency_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */