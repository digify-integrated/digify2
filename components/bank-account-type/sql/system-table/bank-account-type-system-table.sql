/* Bank Account Type Table */

CREATE TABLE bank_account_type (
    bank_account_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    bank_account_type_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX bank_account_type_index_bank_account_type_id ON bank_account_type(bank_account_type_id);

INSERT INTO bank_account_type (bank_account_type_id, bank_account_type_name, last_log_by)
VALUES 
(1, 'Checking', 1),
(2, 'Savings', 1),
(3, 'Money Market', 1),
(4, 'Certificate of Deposit (CD)', 1),
(5, 'Individual Retirement Account (IRA)', 1),
(6, 'Business Checking', 1),
(7, 'Business Savings', 1),
(8, 'Business Money Market', 1),
(9, 'Business Certificate of Deposit (CD)', 1),
(10, 'Business Individual Retirement Account (IRA)', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */