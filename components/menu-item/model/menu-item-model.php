<?php
/**
* Class MenuItemModel
*
* The MenuItemModel class handles menu item related operations and interactions.
*/
class MenuItemModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateMenuItem
    # Description: Updates the menu item.
    #
    # Parameters:
    # - $p_menu_item_id (int): The menu item ID.
    # - $p_menu_item_name (string): The menu item name.
    # - $p_menu_item_url (string): The menu item URL.
    # - $p_menu_group_id (int): The menu group ID.
    # - $p_menu_group_name (string): The menu group name.
    # - $p_app_module_id (int): The menu group ID.
    # - $p_app_module_name (string): The menu group name.
    # - $p_parent_id (int): The parent ID.
    # - $p_parent_name (string): The parent name.
    # - $p_order_sequence (int): The order sequence of menu item.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateMenuItem($p_menu_item_id, $p_menu_item_name, $p_menu_item_url, $p_menu_group_id, $p_menu_group_name, $p_app_module_id, $p_app_module_name, $p_parent_id, $p_parent_name, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateMenuItem(:p_menu_item_id, :p_menu_item_name, :p_menu_item_url, :p_menu_group_id, :p_menu_group_name, :p_app_module_id, :p_app_module_name, :p_parent_id, :p_parent_name, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_menu_item_id', $p_menu_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_menu_item_name', $p_menu_item_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_menu_item_url', $p_menu_item_url, PDO::PARAM_STR);
        $stmt->bindValue(':p_menu_group_id', $p_menu_group_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_menu_group_name', $p_menu_group_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_app_module_id', $p_app_module_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_app_module_name', $p_app_module_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_parent_id', $p_parent_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_parent_name', $p_parent_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertMenuItem
    # Description: Inserts the menu item.
    #
    # Parameters:
    # - $p_menu_item_name (string): The menu item name.
    # - $p_menu_item_url (string): The menu item URL.
    # - $p_menu_group_id (int): The menu group ID.
    # - $p_menu_group_name (string): The menu group name.
    # - $p_app_module_id (int): The menu group ID.
    # - $p_app_module_name (string): The menu group name.
    # - $p_parent_id (int): The parent ID.
    # - $p_parent_name (string): The parent name.
    # - $p_order_sequence (int): The order sequence of menu item.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertMenuItem($p_menu_item_name, $p_menu_item_url, $p_menu_group_id, $p_menu_group_name, $p_app_module_id, $p_app_module_name, $p_parent_id, $p_parent_name, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertMenuItem(:p_menu_item_name, :p_menu_item_url, :p_menu_group_id, :p_menu_group_name, :p_app_module_id, :p_app_module_name, :p_parent_id, :p_parent_name, :p_order_sequence, :p_last_log_by, @p_menu_item_id)');
        $stmt->bindValue(':p_menu_item_name', $p_menu_item_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_menu_item_url', $p_menu_item_url, PDO::PARAM_STR);
        $stmt->bindValue(':p_menu_group_id', $p_menu_group_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_menu_group_name', $p_menu_group_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_app_module_id', $p_app_module_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_app_module_name', $p_app_module_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_parent_id', $p_parent_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_parent_name', $p_parent_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_menu_item_id AS menu_item_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['menu_item_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkMenuItemExist
    # Description: Checks if a menu item exists.
    #
    # Parameters:
    # - $p_menu_item_id (int): The menu item ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkMenuItemExist($p_menu_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkMenuItemExist(:p_menu_item_id)');
        $stmt->bindValue(':p_menu_item_id', $p_menu_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteMenuItem
    # Description: Deletes the menu item.
    #
    # Parameters:
    # - $p_menu_item_id (int): The menu item ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteMenuItem($p_menu_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteMenuItem(:p_menu_item_id)');
        $stmt->bindValue(':p_menu_item_id', $p_menu_item_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getMenuItem
    # Description: Retrieves the details of a menu item.
    #
    # Parameters:
    # - $p_menu_item_id (int): The menu item ID.
    #
    # Returns:
    # - An array containing the menu item details.
    #
    # -------------------------------------------------------------
    public function getMenuItem($p_menu_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getMenuItem(:p_menu_item_id)');
        $stmt->bindValue(':p_menu_item_id', $p_menu_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateMenuItemOptions
    # Description: Generates the menu item options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateMenuItemOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateMenuItemOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $menuItemID = $row['menu_item_id'];
            $menuItemName = $row['menu_item_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($menuItemID, ENT_QUOTES) . '">' . htmlspecialchars($menuItemName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>