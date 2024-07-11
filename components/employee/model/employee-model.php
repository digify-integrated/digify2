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
    # - $p_full_name (string): The full name.
    # - $p_first_name (string): The first name.
    # - $p_middle_name (string): The middle name.
    # - $p_last_name (string): The last name.
    # - $p_suffix (string): The suffix.
    # - $p_nickname (string): The nickname.
    # - $p_civil_status_id (int): The civil status ID.
    # - $p_civil_status_name (string): The civil status name.
    # - $p_gender_id (int): The gender ID.
    # - $p_gender_name (string): The gender name.
    # - $p_religion_id (int): The religion ID.
    # - $p_religion_name (string): The religion name.
    # - $p_blood_type_id (int): The blood type ID.
    # - $p_blood_type_name (string): The blood type name.
    # - $p_birthday (date): The birthday.
    # - $p_birth_place (date): The birth place.
    # - $p_height (date): The height.
    # - $p_weight (date): The weight.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmployee($p_employee_id, $p_full_name, $p_first_name, $p_middle_name, $p_last_name, $p_suffix, $p_nickname, $p_civil_status_name, $p_gender_id, $p_gender_name, $p_religion_id, $p_religion_name, $p_blood_type_id, $p_blood_type_name, $p_birthday, $p_birth_place, $p_height, $p_weight, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmployee(:p_full_name, :p_first_name, :p_middle_name, :p_last_name, :p_suffix, :p_nickname, :p_civil_status_id, :p_civil_status_name, :p_gender_id, :p_gender_name, :p_religion_id, :p_religion_name, :p_blood_type_id, :p_blood_type_name, :p_birthday, :p_birth_place, :p_height, :p_weight, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_full_name', $p_full_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_first_name', $p_first_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_middle_name', $p_middle_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_name', $p_last_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_suffix', $p_suffix, PDO::PARAM_STR);
        $stmt->bindValue(':p_nickname', $p_nickname, PDO::PARAM_STR);
        $stmt->bindValue(':p_civil_status_id', $p_civil_status_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_civil_status_name', $p_civil_status_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_gender_id', $p_gender_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_gender_name', $p_gender_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_religion_id', $p_religion_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_religion_name', $p_religion_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_blood_type_id', $p_blood_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_blood_type_name', $p_blood_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_birthday', $p_birthday, PDO::PARAM_STR);
        $stmt->bindValue(':p_birth_place', $p_birth_place, PDO::PARAM_STR);
        $stmt->bindValue(':p_height', $p_height, PDO::PARAM_STR);
        $stmt->bindValue(':p_weight', $p_weight, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateEmployeeImage
    # Description: Updates the employee image.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    # - $p_employee_image (string): The employee image path file.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmployeeImage($p_employee_id, $p_employee_image, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmployeeImage(:p_employee_id, :p_employee_image, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employee_image', $p_employee_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateWorkPermit
    # Description: Updates the work permit file.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    # - $p_work_permit (string): The work permit file path file.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateWorkPermit($p_employee_id, $p_work_permit, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateWorkPermit(:p_employee_id, :p_work_permit, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_work_permit', $p_work_permit, PDO::PARAM_STR);
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
    # - $p_first_name (string): The first name.
    # - $p_middle_name (string): The middle name.
    # - $p_last_name (string): The last name.
    # - $p_suffix (string): The suffix.
    # - $p_nickname (string): The nickname.
    # - $p_civil_status_id (int): The civil status ID.
    # - $p_civil_status_name (string): The civil status name.
    # - $p_gender_id (int): The gender ID.
    # - $p_gender_name (string): The gender name.
    # - $p_religion_id (int): The religion ID.
    # - $p_religion_name (string): The religion name.
    # - $p_blood_type_id (int): The blood type ID.
    # - $p_blood_type_name (string): The blood type name.
    # - $p_birthday (date): The birthday.
    # - $p_birth_place (date): The birth place.
    # - $p_height (date): The height.
    # - $p_weight (date): The weight.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertEmployee($p_full_name, $p_first_name, $p_middle_name, $p_last_name, $p_suffix, $p_nickname, $p_civil_status_id, $p_civil_status_name, $p_gender_id, $p_gender_name, $p_religion_id, $p_religion_name, $p_blood_type_id, $p_blood_type_name, $p_birthday, $p_birth_place, $p_height, $p_weight, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertEmployee(:p_full_name, :p_first_name, :p_middle_name, :p_last_name, :p_suffix, :p_nickname, :p_civil_status_id, :p_civil_status_name, :p_gender_id, :p_gender_name, :p_religion_id, :p_religion_name, :p_blood_type_id, :p_blood_type_name, :p_birthday, :p_birth_place, :p_height, :p_weight, :p_last_log_by, @p_employee_id)');
        $stmt->bindValue(':p_full_name', $p_full_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_first_name', $p_first_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_middle_name', $p_middle_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_name', $p_last_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_suffix', $p_suffix, PDO::PARAM_STR);
        $stmt->bindValue(':p_nickname', $p_nickname, PDO::PARAM_STR);
        $stmt->bindValue(':p_civil_status_id', $p_civil_status_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_civil_status_name', $p_civil_status_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_gender_id', $p_gender_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_gender_name', $p_gender_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_religion_id', $p_religion_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_religion_name', $p_religion_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_blood_type_id', $p_blood_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_blood_type_name', $p_blood_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_birthday', $p_birthday, PDO::PARAM_STR);
        $stmt->bindValue(':p_birth_place', $p_birth_place, PDO::PARAM_STR);
        $stmt->bindValue(':p_height', $p_height, PDO::PARAM_STR);
        $stmt->bindValue(':p_weight', $p_weight, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_employee_id AS employee_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['employee_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertWorkInformation
    # Description: Inserts the work information.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    # - $p_badge_id (string): The badge ID.
    # - $p_company_id (int): The company ID.
    # - $p_company_name (string): The company name.
    # - $p_employment_type_id (int): The employment type ID.
    # - $p_employment_type_name (string): The employment type name.
    # - $p_department_id (int): The department ID.
    # - $p_department_name (string): The department name.
    # - $p_job_position_id (int): The job position ID.
    # - $p_job_position_name (string): The job position name.
    # - $p_work_location_id (int): The work location ID.
    # - $p_work_location_name (string): The work location name.
    # - $p_manager_id (int): The manager ID.
    # - $p_manager_name (string): The manager name.
    # - $p_work_schedule_id (int): The work schedule ID.
    # - $p_work_schedule_name (string): The work schedule name.
    # - $p_pin_code (string): The pin code.
    # - $p_home_work_distance (double): The home work distance.
    # - $p_visa_number (string): The visa number.
    # - $p_work_permit_number (string): The work permit number.
    # - $p_visa_expiration_date (date): The visa expiration date.
    # - $p_work_permit_expiration_date (date): The work permit expiration date.
    # - $p_onboard_date (date): The on-board date.
    # - $p_time_off_approver_id (int): The time off approver ID.
    # - $p_time_off_approver_name (string): The time off approver name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertWorkInformation($p_employee_id, $p_badge_id, $p_company_id, $p_company_name, $p_employment_type_id, $p_employment_type_name, $p_department_id, $p_department_name, $p_job_position_id, $p_job_position_name, $p_work_location_id, $p_work_location_name, $p_manager_id, $p_manager_name, $p_work_schedule_id, $p_work_schedule_name, $p_pin_code, $p_home_work_distance, $p_visa_number, $p_work_permit_number, $p_visa_expiration_date, $p_work_permit_expiration_date, $p_onboard_date, $p_time_off_approver_id, $p_time_off_approver_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertWorkInformation(:p_employee_id, :p_badge_id, :p_company_id, :p_company_name, :p_employment_type_id, :p_employment_type_name, :p_department_id, :p_department_name, :p_job_position_id, :p_job_position_name, :p_work_location_id, :p_work_location_name, :p_manager_id, :p_manager_name, :p_work_schedule_id, :p_work_schedule_name, :p_pin_code, :p_home_work_distance, :p_visa_number, :p_work_permit_number, :p_visa_expiration_date, :p_work_permit_expiration_date, :p_onboard_date, :p_time_off_approver_id, :p_time_off_approver_name, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_badge_id', $p_badge_id, PDO::PARAM_STR);
        $stmt->bindValue(':p_company_id', $p_company_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_company_name', $p_company_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_employment_type_id', $p_employment_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employment_type_name', $p_employment_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_department_id', $p_department_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_department_name', $p_department_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_job_position_id', $p_job_position_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_job_position_name', $p_job_position_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_work_location_id', $p_work_location_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_work_location_name', $p_work_location_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_manager_id', $p_manager_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_manager_name', $p_manager_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_work_schedule_id', $p_work_schedule_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_work_schedule_name', $p_work_schedule_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_pin_code', $p_pin_code, PDO::PARAM_STR);
        $stmt->bindValue(':p_home_work_distance', $p_home_work_distance, PDO::PARAM_STR);
        $stmt->bindValue(':p_visa_number', $p_visa_number, PDO::PARAM_STR);
        $stmt->bindValue(':p_work_permit_number', $p_work_permit_number, PDO::PARAM_STR);
        $stmt->bindValue(':p_visa_expiration_date', $p_visa_expiration_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_work_permit_expiration_date', $p_work_permit_expiration_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_onboard_date', $p_onboard_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_time_off_approver_id', $p_time_off_approver_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_time_off_approver_name', $p_time_off_approver_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
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