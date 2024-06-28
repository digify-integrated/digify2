<?php
/**
* Class EmploymentTypesModel
*
* The EmploymentTypesModel class handles employment types related operations and interactions.
*/
class EmploymentTypesModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateEmploymentTypes
    # Description: Updates the employment types.
    #
    # Parameters:
    # - $p_employment_types_id (int): The employment types ID.
    # - $p_employment_types_name (string): The employment types name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmploymentTypes($p_employment_types_id, $p_employment_types_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmploymentTypes(:p_employment_types_id, :p_employment_types_name, :p_last_log_by)');
        $stmt->bindValue(':p_employment_types_id', $p_employment_types_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employment_types_name', $p_employment_types_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertEmploymentTypes
    # Description: Inserts the employment types.
    #
    # Parameters:
    # - $p_employment_types_name (string): The employment types name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertEmploymentTypes($p_employment_types_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertEmploymentTypes(:p_employment_types_name, :p_last_log_by, @p_employment_types_id)');
        $stmt->bindValue(':p_employment_types_name', $p_employment_types_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_employment_types_id AS employment_types_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['employment_types_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkEmploymentTypesExist
    # Description: Checks if a employment types exists.
    #
    # Parameters:
    # - $p_employment_types_id (int): The employment types ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkEmploymentTypesExist($p_employment_types_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkEmploymentTypesExist(:p_employment_types_id)');
        $stmt->bindValue(':p_employment_types_id', $p_employment_types_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteEmploymentTypes
    # Description: Deletes the employment types.
    #
    # Parameters:
    # - $p_employment_types_id (int): The employment types ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteEmploymentTypes($p_employment_types_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteEmploymentTypes(:p_employment_types_id)');
        $stmt->bindValue(':p_employment_types_id', $p_employment_types_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getEmploymentTypes
    # Description: Retrieves the details of a employment types.
    #
    # Parameters:
    # - $p_employment_types_id (int): The employment types ID.
    #
    # Returns:
    # - An array containing the employment types details.
    #
    # -------------------------------------------------------------
    public function getEmploymentTypes($p_employment_types_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getEmploymentTypes(:p_employment_types_id)');
        $stmt->bindValue(':p_employment_types_id', $p_employment_types_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateEmploymentTypesOptions
    # Description: Generates the employment types options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateEmploymentTypesOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateEmploymentTypesOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $departureReasonsID = $row['employment_types_id'];
            $departureReasonsName = $row['employment_types_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($departureReasonsID, ENT_QUOTES) . '">' . htmlspecialchars($departureReasonsName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>