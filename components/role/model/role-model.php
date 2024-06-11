<?php
/**
* Class RoleModel
*
* The RoleModel class handles role related operations and interactions.
*/
class RoleModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateRole
    # Description: Updates the role.
    #
    # Parameters:
    # - $p_role_id (int): The role ID.
    # - $p_role_name (string): The role name.
    # - $p_role_description (string): The description of role.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateRole($p_role_id, $p_role_name, $p_role_description, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateRole(:p_role_id, :p_role_name, :p_role_description, :p_last_log_by)');
        $stmt->bindValue(':p_role_id', $p_role_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_role_name', $p_role_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_role_description', $p_role_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateRolePermission
    # Description: Updates the role permission.
    #
    # Parameters:
    # - $p_role_permission_id (int): The role permission ID.
    # - $p_access_type (string): The access type to update.
    # - $p_access (int): The access either 1 or 0.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateRolePermission($p_role_permission_id, $p_access_type, $p_access, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateRolePermission(:p_role_permission_id, :p_access_type, :p_access, :p_last_log_by)');
        $stmt->bindValue(':p_role_permission_id', $p_role_permission_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_access_type', $p_access_type, PDO::PARAM_STR);
        $stmt->bindValue(':p_access', $p_access, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateRoleSystemActionPermission
    # Description: Updates the role permission.
    #
    # Parameters:
    # - $p_role_system_action_permission_id (int): The role system action permission ID.
    # - $p_system_action_access (int): The system action access either 1 or 0.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateRoleSystemActionPermission($p_role_system_action_permission_id, $p_system_action_access, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateRoleSystemActionPermission(:p_role_system_action_permission_id, :p_system_action_access, :p_last_log_by)');
        $stmt->bindValue(':p_role_system_action_permission_id', $p_role_system_action_permission_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_system_action_access', $p_system_action_access, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertRole
    # Description: Inserts the role.
    #
    # Parameters:
    # - $p_role_name (string): The role name.
    # - $p_role_description (string): The description of role.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertRole($p_role_name, $p_role_description, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertRole(:p_role_name, :p_role_description, :p_last_log_by, @p_role_id)');
        $stmt->bindValue(':p_role_name', $p_role_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_role_description', $p_role_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_role_id AS role_id');
        $menuGroupID = $result->fetch(PDO::FETCH_ASSOC)['role_id'];
        
        return $menuGroupID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertRolePermission
    # Description: Inserts the role permission.
    #
    # Parameters:
    # - $p_role_id (int): The role ID.
    # - $p_role_name (string): The role name.
    # - $p_menu_item_id (int): The menu item ID.
    # - $p_menu_item_name (string): The menu item name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertRolePermission($p_role_id, $p_role_name, $p_menu_item_id, $p_menu_item_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertRolePermission(:p_role_id, :p_role_name, :p_menu_item_id, :p_menu_item_name, :p_last_log_by)');
        $stmt->bindValue(':p_role_id', $p_role_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_role_name', $p_role_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_menu_item_id', $p_menu_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_menu_item_name', $p_menu_item_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertRoleSystemActionPermission
    # Description: Inserts the role sytem action permission.
    #
    # Parameters:
    # - $p_role_id (int): The role ID.
    # - $p_role_name (string): The role name.
    # - $p_system_action_id (int): The system action ID.
    # - $p_system_action_name (string): The system action name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertRoleSystemActionPermission($p_role_id, $p_role_name, $p_system_action_id, $p_system_action_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertRoleSystemActionPermission(:p_role_id, :p_role_name, :p_system_action_id, :p_system_action_name, :p_last_log_by)');
        $stmt->bindValue(':p_role_id', $p_role_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_role_name', $p_role_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_system_action_id', $p_system_action_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_system_action_name', $p_system_action_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertRoleUserAccount
    # Description: Inserts the role user account.
    #
    # Parameters:
    # - $p_role_id (int): The role ID.
    # - $p_role_name (string): The role name.
    # - $p_user_account_id (int): The user account ID.
    # - $p_file_as (string): The user account name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertRoleUserAccount($p_role_id, $p_role_name, $p_user_account_id, $p_file_as, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertRoleUserAccount(:p_role_id, :p_role_name, :p_user_account_id, :p_file_as, :p_last_log_by)');
        $stmt->bindValue(':p_role_id', $p_role_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_role_name', $p_role_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_file_as', $p_file_as, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkRoleExist
    # Description: Checks if a role exists.
    #
    # Parameters:
    # - $p_role_id (int): The role ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkRoleExist($p_role_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkRoleExist(:p_role_id)');
        $stmt->bindValue(':p_role_id', $p_role_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkRolePermissionExist
    # Description: Checks if a role permission exists.
    #
    # Parameters:
    # - $p_role_permission_id (int): The role permission ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkRolePermissionExist($p_role_permission_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkRolePermissionExist(:p_role_permission_id)');
        $stmt->bindValue(':p_role_permission_id', $p_role_permission_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkRoleSystemActionPermissionExist
    # Description: Checks if a role system action permission exists.
    #
    # Parameters:
    # - $p_role_system_action_permission_id (int): The role system action permission ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkRoleSystemActionPermissionExist($p_role_system_action_permission_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkRoleSystemActionPermissionExist(:p_role_system_action_permission_id)');
        $stmt->bindValue(':p_role_system_action_permission_id', $p_role_system_action_permission_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkRoleUserAccountExist
    # Description: Checks if a role user account exists.
    #
    # Parameters:
    # - $p_role_user_account_id (int): The role user account ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkRoleUserAccountExist($p_role_user_account_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkRoleUserAccountExist(:p_role_user_account_id)');
        $stmt->bindValue(':p_role_user_account_id', $p_role_user_account_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteRole
    # Description: Deletes the role.
    #
    # Parameters:
    # - $p_role_id (int): The role ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteRole($p_role_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteRole(:p_role_id)');
        $stmt->bindValue(':p_role_id', $p_role_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteRolePermission
    # Description: Deletes the role permission.
    #
    # Parameters:
    # - $p_role_permission_id (int): The role permission ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteRolePermission($p_role_permission_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteRolePermission(:p_role_permission_id)');
        $stmt->bindValue(':p_role_permission_id', $p_role_permission_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteRoleSystemActionPermission
    # Description: Deletes the role system action permission.
    #
    # Parameters:
    # - $p_role_system_action_permission_id (int): The role system action permission ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteRoleSystemActionPermission($p_role_system_action_permission_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteRoleSystemActionPermission(:p_role_system_action_permission_id)');
        $stmt->bindValue(':p_role_system_action_permission_id', $p_role_system_action_permission_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteRoleUserAccount
    # Description: Deletes the role user account.
    #
    # Parameters:
    # - $p_role_user_account_id (int): The role user account ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteRoleUserAccount($p_role_user_account_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteRoleUserAccount(:p_role_user_account_id)');
        $stmt->bindValue(':p_role_user_account_id', $p_role_user_account_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getRole
    # Description: Retrieves the details of a role.
    #
    # Parameters:
    # - $p_role_id (int): The role ID.
    #
    # Returns:
    # - An array containing the role details.
    #
    # -------------------------------------------------------------
    public function getRole($p_role_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getRole(:p_role_id)');
        $stmt->bindValue(':p_role_id', $p_role_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>