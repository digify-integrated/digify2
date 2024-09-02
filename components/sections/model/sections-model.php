<?php
/**
* Class SectionsModel
*
* The SectionsModel class handles sections related operations and interactions.
*/
class SectionsModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateSections
    # Description: Updates the sections.
    #
    # Parameters:
    # - $p_sections_id (int): The sections ID.
    # - $p_sections_name (string): The sections name.
    # - $p_description (string): The sections description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateSections($p_sections_id, $p_sections_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateSections(:p_sections_id, :p_sections_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_sections_id', $p_sections_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_sections_name', $p_sections_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateSectionsPublishStatus
    # Description: Updates the sections publish status.
    #
    # Parameters:
    # - $p_sections_item_id (int): The sections item ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateSectionsPublishStatus($p_sections_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateSectionsPublishStatus(:p_sections_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_sections_id', $p_sections_id, PDO::PARAM_INT);
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
    # Function: insertSections
    # Description: Inserts the sections.
    #
    # Parameters:
    # - $p_sections_name (string): The sections name.
    # - $p_description (string): The sections description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertSections($p_sections_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertSections(:p_sections_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_sections_id)');
        $stmt->bindValue(':p_sections_name', $p_sections_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_sections_id AS sections_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['sections_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkSectionsExist
    # Description: Checks if a sections exists.
    #
    # Parameters:
    # - $p_sections_id (int): The sections ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkSectionsExist($p_sections_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkSectionsExist(:p_sections_id)');
        $stmt->bindValue(':p_sections_id', $p_sections_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteSections
    # Description: Deletes the sections.
    #
    # Parameters:
    # - $p_sections_id (int): The sections ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteSections($p_sections_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteSections(:p_sections_id)');
        $stmt->bindValue(':p_sections_id', $p_sections_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getSections
    # Description: Retrieves the details of a sections.
    #
    # Parameters:
    # - $p_sections_id (int): The sections ID.
    #
    # Returns:
    # - An array containing the sections details.
    #
    # -------------------------------------------------------------
    public function getSections($p_sections_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getSections(:p_sections_id)');
        $stmt->bindValue(':p_sections_id', $p_sections_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateSectionsOptions
    # Description: Generates the sections options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateSectionsOptions($p_sections_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateSectionsOptions(:p_sections_id)');
        $stmt->bindValue(':p_sections_id', $p_sections_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $sectionsID = $row['sections_id'];
            $sectionsName = $row['sections_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($sectionsID, ENT_QUOTES) . '">' . htmlspecialchars($sectionsName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>