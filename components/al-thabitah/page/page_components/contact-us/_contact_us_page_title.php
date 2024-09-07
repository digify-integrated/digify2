<?php
$contactUsTitleDetails = $pageTitleModel->getPageTitle(14);
$contactUsTitleBlockStyle = $contactUsTitleDetails['block_style_id'] ?? null;
$contactUsPageTitle = $contactUsTitleDetails['page_title'] ?? null;
$contactUsPageHeading = $contactUsTitleDetails['page_heading'] ?? null;
$contactUsPageTitleImage = $contactUsTitleDetails['page_title_image'] ?? null;

$contactUsTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($contactUsTitleBlockStyle);
$contactUsTitleBlockContainer = $contactUsTitleBlockContainerDetails['block_container'] ?? null;

$contactUsTitleBlockItemDetails = $blockStyleModel->getBlockItem($contactUsTitleBlockStyle);
$contactUsTitleBlockItem = $contactUsTitleBlockItemDetails['block_item'] ?? null;

$contactUsTitleBlockItem = str_replace('#{PAGE_TITLE}', $contactUsPageTitle, $contactUsTitleBlockItem);
$contactUsTitleBlockItem = str_replace('#{PAGE_HEADING}', $contactUsPageHeading, $contactUsTitleBlockItem);


$contactUsTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $contactUsPageTitleImage, $contactUsTitleBlockContainer);
$contactUsTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $contactUsTitleBlockItem, $contactUsTitleBlockContainer);

echo $contactUsTitleBlockContainer;
?>