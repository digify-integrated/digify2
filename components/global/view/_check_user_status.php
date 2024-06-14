<?php
    $loginCredentialsDetails = $authenticationModel->getLoginCredentials($userID, null);
    $userFileAs = $loginCredentialsDetails['file_as'];
    $userEmail = $loginCredentialsDetails['email'];
    $multipleSession = $loginCredentialsDetails['multiple_session'];
    $profilePicture = $systemModel->checkImage($loginCredentialsDetails['profile_picture'] ?? null, 'profile');
    $sessionToken = $securityModel->decryptData($loginCredentialsDetails['session_token']);
    
    if ($loginCredentialsDetails['active'] == 'No' || $loginCredentialsDetails['locked'] == 'Yes' || ($_SESSION['session_token'] != $sessionToken && $multipleSession == 'No')) {
        header('location: logout.php?logout');
        exit;
    }
?>