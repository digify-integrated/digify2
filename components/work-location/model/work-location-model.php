<?php
/**
* Class WorkLocationModel
*
* The WorkLocationModel class handles work location related operations and interactions.
*/
class WorkLocationModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateWorkLocation
    # Description: Updates the work location.
    #
    # Parameters:
    # - $p_work_location_id (int): The work location ID.
    # - $p_work_location_name (string): The work location name.
    # - $p_address (string): The address of the work location.
    # - $p_city_id (int): The city ID.
    # - $p_city_name (string): The city name.
    # - $p_state_id (int): The state ID.
    # - $p_state_name (string): The state name.
    # - $p_country_id (int): The country ID.
    # - $p_country_name (string): The country name.
    # - $p_phone (string): The phone of the work location.
    # - $p_mobile (string): The mobile of the work location.
    # - $p_email (string): The email of the work location.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateWorkLocation($p_work_location_id, $p_work_location_name, $p_address, $p_city_id, $p_city_name, $p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_phone, $p_mobile, $p_email, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateWorkLocation(:p_work_location_id, :p_work_location_name, :p_address, :p_city_id, :p_city_name, :p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_phone, :p_mobile, :p_email, :p_last_log_by)');
        $stmt->bindValue(':p_work_location_id', $p_work_location_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_work_location_name', $p_work_location_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_address', $p_address, PDO::PARAM_STR);
        $stmt->bindValue(':p_city_id', $p_city_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_city_name', $p_city_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_state_id', $p_state_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_state_name', $p_state_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_country_id', $p_country_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_country_name', $p_country_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_phone', $p_phone, PDO::PARAM_STR);
        $stmt->bindValue(':p_mobile', $p_mobile, PDO::PARAM_STR);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertWorkLocation
    # Description: Inserts the work location.
    #
    # Parameters:
    # - $p_work_location_name (string): The work location name.
    # - $p_address (string): The address of the work location.
    # - $p_city_id (int): The city ID.
    # - $p_city_name (string): The city name.
    # - $p_state_id (int): The state ID.
    # - $p_state_name (string): The state name.
    # - $p_country_id (int): The country ID.
    # - $p_country_name (string): The country name.
    # - $p_phone (string): The phone of the work location.
    # - $p_mobile (string): The mobile of the work location.
    # - $p_email (string): The email of the work location.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertWorkLocation($p_work_location_name, $p_address, $p_city_id, $p_city_name, $p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_phone, $p_mobile, $p_email, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertWorkLocation(:p_work_location_name, :p_address, :p_city_id, :p_city_name, :p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_phone, :p_mobile, :p_email, :p_last_log_by, @p_work_location_id)');
        $stmt->bindValue(':p_work_location_name', $p_work_location_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_address', $p_address, PDO::PARAM_STR);
        $stmt->bindValue(':p_city_id', $p_city_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_city_name', $p_city_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_state_id', $p_state_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_state_name', $p_state_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_country_id', $p_country_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_country_name', $p_country_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_phone', $p_phone, PDO::PARAM_STR);
        $stmt->bindValue(':p_mobile', $p_mobile, PDO::PARAM_STR);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_work_location_id AS work_location_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['work_location_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkWorkLocationExist
    # Description: Checks if a work location exists.
    #
    # Parameters:
    # - $p_work_location_id (int): The work location ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkWorkLocationExist($p_work_location_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkWorkLocationExist(:p_work_location_id)');
        $stmt->bindValue(':p_work_location_id', $p_work_location_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteWorkLocation
    # Description: Deletes the work location.
    #
    # Parameters:
    # - $p_work_location_id (int): The work location ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteWorkLocation($p_work_location_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteWorkLocation(:p_work_location_id)');
        $stmt->bindValue(':p_work_location_id', $p_work_location_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getWorkLocation
    # Description: Retrieves the details of a work location.
    #
    # Parameters:
    # - $p_work_location_id (int): The work location ID.
    #
    # Returns:
    # - An array containing the work location details.
    #
    # -------------------------------------------------------------
    public function getWorkLocation($p_work_location_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getWorkLocation(:p_work_location_id)');
        $stmt->bindValue(':p_work_location_id', $p_work_location_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>