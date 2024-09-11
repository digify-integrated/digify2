/* Booking Table */

CREATE TABLE booking (
    booking_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    booking_reference_number VARCHAR(100) NOT NULL,
    source_of_booking VARCHAR(50) NOT NULL DEFAULT 'Website',
    service VARCHAR(100) NOT NULL,
    frequency VARCHAR(50),
    duration INT,
    number_of_seats INT,
    meters INT,
    cleaning_materials VARCHAR(10) NOT NULL,
    booking_date DATE NOT NULL,
    booking_time VARCHAR(20) NOT NULL,
    number_of_professionals INT NOT NULL,
    number_of_hours INT NOT NULL,
    nationality VARCHAR(50) NOT NULL,
    first_name VARCHAR(500) NOT NULL,
    last_name VARCHAR(500) NOT NULL,
    address LONGTEXT NOT NULL,
    phone VARCHAR(50) NOT NULL,
    email_address VARCHAR(500) NOT NULL,
    special_instructions LONGTEXT,
    mode_of_payment VARCHAR(50),
    discount_code VARCHAR(50),
    discount_type VARCHAR(20),
    discount_amount DOUBLE,
    total_discount_amount DOUBLE,
    booking_subtotal_amount DOUBLE,
    total_booking_amount DOUBLE,
    refund_amount DOUBLE,
    payment_status VARCHAR(100) NOT NULL DEFAULT 'Pending', /* Pending, Paid, Refunded */
    booking_status VARCHAR(100) NOT NULL DEFAULT 'Pending', /* Pending, In-Progress, Completed, For Cancellation, Cancelled */
    cancellation_request_date DATETIME,
    cancellation_window DATETIME,
    cancellation_reason LONGTEXT,
    payment_reference_number VARCHAR(500),
    payment_date DATETIME,
    refund_date DATETIME,
    refund_reason LONGTEXT,
    in_progress_date DATETIME,
    completed_date DATETIME,
    cancellation_date DATETIME,
    transaction_date DATETIME NOT NULL DEFAULT NOW(),
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX booking_index_booking_id ON booking(booking_id);
CREATE INDEX booking_index_payment_status ON booking(payment_status);
CREATE INDEX booking_index_booking_status ON booking(booking_status);
CREATE INDEX booking_index_source_of_booking ON booking(source_of_booking);
CREATE INDEX booking_index_service ON booking(service);
CREATE INDEX booking_index_mode_of_payment ON booking(mode_of_payment);
CREATE INDEX booking_index_payment_reference_number ON booking(payment_reference_number);
CREATE INDEX booking_index_booking_reference_number ON booking(booking_reference_number);
CREATE INDEX booking_index_discount_type ON booking(discount_type);

/* ----------------------------------------------------------------------------------------------------------------------------- */