<?php
/**
* Class AddressTypeModel
*
* The AddressTypeModel class handles address type related operations and interactions.
*/
class AddressTypeModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateAddressType
    # Description: Updates the address type.
    #
    # Parameters:
    # - $p_address_type_id (int): The address type ID.
    # - $p_address_type_name (string): The address type name.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateAddressType($p_address_type_id, $p_address_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateAddressType(:p_address_type_id, :p_address_type_name, :p_last_log_by)');
        $stmt->bindValue(':p_address_type_id', $p_address_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_address_type_name', $p_address_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertAddressType
    # Description: Inserts the address type.
    #
    # Parameters:
    # - $p_address_type_name (string): The address type name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertAddressType($p_address_type_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertAddressType(:p_address_type_name, :p_last_log_by, @p_address_type_id)');
        $stmt->bindValue(':p_address_type_name', $p_address_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_address_type_id AS address_type_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['address_type_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkAddressTypeExist
    # Description: Checks if a address type exists.
    #
    # Parameters:
    # - $p_address_type_id (int): The address type ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkAddressTypeExist($p_address_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkAddressTypeExist(:p_address_type_id)');
        $stmt->bindValue(':p_address_type_id', $p_address_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteAddressType
    # Description: Deletes the address type.
    #
    # Parameters:
    # - $p_address_type_id (int): The address type ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteAddressType($p_address_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteAddressType(:p_address_type_id)');
        $stmt->bindValue(':p_address_type_id', $p_address_type_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getAddressType
    # Description: Retrieves the details of a address type.
    #
    # Parameters:
    # - $p_address_type_id (int): The address type ID.
    #
    # Returns:
    # - An array containing the address type details.
    #
    # -------------------------------------------------------------
    public function getAddressType($p_address_type_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getAddressType(:p_address_type_id)');
        $stmt->bindValue(':p_address_type_id', $p_address_type_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateAddressTypeOptions
    # Description: Generates the address type options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateAddressTypeOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateAddressTypeOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $addressTypeID = $row['address_type_id'];
            $addressTypeName = $row['address_type_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($addressTypeID, ENT_QUOTES) . '">' . htmlspecialchars($addressTypeName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>