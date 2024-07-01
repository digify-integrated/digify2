<?php
/**
* Class JobPositionModel
*
* The JobPositionModel class handles job position related operations and interactions.
*/
class JobPositionModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateJobPosition
    # Description: Updates the job position.
    #
    # Parameters:
    # - $p_job_position_id (int): The job position ID.
    # - $p_job_position_name (string): The job position name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateJobPosition($p_job_position_id, $p_job_position_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateJobPosition(:p_job_position_id, :p_job_position_name, :p_last_log_by)');
        $stmt->bindValue(':p_job_position_id', $p_job_position_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_job_position_name', $p_job_position_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertJobPosition
    # Description: Inserts the job position.
    #
    # Parameters:
    # - $p_job_position_name (string): The job position name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertJobPosition($p_job_position_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertJobPosition(:p_job_position_name, :p_last_log_by, @p_job_position_id)');
        $stmt->bindValue(':p_job_position_name', $p_job_position_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_job_position_id AS job_position_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['job_position_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkJobPositionExist
    # Description: Checks if a job position exists.
    #
    # Parameters:
    # - $p_job_position_id (int): The job position ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkJobPositionExist($p_job_position_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkJobPositionExist(:p_job_position_id)');
        $stmt->bindValue(':p_job_position_id', $p_job_position_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteJobPosition
    # Description: Deletes the job position.
    #
    # Parameters:
    # - $p_job_position_id (int): The job position ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteJobPosition($p_job_position_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteJobPosition(:p_job_position_id)');
        $stmt->bindValue(':p_job_position_id', $p_job_position_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getJobPosition
    # Description: Retrieves the details of a job position.
    #
    # Parameters:
    # - $p_job_position_id (int): The job position ID.
    #
    # Returns:
    # - An array containing the job position details.
    #
    # -------------------------------------------------------------
    public function getJobPosition($p_job_position_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getJobPosition(:p_job_position_id)');
        $stmt->bindValue(':p_job_position_id', $p_job_position_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateJobPositionOptions
    # Description: Generates the job position options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateJobPositionOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateJobPositionOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $jobPositionID = $row['job_position_id'];
            $jobPositionName = $row['job_position_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($jobPositionID, ENT_QUOTES) . '">' . htmlspecialchars($jobPositionName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>