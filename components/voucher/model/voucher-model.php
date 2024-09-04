<?php
/**
* Class VoucherModel
*
* The VoucherModel class handles voucher related operations and interactions.
*/
class VoucherModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateVoucher
    # Description: Updates the voucher.
    #
    # Parameters:
    # - $p_voucher_id (int): The voucher ID.
    # - $p_voucher_name (string): The voucher name.
    # - $p_voucher_code (string): The voucher code.
    # - $p_voucher_usage_start_date (date): The voucher usage start date.
    # - $p_voucher_usage_end_date (date): The voucher usage end date.
    # - $p_discount_type (string): The discount type.
    # - $p_discount_amount (double): The discount amount.
    # - $p_minimum_booking_amount (double): The minimum booking amount.
    # - $p_voucher_quantity (int): The voucher quantity.
    # - $p_available_voucher (int): The available voucher.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateVoucher($p_voucher_id, $p_voucher_name, $p_voucher_code, $p_voucher_usage_start_date, $p_voucher_usage_end_date, $p_discount_type, $p_discount_amount, $p_minimum_booking_amount, $p_voucher_quantity, $p_available_voucher, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateVoucher(:p_voucher_id, :p_voucher_name, :p_voucher_code, :p_voucher_usage_start_date, :p_voucher_usage_end_date, :p_discount_type, :p_discount_amount, :p_minimum_booking_amount, :p_voucher_quantity, :p_available_voucher, :p_last_log_by)');
        $stmt->bindValue(':p_voucher_id', $p_voucher_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_voucher_name', $p_voucher_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_voucher_code', $p_voucher_code, PDO::PARAM_STR);
        $stmt->bindValue(':p_voucher_usage_start_date', $p_voucher_usage_start_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_voucher_usage_end_date', $p_voucher_usage_end_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_discount_type', $p_discount_type, PDO::PARAM_STR);
        $stmt->bindValue(':p_discount_amount', $p_discount_amount, PDO::PARAM_STR);
        $stmt->bindValue(':p_minimum_booking_amount', $p_minimum_booking_amount, PDO::PARAM_STR);
        $stmt->bindValue(':p_voucher_quantity', $p_voucher_quantity, PDO::PARAM_INT);
        $stmt->bindValue(':p_available_voucher', $p_available_voucher, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertVoucher
    # Description: Inserts the voucher.
    #
    # Parameters:
    # - $p_voucher_name (string): The voucher name.
    # - $p_voucher_code (string): The voucher code.
    # - $p_voucher_usage_start_date (date): The voucher usage start date.
    # - $p_voucher_usage_end_date (date): The voucher usage end date.
    # - $p_discount_type (string): The discount type.
    # - $p_discount_amount (double): The discount amount.
    # - $p_minimum_booking_amount (double): The minimum booking amount.
    # - $p_voucher_quantity (int): The voucher quantity.
    # - $p_available_voucher (int): The available voucher.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertVoucher($p_voucher_name, $p_voucher_code, $p_voucher_usage_start_date, $p_voucher_usage_end_date, $p_discount_type, $p_discount_amount, $p_minimum_booking_amount, $p_voucher_quantity, $p_available_voucher, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertVoucher(:p_voucher_name, :p_voucher_code, :p_voucher_usage_start_date, :p_voucher_usage_end_date, :p_discount_type, :p_discount_amount, :p_minimum_booking_amount, :p_voucher_quantity, :p_available_voucher, :p_last_log_by, @p_voucher_id)');
        $stmt->bindValue(':p_voucher_name', $p_voucher_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_voucher_code', $p_voucher_code, PDO::PARAM_STR);
        $stmt->bindValue(':p_voucher_usage_start_date', $p_voucher_usage_start_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_voucher_usage_end_date', $p_voucher_usage_end_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_discount_type', $p_discount_type, PDO::PARAM_STR);
        $stmt->bindValue(':p_discount_amount', $p_discount_amount, PDO::PARAM_STR);
        $stmt->bindValue(':p_minimum_booking_amount', $p_minimum_booking_amount, PDO::PARAM_STR);
        $stmt->bindValue(':p_voucher_quantity', $p_voucher_quantity, PDO::PARAM_INT);
        $stmt->bindValue(':p_available_voucher', $p_available_voucher, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_voucher_id AS voucher_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['voucher_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkVoucherExist
    # Description: Checks if a voucher exists.
    #
    # Parameters:
    # - $p_voucher_id (int): The voucher ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkVoucherExist($p_voucher_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkVoucherExist(:p_voucher_id)');
        $stmt->bindValue(':p_voucher_id', $p_voucher_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteVoucher
    # Description: Deletes the voucher.
    #
    # Parameters:
    # - $p_voucher_id (int): The voucher ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteVoucher($p_voucher_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteVoucher(:p_voucher_id)');
        $stmt->bindValue(':p_voucher_id', $p_voucher_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getVoucher
    # Description: Retrieves the details of a voucher.
    #
    # Parameters:
    # - $p_voucher_id (int): The voucher ID.
    #
    # Returns:
    # - An array containing the voucher details.
    #
    # -------------------------------------------------------------
    public function getVoucher($p_voucher_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getVoucher(:p_voucher_id)');
        $stmt->bindValue(':p_voucher_id', $p_voucher_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>