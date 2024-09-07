<?php
$bookingTitleDetails = $pageTitleModel->getPageTitle(15);
$bookingTitleBlockStyle = $bookingTitleDetails['block_style_id'] ?? null;
$bookingPageTitle = $bookingTitleDetails['page_title'] ?? null;
$bookingPageHeading = $bookingTitleDetails['page_heading'] ?? null;
$bookingPageTitleImage = $bookingTitleDetails['page_title_image'] ?? null;

$bookingTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($bookingTitleBlockStyle);
$bookingTitleBlockContainer = $bookingTitleBlockContainerDetails['block_container'] ?? null;

$bookingTitleBlockItemDetails = $blockStyleModel->getBlockItem($bookingTitleBlockStyle);
$bookingTitleBlockItem = $bookingTitleBlockItemDetails['block_item'] ?? null;

$bookingTitleBlockItem = str_replace('#{PAGE_TITLE}', $bookingPageTitle, $bookingTitleBlockItem);
$bookingTitleBlockItem = str_replace('#{PAGE_HEADING}', $bookingPageHeading, $bookingTitleBlockItem);


$bookingTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $bookingPageTitleImage, $bookingTitleBlockContainer);
$bookingTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $bookingTitleBlockItem, $bookingTitleBlockContainer);

echo $bookingTitleBlockContainer;
?>