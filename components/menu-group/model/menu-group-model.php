<?php
/**
* Class MenuGroupModel
*
* The MenuGroupModel class handles menu group related operations and interactions.
*/
class MenuGroupModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateMenuGroup
    # Description: Updates the menu group.
    #
    # Parameters:
    # - $p_menu_group_id (int): The menu group ID.
    # - $p_menu_group_name (string): The menu group name.
    # - $p_order_sequence (int): The order sequence of menu group.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateMenuGroup($p_menu_group_id, $p_menu_group_name, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateMenuGroup(:p_menu_group_id, :p_menu_group_name, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_menu_group_id', $p_menu_group_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_menu_group_name', $p_menu_group_name, PDO::PARAM_STR);
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
    # Function: insertMenuGroup
    # Description: Inserts the menu group.
    #
    # Parameters:
    # - $p_menu_group_name (string): The menu group name.
    # - $p_order_sequence (int): The order sequence of menu group.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertMenuGroup($p_menu_group_name, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertMenuGroup(:p_menu_group_name, :p_order_sequence, :p_last_log_by, @p_menu_group_id)');
        $stmt->bindValue(':p_menu_group_name', $p_menu_group_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_menu_group_id AS menu_group_id');
        $menuGroupID = $result->fetch(PDO::FETCH_ASSOC)['menu_group_id'];
        
        return $menuGroupID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkMenuGroupExist
    # Description: Checks if a menu group exists.
    #
    # Parameters:
    # - $p_menu_group_id (int): The menu group ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkMenuGroupExist($p_menu_group_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkMenuGroupExist(:p_menu_group_id)');
        $stmt->bindValue(':p_menu_group_id', $p_menu_group_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteMenuGroup
    # Description: Deletes the menu group.
    #
    # Parameters:
    # - $p_menu_group_id (int): The menu group ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteMenuGroup($p_menu_group_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteMenuGroup(:p_menu_group_id)');
        $stmt->bindValue(':p_menu_group_id', $p_menu_group_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getMenuGroup
    # Description: Retrieves the details of a menu group.
    #
    # Parameters:
    # - $p_menu_group_id (int): The menu group ID.
    #
    # Returns:
    # - An array containing the menu group details.
    #
    # -------------------------------------------------------------
    public function getMenuGroup($p_menu_group_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getMenuGroup(:p_menu_group_id)');
        $stmt->bindValue(':p_menu_group_id', $p_menu_group_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateMenuGroupOptions
    # Description: Generates the menu group options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateMenuGroupOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateMenuGroupOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $menuGroupID = $row['menu_group_id'];
            $menuGroupName = $row['menu_group_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($menuGroupID, ENT_QUOTES) . '">' . htmlspecialchars($menuGroupName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>