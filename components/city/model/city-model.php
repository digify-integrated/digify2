<?php
/**
* Class CityModel
*
* The CityModel class handles city related operations and interactions.
*/
class CityModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCity
    # Description: Updates the city.
    #
    # Parameters:
    # - $p_city_id (int): The city ID.
    # - $p_city_name (string): The city name.
    # - $p_state_id (int): The state ID.
    # - $p_state_name (string): The state name.
    # - $p_country_id (int): The country ID.
    # - $p_country_name (string): The country name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCity($p_city_id, $p_city_name, $p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCity(:p_city_id, :p_city_name, :p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_last_log_by)');
        $stmt->bindValue(':p_city_id', $p_city_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_city_name', $p_city_name, PDO::PARAM_STR);
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
    # Function: insertCity
    # Description: Inserts the city.
    #
    # Parameters:
    # - $p_city_name (string): The city name.
    # - $p_state_id (int): The state ID.
    # - $p_state_name (string): The state name.
    # - $p_country_id (int): The country ID.
    # - $p_country_name (string): The country name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertCity($p_city_name, $p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCity(:p_city_name, :p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_last_log_by, @p_city_id)');
        $stmt->bindValue(':p_city_name', $p_city_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_state_id', $p_state_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_state_name', $p_state_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_country_id', $p_country_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_country_name', $p_country_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_city_id AS city_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['city_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkCityExist
    # Description: Checks if a city exists.
    #
    # Parameters:
    # - $p_city_id (int): The city ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCityExist($p_city_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCityExist(:p_city_id)');
        $stmt->bindValue(':p_city_id', $p_city_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCity
    # Description: Deletes the city.
    #
    # Parameters:
    # - $p_city_id (int): The city ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCity($p_city_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCity(:p_city_id)');
        $stmt->bindValue(':p_city_id', $p_city_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCity
    # Description: Retrieves the details of a city.
    #
    # Parameters:
    # - $p_city_id (int): The city ID.
    #
    # Returns:
    # - An array containing the city details.
    #
    # -------------------------------------------------------------
    public function getCity($p_city_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCity(:p_city_id)');
        $stmt->bindValue(':p_city_id', $p_city_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>