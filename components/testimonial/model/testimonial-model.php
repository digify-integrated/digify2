<?php
/**
* Class TestimonialModel
*
* The TestimonialModel class handles testimonial related operations and interactions.
*/
class TestimonialModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateTestimonial
    # Description: Updates the testimonial.
    #
    # Parameters:
    # - $p_testimonial_id (int): The testimonial ID.
    # - $p_testimonial_name (string): The testimonial name.
    # - $p_description (string): The testimonial description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateTestimonial($p_testimonial_id, $p_testimonial_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateTestimonial(:p_testimonial_id, :p_testimonial_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_testimonial_id', $p_testimonial_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_testimonial_name', $p_testimonial_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateTestimonialItem
    # Description: Updates the testimonial item.
    #
    # Parameters:
    # - $p_testimonial_item_id (int): The testimonial item ID.
    # - $p_testimonial_id (int): The testimonial ID.
    # - $p_testimonial_client (string): The testimonial client.
    # - $p_testimonial_title (string): The testimonial title.
    # - $p_testimonial_paragraph (string): The testimonial paragraph.
    # - $p_rating (string): The rating.
    # - $p_testimonial_image (string): The testimonial image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateTestimonialItem($p_testimonial_item_id, $p_testimonial_id, $p_testimonial_client, $p_testimonial_title, $p_testimonial_paragraph, $p_rating, $p_testimonial_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateTestimonialItem(:p_testimonial_item_id, :p_testimonial_id, :p_testimonial_client, :p_testimonial_title, :p_testimonial_paragraph, :p_rating, :p_testimonial_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_testimonial_item_id', $p_testimonial_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_testimonial_id', $p_testimonial_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_testimonial_client', $p_testimonial_client, PDO::PARAM_STR);
        $stmt->bindValue(':p_testimonial_title', $p_testimonial_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_testimonial_paragraph', $p_testimonial_paragraph, PDO::PARAM_STR);
        $stmt->bindValue(':p_rating', $p_rating, PDO::PARAM_STR);
        $stmt->bindValue(':p_testimonial_image', $p_testimonial_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateTestimonialPublishStatus
    # Description: Updates the testimonial publish status.
    #
    # Parameters:
    # - $p_testimonial_id (int): The testimonial ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateTestimonialPublishStatus($p_testimonial_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateTestimonialPublishStatus(:p_testimonial_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_testimonial_id', $p_testimonial_id, PDO::PARAM_INT);
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
    # Function: insertTestimonial
    # Description: Inserts the testimonial.
    #
    # Parameters:
    # - $p_testimonial_name (string): The testimonial name.
    # - $p_description (string): The testimonial description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertTestimonial($p_testimonial_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertTestimonial(:p_testimonial_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_testimonial_id)');
        $stmt->bindValue(':p_testimonial_name', $p_testimonial_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_testimonial_id AS testimonial_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['testimonial_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertTestimonialItem
    # Description: Inserts the testimonial item.
    #
    # Parameters:
    # - $p_testimonial_id (int): The testimonial ID.
    # - $p_testimonial_title (string): The testimonial title.
    # - $p_testimonial_client (string): The testimonial client.
    # - $p_testimonial_paragraph (string): The testimonial paragraph.
    # - $p_rating (string): The rating.
    # - $p_testimonial_image (string): The testimonial image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertTestimonialItem($p_testimonial_id, $p_testimonial_client, $p_testimonial_title, $p_testimonial_paragraph, $p_rating, $p_testimonial_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertTestimonialItem(:p_testimonial_id, :p_testimonial_client, :p_testimonial_title, :p_testimonial_paragraph, :p_rating, :p_testimonial_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_testimonial_id', $p_testimonial_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_testimonial_client', $p_testimonial_client, PDO::PARAM_STR);
        $stmt->bindValue(':p_testimonial_title', $p_testimonial_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_testimonial_paragraph', $p_testimonial_paragraph, PDO::PARAM_STR);
        $stmt->bindValue(':p_rating', $p_rating, PDO::PARAM_STR);
        $stmt->bindValue(':p_testimonial_image', $p_testimonial_image, PDO::PARAM_STR);
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
    # Function: checkTestimonialExist
    # Description: Checks if a testimonial exists.
    #
    # Parameters:
    # - $p_testimonial_id (int): The testimonial ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkTestimonialExist($p_testimonial_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkTestimonialExist(:p_testimonial_id)');
        $stmt->bindValue(':p_testimonial_id', $p_testimonial_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkTestimonialItemExist
    # Description: Checks if a testimonial item exists.
    #
    # Parameters:
    # - $p_testimonial_item_id (int): The testimonial item ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkTestimonialItemExist($p_testimonial_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkTestimonialItemExist(:p_testimonial_item_id)');
        $stmt->bindValue(':p_testimonial_item_id', $p_testimonial_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteTestimonial
    # Description: Deletes the testimonial.
    #
    # Parameters:
    # - $p_testimonial_id (int): The testimonial ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteTestimonial($p_testimonial_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteTestimonial(:p_testimonial_id)');
        $stmt->bindValue(':p_testimonial_id', $p_testimonial_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteTestimonialItem
    # Description: Deletes the testimonial item.
    #
    # Parameters:
    # - $p_testimonial_item_id (int): The testimonial item ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteTestimonialItem($p_testimonial_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteTestimonialItem(:p_testimonial_item_id)');
        $stmt->bindValue(':p_testimonial_item_id', $p_testimonial_item_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getTestimonial
    # Description: Retrieves the details of a testimonial.
    #
    # Parameters:
    # - $p_testimonial_id (int): The testimonial ID.
    #
    # Returns:
    # - An array containing the testimonial details.
    #
    # -------------------------------------------------------------
    public function getTestimonial($p_testimonial_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getTestimonial(:p_testimonial_id)');
        $stmt->bindValue(':p_testimonial_id', $p_testimonial_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getTestimonialItem
    # Description: Retrieves the details of a testimonial item.
    #
    # Parameters:
    # - $p_testimonial_item_id (int): The testimonial ID.
    #
    # Returns:
    # - An array containing the testimonial details.
    #
    # -------------------------------------------------------------
    public function getTestimonialItem($p_testimonial_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getTestimonialItem(:p_testimonial_item_id)');
        $stmt->bindValue(':p_testimonial_item_id', $p_testimonial_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getTestimonialItemByTestimonialID
    # Description: Retrieves the details of a testimonial item.
    #
    # Parameters:
    # - $p_testimonial_id (int): The testimonial ID.
    #
    # Returns:
    # - An array containing the testimonial details.
    #
    # -------------------------------------------------------------
    public function getTestimonialItemByTestimonialID($p_testimonial_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getTestimonialItemByTestimonialID(:p_testimonial_id)');
        $stmt->bindValue(':p_testimonial_id', $p_testimonial_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateTestimonialOptions
    # Description: Generates the testimonial options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateTestimonialOptions($p_testimonial_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateTestimonialOptions(:p_testimonial_id)');
        $stmt->bindValue(':p_testimonial_id', $p_testimonial_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $testimonialID = $row['testimonial_id'];
            $testimonialName = $row['testimonial_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($testimonialID, ENT_QUOTES) . '">' . htmlspecialchars($testimonialName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>