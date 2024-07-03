<?php
/**
* Class ReligionModel
*
* The ReligionModel class handles religion related operations and interactions.
*/
class ReligionModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateReligion
    # Description: Updates the religion.
    #
    # Parameters:
    # - $p_religion_id (int): The religion ID.
    # - $p_religion_name (string): The religion name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateReligion($p_religion_id, $p_religion_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateReligion(:p_religion_id, :p_religion_name, :p_last_log_by)');
        $stmt->bindValue(':p_religion_id', $p_religion_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_religion_name', $p_religion_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertReligion
    # Description: Inserts the religion.
    #
    # Parameters:
    # - $p_religion_name (string): The religion name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertReligion($p_religion_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertReligion(:p_religion_name, :p_last_log_by, @p_religion_id)');
        $stmt->bindValue(':p_religion_name', $p_religion_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_religion_id AS religion_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['religion_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkReligionExist
    # Description: Checks if a religion exists.
    #
    # Parameters:
    # - $p_religion_id (int): The religion ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkReligionExist($p_religion_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkReligionExist(:p_religion_id)');
        $stmt->bindValue(':p_religion_id', $p_religion_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteReligion
    # Description: Deletes the religion.
    #
    # Parameters:
    # - $p_religion_id (int): The religion ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteReligion($p_religion_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteReligion(:p_religion_id)');
        $stmt->bindValue(':p_religion_id', $p_religion_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getReligion
    # Description: Retrieves the details of a religion.
    #
    # Parameters:
    # - $p_religion_id (int): The religion ID.
    #
    # Returns:
    # - An array containing the religion details.
    #
    # -------------------------------------------------------------
    public function getReligion($p_religion_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getReligion(:p_religion_id)');
        $stmt->bindValue(':p_religion_id', $p_religion_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateReligionOptions
    # Description: Generates the religion options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateReligionOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateReligionOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $religionID = $row['religion_id'];
            $religionName = $row['religion_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($religionID, ENT_QUOTES) . '">' . htmlspecialchars($religionName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>