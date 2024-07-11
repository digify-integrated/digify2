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
                    echo $deleteAccess['total'] > 0 ? '<button type="button" class="btn btn-dark dropdown-toggle action-dropdown mb-0 d-none" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                                                        <ul class="dropdown-menu dropdown-menu-end">
                                                            <li><button class="dropdown-item" type="button" id="delete-employee">Delete Employee</button></li>
                                                        </ul>' : '';
                    
                    echo $createAccess['total'] > 0 ? '<a href="'. $pageLink .'&new" class="btn btn-success d-flex align-items-center mb-0">Create</a>' : '';
                ?>
                <button type="button" class="btn btn-warning mb-0 px-4" data-bs-toggle="offcanvas" data-bs-target="#filter-offcanvas" aria-controls="filter-offcanvas">Filter</a>
            </div>
        </div>
    </div>
</div>

<div class="card position-relative overflow-hidden">
    <div class="shop-part d-flex w-100">
        <div class="card-body p-4 pb-0">
            <div class="row" id="employee-cards">
                <div class="col-sm-4">
                    <div class="card overflow-hidden rounded-2 border">
                        <div class="position-relative">
                            <a href="./eco-shop-detail.html" class="hover-img d-block overflow-hidden">
                                <img src="./assets/images/profile/user-1.jpg" class="card-img-top rounded-0" alt="employee-image">
                            </a>
                        </div>
                        <div class="card-body pt-3 p-4">
                            <h6 class="fw-semibold fs-4">Super Games</h6>
                            <div class="d-flex align-items-center justify-content-between">
                                <h6 class="fw-semibold fs-4 mb-0">$285</h6>
                            </div>
                        </div>
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
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By App Module</h6>
            <div class="pb-4 px-4 text-dark" id="app-module-filter"></div>
        </div>
        <div class="p-4">
            <button type="button" class="btn btn-warning w-100" id="apply-filter">Apply Filter</button>
        </div>
    </div>
</div>