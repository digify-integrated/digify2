<?php
    $addWorkHours = $globalModel->checkSystemActionAccessRights($userID, 17);
?>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Work Schedule</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <?php
                            echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Work Schedule</a></li>' : '';
                            echo $deleteAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="delete-work-schedule">Delete Work Schedule</button></li>' : '';
                        ?>
                    </ul>
                </div>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                        <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#work-schedule-modal" id="edit-details">Edit</button>
                                                    </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group row">
                            <label class="form-label col-md-3">Display Name:</label>
                            <div class="col-md-9">
                                <p class="form-control-static" id="work_schedule_name_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group row">
                            <label class="form-label col-md-3">Schedule Type:</label>
                            <div class="col-md-9">
                                <p class="form-control-static" id="schedule_type_name_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="datatables">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex align-items-center">
                    <h5 class="card-title mb-0">Work Hours</h5>
                    <?php
                        echo $addWorkHours['total'] > 0 ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                                <button class="btn btn-success d-flex align-items-center mb-0" data-bs-toggle="modal" data-bs-target="#work-hours-modal" id="add-work-hours">Create</button>
                                                            </div>' : '';
                    ?>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="work-hours-table" class="table border table-striped table-hover align-middle text-wrap mb-0">
                            <thead class="text-dark">
                                <tr>
                                    <th>Day of Week</th>
                                    <th>Day Period</th>
                                    <th>Work From</th>
                                    <th>Work To</th>
                                    <th>Notes</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="work-schedule-modal" class="modal fade" tabindex="-1" aria-labelledby="work-schedule-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Work Schedule Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
            <form id="work-schedule-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="work_schedule_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="work_schedule_name" name="work_schedule_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label class="form-label" for="schedule_type_id">Schedule Type <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="schedule_type_id" name="schedule_type_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="work-schedule-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="work-hours-modal" class="modal fade" tabindex="-1" aria-labelledby="work-hours-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Work Hours</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="work-hours-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <input type="hidden" id="work_hours_id" name="work_hours_id">
                            <label class="form-label" for="day_of_week">Day of Week <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="day_of_week" name="day_of_week" class="select2 form-control">
                                    <option value="">--</option>
                                    <option value="Monday">Monday</option>
                                    <option value="Tuesday">Tuesday</option>
                                    <option value="Wednesday">Wednesday</option>
                                    <option value="Thursday">Thursday</option>
                                    <option value="Friday">Friday</option>
                                    <option value="Saturday">Saturday</option>
                                    <option value="Sunday">Sunday</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="day_period">Day of Period <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="day_period" name="day_period" class="select2 form-control">
                                    <option value="">--</option>
                                    <option value="Morning">Morning</option>
                                    <option value="Afternoon">Afternoon</option>
                                    <option value="Evening">Evening</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <label class="form-label" for="work_from">Work From <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input class="form-control" id="work_from" name="work_from" type="time">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="work_to">Work To <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input class="form-control" id="work_to" name="work_to" type="time">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label class="form-label" for="notes">Notes</label>
                            <div class="mb-3">
                                <textarea class="form-control" id="notes" name="notes" maxlength="500" rows="4"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="work-hours-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_log_notes_offcanvas.php'); ?>
<?php require_once('components/global/view/_internal_log_notes.php'); ?>