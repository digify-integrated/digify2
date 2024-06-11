<?php
/**
* Class SecuritySettingModel
*
* The SecuritySettingModel class handles security setting related operations and interactions.
*/
class SecuritySettingModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateSecuritySetting
    # Description: Updates the security setting.
    #
    # Parameters:
    # - $p_security_setting_id (int): The security setting ID.
    # - $p_security_setting_name (string): The security setting name.
    # - $p_security_setting_description (string): The security setting description.
    # - $p_value (string): The value of the setting.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateSecuritySetting($p_security_setting_id, $p_security_setting_name, $p_security_setting_description, $p_value, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateSecuritySetting(:p_security_setting_id, :p_security_setting_name, :p_security_setting_description, :p_value, :p_last_log_by)');
        $stmt->bindValue(':p_security_setting_id', $p_security_setting_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_security_setting_name', $p_security_setting_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_security_setting_description', $p_security_setting_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_value', $p_value, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertSecuritySetting
    # Description: Inserts the security setting.
    #
    # Parameters:
    # - $p_security_setting_name (string): The security setting name.
    # - $p_security_setting_description (string): The security setting description.
    # - $p_value (string): The value of the setting.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertSecuritySetting($p_security_setting_name, $p_security_setting_description, $p_value, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertSecuritySetting(:p_security_setting_name, :p_security_setting_description, :p_value, :p_last_log_by, @p_security_setting_id)');
        $stmt->bindValue(':p_security_setting_name', $p_security_setting_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_security_setting_description', $p_security_setting_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_value', $p_value, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_security_setting_id AS security_setting_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['security_setting_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkSecuritySettingExist
    # Description: Checks if a security setting exists.
    #
    # Parameters:
    # - $p_security_setting_id (int): The security setting ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkSecuritySettingExist($p_security_setting_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkSecuritySettingExist(:p_security_setting_id)');
        $stmt->bindValue(':p_security_setting_id', $p_security_setting_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteSecuritySetting
    # Description: Deletes the security setting.
    #
    # Parameters:
    # - $p_security_setting_id (int): The security setting ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteSecuritySetting($p_security_setting_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteSecuritySetting(:p_security_setting_id)');
        $stmt->bindValue(':p_security_setting_id', $p_security_setting_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getSecuritySetting
    # Description: Retrieves the details of a security setting.
    #
    # Parameters:
    # - $p_security_setting_id (int): The security setting ID.
    #
    # Returns:
    # - An array containing the user details.
    #
    # -------------------------------------------------------------
    public function getSecuritySetting($p_security_setting_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getSecuritySetting(:p_security_setting_id)');
        $stmt->bindValue(':p_security_setting_id', $p_security_setting_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>