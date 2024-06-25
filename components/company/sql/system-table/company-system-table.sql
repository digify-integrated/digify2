/* Company Table */

CREATE TABLE company (
    company_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    company_name VARCHAR(100) NOT NULL,
    legal_name VARCHAR(100) NOT NULL,
    address VARCHAR(500) NOT NULL,
    city_id INT UNSIGNED NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    state_id INT UNSIGNED NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    country_id INT UNSIGNED NOT NULL,
    country_name VARCHAR(100) NOT NULL,
    currency_id INT UNSIGNED NOT NULL,
    currency_name VARCHAR(100) NOT NULL,
    currency_symbol VARCHAR(10) NOT NULL,
    tax_id VARCHAR(50),
    phone VARCHAR(50),
    mobile VARCHAR(50),
    email VARCHAR(500),
    website VARCHAR(500),
    company_logo VARCHAR(500),
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX company_index_company_id ON company(company_id);
CREATE INDEX company_index_city_id ON company(city_id);
CREATE INDEX company_index_state_id ON company(state_id);
CREATE INDEX company_index_country_id ON company(country_id);
CREATE INDEX company_index_currency_id ON company(currency_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */