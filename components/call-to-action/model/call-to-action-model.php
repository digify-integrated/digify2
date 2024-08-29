<?php
/**
* Class CallToActionModel
*
* The CallToActionModel class handles call to action related operations and interactions.
*/
class CallToActionModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCallToAction
    # Description: Updates the call to action.
    #
    # Parameters:
    # - $p_call_to_action_id (int): The call to action ID.
    # - $p_call_to_action_name (string): The call to action name.
    # - $p_description (string): The call to action description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_call_to_action_header (string): The call to action header.
    # - $p_call_to_action_body (string): The call to action body.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCallToAction($p_call_to_action_id, $p_call_to_action_name, $p_description, $p_block_style_id, $p_block_style_name, $p_call_to_action_header, $p_call_to_action_body, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCallToAction(:p_call_to_action_id, :p_call_to_action_name, :p_description, :p_block_style_id, :p_block_style_name, :p_call_to_action_header, :p_call_to_action_body, :p_last_log_by)');
        $stmt->bindValue(':p_call_to_action_id', $p_call_to_action_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_call_to_action_name', $p_call_to_action_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_header', $p_call_to_action_header, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_body', $p_call_to_action_body, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCallToActionPublishStatus
    # Description: Updates the call to action publish status.
    #
    # Parameters:
    # - $p_call_to_action_item_id (int): The call to action item ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCallToActionPublishStatus($p_call_to_action_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCallToActionPublishStatus(:p_call_to_action_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_call_to_action_id', $p_call_to_action_id, PDO::PARAM_INT);
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
    # Function: insertCallToAction
    # Description: Inserts the call to action.
    #
    # Parameters:
    # - $p_call_to_action_name (string): The call to action name.
    # - $p_description (string): The call to action description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $call_to_action_header (string): The call to action header.
    # - $call_to_action_body (string): The call to action body.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertCallToAction($p_call_to_action_name, $p_description, $p_block_style_id, $p_block_style_name, $call_to_action_header, $call_to_action_body, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCallToAction(:p_call_to_action_name, :p_description, :p_block_style_id, :p_block_style_name, :call_to_action_header, :call_to_action_body, :p_last_log_by, @p_call_to_action_id)');
        $stmt->bindValue(':p_call_to_action_name', $p_call_to_action_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':call_to_action_header', $call_to_action_header, PDO::PARAM_STR);
        $stmt->bindValue(':call_to_action_body', $call_to_action_body, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_call_to_action_id AS call_to_action_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['call_to_action_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkCallToActionExist
    # Description: Checks if a call to action exists.
    #
    # Parameters:
    # - $p_call_to_action_id (int): The call to action ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCallToActionExist($p_call_to_action_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCallToActionExist(:p_call_to_action_id)');
        $stmt->bindValue(':p_call_to_action_id', $p_call_to_action_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCallToAction
    # Description: Deletes the call to action.
    #
    # Parameters:
    # - $p_call_to_action_id (int): The call to action ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCallToAction($p_call_to_action_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCallToAction(:p_call_to_action_id)');
        $stmt->bindValue(':p_call_to_action_id', $p_call_to_action_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCallToAction
    # Description: Retrieves the details of a call to action.
    #
    # Parameters:
    # - $p_call_to_action_id (int): The call to action ID.
    #
    # Returns:
    # - An array containing the call to action details.
    #
    # -------------------------------------------------------------
    public function getCallToAction($p_call_to_action_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCallToAction(:p_call_to_action_id)');
        $stmt->bindValue(':p_call_to_action_id', $p_call_to_action_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>