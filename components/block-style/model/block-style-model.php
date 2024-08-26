<?php
/**
* Class BlockStyleModel
*
* The BlockStyleModel class handles block style related operations and interactions.
*/
class BlockStyleModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateBlockStyle
    # Description: Updates the block style.
    #
    # Parameters:
    # - $p_block_style_id (int): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_description (string): The description.
    # - $p_block_type_id (int): The block type ID.
    # - $p_block_type_name (string): The block type name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateBlockStyle($p_block_style_id, $p_block_style_name, $p_description, $p_block_type_id, $p_block_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateBlockStyle(:p_block_style_id, :p_block_style_name, :p_description, :p_block_type_id, :p_block_type_name, :p_last_log_by)');
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_type_id', $p_block_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_type_name', $p_block_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateBlockContainer
    # Description: Updates the block container.
    #
    # Parameters:
    # - $p_block_style_id (int): The block style ID.
    # - $p_block_container (string): The block container.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateBlockContainer($p_block_style_id, $p_block_container, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateBlockContainer(:p_block_style_id, :p_block_container, :p_last_log_by)');
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_container', $p_block_container, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateBlockItem
    # Description: Updates the block item.
    #
    # Parameters:
    # - $p_block_style_id (int): The block style ID.
    # - $p_block_item (string): The block item.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateBlockItem($p_block_style_id, $p_block_item, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateBlockItem(:p_block_style_id, :p_block_item, :p_last_log_by)');
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_item', $p_block_item, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertBlockStyle
    # Description: Inserts the block style.
    #
    # Parameters:
    # - $p_block_style_name (string): The block style name.
    # - $p_description (string): The description.
    # - $p_block_type_id (int): The block type ID.
    # - $p_block_type_name (string): The block type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertBlockStyle($p_block_style_name, $p_description, $p_block_type_id, $p_block_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertBlockStyle(:p_block_style_name, :p_description, :p_block_type_id, :p_block_type_name, :p_last_log_by, @p_block_style_id)');
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_type_id', $p_block_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_type_name', $p_block_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_block_style_id AS block_style_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['block_style_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertBlockContainer
    # Description: Inserts the block container.
    #
    # Parameters:
    # - $p_block_style_id (int): The block style ID.
    # - $p_block_container (string): The block container.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertBlockContainer($p_block_style_id, $p_block_container, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertBlockContainer(:p_block_style_id, :p_block_container, :p_last_log_by)');
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_container', $p_block_container, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertBlockItem
    # Description: Inserts the block item.
    #
    # Parameters:
    # - $p_block_style_id (int): The block style ID.
    # - $p_block_item (string): The block item.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertBlockItem($p_block_style_id, $p_block_item, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertBlockItem(:p_block_style_id, :p_block_item, :p_last_log_by)');
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_item', $p_block_item, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkBlockStyleExist
    # Description: Checks if a block style exists.
    #
    # Parameters:
    # - $p_block_style_id (int): The block style ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkBlockStyleExist($p_block_style_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkBlockStyleExist(:p_block_style_id)');
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkBlockContainerExist
    # Description: Checks if a block container exists.
    #
    # Parameters:
    # - $p_block_style_id (int): The block style ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkBlockContainerExist($p_block_style_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkBlockContainerExist(:p_block_style_id)');
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkBlockItemExist
    # Description: Checks if a block item exists.
    #
    # Parameters:
    # - $p_block_style_id (int): The block style ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkBlockItemExist($p_block_style_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkBlockItemExist(:p_block_style_id)');
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteBlockStyle
    # Description: Deletes the block style.
    #
    # Parameters:
    # - $p_block_style_id (int): The block style ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteBlockStyle($p_block_style_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteBlockStyle(:p_block_style_id)');
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getBlockStyle
    # Description: Retrieves the details of a block style.
    #
    # Parameters:
    # - $p_block_style_id (int): The block style ID.
    #
    # Returns:
    # - An array containing the block style details.
    #
    # -------------------------------------------------------------
    public function getBlockStyle($p_block_style_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getBlockStyle(:p_block_style_id)');
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getBlockContainer
    # Description: Retrieves the details of a block container.
    #
    # Parameters:
    # - $p_block_style_id (int): The block style ID.
    #
    # Returns:
    # - An array containing the block container details.
    #
    # -------------------------------------------------------------
    public function getBlockContainer($p_block_style_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getBlockContainer(:p_block_style_id)');
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getBlockItem
    # Description: Retrieves the details of a block item.
    #
    # Parameters:
    # - $p_block_style_id (int): The block style ID.
    #
    # Returns:
    # - An array containing the block item details.
    #
    # -------------------------------------------------------------
    public function getBlockItem($p_block_style_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getBlockItem(:p_block_style_id)');
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateBlockStyleOptions
    # Description: Generates the block style options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateBlockStyleOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateBlockStyleOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $blockStyleID = $row['block_style_id'];
            $blockStyleName = $row['block_style_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($blockStyleID, ENT_QUOTES) . '">' . htmlspecialchars($blockStyleName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>