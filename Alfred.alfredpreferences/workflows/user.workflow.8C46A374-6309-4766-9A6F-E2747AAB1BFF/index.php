#!/usr/bin/env php
<?php

require_once 'vendor/autoload.php';

use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\UuidInterface;

class AlfredFormatter
{
    /**
     * @var UuidInterface
     */
    private $uuid;

    public function __construct(UuidInterface $uuid)
    {
        $this->uuid = $uuid;
    }

    public function upperNoDashes()
    {
        return strtoupper(str_replace('-', '', $this->uuid->getHex()));
    }

    public function upperWithDashes()
    {
        return strtoupper($this->uuid->toString());
    }

    public function lowerNoDashes()
    {
        return strtolower(str_replace('-', '', $this->uuid->getHex()));
    }

    public function lowerWithDashes()
    {
        return strtolower($this->uuid->toString());
    }
}

if ($argv[1] === 'gen') {
    $genUuid = Uuid::uuid4();
    $formatter = new AlfredFormatter($genUuid);
} else {
    $uuid = Uuid::fromString($argv[1]);
    $formatter = new AlfredFormatter($uuid);
}

$items = [
    'items' => [
        [
            'uid' => 'uuid upper no dashes',
            'title' => $formatter->upperNoDashes(),
            'subtitle' => 'upper no \'s',
            'arg' => $formatter->upperNoDashes(),
            'icon' => [
                'path' => 'touch.png'
            ]
        ],
        [
            'uid' => 'uuid lower no dashes',
            'title' => $formatter->lowerNoDashes(),
            'subtitle' => 'lower no -\'s',
            'arg' => $formatter->lowerNoDashes(),
            'icon' => [
                'path' => 'touch.png'
            ]
        ],
        [
            'uid' => 'uuid upper with dashes',
            'title' => $formatter->upperWithDashes(),
            'subtitle' => 'upper with -',
            'arg' => $formatter->upperWithDashes(),
            'icon' => [
                'path' => 'touch.png'
            ]
        ],
        [
            'uid' => 'uuid lower with dashes',
            'title' => $formatter->lowerWithDashes(),
            'subtitle' => 'lower with -',
            'arg' => $formatter->lowerWithDashes(),
            'icon' => [
                'path' => 'touch.png'
            ]
        ]
    ]
];

echo json_encode($items, JSON_PRETTY_PRINT);
