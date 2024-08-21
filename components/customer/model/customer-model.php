<?php
/**
* Class CustomerModel
*
* The CustomerModel class handles customer related operations and interactions.
*/
class CustomerModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerAbout
    # Description: Updates the customer about.
    #
    # Parameters:
    # - $p_customer_id (int): The customer ID.
    # - $p_about (string): The about.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerAbout($p_customer_id, $p_about, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerAbout(:p_customer_id, :p_about, :p_last_log_by)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_about', $p_about, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerPrivateInformation
    # Description: Updates the customer private information.
    #
    # Parameters:
    # - $p_customer_id (int): The customer ID.
    # - $p_full_name (string): The full name.
    # - $p_first_name (string): The first name.
    # - $p_middle_name (string): The middle name.
    # - $p_last_name (string): The last name.
    # - $p_suffix (string): The suffix.
    # - $p_nickname (string): The nickname.
    # - $p_civil_status_id (int): The civil status ID.
    # - $p_civil_status_name (string): The civil status name.
    # - $p_gender_id (int): The gender ID.
    # - $p_gender_name (string): The gender name.
    # - $p_birthday (date): The birthday.
    # - $p_birth_place (date): The birth place.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerPrivateInformation($p_customer_id, $p_full_name, $p_first_name, $p_middle_name, $p_last_name, $p_suffix, $p_nickname, $p_civil_status_id, $p_civil_status_name, $p_gender_id, $p_gender_name, $p_birthday, $p_birth_place, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerPrivateInformation(:p_customer_id, :p_full_name, :p_first_name, :p_middle_name, :p_last_name, :p_suffix, :p_nickname, :p_civil_status_id, :p_civil_status_name, :p_gender_id, :p_gender_name, :p_birthday, :p_birth_place, :p_last_log_by)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_full_name', $p_full_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_first_name', $p_first_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_middle_name', $p_middle_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_name', $p_last_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_suffix', $p_suffix, PDO::PARAM_STR);
        $stmt->bindValue(':p_nickname', $p_nickname, PDO::PARAM_STR);
        $stmt->bindValue(':p_civil_status_id', $p_civil_status_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_civil_status_name', $p_civil_status_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_gender_id', $p_gender_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_gender_name', $p_gender_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_birthday', $p_birthday, PDO::PARAM_STR);
        $stmt->bindValue(':p_birth_place', $p_birth_place, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerAddress
    # Description: Updates the customer address.
    #
    # Parameters:
    # - $p_customer_address_id (int): The customer address ID.
    # - $p_customer_id (int): The customer ID.
    # - $p_address_type_id (int): The address type ID.
    # - $p_address_type_name (string): The address type name.
    # - $p_address (string): The address.
    # - $p_city_id (int): The city ID.
    # - $p_city_name (string): The city name.
    # - $p_state_id (int): The state ID.
    # - $p_state_name (string): The state name.
    # - $p_country_id (int): The country ID.
    # - $p_country_name (string): The country name.
    # - $p_telephone (string): The telephone.
    # - $p_mobile (string): The mobile.
    # - $p_email (string): The email.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerAddress($p_customer_address_id, $p_customer_id, $p_address_type_id, $p_address_type_name, $p_address, $p_city_id, $p_city_name, $p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_telephone, $p_mobile, $p_email, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerAddress(:p_customer_address_id, :p_customer_id, :p_address_type_id, :p_address_type_name, :p_address, :p_city_id, :p_city_name, :p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_telephone, :p_mobile, :p_email, :p_last_log_by)');
        $stmt->bindValue(':p_customer_address_id', $p_customer_address_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_address_type_id', $p_address_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_address_type_name', $p_address_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_address', $p_address, PDO::PARAM_STR);
        $stmt->bindValue(':p_city_id', $p_city_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_city_name', $p_city_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_state_id', $p_state_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_state_name', $p_state_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_country_id', $p_country_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_country_name', $p_country_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_telephone', $p_telephone, PDO::PARAM_STR);
        $stmt->bindValue(':p_mobile', $p_mobile, PDO::PARAM_STR);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerBankAccount
    # Description: Updates the customer bank account.
    #
    # Parameters:
    # - $p_customer_bank_account_id (int): The customer bank account ID.
    # - $p_customer_id (int): The customer ID.
    # - $p_bank_id (int): The bank ID.
    # - $p_bank_name (string): The bank name.
    # - $p_bank_account_type_id (int): The bank account type ID.
    # - $p_bank_account_type_name (string): The bank account type name.
    # - $p_account_number (string): The account number.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerBankAccount($p_customer_bank_account_id, $p_customer_id, $p_bank_id, $p_bank_name, $p_bank_account_type_id, $p_bank_account_type_name, $p_account_number, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerBankAccount(:p_customer_bank_account_id, :p_customer_id, :p_bank_id, :p_bank_name, :p_bank_account_type_id, :p_bank_account_type_name, :p_account_number, :p_last_log_by)');
        $stmt->bindValue(':p_customer_bank_account_id', $p_customer_bank_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_id', $p_bank_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_name', $p_bank_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_bank_account_type_id', $p_bank_account_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_account_type_name', $p_bank_account_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_account_number', $p_account_number, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerBankCard
    # Description: Updates the customer bank card.
    #
    # Parameters:
    # - $p_customer_bank_card_id (int): The customer bank card ID.
    # - $p_customer_id (int): The customer ID.
    # - $p_name_on_card (string): The name on card.
    # - $p_card_number (string): The card number.
    # - $p_expiry_date (string): The expiry date.
    # - $p_cvv (string): The CVV.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerBankCard($p_customer_bank_card_id, $p_customer_id, $p_name_on_card, $p_card_number, $p_expiry_date, $p_cvv, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerBankCard(:p_customer_bank_card_id, :p_customer_id, :p_name_on_card, :p_card_number, :p_expiry_date, :p_cvv, :p_last_log_by)');
        $stmt->bindValue(':p_customer_bank_card_id', $p_customer_bank_card_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_name_on_card', $p_name_on_card, PDO::PARAM_STR);
        $stmt->bindValue(':p_card_number', $p_card_number, PDO::PARAM_STR);
        $stmt->bindValue(':p_expiry_date', $p_expiry_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_cvv', $p_cvv, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerAddressDefault
    # Description: Updates the customer address to default.
    #
    # Parameters:
    # - $p_customer_address_id (int): The customer ID.
    # - $p_customer_id (int): The customer ID.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerAddressDefault($p_customer_address_id, $p_customer_id, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerAddressDefault(:p_customer_address_id, :p_customer_id, :p_last_log_by)');
        $stmt->bindValue(':p_customer_address_id', $p_customer_address_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerBankCardDefault
    # Description: Updates the customer bank card to default.
    #
    # Parameters:
    # - $p_customer_bank_card_id (int): The customer ID.
    # - $p_customer_id (int): The customer ID.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerBankCardDefault($p_customer_bank_card_id, $p_customer_id, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerBankCardDefault(:p_customer_bank_card_id, :p_customer_id, :p_last_log_by)');
        $stmt->bindValue(':p_customer_bank_card_id', $p_customer_bank_card_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerIDRecord
    # Description: Updates the customer ID record.
    #
    # Parameters:
    # - $p_customer_id_record_id (int): The customer ID record ID.
    # - $p_customer_id (int): The customer ID.
    # - $p_id_type_id (int): The ID type ID.
    # - $p_id_type_name (string): The ID type name.
    # - $p_id_number (string): The ID number.
    # - $p_issue_date (date): The issue date.
    # - $p_expiration_date (date): The ID expiration date.
    # - $p_issuing_authority (string): The issuing authority.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerIDRecord($p_customer_id_record_id, $p_customer_id, $p_id_type_id, $p_id_type_name, $p_id_number, $p_issue_date, $p_expiration_date, $p_issuing_authority, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerIDRecord(:p_customer_id_record_id, :p_customer_id, :p_id_type_id, :p_id_type_name, :p_id_number, :p_issue_date, :p_expiration_date, :p_issuing_authority, :p_last_log_by)');
        $stmt->bindValue(':p_customer_id_record_id', $p_customer_id_record_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_id_type_id', $p_id_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_id_type_name', $p_id_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_id_number', $p_id_number, PDO::PARAM_STR);
        $stmt->bindValue(':p_issue_date', $p_issue_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_expiration_date', $p_expiration_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_issuing_authority', $p_issuing_authority, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerImage
    # Description: Updates the customer image.
    #
    # Parameters:
    # - $p_customer_id (int): The customer ID.
    # - $p_customer_image (string): The customer image path file.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerImage($p_customer_id, $p_customer_image, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerImage(:p_customer_id, :p_customer_image, :p_last_log_by)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_image', $p_customer_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerIDRecordImage
    # Description: Updates the customer ID record image.
    #
    # Parameters:
    # - $p_customer_id (int): The customer ID.
    # - $p_id_image (string): The customer ID record image path file.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerIDRecordImage($p_customer_id, $p_id_image, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerIDRecordImage(:p_customer_id, :p_id_image, :p_last_log_by)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_id_image', $p_id_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCustomerStatus
    # Description: Updates the customer stauts.
    #
    # Parameters:
    # - $p_customer_id (int): The customer ID.
    # - $p_customer_status (string): The employment status.
    # - $p_offboard_date (string): The offboard date.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCustomerStatus($p_customer_id, $p_customer_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCustomerStatus(:p_customer_id, :p_customer_status, :p_last_log_by)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_status', $p_customer_status, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertCustomer
    # Description: Inserts the customer.
    #
    # Parameters:
    # - $p_full_name (string): The full name.
    # - $p_first_name (string): The first name.
    # - $p_middle_name (string): The middle name.
    # - $p_last_name (string): The last name.
    # - $p_suffix (string): The suffix.
    # - $p_nickname (string): The nickname.
    # - $p_civil_status_id (int): The civil status ID.
    # - $p_civil_status_name (string): The civil status name.
    # - $p_gender_id (int): The gender ID.
    # - $p_gender_name (string): The gender name.
    # - $p_birthday (date): The birthday.
    # - $p_birth_place (date): The birth place.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertCustomer($p_full_name, $p_first_name, $p_middle_name, $p_last_name, $p_suffix, $p_nickname, $p_civil_status_id, $p_civil_status_name, $p_gender_id, $p_gender_name, $p_birthday, $p_birth_place, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCustomer(:p_full_name, :p_first_name, :p_middle_name, :p_last_name, :p_suffix, :p_nickname, :p_civil_status_id, :p_civil_status_name, :p_gender_id, :p_gender_name, :p_birthday, :p_birth_place, :p_last_log_by, @p_customer_id)');
        $stmt->bindValue(':p_full_name', $p_full_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_first_name', $p_first_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_middle_name', $p_middle_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_name', $p_last_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_suffix', $p_suffix, PDO::PARAM_STR);
        $stmt->bindValue(':p_nickname', $p_nickname, PDO::PARAM_STR);
        $stmt->bindValue(':p_civil_status_id', $p_civil_status_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_civil_status_name', $p_civil_status_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_gender_id', $p_gender_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_gender_name', $p_gender_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_birthday', $p_birthday, PDO::PARAM_STR);
        $stmt->bindValue(':p_birth_place', $p_birth_place, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_customer_id AS customer_id');
        $customerID = $result->fetch(PDO::FETCH_ASSOC)['customer_id'];
        
        return $customerID;
    }
    # -------------------------------------------------------------
    
    # -------------------------------------------------------------
    #
    # Function: insertCustomerSignUp
    # Description: Inserts the customer via sign up.
    #
    # Parameters:
    # - $p_full_name (string): The full name.
    # - $p_first_name (string): The first name.
    # - $p_middle_name (string): The middle name.
    # - $p_last_name (string): The last name.
    # - $p_suffix (string): The suffix.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertCustomerSignUp($p_full_name, $p_first_name, $p_middle_name, $p_last_name, $p_suffix, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCustomerSignUp(:p_full_name, :p_first_name, :p_middle_name, :p_last_name, :p_suffix, :p_last_log_by, @p_customer_id)');
        $stmt->bindValue(':p_full_name', $p_full_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_first_name', $p_first_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_middle_name', $p_middle_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_name', $p_last_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_suffix', $p_suffix, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_customer_id AS customer_id');
        $customerID = $result->fetch(PDO::FETCH_ASSOC)['customer_id'];
        
        return $customerID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertCustomerAddress
    # Description: Updates the customer address.
    #
    # Parameters:
    # - $p_customer_id (int): The customer ID.
    # - $p_address_type_id (int): The address type ID.
    # - $p_address_type_name (string): The address type name.
    # - $p_address (string): The address.
    # - $p_city_id (int): The city ID.
    # - $p_city_name (string): The city name.
    # - $p_state_id (int): The state ID.
    # - $p_state_name (string): The state name.
    # - $p_country_id (int): The country ID.
    # - $p_country_name (string): The country name.
    # - $p_telephone (string): The telephone.
    # - $p_mobile (string): The mobile.
    # - $p_email (string): The email.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertCustomerAddress($p_customer_id, $p_address_type_id, $p_address_type_name, $p_address, $p_city_id, $p_city_name, $p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_telephone, $p_mobile, $p_email, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCustomerAddress(:p_customer_id, :p_address_type_id, :p_address_type_name, :p_address, :p_city_id, :p_city_name, :p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_telephone, :p_mobile, :p_email, :p_last_log_by)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_address_type_id', $p_address_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_address_type_name', $p_address_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_address', $p_address, PDO::PARAM_STR);
        $stmt->bindValue(':p_city_id', $p_city_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_city_name', $p_city_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_state_id', $p_state_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_state_name', $p_state_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_country_id', $p_country_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_country_name', $p_country_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_telephone', $p_telephone, PDO::PARAM_STR);
        $stmt->bindValue(':p_mobile', $p_mobile, PDO::PARAM_STR);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertCustomerBankAccount
    # Description: Inserts the customer bank account.
    #
    # Parameters:
    # - $p_customer_id (int): The customer ID.
    # - $p_bank_id (int): The bank ID.
    # - $p_bank_name (string): The bank name.
    # - $p_bank_account_type_id (int): The bank account type ID.
    # - $p_bank_account_type_name (string): The bank account type name.
    # - $p_account_number (string): The account number.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertCustomerBankAccount($p_customer_id, $p_bank_id, $p_bank_name, $p_bank_account_type_id, $p_bank_account_type_name, $p_account_number, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCustomerBankAccount(:p_customer_id, :p_bank_id, :p_bank_name, :p_bank_account_type_id, :p_bank_account_type_name, :p_account_number, :p_last_log_by)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_id', $p_bank_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_name', $p_bank_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_bank_account_type_id', $p_bank_account_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_bank_account_type_name', $p_bank_account_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_account_number', $p_account_number, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------
    
    # -------------------------------------------------------------
    #
    # Function: insertCustomerBankCard
    # Description: Inserts the customer bank card.
    #
    # Parameters:
    # - $p_customer_id (int): The customer ID.
    # - $p_name_on_card (string): The name on card.
    # - $p_card_number (string): The card number.
    # - $p_expiry_date (string): The expiry date.
    # - $p_cvv (string): The CVV.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertCustomerBankCard($p_customer_id, $p_name_on_card, $p_card_number, $p_expiry_date, $p_cvv, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCustomerBankCard(:p_customer_id, :p_name_on_card, :p_card_number, :p_expiry_date, :p_cvv, :p_last_log_by)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_name_on_card', $p_name_on_card, PDO::PARAM_STR);
        $stmt->bindValue(':p_card_number', $p_card_number, PDO::PARAM_STR);
        $stmt->bindValue(':p_expiry_date', $p_expiry_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_cvv', $p_cvv, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------
    
    # -------------------------------------------------------------
    #
    # Function: insertCustomerIDRecord
    # Description: Inserts the customer ID record.
    #
    # Parameters:
    # - $p_customer_id (int): The customer ID.
    # - $p_id_type_id (int): The ID type ID.
    # - $p_id_type_name (string): The ID type name.
    # - $p_id_number (string): The ID number.
    # - $p_issue_date (date): The issue date.
    # - $p_expiration_date (date): The expiration date.
    # - $p_issuing_authority (string): The issuing authority.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertCustomerIDRecord($p_customer_id, $p_id_type_id, $p_id_type_name, $p_id_number, $p_issue_date, $p_expiration_date, $p_issuing_authority, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCustomerIDRecord(:p_customer_id, :p_id_type_id, :p_id_type_name, :p_id_number, :p_issue_date, :p_expiration_date, :p_issuing_authority, :p_last_log_by)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_id_type_id', $p_id_type_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_id_type_name', $p_id_type_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_id_number', $p_id_number, PDO::PARAM_STR);
        $stmt->bindValue(':p_issue_date', $p_issue_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_expiration_date', $p_expiration_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_issuing_authority', $p_issuing_authority, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkCustomerExist
    # Description: Checks if a customer exists.
    #
    # Parameters:
    # - $p_customer_id (int): The customer ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCustomerExist($p_customer_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCustomerExist(:p_customer_id)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkCustomerAddressExist
    # Description: Checks if a customer address exists.
    #
    # Parameters:
    # - $p_customer_address_id (int): The customer address ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCustomerAddressExist($p_customer_address_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCustomerAddressExist(:p_customer_address_id)');
        $stmt->bindValue(':p_customer_address_id', $p_customer_address_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkCustomerBankAccountExist
    # Description: Checks if a customer bank account exists.
    #
    # Parameters:
    # - $p_customer_bank_account_id (int): The customer bank account ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCustomerBankAccountExist($p_customer_bank_account_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCustomerBankAccountExist(:p_customer_bank_account_id)');
        $stmt->bindValue(':p_customer_bank_account_id', $p_customer_bank_account_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkCustomerBankCardExist
    # Description: Checks if a customer bank card exists.
    #
    # Parameters:
    # - $p_customer_bank_card_id (int): The customer bank card ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCustomerBankCardExist($p_customer_bank_card_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCustomerBankCardExist(:p_customer_bank_card_id)');
        $stmt->bindValue(':p_customer_bank_card_id', $p_customer_bank_card_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkCustomerIDRecordExist
    # Description: Checks if a customer ID record exists.
    #
    # Parameters:
    # - $p_customer_id_record_id (int): The customer ID record ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCustomerIDRecordExist($p_customer_id_record_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCustomerIDRecordExist(:p_customer_id_record_id)');
        $stmt->bindValue(':p_customer_id_record_id', $p_customer_id_record_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCustomer
    # Description: Deletes the customer.
    #
    # Parameters:
    # - $p_customer_id (int): The customer ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCustomer($p_customer_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCustomer(:p_customer_id)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCustomerAddress
    # Description: Deletes the customer address.
    #
    # Parameters:
    # - $p_customer_address_id (int): The customer address ID.
    # - $p_customer_id (int): The customer ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCustomerAddress($p_customer_address_id, $p_customer_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCustomerAddress(:p_customer_address_id, :p_customer_id)');
        $stmt->bindValue(':p_customer_address_id', $p_customer_address_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCustomerBankAccount
    # Description: Deletes the customer bank account.
    #
    # Parameters:
    # - $p_customer_bank_account_id (int): The customer bank account ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCustomerBankAccount($p_customer_bank_account_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCustomerBankAccount(:p_customer_bank_account_id)');
        $stmt->bindValue(':p_customer_bank_account_id', $p_customer_bank_account_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCustomerBankCard
    # Description: Deletes the customer bank card.
    #
    # Parameters:
    # - $p_customer_bank_card_id (int): The customer bank card ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCustomerBankCard($p_customer_bank_card_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCustomerBankCard(:p_customer_bank_card_id)');
        $stmt->bindValue(':p_customer_bank_card_id', $p_customer_bank_card_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCustomerIDRecord
    # Description: Deletes the customer ID record.
    #
    # Parameters:
    # - $p_customer_id_record_id (int): The customer ID record ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCustomerIDRecord($p_customer_id_record_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCustomerIDRecord(:p_customer_id_record_id)');
        $stmt->bindValue(':p_customer_id_record_id', $p_customer_id_record_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCustomer
    # Description: Retrieves the details of a customer.
    #
    # Parameters:
    # - $p_customer_id (int): The customer ID.
    #
    # Returns:
    # - An array containing the customer details.
    #
    # -------------------------------------------------------------
    public function getCustomer($p_customer_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCustomer(:p_customer_id)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCustomerAddress
    # Description: Retrieves the details of a customer address.
    #
    # Parameters:
    # - $p_customer_address_id (int): The customer address ID.
    #
    # Returns:
    # - An array containing the customer address details.
    #
    # -------------------------------------------------------------
    public function getCustomerAddress($p_customer_address_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCustomerAddress(:p_customer_address_id)');
        $stmt->bindValue(':p_customer_address_id', $p_customer_address_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCustomerBankAccount
    # Description: Retrieves the details of a customer bank account.
    #
    # Parameters:
    # - $p_customer_bank_account_id (int): The customer bank account ID.
    #
    # Returns:
    # - An array containing the customer bank account details.
    #
    # -------------------------------------------------------------
    public function getCustomerBankAccount($p_customer_bank_account_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCustomerBankAccount(:p_customer_bank_account_id)');
        $stmt->bindValue(':p_customer_bank_account_id', $p_customer_bank_account_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCustomerBankCard
    # Description: Retrieves the details of a customer bank card.
    #
    # Parameters:
    # - $p_customer_bank_card_id (int): The customer bank card ID.
    #
    # Returns:
    # - An array containing the customer bank card details.
    #
    # -------------------------------------------------------------
    public function getCustomerBankCard($p_customer_bank_card_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCustomerBankCard(:p_customer_bank_card_id)');
        $stmt->bindValue(':p_customer_bank_card_id', $p_customer_bank_card_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCustomerIDRecord
    # Description: Retrieves the details of a customer ID record.
    #
    # Parameters:
    # - $p_customer_id_record_id (int): The customer ID record ID.
    #
    # Returns:
    # - An array containing the customer ID record details.
    #
    # -------------------------------------------------------------
    public function getCustomerIDRecord($p_customer_id_record_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCustomerIDRecord(:p_customer_id_record_id)');
        $stmt->bindValue(':p_customer_id_record_id', $p_customer_id_record_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateCustomerOptions
    # Description: Generates the customer options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateCustomerOptions($p_customer_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateCustomerOptions(:p_customer_id)');
        $stmt->bindValue(':p_customer_id', $p_customer_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $customerID = $row['customer_id'];
            $customerName = $row['customer_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($customerID, ENT_QUOTES) . '">' . htmlspecialchars($customerName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>