<?php
/**
* Class ScheduleTypeModel
*
* The ScheduleTypeModel class handles schedule type related operations and interactions.
*/
class ScheduleTypeModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateScheduleType
    # Description: Updates the schedule type.
    #
    # Parameters:
    # - $p_schedule_type_id (int): The schedule type ID.
    # - $p_schedule_type_name (string): The schedule type name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateScheduleType($p_schedule_type_id, $p_schedule_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateScheduleType(:p_schedule_type_id, :p_schedule_type_name, :p_last_log_by)');
        $stmt->bindValue(':p_schedule_type_id', $p_schedule_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_schedule_type_name', $p_schedule_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertScheduleType
    # Description: Inserts the schedule type.
    #
    # Parameters:
    # - $p_schedule_type_name (string): The schedule type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertScheduleType($p_schedule_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertScheduleType(:p_schedule_type_name, :p_last_log_by, @p_schedule_type_id)');
        $stmt->bindValue(':p_schedule_type_name', $p_schedule_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_schedule_type_id AS schedule_type_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['schedule_type_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkScheduleTypeExist
    # Description: Checks if a schedule type exists.
    #
    # Parameters:
    # - $p_schedule_type_id (int): The schedule type ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkScheduleTypeExist($p_schedule_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkScheduleTypeExist(:p_schedule_type_id)');
        $stmt->bindValue(':p_schedule_type_id', $p_schedule_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteScheduleType
    # Description: Deletes the schedule type.
    #
    # Parameters:
    # - $p_schedule_type_id (int): The schedule type ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteScheduleType($p_schedule_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteScheduleType(:p_schedule_type_id)');
        $stmt->bindValue(':p_schedule_type_id', $p_schedule_type_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getScheduleType
    # Description: Retrieves the details of a schedule type.
    #
    # Parameters:
    # - $p_schedule_type_id (int): The schedule type ID.
    #
    # Returns:
    # - An array containing the schedule type details.
    #
    # -------------------------------------------------------------
    public function getScheduleType($p_schedule_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getScheduleType(:p_schedule_type_id)');
        $stmt->bindValue(':p_schedule_type_id', $p_schedule_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateScheduleTypeOptions
    # Description: Generates the schedule type options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateScheduleTypeOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateScheduleTypeOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $scheduleTypeID = $row['schedule_type_id'];
            $scheduleTypeName = $row['schedule_type_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($scheduleTypeID, ENT_QUOTES) . '">' . htmlspecialchars($scheduleTypeName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>