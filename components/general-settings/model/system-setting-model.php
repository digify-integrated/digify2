<?php
/**
* Class SystemSettingModel
*
* The SystemSettingModel class handles system setting related operations and interactions.
*/
class SystemSettingModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateSystemSetting
    # Description: Updates the system setting.
    #
    # Parameters:
    # - $p_system_setting_id (int): The system setting ID.
    # - $p_system_setting_name (string): The system setting name.
    # - $p_system_setting_description (string): The system setting description.
    # - $p_value (string): The value of the setting.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateSystemSetting($p_system_setting_id, $p_system_setting_name, $p_system_setting_description, $p_value, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateSystemSetting(:p_system_setting_id, :p_system_setting_name, :p_system_setting_description, :p_value, :p_last_log_by)');
        $stmt->bindValue(':p_system_setting_id', $p_system_setting_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_system_setting_name', $p_system_setting_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_system_setting_description', $p_system_setting_description, PDO::PARAM_STR);
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
    # Function: insertSystemSetting
    # Description: Inserts the system setting.
    #
    # Parameters:
    # - $p_system_setting_name (string): The system setting name.
    # - $p_system_setting_description (string): The system setting description.
    # - $p_value (string): The value of the setting.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertSystemSetting($p_system_setting_name, $p_system_setting_description, $p_value, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertSystemSetting(:p_system_setting_name, :p_system_setting_description, :p_value, :p_last_log_by, @p_system_setting_id)');
        $stmt->bindValue(':p_system_setting_name', $p_system_setting_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_system_setting_description', $p_system_setting_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_value', $p_value, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_system_setting_id AS system_setting_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['system_setting_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkSystemSettingExist
    # Description: Checks if a system setting exists.
    #
    # Parameters:
    # - $p_system_setting_id (int): The system setting ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkSystemSettingExist($p_system_setting_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkSystemSettingExist(:p_system_setting_id)');
        $stmt->bindValue(':p_system_setting_id', $p_system_setting_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteSystemSetting
    # Description: Deletes the system setting.
    #
    # Parameters:
    # - $p_system_setting_id (int): The system setting ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteSystemSetting($p_system_setting_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteSystemSetting(:p_system_setting_id)');
        $stmt->bindValue(':p_system_setting_id', $p_system_setting_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getSystemSetting
    # Description: Retrieves the details of a system setting.
    #
    # Parameters:
    # - $p_system_setting_id (int): The system setting ID.
    #
    # Returns:
    # - An array containing the user details.
    #
    # -------------------------------------------------------------
    public function getSystemSetting($p_system_setting_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getSystemSetting(:p_system_setting_id)');
        $stmt->bindValue(':p_system_setting_id', $p_system_setting_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>