<?php
# -------------------------------------------------------------
#
# Name       : date_default_timezone_set
# Purpose    : This sets the default timezone to PH.
#
# -------------------------------------------------------------

date_default_timezone_set('Asia/Manila');

# -------------------------------------------------------------
#
# Name       : Database Connection
# Purpose    : This is the place where your database login constants are saved
#
#              DB_HOST: database host, usually it's '127.0.0.1' or 'localhost', some servers also need port info
#              DB_NAME: name of the database. please note: database and database table are not the same thing
#              DB_USER: user for your database. the user needs to have rights for SELECT, UPDATE, DELETE and INSERT.
#              DB_PASS: the password of the above user
#
# -------------------------------------------------------------

define('DB_HOST', 'localhost');
define('DB_NAME', 'digifydb');
define('DB_USER', 'modernize');
define('DB_PASS', 'qKHJpbkgC6t93nQr');

# -------------------------------------------------------------

# -------------------------------------------------------------
#
# Name       : Encryption Key
# Purpose    : This is the serves as the encryption and decryption key of RC
#
# -------------------------------------------------------------

define('ENCRYPTION_KEY', '4b$Gy#89%q*aX@^p&cT!sPv6(5w)zSd+R');

# -------------------------------------------------------------

# -------------------------------------------------------------
#
# Name       : Email Configuration
# Purpose    : Define constants for email server configuration.
#
# -------------------------------------------------------------

define('MAIL_HOST', 'smtp.hostinger.com');
define('MAIL_SMTP_AUTH', true);
define('MAIL_USERNAME', 'cgmi-noreply@christianmotors.ph');
define('MAIL_PASSWORD', 'P@ssw0rd');
define('MAIL_SMTP_SECURE', 'ssl');
define('MAIL_PORT', 465);

# -------------------------------------------------------------

# -------------------------------------------------------------
#
# Name       : Default user interface image
# Purpose    : This is the serves as the default images for the user interface.
#
# -------------------------------------------------------------

define('DEFAULT_AVATAR_IMAGE', './assets/images/default/default-avatar.jpg');
define('DEFAULT_BG_IMAGE', './assets/images/default/default-bg.jpg');
define('DEFAULT_LOGIN_LOGO_IMAGE', './assets/images/default/default-logo-placeholder.png');
define('DEFAULT_MENU_LOGO_IMAGE', './assets/images/default/default-menu-logo.png');
define('DEFAULT_MODULE_ICON_IMAGE', './assets/images/default/default-module-icon.svg');
define('DEFAULT_FAVICON_IMAGE', './assets/images/default/default-favicon.svg');
define('DEFAULT_COMPANY_LOGO', './assets/images/default/default-company-logo.png');
define('DEFAULT_APP_MODULE_LOGO', './assets/images/default/app-module-logo.png');
define('DEFAULT_PLACEHOLDER_IMAGE', './assets/images/default/default-image-placeholder.png');

# -------------------------------------------------------------

# -------------------------------------------------------------
#
# Name       : PASSWORD DEFAULTS
# Purpose    : Define default password.
#
# -------------------------------------------------------------

define('DEFAULT_PASSWORD', 'P@ssw0rd');

# -------------------------------------------------------------

# -------------------------------------------------------------
#
# Name       : SECURITY SETTINGS
# Purpose    : Define maximum allowed failed login and OTP attempts.
#
# -------------------------------------------------------------

define('MAX_FAILED_LOGIN_ATTEMPTS', 5);
define('RESET_PASSWORD_TOKEN_DURATION', 10);
define('DEFAULT_PASSWORD_DURATION', 180);
define('MAX_FAILED_OTP_ATTEMPTS', 5);
define('DEFAULT_OTP_DURATION', 5);
define('BASE_USER_ACCOUNT_DURATION', 1);
define('DEFAULT_SESSION_INACTIVITY', 30);
define('DEFAULT_PASSWORD_RECOVERY_LINK', 'http://localhost/modernize/password-reset.php?id=');

# -------------------------------------------------------------
?>
