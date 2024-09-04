/* Customer Inquiry Table */

CREATE TABLE customer_inquiry (
    customer_inquiry_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    customer_name VARCHAR(500) NOT NULL,
    email VARCHAR(500) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    subject VARCHAR(500) NOT NULL,
    message LONGTEXT NOT NULL,
    inquiry_status VARCHAR(50) NOT NULL DEFAULT 'Pending', /*Pending, in_progress, resolved, closed */
    in_progress_date DATETIME, 
    in_progress_by INT UNSIGNED, 
    resolved_date DATETIME, 
    resolved_by INT UNSIGNED, 
    closed_date DATETIME, 
    closed_by INT UNSIGNED, 
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX customer_inquiry_index_customer_inquiry_id ON customer_inquiry(customer_inquiry_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */