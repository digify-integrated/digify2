<?php
/**
* Class RelationModel
*
* The RelationModel class handles relation related operations and interactions.
*/
class RelationModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateRelation
    # Description: Updates the relation.
    #
    # Parameters:
    # - $p_relation_id (int): The relation ID.
    # - $p_relation_name (string): The relation name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateRelation($p_relation_id, $p_relation_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateRelation(:p_relation_id, :p_relation_name, :p_last_log_by)');
        $stmt->bindValue(':p_relation_id', $p_relation_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_relation_name', $p_relation_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertRelation
    # Description: Inserts the relation.
    #
    # Parameters:
    # - $p_relation_name (string): The relation name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertRelation($p_relation_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertRelation(:p_relation_name, :p_last_log_by, @p_relation_id)');
        $stmt->bindValue(':p_relation_name', $p_relation_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_relation_id AS relation_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['relation_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkRelationExist
    # Description: Checks if a relation exists.
    #
    # Parameters:
    # - $p_relation_id (int): The relation ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkRelationExist($p_relation_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkRelationExist(:p_relation_id)');
        $stmt->bindValue(':p_relation_id', $p_relation_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteRelation
    # Description: Deletes the relation.
    #
    # Parameters:
    # - $p_relation_id (int): The relation ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteRelation($p_relation_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteRelation(:p_relation_id)');
        $stmt->bindValue(':p_relation_id', $p_relation_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getRelation
    # Description: Retrieves the details of a relation.
    #
    # Parameters:
    # - $p_relation_id (int): The relation ID.
    #
    # Returns:
    # - An array containing the relation details.
    #
    # -------------------------------------------------------------
    public function getRelation($p_relation_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getRelation(:p_relation_id)');
        $stmt->bindValue(':p_relation_id', $p_relation_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateRelationOptions
    # Description: Generates the relation options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateRelationOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateRelationOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $relationID = $row['relation_id'];
            $relationName = $row['relation_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($relationID, ENT_QUOTES) . '">' . htmlspecialchars($relationName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>