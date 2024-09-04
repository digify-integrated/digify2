/* Relation Table */

CREATE TABLE relation (
    relation_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    relation_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX relation_index_relation_id ON relation(relation_id);

INSERT INTO relation (relation_id, relation_name, last_log_by)
VALUES 
(1, 'Father', 1),
(2, 'Mother', 1),
(3, 'Husband', 1),
(4, 'Wife', 1),
(5, 'Son', 1),
(6, 'Daughter', 1),
(7, 'Brother', 1),
(8, 'Sister', 1),
(9, 'Grandfather', 1),
(10, 'Grandmother', 1),
(11, 'Grandson', 1),
(12, 'Granddaughter', 1),
(13, 'Uncle', 1),
(14, 'Aunt', 1),
(15, 'Nephew', 1),
(16, 'Niece', 1),
(17, 'Cousin', 1),
(18, 'Friend', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */