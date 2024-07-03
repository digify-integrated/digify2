<?php
/**
* Class CivilStatusModel
*
* The CivilStatusModel class handles civil status related operations and interactions.
*/
class CivilStatusModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCivilStatus
    # Description: Updates the civil status.
    #
    # Parameters:
    # - $p_civil_status_id (int): The civil status ID.
    # - $p_civil_status_name (string): The civil status name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCivilStatus($p_civil_status_id, $p_civil_status_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCivilStatus(:p_civil_status_id, :p_civil_status_name, :p_last_log_by)');
        $stmt->bindValue(':p_civil_status_id', $p_civil_status_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_civil_status_name', $p_civil_status_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertCivilStatus
    # Description: Inserts the civil status.
    #
    # Parameters:
    # - $p_civil_status_name (string): The civil status name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertCivilStatus($p_civil_status_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCivilStatus(:p_civil_status_name, :p_last_log_by, @p_civil_status_id)');
        $stmt->bindValue(':p_civil_status_name', $p_civil_status_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_civil_status_id AS civil_status_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['civil_status_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkCivilStatusExist
    # Description: Checks if a civil status exists.
    #
    # Parameters:
    # - $p_civil_status_id (int): The civil status ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCivilStatusExist($p_civil_status_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCivilStatusExist(:p_civil_status_id)');
        $stmt->bindValue(':p_civil_status_id', $p_civil_status_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCivilStatus
    # Description: Deletes the civil status.
    #
    # Parameters:
    # - $p_civil_status_id (int): The civil status ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCivilStatus($p_civil_status_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCivilStatus(:p_civil_status_id)');
        $stmt->bindValue(':p_civil_status_id', $p_civil_status_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCivilStatus
    # Description: Retrieves the details of a civil status.
    #
    # Parameters:
    # - $p_civil_status_id (int): The civil status ID.
    #
    # Returns:
    # - An array containing the civil status details.
    #
    # -------------------------------------------------------------
    public function getCivilStatus($p_civil_status_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCivilStatus(:p_civil_status_id)');
        $stmt->bindValue(':p_civil_status_id', $p_civil_status_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateCivilStatusOptions
    # Description: Generates the civil status options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateCivilStatusOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateCivilStatusOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $civilStatusID = $row['civil_status_id'];
            $civilStatusName = $row['civil_status_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($civilStatusID, ENT_QUOTES) . '">' . htmlspecialchars($civilStatusName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>