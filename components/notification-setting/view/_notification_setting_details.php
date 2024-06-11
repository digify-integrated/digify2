<div class="row">
    <div class="col-12">
        <div class="card">
            <ul class="nav nav-pills user-profile-tab" id="pills-tab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link position-relative rounded-0 active d-flex align-items-center justify-content-center bg-transparent fs-3 py-4" id="notification-setting-details-tab" data-bs-toggle="pill" data-bs-target="#notification-setting-details" type="button" role="tab" aria-controls="notification-setting-details" aria-selected="true">
                        <i class="ti ti-bell me-2 fs-6"></i>
                        <span class="d-none d-md-block">Notification Setting</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button  class="nav-link position-relative rounded-0 d-flex align-items-center justify-content-center bg-transparent fs-3 py-4" id="notification-channel-tab" data-bs-toggle="pill" data-bs-target="#notification-channel" type="button" role="tab" aria-controls="notification-channel" aria-selected="false">
                        <i class="ti ti-notification me-2 fs-6"></i>
                        <span class="d-none d-md-block">Notification Channel</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button  class="nav-link position-relative rounded-0 d-flex align-items-center justify-content-center bg-transparent fs-3 py-4" id="notification-template-tab" data-bs-toggle="pill" data-bs-target="#notification-template" type="button" role="tab" aria-controls="notification-template" aria-selected="false">
                        <i class="ti ti-bell-ringing me-2 fs-6"></i>
                        <span class="d-none d-md-block">Notification Template</span>
                    </button>
                </li>
            </ul>
            <div class="card-body">
                <div class="tab-content" id="pills-tabContent">
                    <div class="tab-pane fade show active" id="notification-setting-details" role="tabpanel" aria-labelledby="notification-setting-details-tab" tabindex="0">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center">
                                        <h5 class="card-title mb-0">Notification Setting</h5>
                                        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                            <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                                            <ul class="dropdown-menu dropdown-menu-end">
                                                <?php
                                                    if($notificationSettingCreateAccess['total'] > 0 || $notificationSettingDeleteAccess['total'] > 0){
                                                        echo $notificationSettingCreateAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Notification Setting</a></li>' : '';

                                                        echo $notificationSettingDeleteAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="delete-notification-setting">Delete Notification Setting</button></li>' : '';
                                                        
                                                        echo '<li><hr class="dropdown-divider"></li>';
                                                    }
                                                ?>
                                                <li><button class="dropdown-item" type="button" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" id="view-log-notes">View Log Notes</button></li>
                                            </ul>
                                            <?php
                                                echo $notificationSettingWriteAccess['total'] > 0 ? 
                                                '<button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#notification-setting-modal">Edit</button>' : '';
                                            ?>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Display Name:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="notification_setting_name_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group row">
                                                    <label class="form-label col-md-5">Description:</label>
                                                    <div class="col-md-7">
                                                        <p class="form-control-static" id="notification_setting_description_summary">--</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="notification-channel" role="tabpanel" aria-labelledby="notification-channel-tab" tabindex="0">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="card">
                                    <div class="card-header d-flex align-items-center">
                                        <h5 class="card-title mb-0">Notification Channel</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <div>
                                            <div class="d-flex align-items-center justify-content-between mb-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="text-bg-light rounded-1 p-6 d-flex align-items-center justify-content-center">
                                                        <i class="ti ti-bell-ringing text-dark d-block fs-7" width="22" height="22"></i>
                                                    </div>
                                                    <div>
                                                        <h5 class="fs-4 fw-semibold">System Notification</h5>
                                                    </div>
                                                </div>
                                                <div class="form-check form-switch mb-0">
                                                    <?php
                                                        $checkboxAttributes = ($notificationSettingWriteAccess['total'] > 0) ? '' : 'disabled';

                                                        echo '<input class="form-check-input" type="checkbox" role="switch" id="system-notification" ' . $checkboxAttributes . '>';
                                                    ?>
                                                </div>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between mb-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="text-bg-light rounded-1 p-6 d-flex align-items-center justify-content-center">
                                                        <i class="ti ti-mail text-dark d-block fs-7" width="22" height="22"></i>
                                                    </div>
                                                    <div>
                                                        <h5 class="fs-4 fw-semibold">Email Notification</h5>
                                                    </div>
                                                </div>
                                                <div class="form-check form-switch mb-0">
                                                    <?php
                                                        $checkboxAttributes = ($notificationSettingWriteAccess['total'] > 0) ? '' : 'disabled';
                                                        
                                                        echo '<input class="form-check-input" type="checkbox" role="switch" id="email-notification" ' . $checkboxAttributes . '>';
                                                    ?>
                                                </div>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between mb-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="text-bg-light rounded-1 p-6 d-flex align-items-center justify-content-center">
                                                        <i class="ti ti-device-mobile text-dark d-block fs-7" width="22" height="22"></i>
                                                    </div>
                                                    <div>
                                                        <h5 class="fs-4 fw-semibold">SMS Notification</h5>
                                                    </div>
                                                </div>
                                                <div class="form-check form-switch mb-0">
                                                    <?php
                                                        $checkboxAttributes = ($notificationSettingWriteAccess['total'] > 0) ? '' : 'disabled';
                                                        
                                                        echo '<input class="form-check-input" type="checkbox" role="switch" id="sms-notification" ' . $checkboxAttributes . '>';
                                                    ?>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="notification-template" role="tabpanel" aria-labelledby="notification-template-tab" tabindex="0">
                        <div class="row justify-content-center">
                            <div class="col-lg-9">
                                <div class="card border shadow-none">
                                    <div class="card-body p-4">
                                        <h4 class="card-title">System Notification Template</h4>
                                        <p class="card-subtitle">Configure the system notification template:</p>
                                        <div class="d-flex align-items-center justify-content-between mt-7">
                                            <div class="d-flex align-items-center gap-3">
                                                <div>
                                                    <h5 class="fs-4 fw-semibold" id="system_notification_title_preview">Title</h5>
                                                    <p class="mb-0" id="system_notification_message_preview">Message</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center gap-3">
                                            <?php
                                                echo $notificationSettingWriteAccess['total'] > 0 ? 
                                                '<button class="btn btn-info" data-bs-toggle="modal" id="edit-system-notification-template-details" data-bs-target="#system-notification-template-modal">Edit</button>' : '';
                                            ?>
                                            <button class="btn btn-warning" id="view-system-notification-template-log-notes" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">View Log Notes</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row justify-content-center">
                            <div class="col-lg-9">
                                <div class="card border shadow-none">
                                    <div class="card-body p-4">
                                        <h4 class="card-title">Email Notification Template</h4>
                                        <p class="card-subtitle">Configure the email notification template:</p>
                                        <div class="d-flex align-items-center justify-content-between mt-7">
                                            <div class="d-flex align-items-center gap-3">
                                                <div>
                                                    <h5 class="fs-4 fw-semibold" id="email_notification_subject_preview">Subject</h5>
                                                    <p class="mb-0" id="email_notification_body_preview">Body</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center gap-3">
                                            <?php
                                                echo $notificationSettingWriteAccess['total'] > 0 ? 
                                                '<button class="btn btn-info" data-bs-toggle="modal" id="edit-email-notification-template-details" data-bs-target="#email-notification-template-modal">Edit</button>' : '';
                                            ?>
                                            <button class="btn btn-warning" id="view-email-notification-template-log-notes" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">View Log Notes</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row justify-content-center">
                            <div class="col-lg-9">
                                <div class="card border shadow-none">
                                    <div class="card-body p-4">
                                        <h4 class="card-title">SMS Notification Template</h4>
                                        <p class="card-subtitle">Configure the SMS notification template:</p>
                                        <div class="d-flex align-items-center justify-content-between mt-7">
                                            <div class="d-flex align-items-center gap-3">
                                                <div>
                                                    <p class="mb-0" id="sms_notification_message_preview">Message</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center gap-3">
                                            <?php
                                                echo $notificationSettingWriteAccess['total'] > 0 ? 
                                                '<button class="btn btn-info" data-bs-toggle="modal" id="edit-sms-notification-template-details" data-bs-target="#sms-notification-template-modal">Edit</button>' : '';
                                            ?>
                                            <button class="btn btn-warning" id="view-sms-notification-template-log-notes" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">View Log Notes</button>
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

