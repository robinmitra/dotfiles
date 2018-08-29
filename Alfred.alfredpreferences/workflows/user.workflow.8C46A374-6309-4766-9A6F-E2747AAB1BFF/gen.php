#!/usr/bin/env php
<?php

require_once 'vendor/autoload.php';

use Ramsey\Uuid\Uuid;

Uuid::uuid4()->toString();
