<?php
/**
* Class SliderModel
*
* The SliderModel class handles slider related operations and interactions.
*/
class SliderModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateSlider
    # Description: Updates the slider.
    #
    # Parameters:
    # - $p_slider_id (int): The slider ID.
    # - $p_slider_name (string): The slider name.
    # - $p_description (string): The slider description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateSlider($p_slider_id, $p_slider_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateSlider(:p_slider_id, :p_slider_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_slider_id', $p_slider_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_slider_name', $p_slider_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateSliderItem
    # Description: Updates the slider item.
    #
    # Parameters:
    # - $p_slider_item_id (int): The slider item ID.
    # - $p_slider_id (int): The slider ID.
    # - $p_slider_title (string): The slider title.
    # - $p_slider_heading (string): The slider heading.
    # - $p_slider_paragraph (string): The slider paragraph.
    # - $p_call_to_action_button_1_text (string): The call-to-action button 1 text.
    # - $p_call_to_action_button_1_link (string): The call-to-action button 1 link.
    # - $p_call_to_action_button_2_text (string): The call-to-action button 2 text.
    # - $p_call_to_action_button_2_link (string): The call-to-action button 2 link.
    # - $p_slider_image (string): The slider image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateSliderItem($p_slider_item_id, $p_slider_id, $p_slider_title, $p_slider_heading, $p_slider_paragraph, $p_call_to_action_button_1_text, $p_call_to_action_button_1_link, $p_call_to_action_button_2_text, $p_call_to_action_button_2_link, $p_slider_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateSliderItem(:p_slider_item_id, :p_slider_id, :p_slider_title, :p_slider_heading, :p_slider_paragraph, :p_call_to_action_button_1_text, :p_call_to_action_button_1_link, :p_call_to_action_button_2_text, :p_call_to_action_button_2_link, :p_slider_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_slider_item_id', $p_slider_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_slider_id', $p_slider_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_slider_title', $p_slider_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_slider_heading', $p_slider_heading, PDO::PARAM_STR);
        $stmt->bindValue(':p_slider_paragraph', $p_slider_paragraph, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_1_text', $p_call_to_action_button_1_text, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_1_link', $p_call_to_action_button_1_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_2_text', $p_call_to_action_button_2_text, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_2_link', $p_call_to_action_button_2_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_slider_image', $p_slider_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateSliderPublishStatus
    # Description: Updates the slider publish status.
    #
    # Parameters:
    # - $p_slider_id (int): The slider ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateSliderPublishStatus($p_slider_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateSliderPublishStatus(:p_slider_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_slider_id', $p_slider_id, PDO::PARAM_INT);
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
    # Function: insertSlider
    # Description: Inserts the slider.
    #
    # Parameters:
    # - $p_slider_name (string): The slider name.
    # - $p_description (string): The slider description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertSlider($p_slider_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertSlider(:p_slider_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_slider_id)');
        $stmt->bindValue(':p_slider_name', $p_slider_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_slider_id AS slider_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['slider_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertSliderItem
    # Description: Inserts the slider item.
    #
    # Parameters:
    # - $p_slider_id (int): The slider ID.
    # - $p_slider_title (string): The slider title.
    # - $p_slider_heading (string): The slider heading.
    # - $p_slider_paragraph (string): The slider paragraph.
    # - $p_call_to_action_button_1_text (string): The call-to-action button 1 text.
    # - $p_call_to_action_button_1_link (string): The call-to-action button 1 link.
    # - $p_call_to_action_button_2_text (string): The call-to-action button 2 text.
    # - $p_call_to_action_button_2_link (string): The call-to-action button 2 link.
    # - $p_slider_image (string): The slider image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertSliderItem($p_slider_id, $p_slider_title, $p_slider_heading, $p_slider_paragraph, $p_call_to_action_button_1_text, $p_call_to_action_button_1_link, $p_call_to_action_button_2_text, $p_call_to_action_button_2_link, $p_slider_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertSliderItem(:p_slider_id, :p_slider_title, :p_slider_heading, :p_slider_paragraph, :p_call_to_action_button_1_text, :p_call_to_action_button_1_link, :p_call_to_action_button_2_text, :p_call_to_action_button_2_link, :p_slider_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_slider_id', $p_slider_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_slider_title', $p_slider_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_slider_heading', $p_slider_heading, PDO::PARAM_STR);
        $stmt->bindValue(':p_slider_paragraph', $p_slider_paragraph, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_1_text', $p_call_to_action_button_1_text, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_1_link', $p_call_to_action_button_1_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_2_text', $p_call_to_action_button_2_text, PDO::PARAM_STR);
        $stmt->bindValue(':p_call_to_action_button_2_link', $p_call_to_action_button_2_link, PDO::PARAM_STR);
        $stmt->bindValue(':p_slider_image', $p_slider_image, PDO::PARAM_STR);
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
    # Function: checkSliderExist
    # Description: Checks if a slider exists.
    #
    # Parameters:
    # - $p_slider_id (int): The slider ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkSliderExist($p_slider_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkSliderExist(:p_slider_id)');
        $stmt->bindValue(':p_slider_id', $p_slider_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkSliderItemExist
    # Description: Checks if a slider item exists.
    #
    # Parameters:
    # - $p_slider_item_id (int): The slider item ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkSliderItemExist($p_slider_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkSliderItemExist(:p_slider_item_id)');
        $stmt->bindValue(':p_slider_item_id', $p_slider_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteSlider
    # Description: Deletes the slider.
    #
    # Parameters:
    # - $p_slider_id (int): The slider ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteSlider($p_slider_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteSlider(:p_slider_id)');
        $stmt->bindValue(':p_slider_id', $p_slider_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteSliderItem
    # Description: Deletes the slider item.
    #
    # Parameters:
    # - $p_slider_item_id (int): The slider item ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteSliderItem($p_slider_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteSliderItem(:p_slider_item_id)');
        $stmt->bindValue(':p_slider_item_id', $p_slider_item_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getSlider
    # Description: Retrieves the details of a slider.
    #
    # Parameters:
    # - $p_slider_id (int): The slider ID.
    #
    # Returns:
    # - An array containing the slider details.
    #
    # -------------------------------------------------------------
    public function getSlider($p_slider_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getSlider(:p_slider_id)');
        $stmt->bindValue(':p_slider_id', $p_slider_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getSliderItem
    # Description: Retrieves the details of a slider item.
    #
    # Parameters:
    # - $p_slider_item_id (int): The slider ID.
    #
    # Returns:
    # - An array containing the slider details.
    #
    # -------------------------------------------------------------
    public function getSliderItem($p_slider_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getSliderItem(:p_slider_item_id)');
        $stmt->bindValue(':p_slider_item_id', $p_slider_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getSliderItemBySliderID
    # Description: Retrieves the details of a slider item.
    #
    # Parameters:
    # - $p_slider_id (int): The slider ID.
    #
    # Returns:
    # - An array containing the slider details.
    #
    # -------------------------------------------------------------
    public function getSliderItemBySliderID($p_slider_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getSliderItemBySliderID(:p_slider_id)');
        $stmt->bindValue(':p_slider_id', $p_slider_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateSliderOptions
    # Description: Generates the slider options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateSliderOptions($p_slider_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateSliderOptions(:p_slider_id)');
        $stmt->bindValue(':p_slider_id', $p_slider_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $sliderID = $row['slider_id'];
            $sliderName = $row['slider_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($sliderID, ENT_QUOTES) . '">' . htmlspecialchars($sliderName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>