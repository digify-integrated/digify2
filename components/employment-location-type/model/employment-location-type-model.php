<?php
/**
* Class EmploymentLocationTypeModel
*
* The EmploymentLocationTypeModel class handles employment location type related operations and interactions.
*/
class EmploymentLocationTypeModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateEmploymentLocationType
    # Description: Updates the employment location type.
    #
    # Parameters:
    # - $p_employment_location_type_id (int): The employment location type ID.
    # - $p_employment_location_type_name (string): The employment location type name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmploymentLocationType($p_employment_location_type_id, $p_employment_location_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmploymentLocationType(:p_employment_location_type_id, :p_employment_location_type_name, :p_last_log_by)');
        $stmt->bindValue(':p_employment_location_type_id', $p_employment_location_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employment_location_type_name', $p_employment_location_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertEmploymentLocationType
    # Description: Inserts the employment location type.
    #
    # Parameters:
    # - $p_employment_location_type_name (string): The employment location type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertEmploymentLocationType($p_employment_location_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertEmploymentLocationType(:p_employment_location_type_name, :p_last_log_by, @p_employment_location_type_id)');
        $stmt->bindValue(':p_employment_location_type_name', $p_employment_location_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_employment_location_type_id AS employment_location_type_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['employment_location_type_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkEmploymentLocationTypeExist
    # Description: Checks if a employment location type exists.
    #
    # Parameters:
    # - $p_employment_location_type_id (int): The employment location type ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkEmploymentLocationTypeExist($p_employment_location_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkEmploymentLocationTypeExist(:p_employment_location_type_id)');
        $stmt->bindValue(':p_employment_location_type_id', $p_employment_location_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteEmploymentLocationType
    # Description: Deletes the employment location type.
    #
    # Parameters:
    # - $p_employment_location_type_id (int): The employment location type ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteEmploymentLocationType($p_employment_location_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteEmploymentLocationType(:p_employment_location_type_id)');
        $stmt->bindValue(':p_employment_location_type_id', $p_employment_location_type_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getEmploymentLocationType
    # Description: Retrieves the details of a employment location type.
    #
    # Parameters:
    # - $p_employment_location_type_id (int): The employment location type ID.
    #
    # Returns:
    # - An array containing the employment location type details.
    #
    # -------------------------------------------------------------
    public function getEmploymentLocationType($p_employment_location_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getEmploymentLocationType(:p_employment_location_type_id)');
        $stmt->bindValue(':p_employment_location_type_id', $p_employment_location_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateEmploymentLocationTypeOptions
    # Description: Generates the employment location type options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateEmploymentLocationTypeOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateEmploymentLocationTypeOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $employmentLocationTypeID = $row['employment_location_type_id'];
            $employmentLocationTypeName = $row['employment_location_type_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($employmentLocationTypeID, ENT_QUOTES) . '">' . htmlspecialchars($employmentLocationTypeName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>