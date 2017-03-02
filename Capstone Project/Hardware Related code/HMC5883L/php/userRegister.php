<?php
    require(dirname(__FILE__).'/db/MySQLDAO.php');
    require(dirname(__FILE__).'/Classes/EmailConfirmation.php');
    $dao =new MySQLDao();
    try {
        
        $returnValue = array();
        if(empty($_REQUEST["userEmail"]) ||empty($_REQUEST['userPassword']))
        {
            $returnValue["status"] = "error";
            $returnValue["message"] = "Missing required field";
            echo json_encode($returnValue);
            return;
        }
        
        $userEmail = htmlentities($_REQUEST["userEmail"]);
        $userPassword = htmlentities($_REQUEST["userPassword"]);
        $userFirstName = htmlentities($_REQUEST["userFirstName"]);
        $userLastName = htmlentities($_REQUEST["userLastName"]);
        
        //Generate secure password
        $salt = openssl_random_pseudo_bytes(16);
        $secured_password = sha1($userPassword.$salt);
        
        $dao->openConnection();
        $dao->getUserDetails($userEmail);
        
        
    } catch (Exception $e) {
        print('Caught exception: '.$e->getMessage()."\n");
    }
    //Check if user with provided username is available
    $userDetails = $dao->getUserDetails($userEmail);
    if(!empty($userDetails))
    {
        $returnValue["status"] = "error";
        $returnValue["message"] = "User already exists";
        echo json_encode($returnValue);
        return;
    }
    
    //Register new user
    $result = $dao->registerUser($userEmail,$userFirstName,$userLastName,$secured_password,$salt);
    
    
    if($result)
    {
        $userDetails = $dao->getUserDetails($userEmail);
        $returnValue["status"] = "Success";
        $returnValue["message"] = "Successfully registered new user";
        $returnValue["userId"] = $userDetails["user_id"];
        $returnValue["userFirstName"] = $userDetails["first_name"];
        $returnValue["userLastName"] = $userDetails["last_name"];
        $returnValue["userEmail"] = $userDetails["email"];
        
        
        //Generate a unique email confirmation
        $emailConfirmation = new EmailConfirmation();
        $emailToken = $emailConfirmation->generateUniqueToken(16);
        
        
        //Store this token in our database table.
        $dao->storeEmailToken($userDetails["user_id"],$emailToken);
        
        //Prepare email mesage paramaters like Subject, Mesasge, From, To and etc.
        $messageDetails = array();
           $messageDetails["message_subject"] = "Please confirm your email address";
          $messageDetails["to_email"] = $userDetails["email"];
          $messageDetails["from_name"] = "ParkYourCar";
          $messageDetails["from_email"] = "fanyuecan@gmail.com";
        //Load up email message from an email template
        $emailMessage = $emailConfirmation->loadEmailEmailMessage();
        $emailMessage = str_replace("{token}", $emailToken, $emailMessage);
        $messageDetails["message_body"] = $emailMessage;
        
        
        //Send out this email message to user
        $emailConfirmation->sendEmailConfirmation($messageDetails);
        
        
    } else{
        $returnValue["status"] = "400";
        $returnValue["message"] = "Could not register user with provided information";
    }
    
    $dao->closeConnection();
    
    echo json_encode($returnValue);
