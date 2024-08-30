<?php
/**
* Class ContentCarouselModel
*
* The ContentCarouselModel class handles content carousel related operations and interactions.
*/
class ContentCarouselModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateContentCarousel
    # Description: Updates the content carousel.
    #
    # Parameters:
    # - $p_content_carousel_id (int): The carousel ID.
    # - $p_content_carousel_name (string): The carousel name.
    # - $p_description (string): The carousel description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateContentCarousel($p_content_carousel_id, $p_content_carousel_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateContentCarousel(:p_content_carousel_id, :p_content_carousel_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_content_carousel_id', $p_content_carousel_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_content_carousel_name', $p_content_carousel_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateContentCarouselItem
    # Description: Updates the content carousel item.
    #
    # Parameters:
    # - $p_content_carousel_item_id (int): The carousel item ID.
    # - $p_content_carousel_id (int): The carousel ID.
    # - $p_content_carousel_title (string): The carousel title.
    # - $p_content_carousel_heading (string): The carousel heading.
    # - $p_content_carousel_paragraph (string): The carousel paragraph.
    # - $p_call_to_action_button_1_text (string): The call-to-action button 1 text.
    # - $p_call_to_action_button_1_link (string): The call-to-action button 1 link.
    # - $p_call_to_action_button_2_text (string): The call-to-action button 2 text.
    # - $p_call_to_action_button_2_link (string): The call-to-action button 2 link.
    # - $p_content_carousel_image (string): The content carousel image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateContentCarouselItem($p_content_carousel_item_id, $p_content_carousel_id, $p_content_carousel_title, $p_content_carousel_heading, $p_content_carousel_paragraph, $p_call_to_action_button_1_text, $p_call_to_action_button_1_link, $p_call_to_action_button_2_text, $p_call_to_action_button_2_link, $p_content_carousel_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateContentCarouselItem(:p_content_carousel_item_id, :p_content_carousel_id, :p_content_carousel_title, :p_content_carousel_heading, :p_content_carousel_paragraph, :p_call_to_action_button_1_text, :p_call_to_action_button_1_link, :p_call_to_action_button_2_text, :p_call_to_action_button_2_link, :p_content_carousel_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_content_carousel_item_id', $p_content_carousel_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_content_carousel_id', $p_content_carousel_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_content_carousel_title', $p_content_carousel_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_content_carousel_heading', $p_content_carousel_heading, PDO::PARAM_STR);
        $stmt->bindValue(':p_content_carousel_paragraph', $p_content_carousel_paragraph, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_1_text', $p_call_to_action_button_1_text, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_1_link', $p_call_to_action_button_1_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_2_text', $p_call_to_action_button_2_text, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_2_link', $p_call_to_action_button_2_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_content_carousel_image', $p_content_carousel_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateContentCarouselPublishStatus
    # Description: Updates the content carousel publish status.
    #
    # Parameters:
    # - $p_content_carousel_id (int): The content carousel ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateContentCarouselPublishStatus($p_content_carousel_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateContentCarouselPublishStatus(:p_content_carousel_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_content_carousel_id', $p_content_carousel_id, PDO::PARAM_INT);
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
    # Function: insertContentCarousel
    # Description: Inserts the content carousel.
    #
    # Parameters:
    # - $p_content_carousel_name (string): The content carousel name.
    # - $p_description (string): The content carousel description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertContentCarousel($p_content_carousel_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertContentCarousel(:p_content_carousel_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_content_carousel_id)');
        $stmt->bindValue(':p_content_carousel_name', $p_content_carousel_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_content_carousel_id AS content_carousel_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['content_carousel_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertContentCarouselItem
    # Description: Inserts the content carousel item.
    #
    # Parameters:
    # - $p_content_carousel_id (int): The carousel ID.
    # - $p_content_carousel_title (string): The carousel title.
    # - $p_content_carousel_heading (string): The carousel heading.
    # - $p_content_carousel_paragraph (string): The carousel paragraph.
    # - $p_call_to_action_button_1_text (string): The call-to-action button 1 text.
    # - $p_call_to_action_button_1_link (string): The call-to-action button 1 link.
    # - $p_call_to_action_button_2_text (string): The call-to-action button 2 text.
    # - $p_call_to_action_button_2_link (string): The call-to-action button 2 link.
    # - $p_content_carousel_image (string): The content carousel image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertContentCarouselItem($p_content_carousel_id, $p_content_carousel_title, $p_content_carousel_heading, $p_content_carousel_paragraph, $p_call_to_action_button_1_text, $p_call_to_action_button_1_link, $p_call_to_action_button_2_text, $p_call_to_action_button_2_link, $p_content_carousel_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertContentCarouselItem(:p_content_carousel_id, :p_content_carousel_title, :p_content_carousel_heading, :p_content_carousel_paragraph, :p_call_to_action_button_1_text, :p_call_to_action_button_1_link, :p_call_to_action_button_2_text, :p_call_to_action_button_2_link, :p_content_carousel_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_content_carousel_id', $p_content_carousel_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_content_carousel_title', $p_content_carousel_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_content_carousel_heading', $p_content_carousel_heading, PDO::PARAM_STR);
        $stmt->bindValue(':p_content_carousel_paragraph', $p_content_carousel_paragraph, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_1_text', $p_call_to_action_button_1_text, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_1_link', $p_call_to_action_button_1_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_2_text', $p_call_to_action_button_2_text, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_2_link', $p_call_to_action_button_2_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_content_carousel_image', $p_content_carousel_image, PDO::PARAM_STR);
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
    # Function: checkContentCarouselExist
    # Description: Checks if a content carousel exists.
    #
    # Parameters:
    # - $p_content_carousel_id (int): The content carousel ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkContentCarouselExist($p_content_carousel_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkContentCarouselExist(:p_content_carousel_id)');
        $stmt->bindValue(':p_content_carousel_id', $p_content_carousel_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkContentCarouselItemExist
    # Description: Checks if a content carousel item exists.
    #
    # Parameters:
    # - $p_content_carousel_item_id (int): The content carousel item ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkContentCarouselItemExist($p_content_carousel_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkContentCarouselItemExist(:p_content_carousel_item_id)');
        $stmt->bindValue(':p_content_carousel_item_id', $p_content_carousel_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteContentCarousel
    # Description: Deletes the content carousel.
    #
    # Parameters:
    # - $p_content_carousel_id (int): The content carousel ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteContentCarousel($p_content_carousel_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteContentCarousel(:p_content_carousel_id)');
        $stmt->bindValue(':p_content_carousel_id', $p_content_carousel_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteContentCarouselItem
    # Description: Deletes the content carousel item.
    #
    # Parameters:
    # - $p_content_carousel_item_id (int): The content carousel item ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteContentCarouselItem($p_content_carousel_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteContentCarouselItem(:p_content_carousel_item_id)');
        $stmt->bindValue(':p_content_carousel_item_id', $p_content_carousel_item_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getContentCarousel
    # Description: Retrieves the details of a content carousel.
    #
    # Parameters:
    # - $p_content_carousel_id (int): The content carousel ID.
    #
    # Returns:
    # - An array containing the content carousel details.
    #
    # -------------------------------------------------------------
    public function getContentCarousel($p_content_carousel_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getContentCarousel(:p_content_carousel_id)');
        $stmt->bindValue(':p_content_carousel_id', $p_content_carousel_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getContentCarouselItem
    # Description: Retrieves the details of a content carousel item.
    #
    # Parameters:
    # - $p_content_carousel_item_id (int): The content carousel ID.
    #
    # Returns:
    # - An array containing the content carousel details.
    #
    # -------------------------------------------------------------
    public function getContentCarouselItem($p_content_carousel_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getContentCarouselItem(:p_content_carousel_item_id)');
        $stmt->bindValue(':p_content_carousel_item_id', $p_content_carousel_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getContentCarouselItemByContentCarouselID
    # Description: Retrieves the details of a content carousel item.
    #
    # Parameters:
    # - $p_content_carousel_id (int): The content carousel ID.
    #
    # Returns:
    # - An array containing the content carousel details.
    #
    # -------------------------------------------------------------
    public function getContentCarouselItemByContentCarouselID($p_content_carousel_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getContentCarouselItemByContentCarouselID(:p_content_carousel_id)');
        $stmt->bindValue(':p_content_carousel_id', $p_content_carousel_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateContentCarouselOptions
    # Description: Generates the content carousel options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateContentCarouselOptions($p_content_carousel_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateContentCarouselOptions(:p_content_carousel_id)');
        $stmt->bindValue(':p_content_carousel_id', $p_content_carousel_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $contentCarouselID = $row['content_carousel_id'];
            $contentCarouselName = $row['content_carousel_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($contentCarouselID, ENT_QUOTES) . '">' . htmlspecialchars($contentCarouselName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>