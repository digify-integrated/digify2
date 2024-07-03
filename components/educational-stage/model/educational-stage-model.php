<?php
/**
* Class EducationalStageModel
*
* The EducationalStageModel class handles educational stage related operations and interactions.
*/
class EducationalStageModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateEducationalStage
    # Description: Updates the educational stage.
    #
    # Parameters:
    # - $p_educational_stage_id (int): The educational stage ID.
    # - $p_educational_stage_name (string): The educational stage name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateEducationalStage($p_educational_stage_id, $p_educational_stage_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateEducationalStage(:p_educational_stage_id, :p_educational_stage_name, :p_last_log_by)');
        $stmt->bindValue(':p_educational_stage_id', $p_educational_stage_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_educational_stage_name', $p_educational_stage_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertEducationalStage
    # Description: Inserts the educational stage.
    #
    # Parameters:
    # - $p_educational_stage_name (string): The educational stage name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertEducationalStage($p_educational_stage_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertEducationalStage(:p_educational_stage_name, :p_last_log_by, @p_educational_stage_id)');
        $stmt->bindValue(':p_educational_stage_name', $p_educational_stage_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_educational_stage_id AS educational_stage_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['educational_stage_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkEducationalStageExist
    # Description: Checks if a educational stage exists.
    #
    # Parameters:
    # - $p_educational_stage_id (int): The educational stage ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkEducationalStageExist($p_educational_stage_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkEducationalStageExist(:p_educational_stage_id)');
        $stmt->bindValue(':p_educational_stage_id', $p_educational_stage_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteEducationalStage
    # Description: Deletes the educational stage.
    #
    # Parameters:
    # - $p_educational_stage_id (int): The educational stage ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteEducationalStage($p_educational_stage_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteEducationalStage(:p_educational_stage_id)');
        $stmt->bindValue(':p_educational_stage_id', $p_educational_stage_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getEducationalStage
    # Description: Retrieves the details of a educational stage.
    #
    # Parameters:
    # - $p_educational_stage_id (int): The educational stage ID.
    #
    # Returns:
    # - An array containing the educational stage details.
    #
    # -------------------------------------------------------------
    public function getEducationalStage($p_educational_stage_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getEducationalStage(:p_educational_stage_id)');
        $stmt->bindValue(':p_educational_stage_id', $p_educational_stage_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateEducationalStageOptions
    # Description: Generates the educational stage options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateEducationalStageOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateEducationalStageOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $educationalStageID = $row['educational_stage_id'];
            $educationalStageName = $row['educational_stage_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($educationalStageID, ENT_QUOTES) . '">' . htmlspecialchars($educationalStageName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>