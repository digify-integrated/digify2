<?php
/**
* Class PageTitleModel
*
* The PageTitleModel class handles page title related operations and interactions.
*/
class PageTitleModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updatePageTitle
    # Description: Updates the page title.
    #
    # Parameters:
    # - $p_page_title_id (int): The image galllery ID.
    # - $p_page_title_name (string): The carousel name.
    # - $p_description (string): The carousel description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_page_title (string): The page title.
    # - $p_page_heading (string): The page title.
    # - $p_page_title_image (string): The page title image.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updatePageTitle($p_page_title_id, $p_page_title_name, $p_description, $p_block_style_id, $p_block_style_name, $p_page_title, $p_page_heading, $p_page_title_image, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updatePageTitle(:p_page_title_id, :p_page_title_name, :p_description, :p_block_style_id, :p_block_style_name, :p_page_title, :p_page_heading, :p_page_title_image, :p_last_log_by)');
        $stmt->bindValue(':p_page_title_id', $p_page_title_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_page_title_name', $p_page_title_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_page_title', $p_page_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_page_heading', $p_page_heading, PDO::PARAM_STR);
        $stmt->bindValue(':p_page_title_image', $p_page_title_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updatePageTitlePublishStatus
    # Description: Updates the page title publish status.
    #
    # Parameters:
    # - $p_page_title_id (int): The page title ID.
    # - $p_publish_status (string): The publish status.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updatePageTitlePublishStatus($p_page_title_id, $p_publish_status, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updatePageTitlePublishStatus(:p_page_title_id, :p_publish_status, :p_last_log_by)');
        $stmt->bindValue(':p_page_title_id', $p_page_title_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_publish_status', $p_publish_status, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updatePageTitleImage
    # Description: Updates the page title image.
    #
    # Parameters:
    # - $p_page_title_id (int): The page title ID.
    # - $p_page_title_image (string): The page title image.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updatePageTitleImage($p_page_title_id, $p_page_title_image, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updatePageTitleImage(:p_page_title_id, :p_page_title_image, :p_last_log_by)');
        $stmt->bindValue(':p_page_title_id', $p_page_title_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_page_title_image', $p_page_title_image, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertPageTitle
    # Description: Inserts the page title.
    #
    # Parameters:
    # - $p_page_title_name (string): The page title name.
    # - $p_description (string): The page title description.
    # - $p_block_style_id (string): The block style ID.
    # - $p_block_style_name (string): The block style name.
    # - $p_page_title (string): The page title.
    # - $p_page_heading (string): The page heading.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertPageTitle($p_page_title_name, $p_description, $p_block_style_id, $p_block_style_name, $p_page_title, $p_page_heading, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertPageTitle(:p_page_title_name, :p_description, :p_block_style_id, :p_block_style_name, :p_page_title, :p_page_heading, :p_last_log_by, @p_page_title_id)');
        $stmt->bindValue(':p_page_title_name', $p_page_title_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_description', $p_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_block_style_id', $p_block_style_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_block_style_name', $p_block_style_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_page_title', $p_page_title, PDO::PARAM_STR);
        $stmt->bindValue(':p_page_heading', $p_page_heading, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_page_title_id AS page_title_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['page_title_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkPageTitleExist
    # Description: Checks if a page title exists.
    #
    # Parameters:
    # - $p_page_title_id (int): The page title ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkPageTitleExist($p_page_title_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkPageTitleExist(:p_page_title_id)');
        $stmt->bindValue(':p_page_title_id', $p_page_title_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deletePageTitle
    # Description: Deletes the page title.
    #
    # Parameters:
    # - $p_page_title_id (int): The page title ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deletePageTitle($p_page_title_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deletePageTitle(:p_page_title_id)');
        $stmt->bindValue(':p_page_title_id', $p_page_title_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getPageTitle
    # Description: Retrieves the details of a page title.
    #
    # Parameters:
    # - $p_page_title_id (int): The page title ID.
    #
    # Returns:
    # - An array containing the page title details.
    #
    # -------------------------------------------------------------
    public function getPageTitle($p_page_title_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getPageTitle(:p_page_title_id)');
        $stmt->bindValue(':p_page_title_id', $p_page_title_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generatePageTitleOptions
    # Description: Generates the page title options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generatePageTitleOptions($p_page_title_id) {
        $stmt = $this->db->getConnection()->prepare('CALL generatePageTitleOptions(:p_page_title_id)');
        $stmt->bindValue(':p_page_title_id', $p_page_title_id, PDO::PARAM_INT);
        $stmt->execute();
        $options = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $htmlOptions = '';
        foreach ($options as $row) {
            $pageTitleID = $row['page_title_id'];
            $pageTitleName = $row['page_title_name'];

            $htmlOptions .= '<option value="' . htmlspecialchars($pageTitleID, ENT_QUOTES) . '">' . htmlspecialchars($pageTitleName, ENT_QUOTES) . '</option>';
        }

        return $htmlOptions;
    }
    # -------------------------------------------------------------
}
?>