<div  class="datatables">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex align-items-center">
                    <h5 class="card-title mb-0">Menu Item List</h5>
                    <div class="card-actions cursor-pointer ms-auto d-flex button-item">
                    <?php
                        echo $menuItemDeleteAccess['total'] > 0 ? '<button type="button" class="btn btn-dark dropdown-toggle action-dropdown mb-0 d-none" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><button class="dropdown-item" type="button" id="delete-menu-item">Delete Menu Item</button></li>
                        </ul>' : '';
                    ?>
                    </div>
                    <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                        <?php
                            if($menuItemCreateAccess['total'] > 0){
                                echo '<a href="'. $pageLink .'&new" class="btn btn-success d-flex align-items-center mb-0">Create</a>';
                            }
                        ?>
                        <button type="button" class="btn btn-warning mb-0 px-4" data-bs-toggle="offcanvas" data-bs-target="#filter-offcanvas" aria-controls="filter-offcanvas">Filter</a>
                    </div>
                </div>
                <div class="card-body">
                    <input type="hidden" id="page-id" value="<?php echo $pageID; ?>">
                    <div class="table-responsive">
                        <table id="menu-item-table" class="table border table-striped table-hover align-middle text-nowrap mb-0">
                            <thead class="text-dark">
                                <tr>
                                    <th class="all">
                                        <div class="form-check">
                                            <input class="form-check-input" id="datatable-checkbox" type="checkbox">
                                        </div>
                                    </th>
                                    <th>Menu Item</th>
                                    <th>App Module</th>
                                    <th>Order Sequence</th>
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
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By App Module</h6>
            <div class="pb-4 px-4" id="app-module-filter"></div>
        </div>
        <div class="p-4">
            <button type="button" class="btn btn-warning w-100" id="apply-filter">Apply Filter</button>
        </div>
    </div>
</div>