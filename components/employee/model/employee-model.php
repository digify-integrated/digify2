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
    # Function: updateEmployeeAbout
    # Description: Updates the employee about.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    # - $p_about (string): The about.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmployeeAbout($p_employee_id, $p_about, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmployeeAbout(:p_employee_id, :p_about, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_about', $p_about, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateEmployeePrivateInformation
    # Description: Updates the employee private information.
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
    public function updateEmployeePrivateInformation($p_employee_id, $p_full_name, $p_first_name, $p_middle_name, $p_last_name, $p_suffix, $p_nickname, $p_civil_status_id, $p_civil_status_name, $p_gender_id, $p_gender_name, $p_religion_id, $p_religion_name, $p_blood_type_id, $p_blood_type_name, $p_birthday, $p_birth_place, $p_height, $p_weight, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmployeePrivateInformation(:p_employee_id, :p_full_name, :p_first_name, :p_middle_name, :p_last_name, :p_suffix, :p_nickname, :p_civil_status_id, :p_civil_status_name, :p_gender_id, :p_gender_name, :p_religion_id, :p_religion_name, :p_blood_type_id, :p_blood_type_name, :p_birthday, :p_birth_place, :p_height, :p_weight, :p_last_log_by)');
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
    # Function: updateEmployeeWorkInformation
    # Description: Updates the employee work information.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    # - $p_badge_id (string): The badge ID.
    # - $p_company_id (int): The company ID.
    # - $p_company_name (string): The company name.
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
    # - $p_home_work_distance (double): The home work distance.
    # - $p_time_off_approver_id (int): The time off approver ID.
    # - $p_time_off_approver_name (string): The time off approver name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmployeeWorkInformation($p_employee_id, $p_company_id, $p_company_name, $p_department_id, $p_department_name, $p_job_position_id, $p_job_position_name, $p_work_location_id, $p_work_location_name, $p_manager_id, $p_manager_name, $p_work_schedule_id, $p_work_schedule_name, $p_home_work_distance, $p_time_off_approver_id, $p_time_off_approver_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmployeeWorkInformation(:p_employee_id, :p_company_id, :p_company_name, :p_department_id, :p_department_name, :p_job_position_id, :p_job_position_name, :p_work_location_id, :p_work_location_name, :p_manager_id, :p_manager_name, :p_work_schedule_id, :p_work_schedule_name, :p_home_work_distance, :p_time_off_approver_id, :p_time_off_approver_name, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_company_id', $p_company_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_company_name', $p_company_name, PDO::PARAM_STR);
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
        $stmt->bindValue(':p_home_work_distance', $p_home_work_distance, PDO::PARAM_STR);
        $stmt->bindValue(':p_time_off_approver_id', $p_time_off_approver_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_time_off_approver_name', $p_time_off_approver_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateEmployeeHRSettings
    # Description: Updates the employee hr settings.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    # - $p_badge_id (string): The badge ID.
    # - $p_employment_type_id (int): The employment type ID.
    # - $p_employment_type_name (string): The employment type name.
    # - $p_pin_code (string): The pin code.
    # - $p_onboard_date (date): The on-board date.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmployeeHRSettings($p_employee_id, $p_badge_id, $p_employment_type_id, $p_employment_type_name, $p_pin_code, $p_onboard_date, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmployeeHRSettings(:p_employee_id, :p_badge_id, :p_employment_type_id, :p_employment_type_name, :p_pin_code, :p_onboard_date, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_badge_id', $p_badge_id, PDO::PARAM_STR);
        $stmt->bindValue(':p_employment_type_id', $p_employment_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employment_type_name', $p_employment_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_pin_code', $p_pin_code, PDO::PARAM_STR);
        $stmt->bindValue(':p_onboard_date', $p_onboard_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateEmployeeWorkPermit
    # Description: Updates the employee work permit.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    # - $p_visa_number (string): The visa number.
    # - $p_work_permit_number (string): The work permit number.
    # - $p_visa_expiration_date (date): The visa expiration date.
    # - $p_work_permit_expiration_date (date): The work permit expiration date.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmployeeWorkPermit($p_employee_id, $p_visa_number, $p_work_permit_number, $p_visa_expiration_date, $p_work_permit_expiration_date, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmployeeWorkPermit(:p_employee_id, :p_visa_number, :p_work_permit_number, :p_visa_expiration_date, :p_work_permit_expiration_date, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_visa_number', $p_visa_number, PDO::PARAM_STR);
        $stmt->bindValue(':p_work_permit_number', $p_work_permit_number, PDO::PARAM_STR);
        $stmt->bindValue(':p_visa_expiration_date', $p_visa_expiration_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_work_permit_expiration_date', $p_work_permit_expiration_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateEmployeeExperience
    # Description: Updates the employee experience.
    #
    # Parameters:
    # - $p_employee_experience_id (int): The employee experience ID.
    # - $p_employee_id (int): The employee ID.
    # - $p_job_title (string): The job title.
    # - $p_employment_type_id (int): The employment type ID.
    # - $p_employment_type_name (string): The employment type name.
    # - $p_company_name (string): The company name.
    # - $p_location (string): The location.
    # - $p_employment_location_type_id (int): The employment location type ID.
    # - $p_employment_location_type_name (string): The employment location type name.
    # - $p_start_month (string): The start month.
    # - $p_start_year (string): The start year.
    # - $p_end_month (string): The end month.
    # - $p_end_year (string): The end year.
    # - $p_job_description (string): The job description.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmployeeExperience($p_employee_experience_id, $p_employee_id, $p_job_title, $p_employment_type_id , $p_employment_type_name, $p_company_name, $p_location, $p_employment_location_type_id, $p_employment_location_type_name, $p_start_month, $p_start_year, $p_end_month, $p_end_year, $p_job_description, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmployeeExperience(:p_employee_experience_id, :p_employee_id, :p_job_title, :p_employment_type_id , :p_employment_type_name, :p_company_name, :p_location, :p_employment_location_type_id, :p_employment_location_type_name, :p_start_month, :p_start_year, :p_end_month, :p_end_year, :p_job_description, :p_last_log_by)');
        $stmt->bindValue(':p_employee_experience_id', $p_employee_experience_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_job_title', $p_job_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_employment_type_id', $p_employment_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employment_type_name', $p_employment_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_company_name', $p_company_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_location', $p_location, PDO::PARAM_STR);
        $stmt->bindValue(':p_employment_location_type_id', $p_employment_location_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employment_location_type_name', $p_employment_location_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_start_month', $p_start_month, PDO::PARAM_STR);
        $stmt->bindValue(':p_start_year', $p_start_year, PDO::PARAM_STR);
        $stmt->bindValue(':p_end_month', $p_end_month, PDO::PARAM_STR);
        $stmt->bindValue(':p_end_year', $p_end_year, PDO::PARAM_STR);
        $stmt->bindValue(':p_job_description', $p_job_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateEmployeeEducation
    # Description: Updates the employee education.
    #
    # Parameters:
    # - $p_employee_education_id (int): The employee education ID.
    # - $p_employee_id (int): The employee ID.
    # - $p_school (string): The school.
    # - $p_degree (string): The degree.
    # - $p_field_of_study (string): The field of study.
    # - $p_start_month (string): The start month.
    # - $p_start_year (string): The start year.
    # - $p_end_month (string): The end month.
    # - $p_end_year (string): The end year.
    # - $p_activities_societies (string): The activities and societies.
    # - $p_education_description (string): The education description.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmployeeEducation($p_employee_education_id, $p_employee_id, $p_school, $p_degree, $p_field_of_study, $p_start_month, $p_start_year, $p_end_month, $p_end_year, $p_activities_societies, $p_education_description, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmployeeEducation(:p_employee_education_id, :p_employee_id, :p_school, :p_degree, :p_field_of_study, :p_start_month, :p_start_year, :p_end_month, :p_end_year, :p_activities_societies, :p_education_description, :p_last_log_by)');
        $stmt->bindValue(':p_employee_education_id', $p_employee_education_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_school', $p_school, PDO::PARAM_STR);
        $stmt->bindValue(':p_degree', $p_degree, PDO::PARAM_STR);
        $stmt->bindValue(':p_field_of_study', $p_field_of_study, PDO::PARAM_STR);
        $stmt->bindValue(':p_start_month', $p_start_month, PDO::PARAM_STR);
        $stmt->bindValue(':p_start_year', $p_start_year, PDO::PARAM_STR);
        $stmt->bindValue(':p_end_month', $p_end_month, PDO::PARAM_STR);
        $stmt->bindValue(':p_end_year', $p_end_year, PDO::PARAM_STR);
        $stmt->bindValue(':p_activities_societies', $p_activities_societies, PDO::PARAM_STR);
        $stmt->bindValue(':p_education_description', $p_education_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateEmployeeAddress
    # Description: Updates the employee address.
    #
    # Parameters:
    # - $p_employee_address_id (int): The employee address ID.
    # - $p_employee_id (int): The employee ID.
    # - $p_address_type_id (int): The address type ID.
    # - $p_address_type_name (string): The address type name.
    # - $p_address (string): The address.
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
    public function updateEmployeeAddress($p_employee_address_id, $p_employee_id, $p_address_type_id, $p_address_type_name, $p_address, $p_city_id, $p_city_name, $p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmployeeAddress(:p_employee_address_id, :p_employee_id, :p_address_type_id, :p_address_type_name, :p_address, :p_city_id, :p_city_name, :p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_last_log_by)');
        $stmt->bindValue(':p_employee_address_id', $p_employee_address_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_address_type_id', $p_address_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_address_type_name', $p_address_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_address', $p_address, PDO::PARAM_STR);
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
    #
    # Function: updateEmployeeBankAccount
    # Description: Updates the employee bank account.
    #
    # Parameters:
    # - $p_employee_bank_account_id (int): The employee bank account ID.
    # - $p_employee_id (int): The employee ID.
    # - $p_bank_id (int): The bank ID.
    # - $p_bank_name (string): The bank name.
    # - $p_bank_account_type_id (int): The bank account type ID.
    # - $p_bank_account_type_name (string): The bank account type name.
    # - $p_account_number (string): The account number.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEmployeeBankAccount($p_employee_bank_account_id, $p_employee_id, $p_bank_id, $p_bank_name, $p_bank_account_type_id, $p_bank_account_type_name, $p_account_number, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEmployeeBankAccount(:p_employee_bank_account_id, :p_employee_id, :p_bank_id, :p_bank_name, :p_bank_account_type_id, :p_bank_account_type_name, :p_account_number, :p_last_log_by)');
        $stmt->bindValue(':p_employee_bank_account_id', $p_employee_bank_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_id', $p_bank_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_name', $p_bank_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_bank_account_type_id', $p_bank_account_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_account_type_name', $p_bank_account_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_account_number', $p_account_number, PDO::PARAM_STR);
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
    public function insertEmployee($p_full_name, $p_first_name, $p_middle_name, $p_last_name, $p_suffix, $p_nickname, $p_civil_status_id, $p_civil_status_name, $p_gender_id, $p_gender_name, $p_religion_id, $p_religion_name, $p_blood_type_id, $p_blood_type_name, $p_birthday, $p_birth_place, $p_height, $p_weight, $p_badge_id, $p_company_id, $p_company_name, $p_employment_type_id, $p_employment_type_name, $p_department_id, $p_department_name, $p_job_position_id, $p_job_position_name, $p_work_location_id, $p_work_location_name, $p_manager_id, $p_manager_name, $p_work_schedule_id, $p_work_schedule_name, $p_pin_code, $p_home_work_distance, $p_visa_number, $p_work_permit_number, $p_visa_expiration_date, $p_work_permit_expiration_date, $p_onboard_date, $p_time_off_approver_id, $p_time_off_approver_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertEmployee(:p_full_name, :p_first_name, :p_middle_name, :p_last_name, :p_suffix, :p_nickname, :p_civil_status_id, :p_civil_status_name, :p_gender_id, :p_gender_name, :p_religion_id, :p_religion_name, :p_blood_type_id, :p_blood_type_name, :p_birthday, :p_birth_place, :p_height, :p_weight, :p_badge_id, :p_company_id, :p_company_name, :p_employment_type_id, :p_employment_type_name, :p_department_id, :p_department_name, :p_job_position_id, :p_job_position_name, :p_work_location_id, :p_work_location_name, :p_manager_id, :p_manager_name, :p_work_schedule_id, :p_work_schedule_name, :p_pin_code, :p_home_work_distance, :p_visa_number, :p_work_permit_number, :p_visa_expiration_date, :p_work_permit_expiration_date, :p_onboard_date, :p_time_off_approver_id, :p_time_off_approver_name, :p_last_log_by, @p_employee_id)');
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
        
        $result = $this->db->getConnection()->query('SELECT @p_employee_id AS employee_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['employee_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertEmployeeExperience
    # Description: Inserts the employee experience.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    # - $p_job_title (string): The job title.
    # - $p_employment_type_id (string): The employment type ID.
    # - $p_employment_type_name (string): The employment type name.
    # - $p_company_name (string): The company name.
    # - $p_location (string): The location.
    # - $p_employment_location_type_id (int): The employment location type ID.
    # - $p_employment_location_type_name (string): The employment location type name.
    # - $p_start_month (string): The start month.
    # - $p_start_year (string): The start year.
    # - $p_end_month (string): The end month.
    # - $p_end_year (string): The end year.
    # - $p_job_description (string): The job description.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertEmployeeExperience($p_employee_id, $p_job_title, $p_employment_type_id , $p_employment_type_name, $p_company_name, $p_location, $p_employment_location_type_id, $p_employment_location_type_name, $p_start_month, $p_start_year, $p_end_month, $p_end_year, $p_job_description, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertEmployeeExperience(:p_employee_id, :p_job_title, :p_employment_type_id , :p_employment_type_name, :p_company_name, :p_location, :p_employment_location_type_id, :p_employment_location_type_name, :p_start_month, :p_start_year, :p_end_month, :p_end_year, :p_job_description, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_job_title', $p_job_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_employment_type_id', $p_employment_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employment_type_name', $p_employment_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_company_name', $p_company_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_location', $p_location, PDO::PARAM_STR);
        $stmt->bindValue(':p_employment_location_type_id', $p_employment_location_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employment_location_type_name', $p_employment_location_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_start_month', $p_start_month, PDO::PARAM_STR);
        $stmt->bindValue(':p_start_year', $p_start_year, PDO::PARAM_STR);
        $stmt->bindValue(':p_end_month', $p_end_month, PDO::PARAM_STR);
        $stmt->bindValue(':p_end_year', $p_end_year, PDO::PARAM_STR);
        $stmt->bindValue(':p_job_description', $p_job_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertEmployeeEducation
    # Description: Inserts the employee education.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    # - $p_school (string): The school.
    # - $p_degree (string): The degree.
    # - $p_field_of_study (string): The field of study.
    # - $p_start_month (string): The start month.
    # - $p_start_year (string): The start year.
    # - $p_end_month (string): The end month.
    # - $p_end_year (string): The end year.
    # - $p_activities_societies (string): The activities and societies.
    # - $p_education_description (string): The education description.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertEmployeeEducation($p_employee_id, $p_school, $p_degree, $p_field_of_study, $p_start_month, $p_start_year, $p_end_month, $p_end_year, $p_activities_societies, $p_education_description, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertEmployeeEducation(:p_employee_id, :p_school, :p_degree, :p_field_of_study, :p_start_month, :p_start_year, :p_end_month, :p_end_year, :p_activities_societies, :p_education_description, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_school', $p_school, PDO::PARAM_STR);
        $stmt->bindValue(':p_degree', $p_degree, PDO::PARAM_STR);
        $stmt->bindValue(':p_field_of_study', $p_field_of_study, PDO::PARAM_STR);
        $stmt->bindValue(':p_start_month', $p_start_month, PDO::PARAM_STR);
        $stmt->bindValue(':p_start_year', $p_start_year, PDO::PARAM_STR);
        $stmt->bindValue(':p_end_month', $p_end_month, PDO::PARAM_STR);
        $stmt->bindValue(':p_end_year', $p_end_year, PDO::PARAM_STR);
        $stmt->bindValue(':p_activities_societies', $p_activities_societies, PDO::PARAM_STR);
        $stmt->bindValue(':p_education_description', $p_education_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertEmployeeAddress
    # Description: Updates the employee address.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    # - $p_address_type_id (int): The address type ID.
    # - $p_address_type_name (string): The address type name.
    # - $p_address (string): The address.
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
    public function insertEmployeeAddress($p_employee_id, $p_address_type_id, $p_address_type_name, $p_address, $p_city_id, $p_city_name, $p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertEmployeeAddress(:p_employee_id, :p_address_type_id, :p_address_type_name, :p_address, :p_city_id, :p_city_name, :p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_address_type_id', $p_address_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_address_type_name', $p_address_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_address', $p_address, PDO::PARAM_STR);
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
    #
    # Function: insertEmployeeBankAccount
    # Description: Inserts the employee bank account.
    #
    # Parameters:
    # - $p_employee_id (int): The employee ID.
    # - $p_bank_id (int): The bank ID.
    # - $p_bank_name (string): The bank name.
    # - $p_bank_account_type_id (int): The bank account type ID.
    # - $p_bank_account_type_name (string): The bank account type name.
    # - $p_account_number (string): The account number.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertEmployeeBankAccount($p_employee_id, $p_bank_id, $p_bank_name, $p_bank_account_type_id, $p_bank_account_type_name, $p_account_number, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertEmployeeBankAccount(:p_employee_id, :p_bank_id, :p_bank_name, :p_bank_account_type_id, :p_bank_account_type_name, :p_account_number, :p_last_log_by)');
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_id', $p_bank_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_name', $p_bank_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_bank_account_type_id', $p_bank_account_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_account_type_name', $p_bank_account_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_account_number', $p_account_number, PDO::PARAM_STR);
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
    #
    # Function: checkEmployeeExperienceExist
    # Description: Checks if a employee experience exists.
    #
    # Parameters:
    # - $p_employee_experience_id (int): The employee experience ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkEmployeeExperienceExist($p_employee_experience_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkEmployeeExperienceExist(:p_employee_experience_id)');
        $stmt->bindValue(':p_employee_experience_id', $p_employee_experience_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkEmployeeEducationExist
    # Description: Checks if a employee education exists.
    #
    # Parameters:
    # - $p_employee_education_id (int): The employee education ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkEmployeeEducationExist($p_employee_education_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkEmployeeEducationExist(:p_employee_education_id)');
        $stmt->bindValue(':p_employee_education_id', $p_employee_education_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkEmployeeAddressExist
    # Description: Checks if a employee address exists.
    #
    # Parameters:
    # - $p_employee_address_id (int): The employee address ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkEmployeeAddressExist($p_employee_address_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkEmployeeAddressExist(:p_employee_address_id)');
        $stmt->bindValue(':p_employee_address_id', $p_employee_address_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkEmployeeBankAccountExist
    # Description: Checks if a employee bank account exists.
    #
    # Parameters:
    # - $p_employee_bank_account_id (int): The employee bank account ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkEmployeeBankAccountExist($p_employee_bank_account_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkEmployeeBankAccountExist(:p_employee_bank_account_id)');
        $stmt->bindValue(':p_employee_bank_account_id', $p_employee_bank_account_id, PDO::PARAM_INT);
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
    #
    # Function: deleteEmployeeExperience
    # Description: Deletes the employee experience.
    #
    # Parameters:
    # - $p_employee_experience_id (int): The employee experience ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteEmployeeExperience($p_employee_experience_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteEmployeeExperience(:p_employee_experience_id)');
        $stmt->bindValue(':p_employee_experience_id', $p_employee_experience_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteEmployeeEducation
    # Description: Deletes the employee education.
    #
    # Parameters:
    # - $p_employee_education_id (int): The employee education ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteEmployeeEducation($p_employee_education_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteEmployeeEducation(:p_employee_education_id)');
        $stmt->bindValue(':p_employee_education_id', $p_employee_education_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteEmployeeAddress
    # Description: Deletes the employee address.
    #
    # Parameters:
    # - $p_employee_address_id (int): The employee address ID.
    # - $p_employee_id (int): The employee ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteEmployeeAddress($p_employee_address_id, $p_employee_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteEmployeeAddress(:p_employee_address_id, :p_employee_id)');
        $stmt->bindValue(':p_employee_address_id', $p_employee_address_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_employee_id', $p_employee_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteEmployeeBankAccount
    # Description: Deletes the employee bank account.
    #
    # Parameters:
    # - $p_employee_bank_account_id (int): The employee bank account ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteEmployeeBankAccount($p_employee_bank_account_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteEmployeeBankAccount(:p_employee_bank_account_id)');
        $stmt->bindValue(':p_employee_bank_account_id', $p_employee_bank_account_id, PDO::PARAM_INT);
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
    #
    # Function: getEmployeeExperience
    # Description: Retrieves the details of a employee experience.
    #
    # Parameters:
    # - $p_employee_experience_id (int): The employee experience ID.
    #
    # Returns:
    # - An array containing the employee experience details.
    #
    # -------------------------------------------------------------
    public function getEmployeeExperience($p_employee_experience_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getEmployeeExperience(:p_employee_experience_id)');
        $stmt->bindValue(':p_employee_experience_id', $p_employee_experience_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getEmployeeEducation
    # Description: Retrieves the details of a employee education.
    #
    # Parameters:
    # - $p_employee_education_id (int): The employee education ID.
    #
    # Returns:
    # - An array containing the employee education details.
    #
    # -------------------------------------------------------------
    public function getEmployeeEducation($p_employee_education_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getEmployeeEducation(:p_employee_education_id)');
        $stmt->bindValue(':p_employee_education_id', $p_employee_education_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getEmployeeAddress
    # Description: Retrieves the details of a employee address.
    #
    # Parameters:
    # - $p_employee_address_id (int): The employee address ID.
    #
    # Returns:
    # - An array containing the employee address details.
    #
    # -------------------------------------------------------------
    public function getEmployeeAddress($p_employee_address_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getEmployeeAddress(:p_employee_address_id)');
        $stmt->bindValue(':p_employee_address_id', $p_employee_address_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getEmployeeBankAccount
    # Description: Retrieves the details of a employee bank account.
    #
    # Parameters:
    # - $p_employee_bank_account_id (int): The employee bank account ID.
    #
    # Returns:
    # - An array containing the employee bank account details.
    #
    # -------------------------------------------------------------
    public function getEmployeeBankAccount($p_employee_bank_account_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getEmployeeBankAccount(:p_employee_bank_account_id)');
        $stmt->bindValue(':p_employee_bank_account_id', $p_employee_bank_account_id, PDO::PARAM_INT);
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