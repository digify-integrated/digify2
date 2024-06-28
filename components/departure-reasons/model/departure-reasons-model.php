<?php
/**
* Class DepartureReasonsModel
*
* The DepartureReasonsModel class handles departure reasons related operations and interactions.
*/
class DepartureReasonsModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateDepartureReasons
    # Description: Updates the departure reasons.
    #
    # Parameters:
    # - $p_departure_reasons_id (int): The departure reasons ID.
    # - $p_departure_reasons_name (string): The departure reasons name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateDepartureReasons($p_departure_reasons_id, $p_departure_reasons_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateDepartureReasons(:p_departure_reasons_id, :p_departure_reasons_name, :p_last_log_by)');
        $stmt->bindValue(':p_departure_reasons_id', $p_departure_reasons_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_departure_reasons_name', $p_departure_reasons_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertDepartureReasons
    # Description: Inserts the departure reasons.
    #
    # Parameters:
    # - $p_departure_reasons_name (string): The departure reasons name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertDepartureReasons($p_departure_reasons_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertDepartureReasons(:p_departure_reasons_name, :p_last_log_by, @p_departure_reasons_id)');
        $stmt->bindValue(':p_departure_reasons_name', $p_departure_reasons_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_departure_reasons_id AS departure_reasons_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['departure_reasons_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkDepartureReasonsExist
    # Description: Checks if a departure reasons exists.
    #
    # Parameters:
    # - $p_departure_reasons_id (int): The departure reasons ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkDepartureReasonsExist($p_departure_reasons_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkDepartureReasonsExist(:p_departure_reasons_id)');
        $stmt->bindValue(':p_departure_reasons_id', $p_departure_reasons_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteDepartureReasons
    # Description: Deletes the departure reasons.
    #
    # Parameters:
    # - $p_departure_reasons_id (int): The departure reasons ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteDepartureReasons($p_departure_reasons_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteDepartureReasons(:p_departure_reasons_id)');
        $stmt->bindValue(':p_departure_reasons_id', $p_departure_reasons_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getDepartureReasons
    # Description: Retrieves the details of a departure reasons.
    #
    # Parameters:
    # - $p_departure_reasons_id (int): The departure reasons ID.
    #
    # Returns:
    # - An array containing the departure reasons details.
    #
    # -------------------------------------------------------------
    public function getDepartureReasons($p_departure_reasons_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getDepartureReasons(:p_departure_reasons_id)');
        $stmt->bindValue(':p_departure_reasons_id', $p_departure_reasons_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateDepartureReasonsOptions
    # Description: Generates the departure reasons options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateDepartureReasonsOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateDepartureReasonsOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $departureReasonsID = $row['departure_reasons_id'];
            $departureReasonsName = $row['departure_reasons_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($departureReasonsID, ENT_QUOTES) . '">' . htmlspecialchars($departureReasonsName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>