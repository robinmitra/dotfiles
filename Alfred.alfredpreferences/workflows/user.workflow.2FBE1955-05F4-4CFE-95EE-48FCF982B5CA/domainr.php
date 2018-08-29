<?php

// Code based on the Domainr workflow by dingyi (http://dingis.me)

require_once( 'workflows.php' );

$w = new Workflows();
$query = urlencode( "{$argv[1]}" );
$url = "https://domainr.com/api/json/search?q=$query";
$domains = $w->request( $url );
$domains = json_decode( $domains );

foreach ( $domains->results as $results ) {
  if ( $results->availability == 'tld' )
    $domain = '*.' . $results->domain;
  else
    $domain = $results->domain;

  if ( isset( $results->path ) && ! empty( $results->path ) )
    $domain .= $results->path;

  $w->result(
    $results->register_url,
    $results->register_url,
    $domain,
    $results->availability,
    available( $results->availability )
  );
};

echo $w->toxml();

function available( $sub ) {

  if ( $sub == 'available' )
    return 'icons/green.png';

  if ( $sub == 'maybe' )
    return 'icons/yellow.png';

  if ( $sub == 'tld' )
    return 'icons/gray.png';

  return 'icons/red.png';

}
