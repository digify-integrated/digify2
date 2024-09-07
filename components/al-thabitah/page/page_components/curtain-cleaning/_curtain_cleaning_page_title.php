<?php
$curtainCleaningTitleDetails = $pageTitleModel->getPageTitle(11);
$curtainCleaningTitleBlockStyle = $curtainCleaningTitleDetails['block_style_id'] ?? null;
$curtainCleaningPageTitle = $curtainCleaningTitleDetails['page_title'] ?? null;
$curtainCleaningPageHeading = $curtainCleaningTitleDetails['page_heading'] ?? null;
$curtainCleaningPageTitleImage = $curtainCleaningTitleDetails['page_title_image'] ?? null;

$curtainCleaningTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($curtainCleaningTitleBlockStyle);
$curtainCleaningTitleBlockContainer = $curtainCleaningTitleBlockContainerDetails['block_container'] ?? null;

$curtainCleaningTitleBlockItemDetails = $blockStyleModel->getBlockItem($curtainCleaningTitleBlockStyle);
$curtainCleaningTitleBlockItem = $curtainCleaningTitleBlockItemDetails['block_item'] ?? null;

$curtainCleaningTitleBlockItem = str_replace('#{PAGE_TITLE}', $curtainCleaningPageTitle, $curtainCleaningTitleBlockItem);
$curtainCleaningTitleBlockItem = str_replace('#{PAGE_HEADING}', $curtainCleaningPageHeading, $curtainCleaningTitleBlockItem);


$curtainCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $curtainCleaningPageTitleImage, $curtainCleaningTitleBlockContainer);
$curtainCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $curtainCleaningTitleBlockItem, $curtainCleaningTitleBlockContainer);

echo $curtainCleaningTitleBlockContainer;
?>