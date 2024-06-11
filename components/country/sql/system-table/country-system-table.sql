/* Country Table */

CREATE TABLE country(
	country_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	country_name VARCHAR(100) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX country_index_country_id ON country(country_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */