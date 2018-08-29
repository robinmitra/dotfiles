<?php
/**
 * @author			FirePanther
 * @copyright		FirePanther (http://firepanther.pro/)
 * @description		some functions for this workflow
 * @date			2014
 * @version			1.0
 */

$w = new Workflows();
$root_dir = dirname(__FILE__).'/';

function add($return = '', $title = '', $text = '', $img = null) {
	global $w, $root_dir;
	// default icon
	if ($img === null)
		$img = 'icon.png';
	
	if (strstr($return, '{title}'))
		$return = str_replace('{title}', $title, $return);
	if (strstr($return, '{text}'))
		$return = str_replace('{text}', $title, $return);
	
	$w->result('', $return, $title, $text, $img);
}

function show() {
	global $w, $root_dir;
	echo $w->toxml();
}

function show_error($msg) {
	global $w;
	add('', $msg, 'Fehler');
	echo $w->toxml();
	exit;
}