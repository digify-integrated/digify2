<?php
/**
* Class ProcesStepModel
*
* The ProcesStepModel class handles process step related operations and interactions.
*/
class ProcesStepModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateProcesStep
    # Description: Updates the process step.
    #
    # Parameters:
    # - $p_process_step_id (int): The process step ID.
    # - $p_process_step_name (string): The process step name.
    # - $p_description (string): The process step description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateProcesStep($p_process_step_id, $p_process_step_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateProcesStep(:p_process_step_id, :p_process_step_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_process_step_id', $p_process_step_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_process_step_name', $p_process_step_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateProcesStepItem
    # Description: Updates the process step item.
    #
    # Parameters:
    # - $p_process_step_item_id (int): The process step item ID.
    # - $p_process_step_id (int): The process step ID.
    # - $p_process_step_title (string): The process step title.
    # - $p_process_step_heading (string): The process step heading.
    # - $p_process_step_link (string): The process step link.
    # - $p_process_step_image (string): The process step image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateProcesStepItem($p_process_step_item_id, $p_process_step_id, $p_process_step_title, $p_process_step_heading, $p_process_step_link, $p_process_step_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateProcesStepItem(:p_process_step_item_id, :p_process_step_id, :p_process_step_title, :p_process_step_heading, :p_process_step_link, :p_process_step_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_process_step_item_id', $p_process_step_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_process_step_id', $p_process_step_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_process_step_title', $p_process_step_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_process_step_heading', $p_process_step_heading, PDO::PARAM_STR);
        $stmt->bindValue(':p_process_step_link', $p_process_step_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_process_step_image', $p_process_step_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateProcesStepPublishStatus
    # Description: Updates the process step publish status.
    #
    # Parameters:
    # - $p_process_step_id (int): The process step ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateProcesStepPublishStatus($p_process_step_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateProcesStepPublishStatus(:p_process_step_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_process_step_id', $p_process_step_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_publish_status', $p_publish_status, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertProcesStep
    # Description: Inserts the process step.
    #
    # Parameters:
    # - $p_process_step_name (string): The process step name.
    # - $p_description (string): The process step description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertProcesStep($p_process_step_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertProcesStep(:p_process_step_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_process_step_id)');
        $stmt->bindValue(':p_process_step_name', $p_process_step_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_process_step_id AS process_step_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['process_step_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertProcesStepItem
    # Description: Inserts the process step item.
    #
    # Parameters:
    # - $p_process_step_id (int): The process step ID.
    # - $p_process_step_title (string): The process step title.
    # - $p_process_step_heading (string): The process step heading.
    # - $p_process_step_link (string): The process step link.
    # - $p_process_step_image (string): The process step image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertProcesStepItem($p_process_step_id, $p_process_step_title, $p_process_step_heading, $p_process_step_link, $p_process_step_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertProcesStepItem(:p_process_step_id, :p_process_step_title, :p_process_step_heading, :p_process_step_link, :p_process_step_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_process_step_id', $p_process_step_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_process_step_title', $p_process_step_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_process_step_heading', $p_process_step_heading, PDO::PARAM_STR);
        $stmt->bindValue(':p_process_step_link', $p_process_step_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_process_step_image', $p_process_step_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkProcesStepExist
    # Description: Checks if a process step exists.
    #
    # Parameters:
    # - $p_process_step_id (int): The process step ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkProcesStepExist($p_process_step_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkProcesStepExist(:p_process_step_id)');
        $stmt->bindValue(':p_process_step_id', $p_process_step_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkProcesStepItemExist
    # Description: Checks if a process step item exists.
    #
    # Parameters:
    # - $p_process_step_item_id (int): The process step item ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkProcesStepItemExist($p_process_step_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkProcesStepItemExist(:p_process_step_item_id)');
        $stmt->bindValue(':p_process_step_item_id', $p_process_step_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteProcesStep
    # Description: Deletes the process step.
    #
    # Parameters:
    # - $p_process_step_id (int): The process step ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteProcesStep($p_process_step_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteProcesStep(:p_process_step_id)');
        $stmt->bindValue(':p_process_step_id', $p_process_step_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteProcesStepItem
    # Description: Deletes the process step item.
    #
    # Parameters:
    # - $p_process_step_item_id (int): The process step item ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteProcesStepItem($p_process_step_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteProcesStepItem(:p_process_step_item_id)');
        $stmt->bindValue(':p_process_step_item_id', $p_process_step_item_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getProcesStep
    # Description: Retrieves the details of a process step.
    #
    # Parameters:
    # - $p_process_step_id (int): The process step ID.
    #
    # Returns:
    # - An array containing the process step details.
    #
    # -------------------------------------------------------------
    public function getProcesStep($p_process_step_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getProcesStep(:p_process_step_id)');
        $stmt->bindValue(':p_process_step_id', $p_process_step_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getProcesStepItem
    # Description: Retrieves the details of a process step item.
    #
    # Parameters:
    # - $p_process_step_item_id (int): The process step ID.
    #
    # Returns:
    # - An array containing the process step details.
    #
    # -------------------------------------------------------------
    public function getProcesStepItem($p_process_step_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getProcesStepItem(:p_process_step_item_id)');
        $stmt->bindValue(':p_process_step_item_id', $p_process_step_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getProcesStepItemByProcesStepID
    # Description: Retrieves the details of a process step item.
    #
    # Parameters:
    # - $p_process_step_id (int): The process step ID.
    #
    # Returns:
    # - An array containing the process step details.
    #
    # -------------------------------------------------------------
    public function getProcesStepItemByProcesStepID($p_process_step_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getProcesStepItemByProcesStepID(:p_process_step_id)');
        $stmt->bindValue(':p_process_step_id', $p_process_step_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateProcesStepOptions
    # Description: Generates the process step options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateProcesStepOptions($p_process_step_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateProcesStepOptions(:p_process_step_id)');
        $stmt->bindValue(':p_process_step_id', $p_process_step_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $procesStepID = $row['process_step_id'];
            $procesStepName = $row['process_step_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($procesStepID, ENT_QUOTES) . '">' . htmlspecialchars($procesStepName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>