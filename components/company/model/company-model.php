<?php
/**
* Class CompanyModel
*
* The CompanyModel class handles company related operations and interactions.
*/
class CompanyModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCompany
    # Description: Updates the company.
    #
    # Parameters:
    # - $p_company_id (int): The company ID.
    # - $p_company_name (string): The company name.
    # - $p_legal_name (string): The legal name of the company.
    # - $p_address (string): The address of the company.
    # - $p_city_id (int): The city ID.
    # - $p_city_name (string): The city name.
    # - $p_state_id (int): The state ID.
    # - $p_state_name (string): The state name.
    # - $p_country_id (int): The country ID.
    # - $p_country_name (string): The country name.
    # - $p_currency_id (int): The currency ID.
    # - $p_currency_name (string): The currency name.
    # - $p_currency_symbol (string): The currency symbol.
    # - $p_tax_id (string): The tax ID.
    # - $p_phone (string): The phone of the company.
    # - $p_mobile (string): The mobile of the company.
    # - $p_email (string): The email of the company.
    # - $p_website (string): The website of the company.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCompany($p_company_id, $p_company_name, $p_legal_name, $p_address, $p_city_id, $p_city_name, $p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_currency_id, $p_currency_name, $p_currency_symbol, $p_tax_id, $p_phone, $p_mobile, $p_email, $p_website, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCompany(:p_company_id, :p_company_name, :p_legal_name, :p_address, :p_city_id, :p_city_name, :p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_currency_id, :p_currency_name, :p_currency_symbol, :p_tax_id, :p_phone, :p_mobile, :p_email, :p_website, :p_last_log_by)');
        $stmt->bindValue(':p_company_id', $p_company_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_company_name', $p_company_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_legal_name', $p_legal_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_address', $p_address, PDO::PARAM_STR);
        $stmt->bindValue(':p_city_id', $p_city_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_city_name', $p_city_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_state_id', $p_state_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_state_name', $p_state_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_country_id', $p_country_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_country_name', $p_country_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_currency_id', $p_currency_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_currency_name', $p_currency_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_currency_symbol', $p_currency_symbol, PDO::PARAM_STR);
        $stmt->bindValue(':p_tax_id', $p_tax_id, PDO::PARAM_STR);
        $stmt->bindValue(':p_phone', $p_phone, PDO::PARAM_STR);
        $stmt->bindValue(':p_mobile', $p_mobile, PDO::PARAM_STR);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->bindValue(':p_website', $p_website, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateCompanyLogo
    # Description: Updates the company logo.
    #
    # Parameters:
    # - $p_company_id (int): The company ID.
    # - $p_company_logo (string): The logo of the company.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateCompanyLogo($p_company_id, $p_company_logo, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateCompanyLogo(:p_company_id, :p_company_logo, :p_last_log_by)');
        $stmt->bindValue(':p_company_id', $p_company_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_company_logo', $p_company_logo, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertCompany
    # Description: Inserts the company.
    #
    # Parameters:
    # - $p_company_name (string): The company name.
    # - $p_legal_name (string): The legal name of the company.
    # - $p_address (string): The address of the company.
    # - $p_city_id (int): The city ID.
    # - $p_city_name (string): The city name.
    # - $p_state_id (int): The state ID.
    # - $p_state_name (string): The state name.
    # - $p_country_id (int): The country ID.
    # - $p_country_name (string): The country name.
    # - $p_currency_id (int): The currency ID.
    # - $p_currency_name (string): The currency name.
    # - $p_currency_symbol (string): The currency symbol.
    # - $p_tax_id (string): The tax ID.
    # - $p_phone (string): The phone of the company.
    # - $p_mobile (string): The mobile of the company.
    # - $p_email (string): The email of the company.
    # - $p_website (string): The website of the company.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertCompany($p_company_name, $p_legal_name, $p_address, $p_city_id, $p_city_name, $p_state_id, $p_state_name, $p_country_id, $p_country_name, $p_currency_id, $p_currency_name, $p_currency_symbol, $p_tax_id, $p_phone, $p_mobile, $p_email, $p_website, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertCompany(:p_company_name, :p_legal_name, :p_address, :p_city_id, :p_city_name, :p_state_id, :p_state_name, :p_country_id, :p_country_name, :p_currency_id, :p_currency_name, :p_currency_symbol, :p_tax_id, :p_phone, :p_mobile, :p_email, :p_website, :p_last_log_by, @p_company_id)');
        $stmt->bindValue(':p_company_name', $p_company_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_legal_name', $p_legal_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_address', $p_address, PDO::PARAM_STR);
        $stmt->bindValue(':p_city_id', $p_city_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_city_name', $p_city_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_state_id', $p_state_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_state_name', $p_state_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_country_id', $p_country_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_country_name', $p_country_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_currency_id', $p_currency_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_currency_name', $p_currency_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_currency_symbol', $p_currency_symbol, PDO::PARAM_STR);
        $stmt->bindValue(':p_tax_id', $p_tax_id, PDO::PARAM_STR);
        $stmt->bindValue(':p_phone', $p_phone, PDO::PARAM_STR);
        $stmt->bindValue(':p_mobile', $p_mobile, PDO::PARAM_STR);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->bindValue(':p_website', $p_website, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_company_id AS company_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['company_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkCompanyExist
    # Description: Checks if a company exists.
    #
    # Parameters:
    # - $p_company_id (int): The company ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkCompanyExist($p_company_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkCompanyExist(:p_company_id)');
        $stmt->bindValue(':p_company_id', $p_company_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteCompany
    # Description: Deletes the company.
    #
    # Parameters:
    # - $p_company_id (int): The company ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteCompany($p_company_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteCompany(:p_company_id)');
        $stmt->bindValue(':p_company_id', $p_company_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getCompany
    # Description: Retrieves the details of a company.
    #
    # Parameters:
    # - $p_company_id (int): The company ID.
    #
    # Returns:
    # - An array containing the company details.
    #
    # -------------------------------------------------------------
    public function getCompany($p_company_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getCompany(:p_company_id)');
        $stmt->bindValue(':p_company_id', $p_company_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>