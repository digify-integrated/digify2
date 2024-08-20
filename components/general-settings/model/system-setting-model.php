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
    # - $p_allow_registration (int): The allow registration.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateSystemSetting($p_allow_registration, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateSystemSetting(:p_allow_registration, :p_last_log_by)');
        $stmt->bindValue(':p_allow_registration', $p_allow_registration, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
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