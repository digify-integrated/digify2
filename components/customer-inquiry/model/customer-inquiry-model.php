<?php
/**
* Class CustomerInquiryModel
*
* The CustomerInquiryModel class handles customer inquiry related operations and interactions.
*/
class CustomerInquiryModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerInquiry
    # Description: Updates the customer inquiry.
    #
    # Parameters:
    # - $p_customer_inquiry_id (int): The customer inquiry ID.
    # - $p_customer_name (string): The customer name.
    # - $p_email (string): The email.
    # - $p_phone (string): The phone.
    # - $p_subject (string): The subject.
    # - $p_message (string): The message.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerInquiry($p_customer_inquiry_id, $p_customer_name, $p_email, $p_phone, $p_subject, $p_message, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerInquiry(:p_customer_inquiry_id, :p_customer_name, :p_email, :p_phone, :p_subject, :p_message, :p_last_log_by)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_name', $p_customer_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->bindValue(':p_phone', $p_phone, PDO::PARAM_STR);
        $stmt->bindValue(':p_subject', $p_subject, PDO::PARAM_STR);
        $stmt->bindValue(':p_message', $p_message, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerInquiryStatus
    # Description: Updates the customer inquiry status.
    #
    # Parameters:
    # - $p_customer_inquiry_id (int): The customer inquiry ID.
    # - $p_inquiry_status (string): The inquiry status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerInquiryStatus($p_customer_inquiry_id, $p_inquiry_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerInquiryStatus(:p_customer_inquiry_id, :p_inquiry_status, :p_last_log_by)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_inquiry_status', $p_inquiry_status, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertCustomerInquiry
    # Description: Inserts the customer inquiry.
    #
    # Parameters:
    # - $p_customer_name (string): The customer name.
    # - $p_email (string): The email.
    # - $p_phone (string): The phone.
    # - $p_subject (string): The subject.
    # - $p_message (string): The message.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertCustomerInquiry($p_customer_name, $p_email, $p_phone, $p_subject, $p_message, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCustomerInquiry(:p_customer_name, :p_email, :p_phone, :p_subject, :p_message, :p_last_log_by, @p_customer_inquiry_id)');
        $stmt->bindValue(':p_customer_name', $p_customer_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->bindValue(':p_phone', $p_phone, PDO::PARAM_STR);
        $stmt->bindValue(':p_subject', $p_subject, PDO::PARAM_STR);
        $stmt->bindValue(':p_message', $p_message, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();

        $result = $this->db->getConnection()->query('SELECT @p_customer_inquiry_id AS customer_inquiry_id');
        $customerInquiryID = $result->fetch(PDO::FETCH_ASSOC)['customer_inquiry_id'];
        
        return $customerInquiryID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkCustomerInquiryExist
    # Description: Checks if a customer inquiry exists.
    #
    # Parameters:
    # - $p_customer_inquiry_id (int): The customer inquiry ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCustomerInquiryExist($p_customer_inquiry_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCustomerInquiryExist(:p_customer_inquiry_id)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCustomerInquiry
    # Description: Deletes the customer inquiry.
    #
    # Parameters:
    # - $p_customer_inquiry_id (int): The customer inquiry ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCustomerInquiry($p_customer_inquiry_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCustomerInquiry(:p_customer_inquiry_id)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCustomerInquiry
    # Description: Retrieves the details of a customer inquiry.
    #
    # Parameters:
    # - $p_customer_inquiry_id (int): The customer inquiry ID.
    #
    # Returns:
    # - An array containing the customer inquiry details.
    #
    # -------------------------------------------------------------
    public function getCustomerInquiry($p_customer_inquiry_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCustomerInquiry(:p_customer_inquiry_id)');
        $stmt->bindValue(':p_customer_inquiry_id', $p_customer_inquiry_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>