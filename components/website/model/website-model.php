<?php
/**
* Class WebsiteModel
*
* The WebsiteModel class handles website related operations and interactions.
*/
class WebsiteModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateWebsite
    # Description: Updates the website.
    #
    # Parameters:
    # - $p_website_id (int): The website ID.
    # - $p_website_name (string): The website name.
    # - $p_description (string): The description.
    # - $p_url (string): The URL.
    # - $p_last_log_by (int): The last logged user.
    #
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateWebsite($p_website_id, $p_website_name, $p_description, $p_url, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateWebsite(:p_website_id, :p_website_name, :p_description, :p_url, :p_last_log_by)');
        $stmt->bindValue(':p_website_id', $p_website_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_website_name', $p_website_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_url', $p_url, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertWebsite
    # Description: Inserts the website.
    #
    # Parameters:
    # - $p_website_name (string): The website name.
    # - $p_description (string): The description.
    # - $p_url (string): The URL.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertWebsite($p_website_name, $p_description, $p_url, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertWebsite(:p_website_name, :p_description, :p_url, :p_last_log_by, @p_website_id)');
        $stmt->bindValue(':p_website_name', $p_website_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_url', $p_url, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_website_id AS website_id');
        $appModuleID = $result->fetch(PDO::FETCH_ASSOC)['website_id'];
        
        return $appModuleID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkWebsiteExist
    # Description: Checks if a website exists.
    #
    # Parameters:
    # - $p_website_id (int): The website ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkWebsiteExist($p_website_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkWebsiteExist(:p_website_id)');
        $stmt->bindValue(':p_website_id', $p_website_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteWebsite
    # Description: Deletes the website.
    #
    # Parameters:
    # - $p_website_id (int): The website ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteWebsite($p_website_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteWebsite(:p_website_id)');
        $stmt->bindValue(':p_website_id', $p_website_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getWebsite
    # Description: Retrieves the details of a website.
    #
    # Parameters:
    # - $p_website_id (int): The website ID.
    #
    # Returns:
    # - An array containing the website details.
    #
    # -------------------------------------------------------------
    public function getWebsite($p_website_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getWebsite(:p_website_id)');
        $stmt->bindValue(':p_website_id', $p_website_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateWebsiteOptions
    # Description: Generates the website options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateWebsiteOptions() {
        $stmt = $this->db->getConnection()->prepare('CALL generateWebsiteOptions()');
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $websiteID = $row['website_id'];
            $websiteName = $row['website_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($websiteID, ENT_QUOTES) . '">' . htmlspecialchars($websiteName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>