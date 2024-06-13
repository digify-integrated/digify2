<?php
/**
* Class AppModuleModel
*
* The AppModuleModel class handles app module related operations and interactions.
*/
class AppModuleModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateAppModule
    # Description: Updates the app module.
    #
    # Parameters:
    # - $p_app_module_id (int): The app module ID.
    # - $p_app_module_name (string): The app module name.
    # - $p_app_module_description (string): The app module description.
    # - $p_order_sequence (int): The order sequence of app module.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateAppModule($p_app_module_id, $p_app_module_name, $p_app_module_description, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateAppModule(:p_app_module_id, :p_app_module_name, :p_app_module_description, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_app_module_id', $p_app_module_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_app_module_name', $p_app_module_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_app_module_description', $p_app_module_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateAppLogo
    # Description: Updates the app logo.
    #
    # Parameters:
    # - $p_app_module_id (int): The app ID.
    # - $p_app_logo (string): The logo of the app.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateAppLogo($p_app_module_id, $p_app_logo, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateAppLogo(:p_app_module_id, :p_app_logo, :p_last_log_by)');
        $stmt->bindValue(':p_app_module_id', $p_app_module_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_app_logo', $p_app_logo, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertAppModule
    # Description: Inserts the app module.
    #
    # Parameters:
    # - $p_app_module_name (string): The app module name.
    # - $p_app_module_description (string): The app module description.
    # - $p_order_sequence (int): The order sequence of app module.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertAppModule($p_app_module_name, $p_app_module_description, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertAppModule(:p_app_module_name, :p_app_module_description, :p_order_sequence, :p_last_log_by, @p_app_module_id)');
        $stmt->bindValue(':p_app_module_name', $p_app_module_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_app_module_description', $p_app_module_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_app_module_id AS app_module_id');
        $menuGroupID = $result->fetch(PDO::FETCH_ASSOC)['app_module_id'];
        
        return $menuGroupID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkAppModuleExist
    # Description: Checks if a app module exists.
    #
    # Parameters:
    # - $p_app_module_id (int): The app module ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkAppModuleExist($p_app_module_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkAppModuleExist(:p_app_module_id)');
        $stmt->bindValue(':p_app_module_id', $p_app_module_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteAppModule
    # Description: Deletes the app module.
    #
    # Parameters:
    # - $p_app_module_id (int): The app module ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteAppModule($p_app_module_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteAppModule(:p_app_module_id)');
        $stmt->bindValue(':p_app_module_id', $p_app_module_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getAppModule
    # Description: Retrieves the details of a app module.
    #
    # Parameters:
    # - $p_app_module_id (int): The app module ID.
    #
    # Returns:
    # - An array containing the app module details.
    #
    # -------------------------------------------------------------
    public function getAppModule($p_app_module_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getAppModule(:p_app_module_id)');
        $stmt->bindValue(':p_app_module_id', $p_app_module_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateAppModuleOptions
    # Description: Generates the app module options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateAppModuleOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateAppModuleOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $menuGroupID = $row['app_module_id'];
            $menuGroupName = $row['app_module_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($menuGroupID, ENT_QUOTES) . '">' . htmlspecialchars($menuGroupName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>