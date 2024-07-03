<?php
/**
* Class BloodTypeModel
*
* The BloodTypeModel class handles blood type related operations and interactions.
*/
class BloodTypeModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateBloodType
    # Description: Updates the blood type.
    #
    # Parameters:
    # - $p_blood_type_id (int): The blood type ID.
    # - $p_blood_type_name (string): The blood type name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateBloodType($p_blood_type_id, $p_blood_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateBloodType(:p_blood_type_id, :p_blood_type_name, :p_last_log_by)');
        $stmt->bindValue(':p_blood_type_id', $p_blood_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_blood_type_name', $p_blood_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertBloodType
    # Description: Inserts the blood type.
    #
    # Parameters:
    # - $p_blood_type_name (string): The blood type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertBloodType($p_blood_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertBloodType(:p_blood_type_name, :p_last_log_by, @p_blood_type_id)');
        $stmt->bindValue(':p_blood_type_name', $p_blood_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_blood_type_id AS blood_type_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['blood_type_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkBloodTypeExist
    # Description: Checks if a blood type exists.
    #
    # Parameters:
    # - $p_blood_type_id (int): The blood type ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkBloodTypeExist($p_blood_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkBloodTypeExist(:p_blood_type_id)');
        $stmt->bindValue(':p_blood_type_id', $p_blood_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteBloodType
    # Description: Deletes the blood type.
    #
    # Parameters:
    # - $p_blood_type_id (int): The blood type ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteBloodType($p_blood_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteBloodType(:p_blood_type_id)');
        $stmt->bindValue(':p_blood_type_id', $p_blood_type_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getBloodType
    # Description: Retrieves the details of a blood type.
    #
    # Parameters:
    # - $p_blood_type_id (int): The blood type ID.
    #
    # Returns:
    # - An array containing the blood type details.
    #
    # -------------------------------------------------------------
    public function getBloodType($p_blood_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getBloodType(:p_blood_type_id)');
        $stmt->bindValue(':p_blood_type_id', $p_blood_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateBloodTypeOptions
    # Description: Generates the blood type options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateBloodTypeOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateBloodTypeOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $bloodTypeID = $row['blood_type_id'];
            $bloodTypeName = $row['blood_type_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($bloodTypeID, ENT_QUOTES) . '">' . htmlspecialchars($bloodTypeName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>