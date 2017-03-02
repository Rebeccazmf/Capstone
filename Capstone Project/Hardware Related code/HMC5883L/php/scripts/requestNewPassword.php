<?php
require("../db/MySQLDAO.php");
require("../Classes/PasswordReset.php");
//require("../db/ConnServer.php");
/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$returnValue = array();
// Get user email address
if (empty($_REQUEST["userEmail"])) {
    $returnValue["message"] = "Missing email address";
    echo json_encode($returnValue);
    return;
}
$email = htmlentities($_REQUEST["userEmail"]);
$dao = new MySQLDAO();
$dao->openConnection();

// Check if email address is found in our database 
$userDetails = $dao->getUserDetails($email);
if (empty($userDetails)) {
    $returnValue["message"] = "Provided email address is not found in our database";
    echo json_encode($returnValue);
    return;
}
// Generate a unique string token 
$passwordReset = new PasswordReset();
$passwordToken = $passwordReset->generateUniqueToken(16);
// Store unique token in our database 
$user_id = $userDetails["user_id"];
$dao->storePasswordToken($user_id, $passwordToken);
// Prepare email message with Subject, Message, From, To... 
$messageDetails = array();
$messageDetails["message_subject"] = "Password reset requested";
$messageDetails["to_email"] = $userDetails["email"];
$messageDetails["from_name"] = "ParkYourCar";
$messageDetails["from_email"] = "no-reply@rhcolud.com";
// Load email message html template and insert html link to click and beging parssword reset
$messageBody = $passwordReset->generateMessageBody();
$emailMessage = str_replace("{token}", $passwordToken, $messageBody);
$messageDetails["message_body"] = $emailMessage;
// Send out email message to user 
$passwordReset->sendEmailMessage($messageDetails);
// Return a message to a mobile App 
$returnValue["userEmail"] = $email;
$returnValue["message"] = "We have sent you email message. Please check your Inbox.";
echo json_encode($returnValue);