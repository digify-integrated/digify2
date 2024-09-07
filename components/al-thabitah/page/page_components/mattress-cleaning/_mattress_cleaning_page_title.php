<?php
$mattressCleaningTitleDetails = $pageTitleModel->getPageTitle(10);
$mattressCleaningTitleBlockStyle = $mattressCleaningTitleDetails['block_style_id'] ?? null;
$mattressCleaningPageTitle = $mattressCleaningTitleDetails['page_title'] ?? null;
$mattressCleaningPageHeading = $mattressCleaningTitleDetails['page_heading'] ?? null;
$mattressCleaningPageTitleImage = $mattressCleaningTitleDetails['page_title_image'] ?? null;

$mattressCleaningTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($mattressCleaningTitleBlockStyle);
$mattressCleaningTitleBlockContainer = $mattressCleaningTitleBlockContainerDetails['block_container'] ?? null;

$mattressCleaningTitleBlockItemDetails = $blockStyleModel->getBlockItem($mattressCleaningTitleBlockStyle);
$mattressCleaningTitleBlockItem = $mattressCleaningTitleBlockItemDetails['block_item'] ?? null;

$mattressCleaningTitleBlockItem = str_replace('#{PAGE_TITLE}', $mattressCleaningPageTitle, $mattressCleaningTitleBlockItem);
$mattressCleaningTitleBlockItem = str_replace('#{PAGE_HEADING}', $mattressCleaningPageHeading, $mattressCleaningTitleBlockItem);


$mattressCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $mattressCleaningPageTitleImage, $mattressCleaningTitleBlockContainer);
$mattressCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $mattressCleaningTitleBlockItem, $mattressCleaningTitleBlockContainer);

echo $mattressCleaningTitleBlockContainer;
?>