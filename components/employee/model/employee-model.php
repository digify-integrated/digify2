<?php
/**
* Class DepartmentModel
*
* The DepartmentModel class handles department related operations and interactions.
*/
class DepartmentModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateDepartment
    # Description: Updates the department.
    #
    # Parameters:
    # - $p_department_id (int): The department ID.
    # - $p_department_name (string): The department name.
    # - $p_parent_department_id (int): The parent department ID.
    # - $p_parent_department_name (string): The parent department name.
    # - $p_manager_id (int): The manager ID.
    # - $p_manager_name (int): The manager name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateDepartment($p_department_id, $p_department_name, $p_parent_department_id, $p_parent_department_name, $p_manager_id, $p_manager_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateDepartment(:p_department_id, :p_department_name, :p_parent_department_id, :p_parent_department_name, :p_manager_id, :p_manager_name, :p_last_log_by)');
        $stmt->bindValue(':p_department_id', $p_department_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_department_name', $p_department_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_parent_department_id', $p_parent_department_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_parent_department_name', $p_parent_department_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_manager_id', $p_manager_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_manager_name', $p_manager_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertDepartment
    # Description: Inserts the department.
    #
    # Parameters:
    # - $p_department_name (string): The department name.
    # - $p_parent_department_id (int): The parent department ID.
    # - $p_parent_department_name (string): The parent department name.
    # - $p_manager_id (int): The manager ID.
    # - $p_manager_name (int): The manager name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertDepartment($p_department_name, $p_parent_department_id, $p_parent_department_name, $p_manager_id, $p_manager_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertDepartment(:p_department_name, :p_parent_department_id, :p_parent_department_name, :p_manager_id, :p_manager_name, :p_last_log_by, @p_department_id)');
        $stmt->bindValue(':p_department_name', $p_department_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_parent_department_id', $p_parent_department_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_parent_department_name', $p_parent_department_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_manager_id', $p_manager_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_manager_name', $p_manager_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_department_id AS department_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['department_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkDepartmentExist
    # Description: Checks if a department exists.
    #
    # Parameters:
    # - $p_department_id (int): The department ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkDepartmentExist($p_department_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkDepartmentExist(:p_department_id)');
        $stmt->bindValue(':p_department_id', $p_department_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteDepartment
    # Description: Deletes the department.
    #
    # Parameters:
    # - $p_department_id (int): The department ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteDepartment($p_department_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteDepartment(:p_department_id)');
        $stmt->bindValue(':p_department_id', $p_department_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getDepartment
    # Description: Retrieves the details of a department.
    #
    # Parameters:
    # - $p_department_id (int): The department ID.
    #
    # Returns:
    # - An array containing the department details.
    #
    # -------------------------------------------------------------
    public function getDepartment($p_department_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getDepartment(:p_department_id)');
        $stmt->bindValue(':p_department_id', $p_department_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateDepartmentOptions
    # Description: Generates the department options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateDepartmentOptions($p_department_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateDepartmentOptions(:p_department_id)');
        $stmt->bindValue(':p_department_id', $p_department_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $departmentID = $row['department_id'];
            $departmentName = $row['department_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($departmentID, ENT_QUOTES) . '">' . htmlspecialchars($departmentName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>