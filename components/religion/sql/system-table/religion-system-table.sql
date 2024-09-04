/* Religion Table */

CREATE TABLE religion (
    religion_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    religion_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX religion_index_religion_id ON religion(religion_id);

INSERT INTO religion (religion_id, religion_name, last_log_by)
VALUES 
(1, 'Christianity', 1),
(2, 'Islam', 1),
(3, 'Hinduism', 1),
(4, 'Buddhism', 1),
(5, 'Judaism', 1),
(6, 'Sikhism', 1),
(7, 'Atheism', 1),
(8, 'Agnosticism', 1),
(9, 'Baháʼí', 1),
(10, 'Jainism', 1),
(11, 'Shintoism', 1),
(12, 'Cao Dai', 1),
(13, 'Tenrikyo', 1),
(14, 'Neo-Paganism', 1),
(15, 'Rastafarianism', 1),
(16, 'Spiritual but not religious', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */