<?php
$carpetCleaningTitleDetails = $pageTitleModel->getPageTitle(9);
$carpetCleaningTitleBlockStyle = $carpetCleaningTitleDetails['block_style_id'] ?? null;
$carpetCleaningPageTitle = $carpetCleaningTitleDetails['page_title'] ?? null;
$carpetCleaningPageHeading = $carpetCleaningTitleDetails['page_heading'] ?? null;
$carpetCleaningPageTitleImage = $carpetCleaningTitleDetails['page_title_image'] ?? null;

$carpetCleaningTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($carpetCleaningTitleBlockStyle);
$carpetCleaningTitleBlockContainer = $carpetCleaningTitleBlockContainerDetails['block_container'] ?? null;

$carpetCleaningTitleBlockItemDetails = $blockStyleModel->getBlockItem($carpetCleaningTitleBlockStyle);
$carpetCleaningTitleBlockItem = $carpetCleaningTitleBlockItemDetails['block_item'] ?? null;

$carpetCleaningTitleBlockItem = str_replace('#{PAGE_TITLE}', $carpetCleaningPageTitle, $carpetCleaningTitleBlockItem);
$carpetCleaningTitleBlockItem = str_replace('#{PAGE_HEADING}', $carpetCleaningPageHeading, $carpetCleaningTitleBlockItem);


$carpetCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $carpetCleaningPageTitleImage, $carpetCleaningTitleBlockContainer);
$carpetCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $carpetCleaningTitleBlockItem, $carpetCleaningTitleBlockContainer);

echo $carpetCleaningTitleBlockContainer;
?>