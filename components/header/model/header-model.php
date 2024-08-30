<?php
/**
* Class HeaderModel
*
* The HeaderModel class handles header related operations and interactions.
*/
class HeaderModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateHeader
    # Description: Updates the header.
    #
    # Parameters:
    # - $p_header_id (int): The header ID.
    # - $p_header_name (string): The header name.
    # - $p_description (string): The header description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateHeader($p_header_id, $p_header_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateHeader(:p_header_id, :p_header_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_header_id', $p_header_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_header_name', $p_header_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateHeaderPublishStatus
    # Description: Updates the header publish status.
    #
    # Parameters:
    # - $p_header_item_id (int): The header item ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateHeaderPublishStatus($p_header_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateHeaderPublishStatus(:p_header_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_header_id', $p_header_id, PDO::PARAM_INT);
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
    # Function: insertHeader
    # Description: Inserts the header.
    #
    # Parameters:
    # - $p_header_name (string): The header name.
    # - $p_description (string): The header description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertHeader($p_header_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertHeader(:p_header_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_header_id)');
        $stmt->bindValue(':p_header_name', $p_header_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_header_id AS header_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['header_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkHeaderExist
    # Description: Checks if a header exists.
    #
    # Parameters:
    # - $p_header_id (int): The header ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkHeaderExist($p_header_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkHeaderExist(:p_header_id)');
        $stmt->bindValue(':p_header_id', $p_header_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteHeader
    # Description: Deletes the header.
    #
    # Parameters:
    # - $p_header_id (int): The header ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteHeader($p_header_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteHeader(:p_header_id)');
        $stmt->bindValue(':p_header_id', $p_header_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getHeader
    # Description: Retrieves the details of a header.
    #
    # Parameters:
    # - $p_header_id (int): The header ID.
    #
    # Returns:
    # - An array containing the header details.
    #
    # -------------------------------------------------------------
    public function getHeader($p_header_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getHeader(:p_header_id)');
        $stmt->bindValue(':p_header_id', $p_header_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateHeaderOptions
    # Description: Generates the header options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateHeaderOptions($p_header_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateHeaderOptions(:p_header_id)');
        $stmt->bindValue(':p_header_id', $p_header_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $headerID = $row['header_id'];
            $headerName = $row['header_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($headerID, ENT_QUOTES) . '">' . htmlspecialchars($headerName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>