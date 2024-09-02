<?php
/**
* Class PricingTableModel
*
* The PricingTableModel class handles pricing table related operations and interactions.
*/
class PricingTableModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updatePricingTable
    # Description: Updates the pricing table.
    #
    # Parameters:
    # - $p_pricing_table_id (int): The carousel ID.
    # - $p_pricing_table_name (string): The carousel name.
    # - $p_description (string): The carousel description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updatePricingTable($p_pricing_table_id, $p_pricing_table_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updatePricingTable(:p_pricing_table_id, :p_pricing_table_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_pricing_table_id', $p_pricing_table_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_pricing_table_name', $p_pricing_table_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updatePricingTablePublishStatus
    # Description: Updates the pricing table publish status.
    #
    # Parameters:
    # - $p_pricing_table_id (int): The pricing table ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updatePricingTablePublishStatus($p_pricing_table_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updatePricingTablePublishStatus(:p_pricing_table_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_pricing_table_id', $p_pricing_table_id, PDO::PARAM_INT);
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
    # Function: insertPricingTable
    # Description: Inserts the pricing table.
    #
    # Parameters:
    # - $p_pricing_table_name (string): The pricing table name.
    # - $p_description (string): The pricing table description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertPricingTable($p_pricing_table_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertPricingTable(:p_pricing_table_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_pricing_table_id)');
        $stmt->bindValue(':p_pricing_table_name', $p_pricing_table_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_pricing_table_id AS pricing_table_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['pricing_table_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkPricingTableExist
    # Description: Checks if a pricing table exists.
    #
    # Parameters:
    # - $p_pricing_table_id (int): The pricing table ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkPricingTableExist($p_pricing_table_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkPricingTableExist(:p_pricing_table_id)');
        $stmt->bindValue(':p_pricing_table_id', $p_pricing_table_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deletePricingTable
    # Description: Deletes the pricing table.
    #
    # Parameters:
    # - $p_pricing_table_id (int): The pricing table ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deletePricingTable($p_pricing_table_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deletePricingTable(:p_pricing_table_id)');
        $stmt->bindValue(':p_pricing_table_id', $p_pricing_table_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getPricingTable
    # Description: Retrieves the details of a pricing table.
    #
    # Parameters:
    # - $p_pricing_table_id (int): The pricing table ID.
    #
    # Returns:
    # - An array containing the pricing table details.
    #
    # -------------------------------------------------------------
    public function getPricingTable($p_pricing_table_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getPricingTable(:p_pricing_table_id)');
        $stmt->bindValue(':p_pricing_table_id', $p_pricing_table_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generatePricingTableOptions
    # Description: Generates the pricing table options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generatePricingTableOptions($p_pricing_table_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generatePricingTableOptions(:p_pricing_table_id)');
        $stmt->bindValue(':p_pricing_table_id', $p_pricing_table_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $pricingTableID = $row['pricing_table_id'];
            $pricingTableName = $row['pricing_table_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($pricingTableID, ENT_QUOTES) . '">' . htmlspecialchars($pricingTableName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>