<?php
/**
* Class CountryModel
*
* The CountryModel class handles country related operations and interactions.
*/
class CountryModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCountry
    # Description: Updates the country.
    #
    # Parameters:
    # - $p_country_id (int): The country ID.
    # - $p_country_name (string): The country name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCountry($p_country_id, $p_country_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCountry(:p_country_id, :p_country_name, :p_last_log_by)');
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
    # Function: insertCountry
    # Description: Inserts the country.
    #
    # Parameters:
    # - $p_country_name (string): The country name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertCountry($p_country_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCountry(:p_country_name, :p_last_log_by, @p_country_id)');
        $stmt->bindValue(':p_country_name', $p_country_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_country_id AS country_id');
        $fileTypeID = $result->fetch(PDO::FETCH_ASSOC)['country_id'];
        
        return $fileTypeID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkCountryExist
    # Description: Checks if a country exists.
    #
    # Parameters:
    # - $p_country_id (int): The country ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCountryExist($p_country_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCountryExist(:p_country_id)');
        $stmt->bindValue(':p_country_id', $p_country_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCountry
    # Description: Deletes the country.
    #
    # Parameters:
    # - $p_country_id (int): The country ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCountry($p_country_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCountry(:p_country_id)');
        $stmt->bindValue(':p_country_id', $p_country_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCountry
    # Description: Retrieves the details of a country.
    #
    # Parameters:
    # - $p_country_id (int): The country ID.
    #
    # Returns:
    # - An array containing the country details.
    #
    # -------------------------------------------------------------
    public function getCountry($p_country_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCountry(:p_country_id)');
        $stmt->bindValue(':p_country_id', $p_country_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>