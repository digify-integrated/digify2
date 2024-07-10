<?php
/**
* Class EmployeeModel
*
* The EmployeeModel class handles employee related operations and interactions.
*/
class EmployeeModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateEmployee
    # Description: Updates the employee.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    # - $p_employee_name (string): The employee name.
    # - $p_parent_employee_id (int): The parent employee ID.
    # - $p_parent_employee_name (string): The parent employee name.
    # - $p_manager_id (int): The manager ID.
    # - $p_manager_name (int): The manager name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmployee($p_employee_id, $p_employee_name, $p_parent_employee_id, $p_parent_employee_name, $p_manager_id, $p_manager_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmployee(:p_employee_id, :p_employee_name, :p_parent_employee_id, :p_parent_employee_name, :p_manager_id, :p_manager_name, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employee_name', $p_employee_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_parent_employee_id', $p_parent_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_parent_employee_name', $p_parent_employee_name, PDO::PARAM_STR);
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
    # Function: insertEmployee
    # Description: Inserts the employee.
    #
    # Parameters:
    # - $p_full_name (string): The full name.
    # - $p_parent_employee_id (int): The parent employee ID.
    # - $p_parent_employee_name (string): The parent employee name.
    # - $p_manager_id (int): The manager ID.
    # - $p_manager_name (int): The manager name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertEmployee($p_full_name, $p_parent_employee_id, $p_parent_employee_name, $p_manager_id, $p_manager_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertEmployee(:p_employee_name, :p_parent_employee_id, :p_parent_employee_name, :p_manager_id, :p_manager_name, :p_last_log_by, @p_employee_id)');
        $stmt->bindValue(':p_employee_name', $p_employee_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_parent_employee_id', $p_parent_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_parent_employee_name', $p_parent_employee_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_manager_id', $p_manager_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_manager_name', $p_manager_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_employee_id AS employee_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['employee_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkEmployeeExist
    # Description: Checks if a employee exists.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkEmployeeExist($p_employee_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkEmployeeExist(:p_employee_id)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteEmployee
    # Description: Deletes the employee.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteEmployee($p_employee_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteEmployee(:p_employee_id)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getEmployee
    # Description: Retrieves the details of a employee.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    #
    # Returns:
    # - An array containing the employee details.
    #
    # -------------------------------------------------------------
    public function getEmployee($p_employee_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getEmployee(:p_employee_id)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateEmployeeOptions
    # Description: Generates the employee options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateEmployeeOptions($p_employee_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateEmployeeOptions(:p_employee_id)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $employeeID = $row['employee_id'];
            $employeeName = $row['employee_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($employeeID, ENT_QUOTES) . '">' . htmlspecialchars($employeeName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>