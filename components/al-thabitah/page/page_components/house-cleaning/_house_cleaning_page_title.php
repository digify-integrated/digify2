<?php
$houseCleaningTitleDetails = $pageTitleModel->getPageTitle(3);
$houseCleaningTitleBlockStyle = $houseCleaningTitleDetails['block_style_id'] ?? null;
$houseCleaningPageTitle = $houseCleaningTitleDetails['page_title'] ?? null;
$houseCleaningPageHeading = $houseCleaningTitleDetails['page_heading'] ?? null;
$houseCleaningPageTitleImage = $houseCleaningTitleDetails['page_title_image'] ?? null;

$houseCleaningTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($houseCleaningTitleBlockStyle);
$houseCleaningTitleBlockContainer = $houseCleaningTitleBlockContainerDetails['block_container'] ?? null;

$houseCleaningTitleBlockItemDetails = $blockStyleModel->getBlockItem($houseCleaningTitleBlockStyle);
$houseCleaningTitleBlockItem = $houseCleaningTitleBlockItemDetails['block_item'] ?? null;

$houseCleaningTitleBlockItem = str_replace('#{PAGE_TITLE}', $houseCleaningPageTitle, $houseCleaningTitleBlockItem);
$houseCleaningTitleBlockItem = str_replace('#{PAGE_HEADING}', $houseCleaningPageHeading, $houseCleaningTitleBlockItem);


$houseCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $houseCleaningPageTitleImage, $houseCleaningTitleBlockContainer);
$houseCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $houseCleaningTitleBlockItem, $houseCleaningTitleBlockContainer);

echo $houseCleaningTitleBlockContainer;
?>