<?php
/**
* Class LanguageModel
*
* The LanguageModel class handles language related operations and interactions.
*/
class LanguageModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateLanguage
    # Description: Updates the language.
    #
    # Parameters:
    # - $p_language_id (int): The language ID.
    # - $p_language_name (string): The language name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateLanguage($p_language_id, $p_language_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateLanguage(:p_language_id, :p_language_name, :p_last_log_by)');
        $stmt->bindValue(':p_language_id', $p_language_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_language_name', $p_language_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertLanguage
    # Description: Inserts the language.
    #
    # Parameters:
    # - $p_language_name (string): The language name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertLanguage($p_language_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertLanguage(:p_language_name, :p_last_log_by, @p_language_id)');
        $stmt->bindValue(':p_language_name', $p_language_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_language_id AS language_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['language_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkLanguageExist
    # Description: Checks if a language exists.
    #
    # Parameters:
    # - $p_language_id (int): The language ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkLanguageExist($p_language_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkLanguageExist(:p_language_id)');
        $stmt->bindValue(':p_language_id', $p_language_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteLanguage
    # Description: Deletes the language.
    #
    # Parameters:
    # - $p_language_id (int): The language ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteLanguage($p_language_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteLanguage(:p_language_id)');
        $stmt->bindValue(':p_language_id', $p_language_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getLanguage
    # Description: Retrieves the details of a language.
    #
    # Parameters:
    # - $p_language_id (int): The language ID.
    #
    # Returns:
    # - An array containing the language details.
    #
    # -------------------------------------------------------------
    public function getLanguage($p_language_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getLanguage(:p_language_id)');
        $stmt->bindValue(':p_language_id', $p_language_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateLanguageOptions
    # Description: Generates the language options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateLanguageOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateLanguageOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $languageID = $row['language_id'];
            $languageName = $row['language_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($languageID, ENT_QUOTES) . '">' . htmlspecialchars($languageName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>