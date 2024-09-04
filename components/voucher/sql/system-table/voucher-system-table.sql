/* Voucher Table */

CREATE TABLE voucher (
    voucher_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    voucher_name VARCHAR(100) NOT NULL,
    voucher_code VARCHAR(20) NOT NULL,
    voucher_usage_start_date DATE NOT NULL,
    voucher_usage_end_date DATE NOT NULL,
    discount_type VARCHAR(20) NOT NULL,
    discount_amount DOUBLE NOT NULL,
    minimum_booking_amount DOUBLE NOT NULL,
    voucher_quantity INT NOT NULL,
    available_voucher INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX voucher_index_voucher_id ON voucher(voucher_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */