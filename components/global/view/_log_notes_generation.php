<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../user-account/model/user-account-model.php';
require_once '../../global/model/security-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$userAccountModel = new UserAccountModel($databaseModel);
$securityModel = new SecurityModel();

if(isset($_POST['type']) && !empty($_POST['type'])){
    $type = htmlspecialchars($_POST['type'], ENT_QUOTES, 'UTF-8');
    $response = [];
    
    switch ($type) {
        # -------------------------------------------------------------
        #
        # Type: log notes main
        # Description:
        # Generates the log notes main.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'log notes main':
            if(isset($_POST['database_table']) && !empty($_POST['database_table']) && isset($_POST['reference_id']) && !empty($_POST['reference_id'])){
                $logNote = '';

                $databaseTable = htmlspecialchars($_POST['database_table'], ENT_QUOTES, 'UTF-8');
                $referenceID = htmlspecialchars($_POST['reference_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateLogNotes(:databaseTable, :referenceID)');
                $sql->bindValue(':databaseTable', $databaseTable, PDO::PARAM_STR);
                $sql->bindValue(':referenceID', $referenceID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $log = $row['log'];
                    $changedBy = $row['changed_by'];
                    $timeElapsed = $systemModel->timeElapsedString($row['changed_at']);

                    $userDetails = $userAccountModel->getUserAccount($changedBy, null);
                    $fileAs = $userDetails['file_as'];
                    $profilePicture = $systemModel->checkImage($userDetails['profile_picture'] ?? null, 'profile');

                    $logNote .= '<div class="p-4 rounded-4 text-bg-light mb-3">
                                    <div class="d-flex align-items-center gap-6 flex-wrap">
                                        <img src="'. $profilePicture .'" alt="user" class="rounded-circle" width="33" height="33">
                                        <h6 class="mb-0">'. $fileAs .'</h6>
                                        <span class="fs-2">
                                            <span class="p-1 text-bg-muted rounded-circle d-inline-block me-2"></span> '. $timeElapsed .'
                                        </span>
                                    </div>
                                    <p class="mt-3 mb-0">'. $log .'</p>
                                </div>';
                }

                if(empty($logNote)){
                    $logNote = '<div class="p-4 rounded-4 text-bg-light mb-0 text-center">
                                No log notes found.
                            </div>';
                }

                $response[] = [
                    'LOG_NOTE' => $logNote
                ];

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: log notes
        # Description:
        # Generates the log notes.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'log notes':
            if(isset($_POST['database_table']) && !empty($_POST['database_table']) && isset($_POST['reference_id']) && !empty($_POST['reference_id'])){
                $logNote = '';

                $databaseTable = htmlspecialchars($_POST['database_table'], ENT_QUOTES, 'UTF-8');
                $referenceID = htmlspecialchars($_POST['reference_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateLogNotes(:databaseTable, :referenceID)');
                $sql->bindValue(':databaseTable', $databaseTable, PDO::PARAM_STR);
                $sql->bindValue(':referenceID', $referenceID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $log = $row['log'];
                    $changedBy = $row['changed_by'];
                    $timeElapsed = $systemModel->timeElapsedString($row['changed_at']);

                    $userDetails = $userAccountModel->getUserAccount($changedBy, null);
                    $fileAs = $userDetails['file_as'];
                    $profilePicture = $systemModel->checkImage($userDetails['profile_picture'] ?? null, 'profile');
                    
                    $logNote .= ' <div class="d-flex flex-row comment-row border-bottom p-3 gap-3">
                                    <div>
                                        <span class=""><img src="'. $profilePicture .'" class="rounded-circle" alt="user" width="50" height="50" /></span>
                                    </div>
                                    <div class="comment-text w-100">
                                        <h6 class="font-weight-medium">'. $fileAs .'</h6>
                                        <div class="comment-footer mb-3">
                                            <span class="text-muted ms-auto fw-normal fs-2 d-block mt-2">'. $timeElapsed .'</span>
                                        </div>
                                        <p class="mb-1 fs-2 text-muted">'. $log .'</p>
                                    </div>
                                </div>';
                }

                if(empty($logNote)){
                    $logNote = '<div class="text-center">
                                No log notes found.
                            </div>';
                }

                $response[] = [
                    'LOG_NOTE' => $logNote
                ];

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------
    }
}

?>