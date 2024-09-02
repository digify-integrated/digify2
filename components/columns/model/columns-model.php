<?php
/**
* Class ColumnsModel
*
* The ColumnsModel class handles columns related operations and interactions.
*/
class ColumnsModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateColumns
    # Description: Updates the columns.
    #
    # Parameters:
    # - $p_columns_id (int): The columns ID.
    # - $p_columns_name (string): The columns name.
    # - $p_description (string): The columns description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateColumns($p_columns_id, $p_columns_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateColumns(:p_columns_id, :p_columns_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_columns_id', $p_columns_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_columns_name', $p_columns_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateColumnsPublishStatus
    # Description: Updates the columns publish status.
    #
    # Parameters:
    # - $p_columns_item_id (int): The columns item ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateColumnsPublishStatus($p_columns_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateColumnsPublishStatus(:p_columns_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_columns_id', $p_columns_id, PDO::PARAM_INT);
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
    # Function: insertColumns
    # Description: Inserts the columns.
    #
    # Parameters:
    # - $p_columns_name (string): The columns name.
    # - $p_description (string): The columns description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertColumns($p_columns_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertColumns(:p_columns_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_columns_id)');
        $stmt->bindValue(':p_columns_name', $p_columns_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_columns_id AS columns_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['columns_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkColumnsExist
    # Description: Checks if a columns exists.
    #
    # Parameters:
    # - $p_columns_id (int): The columns ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkColumnsExist($p_columns_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkColumnsExist(:p_columns_id)');
        $stmt->bindValue(':p_columns_id', $p_columns_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteColumns
    # Description: Deletes the columns.
    #
    # Parameters:
    # - $p_columns_id (int): The columns ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteColumns($p_columns_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteColumns(:p_columns_id)');
        $stmt->bindValue(':p_columns_id', $p_columns_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getColumns
    # Description: Retrieves the details of a columns.
    #
    # Parameters:
    # - $p_columns_id (int): The columns ID.
    #
    # Returns:
    # - An array containing the columns details.
    #
    # -------------------------------------------------------------
    public function getColumns($p_columns_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getColumns(:p_columns_id)');
        $stmt->bindValue(':p_columns_id', $p_columns_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateColumnsOptions
    # Description: Generates the columns options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateColumnsOptions($p_columns_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateColumnsOptions(:p_columns_id)');
        $stmt->bindValue(':p_columns_id', $p_columns_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $columnsID = $row['columns_id'];
            $columnsName = $row['columns_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($columnsID, ENT_QUOTES) . '">' . htmlspecialchars($columnsName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>