<?php
/**
* Class ContactFormModel
*
* The ContactFormModel class handles contact form related operations and interactions.
*/
class ContactFormModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateContactForm
    # Description: Updates the contact form.
    #
    # Parameters:
    # - $p_contact_form_id (int): The contact form ID.
    # - $p_contact_form_name (string): The contact form name.
    # - $p_description (string): The contact form description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateContactForm($p_contact_form_id, $p_contact_form_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateContactForm(:p_contact_form_id, :p_contact_form_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by)');
        $stmt->bindValue(':p_contact_form_id', $p_contact_form_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_contact_form_name', $p_contact_form_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateContactFormPublishStatus
    # Description: Updates the contact form publish status.
    #
    # Parameters:
    # - $p_contact_form_item_id (int): The contact form item ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateContactFormPublishStatus($p_contact_form_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateContactFormPublishStatus(:p_contact_form_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_contact_form_id', $p_contact_form_id, PDO::PARAM_INT);
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
    # Function: insertContactForm
    # Description: Inserts the contact form.
    #
    # Parameters:
    # - $p_contact_form_name (string): The contact form name.
    # - $p_description (string): The contact form description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertContactForm($p_contact_form_name, $p_description, $p_block_style_id, $p_block_style_name, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertContactForm(:p_contact_form_name, :p_description, :p_block_style_id, :p_block_style_name, :p_last_log_by, @p_contact_form_id)');
        $stmt->bindValue(':p_contact_form_name', $p_contact_form_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_contact_form_id AS contact_form_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['contact_form_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkContactFormExist
    # Description: Checks if a contact form exists.
    #
    # Parameters:
    # - $p_contact_form_id (int): The contact form ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkContactFormExist($p_contact_form_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkContactFormExist(:p_contact_form_id)');
        $stmt->bindValue(':p_contact_form_id', $p_contact_form_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteContactForm
    # Description: Deletes the contact form.
    #
    # Parameters:
    # - $p_contact_form_id (int): The contact form ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteContactForm($p_contact_form_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteContactForm(:p_contact_form_id)');
        $stmt->bindValue(':p_contact_form_id', $p_contact_form_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getContactForm
    # Description: Retrieves the details of a contact form.
    #
    # Parameters:
    # - $p_contact_form_id (int): The contact form ID.
    #
    # Returns:
    # - An array containing the contact form details.
    #
    # -------------------------------------------------------------
    public function getContactForm($p_contact_form_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getContactForm(:p_contact_form_id)');
        $stmt->bindValue(':p_contact_form_id', $p_contact_form_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateContactFormOptions
    # Description: Generates the contact form options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateContactFormOptions($p_contact_form_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generateContactFormOptions(:p_contact_form_id)');
        $stmt->bindValue(':p_contact_form_id', $p_contact_form_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $contactFormID = $row['contact_form_id'];
            $contactFormName = $row['contact_form_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($contactFormID, ENT_QUOTES) . '">' . htmlspecialchars($contactFormName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>