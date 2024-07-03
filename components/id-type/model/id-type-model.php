<?php
/**
* Class IDTypeModel
*
* The IDTypeModel class handles id type related operations and interactions.
*/
class IDTypeModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateIDType
    # Description: Updates the id type.
    #
    # Parameters:
    # - $p_id_type_id (int): The id type ID.
    # - $p_id_type_name (string): The id type name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateIDType($p_id_type_id, $p_id_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateIDType(:p_id_type_id, :p_id_type_name, :p_last_log_by)');
        $stmt->bindValue(':p_id_type_id', $p_id_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_id_type_name', $p_id_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertIDType
    # Description: Inserts the id type.
    #
    # Parameters:
    # - $p_id_type_name (string): The id type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertIDType($p_id_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertIDType(:p_id_type_name, :p_last_log_by, @p_id_type_id)');
        $stmt->bindValue(':p_id_type_name', $p_id_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_id_type_id AS id_type_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['id_type_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkIDTypeExist
    # Description: Checks if a id type exists.
    #
    # Parameters:
    # - $p_id_type_id (int): The id type ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkIDTypeExist($p_id_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkIDTypeExist(:p_id_type_id)');
        $stmt->bindValue(':p_id_type_id', $p_id_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteIDType
    # Description: Deletes the id type.
    #
    # Parameters:
    # - $p_id_type_id (int): The id type ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteIDType($p_id_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteIDType(:p_id_type_id)');
        $stmt->bindValue(':p_id_type_id', $p_id_type_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getIDType
    # Description: Retrieves the details of a id type.
    #
    # Parameters:
    # - $p_id_type_id (int): The id type ID.
    #
    # Returns:
    # - An array containing the id type details.
    #
    # -------------------------------------------------------------
    public function getIDType($p_id_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getIDType(:p_id_type_id)');
        $stmt->bindValue(':p_id_type_id', $p_id_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateIDTypeOptions
    # Description: Generates the id type options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateIDTypeOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateIDTypeOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $idTypeID = $row['id_type_id'];
            $idTypeName = $row['id_type_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($idTypeID, ENT_QUOTES) . '">' . htmlspecialchars($idTypeName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>