<?php
/**
* Class SystemActionModel
*
* The SystemActionModel class handles system action related operations and interactions.
*/
class SystemActionModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: hemAction
    # Description: Updates the system action.
    #
    # Parameters:
    # - $p_system_action_id (int): The system action ID.
    # - $p_system_action_name (string): The system action name.
    # - $p_system_action_description (string): The description of system action.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateSystemAction($p_system_action_id, $p_system_action_name, $p_system_action_description, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateSystemAction(:p_system_action_id, :p_system_action_name, :p_system_action_description, :p_last_log_by)');
        $stmt->bindValue(':p_system_action_id', $p_system_action_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_system_action_name', $p_system_action_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_system_action_description', $p_system_action_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertSystemAction
    # Description: Inserts the system action.
    #
    # Parameters:
    # - $p_system_action_name (string): The system action name.
    # - $p_system_action_description (string): The description of system action.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertSystemAction($p_system_action_name, $p_system_action_description, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertSystemAction(:p_system_action_name, :p_system_action_description, :p_last_log_by, @p_system_action_id)');
        $stmt->bindValue(':p_system_action_name', $p_system_action_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_system_action_description', $p_system_action_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_system_action_id AS system_action_id');
        $menuGroupID = $result->fetch(PDO::FETCH_ASSOC)['system_action_id'];
        
        return $menuGroupID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkSystemActionExist
    # Description: Checks if a system action exists.
    #
    # Parameters:
    # - $p_system_action_id (int): The system action ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkSystemActionExist($p_system_action_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkSystemActionExist(:p_system_action_id)');
        $stmt->bindValue(':p_system_action_id', $p_system_action_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteSystemAction
    # Description: Deletes the system action.
    #
    # Parameters:
    # - $p_system_action_id (int): The system action ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteSystemAction($p_system_action_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteSystemAction(:p_system_action_id)');
        $stmt->bindValue(':p_system_action_id', $p_system_action_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getSystemAction
    # Description: Retrieves the details of a system action.
    #
    # Parameters:
    # - $p_system_action_id (int): The system action ID.
    #
    # Returns:
    # - An array containing the system action details.
    #
    # -------------------------------------------------------------
    public function getSystemAction($p_system_action_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getSystemAction(:p_system_action_id)');
        $stmt->bindValue(':p_system_action_id', $p_system_action_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>