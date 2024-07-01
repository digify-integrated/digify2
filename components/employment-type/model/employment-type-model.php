<?php
/**
* Class EmploymentTypeModel
*
* The EmploymentTypeModel class handles employment type related operations and interactions.
*/
class EmploymentTypeModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateEmploymentType
    # Description: Updates the employment type.
    #
    # Parameters:
    # - $p_employment_type_id (int): The employment type ID.
    # - $p_employment_type_name (string): The employment type name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmploymentType($p_employment_type_id, $p_employment_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmploymentType(:p_employment_type_id, :p_employment_type_name, :p_last_log_by)');
        $stmt->bindValue(':p_employment_type_id', $p_employment_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employment_type_name', $p_employment_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertEmploymentType
    # Description: Inserts the employment type.
    #
    # Parameters:
    # - $p_employment_type_name (string): The employment type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertEmploymentType($p_employment_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertEmploymentType(:p_employment_type_name, :p_last_log_by, @p_employment_type_id)');
        $stmt->bindValue(':p_employment_type_name', $p_employment_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_employment_type_id AS employment_type_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['employment_type_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkEmploymentTypeExist
    # Description: Checks if a employment type exists.
    #
    # Parameters:
    # - $p_employment_type_id (int): The employment type ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkEmploymentTypeExist($p_employment_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkEmploymentTypeExist(:p_employment_type_id)');
        $stmt->bindValue(':p_employment_type_id', $p_employment_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteEmploymentType
    # Description: Deletes the employment type.
    #
    # Parameters:
    # - $p_employment_type_id (int): The employment type ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteEmploymentType($p_employment_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteEmploymentType(:p_employment_type_id)');
        $stmt->bindValue(':p_employment_type_id', $p_employment_type_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getEmploymentType
    # Description: Retrieves the details of a employment type.
    #
    # Parameters:
    # - $p_employment_type_id (int): The employment type ID.
    #
    # Returns:
    # - An array containing the employment type details.
    #
    # -------------------------------------------------------------
    public function getEmploymentType($p_employment_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getEmploymentType(:p_employment_type_id)');
        $stmt->bindValue(':p_employment_type_id', $p_employment_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateEmploymentTypeOptions
    # Description: Generates the employment type options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateEmploymentTypeOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateEmploymentTypeOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $departureReasonsID = $row['employment_type_id'];
            $departureReasonsName = $row['employment_type_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($departureReasonsID, ENT_QUOTES) . '">' . htmlspecialchars($departureReasonsName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>