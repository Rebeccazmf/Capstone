<?php
    require(dirname(__FILE__).'/db/MySQLDAO.php');
    require(dirname(__FILE__).'/Classes/PasswordReset.php');
    

    $dao =new MySQLDao();
    try {
        $emailConfirmation = new EmailConfirmation();
        $emailToken = $emailConfirmation->generateUniqueToken(16);
        //Prepare email mesage paramaters like Subject, Mesasge, From, To and etc.
        $messageDetails = array();
        $messageDetails["message_subject"] = "Password reset requested";
        $messageDetails["to_email"] = "fanyuecan@gmail.com";
        $messageDetails["from_name"] = "ParkYourCar";
        $messageDetails["from_email"] = "no-reply@rhcolud.com";
        //Load up email message from an email template
        $messageDetails = array();
        $messageDetails["message_subject"] = "Password reset requested";
        $messageDetails["to_email"] = $userDetails["email"];
        $messageDetails["from_name"] = "ParkYourCar";
        $messageDetails["from_email"] = "fanyuecan@gmail.com";
        // Load email message html template and insert html link to click and beging parssword reset
        $messageBody = $emailConfirmation->loadEmailEmailMessage();
        $emailMessage = str_replace("{token}", $passwordToken, $messageBody);
        $messageDetails["message_body"] = $emailMessage;
        // Send out email message to user
        $emailConfirmation->sendEmailConfirmation($messageDetails);

        
        
        
    } catch (Exception $e) {
        print('Caught exception: '.$e->getMessage()."\n");
    }
    
   
  
    $dao->closeConnection();
