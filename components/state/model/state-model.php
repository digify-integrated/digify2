<?php
/**
* Class StateModel
*
* The StateModel class handles state related operations and interactions.
*/
class StateModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateState
    # Description: Updates the state.
    #
    # Parameters:
    # - $p_state_id (int): The state ID.
    # - $p_state_name (string): The state name.
    # - $p_country_id (int): The file type ID.
    # - $p_country_name (string): The file type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateState($p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateState(:p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_last_log_by)');
        $stmt->bindValue(':p_state_id', $p_state_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_state_name', $p_state_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_country_id', $p_country_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_country_name', $p_country_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertState
    # Description: Inserts the state.
    #
    # Parameters:
    # - $p_state_name (string): The state name.
    # - $p_country_id (int): The file type ID.
    # - $p_country_name (string): The file type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertState($p_state_name, $p_country_id, $p_country_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertState(:p_state_name, :p_country_id, :p_country_name, :p_last_log_by, @p_state_id)');
        $stmt->bindValue(':p_state_name', $p_state_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_country_id', $p_country_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_country_name', $p_country_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_state_id AS state_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['state_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkStateExist
    # Description: Checks if a state exists.
    #
    # Parameters:
    # - $p_state_id (int): The state ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkStateExist($p_state_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkStateExist(:p_state_id)');
        $stmt->bindValue(':p_state_id', $p_state_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteState
    # Description: Deletes the state.
    #
    # Parameters:
    # - $p_state_id (int): The state ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteState($p_state_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteState(:p_state_id)');
        $stmt->bindValue(':p_state_id', $p_state_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getState
    # Description: Retrieves the details of a state.
    #
    # Parameters:
    # - $p_state_id (int): The state ID.
    #
    # Returns:
    # - An array containing the state details.
    #
    # -------------------------------------------------------------
    public function getState($p_state_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getState(:p_state_id)');
        $stmt->bindValue(':p_state_id', $p_state_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>