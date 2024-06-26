<?php
/**
* Class AuthenticationModel
*
* The AuthenticationModel class handles authentication operations and interactions.
*/
class AuthenticationModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getLoginCredentials
    # Description: Retrieves the details of a login credentials.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID of the user.
    # - $p_credentials (string): The username or email address of the user.
    #
    # Returns:
    # - An array containing the user details.
    #
    # -------------------------------------------------------------
    public function getLoginCredentials($p_user_account_id, $p_credentials) {
        $stmt = $this->db->getConnection()->prepare('CALL getLoginCredentials(:p_user_account_id, :p_credentials)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_credentials', $p_credentials, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getPasswordHistory
    # Description: Retrieves the password history of a user based on their user account ID and email.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_credentials (string): The username or email address of the user.
    #
    # Returns:
    # - An array containing the password history details.
    #
    # -------------------------------------------------------------
    public function getPasswordHistory($p_user_account_id, $p_credentials) {
        $stmt = $this->db->getConnection()->prepare('CALL getPasswordHistory(:p_user_account_id, :p_credentials)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_credentials', $p_credentials, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkLoginCredentialsExist
    # Description: Checks if the login credentials exists.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID of the user.
    # - $p_credentials (string): The username or email address of the user.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkLoginCredentialsExist($p_user_account_id, $p_credentials) {
        $stmt = $this->db->getConnection()->prepare('CALL checkLoginCredentialsExist(:p_user_account_id, :p_credentials)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_credentials', $p_credentials, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Update exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateLoginAttempt
    # Description: Updates the login attempt details for a user.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_failed_login_attempts (int): The number of failed login attempts.
    # - $p_last_failed_login_attempt (datetime): The date and time of the last failed login attempt.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateLoginAttempt($p_user_account_id, $p_failed_login_attempts, $p_last_failed_login_attempt) {
        $stmt = $this->db->getConnection()->prepare('CALL updateLoginAttempt(:p_user_account_id, :p_failed_login_attempts, :p_last_failed_login_attempt)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_failed_login_attempts', $p_failed_login_attempts, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_failed_login_attempt', $p_last_failed_login_attempt, PDO::PARAM_STR);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateAccountLock
    # Description: Updates the account lock status and lock duration for a user.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_locked (string): The lock status (yes/no).
    # - $p_lock_duration (int): The lock duration in minutes.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateAccountLock($p_user_account_id, $p_locked, $p_lock_duration) {
        $stmt = $this->db->getConnection()->prepare('CALL updateAccountLock(:p_user_account_id, :p_locked, :p_lock_duration)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_locked', $p_locked, PDO::PARAM_STR);
        $stmt->bindValue(':p_lock_duration', $p_lock_duration, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateOTP
    # Description: Updates the OTP details for a user.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_otp (string): The new OTP.
    # - $p_otp_expiry_date (datetime): The expiry date and time of the OTP.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateOTP($p_user_account_id, $p_otp, $p_otp_expiry_date) {
        $stmt = $this->db->getConnection()->prepare('CALL updateOTP(:p_user_account_id, :p_otp, :p_otp_expiry_date)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_otp', $p_otp, PDO::PARAM_STR);
        $stmt->bindValue(':p_otp_expiry_date', $p_otp_expiry_date, PDO::PARAM_STR);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateFailedOTPAttempts
    # Description: Updates the last connection date for a user.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_failed_otp_attempts (int): The failed OTP attempts.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateFailedOTPAttempts($p_user_account_id, $p_failed_otp_attempts) {
        $stmt = $this->db->getConnection()->prepare('CALL updateFailedOTPAttempts(:p_user_account_id, :p_failed_otp_attempts)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_failed_otp_attempts', $p_failed_otp_attempts, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateOTPAsExpired
    # Description: Updates the last connection date for a user.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_otp_expiry_date (int): The OTP expiry date.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateOTPAsExpired($p_user_account_id, $p_otp_expiry_date) {
        $stmt = $this->db->getConnection()->prepare('CALL updateOTPAsExpired(:p_user_account_id, :p_otp_expiry_date)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_otp_expiry_date', $p_otp_expiry_date, PDO::PARAM_STR);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateResetTokenAsExpired
    # Description: Updates the last connection date for a user.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_reset_token_expiry_date (int): The reset token expiry date.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateResetTokenAsExpired($p_user_account_id, $p_reset_token_expiry_date) {
        $stmt = $this->db->getConnection()->prepare('CALL updateResetTokenAsExpired(:p_user_account_id, :p_reset_token_expiry_date)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_reset_token_expiry_date', $p_reset_token_expiry_date, PDO::PARAM_STR);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateLastConnection
    # Description: Updates the last connection date for a user.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_session_token (string): The session token.
    # - $p_last_connection_date (datetime): The date and time of the last connection.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateLastConnection($p_user_account_id, $p_session_token, $p_last_connection_date) {
        $stmt = $this->db->getConnection()->prepare('CALL updateLastConnection(:p_user_account_id, :p_session_token, :p_last_connection_date)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_session_token', $p_session_token, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_connection_date', $p_last_connection_date, PDO::PARAM_STR);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateResetToken
    # Description: Updates the reset token details for a user.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_resetToken (string): The new reset token.
    # - $p_resetToken_expiry_date (datetime): The expiry date and time of the reset token.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateResetToken($p_user_account_id, $p_resetToken, $p_resetToken_expiry_date) {
        $stmt = $this->db->getConnection()->prepare('CALL updateResetToken(:p_user_account_id, :p_resetToken, :p_resetToken_expiry_date)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_resetToken', $p_resetToken, PDO::PARAM_STR);
        $stmt->bindValue(':p_resetToken_expiry_date', $p_resetToken_expiry_date, PDO::PARAM_STR);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateUserPassword
    # Description: Updates the password details for a user.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_credentials (string): The username or email address of the user.
    # - $p_password (string): The new password.
    # - $p_password_expiry_date (date): The expiry date of the password.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateUserPassword($p_user_account_id, $p_credentials, $p_password, $p_password_expiry_date) {
        $stmt = $this->db->getConnection()->prepare('CALL updateUserPassword(:p_user_account_id, :p_credentials, :p_password, :p_password_expiry_date)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_credentials', $p_credentials, PDO::PARAM_STR);
        $stmt->bindValue(':p_password', $p_password, PDO::PARAM_STR);
        $stmt->bindValue(':p_password_expiry_date', $p_password_expiry_date, PDO::PARAM_STR);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Inser exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertPasswordHistory
    # Description: Inserts a new record in the password history for a user.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_password (string): The password to be stored in the history.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function insertPasswordHistory($p_user_account_id, $p_password) {
        $stmt = $this->db->getConnection()->prepare('CALL insertPasswordHistory(:p_user_account_id, :p_password)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_password', $p_password, PDO::PARAM_STR);
        $stmt->execute();
    }
    # -------------------------------------------------------------
}
?>