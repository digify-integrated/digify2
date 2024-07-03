<?php
/**
* Class ContactInformationTypeModel
*
* The ContactInformationTypeModel class handles contact information type related operations and interactions.
*/
class ContactInformationTypeModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateContactInformationType
    # Description: Updates the contact information type.
    #
    # Parameters:
    # - $p_contact_information_type_id (int): The contact information type ID.
    # - $p_contact_information_type_name (string): The contact information type name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateContactInformationType($p_contact_information_type_id, $p_contact_information_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateContactInformationType(:p_contact_information_type_id, :p_contact_information_type_name, :p_last_log_by)');
        $stmt->bindValue(':p_contact_information_type_id', $p_contact_information_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_contact_information_type_name', $p_contact_information_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertContactInformationType
    # Description: Inserts the contact information type.
    #
    # Parameters:
    # - $p_contact_information_type_name (string): The contact information type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertContactInformationType($p_contact_information_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertContactInformationType(:p_contact_information_type_name, :p_last_log_by, @p_contact_information_type_id)');
        $stmt->bindValue(':p_contact_information_type_name', $p_contact_information_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_contact_information_type_id AS contact_information_type_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['contact_information_type_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkContactInformationTypeExist
    # Description: Checks if a contact information type exists.
    #
    # Parameters:
    # - $p_contact_information_type_id (int): The contact information type ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkContactInformationTypeExist($p_contact_information_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkContactInformationTypeExist(:p_contact_information_type_id)');
        $stmt->bindValue(':p_contact_information_type_id', $p_contact_information_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteContactInformationType
    # Description: Deletes the contact information type.
    #
    # Parameters:
    # - $p_contact_information_type_id (int): The contact information type ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteContactInformationType($p_contact_information_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteContactInformationType(:p_contact_information_type_id)');
        $stmt->bindValue(':p_contact_information_type_id', $p_contact_information_type_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getContactInformationType
    # Description: Retrieves the details of a contact information type.
    #
    # Parameters:
    # - $p_contact_information_type_id (int): The contact information type ID.
    #
    # Returns:
    # - An array containing the contact information type details.
    #
    # -------------------------------------------------------------
    public function getContactInformationType($p_contact_information_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getContactInformationType(:p_contact_information_type_id)');
        $stmt->bindValue(':p_contact_information_type_id', $p_contact_information_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateContactInformationTypeOptions
    # Description: Generates the contact information type options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateContactInformationTypeOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateContactInformationTypeOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $contactInformationTypeID = $row['contact_information_type_id'];
            $contactInformationTypeName = $row['contact_information_type_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($contactInformationTypeID, ENT_QUOTES) . '">' . htmlspecialchars($contactInformationTypeName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>