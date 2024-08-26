<?php
/**
* Class BlockTypeModel
*
* The BlockTypeModel class handles block type related operations and interactions.
*/
class BlockTypeModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateBlockType
    # Description: Updates the block type.
    #
    # Parameters:
    # - $p_block_type_id (int): The block type ID.
    # - $p_block_type_name (string): The block type name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateBlockType($p_block_type_id, $p_block_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateBlockType(:p_block_type_id, :p_block_type_name, :p_last_log_by)');
        $stmt->bindValue(':p_block_type_id', $p_block_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_type_name', $p_block_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertBlockType
    # Description: Inserts the block type.
    #
    # Parameters:
    # - $p_block_type_name (string): The block type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertBlockType($p_block_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertBlockType(:p_block_type_name, :p_last_log_by, @p_block_type_id)');
        $stmt->bindValue(':p_block_type_name', $p_block_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_block_type_id AS block_type_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['block_type_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkBlockTypeExist
    # Description: Checks if a block type exists.
    #
    # Parameters:
    # - $p_block_type_id (int): The block type ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkBlockTypeExist($p_block_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkBlockTypeExist(:p_block_type_id)');
        $stmt->bindValue(':p_block_type_id', $p_block_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteBlockType
    # Description: Deletes the block type.
    #
    # Parameters:
    # - $p_block_type_id (int): The block type ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteBlockType($p_block_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteBlockType(:p_block_type_id)');
        $stmt->bindValue(':p_block_type_id', $p_block_type_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getBlockType
    # Description: Retrieves the details of a block type.
    #
    # Parameters:
    # - $p_block_type_id (int): The block type ID.
    #
    # Returns:
    # - An array containing the block type details.
    #
    # -------------------------------------------------------------
    public function getBlockType($p_block_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getBlockType(:p_block_type_id)');
        $stmt->bindValue(':p_block_type_id', $p_block_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateBlockTypeOptions
    # Description: Generates the block type options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateBlockTypeOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateBlockTypeOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $blockTypeID = $row['block_type_id'];
            $blockTypeName = $row['block_type_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($blockTypeID, ENT_QUOTES) . '">' . htmlspecialchars($blockTypeName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>