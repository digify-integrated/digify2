<?php
/**
* Class BankAccountTypeModel
*
* The BankAccountTypeModel class handles bank account type related operations and interactions.
*/
class BankAccountTypeModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateBankAccountType
    # Description: Updates the bank account type.
    #
    # Parameters:
    # - $p_bank_account_type_id (int): The bank account type ID.
    # - $p_bank_account_type_name (string): The bank account type name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateBankAccountType($p_bank_account_type_id, $p_bank_account_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateBankAccountType(:p_bank_account_type_id, :p_bank_account_type_name, :p_last_log_by)');
        $stmt->bindValue(':p_bank_account_type_id', $p_bank_account_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_account_type_name', $p_bank_account_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertBankAccountType
    # Description: Inserts the bank account type.
    #
    # Parameters:
    # - $p_bank_account_type_name (string): The bank account type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertBankAccountType($p_bank_account_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertBankAccountType(:p_bank_account_type_name, :p_last_log_by, @p_bank_account_type_id)');
        $stmt->bindValue(':p_bank_account_type_name', $p_bank_account_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_bank_account_type_id AS bank_account_type_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['bank_account_type_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkBankAccountTypeExist
    # Description: Checks if a bank account type exists.
    #
    # Parameters:
    # - $p_bank_account_type_id (int): The bank account type ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkBankAccountTypeExist($p_bank_account_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkBankAccountTypeExist(:p_bank_account_type_id)');
        $stmt->bindValue(':p_bank_account_type_id', $p_bank_account_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteBankAccountType
    # Description: Deletes the bank account type.
    #
    # Parameters:
    # - $p_bank_account_type_id (int): The bank account type ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteBankAccountType($p_bank_account_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteBankAccountType(:p_bank_account_type_id)');
        $stmt->bindValue(':p_bank_account_type_id', $p_bank_account_type_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getBankAccountType
    # Description: Retrieves the details of a bank account type.
    #
    # Parameters:
    # - $p_bank_account_type_id (int): The bank account type ID.
    #
    # Returns:
    # - An array containing the bank account type details.
    #
    # -------------------------------------------------------------
    public function getBankAccountType($p_bank_account_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getBankAccountType(:p_bank_account_type_id)');
        $stmt->bindValue(':p_bank_account_type_id', $p_bank_account_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateBankAccountTypeOptions
    # Description: Generates the bank account type options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateBankAccountTypeOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateBankAccountTypeOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $bankAccountTypeID = $row['bank_account_type_id'];
            $bankAccountTypeName = $row['bank_account_type_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($bankAccountTypeID, ENT_QUOTES) . '">' . htmlspecialchars($bankAccountTypeName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>