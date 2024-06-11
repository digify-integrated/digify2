<?php
/**
* Class DatabaseModel
*
* The DatabaseModel class handles database related operations and interactions.
*/
class DatabaseModel {
    public static $instance;
    public $connection;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: Constructs a new instance of the class and establishes a database connection.
    #
    # Parameters:None
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct() {
        $host = DB_HOST;
        $dbname = DB_NAME;
        $username = DB_USER;
        $password = DB_PASS;

        try {
            $options = [
                PDO::ATTR_EMULATE_PREPARES => false,
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci"
            ];

            $this->connection = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password, $options);
        }
        catch (PDOException $e) {
            error_log('Database connection failed: ' . $e->getMessage());
            die('An error occurred while connecting to the database. Please try again later.');
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getInstance
    # Description: Returns the singleton instance of the class.
    #
    # Parameters:None
    #
    # Returns: self
    #
    # -------------------------------------------------------------
    public static function getInstance() {
        if (!self::$instance) {
            self::$instance = new self();
        }
        
        return self::$instance;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getConnection
    # Description: Retrieves the established database connection.
    #
    # Parameters:None
    #
    # Returns: PDO
    #
    # -------------------------------------------------------------
    public function getConnection() {
        return $this->connection;
    }
    # -------------------------------------------------------------
}

?>