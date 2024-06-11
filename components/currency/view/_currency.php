<div  class="datatables">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex align-items-center">
                    <h5 class="card-title mb-0">Currency List</h5>
                    <div class="card-actions cursor-pointer ms-auto d-flex button-item">
                    <?php
                        echo $currencyDeleteAccess['total'] > 0 ? '<button type="button" class="btn btn-dark dropdown-toggle action-dropdown mb-0 d-none" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><button class="dropdown-item" type="button" id="delete-currency">Delete Currency</button></li>
                        </ul>' : '';
                    ?>
                    </div>
                    <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                        <?php
                            if($currencyCreateAccess['total'] > 0){
                                echo '<a href="'. $pageLink .'&new" class="btn btn-success d-flex align-items-center mb-0">Create</a>';
                            }
                        ?>
                    </div>
                </div>
                <div class="card-body">
                    <input type="hidden" id="page-id" value="<?php echo $pageID; ?>">
                    <div class="table-responsive">
                        <table id="currency-table" class="table border table-striped table-hover align-middle text-nowrap mb-0">
                            <thead class="text-dark">
                                <tr>
                                    <th class="all">
                                        <div class="form-check">
                                            <input class="form-check-input" id="datatable-checkbox" type="checkbox">
                                        </div>
                                    </th>
                                    <th>Currency</th>
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