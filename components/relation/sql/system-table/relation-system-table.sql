/* Relation Table */

CREATE TABLE relation (
    relation_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    relation_name VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX relation_index_relation_id ON relation(relation_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */