<?php
$pestControlServiceTitleDetails = $pageTitleModel->getPageTitle(13);
$pestControlServiceTitleBlockStyle = $pestControlServiceTitleDetails['block_style_id'] ?? null;
$pestControlServicePageTitle = $pestControlServiceTitleDetails['page_title'] ?? null;
$pestControlServicePageHeading = $pestControlServiceTitleDetails['page_heading'] ?? null;
$pestControlServicePageTitleImage = $pestControlServiceTitleDetails['page_title_image'] ?? null;

$pestControlServiceTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($pestControlServiceTitleBlockStyle);
$pestControlServiceTitleBlockContainer = $pestControlServiceTitleBlockContainerDetails['block_container'] ?? null;

$pestControlServiceTitleBlockItemDetails = $blockStyleModel->getBlockItem($pestControlServiceTitleBlockStyle);
$pestControlServiceTitleBlockItem = $pestControlServiceTitleBlockItemDetails['block_item'] ?? null;

$pestControlServiceTitleBlockItem = str_replace('#{PAGE_TITLE}', $pestControlServicePageTitle, $pestControlServiceTitleBlockItem);
$pestControlServiceTitleBlockItem = str_replace('#{PAGE_HEADING}', $pestControlServicePageHeading, $pestControlServiceTitleBlockItem);


$pestControlServiceTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $pestControlServicePageTitleImage, $pestControlServiceTitleBlockContainer);
$pestControlServiceTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $pestControlServiceTitleBlockItem, $pestControlServiceTitleBlockContainer);

echo $pestControlServiceTitleBlockContainer;
?>