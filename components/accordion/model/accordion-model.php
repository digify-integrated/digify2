<?php
/**
* Class AccordionModel
*
* The AccordionModel class handles accordion related operations and interactions.
*/
class AccordionModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateAccordion
    # Description: Updates the accordion.
    #
    # Parameters:
    # - $p_accordion_id (int): The accordion ID.
    # - $p_accordion_name (string): The accordion name.
    # - $p_description (string): The accordion description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateAccordion($p_accordion_id, $p_accordion_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateAccordion(:p_accordion_id, :p_accordion_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_accordion_id', $p_accordion_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_accordion_name', $p_accordion_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateAccordionItem
    # Description: Updates the accordion.
    #
    # Parameters:
    # - $p_accordion_item_id (int): The accordion item ID.
    # - $p_accordion_id (int): The accordion ID.
    # - $p_accordion_header (string): The accordion header.
    # - $p_accordion_body (string): The accordion body.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateAccordionItem($p_accordion_item_id, $p_accordion_id, $p_accordion_header, $p_accordion_body, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateAccordionItem(:p_accordion_item_id, :p_accordion_id, :p_accordion_header, :p_accordion_body, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_accordion_item_id', $p_accordion_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_accordion_id', $p_accordion_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_accordion_header', $p_accordion_header, PDO::PARAM_STR);
        $stmt->bindValue(':p_accordion_body', $p_accordion_body, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateAccordionPublishStatus
    # Description: Updates the accordion publish status.
    #
    # Parameters:
    # - $p_accordion_item_id (int): The accordion item ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateAccordionPublishStatus($p_accordion_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateAccordionPublishStatus(:p_accordion_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_accordion_id', $p_accordion_id, PDO::PARAM_INT);
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
    # Function: insertAccordion
    # Description: Inserts the accordion.
    #
    # Parameters:
    # - $p_accordion_name (string): The accordion name.
    # - $p_description (string): The accordion description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertAccordion($p_accordion_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertAccordion(:p_accordion_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_accordion_id)');
        $stmt->bindValue(':p_accordion_name', $p_accordion_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_accordion_id AS accordion_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['accordion_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertAccordionItem
    # Description: Inserts the accordion.
    #
    # Parameters:
    # - $p_accordion_id (int): The accordion ID.
    # - $p_accordion_header (string): The accordion header.
    # - $p_accordion_body (string): The accordion body.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertAccordionItem($p_accordion_id, $p_accordion_header, $p_accordion_body, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertAccordionItem(:p_accordion_id, :p_accordion_header, :p_accordion_body, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_accordion_id', $p_accordion_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_accordion_header', $p_accordion_header, PDO::PARAM_STR);
        $stmt->bindValue(':p_accordion_body', $p_accordion_body, PDO::PARAM_STR);
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
    # Function: checkAccordionExist
    # Description: Checks if a accordion exists.
    #
    # Parameters:
    # - $p_accordion_id (int): The accordion ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkAccordionExist($p_accordion_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkAccordionExist(:p_accordion_id)');
        $stmt->bindValue(':p_accordion_id', $p_accordion_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkAccordionItemExist
    # Description: Checks if a accordion item exists.
    #
    # Parameters:
    # - $p_accordion_item_id (int): The accordion item ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkAccordionItemExist($p_accordion_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkAccordionItemExist(:p_accordion_item_id)');
        $stmt->bindValue(':p_accordion_item_id', $p_accordion_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteAccordion
    # Description: Deletes the accordion.
    #
    # Parameters:
    # - $p_accordion_id (int): The accordion ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteAccordion($p_accordion_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteAccordion(:p_accordion_id)');
        $stmt->bindValue(':p_accordion_id', $p_accordion_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteAccordionItem
    # Description: Deletes the accordion item.
    #
    # Parameters:
    # - $p_accordion_item_id (int): The accordion item ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteAccordionItem($p_accordion_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteAccordionItem(:p_accordion_item_id)');
        $stmt->bindValue(':p_accordion_item_id', $p_accordion_item_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getAccordion
    # Description: Retrieves the details of a accordion.
    #
    # Parameters:
    # - $p_accordion_id (int): The accordion ID.
    #
    # Returns:
    # - An array containing the accordion details.
    #
    # -------------------------------------------------------------
    public function getAccordion($p_accordion_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getAccordion(:p_accordion_id)');
        $stmt->bindValue(':p_accordion_id', $p_accordion_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getAccordionItem
    # Description: Retrieves the details of a accordion item.
    #
    # Parameters:
    # - $p_accordion_item_id (int): The accordion ID.
    #
    # Returns:
    # - An array containing the accordion details.
    #
    # -------------------------------------------------------------
    public function getAccordionItem($p_accordion_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getAccordionItem(:p_accordion_item_id)');
        $stmt->bindValue(':p_accordion_item_id', $p_accordion_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateAccordionOptions
    # Description: Generates the accordion options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateAccordionOptions($p_accordion_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateAccordionOptions(:p_accordion_id)');
        $stmt->bindValue(':p_accordion_id', $p_accordion_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $accordionID = $row['accordion_id'];
            $accordionName = $row['accordion_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($accordionID, ENT_QUOTES) . '">' . htmlspecialchars($accordionName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>