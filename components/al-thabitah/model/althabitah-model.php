<?php
/**
* Class AlthabitahModel
*
* The AlthabitahModel class handles althabitah related operations and interactions.
*/
class AlthabitahModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateAlthabitah
    # Description: Updates the althabitah.
    #
    # Parameters:
    # - $p_work_schedule_id (int): The althabitah ID.
    # - $p_work_schedule_name (string): The althabitah name.
    # - $p_schedule_type_id (int): The schedule type ID.
    # - $p_schedule_type_name (string): The schedule type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateAlthabitah($p_work_schedule_id, $p_work_schedule_name, $p_schedule_type_id, $p_schedule_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateAlthabitah(:p_work_schedule_id, :p_work_schedule_name, :p_schedule_type_id, :p_schedule_type_name, :p_last_log_by)');
        $stmt->bindValue(':p_work_schedule_id', $p_work_schedule_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_work_schedule_name', $p_work_schedule_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_schedule_type_id', $p_schedule_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_schedule_type_name', $p_schedule_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateWorkHours
    # Description: Updates the althabitah.
    #
    # Parameters:
    # - $p_work_hours_id (int): The work hours ID.
    # - $p_work_schedule_id (int): The althabitah ID.
    # - $p_day_of_week (string): The day of the week.
    # - $p_day_period (string): The day period.
    # - $p_start_time (time): The start time.
    # - $p_end_time (time): The end time.
    # - $p_notes (time): The notes/remarks.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateWorkHours($p_work_hours_id, $p_work_schedule_id, $p_day_of_week, $p_day_period, $p_start_time, $p_end_time, $p_notes, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateWorkHours(:p_work_hours_id, :p_work_schedule_id, :p_day_of_week, :p_day_period, :p_start_time, :p_end_time, :p_notes, :p_last_log_by)');
        $stmt->bindValue(':p_work_hours_id', $p_work_hours_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_work_schedule_id', $p_work_schedule_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_day_of_week', $p_day_of_week, PDO::PARAM_STR);
        $stmt->bindValue(':p_day_period', $p_day_period, PDO::PARAM_STR);
        $stmt->bindValue(':p_start_time', $p_start_time, PDO::PARAM_STR);
        $stmt->bindValue(':p_end_time', $p_end_time, PDO::PARAM_STR);
        $stmt->bindValue(':p_notes', $p_notes, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertAlthabitah
    # Description: Inserts the althabitah.
    #
    # Parameters:
    # - $p_work_schedule_name (string): The althabitah name.
    # - $p_schedule_type_id (int): The schedule type ID.
    # - $p_schedule_type_name (string): The schedule type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertAlthabitah($p_work_schedule_name, $p_schedule_type_id, $p_schedule_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertAlthabitah(:p_work_schedule_name, :p_schedule_type_id, :p_schedule_type_name, :p_last_log_by, @p_work_schedule_id)');
        $stmt->bindValue(':p_work_schedule_name', $p_work_schedule_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_schedule_type_id', $p_schedule_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_schedule_type_name', $p_schedule_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_work_schedule_id AS work_schedule_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['work_schedule_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------
    
    # -------------------------------------------------------------
    #
    # Function: insertWorkHours
    # Description: Inserts the althabitah.
    #
    # Parameters:
    # - $p_work_schedule_id (int): The althabitah ID.
    # - $p_day_of_week (string): The day of the week.
    # - $p_day_period (string): The day period.
    # - $p_start_time (time): The start time.
    # - $p_end_time (time): The end time.
    # - $p_notes (time): The notes/remarks.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertWorkHours($p_work_schedule_id, $p_day_of_week, $p_day_period, $p_start_time, $p_end_time, $p_notes, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertWorkHours(:p_work_schedule_id, :p_day_of_week, :p_day_period, :p_start_time, :p_end_time, :p_notes, :p_last_log_by)');
        $stmt->bindValue(':p_work_schedule_id', $p_work_schedule_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_day_of_week', $p_day_of_week, PDO::PARAM_STR);
        $stmt->bindValue(':p_day_period', $p_day_period, PDO::PARAM_STR);
        $stmt->bindValue(':p_start_time', $p_start_time, PDO::PARAM_STR);
        $stmt->bindValue(':p_end_time', $p_end_time, PDO::PARAM_STR);
        $stmt->bindValue(':p_notes', $p_notes, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkWorkHoursOverlap
    # Description: Checks if a work hours overlap.
    #
    # Parameters:
    # - $p_work_hours_id (int): The work hours ID.
    # - $p_work_schedule_id (int): The althabitah ID.
    # - $p_day_of_week (string): The day of the week.
    # - $p_day_period (string): The day period.
    # - $p_start_time (time): The start time.
    # - $p_end_time (time): The end time.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkWorkHoursOverlap($p_work_hours_id, $p_work_schedule_id, $p_day_of_week, $p_day_period, $p_start_time, $p_end_time) {
        $stmt = $this->db->getConnection()->prepare('CALL checkWorkHoursOverlap(:p_work_hours_id, :p_work_schedule_id, :p_day_of_week, :p_day_period, :p_start_time, :p_end_time)');
        $stmt->bindValue(':p_work_hours_id', $p_work_hours_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_work_schedule_id', $p_work_schedule_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_day_of_week', $p_day_of_week, PDO::PARAM_STR);
        $stmt->bindValue(':p_day_period', $p_day_period, PDO::PARAM_STR);
        $stmt->bindValue(':p_start_time', $p_start_time, PDO::PARAM_STR);
        $stmt->bindValue(':p_end_time', $p_end_time, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkAlthabitahExist
    # Description: Checks if a althabitah exists.
    #
    # Parameters:
    # - $p_work_schedule_id (int): The althabitah ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkAlthabitahExist($p_work_schedule_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkAlthabitahExist(:p_work_schedule_id)');
        $stmt->bindValue(':p_work_schedule_id', $p_work_schedule_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkWorkHoursExist
    # Description: Checks if a work hours exists.
    #
    # Parameters:
    # - $p_work_hours_id (int): The work hours ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkWorkHoursExist($p_work_hours_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkWorkHoursExist(:p_work_hours_id)');
        $stmt->bindValue(':p_work_hours_id', $p_work_hours_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteAlthabitah
    # Description: Deletes the althabitah.
    #
    # Parameters:
    # - $p_work_schedule_id (int): The althabitah ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteAlthabitah($p_work_schedule_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteAlthabitah(:p_work_schedule_id)');
        $stmt->bindValue(':p_work_schedule_id', $p_work_schedule_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteWorkHours
    # Description: Deletes the work hours.
    #
    # Parameters:
    # - $p_work_hours_id (int): The work hours ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteWorkHours($p_work_hours_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteWorkHours(:p_work_hours_id)');
        $stmt->bindValue(':p_work_hours_id', $p_work_hours_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getAlthabitah
    # Description: Retrieves the details of a althabitah.
    #
    # Parameters:
    # - $p_work_schedule_id (int): The althabitah ID.
    #
    # Returns:
    # - An array containing the althabitah details.
    #
    # -------------------------------------------------------------
    public function getAlthabitah($p_work_schedule_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getAlthabitah(:p_work_schedule_id)');
        $stmt->bindValue(':p_work_schedule_id', $p_work_schedule_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getWorkHours
    # Description: Retrieves the details of a work hours.
    #
    # Parameters:
    # - $p_work_hours_id (int): The work hours ID.
    #
    # Returns:
    # - An array containing the work hours details.
    #
    # -------------------------------------------------------------
    public function getWorkHours($p_work_hours_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getWorkHours(:p_work_hours_id)');
        $stmt->bindValue(':p_work_hours_id', $p_work_hours_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>