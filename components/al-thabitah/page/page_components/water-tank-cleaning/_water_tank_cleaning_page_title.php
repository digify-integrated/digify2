<?php
$waterTankCleaningTitleDetails = $pageTitleModel->getPageTitle(6);
$waterTankCleaningTitleBlockStyle = $waterTankCleaningTitleDetails['block_style_id'] ?? null;
$waterTankCleaningPageTitle = $waterTankCleaningTitleDetails['page_title'] ?? null;
$waterTankCleaningPageHeading = $waterTankCleaningTitleDetails['page_heading'] ?? null;
$waterTankCleaningPageTitleImage = $waterTankCleaningTitleDetails['page_title_image'] ?? null;

$waterTankCleaningTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($waterTankCleaningTitleBlockStyle);
$waterTankCleaningTitleBlockContainer = $waterTankCleaningTitleBlockContainerDetails['block_container'] ?? null;

$waterTankCleaningTitleBlockItemDetails = $blockStyleModel->getBlockItem($waterTankCleaningTitleBlockStyle);
$waterTankCleaningTitleBlockItem = $waterTankCleaningTitleBlockItemDetails['block_item'] ?? null;

$waterTankCleaningTitleBlockItem = str_replace('#{PAGE_TITLE}', $waterTankCleaningPageTitle, $waterTankCleaningTitleBlockItem);
$waterTankCleaningTitleBlockItem = str_replace('#{PAGE_HEADING}', $waterTankCleaningPageHeading, $waterTankCleaningTitleBlockItem);


$waterTankCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $waterTankCleaningPageTitleImage, $waterTankCleaningTitleBlockContainer);
$waterTankCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $waterTankCleaningTitleBlockItem, $waterTankCleaningTitleBlockContainer);

echo $waterTankCleaningTitleBlockContainer;
?>