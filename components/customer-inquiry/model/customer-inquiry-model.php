<?php
/**
* Class ServicesBoxModel
*
* The ServicesBoxModel class handles customer inquiry related operations and interactions.
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
    # Description: Updates the customer inquiry.
    #
    # Parameters:
    # - $p_customer_inquiry_id (int): The carousel ID.
    # - $p_customer_inquiry_name (string): The carousel name.
    # - $p_description (string): The carousel description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateServicesBox($p_customer_inquiry_id, $p_customer_inquiry_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateServicesBox(:p_customer_inquiry_id, :p_customer_inquiry_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_inquiry_name', $p_customer_inquiry_name, PDO::PARAM_STR);
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
    # Description: Updates the customer inquiry item.
    #
    # Parameters:
    # - $p_customer_inquiry_item_id (int): The carousel item ID.
    # - $p_customer_inquiry_id (int): The carousel ID.
    # - $p_customer_inquiry_title (string): The carousel title.
    # - $p_customer_inquiry_heading (string): The carousel heading.
    # - $p_customer_inquiry_paragraph (string): The carousel paragraph.
    # - $p_call_to_action_button_text (string): The call-to-action button text.
    # - $p_call_to_action_button_link (string): The call-to-action button link.
    # - $p_customer_inquiry_image (string): The customer inquiry image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateServicesBoxItem($p_customer_inquiry_item_id, $p_customer_inquiry_id, $p_customer_inquiry_title, $p_customer_inquiry_heading, $p_customer_inquiry_paragraph, $p_call_to_action_button_text, $p_call_to_action_button_link, $p_customer_inquiry_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateServicesBoxItem(:p_customer_inquiry_item_id, :p_customer_inquiry_id, :p_customer_inquiry_title, :p_customer_inquiry_heading, :p_customer_inquiry_paragraph, :p_call_to_action_button_text, :p_call_to_action_button_link, :p_customer_inquiry_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_customer_inquiry_item_id', $p_customer_inquiry_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_inquiry_title', $p_customer_inquiry_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_customer_inquiry_heading', $p_customer_inquiry_heading, PDO::PARAM_STR);
        $stmt->bindValue(':p_customer_inquiry_paragraph', $p_customer_inquiry_paragraph, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_text', $p_call_to_action_button_text, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_link', $p_call_to_action_button_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_customer_inquiry_image', $p_customer_inquiry_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateServicesBoxPublishStatus
    # Description: Updates the customer inquiry publish status.
    #
    # Parameters:
    # - $p_customer_inquiry_id (int): The customer inquiry ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateServicesBoxPublishStatus($p_customer_inquiry_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateServicesBoxPublishStatus(:p_customer_inquiry_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
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
    # Description: Inserts the customer inquiry.
    #
    # Parameters:
    # - $p_customer_inquiry_name (string): The customer inquiry name.
    # - $p_description (string): The customer inquiry description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertServicesBox($p_customer_inquiry_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertServicesBox(:p_customer_inquiry_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_customer_inquiry_id)');
        $stmt->bindValue(':p_customer_inquiry_name', $p_customer_inquiry_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_customer_inquiry_id AS customer_inquiry_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['customer_inquiry_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertServicesBoxItem
    # Description: Inserts the customer inquiry item.
    #
    # Parameters:
    # - $p_customer_inquiry_id (int): The carousel ID.
    # - $p_customer_inquiry_title (string): The carousel title.
    # - $p_customer_inquiry_heading (string): The carousel heading.
    # - $p_customer_inquiry_paragraph (string): The carousel paragraph.
    # - $p_call_to_action_button_text (string): The call-to-action button text.
    # - $p_call_to_action_button_link (string): The call-to-action button link.
    # - $p_customer_inquiry_image (string): The customer inquiry image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertServicesBoxItem($p_customer_inquiry_id, $p_customer_inquiry_title, $p_customer_inquiry_heading, $p_customer_inquiry_paragraph, $p_call_to_action_button_text, $p_call_to_action_button_link, $p_customer_inquiry_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertServicesBoxItem(:p_customer_inquiry_id, :p_customer_inquiry_title, :p_customer_inquiry_heading, :p_customer_inquiry_paragraph, :p_call_to_action_button_text, :p_call_to_action_button_link, :p_customer_inquiry_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_inquiry_title', $p_customer_inquiry_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_customer_inquiry_heading', $p_customer_inquiry_heading, PDO::PARAM_STR);
        $stmt->bindValue(':p_customer_inquiry_paragraph', $p_customer_inquiry_paragraph, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_text', $p_call_to_action_button_text, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_link', $p_call_to_action_button_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_customer_inquiry_image', $p_customer_inquiry_image, PDO::PARAM_STR);
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
    # Description: Checks if a customer inquiry exists.
    #
    # Parameters:
    # - $p_customer_inquiry_id (int): The customer inquiry ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkServicesBoxExist($p_customer_inquiry_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkServicesBoxExist(:p_customer_inquiry_id)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkServicesBoxItemExist
    # Description: Checks if a customer inquiry item exists.
    #
    # Parameters:
    # - $p_customer_inquiry_item_id (int): The customer inquiry item ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkServicesBoxItemExist($p_customer_inquiry_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkServicesBoxItemExist(:p_customer_inquiry_item_id)');
        $stmt->bindValue(':p_customer_inquiry_item_id', $p_customer_inquiry_item_id, PDO::PARAM_INT);
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
    # Description: Deletes the customer inquiry.
    #
    # Parameters:
    # - $p_customer_inquiry_id (int): The customer inquiry ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteServicesBox($p_customer_inquiry_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteServicesBox(:p_customer_inquiry_id)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteServicesBoxItem
    # Description: Deletes the customer inquiry item.
    #
    # Parameters:
    # - $p_customer_inquiry_item_id (int): The customer inquiry item ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteServicesBoxItem($p_customer_inquiry_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteServicesBoxItem(:p_customer_inquiry_item_id)');
        $stmt->bindValue(':p_customer_inquiry_item_id', $p_customer_inquiry_item_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getServicesBox
    # Description: Retrieves the details of a customer inquiry.
    #
    # Parameters:
    # - $p_customer_inquiry_id (int): The customer inquiry ID.
    #
    # Returns:
    # - An array containing the customer inquiry details.
    #
    # -------------------------------------------------------------
    public function getServicesBox($p_customer_inquiry_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getServicesBox(:p_customer_inquiry_id)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getServicesBoxItem
    # Description: Retrieves the details of a customer inquiry item.
    #
    # Parameters:
    # - $p_customer_inquiry_item_id (int): The customer inquiry ID.
    #
    # Returns:
    # - An array containing the customer inquiry details.
    #
    # -------------------------------------------------------------
    public function getServicesBoxItem($p_customer_inquiry_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getServicesBoxItem(:p_customer_inquiry_item_id)');
        $stmt->bindValue(':p_customer_inquiry_item_id', $p_customer_inquiry_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getServicesBoxItemByServicesBoxID
    # Description: Retrieves the details of a customer inquiry item.
    #
    # Parameters:
    # - $p_customer_inquiry_id (int): The customer inquiry ID.
    #
    # Returns:
    # - An array containing the customer inquiry details.
    #
    # -------------------------------------------------------------
    public function getServicesBoxItemByServicesBoxID($p_customer_inquiry_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getServicesBoxItemByServicesBoxID(:p_customer_inquiry_id)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
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
    # Description: Generates the customer inquiry options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateServicesBoxOptions($p_customer_inquiry_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateServicesBoxOptions(:p_customer_inquiry_id)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $servicesBoxID = $row['customer_inquiry_id'];
            $servicesBoxName = $row['customer_inquiry_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($servicesBoxID, ENT_QUOTES) . '">' . htmlspecialchars($servicesBoxName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>