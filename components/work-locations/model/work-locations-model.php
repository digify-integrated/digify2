<?php
/**
* Class WorkLocationsModel
*
* The WorkLocationsModel class handles work locations related operations and interactions.
*/
class WorkLocationsModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateWorkLocations
    # Description: Updates the work locations.
    #
    # Parameters:
    # - $p_work_locations_id (int): The work locations ID.
    # - $p_work_locations_name (string): The work locations name.
    # - $p_address (string): The address of the work locations.
    # - $p_city_id (int): The city ID.
    # - $p_city_name (string): The city name.
    # - $p_state_id (int): The state ID.
    # - $p_state_name (string): The state name.
    # - $p_country_id (int): The country ID.
    # - $p_country_name (string): The country name.
    # - $p_phone (string): The phone of the work locations.
    # - $p_mobile (string): The mobile of the work locations.
    # - $p_email (string): The email of the work locations.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateWorkLocations($p_work_locations_id, $p_work_locations_name, $p_address, $p_city_id, $p_city_name, $p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_phone, $p_mobile, $p_email, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateWorkLocations(:p_work_locations_id, :p_work_locations_name, :p_address, :p_city_id, :p_city_name, :p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_phone, :p_mobile, :p_email, :p_last_log_by)');
        $stmt->bindValue(':p_work_locations_id', $p_work_locations_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_work_locations_name', $p_work_locations_name, PDO::PARAM_STR);
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
    # Function: insertWorkLocations
    # Description: Inserts the work locations.
    #
    # Parameters:
    # - $p_work_locations_name (string): The work locations name.
    # - $p_address (string): The address of the work locations.
    # - $p_city_id (int): The city ID.
    # - $p_city_name (string): The city name.
    # - $p_state_id (int): The state ID.
    # - $p_state_name (string): The state name.
    # - $p_country_id (int): The country ID.
    # - $p_country_name (string): The country name.
    # - $p_phone (string): The phone of the work locations.
    # - $p_mobile (string): The mobile of the work locations.
    # - $p_email (string): The email of the work locations.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertWorkLocations($p_work_locations_name, $p_address, $p_city_id, $p_city_name, $p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_phone, $p_mobile, $p_email, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertWorkLocations(:p_work_locations_name, :p_address, :p_city_id, :p_city_name, :p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_phone, :p_mobile, :p_email, :p_last_log_by, @p_work_locations_id)');
        $stmt->bindValue(':p_work_locations_name', $p_work_locations_name, PDO::PARAM_STR);
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
        
        $result = $this->db->getConnection()->query('SELECT @p_work_locations_id AS work_locations_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['work_locations_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkWorkLocationsExist
    # Description: Checks if a work locations exists.
    #
    # Parameters:
    # - $p_work_locations_id (int): The work locations ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkWorkLocationsExist($p_work_locations_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkWorkLocationsExist(:p_work_locations_id)');
        $stmt->bindValue(':p_work_locations_id', $p_work_locations_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteWorkLocations
    # Description: Deletes the work locations.
    #
    # Parameters:
    # - $p_work_locations_id (int): The work locations ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteWorkLocations($p_work_locations_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteWorkLocations(:p_work_locations_id)');
        $stmt->bindValue(':p_work_locations_id', $p_work_locations_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getWorkLocations
    # Description: Retrieves the details of a work locations.
    #
    # Parameters:
    # - $p_work_locations_id (int): The work locations ID.
    #
    # Returns:
    # - An array containing the work locations details.
    #
    # -------------------------------------------------------------
    public function getWorkLocations($p_work_locations_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getWorkLocations(:p_work_locations_id)');
        $stmt->bindValue(':p_work_locations_id', $p_work_locations_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>