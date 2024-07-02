<?php
/**
* Class WorkScheduleModel
*
* The WorkScheduleModel class handles work schedule related operations and interactions.
*/
class WorkScheduleModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateWorkSchedule
    # Description: Updates the work schedule.
    #
    # Parameters:
    # - $p_work_schedule_id (int): The work schedule ID.
    # - $p_work_schedule_name (string): The work schedule name.
    # - $p_schedule_type_id (int): The schedule type ID.
    # - $p_schedule_type_name (string): The schedule type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateWorkSchedule($p_work_schedule_id, $p_work_schedule_name, $p_schedule_type_id, $p_schedule_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateWorkSchedule(:p_work_schedule_id, :p_work_schedule_name, :p_schedule_type_id, :p_schedule_type_name, :p_last_log_by)');
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
    # Description: Updates the work schedule.
    #
    # Parameters:
    # - $p_work_hours_id (int): The work hours ID.
    # - $p_work_schedule_id (int): The work schedule ID.
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
    # Function: insertWorkSchedule
    # Description: Inserts the work schedule.
    #
    # Parameters:
    # - $p_work_schedule_name (string): The work schedule name.
    # - $p_schedule_type_id (int): The schedule type ID.
    # - $p_schedule_type_name (string): The schedule type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertWorkSchedule($p_work_schedule_name, $p_schedule_type_id, $p_schedule_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertWorkSchedule(:p_work_schedule_name, :p_schedule_type_id, :p_schedule_type_name, :p_last_log_by, @p_work_schedule_id)');
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
    # Description: Inserts the work schedule.
    #
    # Parameters:
    # - $p_work_schedule_id (int): The work schedule ID.
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
    # - $p_work_schedule_id (int): The work schedule ID.
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
    # Function: checkWorkScheduleExist
    # Description: Checks if a work schedule exists.
    #
    # Parameters:
    # - $p_work_schedule_id (int): The work schedule ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkWorkScheduleExist($p_work_schedule_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkWorkScheduleExist(:p_work_schedule_id)');
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
    # Function: deleteWorkSchedule
    # Description: Deletes the work schedule.
    #
    # Parameters:
    # - $p_work_schedule_id (int): The work schedule ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteWorkSchedule($p_work_schedule_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteWorkSchedule(:p_work_schedule_id)');
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
    # Function: getWorkSchedule
    # Description: Retrieves the details of a work schedule.
    #
    # Parameters:
    # - $p_work_schedule_id (int): The work schedule ID.
    #
    # Returns:
    # - An array containing the work schedule details.
    #
    # -------------------------------------------------------------
    public function getWorkSchedule($p_work_schedule_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getWorkSchedule(:p_work_schedule_id)');
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