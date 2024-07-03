<?php
/**
* Class GenderModel
*
* The GenderModel class handles gender related operations and interactions.
*/
class GenderModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateGender
    # Description: Updates the gender.
    #
    # Parameters:
    # - $p_gender_id (int): The gender ID.
    # - $p_gender_name (string): The gender name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateGender($p_gender_id, $p_gender_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateGender(:p_gender_id, :p_gender_name, :p_last_log_by)');
        $stmt->bindValue(':p_gender_id', $p_gender_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_gender_name', $p_gender_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertGender
    # Description: Inserts the gender.
    #
    # Parameters:
    # - $p_gender_name (string): The gender name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertGender($p_gender_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertGender(:p_gender_name, :p_last_log_by, @p_gender_id)');
        $stmt->bindValue(':p_gender_name', $p_gender_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_gender_id AS gender_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['gender_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkGenderExist
    # Description: Checks if a gender exists.
    #
    # Parameters:
    # - $p_gender_id (int): The gender ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkGenderExist($p_gender_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkGenderExist(:p_gender_id)');
        $stmt->bindValue(':p_gender_id', $p_gender_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteGender
    # Description: Deletes the gender.
    #
    # Parameters:
    # - $p_gender_id (int): The gender ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteGender($p_gender_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteGender(:p_gender_id)');
        $stmt->bindValue(':p_gender_id', $p_gender_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getGender
    # Description: Retrieves the details of a gender.
    #
    # Parameters:
    # - $p_gender_id (int): The gender ID.
    #
    # Returns:
    # - An array containing the gender details.
    #
    # -------------------------------------------------------------
    public function getGender($p_gender_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getGender(:p_gender_id)');
        $stmt->bindValue(':p_gender_id', $p_gender_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateGenderOptions
    # Description: Generates the gender options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateGenderOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateGenderOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $genderID = $row['gender_id'];
            $genderName = $row['gender_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($genderID, ENT_QUOTES) . '">' . htmlspecialchars($genderName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>