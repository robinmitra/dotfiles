<?php
function currencyrate($from, $to) {
	global $currency;
	if ($from == 'EUR')
		return $currency[$to];
	elseif ($to == 'EUR')
		return 1 / $currency[$from];
	else
		return 1 / $currency[$from] * $currency[$to];
}

if (!is_file('/tmp/currencyrates.json') || filemtime('/tmp/currencyrates.json') < time()-3600*12) {
	$fh = @fopen('http://www.x-rates.com/table/?from=EUR', 'r');
	if ($fh) {
		while ($get = fgets($fh, 4096)) {
			if (strstr($get, 'rtRates') && !strstr($get, 'to=EUR')) {
				$cut = substr($get, strpos($get, 'to=')+3);
				$to = substr($cut, 0, 3);
				$value = substr($cut, strpos($cut, '>')+1);
				$value = substr($value, 0, strpos($value, '<'));
				$currency[$to] = $value;
			}
			if (stristr($get, 'Venezuelan Bolivar'))
				break;
		}
		fclose($fh);
		file_put_contents('/tmp/currencyrates.json', json_encode($currency));
	}
} else
	$currency = @json_decode(file_get_contents('/tmp/currencyrates.json'), 1);