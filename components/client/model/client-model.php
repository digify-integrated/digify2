<?php
/**
* Class ClientModel
*
* The ClientModel class handles client related operations and interactions.
*/
class ClientModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateClient
    # Description: Updates the client.
    #
    # Parameters:
    # - $p_client_id (int): The client ID.
    # - $p_client_name (string): The client name.
    # - $p_description (string): The client description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateClient($p_client_id, $p_client_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateClient(:p_client_id, :p_client_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_client_id', $p_client_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_client_name', $p_client_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateClientItem
    # Description: Updates the client item.
    #
    # Parameters:
    # - $p_client_item_id (int): The client item ID.
    # - $p_client_id (int): The client ID.
    # - $p_client_logo (string): The client logo.
    # - $p_client_url (string): The client logo.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateClientItem($p_client_item_id, $p_client_id, $p_client_logo, $p_client_url, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateClientItem(:p_client_item_id, :p_client_id, :p_client_logo, :p_client_url, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_client_item_id', $p_client_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_client_id', $p_client_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_client_logo', $p_client_logo, PDO::PARAM_STR);
        $stmt->bindValue(':p_client_url', $p_client_url, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateClientPublishStatus
    # Description: Updates the client publish status.
    #
    # Parameters:
    # - $p_client_item_id (int): The client item ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateClientPublishStatus($p_client_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateClientPublishStatus(:p_client_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_client_id', $p_client_id, PDO::PARAM_INT);
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
    # Function: insertClient
    # Description: Inserts the client.
    #
    # Parameters:
    # - $p_client_name (string): The client name.
    # - $p_description (string): The client description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertClient($p_client_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertClient(:p_client_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_client_id)');
        $stmt->bindValue(':p_client_name', $p_client_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_client_id AS client_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['client_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertClientItem
    # Description: Inserts the client item.
    #
    # Parameters:
    # - $p_client_id (int): The client ID.
    # - $p_client_logo (string): The client logo.
    # - $p_client_url (string): The client URL.
    # - $p_order_sequence (int): The order sequence.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertClientItem($p_client_id, $p_client_logo, $p_client_url, $p_order_sequence, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertClientItem(:p_client_id, :p_client_logo, :p_client_url, :p_order_sequence, :p_last_log_by)');
        $stmt->bindValue(':p_client_id', $p_client_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_client_logo', $p_client_logo, PDO::PARAM_STR);
        $stmt->bindValue(':p_client_url', $p_client_url, PDO::PARAM_STR);
        $stmt->bindValue(':p_order_sequence', $p_order_sequence, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkClientExist
    # Description: Checks if a client exists.
    #
    # Parameters:
    # - $p_client_id (int): The client ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkClientExist($p_client_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkClientExist(:p_client_id)');
        $stmt->bindValue(':p_client_id', $p_client_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkClientItemExist
    # Description: Checks if a client item exists.
    #
    # Parameters:
    # - $p_client_item_id (int): The client item ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkClientItemExist($p_client_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkClientItemExist(:p_client_item_id)');
        $stmt->bindValue(':p_client_item_id', $p_client_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteClient
    # Description: Deletes the client.
    #
    # Parameters:
    # - $p_client_id (int): The client ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteClient($p_client_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteClient(:p_client_id)');
        $stmt->bindValue(':p_client_id', $p_client_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteClientItem
    # Description: Deletes the client item.
    #
    # Parameters:
    # - $p_client_item_id (int): The client item ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteClientItem($p_client_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteClientItem(:p_client_item_id)');
        $stmt->bindValue(':p_client_item_id', $p_client_item_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getClient
    # Description: Retrieves the details of a client.
    #
    # Parameters:
    # - $p_client_id (int): The client ID.
    #
    # Returns:
    # - An array containing the client details.
    #
    # -------------------------------------------------------------
    public function getClient($p_client_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getClient(:p_client_id)');
        $stmt->bindValue(':p_client_id', $p_client_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getClientItem
    # Description: Retrieves the details of a client item.
    #
    # Parameters:
    # - $p_client_item_id (int): The client ID.
    #
    # Returns:
    # - An array containing the client details.
    #
    # -------------------------------------------------------------
    public function getClientItem($p_client_item_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getClientItem(:p_client_item_id)');
        $stmt->bindValue(':p_client_item_id', $p_client_item_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getClientItemByClientID
    # Description: Retrieves the details of a client item.
    #
    # Parameters:
    # - $p_client_id (int): The client ID.
    #
    # Returns:
    # - An array containing the client details.
    #
    # -------------------------------------------------------------
    public function getClientItemByClientID($p_client_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getClientItemByClientID(:p_client_id)');
        $stmt->bindValue(':p_client_id', $p_client_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateClientOptions
    # Description: Generates the client options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateClientOptions($p_client_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateClientOptions(:p_client_id)');
        $stmt->bindValue(':p_client_id', $p_client_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $clientID = $row['client_id'];
            $clientName = $row['client_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($clientID, ENT_QUOTES) . '">' . htmlspecialchars($clientName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>