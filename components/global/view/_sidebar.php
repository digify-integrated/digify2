<aside class="side-mini-panel with-vertical">
  <div class="iconbar">
    <div>
      <div class="mini-nav">
        <div class="brand-logo d-flex align-items-center justify-content-center">
          <a class="nav-link sidebartoggler" id="headerCollapse" href="javascript:void(0)">
            <iconify-icon icon="solar:hamburger-menu-line-duotone" class="fs-7"></iconify-icon>
          </a>
        </div>
        <ul class="mini-nav-ul" data-simplebar>
          <li class="mini-nav-item" id="mini-apps">
            <a href="apps.php" data-bs-toggle="tooltip" data-bs-custom-class="custom-tooltip" data-bs-placement="right" data-bs-title="Apps">
              <img src="./assets/images/default/apps.png" width="35" height="35" alt="app-logo">
            </a>
          </li>
          <?php
            echo '<li class="mini-nav-item" id="mini-1">
                    <a href="javascript:void(0)" data-bs-toggle="tooltip" data-bs-custom-class="custom-tooltip" data-bs-placement="right" data-bs-title="'. $appModuleName .'">
                      <img src="'. $appLogo .'" width="40" height="40" alt="app-logo">
                    </a>
                  </li>';
          ?>
        </ul>
      </div>
      <div class="sidebarmenu">
        <div class="brand-logo d-flex align-items-center nav-logo">
          <a href="apps.php" class="text-nowrap logo-img">
            <img src="./assets/images/logos/dark-logo.svg" alt="Logo" />
          </a>
        </div>
        <nav class="sidebar-nav" id="menu-right-mini-1" data-simplebar>
          <ul class="sidebar-menu" id="sidebarnav">
            <?php
              $menu = '';
                
              $sql = $databaseModel->getConnection()->prepare('CALL buildMenuGroup(:userID)');
              $sql->bindValue(':userID', $userID, PDO::PARAM_INT);
              $sql->execute();
              $options = $sql->fetchAll(PDO::FETCH_ASSOC);
              $sql->closeCursor();
            
              foreach ($options as $row) {
                $menuGroupID = $row['menu_group_id'];
                $menuGroupName = $row['menu_group_name'];
        
                        $menu .= '<li class="nav-small-cap">
                                    <span class="hide-menu text-primary">'. $menuGroupName .'</span>
                                  </li>';
        
                        $menu .= $globalModel->buildMenuItem($userID, $menuGroupID);
                    }
            
                    echo $menu;
                ?>
          </ul>
        </nav>
      </div>
    </div>
  </div>
</aside>
