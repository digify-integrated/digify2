<?php
$windowCleaningTitleDetails = $pageTitleModel->getPageTitle(7);
$windowCleaningTitleBlockStyle = $windowCleaningTitleDetails['block_style_id'] ?? null;
$windowCleaningPageTitle = $windowCleaningTitleDetails['page_title'] ?? null;
$windowCleaningPageHeading = $windowCleaningTitleDetails['page_heading'] ?? null;
$windowCleaningPageTitleImage = $windowCleaningTitleDetails['page_title_image'] ?? null;

$windowCleaningTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($windowCleaningTitleBlockStyle);
$windowCleaningTitleBlockContainer = $windowCleaningTitleBlockContainerDetails['block_container'] ?? null;

$windowCleaningTitleBlockItemDetails = $blockStyleModel->getBlockItem($windowCleaningTitleBlockStyle);
$windowCleaningTitleBlockItem = $windowCleaningTitleBlockItemDetails['block_item'] ?? null;

$windowCleaningTitleBlockItem = str_replace('#{PAGE_TITLE}', $windowCleaningPageTitle, $windowCleaningTitleBlockItem);
$windowCleaningTitleBlockItem = str_replace('#{PAGE_HEADING}', $windowCleaningPageHeading, $windowCleaningTitleBlockItem);


$windowCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $windowCleaningPageTitleImage, $windowCleaningTitleBlockContainer);
$windowCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $windowCleaningTitleBlockItem, $windowCleaningTitleBlockContainer);

echo $windowCleaningTitleBlockContainer;
?>