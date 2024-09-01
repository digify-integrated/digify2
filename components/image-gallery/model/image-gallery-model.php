<?php
/**
* Class ImageGalleryModel
*
* The ImageGalleryModel class handles image gallery related operations and interactions.
*/
class ImageGalleryModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateImageGallery
    # Description: Updates the image gallery.
    #
    # Parameters:
    # - $p_image_gallery_id (int): The image galllery ID.
    # - $p_image_gallery_name (string): The carousel name.
    # - $p_description (string): The carousel description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateImageGallery($p_image_gallery_id, $p_image_gallery_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateImageGallery(:p_image_gallery_id, :p_image_gallery_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_image_gallery_id', $p_image_gallery_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_image_gallery_name', $p_image_gallery_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateImageGalleryItem
    # Description: Updates the image gallery item.
    #
    # Parameters:
    # - $p_image_gallery_item_id (int): The carousel item ID.
    # - $p_image_gallery_id (int): The image galllery ID.
    # - $p_image_gallery_title (string): The image gallery title.
    # - $p_image_gallery_image (string): The image gallery image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateImageGalleryItem($p_image_gallery_item_id, $p_image_gallery_id, $p_image_gallery_title, $p_image_gallery_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateImageGalleryItem(:p_image_gallery_item_id, :p_image_gallery_id, :p_image_gallery_title, :p_image_gallery_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_image_gallery_item_id', $p_image_gallery_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_image_gallery_id', $p_image_gallery_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_image_gallery_title', $p_image_gallery_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_image_gallery_image', $p_image_gallery_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateImageGalleryPublishStatus
    # Description: Updates the image gallery publish status.
    #
    # Parameters:
    # - $p_image_gallery_id (int): The image gallery ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateImageGalleryPublishStatus($p_image_gallery_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateImageGalleryPublishStatus(:p_image_gallery_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_image_gallery_id', $p_image_gallery_id, PDO::PARAM_INT);
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
    # Function: insertImageGallery
    # Description: Inserts the image gallery.
    #
    # Parameters:
    # - $p_image_gallery_name (string): The image gallery name.
    # - $p_description (string): The image gallery description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertImageGallery($p_image_gallery_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertImageGallery(:p_image_gallery_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_image_gallery_id)');
        $stmt->bindValue(':p_image_gallery_name', $p_image_gallery_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_image_gallery_id AS image_gallery_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['image_gallery_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertImageGalleryItem
    # Description: Inserts the image gallery item.
    #
    # Parameters:
    # - $p_image_gallery_id (int): The image galllery ID.
    # - $p_image_gallery_title (string): The image gallery title.
    # - $p_image_gallery_image (string): The image gallery image.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertImageGalleryItem($p_image_gallery_id, $p_image_gallery_title, $p_image_gallery_image, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertImageGalleryItem(:p_image_gallery_id, :p_image_gallery_title, :p_image_gallery_image, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_image_gallery_id', $p_image_gallery_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_image_gallery_title', $p_image_gallery_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_image_gallery_image', $p_image_gallery_image, PDO::PARAM_STR);
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
    # Function: checkImageGalleryExist
    # Description: Checks if a image gallery exists.
    #
    # Parameters:
    # - $p_image_gallery_id (int): The image gallery ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkImageGalleryExist($p_image_gallery_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkImageGalleryExist(:p_image_gallery_id)');
        $stmt->bindValue(':p_image_gallery_id', $p_image_gallery_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkImageGalleryItemExist
    # Description: Checks if a image gallery item exists.
    #
    # Parameters:
    # - $p_image_gallery_item_id (int): The image gallery item ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkImageGalleryItemExist($p_image_gallery_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkImageGalleryItemExist(:p_image_gallery_item_id)');
        $stmt->bindValue(':p_image_gallery_item_id', $p_image_gallery_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteImageGallery
    # Description: Deletes the image gallery.
    #
    # Parameters:
    # - $p_image_gallery_id (int): The image gallery ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteImageGallery($p_image_gallery_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteImageGallery(:p_image_gallery_id)');
        $stmt->bindValue(':p_image_gallery_id', $p_image_gallery_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteImageGalleryItem
    # Description: Deletes the image gallery item.
    #
    # Parameters:
    # - $p_image_gallery_item_id (int): The image gallery item ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteImageGalleryItem($p_image_gallery_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteImageGalleryItem(:p_image_gallery_item_id)');
        $stmt->bindValue(':p_image_gallery_item_id', $p_image_gallery_item_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getImageGallery
    # Description: Retrieves the details of a image gallery.
    #
    # Parameters:
    # - $p_image_gallery_id (int): The image gallery ID.
    #
    # Returns:
    # - An array containing the image gallery details.
    #
    # -------------------------------------------------------------
    public function getImageGallery($p_image_gallery_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getImageGallery(:p_image_gallery_id)');
        $stmt->bindValue(':p_image_gallery_id', $p_image_gallery_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getImageGalleryItem
    # Description: Retrieves the details of a image gallery item.
    #
    # Parameters:
    # - $p_image_gallery_item_id (int): The image gallery ID.
    #
    # Returns:
    # - An array containing the image gallery details.
    #
    # -------------------------------------------------------------
    public function getImageGalleryItem($p_image_gallery_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getImageGalleryItem(:p_image_gallery_item_id)');
        $stmt->bindValue(':p_image_gallery_item_id', $p_image_gallery_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getImageGalleryItemByImageGalleryID
    # Description: Retrieves the details of a image gallery item.
    #
    # Parameters:
    # - $p_image_gallery_id (int): The image gallery ID.
    #
    # Returns:
    # - An array containing the image gallery details.
    #
    # -------------------------------------------------------------
    public function getImageGalleryItemByImageGalleryID($p_image_gallery_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getImageGalleryItemByImageGalleryID(:p_image_gallery_id)');
        $stmt->bindValue(':p_image_gallery_id', $p_image_gallery_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateImageGalleryOptions
    # Description: Generates the image gallery options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateImageGalleryOptions($p_image_gallery_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateImageGalleryOptions(:p_image_gallery_id)');
        $stmt->bindValue(':p_image_gallery_id', $p_image_gallery_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $imageGalleryID = $row['image_gallery_id'];
            $imageGalleryName = $row['image_gallery_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($imageGalleryID, ENT_QUOTES) . '">' . htmlspecialchars($imageGalleryName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>