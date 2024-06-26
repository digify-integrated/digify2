<?php
/**
* Class UICustomizationSettingModel
*
* The UICustomizationSettingModel class handles UI customization setting related operations and interactions.
*/
class UICustomizationSettingModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateUICustomizationSetting
    # Description: Updates the UI customization setting.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_type (string): The type of the customization.
    # - $p_customization_value (string): The customization value.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateUICustomizationSetting($p_user_account_id, $p_type, $p_customization_value, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateUICustomizationSetting(:p_user_account_id, :p_type, :p_customization_value, :p_last_log_by)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_type', $p_type, PDO::PARAM_STR);
        $stmt->bindValue(':p_customization_value', $p_customization_value, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertUICustomizationSetting
    # Description: Inserts the UI customization setting.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_type (string): The type of the customization.
    # - $p_customization_value (string): The customization value.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertUICustomizationSetting($p_user_account_id, $p_type, $p_customization_value, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertUICustomizationSetting(:p_user_account_id, :p_type, :p_customization_value, :p_last_log_by)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_type', $p_type, PDO::PARAM_STR);
        $stmt->bindValue(':p_customization_value', $p_customization_value, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------


    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkUICustomizationSettingExist
    # Description: Checks if a UI customization setting exists.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkUICustomizationSettingExist($p_user_account_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkUICustomizationSettingExist(:p_user_account_id)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getUICustomizationSetting
    # Description: Retrieves the details of a UI customization setting.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    #
    # Returns:
    # - An array containing the UI customization details.
    #
    # -------------------------------------------------------------
    public function getUICustomizationSetting($p_user_account_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getUICustomizationSetting(:p_user_account_id)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>