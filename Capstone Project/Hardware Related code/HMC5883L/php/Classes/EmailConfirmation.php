<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

class EmailConfirmation{
  function generateUniqueToken($tokenLength)
  {
 $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
      $charactersLength = strlen($characters);
      $randomString = '';
      for ($i = 0; $i < $tokenLength; $i++) {
         $randomString .= $characters[rand(0, $charactersLength - 1)];
      }
      return $randomString; 
  }
  
  function sendEmailConfirmation($messageDetails)
  {
      $message_subject = $messageDetails["message_subject"];
        $to_email = $messageDetails["to_email"];
        $from_name = $messageDetails["from_name"];
        $from_email = $messageDetails["from_email"];
        $message_body = $messageDetails["message_body"];
     
        $headers = "MIME-Version: 1.0" . "\r\n";
        $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
        $headers .= "From: " . $from_name  ." <".$from_email.">" . "\r\n";
       
        mail($to_email,$message_subject,$message_body, $headers);  
  }
  
  function loadEmailEmailMessage(){
      
      $myfile = fopen(dirname(__FILE__).'/emailMessage.html', "r");
       $returnValue =  fread($myfile,filesize(dirname(__FILE__).'/emailMessage.html'));
       fclose($myfile);
       
      return $returnValue;
  }
  
   function generateMessageBody()
    {
       $myfile = fopen(dirname(__FILE__).'/passwordRestMessage.html', "r");
       $returnValue =  fread($myfile,filesize(dirname(__FILE__).'/passwordRestMessage.html'));
       fclose($myfile);
       
       return $returnValue;
    }
      
    
    
}