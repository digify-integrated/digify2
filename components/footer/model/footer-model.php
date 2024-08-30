<?php
/**
* Class FooterModel
*
* The FooterModel class handles footer related operations and interactions.
*/
class FooterModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateFooter
    # Description: Updates the footer.
    #
    # Parameters:
    # - $p_footer_id (int): The footer ID.
    # - $p_footer_name (string): The footer name.
    # - $p_description (string): The footer description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateFooter($p_footer_id, $p_footer_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateFooter(:p_footer_id, :p_footer_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_footer_id', $p_footer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_footer_name', $p_footer_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateFooterPublishStatus
    # Description: Updates the footer publish status.
    #
    # Parameters:
    # - $p_footer_item_id (int): The footer item ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateFooterPublishStatus($p_footer_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateFooterPublishStatus(:p_footer_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_footer_id', $p_footer_id, PDO::PARAM_INT);
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
    # Function: insertFooter
    # Description: Inserts the footer.
    #
    # Parameters:
    # - $p_footer_name (string): The footer name.
    # - $p_description (string): The footer description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertFooter($p_footer_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertFooter(:p_footer_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_footer_id)');
        $stmt->bindValue(':p_footer_name', $p_footer_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_footer_id AS footer_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['footer_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkFooterExist
    # Description: Checks if a footer exists.
    #
    # Parameters:
    # - $p_footer_id (int): The footer ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkFooterExist($p_footer_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkFooterExist(:p_footer_id)');
        $stmt->bindValue(':p_footer_id', $p_footer_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteFooter
    # Description: Deletes the footer.
    #
    # Parameters:
    # - $p_footer_id (int): The footer ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteFooter($p_footer_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteFooter(:p_footer_id)');
        $stmt->bindValue(':p_footer_id', $p_footer_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getFooter
    # Description: Retrieves the details of a footer.
    #
    # Parameters:
    # - $p_footer_id (int): The footer ID.
    #
    # Returns:
    # - An array containing the footer details.
    #
    # -------------------------------------------------------------
    public function getFooter($p_footer_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getFooter(:p_footer_id)');
        $stmt->bindValue(':p_footer_id', $p_footer_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateFooterOptions
    # Description: Generates the footer options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateFooterOptions($p_footer_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateFooterOptions(:p_footer_id)');
        $stmt->bindValue(':p_footer_id', $p_footer_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $footerID = $row['footer_id'];
            $footerName = $row['footer_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($footerID, ENT_QUOTES) . '">' . htmlspecialchars($footerName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>