<div id="notification-setting-modal" class="modal fade" tabindex="-1" aria-labelledby="notification-setting-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Notification Setting Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="notification-setting-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="notification_setting_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="notification_setting_name" name="notification_setting_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="notification_setting_description">Description <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="notification_setting_description" name="notification_setting_description" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="notification-setting-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="system-notification-template-modal" class="modal fade" tabindex="-1" aria-labelledby="system-notification-template-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit System Notification Template</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="system-notification-template-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="system_notification_title">Notification Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="system_notification_title" name="system_notification_title" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="system_notification_message">Notification Message <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="system_notification_message" name="system_notification_message" maxlength="500" rows="4"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="system-notification-template-form" class="btn btn-success" id="system-notification-template-submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="email-notification-template-modal" class="modal fade" tabindex="-1" aria-labelledby="email-notification-template-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-xl">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Email Notification Template</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="email-notification-template-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="email_notification_subject">Email Subject <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="email_notification_subject" name="email_notification_subject" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="email_notification_body">Email Body <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="email_notification_body"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="email-notification-template-form" class="btn btn-success" id="email-notification-template-submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="sms-notification-template-modal" class="modal fade" tabindex="-1" aria-labelledby="sms-notification-template-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit SMS Notification Template</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="sms-notification-template-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="sms_notification_message">Notification Message <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="sms_notification_message" name="sms_notification_message" maxlength="500" rows="4"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="sms-notification-template-form" class="btn btn-success" id="sms-notification-template-submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_internal_notes.php'); ?>
<?php require_once('components/global/view/_log_notes_offcanvas.php'); ?>