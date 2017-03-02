<?php
  require(dirname(__FILE__).'/db/MySQLDAO.php');
/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
$dao =new MySQLDao();
try{
$url="https://fycedward:Fyc646993!@devicecloud.digi.com/ws/DataStream/00000000-00000000-00409DFF-FF819157/serial_data";
$ch = curl_init();
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_URL, $url); //get the url contents

$data = curl_exec($ch); //execute curl request
curl_close($ch);

$xml = simplexml_load_string($data);

$dao->openConnection();

$value = (int)$xml->DataStream->currentValue->data;
$result = $dao->storeXml($value);

}
catch (Exception $e) {
        print('Caught exception: '.$e->getMessage()."\n");
    }

    
$dao->closeConnection();   




