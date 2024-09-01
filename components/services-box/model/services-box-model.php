<?php
/**
* Class ServicesBoxModel
*
* The ServicesBoxModel class handles services box related operations and interactions.
*/
class ServicesBoxModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateServicesBox
    # Description: Updates the services box.
    #
    # Parameters:
    # - $p_services_box_id (int): The carousel ID.
    # - $p_services_box_name (string): The carousel name.
    # - $p_description (string): The carousel description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateServicesBox($p_services_box_id, $p_services_box_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateServicesBox(:p_services_box_id, :p_services_box_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_services_box_id', $p_services_box_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_services_box_name', $p_services_box_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateServicesBoxItem
    # Description: Updates the services box item.
    #
    # Parameters:
    # - $p_services_box_item_id (int): The carousel item ID.
    # - $p_services_box_id (int): The carousel ID.
    # - $p_services_box_title (string): The carousel title.
    # - $p_services_box_heading (string): The carousel heading.
    # - $p_services_box_paragraph (string): The carousel paragraph.
    # - $p_call_to_action_button_text (string): The call-to-action button text.
    # - $p_call_to_action_button_link (string): The call-to-action button link.
    # - $p_services_box_image (string): The services box image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateServicesBoxItem($p_services_box_item_id, $p_services_box_id, $p_services_box_title, $p_services_box_heading, $p_services_box_paragraph, $p_call_to_action_button_text, $p_call_to_action_button_link, $p_services_box_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateServicesBoxItem(:p_services_box_item_id, :p_services_box_id, :p_services_box_title, :p_services_box_heading, :p_services_box_paragraph, :p_call_to_action_button_text, :p_call_to_action_button_link, :p_services_box_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_services_box_item_id', $p_services_box_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_services_box_id', $p_services_box_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_services_box_title', $p_services_box_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_services_box_heading', $p_services_box_heading, PDO::PARAM_STR);
        $stmt->bindValue(':p_services_box_paragraph', $p_services_box_paragraph, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_text', $p_call_to_action_button_text, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_link', $p_call_to_action_button_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_services_box_image', $p_services_box_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateServicesBoxPublishStatus
    # Description: Updates the services box publish status.
    #
    # Parameters:
    # - $p_services_box_id (int): The services box ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateServicesBoxPublishStatus($p_services_box_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateServicesBoxPublishStatus(:p_services_box_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_services_box_id', $p_services_box_id, PDO::PARAM_INT);
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
    # Function: insertServicesBox
    # Description: Inserts the services box.
    #
    # Parameters:
    # - $p_services_box_name (string): The services box name.
    # - $p_description (string): The services box description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertServicesBox($p_services_box_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertServicesBox(:p_services_box_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_services_box_id)');
        $stmt->bindValue(':p_services_box_name', $p_services_box_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_services_box_id AS services_box_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['services_box_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertServicesBoxItem
    # Description: Inserts the services box item.
    #
    # Parameters:
    # - $p_services_box_id (int): The carousel ID.
    # - $p_services_box_title (string): The carousel title.
    # - $p_services_box_heading (string): The carousel heading.
    # - $p_services_box_paragraph (string): The carousel paragraph.
    # - $p_call_to_action_button_text (string): The call-to-action button text.
    # - $p_call_to_action_button_link (string): The call-to-action button link.
    # - $p_services_box_image (string): The services box image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertServicesBoxItem($p_services_box_id, $p_services_box_title, $p_services_box_heading, $p_services_box_paragraph, $p_call_to_action_button_text, $p_call_to_action_button_link, $p_services_box_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertServicesBoxItem(:p_services_box_id, :p_services_box_title, :p_services_box_heading, :p_services_box_paragraph, :p_call_to_action_button_text, :p_call_to_action_button_link, :p_services_box_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_services_box_id', $p_services_box_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_services_box_title', $p_services_box_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_services_box_heading', $p_services_box_heading, PDO::PARAM_STR);
        $stmt->bindValue(':p_services_box_paragraph', $p_services_box_paragraph, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_text', $p_call_to_action_button_text, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_link', $p_call_to_action_button_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_services_box_image', $p_services_box_image, PDO::PARAM_STR);
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
    # Function: checkServicesBoxExist
    # Description: Checks if a services box exists.
    #
    # Parameters:
    # - $p_services_box_id (int): The services box ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkServicesBoxExist($p_services_box_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkServicesBoxExist(:p_services_box_id)');
        $stmt->bindValue(':p_services_box_id', $p_services_box_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkServicesBoxItemExist
    # Description: Checks if a services box item exists.
    #
    # Parameters:
    # - $p_services_box_item_id (int): The services box item ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkServicesBoxItemExist($p_services_box_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkServicesBoxItemExist(:p_services_box_item_id)');
        $stmt->bindValue(':p_services_box_item_id', $p_services_box_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteServicesBox
    # Description: Deletes the services box.
    #
    # Parameters:
    # - $p_services_box_id (int): The services box ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteServicesBox($p_services_box_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteServicesBox(:p_services_box_id)');
        $stmt->bindValue(':p_services_box_id', $p_services_box_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteServicesBoxItem
    # Description: Deletes the services box item.
    #
    # Parameters:
    # - $p_services_box_item_id (int): The services box item ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteServicesBoxItem($p_services_box_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteServicesBoxItem(:p_services_box_item_id)');
        $stmt->bindValue(':p_services_box_item_id', $p_services_box_item_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getServicesBox
    # Description: Retrieves the details of a services box.
    #
    # Parameters:
    # - $p_services_box_id (int): The services box ID.
    #
    # Returns:
    # - An array containing the services box details.
    #
    # -------------------------------------------------------------
    public function getServicesBox($p_services_box_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getServicesBox(:p_services_box_id)');
        $stmt->bindValue(':p_services_box_id', $p_services_box_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getServicesBoxItem
    # Description: Retrieves the details of a services box item.
    #
    # Parameters:
    # - $p_services_box_item_id (int): The services box ID.
    #
    # Returns:
    # - An array containing the services box details.
    #
    # -------------------------------------------------------------
    public function getServicesBoxItem($p_services_box_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getServicesBoxItem(:p_services_box_item_id)');
        $stmt->bindValue(':p_services_box_item_id', $p_services_box_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getServicesBoxItemByServicesBoxID
    # Description: Retrieves the details of a services box item.
    #
    # Parameters:
    # - $p_services_box_id (int): The services box ID.
    #
    # Returns:
    # - An array containing the services box details.
    #
    # -------------------------------------------------------------
    public function getServicesBoxItemByServicesBoxID($p_services_box_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getServicesBoxItemByServicesBoxID(:p_services_box_id)');
        $stmt->bindValue(':p_services_box_id', $p_services_box_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateServicesBoxOptions
    # Description: Generates the services box options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateServicesBoxOptions($p_services_box_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateServicesBoxOptions(:p_services_box_id)');
        $stmt->bindValue(':p_services_box_id', $p_services_box_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $servicesBoxID = $row['services_box_id'];
            $servicesBoxName = $row['services_box_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($servicesBoxID, ENT_QUOTES) . '">' . htmlspecialchars($servicesBoxName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>