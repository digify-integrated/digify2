<?php
    require('components/user-account/model/user-account-model.php');

    $userAccountModel = new UserAccountModel($databaseModel);

    $writeAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');
    $deleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');
    $createAccess = $globalModel->checkAccessRights($userID, $pageID, 'create');

    $activateUserAccount = $globalModel->checkSystemActionAccessRights($userID, 3);
    $deactivateUserAccount = $globalModel->checkSystemActionAccessRights($userID, 4);
    $lockUserAccount = $globalModel->checkSystemActionAccessRights($userID, 5);
    $unlockUserAccount = $globalModel->checkSystemActionAccessRights($userID, 6);
    $addRoleUserAccount  = $globalModel->checkSystemActionAccessRights($userID, 7);

    if(isset($_GET['id'])){
        $userAccountDetails = $userAccountModel->getUserAccount($detailID, null);
        $userAccountActive = $userAccountDetails['active'];
        $userAccountLocked = $userAccountDetails['locked'];
    }
?>
<div class="row">
    <div class="col-12">
        <div class="card">
            <ul class="nav nav-pills user-profile-tab" id="pills-tab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link position-relative rounded-0 active d-flex align-items-center justify-content-center bg-transparent fs-3 py-4" id="account-details-tab" data-bs-toggle="pill" data-bs-target="#account-details" type="button" role="tab" aria-controls="account-details" aria-selected="true">
                        <i class="ti ti-user-circle me-2 fs-6"></i>
                        <span class="d-none d-md-block">Account</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button  class="nav-link position-relative rounded-0 d-flex align-items-center justify-content-center bg-transparent fs-3 py-4" id="security-tab" data-bs-toggle="pill" data-bs-target="#user-role" type="button" role="tab" aria-controls="user-role" aria-selected="false">
                        <i class="ti ti-users me-2 fs-6"></i>
                        <span class="d-none d-md-block">Roles</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button  class="nav-link position-relative rounded-0 d-flex align-items-center justify-content-center bg-transparent fs-3 py-4" id="security-tab" data-bs-toggle="pill" data-bs-target="#security" type="button" role="tab" aria-controls="security" aria-selected="false">
                        <i class="ti ti-lock me-2 fs-6"></i>
                        <span class="d-none d-md-block">Security</span>
                    </button>
                </li>
            </ul>
            <div class="card-body">
                <div class="tab-content" id="pills-tabContent">
                    <div class="tab-pane fade show active" id="account-details" role="tabpanel" aria-labelledby="account-details-tab" tabindex="0">
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center">
                                        <h5 class="card-title mb-0">Change Profile</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <div class="text-center">
                                            <img src="./assets/images/profile/user-1.jpg" alt="" id="user_account_profile_picture" class="rounded-circle" width="100" height="100">
                                            <?php
                                                echo $writeAccess['total'] > 0 ? 
                                                '<div class="d-flex align-items-center justify-content-center my-4 gap-6">
                                                    <button class="btn btn-primary" data-bs-toggle="modal" id="update-user-account-profile-picture" data-bs-target="#user-account-profile-picture-modal">Upload</button>
                                                </div>' : '';
                                            ?>
                                            <p class="mb-0 mt-2">Allowed JPG, JPEG or PNG. Max size of 500kb</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-8">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center">
                                        <h5 class="card-title mb-0">User Account</h5>
                                        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                            <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                                            <ul class="dropdown-menu dropdown-menu-end">
                                                <?php
                                                    if($createAccess['total'] > 0 || $deleteAccess['total'] > 0 || $activateUserAccount['total'] > 0 || $deactivateUserAccount['total'] > 0 || $lockUserAccount['total'] > 0 || $unlockUserAccount['total'] > 0){
                                                        echo $writeAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" data-bs-toggle="modal" id="change-password" data-bs-target="#change-password-modal">Change Password</button></li>' : '';
                                                        
                                                        echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create User Account</a></li>' : '';

                                                        if($userAccountActive == 'Yes' && $deactivateUserAccount['total'] > 0){
                                                            echo '<li><button class="dropdown-item" type="button" id="deactivate-user-account">Deactivate User Account</button></li>';
                                                        }
                                                        else if($userAccountActive == 'No' && $activateUserAccount['total'] > 0){
                                                            echo '<li><button class="dropdown-item" type="button" id="activate-user-account">Activate User Account</button></li>';
                                                        }

                                                        if($userAccountLocked == 'Yes' && $unlockUserAccount['total'] > 0){
                                                            echo '<li><button class="dropdown-item" type="button" id="unlock-user-account">Unlock User Account</button></li>';
                                                        }
                                                        else if($userAccountLocked == 'No' && $lockUserAccount['total'] > 0){
                                                            echo '<li><button class="dropdown-item" type="button" id="lock-user-account">Lock User Account</button></li>';
                                                        }

                                                        echo $deleteAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="delete-user-account">Delete User Account</button></li>' : '';
                                                        
                                                        echo '<li><hr class="dropdown-divider"></li>';
                                                    }
                                                ?>
                                                <li><button class="dropdown-item" type="button" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" id="view-log-notes">View Log Notes</button></li>
                                            </ul>
                                            <?php
                                                echo $writeAccess['total'] > 0 ? 
                                                '<button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#user-account-modal">Edit</button>' : '';
                                            ?>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Display Name:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="file_as_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Email:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="email_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">User Account Status:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="active_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Lock Status:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="locked_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Password Expiry Date:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="password_expiry_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Last Connection Date:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="last_connection_date_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Last Password Reset Date:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="last_password_reset_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Account Locked Duration:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="account_lock_duration_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="user-role" role="tabpanel" aria-labelledby="user-role-tab" tabindex="0">
                        <div class="row justify-content-center">
                            <div class="col-lg-8">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center">
                                        <h5 class="card-title mb-0">User Roles</h5>
                                        <?php
                                            if($addRoleUserAccount['total'] > 0){
                                                echo '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <button class="btn btn-success mb-0 px-4" data-bs-toggle="modal" data-bs-target="#user-account-assignment-modal" id="assign-user-account">Assign</button>
                                                        </div>';        
                                            }
                                        ?>
                                    </div>
                                    <div class="card-body p-4" id="role-list"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="security" role="tabpanel" aria-labelledby="security-tab" tabindex="0">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center">
                                        <h5 class="card-title mb-0">Security Settings</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <div>
                                            <div class="d-flex align-items-center justify-content-between mb-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="text-bg-light rounded-1 p-6 d-flex align-items-center justify-content-center">
                                                        <i class="ti ti-lock text-dark d-block fs-7" width="22" height="22"></i>
                                                    </div>
                                                    <div>
                                                        <h5 class="fs-4 fw-semibold">Two-factor Authentication</h5>
                                                        <p class="mb-0 text-wrap w-80">Enhance security with 2FA, adding extra verification beyond passwords.</p>
                                                    </div>
                                                </div>
                                                <div class="form-check form-switch mb-0">
                                                    <?php
                                                        $checkboxAttributes = ($writeAccess['total'] > 0) ? '' : 'disabled';

                                                        echo '<input class="form-check-input" type="checkbox" role="switch" id="two-factor-authentication" ' . $checkboxAttributes . '>';
                                                    ?>
                                                </div>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between mb-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="text-bg-light rounded-1 p-6 d-flex align-items-center justify-content-center">
                                                        <i class="ti ti-login text-dark d-block fs-7" width="22" height="22"></i>
                                                    </div>
                                                    <div>
                                                        <h5 class="fs-4 fw-semibold">Multiple Login Sessions</h5>
                                                        <p class="mb-0 text-wrap w-80">Track logins with Multiple Sessions, get alerts for unfamiliar activity, boost security.</p>
                                                    </div>
                                                </div>
                                                <div class="form-check form-switch mb-0">
                                                    <?php
                                                        $checkboxAttributes = ($writeAccess['total'] > 0) ? '' : 'disabled';
                                                        
                                                        echo '<input class="form-check-input" type="checkbox" role="switch" id="multiple-login-sessions" ' . $checkboxAttributes . '>';
                                                    ?>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="user-account-modal" class="modal fade" tabindex="-1" aria-labelledby="user-account-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit User Account Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="user-account-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="col-sm-4 form-label" for="file_as">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="file_as" name="file_as" maxlength="300" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="col-sm-4 form-label" for="email">Email Address <span class="text-danger">*</span></label>
                                <input type="email" class="form-control maxlength" id="email" name="email" maxlength="250" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="user-account-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="user-account-profile-picture-modal" class="modal fade" tabindex="-1" aria-labelledby="user-account-profile-picture-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit User Account Profile Picture</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="user-account-profile-picture-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <input type="file" class="form-control" id="profile_picture" name="profile_picture">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="user-account-profile-picture-form" class="btn btn-success" id="submit-profile-picture">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="change-password-modal" class="modal fade" tabindex="-1" aria-labelledby="change-password-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Change Password</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="change-password-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="col-sm-4 form-label" for="new_password">New Password <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="new_password" name="new_password">
                                    <button class="btn btn-dark rounded-end d-flex align-items-center password-addon" type="button">
                                        <i class="ti ti-eye"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="col-sm-4 form-label" for="confirm_password">Confirm Password <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="confirm_password" name="confirm_password">
                                    <button class="btn btn-dark rounded-end d-flex align-items-center password-addon" type="button">
                                        <i class="ti ti-eye"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="change-password-form" class="btn btn-success" id="submit-change-password">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="user-account-assignment-modal" class="modal fade" tabindex="-1" aria-labelledby="user-account-assignment-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Assign User Account</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="user-account-assignment-form" method="post" action="#">
                    <div class="row">
                        <div class="col-12">
                            <select multiple="multiple" size="20" id="role_id" name="role_id[]"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="user-account-assignment-form" class="btn btn-success" id="submit-user-account-assignment">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_internal_log_notes.php'); ?>