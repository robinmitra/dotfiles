<?php
include 'inc.currencyrates.php';

if (preg_match('~[a-z]~', $q))
	die();

$q = str_replace(',', '.', $q);
$q = preg_replace('~[^\d.]~', '', $q);
if (substr_count($q, '.') > 1) show_error('Too many commas.');
if (substr($q, -1) == '.') $q = substr($q, 0, -1);

// get "from"
$from = 0;
switch ($calc) {
	case '$':
		$from = 'USD';
		$title = 'Calculating from dollar';
		break;
	case '€':
		$from = 'EUR';
		$title = 'Calculating from euro';
		break;
}
if (!$from) debug('$from = '.$from);

// if empty, show placeholder
if (empty($q)) {
	add('', $title, 'Please enter a value.');
	show();
	exit;
}

// get "to"
foreach ($toCurrencies as $to) {
	if ($from == $to)
		continue;
	$rate = currencyrate($from, $to);
	$value = $rate * $q;
	add('rate', number_format($value, 2, ',', ' '), 'Factor: 1 '.$from.' = '.number_format($rate, 6, ',', ' ').' '.$to, 'icons/'.strtolower($to).'.png');
}

// show
show();

/*
$s = file_get_contents('https://www.google.com/finance/converter?a='.$q.'&from=USD&to=EUR');
if (preg_match('~=bld>(.*) ~', $s, $m)) {
  $r = $m[1];
  add('{title}', number_format($r, 2, ',', ' '), '{query}'.$calc, ($calc == '$' ? 'euro' : 'dollar').'.png');
  show();
}
*/