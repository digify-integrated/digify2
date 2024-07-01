<?php
/**
* Class DepartureReasonModel
*
* The DepartureReasonModel class handles departure reason related operations and interactions.
*/
class DepartureReasonModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateDepartureReason
    # Description: Updates the departure reason.
    #
    # Parameters:
    # - $p_departure_reason_id (int): The departure reason ID.
    # - $p_departure_reason_name (string): The departure reason name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateDepartureReason($p_departure_reason_id, $p_departure_reason_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateDepartureReason(:p_departure_reason_id, :p_departure_reason_name, :p_last_log_by)');
        $stmt->bindValue(':p_departure_reason_id', $p_departure_reason_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_departure_reason_name', $p_departure_reason_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertDepartureReason
    # Description: Inserts the departure reason.
    #
    # Parameters:
    # - $p_departure_reason_name (string): The departure reason name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertDepartureReason($p_departure_reason_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertDepartureReason(:p_departure_reason_name, :p_last_log_by, @p_departure_reason_id)');
        $stmt->bindValue(':p_departure_reason_name', $p_departure_reason_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_departure_reason_id AS departure_reason_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['departure_reason_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkDepartureReasonExist
    # Description: Checks if a departure reason exists.
    #
    # Parameters:
    # - $p_departure_reason_id (int): The departure reason ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkDepartureReasonExist($p_departure_reason_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkDepartureReasonExist(:p_departure_reason_id)');
        $stmt->bindValue(':p_departure_reason_id', $p_departure_reason_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteDepartureReason
    # Description: Deletes the departure reason.
    #
    # Parameters:
    # - $p_departure_reason_id (int): The departure reason ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteDepartureReason($p_departure_reason_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteDepartureReason(:p_departure_reason_id)');
        $stmt->bindValue(':p_departure_reason_id', $p_departure_reason_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getDepartureReason
    # Description: Retrieves the details of a departure reason.
    #
    # Parameters:
    # - $p_departure_reason_id (int): The departure reason ID.
    #
    # Returns:
    # - An array containing the departure reason details.
    #
    # -------------------------------------------------------------
    public function getDepartureReason($p_departure_reason_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getDepartureReason(:p_departure_reason_id)');
        $stmt->bindValue(':p_departure_reason_id', $p_departure_reason_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateDepartureReasonOptions
    # Description: Generates the departure reason options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateDepartureReasonOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateDepartureReasonOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $departureReasonID = $row['departure_reason_id'];
            $departureReasonName = $row['departure_reason_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($departureReasonID, ENT_QUOTES) . '">' . htmlspecialchars($departureReasonName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>