/* Contact Information Type Table */

CREATE TABLE contact_information_type (
    contact_information_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    contact_information_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX contact_information_type_index_contact_information_type_id ON contact_information_type(contact_information_type_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */