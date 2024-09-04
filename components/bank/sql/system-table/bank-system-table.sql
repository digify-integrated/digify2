/* Bank Table */

CREATE TABLE bank (
    bank_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    bank_name VARCHAR(100) NOT NULL,
    bank_identifier_code VARCHAR(100) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX bank_index_bank_id ON bank(bank_id);

INSERT INTO bank (bank_id, bank_name, bank_identifier_code, last_log_by) VALUES
(1, 'Banco de Oro (BDO)', '010530667', 1),
(2, 'Metrobank', '010269996', 1),
(3, 'Land Bank of the Philippines', '010350025', 1),
(4, 'Bank of the Philippine Islands (BPI)', '010040018', 1),
(5, 'Philippine National Bank (PNB)', '010080010', 1),
(6, 'Security Bank', '010140015', 1),
(7, 'UnionBank of the Philippines', '010419995', 1),
(8, 'Development Bank of the Philippines (DBP)', '010590018', 1),
(9, 'EastWest Bank', '010620014', 1),
(10, 'China Banking Corporation (Chinabank)', '010100013', 1),
(11, 'RCBC (Rizal Commercial Banking Corporation)', '010280014', 1),
(12, 'Maybank Philippines', '010220016', 1)
(13, 'Bank of America', 'BOFAUS3N', 1),
(14, 'JPMorgan Chase', 'CHASUS33', 1),
(15, 'Wells Fargo', 'WFBIUS6W', 1),
(16, 'Citibank', 'CITIUS33', 1),
(17, 'U.S. Bank', 'USBKUS44', 1),
(18, 'Bank of New York Mellon', 'BKONYUS33', 1),
(19, 'State Street Corporation', 'SSTTUS33', 1),
(20, 'Goldman Sachs', 'GOLDUS33', 1),
(21, 'Morgan Stanley', 'MSNYUS33', 1),
(22, 'Capital One', 'COWNUS33', 1),
(23, 'PNC Financial Services Group', 'PNCCUS33', 1),
(24, 'Truist Financial Corporation', 'TRUIUS33', 1),
(25, 'Charles Schwab Corporation', 'SCHWUS33', 1),
(26, 'Ally Financial', 'ALLYUS33', 1),
(27, 'TD Bank', 'TDUSUS33', 1),
(28, 'Fifth Third Bank', 'FTBCUS3J', 1),
(29, 'KeyBank', 'KEYBUS33', 1),
(30, 'Huntington Bancshares', 'HBANUS33', 1),
(31, 'Regions Financial Corporation', 'RGNSUS33', 1),
(32, 'M&T Bank', 'MANTUS33', 1),
(33, 'SunTrust Banks', 'STBAUS33', 1),
(34, 'BB&T Corporation', 'BBTUS33', 1),
(35, 'Emirates NBD', 'EBILAEAD', 1),
(36, 'First Abu Dhabi Bank', 'NBADAEAAXXX', 1),
(37, 'Abu Dhabi Commercial Bank', 'ADCBAEAAXXX', 1),
(38, 'Dubai Islamic Bank', 'DIBAEAAXXX', 1),
(39, 'Mashreq Bank', 'BOMLAEAD', 1),
(40, 'Union National Bank', 'UNBAEAAXXX', 1),
(41, 'Rakbank', 'RAKAEAAXXX', 1),
(42, 'Commercial Bank of Dubai', 'CBDAEAAXXX', 1),
(43, 'Emirates Islamic Bank', 'EIILAEAD', 1),
(44, 'Ajman Bank', 'AJBLAEAD', 1),
(45, 'Sharjah Islamic Bank', 'SIBAEAAXXX', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */