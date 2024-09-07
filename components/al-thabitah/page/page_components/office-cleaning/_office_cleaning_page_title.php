<?php
$officeCleaningTitleDetails = $pageTitleModel->getPageTitle(4);
$officeCleaningTitleBlockStyle = $officeCleaningTitleDetails['block_style_id'] ?? null;
$officeCleaningPageTitle = $officeCleaningTitleDetails['page_title'] ?? null;
$officeCleaningPageHeading = $officeCleaningTitleDetails['page_heading'] ?? null;
$officeCleaningPageTitleImage = $officeCleaningTitleDetails['page_title_image'] ?? null;

$officeCleaningTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($officeCleaningTitleBlockStyle);
$officeCleaningTitleBlockContainer = $officeCleaningTitleBlockContainerDetails['block_container'] ?? null;

$officeCleaningTitleBlockItemDetails = $blockStyleModel->getBlockItem($officeCleaningTitleBlockStyle);
$officeCleaningTitleBlockItem = $officeCleaningTitleBlockItemDetails['block_item'] ?? null;

$officeCleaningTitleBlockItem = str_replace('#{PAGE_TITLE}', $officeCleaningPageTitle, $officeCleaningTitleBlockItem);
$officeCleaningTitleBlockItem = str_replace('#{PAGE_HEADING}', $officeCleaningPageHeading, $officeCleaningTitleBlockItem);


$officeCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $officeCleaningPageTitleImage, $officeCleaningTitleBlockContainer);
$officeCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $officeCleaningTitleBlockItem, $officeCleaningTitleBlockContainer);

echo $officeCleaningTitleBlockContainer;
?>