<?php
/**
* Class BankModel
*
* The BankModel class handles bank related operations and interactions.
*/
class BankModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateBank
    # Description: Updates the bank.
    #
    # Parameters:
    # - $p_bank_id (int): The bank ID.
    # - $p_bank_name (string): The bank name.
    # - $p_bank_identifier_code (string): The bank identifier code.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateBank($p_bank_id, $p_bank_name, $p_bank_identifier_code, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateBank(:p_bank_id, :p_bank_name, :p_bank_identifier_code, :p_last_log_by)');
        $stmt->bindValue(':p_bank_id', $p_bank_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_name', $p_bank_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_bank_identifier_code', $p_bank_identifier_code, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertBank
    # Description: Inserts the bank.
    #
    # Parameters:
    # - $p_bank_name (string): The bank name.
    # - $p_bank_identifier_code (string): The bank identifier code.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertBank($p_bank_name, $p_bank_identifier_code, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertBank(:p_bank_name, :p_bank_identifier_code, :p_last_log_by, @p_bank_id)');
        $stmt->bindValue(':p_bank_name', $p_bank_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_bank_identifier_code', $p_bank_identifier_code, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_bank_id AS bank_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['bank_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkBankExist
    # Description: Checks if a bank exists.
    #
    # Parameters:
    # - $p_bank_id (int): The bank ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkBankExist($p_bank_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkBankExist(:p_bank_id)');
        $stmt->bindValue(':p_bank_id', $p_bank_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteBank
    # Description: Deletes the bank.
    #
    # Parameters:
    # - $p_bank_id (int): The bank ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteBank($p_bank_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteBank(:p_bank_id)');
        $stmt->bindValue(':p_bank_id', $p_bank_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getBank
    # Description: Retrieves the details of a bank.
    #
    # Parameters:
    # - $p_bank_id (int): The bank ID.
    #
    # Returns:
    # - An array containing the bank details.
    #
    # -------------------------------------------------------------
    public function getBank($p_bank_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getBank(:p_bank_id)');
        $stmt->bindValue(':p_bank_id', $p_bank_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateBankOptions
    # Description: Generates the bank options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateBankOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateBankOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $bankID = $row['bank_id'];
            $bankName = $row['bank_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($bankID, ENT_QUOTES) . '">' . htmlspecialchars($bankName, ENT_QUOTES) .'</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>