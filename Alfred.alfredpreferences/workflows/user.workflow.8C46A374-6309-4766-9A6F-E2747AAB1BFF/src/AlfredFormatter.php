<?php
declare(strict_types=1);

namespace ebylund\Uuid;

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