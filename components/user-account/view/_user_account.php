<?php
    $activateUserAccount = $globalModel->checkSystemActionAccessRights($userID, 3);
    $deactivateUserAccount = $globalModel->checkSystemActionAccessRights($userID, 4);
    $lockUserAccount = $globalModel->checkSystemActionAccessRights($userID, 5);
    $unlockUserAccount = $globalModel->checkSystemActionAccessRights($userID, 6);
?>

<div class="card card-body">
    <div class="row">
        <div class="col-md-4 col-xl-3">
            <div class="position-relative">
                <input type="text" class="form-control product-search ps-5" id="datatable-search" placeholder="Search..." />
                <i class="ti ti-search position-absolute top-50 start-0 translate-middle-y fs-6 text-dark ms-3"></i>
            </div>
        </div>
        <div class="col-md-8 col-xl-9 text-end d-flex justify-content-md-end justify-content-center mt-3 mt-md-0">
            <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                <?php
                    if($deleteAccess['total'] > 0 || $activateUserAccount['total'] > 0 || $deactivateUserAccount['total'] > 0 || $lockUserAccount['total'] > 0 || $unlockUserAccount['total'] > 0){
                        $dropdown = '<button type="button" class="btn btn-dark dropdown-toggle action-dropdown mb-0 d-none" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                                <ul class="dropdown-menu dropdown-menu-end">';

                        $dropdown .= $deactivateUserAccount['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="deactivate-user-account">Deactivate User Account</button></li>' : '';

                        $dropdown .= $activateUserAccount['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="activate-user-account">Activate User Account</button></li>' : '';

                        $dropdown .= $unlockUserAccount['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="unlock-user-account">Unlock User Account</button></li>' : '';

                        $dropdown .= $lockUserAccount['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="lock-user-account">Lock User Account</button></li>' : '';

                        $dropdown .= $deleteAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="delete-user-account">Delete User Account</button></li>' : '';

                        $dropdown .= '</ul>';

                        echo $dropdown;
                    }

                    echo $createAccess['total'] > 0 ? '<a href="'. $pageLink .'&new" class="btn btn-success d-flex align-items-center mb-0">Create</a>' : '';
                ?>
                <button type="button" class="btn btn-warning mb-0 px-4" data-bs-toggle="offcanvas" data-bs-target="#filter-offcanvas" aria-controls="filter-offcanvas">Filter</a>
            </div>
        </div>
    </div>
</div>

<div class="datatables">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive overflow-x-auto">
                        <table id="user-account-table" class="table align-middle text-nowrap w-100 mb-4">
                            <thead class="text-dark">
                                <tr>
                                    <th class="all">
                                        <div class="form-check">
                                            <input class="form-check-input" id="datatable-checkbox" type="checkbox">
                                        </div>
                                    </th>
                                    <th class="min-phone-l">User Account</th>
                                    <th>Status</th>
                                    <th>Locked</th>
                                    <th>Password Expiry Date</th>
                                    <th>Last Connection Date</th>
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

<div class="offcanvas offcanvas-start" tabindex="-1" id="filter-offcanvas" aria-labelledby="filter-offcanvas-label">
    <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="filter-offcanvas-label">Filter</h5>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body p-0">
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-2 mx-4 fw-semibold">By User Account Status</h6>
            <div class="pb-2 px-4 text-dark">
                <div class="form-check py-2 mb-0">
                    <input class="form-check-input warning" type="radio" name="filter-user-account-status" id="filter-user-account-status-all" value="" checked>
                    <label class="form-check-label" for="filter-user-account-status-all">All</label>
                </div>
                <div class="form-check py-2 mb-0">
                    <input class="form-check-input warning" type="radio" name="filter-user-account-status" id="filter-user-account-status-yes" value="Yes">
                    <label class="form-check-label" for="filter-user-account-status-yes">Active</label>
                </div>
                <div class="form-check py-2 mb-0">
                    <input class="form-check-input warning" type="radio" name="filter-user-account-status" id="filter-user-account-status-no" value="No">
                    <label class="form-check-label" for="filter-user-account-status-no">Inactive</label>
                </div>
            </div>
            <h6 class="mb-2 mx-4 fw-semibold">By User Account Lock Status</h6>
            <div class="pb-2 px-4 text-dark">
                <div class="form-check py-2 mb-0">
                    <input class="form-check-input warning" type="radio" name="filter-user-account-lock-status" id="filter-user-account-status-lock-all" value="" checked>
                    <label class="form-check-label" for="filter-user-account-status-lock-all">All</label>
                </div>
                <div class="form-check py-2 mb-0">
                    <input class="form-check-input warning" type="radio" name="filter-user-account-lock-status" id="filter-user-account-status-lock-yes" value="Yes">
                    <label class="form-check-label" for="filter-user-account-status-lock-yes">Yes</label>
                </div>
                <div class="form-check py-2 mb-0">
                    <input class="form-check-input warning" type="radio" name="filter-user-account-lock-status" id="filter-user-account-status-lock-no" value="No">
                    <label class="form-check-label" for="filter-user-account-status-lock-no">No</label>
                </div>
            </div>
            <h6 class="mb-2 mx-4 fw-semibold">By Password Expiry Date</h6>
            <div class="pb-2 px-4">
                <div class="input-group mb-3">
                    <input type="text" id="filter-password-expiry-date" class="form-control filter-daterange" autocomplete="off" />
                    <span class="input-group-text">
                        <i class="ti ti-calendar fs-5"></i>
                    </span>
                </div>
            </div>
            <h6 class="mb-2 mx-4 fw-semibold">By Last Connection Date</h6>
            <div class="pb-2 px-4">
                <div class="input-group mb-3">
                    <input type="text" id="filter-last-connection-date" class="form-control filter-daterange" autocomplete="off" />
                    <span class="input-group-text">
                        <i class="ti ti-calendar fs-5"></i>
                    </span>
                </div>
            </div>
        </div>
        <div class="p-4">
            <button type="button" class="btn btn-warning w-100" id="apply-filter">Apply Filter</button>
        </div>
    </div>
</div>