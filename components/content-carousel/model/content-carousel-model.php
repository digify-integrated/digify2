<?php
/**
* Class CarouselModel
*
* The CarouselModel class handles carousel related operations and interactions.
*/
class CarouselModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCarousel
    # Description: Updates the carousel.
    #
    # Parameters:
    # - $p_carousel_id (int): The carousel ID.
    # - $p_carousel_name (string): The carousel name.
    # - $p_description (string): The carousel description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCarousel($p_carousel_id, $p_carousel_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCarousel(:p_carousel_id, :p_carousel_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_carousel_id', $p_carousel_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_carousel_name', $p_carousel_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCarouselImage
    # Description: Updates the carousel image.
    #
    # Parameters:
    # - $p_carousel_image_id (int): The carousel image ID.
    # - $p_carousel_id (int): The carousel ID.
    # - $p_carousel_image (string): The carousel image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCarouselImage($p_carousel_image_id, $p_carousel_id, $p_carousel_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCarouselImage(:p_carousel_image_id, :p_carousel_id, :p_carousel_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_carousel_image_id', $p_carousel_image_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_carousel_id', $p_carousel_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_carousel_image', $p_carousel_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCarouselPublishStatus
    # Description: Updates the carousel publish status.
    #
    # Parameters:
    # - $p_carousel_image_id (int): The carousel image ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCarouselPublishStatus($p_carousel_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCarouselPublishStatus(:p_carousel_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_carousel_id', $p_carousel_id, PDO::PARAM_INT);
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
    # Function: insertCarousel
    # Description: Inserts the carousel.
    #
    # Parameters:
    # - $p_carousel_name (string): The carousel name.
    # - $p_description (string): The carousel description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertCarousel($p_carousel_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCarousel(:p_carousel_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_carousel_id)');
        $stmt->bindValue(':p_carousel_name', $p_carousel_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_carousel_id AS carousel_id');
        $menuImageID = $result->fetch(PDO::FETCH_ASSOC)['carousel_id'];
        
        return $menuImageID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertCarouselImage
    # Description: Inserts the carousel image.
    #
    # Parameters:
    # - $p_carousel_id (int): The carousel ID.
    # - $p_carousel_image (string): The carousel image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertCarouselImage($p_carousel_id, $p_carousel_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCarouselImage(:p_carousel_id, :p_carousel_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_carousel_id', $p_carousel_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_carousel_image', $p_carousel_image, PDO::PARAM_STR);
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
    # Function: checkCarouselExist
    # Description: Checks if a carousel exists.
    #
    # Parameters:
    # - $p_carousel_id (int): The carousel ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCarouselExist($p_carousel_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCarouselExist(:p_carousel_id)');
        $stmt->bindValue(':p_carousel_id', $p_carousel_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkCarouselImageExist
    # Description: Checks if a carousel image exists.
    #
    # Parameters:
    # - $p_carousel_image_id (int): The carousel image ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCarouselImageExist($p_carousel_image_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCarouselImageExist(:p_carousel_image_id)');
        $stmt->bindValue(':p_carousel_image_id', $p_carousel_image_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCarousel
    # Description: Deletes the carousel.
    #
    # Parameters:
    # - $p_carousel_id (int): The carousel ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCarousel($p_carousel_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCarousel(:p_carousel_id)');
        $stmt->bindValue(':p_carousel_id', $p_carousel_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCarouselImage
    # Description: Deletes the carousel image.
    #
    # Parameters:
    # - $p_carousel_image_id (int): The carousel image ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCarouselImage($p_carousel_image_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCarouselImage(:p_carousel_image_id)');
        $stmt->bindValue(':p_carousel_image_id', $p_carousel_image_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCarousel
    # Description: Retrieves the details of a carousel.
    #
    # Parameters:
    # - $p_carousel_id (int): The carousel ID.
    #
    # Returns:
    # - An array containing the carousel details.
    #
    # -------------------------------------------------------------
    public function getCarousel($p_carousel_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCarousel(:p_carousel_id)');
        $stmt->bindValue(':p_carousel_id', $p_carousel_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCarouselImage
    # Description: Retrieves the details of a carousel image.
    #
    # Parameters:
    # - $p_carousel_image_id (int): The carousel ID.
    #
    # Returns:
    # - An array containing the carousel details.
    #
    # -------------------------------------------------------------
    public function getCarouselImage($p_carousel_image_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCarouselImage(:p_carousel_image_id)');
        $stmt->bindValue(':p_carousel_image_id', $p_carousel_image_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCarouselImageByCarouselID
    # Description: Retrieves the details of a carousel image.
    #
    # Parameters:
    # - $p_carousel_id (int): The carousel ID.
    #
    # Returns:
    # - An array containing the carousel details.
    #
    # -------------------------------------------------------------
    public function getCarouselImageByCarouselID($p_carousel_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCarouselImageByCarouselID(:p_carousel_id)');
        $stmt->bindValue(':p_carousel_id', $p_carousel_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateCarouselOptions
    # Description: Generates the carousel options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateCarouselOptions($p_carousel_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateCarouselOptions(:p_carousel_id)');
        $stmt->bindValue(':p_carousel_id', $p_carousel_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $carouselID = $row['carousel_id'];
            $carouselName = $row['carousel_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($carouselID, ENT_QUOTES) . '">' . htmlspecialchars($carouselName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>