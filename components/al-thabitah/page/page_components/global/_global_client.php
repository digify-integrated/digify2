<?php
$getGlobalClientDetails = $clientModel->getClient(1);
$globalClientBlockStyle = $getGlobalClientDetails['block_style_id'] ?? null;

$globalClientBlockContainerDetails = $blockStyleModel->getBlockContainer($globalClientBlockStyle);
$globalClientBlockContainer = $globalClientBlockContainerDetails['block_container'] ?? null;

$globalClientBlockItemDetails = $blockStyleModel->getBlockItem($globalClientBlockStyle);
$globalClientBlockItem = $globalClientBlockItemDetails['block_item'] ?? null;

$globalClientItems = $clientModel->getClientItemByClientID(1);

$globalClientItemHtml = '';
foreach ($globalClientItems as $globalClientItem) {
    $globalClientBlockItemTemplate = $globalClientBlockItem; // create a copy of the template for each item

    $replacements = [
        '#{CLIENT_URL}' => $globalClientItem['client_url'],
        '#{CLIENT_LOGO}' => $globalClientItem['client_logo']
    ];

    $globalClientBlockItemHtml = str_replace(array_keys($replacements), array_values($replacements), $globalClientBlockItemTemplate);

    $globalClientItemHtml .= $globalClientBlockItemHtml;
}

$globalClientBlockContainer = str_replace('#{CLIENT_ITEM}', $globalClientItemHtml, $globalClientBlockContainer);

echo $globalClientBlockContainer;
?>