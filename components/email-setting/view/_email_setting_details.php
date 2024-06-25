<?php
    $writeAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');
    $deleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');
    $createAccess = $globalModel->checkAccessRights($userID, $pageID, 'create');
?>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Email Setting</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <?php
                            if($createAccess['total'] > 0 || $deleteAccess['total'] > 0){
                                echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Email Setting</a></li>' : '';
                                echo $deleteAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="delete-email-setting">Delete Email Setting</button></li>' : '';
                            }
                        ?>
                    </ul>
                </div>
                <?php
                    echo $writeAccess['total'] > 0 ? 
                    '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                        <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#email-setting-modal" id="edit-details">Edit</button>
                    </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Display Name:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="email_setting_name_summary">--</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Description:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="email_setting_description_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Host:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="mail_host_summary">--</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Port:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="port_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Username:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="mail_username_summary">--</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Mail From Name:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="mail_from_name_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Mail From Email:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="mail_from_email_summary">--</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">Mail Encryption:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="mail_encryption_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">SMTP Authentication:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="smtp_auth_summary">--</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group row">
                            <label class="form-label col-md-5">SMTP Auto TLS:</label>
                            <div class="col-md-7">
                                <p class="form-control-static" id="smtp_auto_tls_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="email-setting-modal" class="modal fade" tabindex="-1" aria-labelledby="email-setting-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Email Setting Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="email-setting-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="email_setting_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="email_setting_name" name="email_setting_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="email_setting_description">Description <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="email_setting_description" name="email_setting_description" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="mail_host">Host <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="mail_host" name="mail_host" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="port">Port <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="port" name="port" maxlength="10" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="mail_username">Email Username <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="mail_username" name="mail_username" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="mail_password">Email Password <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="mail_password" name="mail_password">
                                    <button class="btn btn-dark rounded-end d-flex align-items-center password-addon" type="button">
                                        <i class="ti ti-eye"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="mail_from_name">Mail From Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="mail_from_name" name="mail_from_name" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="mail_from_email">Mail From Email <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="mail_from_email" name="mail_from_email" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="mail_encryption">Mail Encryption <span class="text-danger">*</span></label>
                                <select class="form-control" id="mail_encryption" name="mail_encryption">
                                    <option value="none">None</option>
                                    <option value="ssl">SSL</option>
                                    <option value="starttls">Start TLS</option>
                                    <option value="tls">TLS</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="smtp_auth">SMTP Authentication <span class="text-danger">*</span></label>
                                <select class="form-control" id="smtp_auth" name="smtp_auth">
                                    <option value="0">No</option>
                                    <option value="1">Yes</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="smtp_auto_tls">SMTP Auto TLS <span class="text-danger">*</span></label>
                                <select class="form-control" id="smtp_auto_tls" name="smtp_auto_tls">
                                    <option value="0">No</option>
                                    <option value="1">Yes</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="email-setting-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_internal_log_notes.php'); ?>